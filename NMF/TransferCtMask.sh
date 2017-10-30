#!/bin/sh

###################################################################################################
##########################         GRMPY - Transfer CT Masks             ##########################
##########################              Robert Jirsaraie                 ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                  10/25/2017                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<Use

These commands were used to transfer the CT masks to CBICA where they will be inputed into the NMF analysis.

In order to log into CBICA you must connect through a VPN; the PennMedicine Network will not work.

Use
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#################################################################
### Create A Zip File that Contains All the Files to be Moved ###
#################################################################

CfNpath=/data/joy/BBL/studies/grmpy/processedData/NMF/ctSmooth/

tar -cvf ${CfNpath}/n115_MaskSmoothed4mm_20171025.tar.gz ${CfNpath}/*

########################################################################################
### Log out of CfN and Into CBICA then Get Writing Permission using the Sudo Command ###
########################################################################################

logout

ssh jirsarar@cbica-cluster.uphs.upenn.edu

sudo -u pncnmf sudosh

#####################################
### Transfer the Smooth CT Images ###
#####################################

CfNpath=/data/joy/BBL/studies/grmpy/processedData/NMF/ctSmooth/
CBICApath=/cbica/projects/pncNmf/grmpyNMF/n115_structCT/ctSmooth/

mkdir -p ${CBICApath}

scp -r rjirsaraie@chead:${CfNpath}/n115_MaskSmoothed4mm_20171025.tar.gz ${CBICApath}/

#########################################################################
### Unpack and Remove Zip File while Extending Permissions to the Lab ###
#########################################################################

tar -xvf ${CBICApath}/n115_MaskSmoothed4mm_20171025.tar.gz

chmod 777 ${CBICApath}/*

rm -rf ${CBICApath}/n115_MaskSmoothed4mm_20171025.tar.gz*

#################################
### Transfer the Subject List ###
#################################

CfNsubs=/data/joy/BBL/projects/grmpyProcessing2017/NMF
CBICAsubs=/cbica/projects/pncNmf/grmpyNMF/n115_structCT/subjectdata/

mkdir -p ${CBICAsubs}

scp -r rjirsaraie@chead:${CfNsubs}/n115_Cohort_20171015.csv ${CBICAsubs}/

chmod 777 ${CBICAsubs}/*

################################################
### Create a Text File of Smooth Image Paths ###
################################################

subjects=$(cat ${CBICAsubs}/n115_Cohort_20171015.csv| cut -d ',' -f1)

for s in $subjects; do 

ls -d ${CBICApath}/${s}_*smoothed4mm.nii.gz* >> ${CBICAsubs}/n115_ctSmoothPath.csv

done

#######################################################
### Transfer the CT Mask of all Subjects onto CBICA ###
#######################################################

CfNmask=/data/joy/BBL/studies/grmpy/processedData/NMF/ctMask/
CBICAmask=/cbica/projects/pncNmf/grmpyNMF/n115_structCT/ctMask/

mkdir -p ${CBICAmask}

scp -r rjirsaraie@chead:${CfNmask}/n115_ctMask_thr9_2mm.nii.gz ${CBICAmask}/

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

