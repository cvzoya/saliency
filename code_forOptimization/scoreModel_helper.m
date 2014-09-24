function score = scoreModel_helper(metric, files, imnum, map, FixationDBCleaned, FIXATIONMAPS, STIMULI, HASH)

score = nan;

switch metric
        case 'ROC'
            % find the ROC performance
            [~, ~, fixations] = showAllEyeDataForImage2(files(imnum).name, FixationDBCleaned, STIMULI, HASH);
            score = AUC_Judd(map, fixations);
            
        case 'S'            
            % find the similarity
            fixMap = im2double(imread(fullfile(FIXATIONMAPS, files(imnum).name)));
            score= similarity(map, fixMap);
            
        case 'EMD'         
            % find the EMD performance           
            fixMap = im2double(imread(fullfile(FIXATIONMAPS, files(imnum).name)));
            score = EMD(map, fixMap);
            
       case 'ROC_borji'
            % find Borji's ROC performance
            [~, ~, fixations] = showAllEyeDataForImage2(files(imnum).name, FixationDBCleaned, STIMULI, HASH);
            score = AUC_Borji(map, fixations);

        case 'sROC_borji'
            % find the shuffled ROC performance
            [~, ~, fixations] = showAllEyeDataForImage2(files(imnum).name, FixationDBCleaned, STIMULI, HASH);
            
            otherMap = zeros(size(fixations));
            
            % choose nOther other images to sample fixations from
            nOther = 10; % number of images to get fixations from 
            otherImInd = [1:(imnum-1),(imnum+1):length(files)]; % indices of images other than the current one
            whichOther = otherImInd(randperm(length(otherImInd))); % randomize choice of images
            
            % accumulate fixations from nOther other images into one
            % fixation map: otherMap
            for ii = 1:nOther
                [~, ~, fixations2] = showAllEyeDataForImage2(files(whichOther(ii)).name, FixationDBCleaned, STIMULI, HASH);
                otherMap = otherMap + imresize(fixations2,size(otherMap));
            end
            
            % find the shuffled AUC score
            score = AUC_shuffled(map, fixations, otherMap);
            
    case 'CC'
            % find the cross correlation performance
            fixMap = im2double(imread(fullfile(FIXATIONMAPS, files(imnum).name)));
            score = CC(map,fixMap);
            
    case 'NSS'
            % find the normalized scanpath saliency
            [~, ~, fixations] = showAllEyeDataForImage2(files(imnum).name, FixationDBCleaned, STIMULI, HASH);
            score = NSS(map,fixations);
 end