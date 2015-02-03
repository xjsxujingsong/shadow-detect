function [ fileList ] = readFileList( filename )
%READFILELIST Read line seperated file list and return a string cell
% able to filter out the commented lines with '%' and '#'
%
%   Input:
%       - filename: 'path/filename'
%       - the input file should be a vertical list of strings seperated 
%         by return caracter
%
%   Output:
%       - fileList: a n*1 cell array

% open file
fid = fopen(filename, 'r');
if (fid == 0)
    return;
end
count = 0;

% read lines
tline = fgets(fid);
while ischar(tline)
    if ~(strcmp(tline(1), '%') || strcmp(tline(1), '#'))
        count = count + 1;
        temp = textscan(tline, '%s');
        if ~isempty(temp{1})
            fileList{count} = temp{1}{1};
        end
    end
    tline = fgets(fid);
end

fclose(fid);

end
