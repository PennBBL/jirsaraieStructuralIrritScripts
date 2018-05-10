###################################################################################################
##########################         GRMPY - Generate NMF CSV's            ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 04/21/2018                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

###############################################################################
##### Reads in the Dataset of NMF Networks & Data From the Two TimePoints #####
###############################################################################

TP1<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n140_TP1_NMF/n140_Nmf24BasesCT_COMBAT_TP1.csv")
TP2<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n141_Nmf24BasesCT_COMBAT_TP2.csv")

##################################################################
##### Make the Dataset for the Delta Model & Save the Output #####
##################################################################

library(gdata)

Delta<-merge(TP1,TP2, by=c("bblid"))
varsTP1<-names(Delta[grep(".x",names(Delta))])
DeltaTP1<-Delta[,c("bblid",varsTP1)]
rename<- sub(".x", "", names(DeltaTP1))
DeltaTP1<-rename.vars(DeltaTP1,names(DeltaTP1),rename)

Delta<-merge(TP1,TP2, by=c("bblid"))
varsTP2<-names(Delta[grep(".y",names(Delta))])
DeltaTP2<-Delta[,c("bblid",varsTP2)]
rename<- sub(".y", "", names(DeltaTP2))
DeltaTP2<-rename.vars(DeltaTP2,names(DeltaTP2),rename)


vdiff <- function(DeltaTP2,DeltaTP1) {
   colnames    <- names(DeltaTP2)[grep('Nmf',names(DeltaTP2))]
   vdiff       <- data.frame(bblid=DeltaTP2$bblid,scanid=DeltaTP2$scanid)
   for (c in colnames){
       vdiff[c] <- (DeltaTP2[c] - DeltaTP1[c])
   }
   return(vdiff)
}


DeltaFinal <- vdiff(DeltaTP2,DeltaTP1)

write.csv(DeltaFinal, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n137_Delta_NMF/n137_Nmf24BasesCT_COMBAT_Delta.csv")

##################################################################################
##### Use the Delta Spreadsheets to Calcuate the Annual Percent Change Model #####
##################################################################################

DeltaTP1 <- DeltaTP1[order(DeltaTP1$bblid),]
DeltaTP2 <- DeltaTP2[order(DeltaTP2$bblid),]


vdiff <- function(DeltaTP2,DeltaTP1) {
   colnames    <- names(DeltaTP2)[grep('Nmf',names(DeltaTP2))]
   vdiff       <- data.frame(bblid=DeltaTP2$bblid,scanid=DeltaTP2$scanid)
   for (c in colnames){
       vdiff[c] <- (DeltaTP2[c] - DeltaTP1[c])/DeltaTP1[c]
   }
   return(vdiff)
}

percentCT <- vdiff(DeltaTP2,DeltaTP1)

RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_Demo+ARI+QA_20180401.rds")
RDS<-RDS[which(RDS$bblid %in% DeltaTP2$bblid),]
RDS<-RDS[order(RDS$bblid),]

rdiff <- function(DeltaTP2,RDS) {
   colnames    <- names(DeltaTP2)[grep('Nmf',names(DeltaTP2))]
   vdiff       <- data.frame(bblid=DeltaTP2$bblid,scanid=DeltaTP2$scanid)
   for (c in colnames){
       vdiff[c] <- DeltaTP2[c]/RDS['DeltaAge']
   }
   return(vdiff)
}


rateCT <- rdiff(percentCT,RDS)

write.csv(rateCT,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n137_Rate_NMF/n137_Nmf24BasesCT_COMBAT_Rate.csv")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
