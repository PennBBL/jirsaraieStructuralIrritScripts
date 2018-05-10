function [ output ] = thresholdImageBasedOnNeighboorhoodSize(niftiMask, thresholdSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Load the data
mask= load_nifti(niftiMask);

% Now turn all values in the mask not equal to 0 into 1's
valuesToProbe=unique(mask.vol);
valuesToProbe=valuesToProbe(2:end);

% Now loop thorugh and find the number of neighboorhoods
% for each mask value
% But first prime an empty image
xDim=mask.dim(2);
yDim=mask.dim(3);
zDim=mask.dim(4);
blank = zeros(xDim, yDim, zDim);
output = blank;
for i=1:length(valuesToProbe);
    maskThreshold=valuesToProbe(i);
    maskIndex = find(mask.vol==maskThreshold);
    tmp=blank;
    tmp(maskIndex)=1;
    CC = bwconncomp(tmp);
    numPixels = cellfun(@numel, CC.PixelIdxList);
    idToUse=find(numPixels > thresholdSize) ; 
    tmp=blank;
    for q=1:length(idToUse); 
        tmp(CC.PixelIdxList{idToUse(q)}) = valuesToProbe(i); 
    end
    output = output+tmp; 
end

% Now we need to write the new image
outputImage=mask; 
outputImage.vol=output;
imgName=strsplit(niftiMask,'.')
save_nifti(outputImage, sprintf('./%s_NeighborThr%d.nii.gz',imgName{2},thresholdSize));
end

