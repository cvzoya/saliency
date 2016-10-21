% created: Zoya Bylinskii, March 6
% based on: Kummerer et al.
% (http://www.pnas.org/content/112/52/16054.abstract)

% This finds the information-gain of the saliencyMap over a baselineMap

function score = InfoGain(saliencyMap, fixationMap, baselineMap)
% saliencyMap is the saliency map
% fixationMap is the human fixation map (binary matrix)
% baselineMap is another saliency map (e.g. all fixations from other images)

%%
map1 = imresize(saliencyMap,size(fixationMap));
mapb = imresize(baselineMap,size(fixationMap));
%%
% normalize and vectorize saliency maps
map1 = (map1(:) - min(map1(:)))/(max(map1(:))-min(map1(:))); 
mapb = (mapb(:) - min(mapb(:)))/(max(mapb(:))-min(mapb(:))); 
%%

% turn into distributions
map1 = map1./sum(map1);
mapb = mapb./sum(mapb);

locs = logical(fixationMap(:));
%%
score = mean(log2(eps+map1(locs))-log2(eps+mapb(locs))); 