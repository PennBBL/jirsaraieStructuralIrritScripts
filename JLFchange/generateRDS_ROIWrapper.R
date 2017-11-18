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

grmpyARI <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n118_Irritability_20171101.csv")

grmpyDemo <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n118_Demographics_20171101.csv")
pncDemo <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n1601_demographics_go1_20161212.csv")

grmpyQA <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n118_structQAFlags_20171103.csv")
pncQA <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n1601_t1QaData_20170306.csv")

###################################################################
##### Refines Datasets in Order to Get Varaibles of Interests #####
###################################################################

grmpyQA <- grmpyQA[c("bblid","scanid", "ManualRating", "T1exclude")]

pncQA <- pncQA[c("bblid", "scanid", "averageManualRating", "t1Exclude")]

pncDemo <- pncDemo[c("bblid", "scanid", "ageAtScan1", "sex", "race")]

################################################################################
##### Refines PNC Data to Get Subjects of Interest & Adds Any Missing Data #####
################################################################################

pncDemo <- pncDemo[(pncDemo$bblid %in% grmpyDemo$bblid),]

pncQA <- pncQA[(pncQA$bblid %in% grmpyQA$bblid),]

setdiff(grmpyQA$bblid,pncQA$bblid)

pncQA <- rbind(pncQA, c(99964, 9964, 1.33333, 0))

######################################################################
##### Rescales the PNC data to be Consistent with the GRMPY Data #####
######################################################################

pncDemo$ageAtScan1 <- pncDemo$ageAtScan1 / 12

pncDemo$sex <- grmpyDemo$sex

pncDemo$race <- grmpyDemo$race

pncQA$t1Exclude[pncQA$t1Exclude == 0] <- 3
pncQA$t1Exclude[pncQA$t1Exclude == 1] <- 0
pncQA$t1Exclude[pncQA$t1Exclude == 3] <- 1

##########################################################################
##### Renames the PNC Variables to Be Consistent with the GRMPY Data #####
##########################################################################

colnames(pncDemo)[3] <- "ageatscan"
colnames(pncQA)[3] <- "ManualRating"
colnames(pncQA)[4] <- "T1exclude"
colnames(grmpyARI)[3] <- "ARIavg"
colnames(grmpyARI)[4] <- "ARItotal"

########################################################
##### Computes the Change Of Age from PNC to GRMPY #####
########################################################

grmpyDemo <- grmpyDemo[order(grmpyDemo$bblid),]
pncDemo <- pncDemo[order(pncDemo$bblid),]

grmpyDemo$ageatscan<-grmpyDemo$ageatscan-pncDemo$ageatscan

###################################################################################
##### Computes the Average QA Ratings For Both DataFrames & Updates T1exclude #####
###################################################################################

grmpyQA <- grmpyQA[order(grmpyQA$bblid),]
pncQA <- pncQA[order(pncQA$bblid),]

grmpyQA$ManualRating<-(pncQA$ManualRating+grmpyQA$ManualRating)/2

grmpyQA$T1exclude<-grmpyQA$T1exclude+pncQA$T1exclude

grmpyQA$T1exclude<-if(grmpyQA$T1exclude > 0){
    grmpyQA$T1exclude-1
}

#########################################################################
##### Combines only the GRUMPY DataFrames into a Master Spreadsheet #####
#########################################################################

Final <- merge(grmpyQA, grmpyDemo, by=c("bblid","scanid"))

Final <- merge(Final, grmpyARI, by=c("bblid","scanid"))

#########################################
##### Defines the Nominal Variables #####
#########################################

Final$ManualRating <- ordered(Final$ManualRating)

Final$T1exclude <- as.factor(Final$T1exclude)

Final$sex <- as.factor(Final$sex)

Final$race <- as.factor(Final$race)

#####################################
##### Write the Output RDS File #####
#####################################

saveRDS(Final, "/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFchange/n118_Demo+ARI+QA_20171117.rds")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
