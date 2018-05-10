###################################################################################################
##########################           GRMPY - Run ROI Wrapper             ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/03/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<USE

This wrapper was orginally created by Angel Garcia and modifed to run on the GRMPY dataset. After inputing
the required files and formulas, then the script will call the gamROI wrapper that computes the analysis.

USE
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

###############################################
##### Define the RDS File and Output Path #####
###############################################

subjDataName="/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF/n118_Demo+ARI+QA_20171103.rds"

OutDirRoot="/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/JLF"  

###################################################################################################
##### Define the name of the Variable that Specific which Subjects to Exclude in the RDS File #####
#####         Subjects To Include are Coded as "1" and the Ones to Exclude are "0"            #####
###################################################################################################

inclusionName="T1exclude"

subjID="bblid,scanid"

#######################################################################################
##### Define the Formula to Run, including the amount of knots and the Predictors #####
#####   Do Not Include Method as it will be Defined in gamROI.R (method="REML")   #####    
#######################################################################################

covsFormula="~s(ageatscan,k=4)+ari_total+ManualRating+sex"

pAdjustMethod="fdr"

ncores=5

residualMap=FALSE

######################################################################
##### If doing Repeated Measures, Include the Following Argument #####
######################################################################

#randomFormula="~(1|bblid)"

# Include in R script Call: -e $randomFormula

########################################################################
##### Define Paths of the Neuroimaging CSV's that will be Analyzed #####
#####  If a varaible is missing more than half the data, then you  #####
#####   will encounter errors, use reduceGMD.R to remove "NA's"    #####
########################################################################

path="/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLF"

input="${path}/n118_jlfAntsCTIntersectionCT_20170911.csv ${path}/n118_jlfAntsCTIntersectionGMDr_20171104.csv ${path}/n118_jlfAntsCTIntersectionVol_20170911.csv"

########################################################################
##### Calls the " gamROI.R" Rscript that will Perform the Analysis #####
########################################################################

for i in $input; do 

Rscript /data/joy/BBL/projects/jirsaraieStructuralIrrit/scripts/jirsaraieStructuralIrritScripts/JLF/gamROI.R  -c $subjDataName -o $OutDirRoot -p ${i} -i $inclusionName -u $subjID -f $covsFormula -a $pAdjustMethod -r $residualMap -n 5

done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
