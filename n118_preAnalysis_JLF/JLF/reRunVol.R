###################################################################################################
##########################          GRMPY - Reruns JLF Volume            ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/13/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#### Use ####

# This script was created to add an additional predictor of Whole Brain Volume in the Regression Model.

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#################################
##### Define the Volume CSV #####
#################################

Vol <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_jlfAntsCTIntersectionVol_20170911.csv")

##############################################################################################
##### Makes a Varaible of the Whole Total Brain Volume and Another Copy that is Centered #####
#####             These New Variables will be Inputed into a New RDS File                #####
##############################################################################################

Vol$TotalBrainVolume <- rowSums(Vol[3:131])

Vol$cTotalBrainVolume<-scale(Vol$TotalBrainVolume, center = TRUE, scale = FALSE)

VariablesInterest <- c("bblid", "scanid", "TotalBrainVolume", "cTotalBrainVolume")

TBV <- Vol[VariablesInterest]

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
dataSub <- merge(dataSub, TBV, by=c("bblid","scanid"))

######################################################
##### Assign the Nominal Variables to be Factors #####
######################################################

dataSub$sex <- as.factor(dataSub$sex)

dataSub$ManualRating <- ordered(dataSub$ManualRating)

dataSub$race <- as.factor(dataSub$race)

#############################################################
##### Write the Output RDS File with Total Brain Volume #####
#############################################################

saveRDS(dataSub, "/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_Demo+ARI+QA+TBV_20171113.rds")

##################################################################
##### In BASH: Defines the variables for the roiWrapper Call #####
##################################################################

subjDataName="/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_Demo+ARI+QA+TBV_20171113.rds"

OutDirRoot="/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/JLF"  

inclusionName="T1exclude"

subjID="bblid,scanid"

covsFormula="~s(ageatscan,k=4)+ari_total+ManualRating+cTotalBrainVolume"

pAdjustMethod="fdr"

ncores=5

residualMap=FALSE

input="/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_jlfAntsCTIntersectionVol_20170911.csv"

########################################################################
##### Calls the " gamROI.R" Rscript that will Perform the Analysis #####
########################################################################

Rscript /data/joy/BBL/projects/jirsaraieStructuralIrrit/scripts/jirsaraieStructuralIrritScripts/JLF/gamROI.R  -c $subjDataName -o $OutDirRoot -p $input -i $inclusionName -u $subjID -f $covsFormula -a $pAdjustMethod -r $residualMap -n 5

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
