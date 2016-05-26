% Plot the per-pixel information gain of one distribution over another at predicting
% a ground truth (target) distribution. 

% Zoya Bylinskii, April 2016
% linked to: "What do different evaluation metrics tell us about saliency models?"

% based on: Kummerer et al.
% (http://www.pnas.org/content/112/52/16054.abstract)

function [resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(fixMap, salMap, baseMap, toplot)

if nargin < 4
    toplot = 1;
end

figtitle = 'information gain';

%  format, resize, and normalize maps
map1 = im2double(fixMap); 
map2 = im2double(imresize(salMap, size(fixMap)));
map1 = (map1-min(map1(:)))/(max(map1(:))-min(map1(:)));
map2 = (map2-min(map2(:)))/(max(map2(:))-min(map2(:)));

% compute per-pixel information gain (over baseline, if provided)
map1 = map1/sum(map1(:));
map2 = map2/sum(map2(:));
if nargin>2 && ~isempty(baseMap)
    mapb = im2double(imresize(baseMap, size(fixMap)));
    mapb = (mapb-min(mapb(:)))/(max(mapb(:))-min(mapb(:)));
    mapb = mapb/sum(mapb(:));
    map1_log = log2(eps+map1)-log2(eps+mapb);
    map2_log = log2(eps+map2)-log2(eps+mapb);
    
% if no baseMap is provided, IG calculation will be very similar to KL
else
    map1_log = log2(eps+map1);
    map2_log = log2(eps+map2);
end


% what parts of the fixation map can the saliency map explain?
resMap = (map2_log - map1_log).*map1; 

resMap_pos = resMap.*(resMap>0);  % pixels where salmap overpredicts fixmap
resMap_neg = -resMap.*(resMap<0); % pixels where salmap underpredicts fixmap

resMap_pos = (resMap_pos-min(resMap_pos(:)))/(max(resMap_pos(:))-min(resMap_pos(:)));
resMap_neg = (resMap_neg-min(resMap_neg(:)))/(max(resMap_neg(:))-min(resMap_neg(:)));

resMap = imfuse(resMap_neg,resMap_pos,'Scaling','none');

% computations relative to baseline, not fixation map
resMap2 = map2_log.*map1;
resMap2 = resMap2.*(resMap2>0);
resMap2 = (resMap2-min(resMap2(:)))/(max(resMap2(:))-min(resMap2(:)));

if toplot
    resMap1_t = resMap2; resMap1_f = resMap_neg;
    maxval = double(max([max(resMap1_t(:)),max(resMap1_f(:))]));
    
    % joint scaling
    resMap1_t = resMap1_t/maxval; 
    resMap1_f = resMap1_f/maxval; 
    
    resMap1 = imfuse(resMap1_f,resMap1_t,'Scaling','joint','ColorChannels',[1 2 2]);
    figure; imshow(resMap1); title(figtitle,'fontsize',14);
end


