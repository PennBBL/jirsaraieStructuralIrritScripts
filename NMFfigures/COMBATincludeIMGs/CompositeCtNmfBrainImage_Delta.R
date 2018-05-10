#Create nifti images: 1) with all NMF components on one brain and 2) with only FDR-significant NMF components

###############################
### LOAD DATA AND LIBRARIES ###
###############################
data.NMF <- readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n141_Demo+ARI+QA_20180322.rds")

#Load libraries
library(mgcv)
library(ANTsR)

#####################################################
### CREATE IMAGE WITH ALL COMPONENTS ON ONE BRAIN ###
#####################################################

#Load the 4d set of merged component images (NOTE: each component needs to be merged in the correct order 1-26 for this script to work).

img<-antsImageRead('/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/MaskedByNeighborThresh300_WarpedToMNI/n281_24NmfComponentsMerged.nii.gz',4)

#Load the prior grey matter mask (warped to MNI space and binarized)
mask<-antsImageRead('/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/mask/prior_grey_thr01_2mm_MNI_bin.nii.gz',3)

#Create matrix: rows are components, columns are voxels
seed.mat<-timeseries2matrix(img, mask)

#Find, for each voxel, which component has highest loading
whichCompStr <-apply(seed.mat,2,which.max) # however, some of those are all zeros, need to remove
foo <-apply(seed.mat,2,sum) 		   # this is sum of loadings across column; if 0, entire column is 0
whichCompStr[which(foo==0)]<-0 		   # assign 0-columns to 0

#Write image with all components on one brain (every voxel is assigned to one component)
newImg<-antsImageClone(mask)               # prep for writing out image
newImg[mask==1]<-as.matrix(whichCompStr)   # put assigned values back in the image
antsImageWrite(newImg,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/finalFigures/CtNmf24Components.nii.gz")

##################################################################
### CREATE IMAGE WITH ONLY SIGNIFICANT COMPONENTS ON ONE BRAIN ###
##################################################################
#Assign values for components where gestational age is FDR-significantly associated with volume (see GamAnalyses.R for which components survive fdr correction) 
#Create a vector that assigns each voxel a component number
tvalMap<-antsImageClone(mask)
tvalVoxVector<-whichCompStr

output<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/n137_Delta_NMF/n137_rds_n137_Demo+ARI+QA+TP1CT_COMBAT_20180401_inclusion_DeltaEXCLUDE_ROI_n137_Nmf24BasesCT_COMBAT_Delta/gam_formula_DeltaAge_TP1ageAtScan1_ari_log_DeltaManualRating_sex_tp1CT_coefficients.csv")
output<-output[order(output$pval.fdrari_log),]
output<-output[,c("names","tval.ari_log","pval.ari_log","pval.fdrari_log"),]

#Assign all components that did not survive fdr correction to 0
tvalVoxVector[which(tvalVoxVector %in% c(7,17,8,21,5,12,10,23,3,19,24,16,14,2,4,6))]<-0

#OPTIONAL: For the remaining components, assign the respective t-value for that component
#However, this makes it difficult to make custom color palettes in Caret later.

tvalVoxVector[which(tvalVoxVector==1)] <- -5.10
tvalVoxVector[which(tvalVoxVector==11)] <- -5.12
tvalVoxVector[which(tvalVoxVector==9)] <- -3.53
tvalVoxVector[which(tvalVoxVector==13)] <- -2.78
tvalVoxVector[which(tvalVoxVector==15)] <- -2.84
tvalVoxVector[which(tvalVoxVector==18)] <- -2.73
tvalVoxVector[which(tvalVoxVector==20)] <- -2.76
tvalVoxVector[which(tvalVoxVector==22)] <- -2.67


#Essentially this is a replaced image with 0s and surviving component numbers or t-values
tvalMap[mask==1]<-as.matrix(tvalVoxVector)
antsImageWrite(tvalMap,"/home/rjirsaraie/NMFfigures/n137_CtNmfSigComponents_COMBAT_t300_Delta.nii.gz")
