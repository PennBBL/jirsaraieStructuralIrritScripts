###################################################################################################
##########################           GRMPY - Run ROI Wrapper             ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/18/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<USE

This version of the ROI Wrapper call used to specifically run repeated measures of longitudinal data 
(GRMPY & PNC) on JLF regional data.

USE
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

###############################################
##### Define the RDS File and Output Path #####
###############################################

subjDataName="/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFchange/n118_Demo+ARI+QA_20171117.rds"

OutDirRoot="/data/joy/BBL/projects/jirsaraieStructuralIrrit/output/JLFchange"  

###################################################################################################
##### Define the name of the Variable that Specific which Subjects to Exclude in the RDS File #####
#####         Subjects To Include are Coded as "1" and the Ones to Exclude are "0"            #####
###################################################################################################

subjID="bblid,scanid"

inclusionName="T1exclude"

#######################################################################################
##### Define the Formula to Run, including the amount of knots and the Predictors #####
#####   Do Not Include Method as it will be Defined in gamROI.R (method="REML")   #####    
#######################################################################################

covsFormula="~s(ageatscan,k=4)+ARItotal+ManualRating+sex"

pAdjustMethod="fdr"

ncores=5

residualMap=FALSE

######################################################################
##### If doing Repeated Measures, Include the Following Argument #####
######################################################################

#randomFormula="~(1|bblid)"

# Put in Call If using command: -e $randomFormula
########################################################################
##### Define Paths of the Neuroimaging CSV's that will be Analyzed #####
#####  If a varaible is missing more than half the data, then you  #####
#####   will encounter errors, use reduceGMD.R to remove "NA's"    #####
########################################################################

path="/data/joy/BBL/projects/jirsaraieStructuralIrrit/data/JLFchange"

input="${path}/n81_jlfAtroposIntersectionGMDdiff_20171118.csv ${path}/n118_jlfAntsCTIntersectionCTdiff_20171117.csv ${path}/n118_jlfAntsCTIntersectionVOLdiff_20171117.csv"

########################################################################
##### Calls the " gamROI.R" Rscript that will Perform the Analysis #####
########################################################################

for i in $input; do 

Rscript /data/joy/BBL/projects/jirsaraieStructuralIrrit/scripts/jirsaraieStructuralIrritScripts/JLFchange/gamROI.R  -c $subjDataName -o $OutDirRoot -p ${i} -i $inclusionName -u $subjID -f $covsFormula -a $pAdjustMethod -r $residualMap -n 5 

done

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
