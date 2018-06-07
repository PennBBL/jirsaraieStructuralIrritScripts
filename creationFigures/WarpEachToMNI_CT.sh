#Convert each NMF component to MNI space for Caret images.

numComponents="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24"

inDir=/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/creationNMF/Networks24

outDir=/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/creationNMF/EachComponentWarpedToMNI
mkdir -p $outDir

for i in $numComponents
do
        echo ""

        echo "Component number is $i"

antsApplyTransforms -e 3 -d 3 -r /share/apps/fsl/5.0.8/data/standard/MNI152_T1_1mm_brain.nii.gz -o $outDir/CT_NMF_$i.nii -i $inDir/Basis_$i.nii -t /data/joy/BBL/studies/pnc/template/pnc2mni0Warp.nii.gz -t /data/joy/BBL/studies/pnc/template/pnc2mni1GenericAffine.mat

done
