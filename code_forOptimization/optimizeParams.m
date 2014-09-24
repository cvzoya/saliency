% created by: Zoya Bylinskii, Aug 2014
% based on code from Tilke Judd

% This function allows you to compute optimal
% center and blur values on a small subset of 
% the MIT ICCV dataset (see below) by a very simple
% grid search over these values. You can specify
% according to which criteria you want to choose
% these values. This file prints and saves optimal values
% per metric, and returns the optimal values on 
% the ROC metric, but you can choose your own 
% strategy to weight the metrics and select a 
% set of parameters.
% Given the parameters chosen on the ICCV
% dataset, you can apply them to your saliency 
% benchmark maps.

function [optCenter,optBlur] = optimizeParams(mainpath,salMapDir,resDir,targetHist,showOutput)
% mainpath is the full path to ParameterTrainingOnICCV

% PATHS
FIXATIONDB = fullfile(mainpath,'ParameterTrainingOnICCV/ICCVdata/FixationDBCleanedICCV.mat'); % fixation data for dataset
FIXATIONMAPS = fullfile(mainpath,'ParameterTrainingOnICCV/ICCVdata/ALLFIXATIONMAPSICCV/');
STIMULI = fullfile(mainpath,'ParameterTrainingOnICCV/100_ICCV_STIMULI');
HASH = fullfile(mainpath,'ParameterTrainingOnICCV/ICCVdata/hash.mat');
                 
if ~exist(resDir,'dir'), mkdir(resDir); end

if nargin < 5, 
    showOutput = 0; 
end

load('center.mat');
load(FIXATIONDB);

%% PARAMETERS

whichIms = 1:60; % which images to optimize on, from the STIMULI folder
                            % to save time and computation, can only use subset    

metrics = {'S','ROC','ROC_borji','sROC_borji','CC','NSS','EMD'};
metricNames = {'Similarity','AUC-1',...
                          'AUC-2','shuffled AUC','Cross-correlation',...
                          'Normalized Scanpath Saliency','Earth Mover Distance'};
metricOpt = [1,1,1,1,1,1,-1];
% optimal value per metric is either the maximum (1) or the minimum (-1)

sigmaVals = [0,1,10,20,30,40,60,80,100]; % blur parameters to try
centVals = [0:0.1:1]; % center weight parameters to try

nims = length(whichIms);
nsigmas = length(sigmaVals);
ncents = length(centVals);

%% Run code on multiple cores for speed-up
try
    matlabpool open
end

%% Check that files are present and of right format

if isempty(salMapDir), error('%s is empty. Terminating.\n',salMapDir); end
files = dir(fullfile(salMapDir, '*.jpg')); 
if isempty(files)
    error('Could not find image files...'); 
end

%% Create folders of varying blur and center
% NOTE: this code creates AND STORES saliency
% maps for all levels of blur and center, in order
% to be able to visually inspect intermediate
% results created. If you don't want to save all
% these extra images, rewrite this code to 
% combine this cell with the next one, and calculate 
% performance numbers without without saving
% maps.

if 0
% initialize empty directories
fprintf('Creating folders of varying blur and center.\n')
for s = 1:nsigmas
    for w=1:ncents
        curdir = fullfile(resDir,sprintf('center%d_blur%d',w,s));
        mkdir(curdir); 
    end
end

% compute a blurred and centered version of each image
fprintf('Populating folders with images of varying blur and center.\n')

if showOutput, figure; end
parfor i = whichIms %can optimize all files or only a subset

    fprintf('On image %d',i);

    mapOrig = im2double(imread(fullfile(salMapDir, files(i).name)));
    cent = imresize(center, size(mapOrig));

    % try different blur values
    for s = 1:nsigmas

        % try different center weights
        for w=1:ncents

            fprintf('.') % put down one dot for each computation

            % directory for image files
            curdir = fullfile(resDir,sprintf('center%d_blur%d',w,s));
            
            if showOutput, subplot(131); imshow(mapOrig); title('Original'); end

            % first blur map
            if sigmaVals(s)==0
                map = mapOrig;
            else
                gf = fspecial('gaussian', sigmaVals(s)*10, sigmaVals(s));
                map = imfilter(mapOrig,gf,'symmetric');
            end

            % then apply center bias
            map = (map-min(map(:)))/(max(map(:))-min(map(:)));
            map = centVals(w)*cent + (1-centVals(w))*map;
            if showOutput, subplot(132); imshow(map); title('Blurred and centered'); end
            
            % then histogram match map
            map = histoMatch(map, targetHist.counts, targetHist.bins); 
            if showOutput, subplot(133); imshow(map); title('Histogram matched'); end

            % save result
            savefile = fullfile(curdir, files(i).name);
            map = uint8(map*255);
            imwrite(map, savefile);
            
            %pause;
        end
        
        
    end

    fprintf('\n')
    
