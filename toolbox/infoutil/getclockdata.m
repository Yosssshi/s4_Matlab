function [clockArray, clockString] = getclockdata(varargin)

% opts handling
opts = struct(...
              'isOrator', false ...
              );

vl_argparse(opts, varargin);

% set format
format shortg;

% get clock data as array
clockArray = clock;
clockArray = fix(clockArray);

% convert to string
clockString = sprintf('%04.0f%02.0f%02.0f%02.0f%02.0f%02.0f',clockArray(1), clockArray(2), clockArray(3), clockArray(4), clockArray(5), clockArray(6));

% show result
if opts.isOrator
    disp('clockArray');  disp(clockArray);
    disp('clockString'); disp(clockString);
end
