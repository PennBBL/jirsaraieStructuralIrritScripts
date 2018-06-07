###################################################################################################
##########################         GRMPY - Generate Structual RDS        ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/18/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
# Use #

# This script combines the CSV's from the GRMPY and PNC study so that they could be analyzed using 
# repated measures.

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#####################################################################################
##### Reads in all the DataSets and Cohort Files that will be  #####
#####################################################################################

allCSV <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Nmf18Bases_CT_bblids.csv")
allRDS <- readRDS("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFlongitudinal/n229_Demo+ARI+QA_20171125.rds")

grmpySubs <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFcross-sectional/n115_Cohort_20171015.csv", header=FALSE)

#######################################################
##### Seperate the Data from Different Timepoints #####
#######################################################

grmpyRDS <- allRDS[(allRDS$scanid %in% grmpySubs$V2),]
grmpyCSV <- allCSV[(allCSV$scanid %in% grmpySubs$V2),]

pncCSV<-allCSV[!(allCSV$scanid %in% grmpySubs$V2),]
pncRDS<-allRDS[!(allRDS$scanid %in% grmpySubs$V2),]

########################################################
##### Save the GRMPY files for One Set of Analysis #####
########################################################

saveRDS(grmpyRDS, "/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFchange/n115_Demo+ARI+QA_20171204.rds")

write.csv(grmpyCSV, "/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFchange/n115_Nmf18Bases_CT_bblids.csv")

##################################################################
##### Identify which Subjects are Missing From Grmpy and PNC #####
##################################################################

grmpylong<-grmpyCSV[(grmpyCSV$bblid %in% pncCSV$bblid),]

pnclong<-pncCSV[(pncCSV$bblid %in% grmpylong$bblid),]

###################################################################
##### Takes the differences from PNC to GRMPY for Detal Model #####
###################################################################

pnclong <- pnclong[order(pnclong$bblid),] 
grmpylong <- grmpylong[order(grmpylong$bblid),] 


vdiff <- function(pnc,grmpy) {
   colnames    <- names(grmpy)[grep('Nmf',names(grmpy))]
   vdiff       <- data.frame(bblid=grmpy$bblid,scanid=grmpy$scanid)
   for (c in colnames){
       vdiff[c] <- pnc[c]- grmpy[c]
   }
   return(vdiff)
}

deltaAll <- vdiff(pnclong,grmpylong)

##########################################
##### Outputs the Combined CSV Files #####
##########################################

write.csv(deltaAll, paste('/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFchange/n111_Nmf18BasesDelta_CT_bblids_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)

#######################################################
##### Compute a RDS File Specific for Detal Model #####
#######################################################

deltaRDS<-grmpyRDS[(grmpyRDS$bblid %in% deltaAll$bblid),]

saveRDS(deltaRDS, "/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/NMFchange/n111_Demo+ARI+QA_20171204.rds")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
