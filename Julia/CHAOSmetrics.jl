using FileIO
using Images
using ImageMagick
using NearestNeighbors
using LocalFilters
using DICOM


function evaluate(Vref,Vseg,dicom_dir)
    dice=DICE(Vref,Vseg)
    ravd=RAVD(Vref,Vseg)
    assd, mssd=SSD(Vref,Vseg,dicom_dir)
    return dice, ravd, assd ,mssd
end

function DICE(Vref,Vseg)
    dice=2*sum((Vref .& Vseg))/(sum(Vref) + sum(Vseg))
    return round(dice,digits=3)
end

function RAVD(Vref,Vseg)
    ravd=(abs(sum(Vref) - sum(Vseg))/sum(Vref))*100
    return round(ravd,digits=3)
end

function SSD(Vref,Vseg,dicom_dir)
    B=Bool.(zeros(3,3,3))
    B[2,2,1]=1
    B[2,2,3]=1
    B[2,1,2]=1
    B[2,2,2]=1
    B[2,3,2]=1
    B[1,2,2]=1
    B[3,2,2]=1

    ref_border=Vref .⊻  LocalFilters.erode(Vref,B)
    ref_border_voxels=map_to_vector(ref_border)
    ref_border_voxels_real=transformToRealCoordinates(ref_border_voxels,dicom_dir)

    seg_border=Vseg .⊻  LocalFilters.erode(Vseg,B)
    seg_border_voxels=map_to_vector(seg_border)
    seg_border_voxels_real=transformToRealCoordinates(seg_border_voxels,dicom_dir)

    kdtree_seg = KDTree(Float64.(seg_border_voxels_real))
    idxs_ref_to_seg, dists_ref_to_seg = knn(kdtree_seg, Float64.(ref_border_voxels_real), 1, true)

    kdtree_ref = KDTree(Float64.(ref_border_voxels_real))
    idxs_seg_to_ref, dists_seg_to_ref = knn(kdtree_ref, Float64.(seg_border_voxels_real), 1, true)

    assd=(sum(dists_seg_to_ref) + sum(dists_ref_to_seg))/(length(dists_seg_to_ref)+length(dists_ref_to_seg))
    mssd=maximum([dists_ref_to_seg; dists_seg_to_ref])
    return round(assd[1],digits=3), round(mssd[1],digits=3)

end

function transformToRealCoordinates(indexPoints,dicom_dir)

    # This function transforms index points to the real world coordinates
    # according to DICOM Patient-Based Coordinate System
    # The source: DICOM PS3.3 2019a - Information Object Definitions page 499.
    #
    # In CHAOS challenge the orientation of the slices is determined by order
    # of image names NOT by position tags in DICOM files. If you need to use
    # real orientation data mentioned in DICOM, you may consider to use
    # TransformIndexToPhysicalPoint() function from SimpleITK library.

    dicom_file_list=filter(x->occursin(".dcm",x), readdir(dicom_dir))
    dicom_file_list=sort(dicom_file_list)

    #Read position and orientation info from first image
    ds_first = dcm_parse(dicom_dir * dicom_file_list[1])
    img_pos_first=ds_first[(0x0020,0x0032)]
    img_or=ds_first[(0x0020,0x0037)]
    pix_space=ds_first[(0x0028,0x0030)]

    # #Read position info from first image from last image
    ds_last = dcm_parse(dicom_dir * dicom_file_list[end])
    img_pos_last=ds_last[(0x0020,0x0032)]
    #
    T1=img_pos_first
    TN=img_pos_last
    X=img_or[1:3]
    Y=img_or[4:end]
    deltaI=pix_space[1]
    deltaJ=pix_space[2]
    N=length(dicom_file_list)
    M=[[X[1]*deltaI,Y[1]*deltaJ,(T1[1]-TN[1])/(1-N),T1[1]]; [X[2]*deltaI,Y[2]*deltaJ,(T1[2]-TN[2])/(1-N),T1[2]]; [X[3]*deltaI,Y[3]*deltaJ,(T1[3]-TN[3])/(1-N),T1[3]]; [0,0,0,1]]
    M=transpose(reshape(M,4,:))
    #
    realPoints=[]
    for i=1:size(indexPoints,2)
        P=[indexPoints[1,i],indexPoints[2,i],indexPoints[3,i],1]
        R=M * P
        if i==1
            realPoints=R[1:3]
        else
            append!(realPoints,R[1:3])
        end
    end
    return reshape(realPoints, 3,:)
end

function map_to_vector(border_img)
    ind=findall(border_img)
    border_voxels=[]
    for i = 1:length(ind)
        vec=[ind[i][1];ind[i][2];ind[i][3]]
        if i==1
            border_voxels=vec
        else
            append!(border_voxels,vec)
        end
    end
    return reshape(Float64.(border_voxels), 3,:)
end

function png_series_reader(dir)
    files=filter(x->occursin(".png",x), readdir(dir))
    files=sort(files)
    V=[]
    for (i,f) in enumerate(files)
        im=Bool.(load(dir * f))
        if i==1
            V=im
        else
            V=cat(V, im,dims=3)
        end
    end
    return V
end
