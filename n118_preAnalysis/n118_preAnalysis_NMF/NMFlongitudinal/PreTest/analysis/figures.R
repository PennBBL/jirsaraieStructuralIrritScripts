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

changeCT<-read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/NMFlongitudinal/n229_rds_n229_Demo+ARI+QA_20171125_inclusion_T1exclude_ROI_n229_Nmf18Bases_CT_bblids/gamm4_formula_sageatscank4_ARItotal_ManualRating_sex_random_1bblid_coefficients.csv")
changeCT <- changeCT[order(changeCT$pval.fdrARItotal),] 

################################################################################
##### Creates New Data Frame Containing Only Signficance with Irritability #####
################################################################################

SigCT <- changeCT[ which(changeCT$pval.fdrARItotal<=.05),]

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
SigCT$names[SigCT$names == "Ct_Nmf18C14"] <- "14"
SigCT$names[SigCT$names == "Ct_Nmf18C18"] <- "18"
SigCT$names[SigCT$names == "Ct_Nmf18C4"] <- "4"
SigCT$names[SigCT$names == "Ct_Nmf18C8"] <- "8"

###############################################
##### Plots the P-values For Each Network #####
###############################################

CTpval_plot<-ggplot(SigCT, aes(x = names, y = pval.fdrARItotal)) + geom_bar(stat = 'identity') + theme_bw() + xlab("NMF Network") + ylab("Adjusted P-Value") + ggtitle("Brain Networks Associated With Irritability")

####################################################
##### Save P-Value Figures to Output Directory #####
####################################################

setwd("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/NMFlongitudinal/figures")

png(filename="CTpval_plot.png")
plot(CTpval_plot)
dev.off()

#############################################
##### Read Data Needed for Scatterplots #####
#############################################

RDS <- readRDS("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Demo+ARI+QA_20171125.rds")

CT <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Nmf18Bases_CT_bblids.csv")
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

Ct_Nmf18C10<-gam(Ct_Nmf18C10~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

Ct_Nmf18C11<-gam(Ct_Nmf18C11~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

Ct_Nmf18C12<-gam(Ct_Nmf18C12~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

Ct_Nmf18C14<-gam(Ct_Nmf18C14~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

Ct_Nmf18C17<-gam(Ct_Nmf18C17~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

Ct_Nmf18C18<-gam(Ct_Nmf18C18~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

Ct_Nmf18C4<-gam(Ct_Nmf18C4~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

Ct_Nmf18C7<-gam(Ct_Nmf18C7~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

Ct_Nmf18C8<-gam(Ct_Nmf18C8~s(ageatscan,k=4)+ARItotal+ManualRating+sex, data=CTData)

#############################################################
##### Plot The Relationship & Defines the Plots To Save #####
#############################################################

Ct_Nmf18C10<-visreg(Ct_Nmf18C10, "ARItotal")

Ct_Nmf18C11<-visreg(Ct_Nmf18C11, "ARItotal")

Ct_Nmf18C12<-visreg(Ct_Nmf18C12, "ARItotal")

Ct_Nmf18C14<-visreg(Ct_Nmf18C14, "ARItotal")

Ct_Nmf18C17<-visreg(Ct_Nmf18C17, "ARItotal")

Ct_Nmf18C18<-visreg(Ct_Nmf18C18, "ARItotal")

Ct_Nmf18C4<-visreg(Ct_Nmf18C4, "ARItotal")

Ct_Nmf18C7<-visreg(Ct_Nmf18C7, "ARItotal")

Ct_Nmf18C8<-visreg(Ct_Nmf18C8, "ARItotal")

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

png(filename="Ct_Nmf18C14.png")
plot(Ct_Nmf18C14)
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

png(filename="Ct_Nmf18C47.png")
plot(Ct_Nmf18C7)
dev.off()

png(filename="Ct_Nmf18C8.png")
plot(Ct_Nmf18C8)
dev.off()

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
