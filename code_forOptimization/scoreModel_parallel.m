
% created by: Zoya Bylinskii, May 2014
% updated Aug 2014
% built on top of code from Tilke Judd

function [score] = scoreModel_parallel(folder, metric, ext, FixationDBCleaned, FIXATIONMAPS, STIMULI, HASH)

files = dir(fullfile(folder, ['*.',ext]));

score = zeros(length(files), 1);

allmapfiles = cellfun(@(x) fullfile(folder,x), {files().name},'UniformOutput',false);
allmaps = cellfun(@(x) im2double(imread(x)), allmapfiles,'UniformOutput',false);

parfor imnum=1:length(files)

    % find the saliency map
    map = allmaps{imnum};   

    score(imnum) = scoreModel_helper(metric, files, imnum, map, FixationDBCleaned, FIXATIONMAPS, STIMULI, HASH);
    
end

