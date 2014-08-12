% created: Zoya Bylinskii, Aug 2014

% This finds the correlation between two different saliency maps.
% score=1 or -1 means the maps are correlated
% score=0 means the maps are completely uncorrelated

function score = crossCorrelation(saliencyMap1, saliencyMap2)
% saliencyMap1 and saliencyMap2 are 2 real-valued matrices

[w, h, ~] = size(saliencyMap2);

% resize map1 and map2 to smaller size
% longest edge is length 200px.
if w > h
    map1 = imresize(saliencyMap2, [200, NaN]);
    map2 = imresize(saliencyMap1, [200, NaN]);
else
    map1 = imresize(saliencyMap2, [NaN, 200]);
    map2 = imresize(saliencyMap1, [NaN, 200]);
end

map1 = im2double(map1);
map2 = im2double(map2);

% normalize both maps
map1 = (map1 - mean(map1(:))) / std(map1(:)); 
map2 = (map2 - mean(map2(:))) / std(map2(:)); 

score = corr2(map2, map1);