function imSegShadow = imCalcSegShadow(seg, segObj)
%%IMCALCSEGSHADOW Calculate the segment shadow according to segObj
%   Input
%       - seg:
%       - segObj: 
%
%   Output: [varargout]
%       - imSegShadow: 
%

height = size(seg, 1);
width = size(seg, 2);

% get binary seg shadow
imSegShadow = zeros(height, width);
for i = 1:length(segObj)
    if (segObj(i).isShadow == 1)
        for j = 1:size(segObj(i).location, 1)
            imSegShadow(segObj(i).location(j,1), ...
                        segObj(i).location(j,2)) = 1;
        end
    end
end

imSegShadow = im2double(imSegShadow);

end