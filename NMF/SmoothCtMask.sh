#!/bin/sh

###################################################################################################
##########################        GRMPY - Smooth CT Mask for NMF         ##########################
##########################              Robert Jirsaraie                 ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                  10/19/2017                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<Use

This script smoothes by 4mm the CT images that will be used perform NMF analysis.

NOTE From Toni: fslmaths requires smoothing parameters in sigma
FWHM = 2.355*sigma
4mm FWHM = 1.70 sigma

Use
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

##############################################################
### Defines the Subjects that Passed QA & Will be Analyzed ###
##############################################################

subjects=$(cat /data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMF/n115_Cohort_20171015.csv| cut -d ',' -f1)
outdir=/data/joy/BBL/studies/grmpy/processedData/NMF/ctSmooth
mkdir -p ${outdir}

####################################################################
### Identifies the Input Images then Applies FSLmaths on line 45 ###
####################################################################

i=0
for s in $subjects; do

MaskList[i]=$(ls -d /data/joy/BBL/studies/grmpy/processedData/NMF/ctMask/${s}_*2mm_mask.nii.gz)

basename=$(echo ${MaskList[i]} | cut -d '/' -f10| cut -d '.' -f1| sed s@_2mm@''@g)

sig=1.70

fslmaths ${MaskList[i]} -s ${sig} ${outdir}/${basename}_smoothed4mm.nii.gz

(( i++ ))

done

#############################################################
### Create a Text File of the Input Images For Future Use ###
#############################################################

echo ${MaskList[@]} >> /data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMF/n115_ctMasks_20171025.csv

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
