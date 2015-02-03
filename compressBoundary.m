function [ boundary ] =  compressBoundary( boundary )
%COMPRESSBOUNDARY Compress the boundary by joing horizonal or vertical 
%                 lines together
%
% Input:
%     - boundary: n * 4 boundary matrix
% 
% Output:
%     - cBoundary: the compressed boundary, should have the same display
%                  as the original boundary

% deal with horizional continuous line
boundary = unique(boundary, 'rows');
for i = 1:size(boundary, 1) - 1
    a = boundary(i, 1:2);
    b = boundary(i, 3:4);
    c = boundary(i+1, 1:2);
    d = boundary(i+1, 3:4);
    if (sum(b==c)==2 && a(1) == b(1) && a(1) == c(1) && a(1) == d(1))
        boundary(i, :) = zeros(1, 4);
        boundary(i+1, 1:2) = a;
    end
end
% delete non-zero rows
boundary = unique(boundary, 'rows');
boundary = boundary(sum(boundary, 2) ~= 0, :);

% deal with vertical continuous line
boundary = [boundary(:,2), boundary(:,1), boundary(:,4), boundary(:,3)];
boundary = unique(boundary, 'rows');
for i = 1:size(boundary, 1) - 1
    a = boundary(i, 1:2);
    b = boundary(i, 3:4);
    c = boundary(i+1, 1:2);
    d = boundary(i+1, 3:4);
    if (sum(b==c)==2 && a(1) == b(1) && a(1) == c(1) && a(1) == d(1))
        boundary(i, :) = zeros(1, 4);
        boundary(i+1, 1:2) = a;
    end
end
% delete non-zero rows
boundary = unique(boundary, 'rows');
boundary = boundary(sum(boundary, 2) ~= 0, :);
boundary = [boundary(:,2), boundary(:,1), boundary(:,4), boundary(:,3)];

end


