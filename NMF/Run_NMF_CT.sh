#/n1396_t1NMF/scripts/Run_NMF_CT.sh
#Run the NMF script for a range of components to find the optimal component number.

csvFile=/cbica/projects/pncNmf/grmpyNMF/n115_structCT/subjectdata/n115_ctSmoothPath.csv

numComponents="2 4 6 8 10 12 14 16 18 20 22 24 26 28 30"

#Do not place a "/" at the end of the output directory path or it will cause random components to crash in matlab.

outputDirectory=/cbica/projects/pncNmf/grmpyNMF/n115_structCT/results

mask=/cbica/projects/pncNmf/grmpyNMF/n115_structCT/ctMask/n115_ctMask_thr9_2mm.nii.gz


for i in $numComponents
do
        echo ""

        echo "Component number is $i"


qsub /cbica/projects/pncNmf/grmpyNMF/n115_structCT/scripts/submit_script_extractBasesMT.sh $csvFile $i $outputDirectory $mask

echo qsub /cbica/projects/pncNmf/grmpyNMF/n115_structCT/scripts/submit_script_extractBasesMT.sh $csvFile $i $outputDirectory $mask >> commands.txt

sleep 1s
done
