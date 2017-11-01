#!/bin/sh

###################################################################################################
##########################         GRMPY - NMF CT Mask Creation          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                  10/19/2017                   ##########################
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

subjects=$(cat /data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMF/n115_Cohort_20171015.csv| cut -d ',' -f1)
OutRaw=/data/joy/BBL/studies/grmpy/processedData/NMF/ctRaw
OutMask=/data/joy/BBL/studies/grmpy/processedData/NMF/ctMask
mkdir -p ${OutRaw}
mkdir -p ${OutMask}

########################################################
### Make Copies of the Raw CT Images To Be Processed ###
########################################################

i=0
for s in $subjects; do

   imgList[i]=$(ls /data/joy/BBL/studies/grmpy/processedData/structural/struct_pipeline_20170716/${s}/*/antsCT/*_CorticalThicknessNormalizedToTemplate.nii.gz)

   cp ${imgList[i]} ${OutRaw}

   (( i++ ))

done

###################################################################
### Applys a Tranformation to Raw Images to Increase Dimensions ###
###################################################################

copies=/data/joy/BBL/studies/grmpy/processedData/NMF/ctRaw/*CorticalThicknessNormalizedToTemplate.nii.gz

i=0
for c in $copies; do 

   bblid=$(echo ${c}|cut -d'_' -f1); 
   datexscanid=$(echo ${c}|cut -d'_' -f2); 

   output[i]=${bblid}_${datexscanid}_CorticalThicknessNormalizedToTemplate_2mm.nii.gz

   antsApplyTransforms -e 3 -d 3 -i ${c} -r /data/joy/BBL/studies/pnc/template/pnc_template_brain_2mm.nii.gz -o ${output[i]}

   (( i++ ))

done

#########################################################
### Removes the Copied Images if Output is Successful ###
#########################################################

for o in ${output[@]}; do

   if [[ -f ${o} ]] ; then 

      file=$(echo ${o}| sed s@_2mm@''@g)

      rm $file

      else 

      echo "Output For This Subject Was Not Successful"

   fi

done

##################################################
### Locates the Subjects Image To Be Processed ###
##################################################

i=0
for s in $subjects; do

   List[i]=$(ls /data/joy/BBL/studies/grmpy/processedData/NMF/ctRaw/*${s}*_2mm.nii.gz)

   (( i++ ))

done

#####################################################
### Calls the Script that Will Process The Images ###
#####################################################

for i in ${List[@]}; do 
                                                                                                                                                              
   fileName=$(echo $i | cut -d'/' -f10  | cut -d'.' -f1)
   echo "file name is ${fileName}"

	ThresholdImage 3 $i ${OutMask}/${fileName}_mask.nii.gz 0.1 Inf

done

########################################################################
### Average the Masks Together and Binarize/Threshold the Final Mask ###
########################################################################

AverageImages 3 ${OutMask}/coverageMask.nii.gz 0 ${OutMask}/*mask.nii.gz

fslmaths ${OutMask}/coverageMask.nii.gz -thr .9 -bin ${OutMask}/n115_ctMask_thr9_2mm.nii.gz

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
