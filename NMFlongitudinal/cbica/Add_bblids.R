#Read in bblids_scanids list and NMF output .csv

bblids_scanids <- read.csv("/cbica/projects/pncNmf/grmpyNMF/n229_longitudinal/subjectdata/n229_Cohort_20171124.csv", header=FALSE, na.strings=".") 
NMF_CT <- read.csv("/cbica/projects/pncNmf/grmpyNMF/n229_longitudinal/results/data/NmfResults18Bases_CT.csv", header=TRUE, na.strings=".")

#Add header to bblids_scanids

names(bblids_scanids) <- c("bblid", "scanid")

#Combine the bblids, scanids, and NMF output (NOTE: this assumes that the bblids list and the NMF output are in the exact same order)

CT_Data <- cbind(bblids_scanids,NMF_CT)

#Save file

write.csv(CT_Data, file = "/cbica/projects/pncNmf/grmpyNMF/n229_longitudinal/results/data/n229_Nmf18Bases_CT_bblids.csv",row.names=FALSE)
