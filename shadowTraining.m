%% MATLAB Coordinates
%   -------------> 
%   |         (c or x)
%   |
%   |
%   V (r or y)


clear;

%% set up parameters
if ~exist('opt', 'var')
    opt = {};
end
% 1 frequent paramenters
opt.crackName = 'ruiqi';
if strcmp(opt.crackName, 'ruiqi')
    opt.listName = 'ruiqi_train.m';
    opt.modelName = 'model_10_ruiqiPortionArea.mat';
    opt.filterPortion = 1;
    opt.filterArea = 1;
    opt.shadowPortionThresHigh = 0.96;
    opt.shadowPortionThresLow = 0.20;
    opt.areaThresMin = 10000;
elseif strcmp(opt.crackName, 'tappen')
    opt.listName = 'tappen_train.m';
    opt.modelName = 'model_11_tappenPortionArea.mat';
    opt.filterPortion = 1;
    opt.filterArea = 1;
    opt.shadowPortionThresHigh = 0.96;
    opt.shadowPortionThresLow = 0.20;
    opt.areaThresMin = 2000;
end
opt.cacheName = 'cache_06_boundary/';

% 2 less freqeuent paramenters
opt.forceRecalcCache = 0; % set To 0 by default
opt.debugSeg = 0;
opt.enableBfilter = 0;
% 3 auto parameters
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];
%% pre-process the image if necessary
setPath;
trainList = readFileList(opt.listName);

for i = 1:length(trainList)
    % get image name
    imName = trainList{i};
    
    % preprocess and save to cache
    cacheTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
    if opt.forceRecalcCache || ~exist(cacheTargetName, 'file')
        fprintf('Preprocessing %d of %d: %s\n', i, length(trainList), imName);
        tic;
        preprocessIm(imName, opt, cacheTargetName);
        fprintf(' -Time:%f2s\n', toc);
    end
end

%% debug the segmentation
if opt.debugSeg == 1
    tPCollector = [];
    tNCollector = [];
    fPCollector = [];
    fNCollector = [];
    
    for i = 1:length(trainList)
        imName = trainList{i};
        fprintf('Debugging Segmentation %d of %d: %s\n', ...
            i, length(trainList), imName);
        cacheTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
        load(cacheTargetName);

        % evaluate segmentation algorithm
        imSegShadow = imCalcSegShadow(seg, segObj);
        [imSegDebug, debugInfo] = imDebugShadow(imGt, imSegShadow);
        imshow(imSegDebug); pause;
        tPCollector = [tPCollector; debugInfo.truePositive.rate];
        tNCollector = [tNCollector; debugInfo.trueNegative.rate];
        fPCollector = [fPCollector; debugInfo.falsePositive.rate];
        fNCollector = [fNCollector; debugInfo.falseNegative.rate];
    end
    
    meanTruePositiveRate = mean(tPCollector);
    meanTrueNegativeRate = mean(tNCollector);
    meanFalsePositiveRate = mean(fPCollector);
    meanFalseNegativeRate = mean(fNCollector);
end

%% concatinate training data && training
fprintf('Concatinate...\n');
allSingleSegFeature = [];
allSingleSegLabel = [];
shadowPortionCollector = [];
areaCollector = [];

for i = 1:length(trainList)
    imName = trainList{i};
    modelTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
    load(modelTargetName);
    filterCollector = true(segNum, 1);
    
    % filter the trainining set
    if opt.filterPortion == 1
        filterPortion = [segObj(:).shadowPortion]';
        filterPortion = filterPortion <= opt.shadowPortionThresLow | ...
                         filterPortion >= opt.shadowPortionThresHigh;
        filterCollector = filterCollector & filterPortion;
    end
    if opt.filterArea == 1
        filterArea = [segObj(:).area]';
        filterArea = filterArea >= opt.areaThresMin;
        filterCollector = filterCollector & filterArea;
    end
    
    singleSegFeature = singleSegFeature(filterCollector, 1:end);
    singleSegLabel = singleSegLabel(filterCollector, 1:end);
    
    shadowPortionCollector = [shadowPortionCollector, segObj(:).shadowPortion];
    areaCollector = [areaCollector, segObj(:).area];
    allSingleSegFeature = [allSingleSegFeature; singleSegFeature];
    allSingleSegLabel = [allSingleSegLabel; singleSegLabel];
end

tic;
fprintf('Training...\n');
fprintf('Training size: %d\n', length(allSingleSegLabel));
modelTargetName = ['model/' opt.modelName];
singSegModel = libsvmtrain(allSingleSegLabel, allSingleSegFeature, '-t 5 -b 1');
save(modelTargetName, 'singSegModel');
fprintf('SVM train time: %fs\n', toc);











