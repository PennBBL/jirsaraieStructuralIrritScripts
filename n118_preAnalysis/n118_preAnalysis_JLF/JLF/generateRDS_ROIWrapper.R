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

demographics <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_Demographics_20171101.csv")

ARI <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_Irritability_20171101.csv")

structQA <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_structQAFlags_20171103.csv")
structQA <- structQA[c("bblid","scanid", "ManualRating", "T1exclude")]

###########################################
##### Merges the DataSets Into in One #####
###########################################

dataSub <- merge(demographics, ARI, by=c("bblid","scanid"))
dataSub <- merge(dataSub, structQA, by=c("bblid","scanid"))


######################################################
##### Assign the Nominal Variables to be Factors #####
######################################################

dataSub$sex <- as.factor(dataSub$sex)

dataSub$ManualRating <- ordered(dataSub$ManualRating)

dataSub$race <- as.factor(dataSub$race)

#####################################
##### Write the Output RDS File #####
#####################################

saveRDS(dataSub, "/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_Demo+ARI+QA_20171103.rds")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
