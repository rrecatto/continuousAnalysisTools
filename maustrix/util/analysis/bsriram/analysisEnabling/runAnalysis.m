function varargout = runAnalysis(varargin)
% minimally need subjectID, channels, thrV, cellBoundary
devOn = false;

if mod(nargin,2)
    error('All inputs should have the format {''type'',value}');
end

for i = 1:nargin/2
    type = varargin{2*i-1};
    value = varargin{2*i};
    switch type
        case 'subjectID'
            subjectID = value;
        case 'channels'
            channels = value;
        case 'thrV'
            thrV = value;
        case 'cellBoundary'
            cellBoundary = value;
        case 'standardParams'
            stdParams = getBasicParams;
        case 'specialParams'
            run(value);
        case 'analysisMode'
            analysisMode = value;
        case 'forceNoInspect'
            if exist('stdParams','var')
                stdParams.otherParams.forceNoInspect = value;
            else
                error('cannot access forceNoInspect without the stdParams');
            end
        case 'addCurrentAnalysis'
            addCurrentAnalysis = value;
        case 'recordsPaths'
            if ~exist('stdParams','var')
                error('cannot set recordsPath first...will be overwritten by standard recordsPaths')
            else
                stdParams.recordsPaths = value;
            end
        case 'intelligentUpdate'
            stdParams.otherParams.intelligentUpdate = value;
        case 'subSampleSpikes'
            stdParams.otherParams.subSampleSpikes = true;
            stdParams.otherParams.subSampleProb = value;
        case 'milliSecondPrecision'
            stdParams.otherParams.milliSecondPrecision = true;
            stdParams.otherParams.pixelOfInterest = value;
        case 'precisionInMS'
            stdParams.otherParams.precisionInMS = value;
        otherwise
            type
            error('unknown type')
    end
end


spikeDetectionParams = stdParams.spikeDetectionParams;
spikeSortingParams = stdParams.spikeSortingParams;
recordsPaths = stdParams.recordsPaths;
timeRangePerTrialSecs = stdParams.timeRangePerTrialSecs;
stimClassToAnalyze = stdParams.stimClassToAnalyze;
otherParams = stdParams.otherParams;
frameThresholds = stdParams.frameThresholds;
makeBackup = stdParams.makeBackup;

if ~exist('addCurrentAnalysis','var')
    addCurrentAnalysis = false;
end
otherParams.addCurrentAnalysis = addCurrentAnalysis;
% now call analysis
switch spikeDetectionParams.method
    case 'oSort'
        spikeDetectionParams.detectionMethod=3; % 1 -> from power signal, 2 threshold positive, 3 threshold negative, 4 threshold abs, 5 wavelet
        spikeDetectionParams.extractionThreshold =6;
        spikeDetectionParams.minmaxVolts=[-1 1];
    case 'filteredThresh'
        if isempty(thrV)
            spikeDetectionParams.threshHoldVolts=thrV;
            spikeDetectionParams.bottomTopCrossingRate=[2 0]; % [2 2] or [2 0]
        end
        defaultMinMax=[-1 1];
        spikeDetectionParams=putThresholdAndMinMaxVoltageInSpikeDetectionParams(spikeDetectionParams,thrV,length(channels),defaultMinMax);
end
switch analysisMode
    case 'onlyDetectAndSort'
%         disp('do you want to continue re detecting???');
%         keyboard
end
result = analyzeBoundaryRange(subjectID, recordsPaths, cellBoundary, channels,spikeDetectionParams, spikeSortingParams,...
    timeRangePerTrialSecs,stimClassToAnalyze,analysisMode,otherParams,frameThresholds,makeBackup);


switch analysisMode
    case 'onlyInspectInteractive'
        disp('Press any key to continue');
        pause
end

if addCurrentAnalysis
    q = questdlg('Do you want to add this to latest analysis?','add analysis','Yes','No','Yes');
    switch q
        case 'Yes'
            
            for i = 1:length(result)
                fields = fieldnames(result(i));
                if length(fields)>1
                    error('enabling add analysis for one trode at a time');
                end
                trodeName = fields{1};
                [currentUnit unitName]= getCurrentUnit(recordsPaths.analysisLoc,subjectID);
                currentUnit = addAnalysis(currentUnit,result(i).(trodeName));
                currentUnit
                save(fullfile(recordsPaths.analysisLoc,subjectID,'analysis','singleUnits',unitName),'currentUnit');
            end
        case 'No'
            % do nothing
        otherwise
            error('unknown response');
    end
end
varargout = {result};
end