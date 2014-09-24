% created by: Zoya Bylinskii, Sept 2014

% This simple function computes the average 
% histogram across all the ground-truth human
% fixation maps in a subset of the ICCV MIT  
% saliency data set. You can use this average
% human fixation map to perform histogram
% matching on your saliency maps (see
% histogramMatchMaps.m). Histogram matching
% to some baseline human fixation map tends to 
% improve performance on some metrics that  
% downscore very sparse or dense saliency maps.

function targetHist = getTargetHist(FIXATIONMAPS)
% FIXATIONMAPS is the path to human fixation maps

% number of bins for histogram
nbins = 256;

imfiles = dir(fullfile(FIXATIONMAPS,'*.jpeg'));
avghist = zeros(nbins,1);
for i = 1:length(imfiles)
    fixMap = im2double(imread(fullfile(FIXATIONMAPS, imfiles(i).name)));
    [h,x] = imhist(fixMap,nbins);
    avghist = avghist+h;
end

targetHist.counts = avghist/length(imfiles);
targetHist.bins = x;
