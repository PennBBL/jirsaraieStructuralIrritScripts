#Convert the NMF components to MNI space for Caret images.

numComponents="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24"

indir=/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/MaskedByNeighborThresh300

outdir=/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/MaskedByNeighborThresh300_WarpedToMNI

mkdir $outdir

for i in $numComponents
do
        echo ""

        echo "Component number is $i"

antsApplyTransforms -e 3 -d 3 -r /share/apps/fsl/5.0.8/data/standard/MNI152_T1_2mm_brain.nii.gz -o $outdir/Basis_${i}_thr003_maskedByNeighborThr300_2mmMNI.nii.gz -i $indir/Basis_${i}_thr003_maskedByNeighborThr300.nii.gz -t /data/joy/BBL/studies/pnc/template/pnc2mni0Warp.nii.gz -t /data/joy/BBL/studies/pnc/template/pnc2mni1GenericAffine.mat

done

