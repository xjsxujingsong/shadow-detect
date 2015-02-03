% MATLAB Coordinates
%   -------------> 
%   |         (c or x)
%   |
%   |
%   V (r or y)
%

clear;

%% set up parameters
% 1 frequent paramenters
opt.crackName = 'ruiqi';
if strcmp(opt.crackName, 'ruiqi')
    opt.listName = 'ruiqi_test.m';
    opt.modelName = 'model_10_ruiqiPortionArea.mat';
elseif strcmp(opt.crackName, 'tappen')
    opt.listName = 'tappen_test.m';
    opt.modelName = 'model_11_tappenPortionArea.mat';
end

opt.cacheName = 'cache_06_boundary/';
% 2 less freqeuent paramenters
opt.forceRecalcCache = 0; % Set To ZERO by default!
opt.enableBfilter = 0;
opt.debug = 1;
% 3 auto parameters
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];

%% pre-process the image
setPath;
testList = readFileList(opt.listName);
disp(opt.listName);

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
tPCollector = []; % true positive number collector
tNCollector = []; % true negative number collector
fPCollector = []; % false positive number collector
fNCollector = []; % false negative number collector
pixelNumCollector = []; % total pixel number collector
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
    
    [predictedLabel, accuracy, shadowProb] = ...
        libsvmpredict(testLabel, testFeature, singSegModel, '-b 1');
    imShadow = imCalcPredictShadow(seg, segObj, predictedLabel);
    [imDebug, debugInfo] = imDebugShadowSoft(im, imGt, imShadow);
    
    tPCollector = [tPCollector; debugInfo.truePositive.num];
    tNCollector = [tNCollector; debugInfo.trueNegative.num];
    fPCollector = [fPCollector; debugInfo.falsePositive.num];
    fNCollector = [fNCollector; debugInfo.falseNegative.num];
    pixelNumCollector = [pixelNumCollector; debugInfo.pixelNum];
    
    if opt.debug == 1
        fig = figure(1);
        clf('reset');
        imshow(imDebug);
        hold on;
        overlayInfo(segObj, shadowProb, 'boundary');
        %pause;
        print(fig, '-dpng', [opt.pathData 'imDebug/' imName '_imDebug.png']);
    end
end

sumTruePositive = sum(tPCollector);
sumTrueNegative = sum(tNCollector);
sumFalsePositive = sum(fPCollector);
sumFalseNegative = sum(fNCollector);
sumPixelNum = sum(pixelNumCollector);

cMatrixShadow_Shadow = sumTruePositive / ...
                       (sumTruePositive + sumFalseNegative);
cMatrixShadow_NonShadow = sumFalseNegative / ...
                       (sumTruePositive + sumFalseNegative);
cMatrixNonShadow_Shadow = sumFalsePositive / ...
                       (sumFalsePositive + sumTrueNegative);
cMatrixNonShadow_Nonshadow = sumTrueNegative / ...
                       (sumFalsePositive + sumTrueNegative);
cMatrix = [cMatrixShadow_Shadow, cMatrixShadow_NonShadow; ...
           cMatrixNonShadow_Shadow, cMatrixNonShadow_Nonshadow];

trueRate = (sumTruePositive + sumTrueNegative) / sumPixelNum;

disp('Confusion Matrix:');
disp(cMatrix);
disp('TrueRate:');
disp(trueRate);


