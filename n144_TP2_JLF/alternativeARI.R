###################################################################################################
##########################        GRMPY - Summary Scores - Imaging       ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 03/10/20178                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
# Use #

# This script was created to refine and create summary scores for grmpy data that was gathered from
# RedCap. 

#scp ~/Desktop/ARI_Data/ImagingScalesSTAISTA_DATA_2018-04-11_2139.csv rjirsaraie@chead:/home/rjirsaraie/grmpyData/

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#####################################################################
##### Selects only the Subjects of Interest --- IMAGING SECTION #####
#####################################################################

currentDate<-Sys.Date()

grumpy2<-read.csv("/home/rjirsaraie/grmpyData/ImagingScalesSTAISTA_DATA_2018-04-11_2139.csv")
grumpy2<-grumpy2[ which(grumpy2$bbl_protocol %in% "GRMPY") , ] 
grumpy2[grumpy2 ==-9999] <- NA 
subs<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_jlfAntsCTIntersectionCT_20180320.csv", header=TRUE)
grumpy2<- grumpy2[(grumpy2$bblid %in% subs$bblid),]

########################################################
##### Split Data Frames into Before and After Scan #####
########################################################

grumpy2<-grumpy2[order(grumpy2$bblid),]
grumpy2<-grumpy2[complete.cases(grumpy2[,c(grep('staxi2_ca_[0-9]', names(grumpy2), value=T))]),]

#STAXI-2 C/A#

STAXI2CA_SummaryScores<-grumpy2[,c('bblid'), drop=FALSE]
staxi2<-grumpy2[complete.cases(grumpy2[,c(grep('staxi2_ca_[0-9]', names(grumpy2), value=T))]),]
staxi2<-grumpy2[,c(grep('staxi2_ca_[0-9]', names(grumpy2), value=T))]

STAXI2CA_SummaryScores$stateanger_total<-rowSums(staxi2[,c('staxi2_ca_1','staxi2_ca_2','staxi2_ca_3','staxi2_ca_4','staxi2_ca_5','staxi2_ca_6','staxi2_ca_7','staxi2_ca_8','staxi2_ca_9','staxi2_ca_10')])
STAXI2CA_SummaryScores$stateanger_feelings<-rowSums(staxi2[,c('staxi2_ca_1','staxi2_ca_2','staxi2_ca_3','staxi2_ca_8','staxi2_ca_10')])
STAXI2CA_SummaryScores$stateanger_expression<-rowSums(staxi2[,c('staxi2_ca_4','staxi2_ca_5','staxi2_ca_6','staxi2_ca_7','staxi2_ca_9')])
STAXI2CA_SummaryScores$traitanger_total<-rowSums(staxi2[,c('staxi2_ca_11','staxi2_ca_12','staxi2_ca_13','staxi2_ca_14','staxi2_ca_15','staxi2_ca_16','staxi2_ca_17','staxi2_ca_18','staxi2_ca_19','staxi2_ca_20')])
STAXI2CA_SummaryScores$traitanger_temperament<-rowSums(staxi2[,c('staxi2_ca_11','staxi2_ca_12','staxi2_ca_13','staxi2_ca_16','staxi2_ca_19')])
STAXI2CA_SummaryScores$traitanger_reaction<-rowSums(staxi2[,c('staxi2_ca_14','staxi2_ca_15','staxi2_ca_17','staxi2_ca_18','staxi2_ca_20')])
STAXI2CA_SummaryScores$angerexpression_out<-rowSums(staxi2[,c('staxi2_ca_21','staxi2_ca_24','staxi2_ca_27','staxi2_ca_31','staxi2_ca_34')])
STAXI2CA_SummaryScores$angerexpression_in<-rowSums(staxi2[,c('staxi2_ca_22','staxi2_ca_25','staxi2_ca_28','staxi2_ca_33','staxi2_ca_35')])
STAXI2CA_SummaryScores$angercontrol<-rowSums(staxi2[,c('staxi2_ca_23','staxi2_ca_26','staxi2_ca_29','staxi2_ca_30','staxi2_ca_32')])
STAXI2CA_SummaryScores$staxi2_naflag<-ifelse(complete.cases(staxi2),0,1) 

STAXI2CA_SummaryScores<-STAXI2CA_SummaryScores[c("bblid","traitanger_total")]
STAXI2CA_SummaryScores$traitanger_log<-log(STAXI2CA_SummaryScores$traitanger_total+1)

#############################################################################
##### Combine the Variables of Interest with the RDS files for Analysis #####
#############################################################################

TP2<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_Demo+ARI+QA_20180322.rds")
TP2<-merge(TP2,STAXI2CA_SummaryScores, by=c("bblid"))
saveRDS(TP2, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n141_Demo+STAXI+QA_20180322.rds")

TP1<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n143_ARI+DEMO+QA_20180216.rds")
TP1<-merge(TP1,STAXI2CA_SummaryScores, by=c("bblid"))
saveRDS(TP1, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n140_DEMO+STAXI+QA_20180330.rds")

Delta<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_Demo+ARI+QA+tp1CT_20180411.rds")
Delta<-merge(Delta,STAXI2CA_SummaryScores, by=c("bblid"))
saveRDS(Delta, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n141_Demo+STAXI+QA_20180322.rds")

Rate<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Rate_JLF/n144_Demo+ARI+QA_20180401.rds")
Rate<-merge(Rate,STAXI2CA_SummaryScores, by=c("bblid"))
saveRDS(Rate, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Rate_JLF/n141_Demo+STAXI+QA_20180322.rds")

Repeat<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n288_Repeat_JLF/n288_Demo+ARI+QA_20180305.rds")
Repeat<-merge(Repeat,STAXI2CA_SummaryScores, by=c("bblid"))
saveRDS(Repeat, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n288_Repeat_JLF/n282_Demo+STAXI+QA_20180322.rds")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
