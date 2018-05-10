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
##### Reads in all the Volume, Cortical Thickness, and Grey Matter Density Data #####
#####################################################################################

RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_Demo+ARI+QA_20180401.rds")
RDS<-RDS[order(RDS$bblid),]

grmpyVOL <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_jlfAntsCTIntersectionVol_20180320.csv")
pncVOL <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n118_preAnalysis_JLF/JLFrepeat/n1601_jlfAntsCTIntersectionVol_20170412.csv")

grmpyCT <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_jlfAntsCTIntersectionCT_20180320.csv")
pncCT <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n118_preAnalysis_JLF/JLFrepeat/n1601_jlfAntsCTIntersectionCT_20170331.csv")

grmpyGMD <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_jlfAtroposIntersectionGMD_20180320.csv")
pncGMD <- read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n118_preAnalysis_JLF/JLFrepeat/n1601_jlfAtroposIntersectionGMD_20170410.csv")

###################################################################
##### Selects only the Subjects of Interest From the PNC Data #####
###################################################################

pncVOL <- pncVOL[(pncVOL$bblid %in% grmpyVOL$bblid),]

pncCT <- pncCT[(pncCT$bblid %in% grmpyCT$bblid),]

pncGMD <- pncGMD[(pncGMD$bblid %in% grmpyGMD$bblid),]

###########################################
##### Add Data From a Missing Subject #####
###########################################

missVOL <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAntsCTIntersectionVol_20170412.csv")
missCT <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAntsCTIntersectionCt_20170331.csv")
missGMD <- read.csv("/data/joy/BBL/studies/pnc/n2416_dataFreeze/neuroimaging/t1struct/n2416_jlfAtroposIntersectionGMD_20170410.csv")

missVOL<-missVOL[ which(missVOL$bblid=='99964'), ]
missCT<-missCT[ which(missCT$bblid=='99964'), ]
missGMD<-missGMD[ which(missGMD$bblid=='99964'), ]

pncVOL <- rbind(pncVOL,missVOL)
pncCT <- rbind(pncCT,missCT)
pncGMD <- rbind(pncGMD,missGMD)

###############################################
##### Reorder Dataframes to Be Consistent #####
###############################################

grmpyCT <- grmpyCT[order(grmpyCT$bblid),]
pncCT <- pncCT[order(pncCT$bblid),]

grmpyVOL <- grmpyVOL[order(grmpyVOL$bblid),]
pncVOL <- pncVOL[order(pncVOL$bblid),]

grmpyGMD <- grmpyGMD[order(grmpyGMD$bblid),]
pncGMD <- pncGMD[order(pncGMD$bblid),]

###############################################################################
##### Calculate the Percent Change From TP2 to TP1 for Every Brain Metric #####
###############################################################################

vdiff <- function(grmpy,pnc) {
   colnames    <- names(grmpy)[grep('jlf',names(grmpy))]
   vdiff       <- data.frame(bblid=grmpy$bblid,scanid=grmpy$scanid)
   for (c in colnames){
       vdiff[c] <- (grmpy[c] - pnc[c])/pnc[c]
   }
   return(vdiff)
}

percentCT <- vdiff(grmpyCT,pncCT)
percentGMD <- vdiff(grmpyGMD,pncGMD)
percentVOL <- vdiff(grmpyVOL,pncVOL)

###################################################################################################
##### Divide the Percent Change of The Brain Metric by Delta Age to Get Annual Rate of Change #####
###################################################################################################

vdiff <- function(grmpy,pnc) {
   colnames    <- names(grmpy)[grep('jlf',names(grmpy))]
   vdiff       <- data.frame(bblid=grmpy$bblid,scanid=grmpy$scanid)
   for (c in colnames){
       vdiff[c] <- grmpy[c]/pnc['DeltaAge']
   }
   return(vdiff)
}

rateCT <- vdiff(percentCT,RDS)
rateGMD <- vdiff(percentGMD,RDS)
rateVOL <- vdiff(percentVOL,RDS)

###################################################################################################
##### Divide the Percent Change of The Brain Metric by Delta Age to Get Annual Rate of Change #####
###################################################################################################

write.csv(rateCT,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_jlfAntsCTIntersectionCTannualRate_20180404.csv")
write.csv(rateGMD,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_jlfAntsCTIntersectionGMDannualRate_20180404.csv")
write.csv(rateVOL,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_jlfAntsCTIntersectionVOLannualRate_20180404.csv")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#/home/rciric/xcpAccelerator/xcpEngine/utils/val2mask.R -i /data/joy/BBL/studies/pnc/processedData/structural/jlf/99949/20130406x7887/99949_20130406x7887_jlfLabelsANTsCTIntersection.nii.gz -v 46,63,64,69 -o /tmp/jlf_bad_values_pnc.nii.gz
#diff /tmp/jlf_unique_*
#fslview /data/joy/BBL/studies/pnc/processedData/structural/antsCorticalThickness/99949/20130406x7887/BrainSegmentation0N4.nii.gz /tmp/jlf_bad_values_pnc.nii.gz &
