%In CHAOS challenge, we have received many questions about why we are using
% multiple metrics instead of using just DICE as many papers in literature.
% This mini-experiment is designed to analyze the output of evaluation 
% metrics under different segmentation artifacts. As it can be observed 
% from metric results, each metric has advantages and disadvantages about 
% determining particular cases. We hope that this experiment clarifies some
% questions about usage of multiple metrics.
%
% 09/07/2019 -- Ali Emre Kavur, emrekavur@gmail.com

%% Directories
ground_dir=['.' filesep '..' filesep 'Data_2D' filesep 'Ground'];
seg_dir=['.' filesep '..' filesep 'Data_2D' filesep 'Segmentation'];

%% ======= Image Reading =======
ref=imread([ground_dir filesep 'ref.png']); % Ground truth
seg1=logical(imread([seg_dir filesep 'seg1.png'])); % Segmented image (original)

% Modified images on original segmentation result (seg1.png)
seg2=logical(imread([seg_dir filesep 'seg2.png'])); % Single artificial protrusion added.
seg3=logical(imread([seg_dir filesep 'seg3.png'])); % Liver shifted.
seg4=logical(imread([seg_dir filesep 'seg4.png'])); % Many artificial small notches added.
seg5=logical(imread([seg_dir filesep 'seg5.png'])); % A single point far from liver added.
seg6=logical(imread([seg_dir filesep 'seg6.png'])); % A single hole near the border added.
seg7=logical(imread([seg_dir filesep 'seg7.png'])); % Many small dots inside the liver added.

%% ======= Evaluation =======
% Since this is a demo to compare sensitivities of the metrics, ASSD and 
% MSSD metrics are calculated with pixel unit, not millimeter.

disp('Results:')
[DICE1, AVD1, ASSD1, MSSD1]=CHAOSMetrics(ref,seg1,[]);
disp(['Seg 1 -> DICE:' mat2str(round(DICE1,3)), ' RAVD: ' mat2str(round(AVD1,3)), ' ASSD:' mat2str(round(ASSD1,3)), ' MSSD:' mat2str(round(MSSD1,3))])

[DICE2, AVD2, ASSD2, MSSD2]=CHAOSMetrics(ref,seg2,[]);
disp(['Seg 2 -> DICE:' mat2str(round(DICE2,3)), ' RAVD: ' mat2str(round(AVD2,3)), ' ASSD:' mat2str(round(ASSD2,3)), ' MSSD:' mat2str(round(MSSD2,3))])

[DICE3, AVD3, ASSD3, MSSD3]=CHAOSMetrics(ref,seg3,[]);
disp(['Seg 3 -> DICE:' mat2str(round(DICE3,3)), ' RAVD: ' mat2str(round(AVD3,3)), ' ASSD:' mat2str(round(ASSD3,3)), ' MSSD:' mat2str(round(MSSD3,3))])

[DICE4, AVD4, ASSD4, MSSD4]=CHAOSMetrics(ref,seg4,[]);
disp(['Seg 4 -> DICE:' mat2str(round(DICE4,3)), ' RAVD: ' mat2str(round(AVD4,3)), ' ASSD:' mat2str(round(ASSD4,3)), ' MSSD:' mat2str(round(MSSD4,3))])

[DICE5, AVD5, ASSD5, MSSD5]=CHAOSMetrics(ref,seg5,[]);
disp(['Seg 5 -> DICE:' mat2str(round(DICE5,3)), ' RAVD: ' mat2str(round(AVD5,3)), ' ASSD:' mat2str(round(ASSD5,3)), ' MSSD:' mat2str(round(MSSD5,3))])

[DICE6, AVD6, ASSD6, MSSD6]=CHAOSMetrics(ref,seg6,[]);
disp(['Seg 6 -> DICE:' mat2str(round(DICE6,3)), ' RAVD: ' mat2str(round(AVD6,3)), ' ASSD:' mat2str(round(ASSD6,3)), ' MSSD:' mat2str(round(MSSD6,3))])

[DICE7, AVD7, ASSD7, MSSD7]=CHAOSMetrics(ref,seg7,[]);
disp(['Seg 7 -> DICE:' mat2str(round(DICE7,3)), ' RAVD: ' mat2str(round(AVD7,3)), ' ASSD:' mat2str(round(ASSD7,3)), ' MSSD:' mat2str(round(MSSD7,3))])

%% ======= Plots =======
figure('units','normalized','outerposition',[0 0 1 1])
subplot(3,3,1)
imshow(imread([seg_dir filesep 'segmented_ref.png']))
title('Ground truth in color')

subplot(3,3,2)
imshow(ref)
title('Ground truth in binary')

subplot(3,3,3)
imshow(seg1)
title('Segmented image (original)')
xlabel(['DICE:' mat2str(round(DICE1,3)), ' RAVD:' mat2str(round(AVD1,3)), ' ASSD:' mat2str(round(ASSD1,3)), ' MSSD:' mat2str(round(MSSD1,3))])

subplot(3,3,4)
imshow(seg2)
title('Single artificial protrusion added.')
xlabel(['DICE:' mat2str(round(DICE2,3)), ' RAVD:' mat2str(round(AVD2,3)), ' ASSD:' mat2str(round(ASSD2,3)), ' MSSD:' mat2str(round(MSSD2,3))])

subplot(3,3,5)
imshow(seg3)
title('Liver shifted.')
xlabel(['DICE:' mat2str(round(DICE3,3)), ' RAVD:' mat2str(round(AVD3,3)), ' ASSD:' mat2str(round(ASSD3,3)), ' MSSD:' mat2str(round(MSSD3,3))])

subplot(3,3,6)
imshow(seg4)
title('Many artificial small notches added.')
xlabel(['DICE:' mat2str(round(DICE4,3)), ' RAVD:' mat2str(round(AVD4,3)), ' ASSD:' mat2str(round(ASSD4,3)), ' MSSD:' mat2str(round(MSSD4,3))])

subplot(3,3,7)
imshow(seg5)
title('A single point far from liver added.')
xlabel(['DICE:' mat2str(round(DICE5,3)), ' RAVD:' mat2str(round(AVD5,3)), ' ASSD:' mat2str(round(ASSD5,3)), ' MSSD:' mat2str(round(MSSD5,3))])

subplot(3,3,8)
imshow(seg6)
title('A single hole near the border added.')
xlabel(['DICE:' mat2str(round(DICE6,3)), ' RAVD:' mat2str(round(AVD6,3)), ' ASSD:' mat2str(round(ASSD6,3)), ' MSSD:' mat2str(round(MSSD6,3))])

subplot(3,3,9)
imshow(seg7)
title('Many small dots inside the liver added.')
xlabel(['DICE:' mat2str(round(DICE7,3)), ' RAVD:' mat2str(round(AVD7,3)), ' ASSD:' mat2str(round(ASSD7,3)), ' MSSD:' mat2str(round(MSSD7,3))])

sgtitle('Summary of original and modified segmentations.')