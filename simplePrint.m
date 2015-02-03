function simplePrint( fig , fileName, size)
%SIMPLEPRINT Save the figure in the desinated format
%   Input:
%       fig: the figure
%       fileName: target file name
%       size: [width, height]

pos = get(gcf,'Position');
pos(3:4) = size;
set(gcf,'Position',pos);
mlf2pdf(fig, fileName);

end

