% created by: Zoya Bylinskii, Sept 2014

% Running this file will test different blur and center
% bias parameters on the saliency maps you provide
% for a subset of the MIT ICCV dataset (see below),
% and will choose a single setting of parameters
% (you should modify the code to specify your own
% optimization criteria). These parameters will be
% applied to saliency maps you provide for the
% MIT Saliency Benchmark. The optimizations include
% blur, center bias, and histogram matching to a 
% human fixation map.

%% (1) PREPARATIONS

% ----- COMPUTE saliency maps on subset of ICCV dataset -----
% compute saliency maps on the images in
% ParameterTrainingOnICCV/100_ICCV_STIMULI
salMapDir_ICCV = 'your_path_to_salMaps_of_100_ICCV_images';

% ----- COMPUTE saliency maps on the saliency benchmark images -----
% compute saliency maps on the images from
% http://saliency.mit.edu/BenchmarkIMAGES.zip
salMapDir_benchmark = 'your_path_to_salMaps_of_benchmark_images';

% ----- REPLACE the paths here with your own paths -----
addpath(genpath('../code_forMetrics'));
mainpath = 'full_path_to_ParameterTrainingOnICCV';
resDir_ICCV = 'where_to_put_all_centered_and_blurred_ICCV_maps';
resDir_benchmark = 'where_to_put_adjusted_benchmark_maps';

%% (2) compute an average human fixation histogram 
FIXATIONMAPS =fullfile(mainpath,'ParameterTrainingOnICCV/FIXATIONMAPS');
targetHist = getTargetHist(FIXATIONMAPS);

%% (3) choose best center weight and blur values on ICCV dataset
[optCenter,optBlur] = optimizeParams(mainpath,salMapDir_ICCV,resDir_ICCV,targetHist);

%% (4) adjust benchmark saliency maps by applying chosen center weight and blur
adjustSalMaps(salMapDir_benchmark,resDir_benchmark,optCenter,optBlur,targetHist);

% send your final maps to saliency@mit.edu to receive your benchmark performances

%% if all you want to do is histogram match your final maps
% % note: histogram matching is built into the optimization procedure in cells (3) and (4)
% % run cells (1) and (2) above
% histMatchDir_benchmark = 'where_to_save_histMatched_benchmark_maps';
% histogramMatchMaps(salMapDir_benchmark,histMatchDir_benchmark,targetHist);
