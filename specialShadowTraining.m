% use ruiqi's annotation to train our SVM

% should disable:
% allPreprocess
% shadowTraining
clear;

setPath;
opt.listName = 'ruiqi_train.m';
opt.cacheName = 'cache_05_ruiqiAnno/';
opt.modelName = 'model_09_ruiqiAnno.mat';
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];
trainList = readFileList(opt.listName);

allSingleSegFeature = [];
allSingleSegLabel = [];

for imIndex = 1:length(trainList)
    imName = trainList{imIndex};
    modelTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
    load(modelTargetName);
    
    % use the singleSegFeature and singleSegLabel directly
    allSingleSegFeature = [allSingleSegFeature; singleSegFeature];
    allSingleSegLabel = [allSingleSegLabel; singleSegLabel];
end

tic;
fprintf('Training...\n');
fprintf('Training size: %d\n', length(allSingleSegLabel));
modelTargetName = ['model/' opt.modelName];
singSegModel = libsvmtrain(allSingleSegLabel, allSingleSegFeature, '-t 5 -b 1');
save(modelTargetName, 'singSegModel');
fprintf('SVM model saved to: %s\n', modelTargetName);
fprintf('SVM train time: %fs\n', toc);