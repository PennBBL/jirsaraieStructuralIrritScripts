###################################################################################################
##########################         GRMPY - Generate Structual RDS        ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/02/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
# Use #

# This script is used in order to combine the non-neuroimaging data into a single dataframe and assign the nominal
# variables as factors. This is needed before performing analysis with the roiWrapperCall.sh.

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#####################################################################
##### Reads in the Demographic, Irritability, and structQA Data #####
#####################################################################

demographics <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_Demographics_20180322.csv")

ARI <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_Irritability_20180322.csv")

structQA <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_manualQA_20180318.csv")

library(car)

structQA$T1exclude <- recode(structQA$rating, "0 = '0'; 1 = '1'; 2 = '1'")
structQA <- structQA[c("bblid","scanid", "rating", "T1exclude")]

###########################################
##### Merges the DataSets Into in One #####
###########################################

dataSub <- merge(demographics, ARI, by=c("bblid"))
dataSub <- merge(dataSub, structQA, by=c("bblid"))
dataSub <- subset( dataSub, select = -c(X,scanid.x) )
colnames(dataSub)[which(colnames(dataSub) == 'scanid.y')] <- 'scanid'
dataSub<-dataSub[,c(1,17,2:16,18:19)]

######################################################
##### Assign the Nominal Variables to be Factors #####
######################################################

dataSub$sex <- as.factor(dataSub$sex)

dataSub$rating <- ordered(dataSub$rating)

dataSub$race <- as.factor(dataSub$race)

#####################################
##### Write the Output RDS File #####
#####################################

saveRDS(dataSub, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_Demo+ARI+QA_20180322.rds")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
