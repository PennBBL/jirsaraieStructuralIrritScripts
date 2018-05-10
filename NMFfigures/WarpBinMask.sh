#Warp and binarize the mask

mask=/data/joy/BBL/studies/pnc/template/priors/prior_grey_thr01_2mm.nii.gz

outdir=/data/jux/BBL/projects/jirsaraieStructuralIrrit/output/NMFcreation/mask
mkdir $outdir

#Warp to MNI
antsApplyTransforms -e 3 -d 3 -r /share/apps/fsl/5.0.8/data/standard/MNI152_T1_2mm_brain.nii.gz -o $outdir/prior_grey_thr01_2mm_MNI.nii.gz -i $mask -t /data/joy/BBL/studies/pnc/template/pnc2mni0Warp.nii.gz -t /data/joy/BBL/studies/pnc/template/pnc2mni1GenericAffine.mat

#Binarize
fslmaths $outdir/prior_grey_thr01_2mm_MNI.nii.gz -bin $outdir/prior_grey_thr01_2mm_MNI_bin.nii.gz
