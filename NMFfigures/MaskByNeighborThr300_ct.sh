#Mask the thresholded .004 images by the NeighborThr400 mask.

numComponents="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24"

indir=/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/Threshold003

maskdir=/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/NeighborThresh300

outdir=/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/MaskedByNeighborThresh300

mkdir $outdir


for i in $numComponents
do
        echo ""

        echo "Component number is $i"

fslmaths $indir/Basis_${i}_thr003.nii.gz -mas $maskdir/Basis_${i}_thr003Bin_NeighborThr300.nii.gz $outdir/Basis_${i}_thr003_maskedByNeighborThr300.nii.gz

done
