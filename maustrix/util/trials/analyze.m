function varargout =  analyze(inputParams, outputParams, otherParams)
%% 
% The advantage of this new setup is 
% inputParams
%   - subjectID - 'bas060'
%   - recordsPath
%       - neuralRecords
%       - spikeRecords
%       - eyeRecords
%       - analysis
%   - trialRange (no more trial and chunk range that was a useless function)
%       - [200 201 202 205 208]


%% START ERROR CHECKING AND CORRECTION
if ~exist('inputParams','var') || isempty(inputParams)
    error('need a inputParams');
end

% some basic 
makePathsIfNecessary(inputParams.subjectID, inputParams.recordsPath);
[Detect, Sort, Inspect, Analyze, View] = analysisRouters(inputParams.analysisMode);
%% detectspikes
% This happens on a trial by trial basis
if Detect
for tr = inputParams.trialRange
    % Only trials where the spikeDetectionParams are different from
    % the one already stored(if another one is stored) will be detected. 
    reDetect = false;
    
    %  Do I have a neural record file?
    [neuRecExists, neuTimestamp] = findRecord(inputParams.recordsPath.neuralRecords, tr, 'neural');
    if neuRecExists
        [spikeRecExists, spikeTimestamp] = findRecord(inputParams.recordsPath.spikeRecords, tr, 'spike',neuTimestamp);
    end
    
    if neuRecExists && ~spikeRecExists
        reDetect = true;
    end
    
    % Do I have spike record file?
    
    
end
end

%% sortSpikes
% All of this happens on an analysis folder specific way
if Sort
end

%% Inspect
if Inspect
end

%% Analyze
if Analyze
end

%% View
if View
end
end

function makePathsIfNecessary(subjectID, recordsPath)
% LFPRecords
LFPRecordPath = fullfile(recordsPath.analysisLoc,subjectID,'LFPRecords');
if ~exist(LFPRecordPath,'dir')
    [succ, ~, ~] = mkdir(LFPRecordPath);
    if ~succ
        error('LFPRecordPath does not exist and could not create the path.');
    else
        disp('made LFPRecord Path');
    end
end

% spikeRecords
spikeRecordPath = fullfile(recordsPath.analysisLoc,subjectID,'spikeRecords');
if ~exist(spikeRecordPath,'dir')
    [succ, ~, ~] = mkdir(spikeRecordPath);
    if ~succ
        error('spikeRecords does not exist and could not create the path.');
    else
        disp('made spikeRecord Path');
    end
end

% analysis
analysisPath = fullfile(recordsPath.analysisLoc,subjectID,'analysis');
if ~exist(analysisPath,'dir')
    [succ, ~, ~] = mkdir(analysisPath);
    if ~succ
        error('analysis Path does not exist and could not create the path.');
    else
        disp('made analysis records path');
    end
end
end

function [recordExists, timestamp, recordPath] = findRecord(path, trialNum, type, timeStampAvail)

if ~exist('timestampAvail','var') || isempty(timeStampAvail)
    timeStampAvail = '*';
end
recordPath = '';
switch type
    case 'neural'
        dirStr=fullfile(path,sprintf('neuralRecords_%d-%s.mat',trialNum,timeStampAvail));
    case 'spike'
        dirStr=fullfile(path,sprintf('spikeRecords_%d-%s.mat',trialNum,timeStampAvail));
    case 'stim'
        dirStr=fullfile(path,sprintf('stimRecords_%d-%s.mat',trialNum,timeStampAvail));
    case 'eye'
        dirStr=fullfile(path,sprintf('eyeRecords_%d-%s.mat',trialNum,timeStampAvail));
end
d=dir(dirStr);
recordExists = false;
timestamp = '';
if length(d)==1
    % get the timestamp
    [matches, tokens] = regexpi(d(1).name, 'neuralRecords_(\d+)-(.*)\.mat', 'match', 'tokens');
    if length(matches) ~= 1
        %         warning('not a neuralRecord file name');
    else
        timestamp = tokens{1}{2};
    end
    recordExists = true;
elseif length(d)>1
    disp('duplicates present. skipping trial');
else
    disp('didnt find anything in d. skipping trial');
end
end

function [Detect, Sort, Inspect, Analyze, View] = analysisRouters(analysisMode)
switch analysisMode
    case 'overwriteAll'
        [Detect, Sort, Inspect, Analyze, View] = deal(true, true, false, true,  true);
    case 'viewAnalysisOnly'
        [Detect, Sort, Inspect, Analyze, View] = deal(false, false, false, false, true);
    case 'onlyAnalyze'
        [Detect, Sort, Inspect, Analyze, View] = deal(false, false, false, true,  false);
    case 'onlyDetectAndSort'
        [Detect, Sort, Inspect, Analyze, View] = deal(true, true, false, false,  false);
    case 'onlyDetect'
        [Detect, Sort, Inspect, Analyze, View] = deal(true, false, false, false,  false);
    case 'onlySort'
        [Detect, Sort, Inspect, Analyze, View] = deal(false, true, false, false,  false);
    case 'onlySortNoInspect'
        [Detect, Sort, Inspect, Analyze, View] = deal(false, true, false, false,  false);
    case 'onlyInspect'
        [Detect, Sort, Inspect, Analyze, View] = deal(false, false, false, false,  false);
    case 'onlyInspectInteractive'
        [Detect, Sort, Inspect, Analyze, View] = deal(false, false, true, false,  false);
    otherwise
        error('analysisMode: ''%s'' not supported',analysisMode);
end
end