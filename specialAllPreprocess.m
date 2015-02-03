% Preprocess all images for ruiqi anno

%% set paths
opt.listName = 'ruiqi_train.m';
opt.cacheName = 'cache_05_ruiqiAnno/';
opt.forceRecalcCache = 1;

opt.enableBfilter = 0;
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];
imList = readFileList('ruiqi_train.m');
setPath;

%% preprocess all
if ~exist([opt.pathData opt.pathCache], 'dir')
    fprintf('Create new directory %s\n', [opt.pathData opt.pathCache]);
    mkdir(opt.pathData,opt.pathCache);
end

allTime = tic;
for imIndex = 1:length(imList)
    imName = imList{imIndex};
    fprintf('Preprocessing %d of %d: %s\n', imIndex, length(imList), imName);
    
    annoName = ['data/ruiqiAnno/annt_', imName, '.mat'];
    load(annoName);
    
    tic;
    fprintf(' -Segmentation');
    % calculate the missing parameters
    % 1) seg -> resize (omit)
    % 2) segNum, 
    %    segObj
    %       - location
    %       - area
    %       - center
    %       - shadowPortion
    % 3) featureLab, featureTexton, im, imGt
    
    segNum = max(max(seg));
    adjMatrix = calcAdjMatrix( seg, segNum );
    
    % compute segment object
    segObj = repmat(struct(), segNum, 1);
    for i = 1:segNum
        [row, col] = find(seg == i);
        segObj(i).location = [row, col];
        segObj(i).area = nnz(seg == i);
        segObj(i).center = [mean(row), mean(col)];
    end
    
    % single region feature
    fprintf(' -SingleSegFeatures'); 
    featureLab = calcLabHist(im, seg, segNum);
    featureTexton = calcTextonHist(im, seg, segNum);
    for i = 1:segNum
        segObj(i).feature = [featureLab(i,:), featureTexton(i,:)];
    end
    
    % important: only leave allshadow, allnonshadow
    singleSegFeature = [];
    singleSegLabel = [];
    
    for i = 1:size(allshadow, 1)
        targetIndex = allshadow(i);
        singleSegFeature = [singleSegFeature; segObj(targetIndex).feature];
        singleSegLabel = [singleSegLabel; 1];
    end
    
    for i = 1:size(allnonshadow, 1)
        targetIndex = allnonshadow(i);
        singleSegFeature = [singleSegFeature; segObj(targetIndex).feature];
        singleSegLabel = [singleSegLabel; -1];
    end
    
    fprintf(' -Time:%f\n', toc);
    
    % save
    targetName = [opt.pathData opt.pathCache imName '_cache.mat'];
    save(targetName, 'im*', 'seg*', 'adjMatrix', 'feature*', ...
     'segObj', 'singleSeg*');
    
end
fprintf('Total time:%f2s\n', toc(allTime));
