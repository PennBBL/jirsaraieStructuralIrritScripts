###################################################################################################
##########################            GRMPY - Reduce GMD csv             ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/04/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#### Use ####

# This script was created to remove the columns of the GMPY GMD.csv that contained mostly missing data.
# Including these variables in the roiWrapper for analysis will only produce errors.

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#####################################
##### Define the File to Reduce #####
#####################################

GMD <- read.csv("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_jlfAntsCTIntersectionGMD_20170911.csv")

##########################################################
##### Prints the Sum of Missing Data for Each Column #####
##########################################################

 for (Var in names(GMD)) {
     missing <- sum(is.na(GMD[,Var]))
     if (missing > 0) {
         print(c(Var,missing))
     }
 }
 
####################################################################################
##### Lists Columns with the Most Missing Data and Removes Them from DataFrame #####
#####   Varaibles with more than half Values Missing will Result in Errors     #####
####################################################################################
 
GMD$mprage_jlf_gmd_R_Pallidum<- NULL
GMD$mprage_jlf_gmd_L_Pallidum<- NULL
GMD$mprage_jlf_gmd_Brain_Stem<- NULL
GMD$mprage_jlf_gmd_R_Thalamus_Proper<- NULL
GMD$mprage_jlf_gmd_L_Thalamus_Proper<- NULL
GMD$mprage_jlf_gmd_R_OCP<- NULL
GMD$mprage_jlf_gmd_L_OCP<- NULL 
GMD$mprage_jlf_gmd_Cerebellar_Vermal_Lobules_I.V<- NULL

#GMD$mprage_jlf_gmd_Cerebellar_Vermal_Lobules_VI.VII<- NULL -- Missing obs: 33
#GMD$mprage_jlf_gmd_Cerebellar_Vermal_Lobules_VIII.X<- NULL -- Missing obs:31
#GMD$mprage_jlf_gmd_L_Putamen<- NULL -- Missing obs:31
#GMD$mprage_jlf_gmd_R_Putamen<- NULL -- Missing obs:36

#######################################################
##### Prints the Sum of Missing Data for Each Row #####
#######################################################
 
apply(GMD,1,function(x) sum(is.na(x)))

##################################################
##### Removes the Rows with Any Missing Data #####
##################################################

#RemovedNaRows<-na.omit(GMD)

#########################################
##### Output the Reduced Data Frame #####
#########################################
  
write.csv(GMD, paste0("/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_jlfAntsCTIntersectionGMDr_20171104.csv"), row.names=F)

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

