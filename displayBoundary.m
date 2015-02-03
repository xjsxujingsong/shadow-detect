function displayBoundary(boundary, color, lineWidth)
%DISPLAYBOUNDARY
% Input
%   - figHandle: the figure handle
%   - boundary: n * 4 matrix specifying the boundary
%   - color: matlab color code 
%   - lineWidth: usually set to 3
% 
% Modified code from Jean-Francois Lalonde

% convert to boundary cell array
boundaryCell = repmat({[0,0;0,0]}, 1, size(boundary, 1));
for i = 1:size(boundary, 1)
    boundaryCell{i} = [boundary(i, 1:2); boundary(i, 3:4)];
end

% plot each boundaries
cellfun(@(b) plot(b(:,2), b(:,1), 'Color', color, 'LineWidth', lineWidth), boundaryCell);
