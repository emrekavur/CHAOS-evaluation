% This function transforms index points to the real world coordinates
% according to DICOM Patient-Based Coordinate System
% The source: DICOM PS3.3 2019a - Information Object Definitions page 499
% Written by Ali Emre Kavur, emrekavur@gmail.com
% Last update: 07/03/2019
% If you use this code, please cite to the paper:...

function [realPoints]=transformToRealCoordinates(indexPoints,dicomDir)

files=dir([dicomDir filesep '*.dcm']);
info1=dicominfo([files(1).folder filesep files(1).name]);
N=size(files,1);
infoN=dicominfo([files(N).folder filesep files(N).name]);

T1=info1.ImagePositionPatient;
TN=infoN.ImagePositionPatient;
X=info1.ImageOrientationPatient(1:3);
Y=info1.ImageOrientationPatient(4:6);
deltaI=info1.PixelSpacing(1);
deltaJ=info1.PixelSpacing(2);

M=[X(1)*deltaI,Y(1)*deltaJ,(T1(1)-TN(1))/(1-N),T1(1);...
    X(2)*deltaI,Y(2)*deltaJ,(T1(2)-TN(2))/(1-N),T1(2);...
    X(3)*deltaI,Y(3)*deltaJ,(T1(3)-TN(3))/(1-N),T1(3);...
    0,0,0,1];

realPoints=zeros(size(indexPoints,1),size(indexPoints,2));
for i=1:size(indexPoints,1)
    P=M*[indexPoints(i,1),indexPoints(i,2),indexPoints(i,3),1]';
    realPoints(i,:)=P(1:3)';
end
