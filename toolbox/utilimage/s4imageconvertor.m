function s4imageconvertor(typeIn, typeOut, dirIn, dirOut)
% S4IMAGECONVERTOR: convert image
%
% Authors: Yoshihiro Fukuhara
%
% Copyright (C) 2016-09 Yoshihiro Fukuhara (Yosssshi).
% All rights reserved.

% check dir
if ~exist(dirIn);  error('%s does not exist.\n', dirIn);  end
if ~exist(dirOut); error('%s does not exist.\n', dirOut); end

% build cell array
tmp = dir(fullfile(dirIn, ['*.' typeIn]));
nameCellArray = {tmp.name};

% imread
imArray = [];

for i=1:numel(nameCellArray)
  imArray[i] = imread(fullfile(dirIn, nameCellArray{i}));
end

% imwrite
for i=1:numel(nameCellArray)
  tmp = strsplit(nameCellArray{i},'.');
  name = tmp{1};

  imwrite(imArray[i], fullfile(dirOut, [name '.' typeOut]));
end
