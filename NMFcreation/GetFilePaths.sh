#Get the paths for the CT and Ravens files for the testing sample on CBICA 
#NOTE: We are skipping GMD b/c the NMF GMD results are not looking very good.

cat /cbica/projects/pncNmf/n1396_t1NMF/subjectData/n696_T1_test_bblids_scanids.csv | while IFS="," read -r a b ;

do

#CT
CtPath8mm=`ls -d /cbica/projects/pncNmf/n1396_t1NMF/images/CT_smoothed4mm/${b}_CorticalThicknessNormalizedToTemplate2mm_smoothed4mm.nii.gz`;

echo $CtPath8mm >> /cbica/projects/pncNmf/n1396_t1NMF/subjectData/n696_CtPaths_test.csv

#Ravens
RavensPath8mm=`ls -d /cbica/projects/pncNmf/n1396_t1NMF/images/Ravens_smoothed8mm/${b}_RAVENS_2GM_2mm_smoothed8mm.nii.gz`;

echo $RavensPath8mm >> /cbica/projects/pncNmf/n1396_t1NMF/subjectData/n696_RavensPaths_test.csv

#GMD
#GmdPath8mm=`ls -d /cbica/projects/pncNmf/n1396_t1NMF/images/GMD_smoothed8mm/${b}_atropos3class_prob02SubjToTemp2mm_smoothed8mm.nii.gz`;

#echo $GmdPath8mm >> /cbica/projects/pncNmf/n1396_t1NMF/subjectData/n1396_GmdPaths.csv


done

