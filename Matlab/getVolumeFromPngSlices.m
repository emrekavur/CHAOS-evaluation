function [V]=getVolumeFromPngSlices(Directory)

if ~isfolder([Directory filesep])
    disp('Folder path is wrong!')
    V=[];
    return
end

files=dir([Directory filesep '*.png']);
if size(files,1)<1
    disp('Error! No PNG file found.')
    V=[];
    return
else
    listt=ones(size(files),'logical');
    for u=1:size(files,1)
        if strfind( files(u).name,'._')
        listt(u)=0;
        end
    end
    files=files(listt); 
    N = natsortfiles({files.name});
    [files.name]=N{:};    
    tmp=imread([files(1).folder filesep files(1).name]);
    if size(tmp,3)>1
       disp('Warning. The PNG file must be grayscale. Only red channel is processing.') 
       disp(Directory)
    end
    V=zeros(size(tmp,1),size(tmp,2),size(files,1),'logical');
    
    for i=1:size(files,1)
        tmp=imread([files(i).folder filesep files(i).name]);
        
        if size(tmp,3)==1
            V(:,:,i)=logical(tmp);
        else
            V(:,:,i)=logical(tmp(:,:,1));
        end
    end
end