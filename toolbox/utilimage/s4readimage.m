function [image, scale] = s4readimage(path, varargin)
% S4READIMAGE: read and adjust scale of image
%
% Authors: Yoshihiro Fukuhara
%
% Copyright (C) 2016-09 Yoshihiro Fukuhara (Yosssshi).
% All rights reserved.
%
% Note:
%  if height of image is larger than maxHeight, resize image.
%

% set option
opts = struct(...
                'maxHeight', 480, ...
                'isOrator', false ...
             );

vl_argparse(opts, varargin);

% show opts
if opts.isOrator;
    fprintf('function: s4readimage\n');
    disp('opts:');  disp(opts);
end

% check path
if ~exist(path); error('path: %s does not exist.\n', path); end

% read image
if ischar(path)
    try
        image = imread(path);
    catch
        error('image: %s is corrupted.\n', path);
    end
else
    image = path;
end

% convert to single
image = im2single(image);

% resize
scale = 1;
if (size(image, 1) > opts.maxHeight)
    scale = opts.maxHeight / size(iamge, 1);
    image = imresize(image, scale);
    image = min(max(im,0), 1);
end
