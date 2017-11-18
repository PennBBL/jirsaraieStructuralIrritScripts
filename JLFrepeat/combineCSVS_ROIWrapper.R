###################################################################################################
##########################         GRMPY - Generate Structual RDS        ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/16/2017                    ##########################
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
##### Reads in all the Volume, Cortical Thickness, and Grey Matter Density Data #####
#####################################################################################

grmpyVOL <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n118_jlfAntsCTIntersectionVol_20170911.csv")
pncVOL <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n1601_jlfAntsCTIntersectionVol_20170412.csv")

grmpyCT <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n118_jlfAntsCTIntersectionCT_20170911.csv")
pncCT <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n1601_jlfAntsCTIntersectionCT_20170331.csv")

grmpyGMD <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n118_jlfAntsCTIntersectionGMDr_20171104.csv")
pncGMD <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n1601_jlfAtroposIntersectionGMD_20170410.csv")

##################################################################################
##### Finds Missing Subjects Data (99964) and Binds it to the needed Dataset #####
##################################################################################

missVOL <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAntsCTIntersectionVol_20170412.csv")
missCT <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAntsCTIntersectionCt_20170331.csv")
missGMD <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAtroposIntersectionGMD_20170410.csv")

missVOL<-missVOL[ which(missVOL$bblid=='99964'), ]
missCT<-missCT[ which(missCT$bblid=='99964'), ]
missGMD<-missGMD[ which(missGMD$bblid=='99964'), ]

pncVOL <- rbind(pncVOL,missVOL)
pncCT <- rbind(pncCT,missCT)
pncGMD <- rbind(pncGMD,missGMD)

###################################################################
##### Selects only the Subjects of Interest From the PNC Data #####
###################################################################

pncVOL <- pncVOL[(pncVOL$bblid %in% grmpyVOL$bblid),]

pncCT <- pncCT[(pncCT$bblid %in% grmpyCT$bblid),]

pncGMD <- pncGMD[(pncGMD$bblid %in% grmpyGMD$bblid),]

#########################################################################################
##### Removes the Extra Variables from the GMD PNC Data so Datasets Can be Combined #####
#########################################################################################

columnsPNC<-colnames(pncGMD, do.NULL = TRUE, prefix = "col")
columnsGRMPY<-colnames(grmpyGMD, do.NULL = TRUE, prefix = "col")

setdiff(columnsPNC,columnsgrmpy)

pncGMD$mprage_jlf_gmd_R_Pallidum<- NULL
pncGMD$mprage_jlf_gmd_L_Pallidum<- NULL
pncGMD$mprage_jlf_gmd_Brain_Stem<- NULL
pncGMD$mprage_jlf_gmd_R_Thalamus_Proper<- NULL
pncGMD$mprage_jlf_gmd_L_Thalamus_Proper<- NULL
pncGMD$mprage_jlf_gmd_R_OCP<- NULL
pncGMD$mprage_jlf_gmd_L_OCP<- NULL 

####################################################################
##### Combines the PNC and GRMPY Data Into Master Spreadsheets #####
####################################################################

VOL <-rbind(pncVOL,grmpyVOL)

CT <-rbind(pncCT,grmpyCT)

GMD <-rbind(pncGMD,grmpyGMD)

##########################################
##### Outputs the Combined CSV Files #####
##########################################

write.csv(VOL, paste('/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n236_jlfAntsCTIntersectionVOL_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)

write.csv(CT, paste('/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n236_jlfAntsCTIntersectionCT_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)

write.csv(GMD, paste('/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFrepeat/n236_jlfAtroposIntersectionGMD_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
