% created: Zoya Bylinskii, Aug 2014

% This finds the correlation between two different saliency maps.
% score=1 or -1 means the maps are correlated
% score=0 means the maps are completely uncorrelated

function score = crossCorrelation(saliencyMap1, saliencyMap2)
% saliencyMap1 and saliencyMap2 are 2 real-valued matrices

map1 = im2double(imresize(saliencyMap1, size(saliencyMap2)));
map2 = im2double(saliencyMap2);

% normalize both maps
map1 = (map1 - mean(map1(:))) / std(map1(:)); 
map2 = (map2 - mean(map2(:))) / std(map2(:)); 

score = corr2(map2, map1);