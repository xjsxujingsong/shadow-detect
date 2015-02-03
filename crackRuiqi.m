% run ruiqi training and testing in one file multiple times
clear;

%% list for my annotation 1
imList = readFileList('ruiqi_train.m');
opt.modelName = 'model_07_myAnno01.mat';
opt.cacheName = 'cache_04_myAnno01/';

%% list for ruiqi's annotation
imList = readFileList('ruiqi_train.m');
opt.modelName = 'model_08_ruiqiAnno.mat';
opt.cacheName = 'cache_05_ruiqiAnno/';

% preprocess
%allPreprocess;
allSpecialPreprocess;

% % training
% opt.listName = 'ruiqi_train.m';
% %shadowTraining;
% shadowSpecialTraining;
% 
% % testing
% opt.listName = 'ruiqi_test.m';
% shadowTesting;
% 
% % save to ruiqiAnnoSpecial
% targetName = ['data/ruiqiAnnoSpecial/', opt.modelName];