end
end

%% Test and record performance of each folder (different blur, center values)

% create a file to store all calculated performances
paramsSaveFile = fullfile(resDir, 'params.mat');
if exist(paramsSaveFile,'file')
    load(paramsSaveFile);
end
if 0
folders = dir(fullfile(resDir, 'center*'));

fprintf('Evaluating performance of each folder.\n')

for ii = length(metrics); %1:length(metrics) 
    
    metric = metrics{ii};
    params.(metric).S= nan(ncents,nsigmas);
    params.(metric).scores = nan(ncents,nsigmas,nims);
    
    % test original performance (no center, no blur)
    scores = scoreModel_parallel(salMapDir, metric, 'jpg', FixationDBCleaned, FIXATIONMAPS, STIMULI, HASH);
    params.(metric).orig = scores(whichIms);

    % test all variants of center and blur
    for i = 1:length(folders)
        
        fprintf('On metric %s, folder %s...',metric,folders(i).name); tic
        scores = scoreModel_parallel(fullfile(resDir, folders(i).name), metric, 'jpg', FixationDBCleaned, FIXATIONMAPS, STIMULI, HASH);
        
        temp = regexp(folders(i).name,'center(\d*)_blur(\d*)','tokens');
        temp = temp{1};
        center = str2num(temp{1}); blur = str2num(temp{2});
        
        params.(metric).scores(center,blur,:) = scores;
        params.(metric).S(center,blur) = mean(scores);
        
        save(paramsSaveFile, 'params'); % save results after each iteration, just in case
        fprintf('Done in %2.2f s\n',toc)
    end
    
end
end
%% Replace this with your own code to choose optimal blur, center weight parameters

% this code chooses the best parameters and prints out the best
% performance PER METRIC; you may like to combine all this information to
% choose a single optimal set of parameters

fprintf('Selecting optimal parameters.\n')

for ii =1:length(metrics)
    metric = metrics{ii}; metricName = metricNames{ii};
    
    % get the blur and center weight parameters with highest performance on
    clear S

    S = params.(metric).S;
    if metricOpt(ii)==1
        [bestVal,idx] = max(S(:));
    else
        [bestVal,idx] = min(S(:));
    end
    [center,blur] = ind2sub(size(S),idx);
    
    % obtain the performance with no extra blur or center
    origPerf = params.(metric).orig;
    
    if (metricOpt(ii)==1 && mean(origPerf) >= bestVal) || ...
       (metricOpt(ii)==-1 && mean(origPerf) <= bestVal)
        fprintf('%s performance was best for original model (no extra optimizations).\n\n',metricName);
        optCenterParam = 0;
        optBlurParam = 0;
        scores = origPerf;
    else
        optCenterParam = centVals(center);
        optBlurParam = sigmaVals(blur);
        scores = params.(metric).scores(center,blur,:);
        fprintf('Optimal center weight = %2.2f, blur radius = %2.2f\n',optCenterParam,optBlurParam)
        fprintf('%s performance improves from %2.2f to %2.2f\n\n',metricName,mean(origPerf),bestVal)
    end
    
    params.(metric).optCenterParam = optCenterParam;
    params.(metric).optBlurParam = optBlurParam;
    params.(metric).optScore = scores;
    
    % save the chosen parameter settings
    save(paramsSaveFile, 'params');
    
end

% replace the following with your own choices
optCenter = params.ROC.optCenterParam;
optBlur = params.ROC.optBlurParam;


%% clean-up
try
    matlabpool close
end

fprintf('Done everything.\n')