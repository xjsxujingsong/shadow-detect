%% Set parameters
opt.cacheName = 'cache_06_boundary/';

opt.forceRecalcCache = 1;
opt.enableBfilter = 0;
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];
setPath;

%% Set list
imList = readFileList('tappen_test.m');

%% Preprocess all
if ~exist([opt.pathData opt.pathCache], 'dir')
    fprintf('Create new directory %s\n', [opt.pathData opt.pathCache]);
    mkdir(opt.pathData,opt.pathCache);
end

sizeCollector = [];
for i = 1:length(imList)
    imName = imList{i};
    %fprintf('Checking %d of %d: %s\n', i, length(imList), imName);
    
    originalTragetName = [opt.pathData 'original/' imName '.jpg'];
    if  ~exist(originalTragetName, 'file')
        fprintf('Error reading: %s\n', imName);
    else
        im = imread(originalTragetName);
        %fprintf('Size: %d, %d\n', size(im, 2), size(im, 1));
        sizeCollector = [sizeCollector; [size(im, 2), size(im, 1)]];
    end
end

sizeCollector = sortrows(sizeCollector);
sizeCollector = [[1:length(sizeCollector)]', sizeCollector]
