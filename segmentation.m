function [seg, segNum, segObj, adjMatrix] = segmentation(im, opt)
%SEGMENTATION Summary of this function goes here
%   Input:
%       - im: the rgb double
%       - opt: for opt.enableBfilter
%   Output:
%       - seg: segment map
%       - segNum: segment number
%       - segObj: segment struct array
%                 {
%                    location: [row1, col1;
%                               row2, col2;
%                               ...]
%                    area: 0
%                    center: [row, col]
%                    shadowPortion: computed in calcSegShadowPortion
%                 }
%       - adjMatrix: adjacent matrix of shared edge length

% apply filter
if opt.enableBfilter
    imBfilter = bfilter2(im, 5, [3 0.1]);
else
    imBfilter = im;
end

% segmentation
[~, seg] = edison_wrapper(imBfilter, @RGB2Luv, ...
'SpatialBandWidth', 9, 'RangeBandWidth', 15, 'MinimumRegionArea', 200);
seg = seg + 1; % start the label from 1
segNum = max(max(seg));

% compute adjacent matrix
adjMatrix = calcAdjMatrix( seg, segNum );

% compute segment object
segObj = repmat(struct(), segNum, 1);
for i = 1:segNum
    [row, col] = find(seg == i);
    segObj(i).location = [row, col];
    segObj(i).area = nnz(seg == i);
    segObj(i).center = [mean(row), mean(col)];
end

end