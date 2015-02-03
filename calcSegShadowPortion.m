function [segObj] = calcSegShadowPortion(seg, segObj, imGt)
%CALCSEGSHADOWPORTION Calculates segment shadow portion, and decide whether
% it is shadow by comparing with ground truth
%
%   Input:
%       - seg: segment map
%       - segObj: segment object
%       - imGt: the ground truth image in double, grayscale
%
%   Output:
%       - segObj: containing the new field 
%           - shadowPortion: the percentage of shadow pixel
%           - isShadow: true( >= 0.5) or false(< 0.5)
%
%   - White, >= 0.5, shadow
%   - Black, < 0.5, non-shadow

segNum = length(segObj);

for i = 1:segNum
    % getting targeted pixels
    minusMask = double(seg);
    minusMask(minusMask~=i) = -2; % non-target area set to -2
    minusMask(minusMask==i) = 0; % target area set to 0
    targetGt = imGt + minusMask; % all non-target Gt set to minus
    targetGt = targetGt(targetGt >=0 ); % leave out only the target area
    
    % calculate shadow vs non-shadow
    shadowPixel = length(targetGt(targetGt >= 0.5));
    segObj(i).shadowPortion = double(shadowPixel) / segObj(i).area;
    if segObj(i).shadowPortion >= 0.5
        segObj(i).isShadow = 1.0; % shadow region <- 1
    else
        segObj(i).isShadow = -1.0; % non-shadow region <- -1
    end
end

end