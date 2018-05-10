###################################################################################################
##########################         GRMPY - Generate Structual RDS        ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/16/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
# Use #

# This script version was create in order to perform analysis using repeated measures the GRMPY subjects
# while also including their data from the first time point, which was the PNC Study. 

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#########################################################################
##### Reads in all the Demographic, Irritability, and structQA Data #####
#########################################################################

TP2 <- readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_Demo+ARI+QA_20180322.rds")
TP1 <- readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n143_ARI+DEMO+QA_20180216.rds")

##################################################################################
##### Refines Datasets in Order to Get Varaibles of Interests In One Dataset #####
##################################################################################

TP1 <- TP1[c("bblid","scanid", "ageAtScan1", "IrritabilitySum", "IrritabilityZ", "averageManualRating","t1Exclude")]
TP1 <- rbind(TP1, c(99964, 9964, NA, NA, NA, NA, NA))
colnames(TP1) <- c("bblid","TP1scanid", "TP1ageAtScan1", "TP1IrritabilitySum", "TP1IrritabilityZ", "TP1averageManualRating","TP1t1Exclude")

Combined <- merge(TP1, TP2, by=c("bblid"))

########################################################
##### Computes the Change Of Age from PNC to GRMPY #####
########################################################

Combined$DeltaAge<-Combined$ageatscan-Combined$TP1ageAtScan1

###################################################################################
##### Computes the Average QA Ratings For Both DataFrames & Updates T1exclude #####
###################################################################################

Combined$TP1t1Exclude<-as.numeric(Combined$TP1t1Exclude)
Combined$TP1averageManualRating<-as.numeric(Combined$TP1averageManualRating)
Combined$rating<-as.numeric(Combined$rating)
Combined$rating<-Combined$rating-1

Combined$AvgManRating<-(Combined$TP1averageManualRating+Combined$rating)/2

Combined$EXCLUDE <- Combined$TP1t1Exclude + Combined$T1exclude

Combined$EXCLUDE[Combined$DeltaEXCLUDE != 2] <- 0
Combined$EXCLUDE[Combined$DeltaEXCLUDE == 2] <- 1

###########################################################################
##### Make Z-Scores of Timepoint 2 and Delta Variable of Irritability #####
###########################################################################

Combined$ARIzTP2<-scale(Combined$ari_total, center= TRUE, scale = TRUE)

Combined$DeltaIrritabilityZ <- Combined$ARIzTP2 - Combined$TP1IrritabilityZ

####################################################################
##### Add Baseline CT values in this RDS FILE to be Covariates #####
####################################################################

BaselineCT<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n143_jlfAntsCTIntersectionCT_20180216.csv")
missCT <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAntsCTIntersectionCt_20170331.csv")
missCT<-missCT[ which(missCT$bblid=='99964'), ]
BaselineCT$X<-NULL
BaselineCT <- rbind(BaselineCT,missCT)
names(BaselineCT)[names(BaselineCT) == 'scanid'] <- 'TP1scanid'

Combined <- merge(Combined, BaselineCT, by=c("bblid","TP1scanid"))

###############################################################
##### Rename Columns by Adding Prefix of TP1 for Analysis #####
###############################################################

jlfregions<-grep("jlf", names(Combined), value=TRUE)

for (n in jlfregions){
    
    
    colnames(Combined)[which(names(Combined) == n)] <- print(paste("TP1_",n,sep=''))
}

#####################################
##### Write the Output RDS File #####
#####################################

saveRDS(Combined, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_Demo+ARI+QA+tp1CT_20180411.rds")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#grmpy$bblid[duplicated(grmpy$bblid)]
#grmpy[which(grmpy$bblid=='130687'),]
