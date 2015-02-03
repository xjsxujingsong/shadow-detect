% visualize shadow portion distribution

%% MATLAB Coordinates
%   -------------> 
%   |         (c or x)
%   |
%   |
%   V (r or y)

% black: 0; white: 1

clear;

%% set up parameters
if ~exist('opt', 'var')
    opt = {};
end
% 1 frequent paramenters
opt.listName = 'all_list.m';
opt.modelName = 'model_06_ruiqiPortion.mat';
opt.cacheName = 'cache_01/';

% 2 less freqeuent paramenters
opt.forceRecalcCache = 0; % set To 0 by default
opt.debugSeg = 0;
opt.enableBfilter = 0;
% 3 auto parameters
opt.pathData = 'data/';
opt.pathCache = ['cache/' opt.cacheName];
setPath;


%% shadow portion histogram
trainList = readFileList(opt.listName);
areaCollector = [];
portionCollector = [];

for imIndex = 1:length(trainList)
    fprintf('portion hist: %d\n', imIndex);
    imName = trainList{imIndex};
    cacheTargetName = [opt.pathData opt.pathCache imName '_cache.mat'];
    load(cacheTargetName);
    for i = 1:segNum
        areaCollector = [areaCollector; segObj(i).area];
        portionCollector = [portionCollector; segObj(i).shadowPortion];
    end
end

figPortionHist = figure(1);
hist(portionCollector, 10);
title('Shadow Portion Histogram','FontSize',14);
xlabel('Shadow Portion','FontSize',14);
ylabel('Number of occurrence','FontSize',14);
simplePrint(figPortionHist, 'portionHist', [420, 250]);

%% portion vs area

maxArea = max(areaCollector);
portionAxis = [];
areaAxis = [];
for i = 1:maxArea
    fprintf('portion vs area: %d\n', i);
    portionList = portionCollector(areaCollector == i);
    if ~isempty(portionList)
        portionAxis = [portionAxis, mean(portionList)];
        areaAxis = [areaAxis, i];
    end
end

figPortionVsSize = figure(2);
plot(areaAxis, portionAxis, '*');
title('Shadow Portion VS Area Size','FontSize',14);
xlabel('Area Size (pixels)','FontSize',14);
ylabel('Shadow Portion','FontSize',14);
simplePrint(figPortionVsSize, 'portionVsSize', [420, 250]);

% %% group to 100 areaAxis
% 
% groupNum = 50;
% groupMeanPortion = [];
% groupMeanArea = [];
% step = ceil((max(max(areaAxis)) - min(min(areaAxis))) / groupNum);
% stepStart = min(min(areaAxis));
% 
% for i = 1:groupNum
%     areaLow = stepStart + (i-1) * step;
%     areaHigh = areaLow + step;
%     targetArea = areaAxis>=areaLow & areaAxis<=areaHigh;
%     targetPortion = portionAxis(targetArea);
%     if length(targetPortion) > 0
%         groupMeanPortion = [groupMeanPortion, mean(targetPortion)];
%         groupMeanArea = [groupMeanArea, (areaLow + areaHigh) / 2];
%     end
% end
% 
% figure();
% plot(groupMeanArea, groupMeanPortion);
% 
















