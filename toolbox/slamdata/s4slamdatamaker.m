function slamdata = s4slamdatamaker(varargin)

% set option
opts = struct(...
                'name', 'kitti00im1',...
                'tau', 100,...
                'checkLoopClosure', true,...
                'saveOutput', false,...
                'isOrator', true, ...
                'pathPose', '/local2/yoshi/localscratch/datasets/kitti/kitti00im1/pose/pose-kitti00gt.txt',...
                'pathKeyframe', '/local2/yoshi/localscratch/datasets/kitti/kitti00im1/keyframe/keyframe-kitti00im1.txt',...
                'pathOutput', '/local2/yoshi/localscratch/libs/s4_Matlab/apps/test_tempagg/input/mat/'...
              );

vl_argparse(opts, varargin);

if opts.isOrator
    fprintf('function: slamdatamaker\n');
    disp('opts:');  disp(opts);
end

% scan pose data from txt file
pose = scanpose(opts.pathPose);

% scan keyframe from txt file
isKeyframe = scankeyframe(opts.pathKeyframe);

% compute beta
beta = computebeta(pose, opts.tau);

% getclockdata
[clockArray, clockString] = s4getclockdata();

% check loop closure
if opts.checkLoopClosure
    if opts.isOrator; fprintf('Computing Loop Closure ...\n'); end

    hasLoopClosure = computeloopclosure(pose, opts.tau, beta);
    nLoopClosure = 0;

    fprintf('check loop closure:\n');
    for i=1:size(hasLoopClosure, 2)
        if isequal(hasLoopClosure(1,i), true)
            fprintf('%d\t',i) ;
            nLoopClosure = nLoopClosure + 1;
        end
    end
    fprintf('\n') ;
    fprintf('nLoopClosure: %d\n', nLoopClosure);
end

% output structure
slamdata.name = opts.name;
slamdata.tau  = opts.tau;
slamdata.pose = pose;
slamdata.isKeyframe = isKeyframe;
slamdata.beta = beta;
slamdata.clockArray = clockArray;

if opts.isOrator
    disp('slamdata:');  disp(slamdata);
end

% save
if opts.saveOutput
    if opts.isOrator; fprintf('Saving Output ...\n'); end
    save(fullfile(opts.pathOutput, ['slamdata-' opts.name '-' clockString '.mat']), '-struct', 'slamdata');
end

% scan pose data from txt file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pose = scanpose(path)
% params
nCol = 12;

% open file
if ~exist(path); error('error: %s does not exist.', path); end
fileID = fopen(path, 'r');

    formatString = repmat('%f', 1, nCol);
    dataCell = textscan(fileID, formatString); %'Delimiter', ' ');

% close file
fclose(fileID);

% extract trans data
transXCell = dataCell(:, 4);    transX = cell2mat(transXCell);
transYCell = dataCell(:, 8);    transY = cell2mat(transYCell);
transZCell = dataCell(:, 12);   transZ = cell2mat(transZCell);

pose = cat(2, transX, transY, transZ);
pose = pose';

% scan keyframe from txt file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function isKeyframe = scankeyframe(path)

% open file
if ~exist(path); error('error: %s does not exist.', path); end
fileID = fopen(path, 'r');

    formatString = '%d %f %f %f %f %f %f %f %f';
    dataCell = textscan(fileID, formatString); %, 'Delimiter', ' ');

% close file
fclose(fileID);

% cell 2 array
keyframeCell  = dataCell(:, 1);
keyframeArray = cell2mat(keyframeCell); keyframeArray = keyframeArray';
keyframeArray = 1. + keyframeArray; % adjust start from 0

% make info
isKeyframe = false(1, size(keyframeArray, 2));

for i=1 : size(keyframeArray, 2)
    isKeyframe(1, keyframeArray(1, i)) = true;
end

% compute beta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function beta = computebeta(pose, tau)
% description
% :set beta as harf of mean distance which move during tau frame

% compute mean
mean = 0.0;

for i=1 : size(pose, 2)+1-tau;
    mean = mean + norm(pose(:, i+tau-1) - pose(:, i));
end
mean = mean / size(pose, 2);

beta = 0.3*mean;

% simulate loop closure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hasLoopClosure = computeloopclosure(pose, tau, beta)
% description
% :compute loop closure frame

hasLoopClosure = false(1, size(pose, 2));

for i = tau+1:size(pose, 2)
    j=1;
    while j < i-tau
        if norm(pose(:,i) - pose(:,j)) < beta
            hasLoopClosure(1, i) = true;
            break
        end

        j = j+1;
    end
end
