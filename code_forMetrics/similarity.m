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

% normalize the values to be between 0-1
if max(map1(:))==0 && min(map1(:))==0 % to avoid dividing by zero if zero image
    map1(100, 100)=1;
else
    map1= (map1-min(map1(:)))/(max(map1(:))-min(map1(:)));
end

if max(map2(:))==0 && min(map2(:))==0
    map2(100, 100)=1; % if uniform map, plot central fixation
else
    map2= (map2-min(map2(:)))/(max(map2(:))-min(map2(:)));
end

% make sure map1 and map2 sum to 1
map1 = map1/sum(map1(:));
map2 = map2/sum(map2(:));

assert(min(map1(:))>=0)
assert(min(map2(:))>=0)
assert(abs(1-sum(map1(:)))<0.001)
assert(abs(1-sum(map2(:)))<0.001)

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