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
TP1<-rbind(TP1, c(99964,10105,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA))
setdiff(TP2$bblid,TP1$bblid)

TP2<-TP2[order(TP2$bblid),]
TP1<-TP1[order(TP1$bblid),]

###################################################################
##### Refines Datasets in Order to Get Varaibles of Interests #####
###################################################################

TP2 <- TP2[c("bblid","scanid","ageatscan","sex","race","education","handedness","rating","T1exclude","ari_total")]

TP1 <- TP1[c("bblid","scanid","ageAtScan1","sex","race","edu1","handednessv2","averageManualRating",
"t1Exclude","IrritabilityZ")]

TP2$Zari_total<-scale(TP2$ari_total, center = TRUE, scale = TRUE)
TP2$ari_total<-NULL

TP1$sex<-as.numeric(TP1$sex)
TP1$sex<-(TP1$sex-1)

TP1$handednessv2<-(TP1$handednessv2-1)
TP1$race[TP1$race == "1"] <- "0"
TP1$race[TP1$race == "2"] <- "1"

######################################################################
##### Rescales the PNC data to be Consistent with the GRMPY Data #####
######################################################################

colnames(TP1)[3] <- "ageatscan"
colnames(TP1)[6] <-"education"
colnames(TP1)[7] <- "handedness"
colnames(TP1)[8] <- "rating"
colnames(TP1)[9] <- "T1exclude"
colnames(TP1)[10] <- "Zari_total"

TP2$TP2_ZariTotal<-TP2$Zari_total
TP1$TP2_ZariTotal<-TP2$Zari_total

######################################################################################
##### Rescales the PNC data to be Consistent with the GRMPY Data & Bind Datasets #####
######################################################################################

Final<-rbind(TP1,TP2)
Final<-Final[order(Final$bblid),]

Final$Zari_log<-log(Final$Zari_total+4)
Final$TP2_ZariLog<-log(Final$TP2_ZariTotal+4)

#########################################
##### Defines the Nominal Variables #####
#########################################

Final$handedness <- as.factor(Final$handedness)
Final$T1exclude <- as.factor(Final$T1exclude)
Final$sex <- as.factor(Final$sex)
Final$race <- as.factor(Final$race)
Final$rating <- as.factor(Final$rating)

Final$education <- as.numeric(Final$education)
Final$ageatscan <- as.numeric(Final$ageatscan)
Final$Zari_total <- as.numeric(Final$Zari_total)
Final$TP2_ZariTotal <- as.numeric(Final$TP2_ZariTotal)
Final$Zari_log <- as.numeric(Final$Zari_log)
Final$TP2_ZariLog <- as.numeric(Final$TP2_ZariLog)

#########################################
##### Rbind CSV of Neuroimaging Data ####
#########################################

oneCT<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n143_jlfAntsCTIntersectionCT_20180216.csv")
oneCT$X<-NULL

twoCT<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_jlfAntsCTIntersectionCT_20180320.csv")
missCT <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAntsCTIntersectionCt_20170331.csv")
missCT<-missCT[ which(missCT$bblid=='99964'), ]
twoCT <- rbind(twoCT,missCT)

FINALct <- rbind(twoCT,oneCT)
FINALct <-FINALct[order(FINALct$bblid),]

##################################
##### Write the Output Files #####
##################################

saveRDS(Final, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n288_Repeat_JLF/n288_Demo+ARI+QA_20180305.rds")

write.csv(FINALct, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n288_Repeat_JLF/n288_jlfAntsCTIntersectionCT_20180310.csv")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
