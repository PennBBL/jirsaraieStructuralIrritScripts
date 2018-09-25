###################################################################################################
##########################           GRMPY - Eligability Check           ##########################
##########################              Robert Jirsaraie                 ##########################
##########################             rjirsaraie@upenn.edu              ##########################
##########################                  09/24/2018                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

############################
### Read in Spreadsheets ###
############################

IrrElig<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/grmpyIrritElig_20150909.csv")
ControlElig<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/grmpyTdElig_20150909.csv")
CurrentSample<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n144_ARI+DEMO+QA_20180216.rds")

#############################################################################
### Number of Subjects from the Control & Irritability Eligability Groups ###
#############################################################################

length(which(CurrentSample$bblid %in% ControlElig$bblid)) #101
length(which(CurrentSample$bblid %in% IrrElig$bblid)) #37

# Missing 6 Subjects From These Eliability Spreadsheets

########################################################
### Create Sub Datasets to Find BBLIDS of Each Group ###
########################################################

SubIDsNC<-CurrentSample[which(CurrentSample$bblid %in% ControlElig$bblid),]
SubIDsIrr<-CurrentSample[which(CurrentSample$bblid %in% IrrElig$bblid),]

####################################################################
### Combine Eligability Datasets to Find the Missing 6 Subjects  ###
####################################################################

IrrElig$healthExclude<-NULL
CombinedElig<-rbind(ControlElig, IrrElig)

setdiff(CurrentSample$bblid, CombinedElig$bblid) # 81760,85173,87646,92554,99964,121407


which(duplicated(ControlElig$bblid)==TRUE) #9,34
which(duplicated(IrrElig$bblid)==TRUE) #250,271
which(duplicated(CombinedElig)==TRUE) #9,34,588,609
dim(CombinedElig) # 1160 - 4 Duplicates = 1156 Total in Eligability Datasets

#################################################
### See Distribution of TP1 Irritability Sum  ###
#################################################

CurrentSample$IrritabilitySum<-as.factor(CurrentSample$IrritabilitySum)
summary(CurrentSample$IrritabilitySum) # 0=37 1=31 2=31 3=23 4=16 NA's=6

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################