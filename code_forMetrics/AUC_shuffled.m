% created: Zoya Bylinskii, Aug 2014
% Based on code by Ali Borji

% This measures how well the saliencyMap of an image predicts the ground
% truth human fixations on the image. 

% ROC curve created by sweeping through threshold values at fixed step size 
% until the maximum saliency map value;
% true positive (tp) rate correspond to the ratio of saliency map values above 
% threshold at fixation locations to the total number of fixation locations
% false positive (fp) rate correspond to the ratio of saliency map values above 
% threshold at random locations to the total number of random locations 
% (as many random locations as fixations, sampled uniformly from 
% fixationMap ON OTHER IMAGES), averaging over Nsplits number of selections of
% random locations.

function [score,tp,fp] = AUC_shuffled(saliencyMap, fixationMap, otherMap, Nsplits, stepSize, toPlot)
% saliencyMap is the saliency map
% fixationMap is the human fixation map (binary matrix)
% otherMap is a binary fixation map (like fixationMap) by taking the union of
% fixations from M other random images (Borji uses M=10)
% Nsplits is number of random splits
% stepSize is for sweeping through saliency map
% if toPlot=1, displays ROC curve

if nargin < 6, toPlot = 0; end
if nargin < 5, stepSize = .1; end
if nargin < 4, Nsplits = 100; end

score=nan;

% If there are no fixations to predict, return NaN
if ~any(fixationMap)
    disp('no fixationMap');
    return
end 

% make the saliencyMap the size of fixationMap
if size(saliencyMap, 1)~=size(fixationMap, 1) || size(saliencyMap, 2)~=size(fixationMap, 2)
    saliencyMap = imresize(saliencyMap, size(fixationMap));
end

% normalize saliency map
saliencyMap = (saliencyMap-min(saliencyMap(:)))/(max(saliencyMap(:))-min(saliencyMap(:)));

if sum(isnan(saliencyMap(:)))==length(saliencyMap(:))
    disp('NaN saliencyMap');
    return
end

S = saliencyMap(:);
F = fixationMap(:);
Oth = otherMap(:);

Sth = S(F>0); % sal map values at fixation locations
Nfixations = length(Sth);

% for each fixation, sample Nsplits values from the sal map at locations
% specified by otherMap

ind = find(Oth>0); % find fixation locations on other images

Nfixations_oth = min(Nfixations,length(ind));
randfix = nan(Nfixations_oth,Nsplits);

for i=1:Nsplits
    randind = ind(randperm(length(ind))); % randomize choice of fixation locations
    randfix(:,i) = S(randind(1:Nfixations_oth)); % sal map values at random fixation locations of other random images
end

% calculate AUC per random split (set of random locations)
auc = nan(1,Nsplits);
for s = 1:Nsplits
    
    curfix = randfix(:,s);
    
    allthreshes = fliplr([0:stepSize:double(max([Sth;curfix]))]);
    tp = zeros(length(allthreshes)+2,1);
    fp = zeros(length(allthreshes)+2,1);
    tp(1)=0; tp(end) = 1; 
    fp(1)=0; fp(end) = 1; 
    
    for i = 1:length(allthreshes)
        thresh = allthreshes(i);
        tp(i+1) = sum((Sth >= thresh))/Nfixations;
        fp(i+1) = sum((curfix >= thresh))/Nfixations_oth;
    end

    auc(s) = trapz(fp,tp);
end

score = mean(auc); % mean across random splits

if toPlot
    subplot(121); imshow(saliencyMap, []); title('SaliencyMap with fixations to be predicted');
    hold on;
    [y, x] = find(fixationMap);
    plot(x, y, '.r');
    subplot(122); plot(fp, tp, '.b-');   title(['Area under ROC curve: ', num2str(score)])
end
