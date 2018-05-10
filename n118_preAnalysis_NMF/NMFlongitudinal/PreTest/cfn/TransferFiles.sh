#!/bin/sh

###################################################################################################
##########################         GRMPY - Transfer CT Images            ##########################
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

########################################################################
### Create A Zip File that Contains All Smooth the Files to be Moved ###
########################################################################

CfNpath=/data/joy/BBL/studies/grmpy/processedData/NMF/longitudinal/ctSmooth

cd $CfNpath

tar -cvf n229_Smoothed4mm_20171125.tar.gz *

########################################################################################
### Log out of CfN and Into CBICA then Get Writing Permission using the Sudo Command ###
########################################################################################

logout

ssh jirsarar@cbica-cluster.uphs.upenn.edu

sudo -u pncnmf sudosh

#####################################
### Transfer the Smooth CT Images ###
#####################################

CfNpath=/data/joy/BBL/studies/grmpy/processedData/NMF/longitudinal/ctSmooth
CBICApath=/cbica/projects/pncNmf/grmpyNMF/n229_longitudinal/ctSmooth

mkdir -p ${CBICApath}

scp -r rjirsaraie@chead:${CfNpath}/n229_Smoothed4mm_20171125.tar.gz ${CBICApath}/

#########################################################################
### Unpack and Remove Zip File while Extending Permissions to the Lab ###
#########################################################################

tar -xvf ${CBICApath}/n229_Smoothed4mm_20171125.tar.gz

chmod 777 ${CBICApath}/*

rm -rf ${CBICApath}/n229_Smoothed4mm_20171125.tar.gz*

#################################
### Transfer the Subject List ###
#################################

CfNsubs=/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Cohort_20171124.csv
CfNraw=/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_ctRaw_20171124.csv

CBICAsubs=/cbica/projects/pncNmf/grmpyNMF/n229_longitudinal/subjectdata

mkdir -p ${CBICAsubs}

scp -r rjirsaraie@chead:${CfNsubs} ${CBICAsubs}/
scp -r rjirsaraie@chead:${CfNraw} ${CBICAsubs}/

chmod 777 ${CBICAsubs}/*

################################################
### Create a Text File of Smooth Image Paths ###
################################################

subjects=$(cat ${CBICAsubs}/n229_Cohort_20171124.csv | cut -d ',' -f2)

for s in $subjects; do 

ls -d ${CBICApath}/*_${s}_*4mm.nii.gz* >> ${CBICAsubs}/n229_ctSmoothPath.csv

done

#######################################################
### Transfer the CT Mask of all Subjects onto CBICA ###
#######################################################

CfNmask=/data/joy/BBL/studies/grmpy/processedData/NMF/longitudinal/ctMasks/n229_ctMask_thr9_2mm.nii.gz
CBICAmask=/cbica/projects/pncNmf/grmpyNMF/n229_longitudinal/ctMasks

mkdir -p ${CBICAmask}

scp -r rjirsaraie@chead:${CfNmask} ${CBICAmask}/

################################################
### Transfer the Scripts to Run NMF on CBICA ###
################################################

CallScript=/data/joy/BBL/projects/jirsaraieStructuralIrrit/scripts/jirsaraieStructuralIrritScripts/NMFlongitudinal/cbica/Run_NMF_CT.sh
RunScript=/data/joy/BBL/projects/jirsaraieStructuralIrrit/scripts/jirsaraieStructuralIrritScripts/NMFlongitudinal/cbica/submit_script_extractBasesMT.sh
extractBasesMT=/data/joy/BBL/projects/jirsaraieStructuralIrrit/scripts/jirsaraieStructuralIrritScripts/NMFlongitudinal/cbica/extractBasesMT


CBICAscripts=/cbica/projects/pncNmf/grmpyNMF/n229_longitudinal/scripts
mkdir -p ${CBICAscripts}

scp -r rjirsaraie@chead:${CallScript} ${CBICAscripts}/

scp -r rjirsaraie@chead:${RunScript} ${CBICAscripts}/

scp -r rjirsaraie@chead:${CBICAscripts} ${CBICAscripts}/

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

