###################################################################################################
##########################      GRMPY - TP1 Cohort Collection            ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 01/31/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#### Use ####

# This script was created to gather the selected subjects from TP1 and put their screening data into a single
# csv while also finding the missing values for each column and row

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

############################################################################
##### Identify Subjects of Interest & Exclude Extra Subjects/Variables #####
############################################################################

WHOLE <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n1601_goassess_112_itemwise_vars_20161214.csv")

TP1 <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n144_jlfAntsCTIntersectionCT_20180216.csv")

Subjects <- WHOLE[(WHOLE$bblid %in% TP1$bblid),]

Subjects <- Subjects[c("bblid","scanid","dep004","man007","odd001","odd006")]

###################################################################
##### Identifies the Number of Missing Values for Each Column #####
###################################################################

 for (Var in names(Subjects)) {
     missing <- sum(is.na(Subjects[,Var]))
     if (missing > 0) {
         print(c(Var,missing))
     }
 }

################################################################
##### Identifies the Number of Missing Values for Each Row #####
################################################################

Subjects[!complete.cases(Subjects),]

#########################################################################
##### Take the Sum of Each Row for Compite Variable of Irritability #####
#########################################################################

Subjects$IrritabilitySum<-apply(Subjects[,3:6],1,sum)

################################################################
##### Save the Clean Output File with Subjects of Interest #####
################################################################

write.csv(Subjects, paste0("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n143_Irritability_20180216.csv"), row.names=F)

#################################################################################
##### Read in the Demographic Variables To Include In RDS File for Analysis #####
#################################################################################

DEMO <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n1601_demographics_go1_20161212.csv")
DEMO <- DEMO[(DEMO$bblid %in% Subjects$bblid),]

DEMO$ageAtClinicalAssess1<-DEMO$ageAtClinicalAssess1/12
DEMO$ageAtCnb1<-DEMO$ageAtCnb1/12
DEMO$ageAtScan1<-DEMO$ageAtScan1/12

###############################################################################
##### Read in the Quality Assurance File and Select Variables of Interest #####
###############################################################################

QA<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n1601_t1QaData_20170306.csv")

QA <- QA[(QA$bblid %in% Subjects$bblid),]
QA <- QA[c("bblid","scanid","t1Exclude","averageManualRating")]

########################################################################
##### Merge the Data and Compute Z scores for Irritability Measure #####
########################################################################

rds <- merge(Subjects,QA,by=c("bblid","scanid"))
rds <- merge(rds,DEMO,by=c("bblid","scanid"))
rds$IrritabilityZ<-scale(rds$IrritabilitySum, center=TRUE, scale=TRUE)

rds$sex<-as.factor(rds$sex)
rds$IrritabilitySum<-as.numeric(rds$IrritabilitySum)
rds$IrritabilityZ<-as.numeric(rds$IrritabilityZ)

rds$t1Exclude[rds$t1Exclude == "1"] <- "9999"
rds$t1Exclude[rds$t1Exclude == "0"] <- "1"
rds$t1Exclude[rds$t1Exclude == "9999"] <- "0"

hist(rds$IrritabilityZ,col="black")

missing<-c(1:19)
missing[1:19] <- NA

rds <- rbind(rds, c(99964, 9964,missing))

saveRDS(rds, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n144_ARI+DEMO+QA_20180216.rds")

#############################################################
##### Selects only the CT data for Subjects of Interest #####
#############################################################

CT<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n1601_jlfAntsCTIntersectionCT_20170331.csv")

CT <- CT[(CT$bblid %in% Subjects$bblid),]
missCT <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAntsCTIntersectionCt_20170331.csv")
missCT<-missCT[ which(missCT$bblid=='99964'), ]
BaselineCT$X<-NULL
CT <- rbind(CT,missCT)

write.csv(CT, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n144_jlfAntsCTIntersectionCT_20180216.csv")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
