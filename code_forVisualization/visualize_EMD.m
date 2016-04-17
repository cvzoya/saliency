% Plot the per-pixel KL divergence when one 2D distribution is used to 
% approximate another.

% Zoya Bylinskii, April 2016
% linked to: "What do different evaluation metrics tell us about saliency models?"

% Note: if comparing multiple saliency maps, compute the resMap for each of 
% the saliency maps using this function, but then normalize them jointly
% before plotting (to make range of values comparable across plots).

function [resMap,figtitle] = visualize_EMD(salMap, fixMap, toplot)
% salMap is the saliency model prediction (distribution)
% fixMap is the ground truth fixation map (distribution)
% if only plotting one map, set toplot=1; but if comparing multiple maps,
% see note above

if nargin < 3
    toplot = 1;
end

figtitle = 'Earth Movers Distance';

% % create the red color map, brighter red corresponds to higher KL
% % divergence values
% G = linspace(0,1,20)';
% fpmap = horzcat(G,zeros(size(G)),zeros(size(G)));

% format and resize maps
map1 = im2double(fixMap); 
map2 = im2double(imresize(salMap, size(fixMap)));

% EMD calculations
[score,distMat,flowMat] = EMD(map2, map1);
resMap1_t = reshape(mean(flowMat.*distMat,1),ceil(size(fixMap)/32));
resMap1_f = reshape(mean(flowMat.*distMat,2),ceil(size(fixMap)/32));
resMap = imfuse(resMap1_f,resMap1_t,'Scaling','joint','ColorChannels',[1 2 0]);
resMap = imresize(resMap,size(fixMap));

% plot the visualization
if toplot
    figure; 
    imshow(resMap); 
    title(figtitle,'fontsize',14);
end

