% created by: Zoya Bylinskii, Sept 2014
% based on code by Tilke Judd

% This function applies the chosen center bias
% and blur parameters to the saliency maps
% in salDir to produce the saliency maps in resDir.

function adjustSalMaps(salDir,resDir,centWeight,blurSigma,targetHist,showOutput)
% salDir contains all the saliency map files
% resDir is the output directory for the adjusted saliency maps
% centWeight: the chosen center weight value [0,1]
% blurSigma: the chosen blur value 

assert(centWeight>=0 && centWeight<= 1, 'centWeight must be between 0 and 1');

if nargin < 6, 
    showOutput = 0; 
end

load('center.mat');

if exist(resDir,'dir')
    fprintf('Directory %s already exists. Will overwrite.\n',resDir);
else
    mkdir(resDir)
end

allfiles = dir(salDir);

if showOutput, figure; end

for i = 1:length(allfiles)
    if ~isdir(allfiles(i).name)
        
        fprintf('On %s\n',allfiles(i).name)
        mapOrig = im2double(imread(fullfile(salDir,allfiles(i).name)));
        cent = imresize(center, size(mapOrig));
        map = processMap(mapOrig,cent,targetHist,blurSigma,centWeight,showOutput);
        imwrite(map,fullfile(resDir,allfiles(i).name));

    end
end
