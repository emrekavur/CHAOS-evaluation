
# CHAOS-evaluation
This repo contains evaluation metrics of CHAOS challenge. The evaluation metrics are; 

 1. Sørensen–Dice coefficient (DICE) 
 2. Relative absolute volume difference (RAVD)
 3. Average symmetric surface distance (ASSD)
 4. Maximum symmetric surface distance (MSSD)

For further information about metrics, you may visit [https://chaos.grand-challenge.org/Evaluation/](https://chaos.grand-challenge.org/Evaluation/)

The evaluation code is shared with sample submission. Evaluation of CHAOS is handled via MATLAB language. In addition, [https://www.python.org/](Python) and [https://juliacomputing.com/](Julia) version of the code is prepared.

## Files and Folders
We provide an example evaluation code for sample segmentation submission. Besides, we prepared a mini-experiment to compare metrics (only in MATLAB).

|File or Folder                    |Explanation
|----------------|-------------------------|
|Data_3D |3D data for example evaluation|
|Data_2D |2D data for `evaluate2D_metric_compare.m`     |
|Matlab\ `evaluate3D.m`  |A sample submission evaluation code via MATLAB|
|Matlab\ `evaluate2D_metric_compare.m`  |A mini-experiment to compare metrics via MATLAB|
|Python\ `evaluate3D.py`  |A sample submission evaluation code via Python|
|Julia\ `evaluate3D.py`  |A sample submission evaluation code via Julia|

## MATLAB Version
There are two example code.

1) Evaluation of sample submission (`example3D.m`)

This is an evaluation of a sample submission placed in Data_3D\Segmentation. The segmented and reference data are stored in series of PNG files. They are imported as 3D volumes. DICOM files are used for their header info which is used for transforming voxel values into real-world values. 

The script is ready for use. After downloading repo, just running of `example3D.m` file is enough to perform the evaluation. (`natsort.m` and `natsortfiles.m` files are used to import files in right order. https://uk.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort)

After evaluation the result will be:

    DICE=0.978 RAVD=0.665 ASSD=0.734 MSSD=14

2) Comparison of metrics with different artefacts (`example2D_metric_compare.m`)

*In CHAOS challenge, we have received many questions about why we are using multiple metrics instead of using just a single metric (such as DICE as many papers in literature). This mini-experiment was designed to analyze the output of evaluation metrics under different segmentation artifacts. There are reference data(ref.png), an original sgmentation(seg1.png) and some modified versions of seg1.png with different kind of artefacts(seg2.png ... seg7.png). As it can be observed from metric results, each metric has advantages and disadvantages about determining particular errors in segmented volumes. Also, DICE does not generate significant results in many cases. We hope that this experiment clarifies some questions about usage of multiple metrics.*

## Python Version
We also implemented the code in Python because of high demands from many scientist. `example.py` and `CHAOSMetrics.py` files are Python implementation of `example3D.m` and `CHAOSMetrics.m` files.

### Requirements
The evaluation code written in Python 3.7 an it needs the libraries below. (They are presented with used versions.)

 - numpy (1.16.4)
 - scipy (1.3.0)
 - Pydicom (1.2.2)
 - opencv-python (4.1.0.25)
 - SimpleITK (1.2.0)
 - sklearn2 (2.0.0.13)

You may install them using PyPI with the commands below:

    pip install numpy
    pip install scipy
    pip install pydicom
    pip install opencv-python
    pip install SimpleITK
    pip install sklearn2

> **Important note:** 3D erosion algorithms in *MATLAB* and *scipy.ndimage* library in Python generate slightly different results. Hence, the results of ASSD and MSSD metrics are calculated slightly different.

After downloading repo and installing necessary libraries, you may run `example.py` file to perform the evaluation. The result will be:

    DICE=0.978 RAVD=0.665 ASSD=0.713 MSSD=14
    
# Contact
If you have a question, please consider looking web page of CHAOS:  [https://chaos.grand-challenge.org/News_and_FAQ/](https://chaos.grand-challenge.org/News_and_FAQ/). 

If you cannot find the answer, you may contact with us: emrekavur@gmail.com


