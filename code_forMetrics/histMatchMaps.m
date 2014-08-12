% created: Tilke Judd, March 2011
% updated: Zoya Bylinskii, Aug 2014

function res = histMatchMaps(saliencyMap1, saliencyMap2)
% match saliencyMap2 to saliencyMap1

[COUNTS,X] = imhist(saliencyMap1);
res = histoMatch(saliencyMap2, COUNTS, X);

% display maps and histograms if no output arguments
if nargout == 0
    subplot(231); imshow(saliencyMap1); title(['Map 1'])
    subplot(232); imshow(saliencyMap2); title(['Map 2'])
    subplot(233); imshow(res); title (['Matched map'])
    subplot(234); imhist(saliencyMap1);
    subplot(235); imhist(saliencyMap2);
    subplot(236); imhist(res);
    pause;
end