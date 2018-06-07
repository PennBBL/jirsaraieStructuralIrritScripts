###################################################################################################
##########################        GRMPY - Combat Longitudinal Data       ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 04/22/2018                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
# Use #

# Grmpy Data from TP1 and TP2 were collected on different scanners, which could have lead to some unwanted 
# variation between scanners. This script calls the combat algorithm to help reduce some of this variation 
# between the two timepoints.

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#################################################
##### Load functions from these two scripts #####
#################################################

source("/data/jux/BBL/projects/jirsaraieStructuralIrrit/scripts/jirsaraieStructuralIrritScripts/creationCOMBAT/utils.R")
source("/data/jux/BBL/projects/jirsaraieStructuralIrrit/scripts/jirsaraieStructuralIrritScripts/creationCOMBAT/combat.R")

########################################################################
##### Read in the Datasets to be Harmonized & cbind them together  #####
########################################################################

TP1ct<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n140_TP1_NMF/n140_Nmf24BasesCT_TP1.csv")
TP1ct=t(TP1ct)
colnames(TP1ct)=TP1ct[2,]
TP1ct= TP1ct[-2, ]
TP1ct= TP1ct[-1, ]


TP2ct<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n141_Nmf24BasesCT_TP2.csv")
TP2ct=t(TP2ct)
colnames(TP2ct)=TP2ct[2,]
TP2ct= TP2ct[-2, ]
TP2ct= TP2ct[-1, ]

dat<-cbind(TP1ct, TP2ct)

########################################################
##### Define which columns are from what Timepoint #####
########################################################

batch = c(1:281)

batch[1:140] <- 1
batch[141:281] <- 2

################################################################################
##### Read in the Covaraite Data to Control for when Harmonizing the Data  #####
################################################################################

TP2rds<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n141_Demo+ARI+QA_20180322.rds")
TP2rds<-TP2rds[order(TP2rds$bblid),]
myvars2 <- c("bblid","scanid","ageatscan", "sex","ari_log")
TP2rds <- TP2rds[myvars2]

TP1rds<-readRDS("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n140_TP1_NMF/n140_ARI+DEMO+QA_20180216.rds")
TP1rds<-TP1rds[order(TP1rds$bblid),]
myvars1 <- c("bblid","scanid","ageAtScan1", "sex","TP2ari_log")
TP1rds <- TP1rds[myvars1]
TP1rds$sex<-as.numeric(TP1rds$sex)
TP1rds$sex<-TP1rds$sex-1
TP1rds$sex<-as.factor(TP1rds$sex)
colnames(TP1rds)[3] <- "ageatscan"
colnames(TP1rds)[5]<-"ari_log"

###########################################################################################
##### Reformat the Datasets and Select Only Those Varaibles of Interest Then Combine  #####
###########################################################################################

TP1rds=t(TP1rds)
colnames(TP1rds)=TP1rds[2,]
TP1rds= TP1rds[-2, ]
TP1rds= TP1rds[-1, ]

TP2rds=t(TP2rds)
colnames(TP2rds)=TP2rds[2,]
TP2rds= TP2rds[-2, ]
TP2rds= TP2rds[-1, ]

combinedRDS<-cbind(TP1rds,TP2rds)
combinedRDS<-combinedRDS[,order(colnames(combinedRDS))]

age<-as.numeric(c(combinedRDS[1,]))
sex<-as.factor(c(combinedRDS[2,]))
ari_log<-as.numeric(c(combinedRDS[3,]))

mod <- model.matrix(~age+sex+ari_log)

############################################
##### Final Call to Harmonize the Data #####
############################################

data.harmonized <- combat(dat=dat, batch=batch, mod=mod)

#######################################################################
##### Reformat the output to a standard CSV and write the Output  #####
#######################################################################

output<-as.data.frame(t(data.harmonized$dat.combat))
output$scanid<-row.names(output)
output<-output[,c(25,1:24)]
rownames(output)<-NULL
output$scanid<-as.integer(output$scanid)

###Write for TP1 Sample###
TP1ct<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n140_TP1_NMF/n140_Nmf24BasesCT_TP1.csv")
TP1ct<-TP1ct[,c(1:2)]
TP1<-merge(TP1ct,output, by=c("scanid"))
TP1<-TP1[,c(2,1,3:26)]
write.csv(TP1, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n140_TP1_NMF/n140_Nmf24BasesCT_COMBAT_TP1.csv")

###Write for TP2 Sample###
TP2ct<-read.csv("/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n141_Nmf24BasesCT_TP2.csv")
TP2ct<-TP2ct[,c(1:2)]
TP2<-merge(TP2ct,output, by=c("scanid"))
TP2<-TP2[,c(2,1,3:26)]
write.csv(TP2, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/n141_TP2_NMF/n141_Nmf24BasesCT_COMBAT_TP2.csv")

###Write for Whole Sample###

Combined<-rbind(TP1,TP2)
write.csv(Combined, "/data/jux/BBL/projects/jirsaraieStructuralIrrit/data/creationCOMBAT/n281_NMFAntsCTcombat_20180429.csv")

###########################################################################################
###########################################################################################
