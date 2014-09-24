% created by: Zoya Bylinskii, Sept 2014
% based on code by Tilke Judd

% This code applies blur and center bias, as specified
% by the sigmaVal and centVal parameters, respectively.
% The final map is histogram matched to a target
% distribution (targetHist).

function map = processMap(mapOrig,cent,targetHist,sigmaVal,centVal,showOutput)

if nargin < 6, showOutput = 0; end

if showOutput, subplot(131); imshow(mapOrig); title('Original'); end

% first blur map
if sigmaVal==0
    map = mapOrig;
else
    gf = fspecial('gaussian', sigmaVal*10, sigmaVal);
    map = imfilter(mapOrig,gf,'symmetric');
end

% then apply center bias
map = (map-min(map(:)))/(max(map(:))-min(map(:)));
map = centVal*cent + (1-centVal)*map;
if showOutput, subplot(132); imshow(map); title('Blurred and centered'); end

% then histogram match map
map = histoMatch(map, targetHist.counts, targetHist.bins); 
if showOutput, subplot(133); imshow(map); title('Histogram matched'); end

% save result
map = uint8(map*255);

%pause;