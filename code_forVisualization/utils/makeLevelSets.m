% convert a saliency map into a map of colored level sets under the
% specified color map

% Zoya Bylinskii, April 2016
% linked to: "What do different evaluation metrics tell us about saliency models?"

function salMap_col = makeLevelSets(salMap, threshes, colmap)
% salMap is a saliency map (distribution)
% threshes is a list of values [0,1] to threshold the normalized saliency
% map at to create level sets (as many level sets will be created as
% thresholds)
% colmap is a colormap to sample the level set colors from

%%
colmap = flipud(colmap);
threshes = flipud(threshes);
salMap = im2double(salMap);
salMap = (salMap-min(salMap(:)))/(max(salMap(:))-min(salMap(:)));

salMap_col = zeros(size(salMap,1),size(salMap,2),3);

for ii = 1:length(threshes)
    
    for jj = 1:3
        temp = salMap_col(:,:,jj);
        temp(salMap>=threshes(ii)) = colmap(ii,jj);
        salMap_col(:,:,jj) = temp;
    end

end