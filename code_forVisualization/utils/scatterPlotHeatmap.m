% plots the scatter plot with a heatmap so that overlapping points will
% have a larger value
function scatterPlotHeatmap(I,J,colmap,ms)

if nargin < 4, ms = 15; end

if length(unique(I))<=2 || length(unique(J))<=2, return; end

scatres = scatplot(I,J,'squares',[],[],[],[],3,0); % 5
ind = fix((scatres.dd-min(scatres.dd))/(max(scatres.dd)-min(scatres.dd))*(size(colmap,1)-1))+1;
h = [];
%much more efficient than matlab's scatter plot
for k=1:size(colmap,1) 
    if any(ind==k)
        h(end+1) = line('Xdata',I(ind==k),'Ydata',J(ind==k), ...
            'LineStyle','none','Color',colmap(k,:), ...
            'Marker','.','MarkerSize',ms); hold on;
    end
end
