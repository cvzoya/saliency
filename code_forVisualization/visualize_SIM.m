% Plot the per-pixel histogram intersection value when two distributions
% are compared.

% Zoya Bylinskii, April 2016
% linked to: "What do different evaluation metrics tell us about saliency models?"

% Note: if comparing multiple saliency maps, compute the resMap for each of 
% the saliency maps using this function, but then normalize them jointly
% before plotting (to make range of values comparable across plots).

function [resMap,figtitle] = visualize_SIM(salMap, fixMap, toplot)
% salMap is the saliency model prediction (distribution)
% fixMap is the ground truth fixation map (distribution)
% if only plotting one map, set toplot=1; but if comparing multiple maps,
% see note above

if nargin < 3
    toplot = 1;
end

figtitle = 'Histogram intersection';

% format, resize, and normalize maps
map1 = im2double(fixMap); 
map2 = im2double(imresize(salMap, size(fixMap)));
map1= (map1-min(map1(:)))/(max(map1(:))-min(map1(:)));
map2= (map2-min(map2(:)))/(max(map2(:))-min(map2(:)));

% compute per-pixel histogram interseciton
map1 = map1/sum(map1(:));
map2 = map2/sum(map2(:));
resMap = min(map1, map2);

% plot the visualization
if toplot
    figure; 
    resMap_norm = resMap/max(resMap(:)); 
    imshow(resMap_norm); 
    colormap('parula'); colorbar;
    title(figtitle,'fontsize',14);
end