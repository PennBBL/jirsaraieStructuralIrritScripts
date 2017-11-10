###################################################################################################
##########################          GRMPY - NMF Tyro Figures             ##########################
##########################              Robert Jirsaraie                 ##########################
##########################       rjirsara@pennmedicine.upenn.edu         ##########################
##########################                  11/09/2017                   ##########################
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

NMF <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/NMF/n115_rds_n118_Demo+ARI+QA_20171108_inclusion_T1exclude_ROI_n115_Nmf18Bases_CT_bblids/gam_formula_sageatscank4_ari_total_ManualRating_sex_coefficients.csv")

NMF <- NMF[order(NMF$pval.fdrari_total),] 

##############################################################
##### Adds a Binary Variable of Significance and Non-Sig #####
##############################################################

NMF$col <- cut(NMF$pval.fdrari_total, breaks = c(-Inf, .05, Inf), labels = c("<=.05",">.05"))

library(ggplot2)

###############################################
##### Plots the P-values For Each Network #####
###############################################

pval_plot<-ggplot(NMF, aes (y = NMF$names, x = NMF$pval.fdrari_total, color = col))+ geom_point()

###########################################
##### Save Figure to Output Directory #####
###########################################

setwd("/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/NMF/figures/")

png(filename="pval_plot.png")
plot(pval_plot)
dev.off()

######################################
##### Read Data for Scatterplots #####
######################################

Neuro <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMF/n115_Nmf18Bases_CT_bblids.csv")
Psych <- readRDS("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMF/n118_Demo+ARI+QA_20171108.rds")
Combine <- merge(Neuro, Psych, by=c('bblid', 'scanid'))
attach(Combine)

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

#######################################################################
##### Plot The Relationship While Accounting for Other Covariates #####
#######################################################################

OtherPredictors<-gam(Ct_Nmf18C5~sex+s(ageatscan,k=4)+ManualRating)$residuals

FullRegression<-ggplot(Combine,aes(x=ari_total,y=OtherPredictors)) + geom_smooth()+geom_point() + xlab("Irritability (ARI)") + ylab("Model Residuals From Predicting Network 5") 

###########################################
##### Save Figure to Output Directory #####
###########################################

png(filename="FullRegression")
plot(FullRegression)
dev.off()

########################################################
##### Plot The Relationship Without the Covariates #####
########################################################

ARI_Network5<-ggplot(Combine,aes(x=ari_total,y=Ct_Nmf18C5)) + geom_smooth()+geom_point() + xlab("Irritability (ARI)") + ylab("Model Residuals From Predicting Network 5") 

###########################################
##### Save Figure to Output Directory #####
###########################################

png(filename="ARI_Network5.png")
plot(ARI_Network5)
dev.off()

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

