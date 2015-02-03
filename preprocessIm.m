function preprocessIm(imName, opt, targetName)
%%PREPROCESSIM Preprocess image and save to cache
%   This function will:
%       1) segment image
%       2) compute single region features
%           - lab histogram
%           - texton
%       3) determine (non)shadow by gt
%       4) concatinate feature data and labels for SVM
%       5) and save every thing in a cache file
%
%   INPUT
%       - imName
%           - image path: [opt.pathData, 'original/', imName, '.jpg']
%           - ground truth path: [opt.pathData, 'gt/', imName, '.png']
%               > if ground truth not found, then will not save
%                 'imGt', 'singleSegLabel', segObj(i).isShadow
%               > the existGt parameter will store whether GT exist
%       - opt: for controling whether is train or test
%
%   OUTPUT
%       save in teh cache file

% Read image
im = imread([opt.pathData, 'original/', imName, '.jpg']);
im = im2double(im);

% Segmentation
fprintf(' -Segmentation');
[seg, segNum, segObj, adjMatrix] = segmentation(im, opt);

% Get boundary
fprintf(' -Boundary');
for i = 1:segNum
    segObj(i).boundary = calcSegBoundary(seg, i);
end

% Single region feature
fprintf(' -SingleSegFeatures');
featureLab = calcLabHist(im, seg, segNum);
featureTexton = calcTextonHist(im, seg, segNum);
for i = 1:segNum
    segObj(i).feature = [featureLab(i,:), featureTexton(i,:)];
end
singleSegFeature = [featureLab, featureTexton];

% Determine (non)shadow by gt if ground truth exists
gtPath = [opt.pathData, 'gt/', imName, '.png'];
if exist(gtPath, 'file')
    existGt = 1;
    imGt = imread(gtPath);
    if ndims(imGt) > 2 %#ok<*ISMAT>
        imGt = rgb2gray(imGt);
    end
    imGt = im2double(imGt);
    segObj = calcSegShadowPortion(seg, segObj, imGt);
    % concatinate feature data and labels for SVM
    singleSegLabel = zeros(segNum, 1);
    for i = 1:segNum
        singleSegLabel(i) = segObj(i).isShadow;
    end
else
    existGt = 0;
    fprintf(' -GTNotFound');
end

% Save to cache
save(targetName, 'im*', 'seg*', 'adjMatrix', 'feature*', ...
     'segObj', 'singleSeg*', 'existGt');

end








