function [ boundary ] = calcSegBoundary( seg, index )
%CALCSEGBOUNDARY Calculate No.index segment's boundary and compress them
%   Input:
%       - seg: int segment matp
%       - index: the targeted segment

targetSeg = zeros(size(seg));
targetSeg(seg == index) = 1;

% calculate gradient with neighbor
targetSetWrap = zeros(size(targetSeg, 1)+2, size(targetSeg, 2)+2);
targetSetWrap(2:end-1, 2:end-1) = targetSeg;
rowUp = targetSetWrap(1:end-2, 2:end-1) - targetSeg;
rowDown = targetSetWrap(3:end, 2:end-1) - targetSeg;
colLeft = targetSetWrap(2:end-1, 1:end-2) - targetSeg;
colRight = targetSetWrap(2:end-1, 3:end) - targetSeg;

% init boundary
numUp = length(rowUp(rowUp==-1));
numDown = length(rowDown(rowDown==-1));
numLeft = length(colLeft(colLeft==-1));
numRight = length(colRight(colRight==-1));
boundary = zeros(numUp + numDown + numLeft + numRight, 4);

% up
[row,col] = find(rowUp == -1);
boundary(1:numUp, :) = ...
    [row-0.5, col-0.5, row-0.5, col+0.5];
% down
[row,col] = find(rowDown == -1);
boundary(numUp+1:numUp+numDown, :) = ...
    [row+0.5, col-0.5, row+0.5, col+0.5];
% left
[row,col] = find(colLeft == -1);
boundary(numUp+numDown+1:numUp+numDown+numLeft, :) = ...
    [row-0.5, col-0.5, row+0.5, col-0.5];
% right
[row,col] = find(colRight == -1);
boundary(numUp+numDown+numLeft+1:end, :) = ...
    [row-0.5, col+0.5, row+0.5, col+0.5];

boundary = compressBoundary(boundary);

end

