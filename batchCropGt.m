% batch crop(resize) the ground truth to the original

opt.pathData = 'data/';
setPath;
allList = readFileList('all_list.m');

for i = 1:length(allList)
    imName = allList{i};
    
    originalTarget = [opt.pathData, 'original/', imName, '.jpg'];
    gtTarget = [opt.pathData, 'gt/', imName, '.png'];
    
    im = imread(originalTarget);
    imGt = imread(gtTarget);
    
    if size(imGt, 1) ~= size(im, 1) || size(imGt, 2) ~= size(im, 2)
        fprintf('%s Original: %d*%d; Gt: %d*%d\n', imName, ...
            size(im, 1), size(im, 2), size(imGt, 1), size(imGt, 2));
        imGt = imresize(imGt, [size(im, 1), size(im, 2)]);
        fprintf('  -> %s Original: %d*%d; Gt: %d*%d\n', imName, ...
            size(im, 1), size(im, 2), size(imGt, 1), size(imGt, 2));
        imwrite(imGt, gtTarget, 'png');
    end
    
end