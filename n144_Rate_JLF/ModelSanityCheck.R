###################################################################################################
##########################           GRMPY - Run ROI Wrapper             ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/18/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

# Script to Run All Four Longitudinal Models and Show Output For Each Model of the Right Inferior Occipital Gyrus

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

###########################################
##### Load the libraries For Analysis #####
###########################################

suppressMessages(require(optparse))
suppressMessages(require(ggplot2))
suppressMessages(require(base))
suppressMessages(require(reshape2))
suppressMessages(require(nlme))
suppressMessages(require(lme4))
suppressMessages(require(gamm4))
suppressMessages(require(stats))
suppressMessages(require(knitr))
suppressMessages(require(mgcv))
suppressMessages(require(plyr))
suppressMessages(require(oro.nifti))
suppressMessages(require(parallel))
suppressMessages(require(optparse))
suppressMessages(require(fslr))
suppressMessages(require(voxel))

#############################################
##### Read in Data and Apply Exclusions #####
#############################################

CSV<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n288_Repeat_JLF/n288_jlfAntsCTIntersectionCT_20180310.csv")
RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n288_Repeat_JLF/n288_Demo+ARI+QA_20180305.rds")
Repeat<-merge(RDS,CSV, by=c("bblid","scanid"))
Repeat<-Repeat[which(Repeat$T1exclude=='1'),]

CSV<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n288_Repeat_JLF/n288_jlfAntsCTIntersectionCT_20180310.csv")
RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n288_Repeat_JLF/n288_Demo+ARI+QA_20180305.rds")
Interact<-merge(RDS,CSV, by=c("bblid","scanid"))
Interact<-Interact[which(Interact$T1exclude=='1'),]

CSV<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Rate_JLF/n144_jlfAntsCTIntersectionCTannualRate_20180404.csv")
RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Rate_JLF/n144_Demo+ARI+QA_20180401.rds")
Rate<-merge(RDS,CSV, by=c("bblid","scanid"))
Rate<-Rate[which(Rate$DeltaEXCLUDE=='1'),]

CSV<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_jlfAntsCTIntersectionCTdiff_20180403.csv")
RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_Demo+ARI+QA+tp1CT_20180411.rds")
Delta<-merge(RDS,CSV, by=c("bblid","scanid"))
Delta<-Delta[which(Delta$T1exclude=='1'),]

###############################################
##### Define the Models For Each Analysis #####
###############################################

rateMOD<-gam(Rate$mprage_jlf_ct_R_IOG~Rate$TP1ageAtScan1+Rate$ari_log+Rate$DeltaManualRating+Rate$sex, method="REML")

deltaMOD<-gam(Delta$mprage_jlf_ct_R_IOG~Delta$DeltaAge+Delta$ari_log+Delta$AvgManRating+Delta$sex+Delta$TP1ageAtScan1+Delta$TP1_mprage_jlf_ct_R_IOG, method="REML")

InteractMOD<-gamm4(formula =mprage_jlf_ct_R_IOG~ageatscan*Zari_log+rating+sex, random=as.formula(~(1|bblid)), data=Interact, REML=T)$gam

RepeatMOD<-gamm4(formula =mprage_jlf_ct_R_IOG~ageatscan+Zari_log+rating+sex, random=as.formula(~(1|bblid)), data=Repeat, REML=T)$gam

###########################
##### Test Each Model #####
###########################

summary(rateMOD)

summary(deltaMOD)

summary(InteractMOD)

summary(RepeatMOD)

###############################
##### Pasted Output Below #####
###############################
