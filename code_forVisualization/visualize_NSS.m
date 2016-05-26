% Plot the per-pixel normalized scanpath saliency value, for a saliency map
% that is used to approximate a set of fixations.

% Zoya Bylinskii, April 2016
% linked to: "What do different evaluation metrics tell us about saliency models?"

% Note: if comparing multiple saliency maps, compute the resMap for each of 
% the saliency maps using this function, but then normalize them jointly
% before plotting (to make range of values comparable across plots).

function [resMap,figtitle] = visualize_NSS(salMap, fixations, toplot)
% salMap is the saliency map
% fixations is a binary map of fixation locations
% if only plotting one map, set toplot=1; but if comparing multiple maps,
% see note above

if nargin < 3
    toplot = 1;
end

figtitle = 'Normalized saliency';

% format, resize, and normalize maps
map1 = im2double(fixations); 
map2 = im2double(imresize(salMap, size(fixations)));
map2 = (map2 - mean(map2(:))) / std(map2(:)); 

resMap = zeros(size(fixations));
resMap(map1>0) = map2(map1>0);
se = strel('disk',15);
resMap = imdilate(resMap,se);

% plot the visualization
if toplot
    figure; 
    resMap_norm = resMap/max(resMap(:)); 
    imshow(resMap_norm); 
    colormap('parula'); colorbar;
    title(figtitle,'fontsize',14);
end

