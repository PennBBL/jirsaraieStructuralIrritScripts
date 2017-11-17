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

grmpyARI <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeate/n118_Irritability_20171101.csv")

grmpyDemo <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeate/n118_Demographics_20171101.csv")
pncDemo <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeate/n1601_demographics_go1_20161212.csv")

grmpyQA <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeate/n118_structQAFlags_20171103.csv")
pncQA <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeate/n1601_t1QaData_20170306.csv")

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

pncQA <- rbind(pncQA, c(99964, 9964, 2.000, 0))

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

###########################################################
##### Combines the datasets into a Master Spreadsheet #####
###########################################################

QA <- rbind(pncQA, grmpyQA)
Demo <-rbind(pncDemo,grmpyDemo)

Final <- merge(QA, Demo, by=c("bblid","scanid"))
Final <- merge(Final, grmpyARI, by=c("bblid"))

Final$scanid.y<-NULL

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

saveRDS(Final, "/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeate/n236_Demo+ARI+QA_20171117.rds")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
