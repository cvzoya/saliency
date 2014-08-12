% created: Zoya Bylinskii, Aug 2014

% This finds the normalized scanpath saliency between two different 
% saliency maps as the mean value of the normalized saliency map at 
% fixation locations.

function score = NSS(saliencyMap, fixationMap)
% saliencyMap is the saliency map
% fixationMap is the human fixation map (binary matrix)

% normalize saliency map
map = (saliencyMap - mean(saliencyMap(:)))/std(saliencyMap(:)); 

% mean value at fixation locations
score = mean(map(logical(fixationMap))); 