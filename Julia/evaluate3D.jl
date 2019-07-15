# -*- coding: utf-8 -*-
# This example shows the evaluation process used in CHAOS challenge.
# A sample data is shared with original DICOM images, its ground truth
# and an example of segmentation result.
#
# Ground truth volume is used as reference to evaluate sample segmentation.
#
# DICOM folder is used to transform voxel values into real world coordinates.
# Hence, ASSD and MSSD metrics are calculated with millimeter.
#
# 14/07/2019
# @author: Ali Emre Kavur, emrekavur@gmail.com

include("CHAOSmetrics.jl")

# ======= Directories =======
current_dir=pwd()
ground_dir_rel = "../Data_3D/Ground/"
seg_dir_rel = "../Data_3D/Segmentation/"
dicom_dir_rel = "../Data_3D/DICOM_anon/"

ground_dir=abspath(current_dir, ground_dir_rel)
seg_dir=abspath(current_dir, seg_dir_rel)
dicom_dir=abspath(current_dir, dicom_dir_rel)

# ======= Volume Reading =======
Vref=png_series_reader(ground_dir)
Vseg=png_series_reader(seg_dir)
println("Volumes imported.")
# ======= Evaluation =======
println("Calculating...")
dice, ravd, assd ,mssd=evaluate(Vref,Vseg,dicom_dir)
println("DICE=$dice RAVD=$ravd ASSD=$assd MSSD=$mssd")
