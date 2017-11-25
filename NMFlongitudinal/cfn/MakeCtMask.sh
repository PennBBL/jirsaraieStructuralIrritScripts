#!/bin/sh

###################################################################################################
##########################         GRMPY - NMF CT Mask Creation          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                  10/24/2017                   ##########################
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

subjects=$(cat /data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Cohort_20171124.csv| cut -d ',' -f2)

#######################################################################
### Defines and Creates the Ouput Paths for CT Raw Images and Masks ###
#######################################################################

OutRaw=/data/joy/BBL/studies/grmpy/processedData/NMF/longitudinal/ctRaw
mkdir -p ${OutRaw}

OutMask=/data/joy/BBL/studies/grmpy/processedData/NMF/longitudinal/ctMasks
mkdir -p ${OutMask}

#######################################################################################
### Make Copies of the ctRaw Images to be processed into ctMasks (from GRMPY & PNC) ###
###  Note This Should Only Select Subjects of Interest, Not the Entire Directories  ###
#######################################################################################

i=0
for s in $subjects; do

   grmpyraw[i]=$(ls /data/joy/BBL/studies/grmpy/processedData/NMF/cross-sectional/ctRaw/*${s}*Cortical*2mm.nii.gz)

   cp ${grmpyraw[i]} ${OutRaw}

   (( i++ ))
   
done

i=0
for s in $subjects; do

   pncraw[i]=$(ls /data/joy/BBL/studies/pnc/n1601_dataFreeze/neuroimaging/t1struct/voxelwiseMaps_antsCt/*${s}*Cortical*2mm.nii.gz)

   cp ${pncraw[i]} ${OutRaw}

   (( i++ ))
   
done

chmod a+x ${OutRaw}/*
chmod a+w ${OutRaw}/*
chmod a+r ${OutRaw}/*

#########################################
### Renames Images To Be More Uniform ###
#########################################

pnc=/data/joy/BBL/studies/grmpy/processedData/NMF/longitudinal/ctRaw/pnc*.nii.gz
cohort=/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Cohort_20171124.csv

for p in $pnc; do

   scanid=$(basename $p | cut -d '_' -f2)
   fname=$(basename $p | cut -d '_' -f3-)
   dname=$(dirname $p)
   
   bblid=$(grep -i ','${scanid}'$' ${cohort}|cut -d',' -f1)
   
   if [[ -n ${bblid} ]] ; then 
   
   id=${bblid}_${scanid}
   
   mv $p ${dname}/${id}_${fname}
   
   fi
   
done

i=0
for s in $subjects; do

   grmpyImages[i]=$(ls /data/joy/BBL/studies/grmpy/processedData/NMF/longitudinal/ctRaw/*x${s}*Cortical*2mm.nii.gz)
   grumpybasename=$(basename ${grmpyImages[i]}| sed s@'x'@'_'@g| cut -d '_' -f1,3,4)
   

   mv ${grmpyImages[i]} ${OutRaw}/${grmpybasename}2mm.nii.gz

   (( i++ ))
   
done

############################################
### Ensures Cohort File is in Same Order ###
############################################

rm /data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Cohort_20171124.csv

subs=/data/joy/BBL/studies/grmpy/processedData/NMF/longitudinal/ctRaw/*

for s in $subs ; do 

basename $s | cut -d '_' -f1,2 | sed s@'_'@','@g >>/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Cohort_20171124.csv

done

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

fslmaths ${OutMask}/coverageMask.nii.gz -thr .9 -bin ${OutMask}/n229_ctMask_thr9_2mm.nii.gz

chmod a+x ${OutMask}/*
chmod a+w ${OutMask}/*
chmod a+r ${OutMask}/*
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
