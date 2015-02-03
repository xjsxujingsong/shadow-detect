function [ adjMatrix ] =  calcAdjMatrix( seg, numSeg )
%CALCNEIGHBOREDGE AdjMatrix with weight (shred edge length)
% 
% Simple implementation: for each pixel calculate its 4 adjacency neighbor
%
% Input:
%     - seg: the image segments, starting from 1
%     - numSeg: (optional) the number of segments
% 
% Output:
%     - adjMatrix: adjacent matrix, where 
%           adjMatrix(i,j) = 0          (i == j)
%                          = edgeLength by 4 adjacency (i != j)
%

% check parameters
if nargin < 2
    numSeg = max(max(seg));
end

% initilize
width = size(seg, 2);
height = size(seg, 1);
adjMatrix = zeros(numSeg, numSeg);

% gradient image
[dx, dy] = gradient(double(seg));
segGradient = abs(dx)+abs(dy);

% calculate adjMatrix with weight
[r, c] = find(segGradient);
for k = 1:length(r)
    i = r(k);
    j = c(k);
    if segGradient(i, j) > 0
        allAdj = [seg(i, j), ...
                  seg(i, max(1, j-1)), ...     % left
                  seg(i, min(width, j+1)), ... % right
                  seg(max(1, i-1), j), ...     % up
                  seg(min(height, i+1), j) ... % down
                 ];
        allAdj = unique(allAdj);
        for x = allAdj
        for y = allAdj
            if x~=y
                adjMatrix(x,y) = adjMatrix(x,y) + 1;
            end
        end
        end
    end
end

end

