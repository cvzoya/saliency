% created: Tilke Judd, Feb 2011
% updated: Zoya Bylinskii, Aug 2014

% This finds the similarity between two different saliency maps when
% viewed as distributions (equivalent to histogram intersection).
% score=1 means the maps are identical
% score=0 means the maps are completely opposite

function score = similarity(saliencyMap1, saliencyMap2, toPlot)
% saliencyMap1 and saliencyMap2 are 2 real-valued matrices
% if toPlot=1, displays output of similarity computation as well as both maps

if nargin < 3, toPlot = 0; end

map1 = im2double(imresize(saliencyMap1, size(saliencyMap2)));
map2 = im2double(saliencyMap2);

% (1) first normalize the map values to lie between 0-1
% this is done so that models that assign a nonzero
% value to every pixel do not get an artificial performance boost
% (2) then make sure that the map is normalized to sum to 1
% so that the maximum value of score will be 1
if any(map1(:)) % zero map will remain a zero map
    map1= (map1-min(map1(:)))/(max(map1(:))-min(map1(:)));
    map1 = map1/sum(map1(:));
end

if any(map2(:)) % zero map will remain a zero map
    map2= (map2-min(map2(:)))/(max(map2(:))-min(map2(:)));
    map2 = map2/sum(map2(:));
end

score = nan;
if sum(isnan(map1(:)))==length(map1(:)) || sum(isnan(map2(:)))==length(map2(:))
    return;
end

% compute histogram intersection
diff = min(map1, map2);
score = sum(diff(:));

% visual output
if toPlot
    subplot(131); imshow(map1, []);
    subplot(132); imshow(map2, []);
    subplot(133); imshow(diff, []);
    title(['Similar parts = ', num2str(s)]);
    pause;
end