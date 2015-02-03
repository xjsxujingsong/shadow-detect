% Preprocess all images

%% Set parameters
opt.cacheName = 'cache_06_boundary/';

opt.forceRecalcCache = 1;
opt.enableBfilter = 0;
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];
setPath;

%% Set list
imList = readFileList('all_list.m');
% imList1 = readFileList('ruiqi_train.m');
% imList2 = readFileList('ruiqi_test.m');
% imList = [imList1];

%% Preprocess all
if ~exist([opt.pathData opt.pathCache], 'dir')
    fprintf('Create new directory %s\n', [opt.pathData opt.pathCache]);
    mkdir(opt.pathData,opt.pathCache);
end

allTime = tic;
for i = 1:length(imList)
    imName = imList{i};
    fprintf('Preprocessing %d of %d: %s\n', i, length(imList), imName);
    
    cacheTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
    if opt.forceRecalcCache || ~exist(cacheTargetName, 'file')
        individualTime = tic;
        preprocessIm(imName, opt, cacheTargetName);
        fprintf(' -Time:%f2s\n', toc(individualTime));
    end
end
fprintf('Total time:%f2s\n', toc(allTime));