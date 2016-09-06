function structure = structurefromtxt(path, varargin)
% 4SSTRUCTURE: read txt file and make structure
%
% Authors: Yoshihiro Fukuhara
%
% Copyright (C) 2016-09 Yoshihiro Fukuhara (Yosssshi).
% All rights reserved.
%
% txt file should be include info like following
%
%   % imageRepresentation
%   %:Representation of image
%   NAME: imageRepresentation
%   TYPE: %f
%   NCOL: 3
%   0.01, 0.02, 0.03
%   0.04, 0.05, 0.06
%   0.07, 0.08, 0.09
%   0.10, 0.11, 0.12
%
%  %typeRepresentation
%  %:Type of image representation
%  NAME: typeRepresentation
%  TYPE: %s
%  NCOL: 1
%  vlad

% path check
if ~exist(path); error('path:%s does not exist.', path); end

% open file to read
fileID = fopen(path, 'r');

% read intro
textIntro = textscan(fileID, '%s', 4, 'Delimiter', '\n');
disp(textIntro{1});
skipLines(fileID, 1);

% init
block = 1;
fieldCellArray = {};
while(~feof(fileID))  % for each block

      % scan header
      fprintf('Block: %s\n', num2str(block));
      header = textscan(fileID, '%s', 2, 'Delimiter', '\n');
      headerCell{block, 1} = header{1};
      disp(headerCell{block});

      % scan info
      nameCell = textscan(fileID, 'NAME: %s');
      name = cell2mat(nameCell{:});
      fieldCellArray{block, 1} = name;

      typeCell = textscan(fileID, 'TYPE: %s');
      type = cell2mat(typeCell{:});

      nColCell = textscan(fileID, 'NCOL: %f');
      nCol = cell2mat(nColCell);

      % show info
      fprintf('NAME: %s\n', name);
      fprintf('TYPE: %s\n', type);
      fprintf('NCOL: %d\n', nCol);

      % scan value
      formatString = repmat(type, 1, nCol);
      %textInput = textscan(fileID, formatString, 'Delimiter', ',');

      % convert
      switch type
      case '%d'
        textInput = textscan(fileID, formatString, 'Delimiter', ',');
        data{block, 1} = cell2mat(textInput);
      case '%f'
        textInput = textscan(fileID, formatString, 'Delimiter', ',');
        data{block, 1} = cell2mat(textInput);
      case '%s'
        textInput = textscan(fileID, formatString, nCol, 'Delimiter', '\n');
        data{block, 1} = cell2mat(textInput{:});
        skipLines(fileID, 1);
      otherwise
          error('Unsupported type');
      end

      [nDataRow, nDataCol] = size(data{block});
      fprintf('DATA SIZE: %d x %d\n', nDataRow, nDataCol);
      disp(data{block});
      disp(' ');

      block = block+1;
end

structure = cell2struct(data, fieldCellArray, 1);
disp(structure);

% close file
fclose(fileID);

% subfunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function skipLines(fileID, nLine)
textscan(fileID, '%s', nLine, 'Delimiter', '\n');
