% Plot the per-pixel Pearson's correlation coefficient when two distributions
% are compared.

% Zoya Bylinskii, April 2016
% linked to: "What do different evaluation metrics tell us about saliency models?"

% Note: if comparing multiple saliency maps, compute the resMap for each of 
% the saliency maps using this function, but then normalize them jointly
% before plotting (to make range of values comparable across plots).

function [resMap,figtitle] = visualize_CC(salMap, fixMap, toplot)
% salMap is the saliency model prediction (distribution)
% fixMap is the ground truth fixation map (distribution)
% if only plotting one map, set toplot=1; but if comparing multiple maps,
% see note above

if nargin < 3
    toplot = 1;
end

figtitle = 'Correlation';

% format, resize, and normalize maps
map1 = im2double(fixMap); 
map2 = im2double(imresize(salMap, size(fixMap)));

% compute per-pixel correlation
map1 = (map1 - mean(map1(:))) / std(map1(:)); 
map2 = (map2 - mean(map2(:))) / std(map2(:)); 
resMap = (map1.*map2)./sqrt(sum((map1(:)).^2)+sum((map2(:)).^2));

% plot the visualization
if toplot
    figure; 
    resMap_norm = resMap/max(resMap(:)); 
    imshow(resMap_norm); 
    colormap('parula'); colorbar;
    title(figtitle,'fontsize',14); 
end