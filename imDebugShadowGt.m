function [imDebug, debugInfo] = imDebugShadow(imGt, imCalc)
%%IMDEBUGSHADOWGT Generate Debug image Gt vs calculated shadow
%   Input
%       - imGt: the ground truth image, in grayscale double
%       - imCalc: the calculated shadow image, in grayscale double
%
%   Output
%       - imDebug: the debug rgb image
%           - White (1, 1, 1): truePositive
%           - Black (0, 0, 0): trueNegative
%           - Red (1, 0, 0): falseNegative
%           - Green (0, 1, 0): falsePositive
%       - debugInfo(struct of stucts)
%           - true{ num, rate }
%           - false{ num, rate }
%           - truePositive{ num, rate }
%           - trueNegative{ num, rate }
%           - falsePositive{ num, rate }
%           - falseNegative{ num, rate }
%
%                          CLASSIFICATION
%                          Shadow           Non-shadow
%         Shadow(GT)      'truePositive'   'falseNegative'
%         Non-Shadow(GT)  'falsePositive'  'trueNegative'
%

height = size(imGt, 1);
width = size(imGt, 2);
totalPixel = height * width;

imGt = im2double(imGt);
imCalc = im2double(imCalc);

% get binary Gt
imGt(imGt >= 0.5) = 1;
imGt(imGt < 0.5) = -1;

% get binary calculated shadow
imCalc(imCalc >= 0.5) = 1;
imCalc(imCalc < 0.5) = -1;

% create imDebug
imDebug = zeros(height, width, 3);
truePositiveNum = 0;
trueNegativeNum = 0;
falsePositiveNum = 0;
falseNegativeNum = 0;
for r = 1:height
for c = 1:width
    if imGt(r,c) == imCalc(r,c) % true
        if imGt(r, c) == 1 % truePositive
            imDebug(r, c, :) = 1;
            truePositiveNum = truePositiveNum + 1;
        else % trueNegative
            imDebug(r, c, :) = 0;
            trueNegativeNum = trueNegativeNum + 1;
        end
    else % false
        if imGt(r, c) == 1 % falseNegative
            imDebug(r, c, 1) = 1;
            falsePositiveNum = falsePositiveNum + 1;
        else %falsePositive
            imDebug(r, c, 2) = 1;
            falseNegativeNum = falseNegativeNum + 1;
        end
    end
end
end

% claculate rate
debugInfo.truePositive.num = truePositiveNum;
debugInfo.truePositive.rate = truePositiveNum / totalPixel;

debugInfo.trueNegative.num = trueNegativeNum;
debugInfo.trueNegative.rate = trueNegativeNum / totalPixel;

debugInfo.falsePositive.num = falsePositiveNum;
debugInfo.falsePositive.rate = falsePositiveNum / totalPixel;

debugInfo.falseNegative.num = falseNegativeNum;
debugInfo.falseNegative.rate = falseNegativeNum / totalPixel;

debugInfo.true.num = truePositiveNum + trueNegativeNum;
debugInfo.true.rate = debugInfo.true.num / totalPixel;

debugInfo.false.num = falsePositiveNum + falseNegativeNum;
debugInfo.false.rate = debugInfo.false.num / totalPixel;


% fprintf('Add up to 1 == %f, %f\n', debugInfo.truePositive.rate + ...
%                                    debugInfo.trueNegative.rate + ...
%                                    debugInfo.falsePositive.rate + ...
%                                    debugInfo.falseNegative.rate, ...
%                                    debugInfo.true.rate + ...
%                                    debugInfo.false.rate);

end



