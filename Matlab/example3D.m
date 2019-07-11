% This example shows the evaluation process used in CHAOS challenge. A
% sample data is shared with original DICOM images, its ground truth and an
% example of segmentation result.
%
% Ground truth volume is used as reference to evaluate sample segmentation.
%
% DICOM folder is used to transform voxel values into real world
% coordinates. Hence, ASSD and MSSD metrics are calculated with millimeter.
%
% 09/07/2019 -- Ali Emre Kavur, emrekavur@gmail.com

%% Directories
ground_dir=['.' filesep '..' filesep 'Data_3D' filesep 'Ground'];
seg_dir=['.' filesep '..' filesep 'Data_3D' filesep 'Segmentation'];
dicom_dir=['.' filesep '..' filesep 'Data_3D' filesep 'DICOM_anon'];

%% ======= Volume Reading =======
[Vref]=getVolumeFromPngSlices(ground_dir);
[Vseg]=getVolumeFromPngSlices(seg_dir);

%% ======= Evaluation =======
[DICE, RAVD, ASSD, MSSD]=CHAOSMetrics(Vref,Vseg,dicom_dir);
disp(['DICE=' mat2str(DICE,3) ' RAVD=' mat2str(RAVD,3)...
    ' ASSD=' mat2str(ASSD,3) ' MSSD=' mat2str(MSSD,3)])