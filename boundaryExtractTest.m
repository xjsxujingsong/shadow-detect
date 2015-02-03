
clear;
setPath;
opt.pathData = 'data/';
opt.cacheName = 'cache_06_boundary/';
opt.listName = 'ruiqi_train.m';
opt.pathCache = ['cache/' opt.cacheName];
imList = readFileList('ruiqi_train.m');
imName = imList{1};
cacheTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
load(cacheTargetName);

boundaryCollector = [];
for i = 1:segNum
    boundaryCollector = [boundaryCollector; segObj(i).boundary];
end
disp(size(boundaryCollector));
boundaryCollector = compressBoundary(boundaryCollector);
disp(size(boundaryCollector));

% fig = figure(1);
% imshow(im);
% hold on;
% displayBoundary(boundaryCollector, 'b', 3);

imshow(im);
hold on;
text(0, 200, '*',  'color', 'w', 'HorizontalAlignment', 'left');
