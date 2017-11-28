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

changeCT<-read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/NMFcross-sectional/n115_rds_n118_Demo+ARI+QA_20171103_inclusion_T1exclude_ROI_n115_Nmf18Bases_CT_bblids/gam_formula_sageatscank4_ari_total_ManualRating_sex_coefficients.csv")
changeCT <- changeCT[order(changeCT$pval.fdrari_total),] 

################################################################################
##### Creates New Data Frame Containing Only Signficance with Irritability #####
################################################################################

SigCT <- changeCT[ which(changeCT$pval.fdrari_total<=.05),]

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

########################################
##### Change Values for the X axis #####
########################################

SigCT$names<-as.character(SigCT$names)

SigCT$names[SigCT$names == "Ct_Nmf18C11"] <- "11"
SigCT$names[SigCT$names == "Ct_Nmf18C12"] <- "12"
SigCT$names[SigCT$names == "Ct_Nmf18C10"] <- "10"
SigCT$names[SigCT$names == "Ct_Nmf18C17"] <- "17"
SigCT$names[SigCT$names == "Ct_Nmf18C7"] <- "7"
#SigCT$names[SigCT$names == "Ct_Nmf18C14"] <- "14" ### Was Signficnat for Longitudinal, but not for cross-sectional
SigCT$names[SigCT$names == "Ct_Nmf18C18"] <- "18"
SigCT$names[SigCT$names == "Ct_Nmf18C4"] <- "4"
SigCT$names[SigCT$names == "Ct_Nmf18C8"] <- "8"
SigCT$names[SigCT$names == "Ct_Nmf18C9"] <- "9"
SigCT$names[SigCT$names == "Ct_Nmf18C5"] <- "5"
SigCT$names[SigCT$names == "Ct_Nmf18C16"] <- "16"
SigCT$names[SigCT$names == "Ct_Nmf18C6"] <- "6"
SigCT$names[SigCT$names == "Ct_Nmf18C13"] <- "13"
SigCT$names[SigCT$names == "Ct_Nmf18C15"] <- "15"

###############################################
##### Plots the P-values For Each Network #####
###############################################

CTpval_plot<-ggplot(SigCT, aes(x = names, y = pval.fdrari_total)) + geom_bar(stat = 'identity') + theme_bw() + xlab("NMF Network") + ylab("Adjusted P-Value") + ggtitle("Brain Networks Associated With Irritability")

####################################################
##### Save P-Value Figures to Output Directory #####
####################################################

setwd("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/NMFcross-sectional/figures")

png(filename="CTpval_plot.png")
plot(CTpval_plot)
dev.off()

#############################################
##### Read Data Needed for Scatterplots #####
#############################################

RDS <- readRDS("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFcross-sectional/n118_Demo+ARI+QA_20171103.rds")

CT <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFcross-sectional/n115_Nmf18Bases_CT_bblids.csv")
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

Ct_Nmf18C10<-gam(Ct_Nmf18C10~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C11<-gam(Ct_Nmf18C11~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C12<-gam(Ct_Nmf18C12~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C17<-gam(Ct_Nmf18C17~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C18<-gam(Ct_Nmf18C18~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C4<-gam(Ct_Nmf18C4~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C7<-gam(Ct_Nmf18C7~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C8<-gam(Ct_Nmf18C8~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C9<-gam(Ct_Nmf18C9~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C5<-gam(Ct_Nmf18C5~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C16<-gam(Ct_Nmf18C16~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C6<-gam(Ct_Nmf18C6~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C13<-gam(Ct_Nmf18C13~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

Ct_Nmf18C15<-gam(Ct_Nmf18C15~s(ageatscan,k=4)+ari_total+ManualRating+sex, data=CTData)

#############################################################
##### Plot The Relationship & Defines the Plots To Save #####
#############################################################

Ct_Nmf18C10<-visreg(Ct_Nmf18C10, "ari_total")

Ct_Nmf18C11<-visreg(Ct_Nmf18C11, "ari_total")

Ct_Nmf18C12<-visreg(Ct_Nmf18C12, "ari_total")

Ct_Nmf18C17<-visreg(Ct_Nmf18C17, "ari_total")

Ct_Nmf18C18<-visreg(Ct_Nmf18C18, "ari_total")

Ct_Nmf18C4<-visreg(Ct_Nmf18C4, "ari_total")

Ct_Nmf18C7<-visreg(Ct_Nmf18C7, "ari_total")

Ct_Nmf18C8<-visreg(Ct_Nmf18C8, "ari_total")

Ct_Nmf18C9<-visreg(Ct_Nmf18C9, "ari_total")

Ct_Nmf18C5<-visreg(Ct_Nmf18C5, "ari_total")

Ct_Nmf18C16<-visreg(Ct_Nmf18C16, "ari_total")

Ct_Nmf18C6<-visreg(Ct_Nmf18C6, "ari_total")

Ct_Nmf18C13<-visreg(Ct_Nmf18C13, "ari_total")

Ct_Nmf18C15<-visreg(Ct_Nmf18C15, "ari_total")

############################################
##### Save Figures to Output Directory #####
############################################

png(filename="Ct_Nmf18C10.png")
plot(Ct_Nmf18C10)
dev.off()

png(filename="Ct_Nmf18C11.png")
plot(Ct_Nmf18C11)
dev.off()

png(filename="Ct_Nmf18C12.png")
plot(Ct_Nmf18C12)
dev.off()

png(filename="Ct_Nmf18C17.png")
plot(Ct_Nmf18C17)
dev.off()

png(filename="Ct_Nmf18C18.png")
plot(Ct_Nmf18C18)
dev.off()

png(filename="Ct_Nmf18C4.png")
plot(Ct_Nmf18C4)
dev.off()

png(filename="Ct_Nmf18C7.png")
plot(Ct_Nmf18C7)
dev.off()

png(filename="Ct_Nmf18C8.png")
plot(Ct_Nmf18C8)
dev.off()

png(filename="Ct_Nmf18C9.png")
plot(Ct_Nmf18C9)
dev.off()

png(filename="Ct_Nmf18C5.png")
plot(Ct_Nmf18C5)
dev.off()

png(filename="Ct_Nmf18C16.png")
plot(Ct_Nmf18C16)
dev.off()

png(filename="Ct_Nmf18C6.png")
plot(Ct_Nmf18C6)
dev.off()


png(filename="Ct_Nmf18C13.png")
plot(Ct_Nmf18C13)
dev.off()

png(filename="Ct_Nmf18C15.png")
plot(Ct_Nmf18C15)
dev.off()

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
