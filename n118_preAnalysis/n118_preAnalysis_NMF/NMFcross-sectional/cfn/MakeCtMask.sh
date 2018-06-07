#!/bin/sh

###################################################################################################
##########################         GRMPY - NMF CT Mask Creation          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                  10/25/2017                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<Use

This script creates the CT masks needed perform Non-Negative Matrix Factorization (NMF) Analysis.
The script first increases the dimensions of Raw Images to 2mm, then computes the masks that will
remove images with too many 0 or <.1 values using Phil's method.

To run this script it is required to have a qlogin session with 50G of memory. Use the Command Below:

qlogin -l h_vmem=50.5G,s_vmem=50.0G -q qlogin.himem.q

Use
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

##############################################################
### Defines the Subjects that Passed QA & Will be Analyzed ###
##############################################################

subjects=$(cat /data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFcross-sectional/n115_Cohort_20171015.csv | cut -d ',' -f2)

#######################################################################
### Defines and Creates the Ouput Paths for CT Raw Images and Masks ###
#######################################################################

OutRaw=/data/joy/BBL/studies/grmpy/processedData/NMF/cross-sectional/ctRaw
mkdir -p ${OutRaw}

OutMask=/data/joy/BBL/studies/grmpy/processedData/NMF/cross-sectional/ctMasks
mkdir -p ${OutMask}

chmod a+x ${OutRaw}/*
chmod a+w ${OutRaw}/*
chmod a+r ${OutRaw}/*

#####################################################
### Calls the Script that Will Process The Images ###
#####################################################

images=${OutRaw}/*

for i in ${images}; do 
                                                                                                                                                              
   fileName=$(echo $i | cut -d'/' -f11  | cut -d'.' -f1)
   echo "file name is ${fileName}"

	ThresholdImage 3 $i ${OutMask}/${fileName}_mask.nii.gz 0.1 Inf

done

########################################################################
### Average the Masks Together and Binarize/Threshold the Final Mask ###
########################################################################

AverageImages 3 ${OutMask}/coverageMask.nii.gz 0 ${OutMask}/*mask.nii.gz

fslmaths ${OutMask}/coverageMask.nii.gz -thr .9 -bin ${OutMask}/n115_ctMask_thr9_2mm.nii.gz

chmod a+x ${OutMask}/*
chmod a+w ${OutMask}/*
chmod a+r ${OutMask}/*
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
