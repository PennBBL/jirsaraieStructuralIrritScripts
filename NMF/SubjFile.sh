#!/bin/sh

###################################################################################################
##########################         GRMPY - Create Subject Files          ##########################
##########################              Robert Jirsaraie                 ##########################
##########################             rjirsara@upenn.edu                ##########################
##########################                  10/15/2017                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<Use

This script was created to identify the subjects of interest and list their information into correct format.
This specific script was used to create the cohort files needed for computing Masks, which are required 
for NMF analysis.

Use
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

subjects=/data/joy/BBL/studies/grmpy/processedData/structural/struct_pipeline_20170716/*/*/
QAExclude=$(echo 106331,10587 121476,10280 85083,10577)

outdirect=/data/joy/BBL/projects/grmpyProcessing2017/NMF

for s in $subjects; do 

   bblIDs=$(echo ${s}|cut -d'/' -f10|sed s@'/'@' '@g)
   SubjectxDate=$(echo ${s}|cut -d'/' -f11|sed s@'/'@' '@g|sed s@'x'@','@g)
   scanID=$(echo ${SubjectxDate}|cut -d',' -f2)

   echo ${bblIDs},${scanID}>>${outdirect}/n118_Cohort_20171015.csv

done

Cohort=$(cat ${outdirect}/n118_Cohort_20171015.csv)

i=0
for c in ${Cohort}; do
   for q in ${QAExclude}; do

      if [[ ${c} == ${q} ]]; then

          echo "Bad QA Will Be Excluded"
          unset final[i]
          break

      else 

         final[i]=$(echo ${c})
         
      fi 
      
   done
   
   echo ${final[i]}>>${outdirect}/n115_Cohort_20171015.csv 
   
   (( i++ ))
   
done


rm ${outdirect}/n118_Cohort_20171015.csv


###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<ALTERNATIVECODE

cat n115_Cohort_20171015.csv|grep -v '106331,10587'|grep -v '121476,10280'|grep -v '85083,10577'>>OUTPUT

ALTERNATIVECODE
