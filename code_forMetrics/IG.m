% created: David Berga, May 2016

% This finds the Information Gain between a saliency map and the ground
% truth fixation map.
% It is a non-symmetric measure of the information gain when saliencyMap 
% is used to estimate fixationMap by substracting a baseline map, 
% which is the averaged the ground truth fixation maps of all other images


function [score,map] = IG(saliencyMap, fixationMap, baselineMap)
% saliencyMap is the saliency map
% fixationMap is the binary human fixation map
% baselineMap is the saliency mean from other human fixation maps

map1 = im2double(imresize(saliencyMap, size(fixationMap)));
map2 = im2double(fixationMap);
map3 = im2double(imresize(baselineMap, size(fixationMap)));

% make sure map1 and map3 sum to 1
if any(map1(:))
    map1 = map1/sum(map1(:));
end

if any(map3(:))
    map3 = map3/sum(map3(:));
end

% compute IG
score = mean(nonzeros(map2 .* (log2(eps + map1) - log2(eps+map3))));
map = map2 .* (log2(eps + map1) - log2(eps+map3));

