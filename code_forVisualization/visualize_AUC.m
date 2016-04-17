% plot the ROC curve with associated level set samples and true positive
% and false positive rate calculations

% Zoya Bylinskii, April 2016
% linked to: "What do different evaluation metrics tell us about saliency models?"

function visualize_AUC(salMap,fixations)
% salMap is the saliency map
% fixations is a binary map of fixation locations

npoints = 10; % number of points to sample on ROC curve

% prepare the color map for the correctly detected and missed fixations
colmap = fliplr(colormap(jet(npoints)));
G = linspace(0.5,1,20)';
tpmap = horzcat(zeros(size(G)),G,zeros(size(G))); % green color space
fpmap = horzcat(G,zeros(size(G)),zeros(size(G))); % red color space

% compute AUC-Judd
heatmap = im2double(salMap);
[score,tp,fp,allthreshes] = AUC_Judd(heatmap, fixations);

N = ceil(length(allthreshes)/npoints);
allthreshes_samp = allthreshes(1:N:end);

heatmap_norm = (heatmap-min(heatmap(:)))/(max(heatmap(:))-min(heatmap(:)));

salMap_col = makeLevelSets(heatmap, allthreshes_samp, colmap);
figure; subplot(1,2,1); imshow(salMap_col);

% plot the ROC curve
tp1 = tp(1:N:end); fp1 = fp(1:N:end);
subplot(1,2,2); plot(fp,tp,'b'); hold on;
for ii = 1:npoints
     plot(fp1(ii),tp1(ii),'.','color',colmap(ii,:),'markersize',20); hold on; axis square;
end 
title(sprintf('AUC: %2.2f',score),'fontsize',14);
xlabel('FP rate','fontsize',14); ylabel('TP rate','fontsize',14);

% plot the level sets, one per subplot
figure('name','saliency map level sets');
nplot = floor(npoints/2); % plot every other level set
for ii = 1:nplot
   %temp = heatmap_norm>=allthreshes_samp(ii);   % plot every level set
   temp = heatmap_norm>=allthreshes_samp(2*ii);  % plot every other level set
   temp2 = zeros(size(temp,1),size(temp,2),3);
   temp2(:,:,1) = temp*colmap(2*ii,1); temp2(:,:,2) = temp*colmap(2*ii,2); temp2(:,:,3) = temp*colmap(2*ii,3); 
   subplottight(1,nplot,ii,0.05); imshow(temp2);
end

% plot the fixations falling within and outside of each level set 
figure('name','true positives and false negatives');
for ii = 1:nplot
   % temp = heatmap_norm>=allthreshes_samp(ii); % plot every level set
   temp = heatmap_norm>=allthreshes_samp(2*ii); % plot every other level set
   res = fixations.*temp;
   res_neg = fixations.*(1-temp);
   subplottight(1,nplot,ii,0.05); imshow(temp); hold on; 
   [J,I] = ind2sub(size(res),find(res==1));
   scatterPlotHeatmap(I,J,tpmap);
   [J,I] = ind2sub(size(res_neg),find(res_neg==1));
   scatterPlotHeatmap(I,J,fpmap);
end