#!/bin/sh

###################################################################################################
##########################           GRMPY - Run NMF Analysis            ##########################
##########################              Robert Jirsaraie                 ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                  10/25/2017                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<Use

This script runs the NMF script for a range of components to find the optimal component number of network
you should select. Processing these images requires alot of memory and computer power so you to use qlogin
and request high memory.

Use
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#######################################
### Signs in to High Memory Q Login ###
#######################################

#qlogin -l h_vmem=50.5G,s_vmem=50.0G -q qlogin.himem.q

#####################################################################
### Defines Paths to Input - Do Not put '/' at the end of Outpath ###
#####################################################################

csvFile=/cbica/projects/pncNmf/grmpyNMF/n281_Final_201804/subjectdata/n140_ctSmooth_test_2018.csv

mask=/cbica/projects/pncNmf/grmpyNMF/n281_Final_201804/ctMask/n281_ctMask_thr9_2mm.nii.gz

outputDirectory=/cbica/projects/pncNmf/grmpyNMF/n281_Final_201804/output/n140_test

###########################################
### Defines Number of Components to Run ###
###########################################

numComponents="2 4 6 8 10 12 14 16 18 20 22 24 26 28 30"

for i in $numComponents
do
        echo ""

        echo "Component number is $i"
        
############################################
### Calls the Script to Perform Analysis ###
############################################ 

qsub /cbica/projects/pncNmf/grmpyNMF/n281_Final_201804/scripts/submit_script_extractBasesMT.sh $csvFile $i $outputDirectory $mask

echo qsub $csvFile $i $outputDirectory $mask >> ${outputDirectory}/commands.txt

sleep 1s
done
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

csvFile=/cbica/projects/pncNmf/grmpyNMF/n281_Final_201804/subjectdata/n141_ctSmooth_train_2018.csv

mask=/cbica/projects/pncNmf/grmpyNMF/n281_Final_201804/ctMask/n281_ctMask_thr9_2mm.nii.gz

outputDirectory=/cbica/projects/pncNmf/grmpyNMF/n281_Final_201804/output/n141_train/

###########################################
### Defines Number of Components to Run ###
###########################################

numComponents="2 4 6 8 10 12 14 16 18 20 22 24 26 28 30"

for i in $numComponents
do
        echo ""

        echo "Component number is $i"
        
############################################
### Calls the Script to Perform Analysis ###
############################################ 

qsub /cbica/projects/pncNmf/grmpyNMF/n281_Final_201804/scripts/submit_script_extractBasesMT.sh $csvFile $i $outputDirectory $mask

echo qsub $csvFile $i $outputDirectory $mask >> ${outputDirectory}/commands.txt

sleep 1s
done
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
