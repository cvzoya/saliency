% created by: Zoya Bylinskii, Sept 2014
% based on code by Tilke Judd

% This function histogram matches all the saliency
% maps in a given directory with a target histogram.
% Empirically, saliency maps that are histogram 
% matched to a ground-truth human fixation map 
% tend to perform better on some metrics.

function histogramMatchMaps(salDir,resDir,targetHist,showOutput)
% salDir contains all the saliency map files
% resDir is the output directory for the histogram-matched saliency maps
% targetHist is the histogram to use for matching the maps to
%     targetHist.counts should contain the counts
%     targetHist.bins should contain the bin locations
% this could be obtained as:
% [targetHist.counts,targetHist.bins] = imhist(im); 
% for some target image im
% the script getTargetHist computes a target histogram
% on images from the ICCV MIT saliency data set.

if nargin < 4, 
    showOutput = 0; 
end

if exist(resDir,'dir')
    fprintf('Directory %s already exists. Will overwrite.\n',resDir);
else
    mkdir(resDir)
end

allfiles = dir(fullfile(salDir,'*.jpg'));
fprintf('Found %d files in %s.\n',length(allfiles),salDir);

if showOutput
    figure;
end

for i = 1:length(allfiles)
    fprintf('On %s\n',allfiles(i).name)
    curMap = im2double(imread(fullfile(salDir,allfiles(i).name)));
    matchedMap = histoMatch(curMap, targetHist.counts, targetHist.bins); 
    imwrite(matchedMap,fullfile(resDir,allfiles(i).name));
    if showOutput
        subplot(221); imshow(curMap); title(['Original map'])
        subplot(222); imshow(matchedMap); title (['Matched map'])
        subplot(223); imhist(curMap);
        subplot(224); imhist(matchedMap);
        pause;
    end
end
