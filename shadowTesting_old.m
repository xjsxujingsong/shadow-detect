% MATLAB Coordinates
%   -------------> 
%   |         (c or x)
%   |
%   |
%   V (r or y)
%
% black: 0; white: 1

%clear;

%% set up parameters
if ~exist('opt', 'var')
    fprintf('[Warning] opt not set, using the default value.\n');
    opt = {};
end
disp(opt.listName);

% 1 frequent paramenters
if ~isfield(opt, 'listName')
    fprintf('[Warning] opt.listName not set, using the default value.\n');
    opt.listName = 'ruiqi_test.m';
end
if ~isfield(opt, 'modelName')
    fprintf('[Warning] opt.modelName not set, using the default value.\n');
    opt.modelName = 'model_06_ruiqiPortion.mat';
end
if ~isfield(opt, 'cacheName')
    fprintf('[Warning] opt.cacheName not set, using the default value.\n');
    opt.cacheName = 'cache_01/';
end
% 2 less freqeuent paramenters
opt.forceRecalcCache = 0; % Set To ZERO by default!
opt.enableBfilter = 0;
opt.debug = 0;
% 3 auto parameters
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];
%% pre-process the image
setPath;
testList = readFileList(opt.listName);

for i = 1:length(testList)
    % get image name
    imName = testList{i};
    
    % compute and save to cache
    cacheTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
    if opt.forceRecalcCache || ~exist(cacheTargetName, 'file')
        fprintf('Preprocessing %d of %d: %s\n', i, length(testList), imName);
        tic;
        preprocessIm(imName, opt, cacheTargetName);
        fprintf(' -Time:%f2s\n', toc);
    end
end

%% test the image
load(['model/' opt.modelName]);
tPCollector = [];
tNCollector = [];
fPCollector = [];
fNCollector = [];
for i = 1:length(testList)
    imName = testList{i};
    fprintf('Testing %d of %d: %s\n', i, length(testList), imName);
    cacheTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
    load(cacheTargetName);
    gtTargetName = [opt.pathData 'gt/' imName '.png'];
    imGt = imread(gtTargetName);
    imGt = im2double(imGt);
    
    segNum = length(segObj);
    testLabel = zeros(segNum, 1);
    testFeature = singleSegFeature;
    
    [predictedLabel, accuracy, desValues]=libsvmpredict(testLabel, testFeature, singSegModel, '-b 1');
    imShadow = imCalcPredictShadow(seg, segObj, predictedLabel);
    [imDebug, debugInfo] = imDebugShadowSoft(im, imGt, imShadow);
    
    tPCollector = [tPCollector; debugInfo.truePositive.rate];
    tNCollector = [tNCollector; debugInfo.trueNegative.rate];
    fPCollector = [fPCollector; debugInfo.falsePositive.rate];
    fNCollector = [fNCollector; debugInfo.falseNegative.rate];
    
    if opt.debug == 1
        imshow(imDebug); pause;
    end
end

meanTruePositiveRate = mean(tPCollector);
meanTrueNegativeRate = mean(tNCollector);
meanFalsePositiveRate = mean(fPCollector);
meanFalseNegativeRate = mean(fNCollector);

cMatrixShadow_Shadow = meanTruePositiveRate / ...
                       (meanTruePositiveRate + meanFalseNegativeRate);
cMatrixShadow_NonShadow = meanFalseNegativeRate / ...
                       (meanTruePositiveRate + meanFalseNegativeRate);
cMatrixNonShadow_Shadow = meanFalsePositiveRate / ...
                       (meanFalsePositiveRate + meanTrueNegativeRate);
cMatrixNonShadow_Nonshadow = meanTrueNegativeRate / ...
                       (meanFalsePositiveRate + meanTrueNegativeRate);
cMatrix = [cMatrixShadow_Shadow, cMatrixShadow_NonShadow; ...
           cMatrixNonShadow_Shadow, cMatrixNonShadow_Nonshadow];
meanTrueRate = meanTruePositiveRate + meanTrueNegativeRate;
meanFalseRate = meanFalsePositiveRate + meanFalseNegativeRate;

disp('Confusion Matrix:');
disp(cMatrix);
disp('TrueRate:');
disp(meanTrueRate);


