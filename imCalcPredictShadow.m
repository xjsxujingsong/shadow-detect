function [ imShadow ] = imCalcPredictShadow( seg, segObj, predictedLabel )
%IMCALCPREDICTSHADOW Calculate the shadow image according to prediction
%   Input
%       - seg
%       - predictedLabel
%   Output
%       - imShadow
%

height = size(seg, 1);
width = size(seg, 2);

imShadow = zeros(height, width);
for i = 1:length(predictedLabel)
    if (predictedLabel(i)==1)
        for j = 1:size(segObj(i).location, 1)
            imShadow(segObj(i).location(j,1), ...
                     segObj(i).location(j,2)) = 1;
        end
    end
end

end