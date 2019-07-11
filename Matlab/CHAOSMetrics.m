function [DICE, AVD, ASSD, MSSD]=CHAOSMetrics(Vref,Vseg,dicomDir)

if ~isequal(size(Vref),size(Vseg))
    disp(['Dimension mismatch! Size Vref:' mat2str(size(Vref)) ' Size Vresult:' mat2str(size(Vseg))]);
    DICE=0; % Worst score if any problem occurs
    AVD=100; % Worst score if any problem occurs
    [ASSD, MSSD]=deal(dist(size(Vref),0)); % Highest possible distance
    % (worst score) if any problem occurs.
    return
end

%%% Metric 1: Dice Similarity
DICE=dice(Vref,Vseg);

%%% Metric 2: Absolute Volume Difference
refVolume=sum(Vref(:));
segVolume=sum(Vseg(:));
AVD=(abs(refVolume-segVolume)/refVolume)*100;

%%% Metric 3: Average Symmetric Surface Distance
%%% Metric 4: Maximum Symmetric Surface Distance

% Extract border voxels
FVRef=Vref & ~imerode(Vref,strel('sphere',1));
[x1,y1,z1]=ind2sub(size(FVRef),find(FVRef==1));
BorderVoxelsRef=[x1,y1,z1];

FVResult=Vseg & ~imerode(Vseg,strel('sphere',1));
[x2,y2,z2]=ind2sub(size(FVResult),find(FVResult==1));
BorderVoxelsResult=[x2,y2,z2];

% Convert Index to Real world points. In CHAOS challenge the
% orientation of the slices is determined by order of image names NOT by
% position tags in DICOM files. If you need to use real orientation data
% mentioned in DICOM, you may consider to use
% TransformIndexToPhysicalPoint() function from SimpleITK library.

if ~isempty(BorderVoxelsRef) && ~isempty(BorderVoxelsResult)
    if ~isempty(dicomDir)
        BorderVoxelsRefReal=transformToRealCoordinates(BorderVoxelsRef,dicomDir);
        BorderVoxelsResultReal=transformToRealCoordinates(BorderVoxelsResult,dicomDir);
    else
        BorderVoxelsRefReal=BorderVoxelsRef;
        BorderVoxelsResultReal=BorderVoxelsResult;
    end
    
    % Distance between border voxels
    MdlKDTResult = KDTreeSearcher(BorderVoxelsResultReal);
    [~,distIndex1] = knnsearch(MdlKDTResult,BorderVoxelsRefReal);
    distIndex1=distIndex1';
    
    MdlKDTRef = KDTreeSearcher(BorderVoxelsRefReal);
    [~,distIndex2] = knnsearch(MdlKDTRef,BorderVoxelsResultReal);
    distIndex2=distIndex2';
    
    % Metrics
    ASSD=(sum(distIndex1)+sum(distIndex2))/(size(distIndex1,2)+size(distIndex2,2));
    MSSD=max([distIndex1,distIndex2]);
else
    [ASSD, MSSD]=deal(dist(size(Vref),0)); % Highest possible distance if any problem occurs
end


