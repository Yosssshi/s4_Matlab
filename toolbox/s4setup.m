function path = s4setup(varargin)
% 4SSETUP: set up s4Matlab, include path and other

% Authors: Yoshihiro Fukuhara

% Copyright (C) 2016-09 Yoshihiro Fukuhara (Yosssshi).
% All rights reserved.

% flags for other libs
addVlFeat = true;

% add path
[a,b,c] = fileparts(mfilename('fullpath')) ;
[a,b,c] = fileparts(a) ;
root = a ;

addpath(fullfile(root,'toolbox'             )) ;

fprintf('s4Matlab ready.\n');

% add other libs
if addVlFeat; vlsetup(); end % VLFeat

if nargout == 0
    clear path ;
end

% sub function add VLFeat %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vlsetup(varagin)
pathVlFeatRoot = '/local2/yoshi/localscratch/libs/vlfeat-0.9.20';

% option
noprefix = false ;
quiet = true ;
xtest = false ;
demo = false ;

% add path
if exist(pathVlFeatRoot)
    addpath(fullfile(pathVlFeatRoot,'toolbox'             )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','aib'       )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','geometry'  )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','imop'      )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','kmeans'    )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','misc'      )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','mser'      )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','plotop'    )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','quickshift')) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','sift'      )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','special'   )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','slic'      )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','gmm'       )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','vlad'      )) ;
    addpath(fullfile(pathVlFeatRoot,'toolbox','fisher'    )) ;

    if vl_isoctave()
      addpath(genpath(fullfile(pathVlFeatRoot,'toolbox','mex','octave'))) ;
      warning('off', 'Octave:possible-matlab-short-circuit-operator') ;
      pkg load image ;
    else
      bindir = mexext ;
      if strcmp(bindir, 'dll'), bindir = 'mexw32' ; end
      addpath(fullfile(pathVlFeatRoot,'toolbox','mex',bindir)) ;
    end

    if noprefix
      addpath(fullfile(pathVlFeatRoot,'toolbox','noprefix')) ;
    end

    if xtest
      addpath(fullfile(pathVlFeatRoot,'toolbox','xtest')) ;
    end

    if demo
      addpath(fullfile(pathVlFeatRoot,'toolbox','demo')) ;
    end
else
    error('s4setup: pathVlFeatRoot does not exist !\n');
end

if exist('vl_version') == 3
    fprintf('VLFeat %s ready.\n', vl_version) ;
else
    warning('VLFeat does not seem to be installed correctly. Make sure that the MEX files are compiled.') ;
end
