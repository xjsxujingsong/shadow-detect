% evaluate the performance of the segmentation algorithm

%% set paramenters
% 1 list name
opt.listName = 'all_list.m';
opt.cacheName = 'cache_06_boundary/';
opt.modelName = 'model_11_tappenPortionArea.mat';
% 2 less freqeuent paramenters
opt.forceRecalcCache = 0; % Set To ZERO by default!
opt.enableBfilter = 0;
opt.debug = 1;
% 3 auto parameters
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];

setPath;
testList = readFileList(opt.listName);
disp(opt.listName);

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
    imGt = im2double(imGt);
    
    segNum = length(segObj);
    testLabel = zeros(segNum, 1);
    testFeature = singleSegFeature;
    
    % get predictedLabel according to gt directly
    predictedLabel = [];
    for j = 1:segNum
        predictedLabel = [predictedLabel; segObj(j).isShadow];
    end
    
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
        overlayInfo(segObj, 'boundary');
        %pause;
        print(fig, '-dpng', [opt.pathData 'segDebug/' imName '_segDebug.png']);
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































