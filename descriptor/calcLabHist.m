function desc = calcLabHist(rgb_im, seg, numRegion)
% calculate lab histogram of the entire image
%
% input: rgb_im: the rgb image
%        seg: segment marking (int32)
%        numRegion: number of region
%
% This function is adopted from Ruiqi Guo's work in TPAMI(2012)
%

    if ~isa(rgb_im,'uint8'), % is a ... function
        rgb_im = im2uint8(rgb_im);
    end
    
    cform = makecform('srgb2lab'); % make transform
    im = applycform(rgb_im,cform);

    %[hgt wid dummy] = size(im);
    
    % represent histogram in Lab space, 21 bins per channel
    binNum = 21;
    binVal = 0 : 256/(binNum) : 256;
    desc = zeros([numRegion binNum*3]);
    
    cnt = 0;
    ind={};
    for iReg=1:numRegion
        ind{iReg} = seg(:)==iReg;
    end

    for ch=1:3
        for bin=1:binNum
            cnt = cnt + 1;
            I = im(:,:,ch);
            I = ( (I>=binVal(bin)) & (I<binVal(bin+1)) );
            for iReg=1:numRegion
                desc(iReg, cnt) = sum(I(ind{iReg}));
            end
        end
    end
    
    tmp = sum(desc, 2);
    desc = desc ./ repmat(tmp(:), [1 size(desc,2)]);
end
