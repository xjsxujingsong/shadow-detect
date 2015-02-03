function desc  = calcTextonHistNoInv(rgb_im, seg, numRegion)
% calculate Texton histogram of the entire image
%
% input: rgb_im: the rgb image
%        seg: segment marking (int32)
%        numRegion: number of region
%
% This function is adopted from Ruiqi Guo's work in TPAMI(2012)

if ~isa(rgb_im,'double'),
    rgb_im = double(rgb_im)/256;
end
gray_im = rgb2gray(rgb_im);

load('bsd300_128.mat');
fim = fbRun(fb,gray_im);
im = assignTextons(fim, textons);
[hgt wid] = size(im);

binNum = 128;
binVal = 1:binNum;
desc = zeros([numRegion binNum]);

cnt = 0;
ind={};
for iReg=1:numRegion
    ind{iReg} = seg(:)==iReg;
end

for bin=1:binNum
    cnt = cnt + 1;
    I =  (im(:)==binVal(bin)) ;
    for iReg=1:numRegion
        desc(iReg,cnt) = sum(I(ind{iReg}));
    end
end

tmp = sum(desc, 2);
desc = desc ./ repmat(tmp(:,:), [1 size(desc,2)]);
    
    
end

