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

NMF<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/NMFcreation/n281_Nmf24Bases_CT_bblids.csv")

TP2<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_jlfAntsCTIntersectionCT_20180320.csv")
TP1<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n144_jlfAntsCTIntersectionCT_20180216.csv")

TP2<-TP2[,c("bblid","scanid")]
TP1<-TP1[,c("bblid","scanid")]

#########################################################################################
##### Merge the Data to Seperate the Two Timepoints & Save the Cross-sectional Data #####
#########################################################################################

TP2NMF<-merge(TP2,NMF, by=c("bblid","scanid"))
TP1NMF<-merge(TP1,NMF, by=c("bblid","scanid"))

write.csv(TP2NMF, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n141_Nmf24BasesCT_TP2.csv")
write.csv(TP1NMF,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n140_TP1_NMF/n140_Nmf24BasesCT_TP1.csv")

##################################################################
##### Make the Dataset for the Delta Model & Save the Output #####
##################################################################

library(gdata)

Delta<-merge(TP1NMF,TP2NMF, by=c("bblid"))
varsTP1<-names(Delta[grep(".x",names(Delta))])
DeltaTP1<-Delta[,c("bblid",varsTP1)]
rename<- sub(".x", "", names(DeltaTP1))
DeltaTP1<-rename.vars(DeltaTP1,names(DeltaTP1),rename)

Delta<-merge(TP1NMF,TP2NMF, by=c("bblid"))
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

write.csv(DeltaFinal, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n137_Delta_NMF/n137_Nmf24BasesCT_Delta.csv")

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

write.csv(rateCT,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n137_Rate_NMF/n137_Nmf24BasesCT_Rate.csv")

#######################################################
##### Write the Associated RDS Files for Analyses #####
#######################################################

RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_Delta_JLF/n144_Demo+ARI+QA_20180401.rds")
RDS<-RDS[which(RDS$bblid %in% DeltaTP2$bblid),]
RDS<-RDS[order(RDS$bblid),]
saveRDS(RDS, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n137_Rate_NMF/n137_Demo+ARI+QA_20180401.rds")

RDS<-merge(RDS,DeltaTP1, by=c("bblid"))
colnames(RDS)[8]<-"scanid"
RDS$scanid.y<-NULL
rename<- sub("Ct", "TP1_Ct", names(RDS))
RDS<-rename.vars(RDS,names(RDS),rename)
saveRDS(RDS, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n137_Delta_NMF/n137_Demo+ARI+QA+TP1CT_20180401.rds")

RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP2_JLF/n144_Demo+ARI+QA_20180322.rds")
RDS<-RDS[which(RDS$bblid %in% TP2NMF$bblid),]
RDS<-RDS[order(RDS$bblid),]
saveRDS(RDS,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n144_Demo+ARI+QA_20180322.rds")

RDS<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n144_TP1_JLF/n144_ARI+DEMO+QA_20180216.rds")
RDS<-RDS[which(RDS$bblid %in% TP1NMF$bblid),]
RDS<-RDS[order(RDS$bblid),]
saveRDS(RDS,"/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n140_TP1_NMF/n140_ARI+DEMO+QA_20180216.rds")

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
