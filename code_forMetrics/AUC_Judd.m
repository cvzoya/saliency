% created: Tilke Judd, Oct 2009
% updated: Zoya Bylinskii, Aug 2014

% This measures how well the saliencyMap of an image predicts the ground
% truth human fixations on the image. 

% ROC curve created by sweeping through threshold values 
% determined by range of saliency map values at fixation locations;
% true positive (tp) rate correspond to the ratio of saliency map values above 
% threshold at fixation locations to the total number of fixation locations
% false positive (fp) rate correspond to the ratio of saliency map values above 
% threshold at all other locations to the total number of posible other
% locations (non-fixated image pixels)

function [score,tp,fp,allthreshes] = AUC_Judd(saliencyMap, fixationMap, jitter, toPlot)
% saliencyMap is the saliency map
% fixationMap is the human fixation map (binary matrix)
% jitter = 1 will add tiny non-zero random constant to all map locations
% to ensure ROC can be calculated robustly (to avoid uniform region)
% if toPlot=1, displays ROC curve

if nargin < 4, toPlot = 0; end
if nargin < 3, jitter = 1; end
score = nan;

% If there are no fixations to predict, return NaN
if ~any(fixationMap)
    disp('no fixationMap');
    return
end 

% make the saliencyMap the size of the image of fixationMap
if size(saliencyMap, 1)~=size(fixationMap, 1) || size(saliencyMap, 2)~=size(fixationMap, 2)
    saliencyMap = imresize(saliencyMap, size(fixationMap));
end

% jitter saliency maps that come from saliency models that have a lot of
% zero values.  If the saliency map is made with a Gaussian then it does 
% not need to be jittered as the values are varied and there is not a large 
% patch of the same value. In fact jittering breaks the ordering 
% in the small values!
if jitter
    % jitter the saliency map slightly to distrupt ties of the same numbers
    saliencyMap = saliencyMap+rand(size(saliencyMap))/10000000;
end

% normalize saliency map
saliencyMap = (saliencyMap-min(saliencyMap(:)))/(max(saliencyMap(:))-min(saliencyMap(:)));

if sum(isnan(saliencyMap(:)))==length(saliencyMap(:))
    disp('NaN saliencyMap');
    return
end

S = saliencyMap(:);
F = fixationMap(:);
   
Sth = S(F>0); % sal map values at fixation locations
Nfixations = length(Sth);
Npixels = length(S);

allthreshes = sort(Sth, 'descend'); % sort sal map values, to sweep through values
tp = zeros(Nfixations+2,1);
fp = zeros(Nfixations+2,1);
tp(1)=0; tp(end) = 1; 
fp(1)=0; fp(end) = 1;

for i = 1:Nfixations
    thresh = allthreshes(i);
    aboveth = sum(S >= thresh); % total number of sal map values above threshold
    tp(i+1) = i / Nfixations; % ratio sal map values at fixation locations above threshold
    fp(i+1) = (aboveth-i) / (Npixels - Nfixations); % ratio other sal map values above threshold
end 

score = trapz(fp,tp);
allthreshes = [1;allthreshes;0];

if toPlot
    subplot(121); imshow(saliencyMap, []); title('SaliencyMap with fixations to be predicted');
    hold on;
    [y, x] = find(fixationMap);
    plot(x, y, '.r');
    subplot(122); plot(fp, tp, '.b-');   title(['Area under ROC curve: ', num2str(score)])
end
