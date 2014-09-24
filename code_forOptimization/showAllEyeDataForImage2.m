function [collectedEyeData, img, fixMap] = showAllEyeDataForImage2(filename, FixationDB, STIMULI, HASH)

if strcmp(filename(end-2:end), 'jpg')
    stimname = filename(1:end-4);
elseif strcmp(filename(end-2:end), 'mat')
    stimname = filename(1:end-4);
else
    disp('filename not .mat or .jpg');
end

if exist(fullfile(STIMULI, strcat(stimname, '.jpg')))
    img = imread(fullfile(STIMULI, strcat(stimname, '.jpg')));
else
    fprintf('image file not found\n')
    fullfile(STIMULI, strcat(stimname, '.jpg'))
    collectedEyeData = [];
    img = NaN;
    fixMap = NaN;
    return
end

% get the eyetracking data from the FixationDB
load(HASH);
index = hash.(stimname);
collectedEyeData = FixationDB(index).fixationData;
[users{1:length(collectedEyeData)}] = deal(collectedEyeData.user);
fixMap = zeros(size(img, 1), size(img, 2));

for u=1:length(users)

    appropFix = collectedEyeData(u).appropFix;
    
    % create new image with fixations and save
    for j=1:size(appropFix, 1)
        pt = appropFix(j, :);
        fixMap(pt(2), pt(1))=1;
    end
    
end



