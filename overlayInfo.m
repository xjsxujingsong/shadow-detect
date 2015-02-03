function overlayInfo(varargin)
%OVERLAYINFO Display text debug info over the original figure
% 
% Input
%   - segObj: compulsory
%   - shadowProb: the probability of shadow outputed by the classifier
%   - 'boundary'
%   - 'index'
%   - 'area'
%   - 'portion'

if nargin <= 1
    return;
end

segObj = varargin{1};
segNum = size(segObj, 1);
inputOption = varargin(2:end);

% boundary
if max(strcmp('boundary', inputOption)) == 1
    boundaryCollector = [];
    for i = 1:segNum
        boundaryCollector = [boundaryCollector; segObj(i).boundary];
    end
    boundaryCollector = compressBoundary(boundaryCollector);
    displayBoundary(boundaryCollector, 'b', 2);
end

% overlay text
for i = 1:segNum
    overlayText{i} = '*';
end

% index
if max(strcmp('index', inputOption)) == 1
    for i = 1:segNum
        overlayText{i} = [overlayText{i}, sprintf('%d; ', i)];
    end
end

% shadow probability
if max(strcmp('shadowProb', inputOption)) == 1
    shadowProb = varargin{2};
    for i = 1:segNum
        overlayText{i} = ...
        [overlayText{i}, sprintf('%.0f%%; ', shadowProb(i, 2)*100)];
    end
end

% size
if max(strcmp('area', inputOption)) == 1
    for i = 1:segNum
        overlayText{i} = [overlayText{i}, sprintf('%d; ', segObj(i).area)];
    end
end

if max([strcmp('index', inputOption), strcmp('shadowProb', inputOption), ...
        strcmp('area', inputOption)]) >= 1
    % display text
    for i = 1:segNum
        text(segObj(i).center(2), segObj(i).center(1), ...
            overlayText{i},  'color', 'r', 'HorizontalAlignment', 'left');
    end
end


end