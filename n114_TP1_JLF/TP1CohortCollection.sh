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

TP1 <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n144_BBLids_20180131.csv")

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

write.csv(Subjects, paste0("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n144_Irritability_20180131.csv"), row.names=F)

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

