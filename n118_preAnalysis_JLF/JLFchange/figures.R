###################################################################################################
##########################       GRMPY - JLF Significant Figures         ##########################
##########################              Robert Jirsaraie                 ##########################
##########################       rjirsara@pennmedicine.upenn.edu         ##########################
##########################                  11/19/2017                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#### Use ####

#These figures were made to vizualize the signficant results from the first NMF Analysis.

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

##########################################################
##### Reads in the Data and Sort By Adjusted P-Value #####
##########################################################

changeCT<-read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/JLFchange/n112_rds_n118_Demo+ARI+QA_20171117_inclusion_T1exclude_ROI_n118_jlfAntsCTIntersectionCTdiff_20171117/gam_formula_sageatscank4_ARItotal_ManualRating_sex_coefficients.csv")
changeCT <- changeCT[order(changeCT$pval.fdrARItotal),] 

changeVOL<-read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/JLFchange/n112_rds_n118_Demo+ARI+QA_20171117_inclusion_T1exclude_ROI_n118_jlfAntsCTIntersectionVOLdiff_20171117/gam_formula_sageatscank4_ARItotal_ManualRating_sex_coefficients.csv")
changeVOL <- changeVOL[order(changeVOL$pval.fdrARItotal),] 

changeGMD<-read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/JLFchange/n79_rds_n118_Demo+ARI+QA_20171117_inclusion_T1exclude_ROI_n81_jlfAtroposIntersectionGMDdiff_20171118/gam_formula_sageatscank4_ARItotal_ManualRating_sex_coefficients.csv")
changeGMD <- changeGMD[order(changeGMD$pval.fdrARItotal),] 

################################################################################
##### Creates New Data Frame Containing Only Signficance with Irritability #####
################################################################################

SigCT <- changeCT[ which(changeCT$pval.fdrARItotal<=.05),]

SigVOL <- changeVOL[ which(changeVOL$pval.fdrARItotal<=.05),]

SigGMD <- changeGMD[ which(changeGMD$pval.fdrARItotal<=.05),]

##################################
##### Load Required Packages #####
##################################

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

###############################################
##### Plots the P-values For Each Network #####
###############################################

CTpval_plot<-ggplot(SigCT, aes(x = names, y = pval.fdrARItotal)) + geom_bar(stat = 'identity') + theme_bw() + xlab("JLF Region") + ylab("Adjusted P-Value") + ggtitle("Brain Regions Associated With Irritability")

VOLpval_plot<-ggplot(SigVOL, aes(x = names, y = pval.fdrARItotal)) + geom_bar(stat = 'identity') + theme_bw() + xlab("JLF Region") + ylab("Adjusted P-Value") + ggtitle("Brain Regions Associated With Irritability")

GMDpval_plot<-ggplot(SigGMD, aes(x = names, y = pval.fdrARItotal)) + geom_bar(stat = 'identity') + theme_bw() + xlab("JLF Region") + ylab("Adjusted P-Value") + ggtitle("Brain Regions Associated With Irritability")

####################################################
##### Save P-Value Figures to Output Directory #####
####################################################

setwd("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/JLFchange/figures")

png(filename="CTpval_plot.png")
plot(CTpval_plot)
dev.off()

png(filename="VOLpval_plot.png")
plot(VOLpval_plot)
dev.off()

png(filename="GMDpval_plot.png")
plot(GMDpval_plot)
dev.off()

#############################################
##### Read Data Needed for Scatterplots #####
#############################################

RDS <- readRDS("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFchange/n118_Demo+ARI+QA_20171117.rds")

CT <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFchange/n118_jlfAntsCTIntersectionCTdiff_20171117.csv")
CTData <- merge(CT, RDS, by=c('bblid', 'scanid'))
attach(CTData)

######################################################
##### Loads the Packages Needed For Scatterplots #####
######################################################

install.packages("visreg")
library(visreg)
install.packages('mgcv')
library('mgcv')

################################################################
##### Defines the Whole Models That You Would Like To Plot #####
################################################################

IOG<-gam(mprage_jlf_ct_L_IOG~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

PCu<-gam(mprage_jlf_ct_R_PCu~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

OFuG<-gam(mprage_jlf_ct_L_OFuG~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

SPL<-gam(mprage_jlf_ct_L_SPL~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

#############################################################
##### Plot The Relationship & Defines the Plots To Save #####
#############################################################

ARI_IOG<-visreg(IOG, "ARItotal")

ARI_PCu<-visreg(PCu, "ARItotal")
Age_PCu<-visreg(PCu, "ageatscan")

ARI_OFuG<-visreg(OFuG, "ARItotal")

ARI_SPL<-visreg(SPL, "ARItotal")

############################################
##### Save Figures to Output Directory #####
############################################

png(filename="ARI_IOG.png")
plot(ARI_IOG)
dev.off()

png(filename="ARI_PCu.png")
plot(ARI_PCu)
dev.off()

png(filename="Age_PCu.png")
plot(Age_PCu)
dev.off()

png(filename="ARI_OFuG.png")
plot(ARI_OFuG)
dev.off()

png(filename="ARI_SPL.png")
plot(ARI_SPL)
dev.off()

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
