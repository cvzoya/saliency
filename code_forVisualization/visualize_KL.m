% Plot the per-pixel KL divergence when one 2D distribution is used to 
% approximate another.

% Zoya Bylinskii, April 2016
% linked to: "What do different evaluation metrics tell us about saliency models?"

% Note: if comparing multiple saliency maps, compute the resMap for each of 
% the saliency maps using this function, but then normalize them jointly
% before plotting (to make range of values comparable across plots).

function [resMap,figtitle] = visualize_KL(salMap, fixMap, toplot)
% salMap is the saliency model prediction (distribution)
% fixMap is the ground truth fixation map (distribution)
% if only plotting one map, set toplot=1; but if comparing multiple maps,
% see note above

if nargin < 3
    toplot = 1;
end

figtitle = 'KL divergence';

% create the red color map, brighter red corresponds to higher KL
% divergence values
G = linspace(0,1,20)';
fpmap = horzcat(G,zeros(size(G)),zeros(size(G)));

% format, resize, and normalize maps
map1 = im2double(fixMap); 
map2 = im2double(imresize(salMap, size(fixMap)));
map1 = map1/sum(map1(:));
map2 = map2/sum(map2(:));

% compute per-pixel KL divergence
resMap = map1 .* log(eps + map1./(map2+eps)); % map 1 is the target distribution, map 2 the prediction

% plot the visualization
if toplot
    figure; 
    resMap_norm = resMap/max(resMap(:)); 
    imshow(resMap_norm); 
    colormap(fpmap); colorbar;
    title(figtitle,'fontsize',14);
end

