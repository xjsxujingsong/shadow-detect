function [ imDebug, debugInfo ] = imDebugShadowSoft( im, imGt, imCalc )
%IMDEBUGSHADOWSOFT Generate Debug image using im, imGt and the calculated
% shadow, softly
%   Input
%       - im: the original image, in RGB
%       - imGt: the ground truth image, in grayscale double
%       - imCalc: the calculated shadow image, in grayscale double
%
%   Output
%       - imDebug: the debug rgb image
%           - Blue (0, 0, 1): truePositive
%           - Red (1, 0, 0): falseNegative shadow->nonshadow
%           - Green (0, 1, 0): falsePositive nonshadow->shadow
%       - debugInfo(struct of stucts)
%           - totalPixel
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
%   The accuracy here are all pixel accuracy
%

addValue = 0.3;

% get image dimension info
height = size(imGt, 1);
width = size(imGt, 2);
totalPixel = height * width;
debugInfo.pixelNum = totalPixel;

% preprocess image
im = im2double(im);
imGray = rgb2gray(im);
im(:,:,1) = imGray;
im(:,:,2) = imGray;
im(:,:,3) = imGray;

imGt = im2double(imGt);
imCalc = im2double(imCalc);

% get binary Gt
imGt(imGt >= 0.5) = 1;
imGt(imGt < 0.5) = -1;

% get binary calculated shadow
imCalc(imCalc >= 0.5) = 1;
imCalc(imCalc < 0.5) = -1;

% create imDebug
imDebug = im;
truePositiveNum = 0;
trueNegativeNum = 0;
falsePositiveNum = 0;
falseNegativeNum = 0;
for r = 1:height
for c = 1:width
    if imGt(r,c) == imCalc(r,c) % true
        if imGt(r, c) == 1 % truePositive -> blue
            imDebug(r, c, 3) = min(imDebug(r, c, 3)+addValue, 1);
            truePositiveNum = truePositiveNum + 1;
        else % trueNegative -> nothing
            trueNegativeNum = trueNegativeNum + 1;
        end
    else % false
        if imGt(r, c) == 1 % falseNegative -> red
            imDebug(r, c, 1) = min(imDebug(r, c, 1)+addValue, 1);
            falsePositiveNum = falsePositiveNum + 1;
        else %falsePositive -> green
            imDebug(r, c, 2) = min(imDebug(r, c, 2)+addValue, 1);
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

end

