% Zoya Bylinskii, April 2016

% Code for reproducing the visualizations from the following paper:

% Bylinskii, Z.*, Judd, T.*, Oliva, A., Torralba, A., Durand, F. (2016)
% "What do different evaluation metrics tell us about saliency models?"
% arXiv preprint arXiv:1604.03605 

% If you use any of this visualization code, please cite the paper.

%%
addpath(genpath('utils'));
% download code from https://github.com/cvzoya/saliency/tree/master/code_forMetrics
%addpath(genpath('/Users/Zoya/Dropbox (MIT)/saliencyPageFiles/saliencyCode/code_forMetrics/')); 

im = imread('demo_ims/ALLSTIMULI/i210.jpg');
fixMap = imread('demo_ims/FIXATIONMAPS/i210.jpg'); % ground truth human fixation map (continuous distribution)
fl = load('demo_ims/FIXATIONLOCS/i210.mat');       % ground truth human fixation locations (binary map)
fixations = fl.fixations;

salMap = imread('demo_ims/MODELS/Judd_i210.jpg');   % saliency map (continuous distribution)
salMap2 = imread('demo_ims/MODELS/ittikoch_i210.jpg'); % another saliency map

baseMap = imread('demo_ims/FIXATIONHISTOGRAM/i210.jpg'); % average of fixations over other images 
baseMap = imresize(baseMap,size(fixMap));

%% plot ground truth
figure('name','Ground Truth'); subplot(1,3,1); imshow(im); title('Input image');
subplot(1,3,2); imshow(fixMap); colormap('parula'); freezeColors;
title('Fixation map'); 
subplot(1,3,3); 
se = strel('disk',15);
fixLocs_dil = imdilate(fixations,se);
imshow(fixLocs_dil); colormap('gray'); freezeColors;
title('Fixation locations');

%% visualize Area under ROC curve (AUC) computation
% a set of AUC visualizations that plot the level sets of the saliency map
% at different thresholds, the corresponding true positives and false
% negatives and the resulting ROC curve
visualize_AUC(salMap,fixations);

%% visualize Normalized Scanpath Saliency (NSS) computation
% NSS plotted in parula color scale; higher values mean higher normalized
% saliency at fixated locations
visualize_NSS(salMap,fixations);

%% visualize Kullback-Leibler Divergence (KL) computation
% KL heatmap, with brighter red values corresponding to higher KL
% divergence (salMap fails to sufficiently approximate fixMap at those pixels)
visualize_KL(salMap,fixMap);

%% visualize Similarity (SIM) computation
% histogram intersection, plotted in parula color scale; higher values
% correspond to higher intersection between saliency map and ground truth
% fixation map
visualize_SIM(salMap,fixMap);

%% visualize Pearson's Correlation Coefficient (CC) computation
% correlation coefficient, plotted in parula color scale; higher values
% correspond to higher correlation between saliency map and ground truth
% fixation map
visualize_CC(salMap,fixMap);

% compare 2 models:
% same kind of code can be reused to compare 2 models using any of the
% other metrics as well
[resMap1,figtitle] = visualize_CC(salMap, fixMap, 0);
[resMap2,~] = visualize_CC(salMap2, fixMap, 0);
% joint scaling (for comparison purposes):
maxval = max(max(resMap1(:)),max(resMap2(:)));
resMap1 = resMap1./maxval;
resMap2 = resMap2./maxval;

figure; 
subplot(1,2,1); imshow(resMap1); title('CC for Saliency Map 1');
subplot(1,2,2); imshow(resMap2); title('CC for Saliency Map 2');
colormap('parula');

%% visualize Earth Mover's Distance (EMD) computation
% in green are regions of the saliency map from which density needs to be
% moved to the regions in red to transform salMap to match fixMap
visualize_EMD(salMap2,fixMap);

% note: this takes longer to compute than the other metrics (due to the
% global optimization EMD is performing)

%% visualize Information Gain (IG) computation

% visualize information gain over baseline map
% cyan color scheme corresponds to gain relative to baseline (salMap better
% predicts fixMap at these pixels)
% red color scheme corresponds to loss relative to baseline (baseMap better
% predicts fixMap at these pixels)
[resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(fixMap, salMap, baseMap);

figure; 
subplot(1,3,1); imshow(fixMap); title('Fixation map','fontsize',14);
subplot(1,3,2); imshow(salMap); title('Saliency map','fontsize',14);
subplot(1,3,3); imshow(baseMap); title('Baseline map','fontsize',14);

% visualize information gain of one saliency map over another
[resMap,resMap_pos,resMap_neg,resMap2] = visualize_IG(fixMap, salMap, salMap2);

figure; 
subplot(1,3,1); imshow(fixMap); title('Fixation map','fontsize',14);
subplot(1,3,2); imshow(salMap); title('Saliency map','fontsize',14);
subplot(1,3,3); imshow(salMap2); title({'Saliency map';'(used as baseline)'},'fontsize',14);

