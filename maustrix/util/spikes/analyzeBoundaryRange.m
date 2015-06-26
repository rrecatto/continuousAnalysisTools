function varargout = analyzeBoundaryRange(subjectID, recordsPath, cellBoundary, trodes, spikeDetectionParams, spikeSortingParams,...
        timeRangePerTrialSecs, stimClassToAnalyze, analysisMode, otherParams, frameThresholds,makeBackup)
    varargout = {};
devON = false;
if devON
    inputParams.trodes = trodes;
    inputParams.spikeDetectionParams = spikeDetectionParams;
    inputParams.spikeSortingParams = spikeSortingParams;
    inputParams.timeRangePerTrialSecs = timeRangePerTrialSecs;
    inputParams.stimClassToAnalyze = stimClassToAnalyze;
    inputParams.analysisMode = analysisMode;
    inputParams.frameThresholds = frameThresholds;
    inputParams.cellBoundary = cellBoundary;
    outputParams = [];
    otherParams.makeBackup = makeBackup;
    analyze(subjectID, path, inputParams, outputParams, otherParams);
end
%% START ERROR CHECKING AND CORRECTION
if ~exist('subjectID','var') || isempty(subjectID)
    subjectID = 'demo1'; %
end

if ~exist('recordsPath','var') || isempty(recordsPath) % there is a new standard for recordsPath
    % recordsPath = '\\Reinagel-lab.AD.ucsd.edu\RLAB\Rodent-Data\Fan\datanet' % OLD
    recordsPath.neuralRecordLoc = '\\132.239.158.169\datanet_storage\';
    recordsPath.stimRecordLoc = '\\132.239.158.169\datanet_storage\';
    recordsPath.spikeRecordLoc = '\\132.239.158.169\datanet_storage\';
    recordsPath.analysisLoc = '\\132.239.158.169\datanet_storage\';
end

% needed for physLog boundaryType
neuralRecordsPath = fullfile(recordsPath.neuralRecordLoc, subjectID, 'neuralRecords');
neuralRecordsPath
if ~isdir(neuralRecordsPath)
    neuralRecordsPath
    error('unable to find directory to neuralRecords');
end
    %% cellBoundary with support for masking
if ~exist('cellBoundary','var') || isempty(cellBoundary)
    error('cellBoundary must be a valid input argument - default value is too dangerous here!');
else 
    [boundaryRange maskInfo] = validateCellBoundary(cellBoundary);
end
    %% spikeChannelsAnalyzed
if ~exist('trodes','var') || isempty(trodes)
    channelAnalysisMode = 'allPhysChannels';
    trodes={}; % default all phys channels one by one. will be set when we know how many channels
else
    channelAnalysisMode = 'onlySomeChannels';
    % error check
    if ~(iscell(trodes))
        error('must be a cell of groups of channels');
    elseif length(trodes)>1
        warning('going to try multiple leads in analysis...');
    end
        
end
    %% create the analysisPath and see if it exists
[analysisPath analysisDirForRange]= createAnalysisPathString(boundaryRange,recordsPath.analysisLoc,subjectID);
prevAnalysisExists =  exist(analysisPath,'dir');
    %% should we backup the analysis?
if prevAnalysisExists && makeBackup
    backupPath = fullfile(recordsPath.analysisLoc,subjectID,'analysis','backups',sprintf('analysisDirForRange-%s',datestr(now,30)));
    makedir(backupPath);
    [succ,msg,msgID] = movefile(analysisPath, backupPath);  % includes all subdirectory regardless of permissions
    if ~succ
        msg
        error('failed to make backup')
    end
end


    %% validate spikeDetection and spikeSorting Params
if ~exist('spikeDetectionParams','var')
    spikeDetectionParams = [];
end

if ~exist('spikeSortingParams','var')
    spikeSortingParams = [];
end
[validatedParams, spikeDetectionParams, spikeSortingParams, trodes] = validateAndSetDetectionAndSortingParams(spikeDetectionParams,...
    spikeSortingParams,channelAnalysisMode,trodes,analysisPath); 
    %% createAnalysisPaths here
switch analysisMode 
    case {'overwriteAll','detectAndSortOnFirst','detectAndSortOnOnAll','interactiveDetectAndSortOnFirst',...
            'interactiveDetectAndSortOnAll', 'analyzeAtEnd','onlyDetectAndSort','onlyDetect'}
        % if a previous analysis exists, delete it only if
        % ~intelligentUpdate
        if isfield(otherParams,'intelligentUpdate') && otherParams.intelligentUpdate{1}
            % find the folder for a previous analysis that works here.
            intelliMode = otherParams.intelligentUpdate{2};
            intelliCriterion = otherParams.intelligentUpdate{3};
            switch intelliCriterion
                case 'identDetAndSortParams'
                    intelliParams.mode = intelliMode;
                    intelliParams.criterion = intelliCriterion;
                    intelliParams.spikeDetectionParams = spikeDetectionParams;
                    intelliParams.spikeSortingParams = spikeSortingParams;
                otherwise
                    error('unknown criterion for intelligentUpdate');
            end
            previousAnalysisIntelligent = findPrevAnalysisFolder(recordsPath,subjectID,boundaryRange,intelliParams);
            % now transfer relevant stuff from prevAnalysisIntelligent to
            % current directory
            prevBoundaryRange = {previousAnalysisIntelligent(1),[],previousAnalysisIntelligent(2),[]};
            prevAnalysisFolder = createAnalysisPathString(prevBoundaryRange,recordsPath.analysisLoc,subjectID);
            movefile(fullfile(prevAnalysisFolder,'spikeRecords.mat'),fullfile(analysisPath,'spikeRecords.mat'));
            movefile(fullfile(prevAnalysisFolder,'physAnalysis.mat'),fullfile(analysisPath,'physAnalysis.mat'));
            
        else
            if prevAnalysisExists
                [succ,msg,msgID] = rmdir(analysisPath,'s');  % includes all subdirectory regardless of permissions
                if ~succ
                    msg
                    error('failed to remove existing files when running with ''overwriteAll=true''')
                end
                prevAnalysisExists = false;
            end
            % recreate the analysis file
            mkdir(analysisPath);
        end
    case {'viewAnalysisOnly','onlyAnalyze','onlySort','onlySortNoInspect','onlyInspect','onlyInspectInteractive'}
        % do nothing
    otherwise
        error('unknown analysisMode: ''%s''',analysisMode)
end
    %% create the LFPRecord location
    LFPRecordPath = fullfile(recordsPath.analysisLoc,subjectID,'LFPRecords');
    if ~exist(LFPRecordPath,'dir')
        [succ mesg mesgID] = mkdir(LFPRecordPath);
        if ~succ
            error('LFPRecordPath does not exist and could not create the path.');
        end
    end
    %% timeRangePerTrialSecs
if ~exist('timeRangePerTrialSecs','var') || isempty(timeRangePerTrialSecs)
    timeRangePerTrialSecs = [0 Inf]; %all
else
    if timeRangePerTrialSecs(1)~=0
        error('frame pulse detection has not been validated if you do not start at time=0')
        %do we throw out the first pulse?
    end
    if timeRangePerTrialSecs(2)<3
        requestedEndDuration= timeRangePerTrialSecs(2)
        error('frame pulse detection has not been validated if you do not have at least some pulses')
        %do we throw out the first pulse?
    end
end
    %% stimClassToAnalyze
if ~exist('stimClassToAnalyze','var') || isempty(stimClassToAnalyze)
    stimClassToAnalyze='all';
else
    if ~(iscell(stimClassToAnalyze) ) % and they are all chars
        stimClassToAnalyze
        error('must be a cell of chars of SM classes or ''all'' ')
    end
end
    %% usePhotoDiodeSpikes
if ~exist('usePhotoDiodeSpikes','var') || isempty(usePhotoDiodeSpikes)
    if strcmp(analysisMode,'usePhotoDiodeSpikes')
        usePhotoDiodeSpikes=true;
    else
        usePhotoDiodeSpikes = false;
    end
end
    %% otherParams
if ~exist('otherParams','var') || isempty(otherParams)
    otherParams.showSpikeAnalysis = true;
    otherParams.showLFPAnalysis = true;
    otherParams.plotSortingForTesting = true;
    otherParams.pauseForInspect = false;
    otherParams.forceNoInspect = false;
    otherParams.saveFigs = true;
    otherParams.forceErrorOnNoAnalysis = true;
end
    %% frameThresholds
if ~exist('frameThresholds','var') || isempty(frameThresholds)
    frameThresholds.dropBound = 1.5;   %smallest fractional length of ifi that will cause the long tail to be called a drop(s)
    frameThresholds.warningBound = 0.1; %fractional difference that will cause a warning, (after drop adjusting)
    frameThresholds.errorBound = 0.5;   %fractional difference of ifi that will cause an error (after drop adjusting)
    frameThresholds.dropsAcceptableFirstNFrames=2; % first 2 frames won't kill the default quality test               
end
    %% eyeRecordPath
eyeRecordPath = fullfile(recordsPath.eyeRecordLoc,subjectID,'eyeRecords');
if ~isdir(eyeRecordPath)
    mkdir(eyeRecordPath);
end
    %% pauseForInspect
if ~exist('pauseForInspect','var')||isempty(pauseForInspect)
    pauseForInspect = false;
end
%% END ERROR CHECKING

%% SAVE ANALYSISBOUNDARIES
% lets save the analysis boundaries in a file called analysisBoundary
% analysisoundaryFile should have everything required to recreate the analysis. 
analysisBoundaryFile = fullfile(analysisPath,'analysisBoundary.mat');
if exist(analysisBoundaryFile,'file')
    save(analysisBoundaryFile,'boundaryRange','maskInfo','trodes','spikeDetectionParams','spikeSortingParams',...
        'timeRangePerTrialSecs','stimClassToAnalyze','analysisMode','usePhotoDiodeSpikes','otherParams','frameThresholds','-append');
else
    save(analysisBoundaryFile,'boundaryRange','maskInfo','trodes','spikeDetectionParams','spikeSortingParams',...
        'timeRangePerTrialSecs','stimClassToAnalyze','analysisMode','usePhotoDiodeSpikes','otherParams','frameThresholds');
end
%% ANALYSIS LOGICALS SET HERE FOR FIRST PASS
switch analysisMode
    case 'overwriteAll'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(true, true, true, false, true,  true);
    case 'viewFirst'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(false, false, true, false, false,  false);
    case 'buildOnFirst'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(true, true, true, true, false,  true);
    case 'viewAnalysisOnly'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(false, false, false, false, false, true);
    case 'interactiveDetectAndSortOnFirst'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(true, true, false, true, false,  false);
    case 'interactiveDetectAndSortOnAll'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(true, false, false, false, false,  false);
    case 'analyzeAtEnd'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(true, true, false, false, false,  false);
    case 'onlyAnalyze'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(false, false, false, false, true,  false);
    case 'onlyDetectAndSort'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(true, true, true, false, false,  false);
    case 'onlyDetect'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(true, false, false, false, false,  false);
    case 'onlySort'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(false, true, true, false, false,  false);
    case 'onlySortNoInspect'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(false, true, false, false, false,  false);
    case 'onlyInspect'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(false, false, true, false, false,  false);
    case 'onlyInspectInteractive'
        [detectSpikes, sortSpikes, inspect, interactive, analyzeRecords, viewAnalysis] = deal(false, false, true, true, false,  false);
    otherwise
        error('analysisMode: ''%s'' not supported',analysisMode);
end

% above logicals will change over the course of the analysis
%% MAKE SURE EVERYTHING REQUIRED FOR THE ANALYSIS GIVEN THE ANALYSIS MODE EXIST

done = false;
currentTrialNum = boundaryRange(1);
analyzeChunk = true;
    
    
%% LOOP THROUGH TRIALS 
while ~done
    fprintf('analyzing trial number: %d\n',currentTrialNum);
    % how many chunks exist for currentTrialNum?
    %% find the neuralRecords location
    [neuralRecordsExist timestamp] = findNeuralRecordsLocation(neuralRecordsPath, currentTrialNum);
    %% find the stim record locations and available chunks for processing
    chunksAvailable = [];
    if neuralRecordsExist
        stimRecordLocation = fullfile(recordsPath.stimRecordLoc,subjectID,'stimRecords',sprintf('stimRecords_%d-%s.mat',currentTrialNum,timestamp));
        neuralRecordLocation = fullfile(recordsPath.neuralRecordLoc,subjectID,'neuralRecords',sprintf('neuralRecords_%d-%s.mat',currentTrialNum,timestamp));
        LFPRecordLocation = fullfile(LFPRecordPath,sprintf('LFPRecord_%d.mat',currentTrialNum));
        chunksAvailable = getDetailsFromNeuralRecords(neuralRecordLocation,{'numChunks'});
    else
        disp(sprintf('skipping analysis for trial %d',currentTrialNum));
        currentTrialNum = currentTrialNum+1;
        continue
    end
    %% snippeting
    snippet = [];
    snippetTimes = [];
    %% LOOP THROUGH CHUNKS
    doneWithChunks = false;
    
    if ~isempty(chunksAvailable)
    currentChunkInd = chunksAvailable(1);
    else
        %warning('uh oh')
        %keyboard
        warning('this shouldn''t happen but has at least once (trial 65 rat 231, which was not even requested in the analysis, but attempted to be masked out)')
        %hacking past
        currentChunkInd=0;
    end
    
    %% initialize LFPRecord
    LFPRecord = [];
    
    
    while ~doneWithChunks
        %% check if we need to analyze chunk based on input requirements
        analyzeChunk = neuralRecordsExist && verifyAnalysisForChunk(stimRecordLocation, boundaryRange, maskInfo, stimClassToAnalyze, currentTrialNum);
        %% now actually analyze
        if analyzeChunk
            %% SPIKE DETECTION
            if detectSpikes
                % initialize currentSpikeRecord to empty         
                currentSpikeRecord = [];
                %% load and validate neuralRecords and detection and sorting parameters
                neuralRecord = getNeuralRecordForCurrentTrialAndChunk(neuralRecordLocation,currentChunkInd);
                samplingRate = neuralRecord.samplingRate;
                save(analysisBoundaryFile,'samplingRate','-append');
                if ~validatedParams
                    % happens when the number of channels is unknown
                    [validatedParams spikeDetectionParams spikeSortingParams trodes] = ...
                        validateAndSetDetectionAndSortingParams(spikeDetectionParams,...
                        spikeSortingParams,channelAnalysisMode,[],analysisPath,neuralRecord.ai_parameters.channelConfiguration);
                    trodes = {};
                    for currTrode = fieldnames(spikeDetectionParams)'
                        trodes{end+1} = spikeDetectionParams.(currTrode{:}).trodeChans;
                    end
                    % save spikeDetection and spikeSorting params to analysisBoundaryFile
                    save(analysisBoundaryFile,'spikeSortingParams','spikeDetectionParams','trodes','-append');
                end
                %% find the photoInd,pulseInd and allPhysInds of neuralRecords
                photoInd=find(strcmp(neuralRecord.ai_parameters.channelConfiguration,'photodiode'));
                pulseInd=find(strcmp(neuralRecord.ai_parameters.digitalConfigration,'Frames'));
                allPhysInds = find(~cellfun(@isempty, strfind(neuralRecord.ai_parameters.channelConfiguration,'phys')));
                %% filter neuralData (timeRangePerTrialSecs, snippets)
                neuralRecord = filterNeuralRecords(neuralRecord,timeRangePerTrialSecs);
                neuralRecord = addSnippetToNeuralData(neuralRecord,snippet,snippetTimes);
                %% get the spikeRecord
                getSpikeRecordParams.analysisMode = analysisMode;
                getSpikeRecordParams.boundaryRange = boundaryRange;
                getSpikeRecordParams.trialNum = currentTrialNum;
                getSpikeRecordParams.chunkID = currentChunkInd;
                spikeRecord = getSpikeRecords(analysisPath,getSpikeRecordParams);
                %% get Frame details
                temp = stochasticLoad(stimRecordLocation,{'refreshRate'});
                ifi = 1/temp.refreshRate;
                currentSpikeRecord =  getFrameDetails(neuralRecord,pulseInd,photoInd,frameThresholds,ifi,currentTrialNum,...
                    currentChunkInd);
                %% create snippet for next chunk
                [snippet snippetTimes neuralRecord chunkHasFrames] = createSnippetFromNeuralRecords(currentSpikeRecord,...
                    neuralRecord,currentChunkInd,chunksAvailable,currentTrialNum);
                %% some relevant info for future use in deciding analysis
                currentSpikeRecord.chunkHasFrames = chunkHasFrames;
                currentSpikeRecord.trialNum = currentTrialNum;
                currentSpikeRecord.chunkID = currentChunkInd;
                try
                currentSpikeRecord.chunkDuration = neuralRecord.elapsedTime;
                catch
                    currentSpikeRecord.chunkDuration = max(neuralRecord.neuralDataTimes) - min(neuralRecord.neuralDataTimes) ;
                end
                % trialStartTime from the stimRecords
                temp = stochasticLoad(stimRecordLocation,{'trialStartTime'});
                currentSpikeRecord.trialStartTime = datenumFor30(temp.trialStartTime);
                %% update spikeRecord
                updateParams.updateMode = 'frameAnalysis';
                spikeRecord = updateSpikeRecords(updateParams,currentSpikeRecord,spikeRecord);
                spikeRecordFile = fullfile(analysisPath,'spikeRecord.mat');
                if exist(spikeRecordFile,'file')
                    save(spikeRecordFile,'spikeRecord','-append');
                else
                    save(spikeRecordFile,'spikeRecord');
                end
                %% detect relevant spikes (photoDiode or physChans)
                if usePhotoDiodeSpikes
                    currentSpikeRecord = detectPhotoDiodeSpikes(neuralRecord, photoInd,currentSpikeRecord);
                    updateParams.updateMode = 'photoDiodeSpikes';
                    sortSpikes = false;
                else
                    % loop through the necessary trodes
                    for trodeNum = 1:length(trodes)
                        currTrode = trodes{trodeNum};
                        currTrodeName = createTrodeName(currTrode);
                        % which physInds???
                        thesePhysInds = getPhysIndsForTrodeChans(neuralRecord.ai_parameters.channelConfiguration,currTrode);
                        currNeuralData = neuralRecord.neuralData(:,thesePhysInds);
                        currNeuralDataTimes = neuralRecord.neuralDataTimes;
                        currSamplingRate = neuralRecord.samplingRate;
                        currSpikeDetectionParams = spikeDetectionParams.(currTrodeName);
                        currentSpikeRecord = detectSpikeForTrode(currentSpikeRecord,currTrode, trodeNum,...
                            currNeuralData,currNeuralDataTimes,currSamplingRate,currSpikeDetectionParams,...
                            currentTrialNum, currentChunkInd);
                        currentLFPRecord = filterLFPForTrode(currNeuralData,currNeuralDataTimes,currSamplingRate,currSpikeDetectionParams,currTrode);
                    end
                    updateParams.updateMode = 'physSpikes';
                end
                %% update spikeRecord                
                spikeRecord = updateSpikeRecords(updateParams,currentSpikeRecord,spikeRecord);
                LFPRecord = updateLFPRecord(currentLFPRecord,LFPRecord);
                spikeRecordFile = fullfile(analysisPath,'spikeRecord.mat');
                if exist(spikeRecordFile,'file')
                    save(spikeRecordFile,'spikeRecord','-append');
                else
                    save(spikeRecordFile,'spikeRecord');
                end
                save(LFPRecordLocation,'LFPRecord');
                %% now logic for switching the status of detectSpikes
                detectUpdateParams = [];
                detectUpdateParams.analysisMode = analysisMode;
                detectUpdateParams.trialNum = currentTrialNum;
                detectUpdateParams.chunkInd = currentChunkInd;
                detectUpdateParams.boundaryRange = boundaryRange;
                detectUpdateParams.chunksAvailable = chunksAvailable;
                detectSpikes = updateDetectSpikesStatus(detectUpdateParams);
            end            
           
            %% SPIKE SORTING
            if sortSpikes
                % initialize currentSpikeRecord to empty
                currentSpikeRecord = [];
                %% upload spikeRecord if necessary
                if ~exist('spikeRecord','var')
                    getSpikeRecordParams.analysisMode = analysisMode;
                    getSpikeRecordParams.boundaryRange = boundaryRange;
                    getSpikeRecordParams.trialNum = currentTrialNum;
                    getSpikeRecordParams.chunkID = currentChunkInd;
                    spikeRecord = getSpikeRecords(analysisPath,getSpikeRecordParams);
                end
                %% filter Spike Records
                filterParams = setFilterParamsForAnalysisMode(analysisMode, currentTrialNum, currentChunkInd, analysisBoundaryFile);
                filteredSpikeRecord = filterSpikeRecords(filterParams,spikeRecord);
                %% do we have a model file?
                % it either already exists in spikeSortingParams(sent as an active param file) 
                % or was updated during the course of analysis.
                [spikeModel, modelExists] = getSpikeModel(spikeRecord,spikeSortingParams);                
                %% loop through the trodes and sort spikes
                for trodeNum = 1:length(trodes)
                    trodeStr = createTrodeName(trodes{trodeNum});
                    currTrode = trodes{trodeNum};
                    currSpikes = filteredSpikeRecord.(trodeStr).spikes;
                    currSpikeWaveforms = filteredSpikeRecord.(trodeStr).spikeWaveforms;
                    currSpikeTimestamps = filteredSpikeRecord.(trodeStr).spikeTimestamps;
                    if modelExists(trodeNum) && ~isempty(spikeModel.(trodeStr))
                        currSpikeSortingParams.method = 'klustaModel';
                    else
                        currSpikeSortingParams = spikeSortingParams.(trodeStr);
                    end
                    currentSpikeRecord = sortSpikesForTrode(currentSpikeRecord,currTrode,trodeNum,...
                        currSpikes, currSpikeWaveforms,currSpikeTimestamps, currSpikeSortingParams, spikeModel,currentTrialNum,currentChunkInd);
                end
                %% update cumulativeSpikeRecord
                updateParams.updateMode = 'sortSpikes';
                updateParams.updateSpikeModel = ~modelExists;
                spikeRecord = updateSpikeRecords(updateParams,currentSpikeRecord,spikeRecord);
                spikeRecordFile = fullfile(analysisPath,'spikeRecord.mat');
                if exist(spikeRecordFile,'file')
                    save(spikeRecordFile,'spikeRecord','-append');
                else
                    save(spikeRecordFile,'spikeRecord');
                end               
                %% now logic for switching status of sortSpikes
                sortUpdateParams = [];
                sortUpdateParams.analysisMode = analysisMode;
                sortUpdateParams.trialNum = currentTrialNum;
                sortUpdateParams.chunkInd = currentChunkInd;
                sortUpdateParams.boundaryRange = boundaryRange;
                sortUpdateParams.trialDetails = spikeRecord.trialNum;
                sortUpdateParams.chunkDetails = spikeRecord.chunkID;
                sortUpdateParams.chunksAvailable = chunksAvailable;
                sortSpikes = updateSortSpikesStatus(sortUpdateParams);
            end
                    
            %% INSPECT
            if inspect && ~otherParams.forceNoInspect
                
                %% set plottingInfo
                plottingInfo.boundaryRange = boundaryRange;
                plottingInfo.trialNum = currentTrialNum;
                plottingInfo.chunkID = currentChunkInd;                
                %% upload spikeRecord if necessary
                if ~exist('spikeRecord','var')
                    getSpikeRecordParams.analysisMode = analysisMode;
                    getSpikeRecordParams.boundaryRange = boundaryRange;
                    getSpikeRecordParams.trialNum = currentTrialNum;
                    getSpikeRecordParams.chunkID = currentChunkInd;
                    spikeRecord = getSpikeRecords(analysisPath,getSpikeRecordParams);
                end
                %% filter Spike Records
                filterParams.filterMode = 'everythingAvailable';
                filteredSpikeRecord = filterSpikeRecords(filterParams,spikeRecord);
                %% now inspect
                if exist('neuralRecord','var')
                    plottingInfo.samplingRate = neuralRecord.samplingRate;
                    plottingInfo.plotZoom = true;
                    inspectSpikes(interactive, analysisPath,plottingInfo,trodes,filteredSpikeRecord,neuralRecord);
                else
                    plottingInfo.plotZoom = false;
                    if exist('samplingRate','var')
                        plottingInfo.samplingRate = samplingRate;
                    else
                        temp = stochasticLoad(analysisBoundaryFile,{'samplingRate'});
                        if isfield(temp,'samplingRate')
                            plottingInfo.samplingRate = temp.samplingRate;
                        else
                            warning('using hardcodeed value for samplingRate. why is it not stored in analysisBoundary?');
                            plottingInfo.samplingRate = 40000;
                        end
                    end
                    inspectSpikes(interactive,analysisPath,plottingInfo,trodes,spikeRecord);
                end
                %% update the status of inspect
                inspectUpdateParams.trialDetails = spikeRecord.trialNum;
                inspectUpdateParams.chunkDetails = spikeRecord.chunkID;
                inspectUpdateParams.trialNum = currentTrialNum;
                inspectUpdateParams.chunkID = currentChunkInd;
                inspectUpdateParams.boundaryRange = boundaryRange;
                inspectUpdateParams.analysisMode = analysisMode;
                inspect = updateInspectStatus(inspectUpdateParams);
            end
            %% pause for inspect
            if otherParams.pauseForInspect
                pause
            end
            
            %% ANALYSIS ON SPIKERECORD
            if analyzeRecords
                %% initialize analysisdata,stimRecord,and a stimManager obj
                analysisdata = []; %analysis data is set to null to begin with
                stimRecords = stochasticLoad(stimRecordLocation);
                trialClass = stimRecords.stimManagerClass; 
                evalStr = sprintf('sm = %s();',trialClass);
                eval(evalStr);
                %% upload spikeRecord if necessary and filter
                if ~exist('spikeRecord','var')
                    getSpikeRecordParams.analysisMode = analysisMode;
                    getSpikeRecordParams.boundaryRange = boundaryRange;
                    getSpikeRecordParams.trialNum = currentTrialNum;
                    getSpikeRecordParams.chunkID = currentChunkInd;
                    spikeRecord = getSpikeRecords(analysisPath,getSpikeRecordParams);
                end
                % physAnalysis is only supported per trial
                filterParams.filterMode = 'theseTrialsOnlyForAnalysis';
                filterParams.trialRange = currentTrialNum;
                if ~ismember(currentTrialNum,unique(spikeRecord.trialNumForCorrectedFrames) )
                    theseTrials=unique(spikeRecord.trialNumForCorrectedFrames);
                    error(sprintf('these records [%d %d] do not contain the neccesary trial %d... maybe redetect...consider dups in previous analysis',min(theseTrials),max(theseTrials),currentTrialNum))
                end
                filteredSpikeRecord = filterSpikeRecords(filterParams,spikeRecord);
                %% quality metrices
                quality = getQualityForSpikeRecord(filteredSpikeRecord);
                quality = filterQualityMetric(quality,currentChunkInd);
                temp = stochasticLoad(neuralRecordLocation,{'samplingRate'});
                quality.samplingRate = temp.samplingRate;
                %% worthPhysAnalysis?                
                analysisExists = false;
                overwriteAll = true;
                isLastChunkInTrial = (currentChunkInd==max(chunksAvailable));
                 
                doAnalysis = worthPhysAnalysis(sm,quality,analysisExists,overwriteAll,isLastChunkInTrial);
                %% IF OKAY TO ANALYZE
                if doAnalysis
                    %% upload physAnalysis if necessary and get the latest cumulativedata
                    if ~exist('physAnalysis','var')
                        getPhysAnalysisParams.analysisMode = analysisMode;
                        getPhysAnalysisParams.boundaryRange = boundaryRange;
                        getPhysAnalysisParams.trialNum = currentTrialNum;
                        getPhysAnalysisParams.chunkID = currentChunkInd;
                        getPhysAnalysisParams.stimManager = sm;
                        physAnalysis = getPhysAnalysis(analysisPath,getPhysAnalysisParams);
                    end
                    

                    [cumulativedata,trialRange,stimManagerClass,stepName,replaceCumulative] = getRelevantCumulativeData...
                        (physAnalysis,stimRecords,sm,stimRecordLocation);

                    %% get parameters and eye data
                    physAnalysisParameters=getNeuralRecordParameters(neuralRecordLocation,stimRecordLocation,subjectID,...
                            currentTrialNum,currentChunkInd,timestamp,filteredSpikeRecord,spikeDetectionParams);
                    physAnalysisParameters.subjectID = subjectID;
                    physAnalysisParameters.subSampleSpikes = otherParams.subSampleSpikes;
                    physAnalysisParameters.subSampleProb = otherParams.subSampleProb;
                    physAnalysisParameters.milliSecondPrecision = otherParams.milliSecondPrecision;
                    physAnalysisParameters.pixelOfInterest = otherParams.pixelOfInterest;
                    physAnalysisParameters.precisionInMS = otherParams.precisionInMS;
                    eyeData=getEyeRecords(eyeRecordPath, currentTrialNum,timestamp);
                    %% loop through trodes
                    for trodeNum = 1:length(trodes)
                        currTrode = trodes{trodeNum};
                        cumulativedata = analyzeCurrentTrode(currTrode,filteredSpikeRecord,...
                            stimRecords,physAnalysisParameters,cumulativedata,eyeData,currentTrialNum,currentChunkInd);                        
                    end
                    %% update physAnalysis and save it
                    physAnalysis = updatePhysAnalysis(physAnalysis,cumulativedata,replaceCumulative,trialRange,...
                        stimManagerClass,stepName,currentTrialNum);
                    if otherParams.subSampleSpikes||otherParams.milliSecondPrecision
                        physAnalysisFile=fullfile(analysisPath,'physAnalysisTemp.mat');
                    else
                        physAnalysisFile=fullfile(analysisPath,'physAnalysis.mat');
                    end
                    if exist(physAnalysisFile,'file')
                        save(physAnalysisFile,'physAnalysis','-append');
                    else
                        save(physAnalysisFile,'physAnalysis');
                    end
                else
                    %% it came to the end of the trial and then decided not to analyze....why?
                    if xor(isLastChunkInTrial,enableChunkedPhysAnalysis(sm)) && ~otherParams.forceErrorOnNoAnalysis
                        cumulativedata.physAnalysisFailed = true;
                        trialRange = currentTrialNum;
                        replaceCumulative = false;
                        cumulativedata.quality = quality;
                        physAnalysis = updatePhysAnalysis(physAnalysis,cumulativedata,replaceCumulative,trialRange,...
                            stimManagerClass,stepName,currentTrialNum);
                        if otherParams.subSampleSpikes||otherParams.milliSecondPrecision
                            physAnalysisFile=fullfile(analysisPath,'physAnalysisTemp.mat');                     
                        else
                            physAnalysisFile=fullfile(analysisPath,'physAnalysis.mat');                     
                        end
                        if exist(physAnalysisFile,'file')
                            save(physAnalysisFile,'physAnalysis','-append');
                        else
                            save(physAnalysisFile,'physAnalysis');
                        end
                    end
                end
                
                %% now logic for switching status of analyze
                analyzeUpdateParams = [];
                analyzeUpdateParams.analysisMode = analysisMode;
                analyzeUpdateParams.trialNum = currentTrialNum;
                analyzeUpdateParams.chunkInd = currentChunkInd;
                analyzeUpdateParams.boundaryRange = boundaryRange;
                analyzeUpdateParams.chunksAvailable = chunksAvailable;
                analyzeRecords = updateAnalyzeStatus(analyzeUpdateParams);
            end
            
            %% VIEW ANALYSIS
            if viewAnalysis
                %% load physAnalysis if necessary and get the relevant cumulativedata and stimRecords
                if ~exist('physAnalysis','var')
                    classForTrial = getClassForTrial(stimRecordLocation);
                    evalStr = sprintf('sm = %s;',classForTrial);
                    eval(evalStr);
                    getPhysAnalysisParams.analysisMode = analysisMode;
                    getPhysAnalysisParams.boundaryRange = boundaryRange;
                    getPhysAnalysisParams.trialNum = currentTrialNum;
                    getPhysAnalysisParams.chunkID = currentChunkInd;
                    getPhysAnalysisParams.stimManager = sm;
                    physAnalysis = getPhysAnalysis(analysisPath,getPhysAnalysisParams);
                end
                indexForCurrentTrial = getAnalysisIndexForTrial(currentTrialNum,physAnalysis);
                if indexForCurrentTrial==0
                    stimClass = getClassForTrial(stimRecordLocation);
                    evalStr = sprintf('sm = %s',stimClass);
                    eval(evalStr);
                    if enableChunkedPhysAnalysis(sm) || (~enableChunkedPhysAnalysis(sm)&&(currentChunkInd==max(chunksAvailable)))
                        if otherParams.forceErrorOnNoAnalysis
                            error('analysis was not done! please make sure analysis exists before calling viewAnalysis')
                        else
                            disp('analysis was not done! please make sure analysis exists before calling viewAnalysis')
                            analysisAvailable = false;
                        end
                    else
                        analysisAvailable = false;
                    end
                else
                    [cumulativedata, trialRange, stimClass, stepName] = deal(physAnalysis{indexForCurrentTrial}{:});
                    stimRecords = stochasticLoad(stimRecordLocation); % any detail that can be used across trial should exist in the current trial!
                    analysisAvailable = true;
                end
                %% do actual plotting
                if  analysisAvailable
                    %% find number of trodes in cumulative data
                    trodesInAnalysis = fieldnames(cumulativedata);
                    trodesInAnalysis = trodesInAnalysis(~cellfun(@isempty,regexp(trodesInAnalysis,'^trode')));
                    requestedTrodes = {};
                    for currTrodeNum = 1:length(trodes)
                        requestedTrodes{end+1} = createTrodeName(trodes{currTrodeNum});
                    end
                    if ~isempty(setdiff(requestedTrodes,trodesInAnalysis))
                        trodesWithoutAnalysis = setdiff(requestedTrodes,trodesInAnalysis)
                        error('some requested trodes have no analysis done for them');
                    end
                    %% loop through trodes and plot
                    if ~exist('figureList')
                        figureList = {};
                        % figureList~{{stimManagerClass,stepName,trialRange,figInfo.(trodeStr) = figNum},{},{}}
                    end
                    for trodeNum = 1:length(trodes)
                        [figNum figureList] = getRelevantFigForPlotting(figureList,trialRange, stimClass, stepName,trodes,trodeNum);
                        plotNew = true; % new method of plotting using classes
                        if plotNew
                            sm = eval(stimClass);
                            analysisLoc = recordsPath.analysisLoc;
                            stimInfo = cumulativedata.(requestedTrodes{trodeNum}).stimInfo;
                            mon = otherParams.monitor;
                            rS = otherParams.rigState;
                            physAnalysisObj = getPhysAnalysisObject(sm,subjectID,trialRange,trodes{trodeNum},analysisLoc,stimInfo,cumulativedata,mon,rS);
                            % create the fig otherwise this is going to
                            % barf.
                            figure(figNum);
                            plot(physAnalysisObj,figNum);
                        else
                            plotAnalysisForTrode(figNum,figureList{end},cumulativedata,stimRecords,trodes{trodeNum});
                        end
                    end
                    if otherParams.addCurrentAnalysis
                        for currAnalysisNum = 1:length(physAnalysis)
                            objectContainer = struct;
                            [cumulativedata, trialRange, stimClass, stepName] = deal(physAnalysis{currAnalysisNum}{:});
                            for trodeNum = 1:length(trodes)
                                sm = eval(stimClass);
                                analysisLoc = recordsPath.analysisLoc;
                                stimInfo = cumulativedata.(createTrodeName(trodes{trodeNum})).stimInfo;
                                mon = otherParams.monitor;
                                rS = otherParams.rigState;
                                physAnalysisObj = getPhysAnalysisObject(sm,subjectID,trialRange,trodes{trodeNum},analysisLoc,stimInfo,cumulativedata,mon,rS);
                                objectContainer(currAnalysisNum).(createTrodeName(trodes{trodeNum})) = physAnalysisObj;
                            end
                        end
                        varargout{end+1} = objectContainer;
                    end
                end
            end
            %% now logic for updation of viewAnalysis
            % params for updating viewAnalysis
            if viewAnalysis
                viewAnalysisUpdateParams = []; % make sure empty to start with
                viewAnalysisUpdateParams.analysisMode = analysisMode;
                viewAnalysisUpdateParams.trialNum = currentTrialNum;
                viewAnalysisUpdateParams.chunkID = currentChunkInd;
                viewAnalysisUpdateParams.analysisAvailable = analysisAvailable;
                if analysisAvailable
                    viewAnalysisUpdateParams.stepName = stepName;
                    viewAnalysisUpdateParams.trialRange = trialRange;
                end
                viewAnalysis = updateViewAnalysis(viewAnalysis,viewAnalysisUpdateParams);
            end
        end
        %% logic for updation of currentChunksInd and doneWithChunks        
        chunkUpdateParams = [];
        chunkUpdateParams.analysisMode = analysisMode;
        chunkUpdateParams.trialNum = currentTrialNum;
        chunkUpdateParams.chunkInd = currentChunkInd;
        chunkUpdateParams.boundaryRange = boundaryRange;
        chunkUpdateParams.chunksAvailable = chunksAvailable;
        [currentChunkInd doneWithChunks] = updateChunkStatus(chunkUpdateParams);
    end
    %% done      
    
    %% logic for changing status of done
    currentTrialNum = currentTrialNum+1;
    if currentTrialNum>boundaryRange(3)
        done = true;
    end
end
% here lies the end of the analysis. other thigns happen after end of
% analysis
if (otherParams.subSampleSpikes||otherParams.milliSecondPrecision)&& exist('physAnalysis','var') % remember sub sampling spikes never called normally
    varargout{1} = physAnalysis;
elseif (otherParams.subSampleSpikes||otherParams.milliSecondPrecision) && ~exist('physAnalysis','var')
    error('analysis should have spewed out something');
end
if isempty(varargout)
    varargout{1} = {NaN};
end
% end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOGICALS DEALT WITH HERE
function detectSpikes = updateDetectSpikesStatus(updateParams)
if ~exist('updateParams','var') || isempty(updateParams) || ~isfield(updateParams,'analysisMode') || isempty(updateParams.analysisMode)
    error('make sure updateParams exists and analysisMode is specified');
end
switch updateParams.analysisMode
    case 'overwriteAll'
        detectSpikes = true;
    case 'onlyAnalyze'
        detectSpikes = false;
    case 'onlyDetectAndSort'
        detectSpikes = true;
    case 'onlyDetect'
        detectSpikes = true;
    case 'onlySort'
        detectSpikes = false;
    case 'onlySortNoInspect'
        detectSpikes = false;
    case 'viewAnalysisOnly'
        detectSpikes = false;
    case 'onlyInspect'
        detectSpikes = false;
    case 'onlyInspectInteractive'
        detectSpikes = false;
    otherwise
        error('unknown updateMode');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sortSpikes = updateSortSpikesStatus(updateParams)
if ~exist('updateParams','var') || isempty(updateParams) || ~isfield(updateParams,'analysisMode') || isempty(updateParams.analysisMode)
    error('make sure updateParams exists and analysisMode is specified');
end
switch updateParams.analysisMode
    case 'overwriteAll'
        sortSpikes = true;
    case 'onlyAnalyze'
        sortSpikes = false;
    case 'onlyDetectAndSort'
        sortSpikes = true;
    case 'onlyDetect'
        sortSpikes = false;
    case 'onlySort'
        sortSpikes = false; % analysis should have sorted spikes for all trials at this point
    case 'onlySortNoInspect'
        sortSpikes = false; % analysis should have sorted spikes for all trials at this point
    case 'viewAnalysisOnly'
        sortSpikes = false;
    case 'onlyInspect'
        sortSpikes = false;
    case 'onlyInspectInteractive'
        sortSpikes = false;
    otherwise
        error('unknown updateMode');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function inspect = updateInspectStatus(updateParams)
if ~exist('updateParams','var') || isempty(updateParams) || ~isfield(updateParams,'analysisMode') || isempty(updateParams.analysisMode)
    error('make sure updateParams exists and analysisMode is specified');
end
switch updateParams.analysisMode
    case 'overwriteAll'
        inspect = true;
    case 'onlyAnalyze'
        inspect = false;
    case 'onlyDetectAndSort'
        inspect = true;
    case 'onlyDetect'
        inspect = false;
    case 'onlySort'
        inspect = false; % analysis should have inspected spikes for all trials at this point
    case 'onlySortNoInspect'
        inspect = false; % analysis should have inspected spikes for all trials at this point
    case 'viewAnalysisOnly'
        inspect = false;
    case 'onlyInspect';
        inspect = false;
    case 'onlyInspectInteractive'
        inspect = false;
    otherwise
        error('unknown updateMode');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function analyzeRecords = updateAnalyzeStatus(updateParams)
if ~exist('updateParams','var') || isempty(updateParams) || ~isfield(updateParams,'analysisMode') || isempty(updateParams.analysisMode)
    error('make sure updateParams exists and analysisMode is specified');
end
switch updateParams.analysisMode
    case 'overwriteAll'
        analyzeRecords = true;
    case 'onlyAnalyze'
        analyzeRecords = true;
    case 'onlyDetectAndSort'
        analyzeRecords = false;
    case 'onlyDetect'
        analyzeRecords = false;
    case 'onlySort'
        analyzeRecords = false;
    case 'onlySortNoInspect'
        analyzeRecords = false;
    case 'viewAnalysisOnly'
        analyzeRecords = false;
    case 'onlyInspect'
        analyzeRecords = false;
    case 'onlyInspectInteractive'
        analyzeRecords = false;
    otherwise
        error('unknown updateMode');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function viewAnalysis = updateViewAnalysis(viewAnalysis,updateParams)
if ~exist('updateParams','var') || isempty(updateParams) || ~isfield(updateParams,'analysisMode') || isempty(updateParams.analysisMode)
    error('make sure updateParams exists and analysisMode is specified');
end
switch updateParams.analysisMode
    case 'overwriteAll'
        viewAnalysis = viewAnalysis;
    case 'onlyAnalyze'
        viewAnalysis = viewAnalysis;
    case 'onlyDetectAndSort'
        viewAnalysis = viewAnalysis;
    case 'onlyDetect'
        viewAnalysis = viewAnalysis;
    case 'onlySort'
        viewAnalysis = viewAnalysis;
    case 'onlySortNoInspect'
        viewAnalysis = viewAnalysis;
    case 'viewAnalysisOnly'
        if updateParams.analysisAvailable
            if updateParams.trialNum==updateParams.trialRange(end)
                % this is the case where plotting has already occured for
                % the latest trial in the analysis trialRange
                viewAnalysis = true;
            else
                viewAnalysis = false;
            end
        end
    case 'onlyInspect'
        viewAnalysis = false;
    case 'onlyInspectInteractive'
        viewAnalysis = false;
    otherwise
        error('unknown updateMode');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [currentChunkInd doneWithChunks] = updateChunkStatus(updateParams)
if ~exist('updateParams','var') || isempty(updateParams) || ~isfield(updateParams,'analysisMode') || isempty(updateParams.analysisMode)
    error('make sure updateParams exists and analysisMode is specified');
end
switch updateParams.analysisMode
    case {'overwriteAll','onlyDetectAndSort','onlyDetect','onlyAnalyze'}
        whichChunk = find(updateParams.chunksAvailable==updateParams.chunkInd);
        if length(updateParams.chunksAvailable)>whichChunk
            doneWithChunks = false;
            currentChunkInd = updateParams.chunksAvailable(whichChunk+1);
        else
            doneWithChunks = true;
            currentChunkInd = 1;
        end
    case {'onlySort','onlySortNoInspect','viewAnalysisOnly','onlyInspect','onlyInspectInteractive'}
        doneWithChunks = true;
        currentChunkInd = 1;
    otherwise
        error('unknown updateMode');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SOME FUNCTIONS TO MAKE CODE EASIER TO READ
function [neuralRecordExists timestamp] = findNeuralRecordsLocation(neuralRecordsPath, currentTrialNum)
dirStr=fullfile(neuralRecordsPath,sprintf('neuralRecords_%d-*.mat',currentTrialNum));
d=dir(dirStr);
neuralRecordExists = false;
timestamp = '';
if length(d)==1
    neuralRecordFilename=d(1).name;
    % get the timestamp
    [matches tokens] = regexpi(d(1).name, 'neuralRecords_(\d+)-(.*)\.mat', 'match', 'tokens');
    if length(matches) ~= 1
        %         warning('not a neuralRecord file name');
    else
        timestamp = tokens{1}{2};
    end
    neuralRecordExists = true;
elseif length(d)>1
    disp('duplicates present. skipping trial');
else
    disp('didnt find anything in d. skipping trial');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function analyzeChunk = verifyAnalysisForChunk(stimRecordLocation, boundaryRange, maskInfo, ...
    stimClassToAnalyze, currentTrialNum)

analyzeChunk = true;
temp = stochasticLoad(stimRecordLocation,{'stimManagerClass'},10);
trialClass = temp.stimManagerClass;
if (currentTrialNum<boundaryRange(1) || currentTrialNum>boundaryRange(3)) ||...
        (~any(strcmpi(stimClassToAnalyze, 'all')) && ~any(strcmpi(stimClassToAnalyze, trialClass)))||...
        (maskInfo.maskON && strcmp(maskInfo.maskType,'trialMask') && any(maskInfo.maskRange==currentTrialNum))    
    analyzeChunk = false;    
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function neuralRecord = getNeuralRecordForCurrentTrialAndChunk(neuralRecordLocation,currentChunkInd)
chunkStr=sprintf('chunk%d',currentChunkInd);

disp(sprintf('%s from %s',chunkStr,neuralRecordLocation)); tic;
neuralRecord = getDetailsFromNeuralRecords(neuralRecordLocation,{chunkStr});
neuralRecord.samplingRate = getDetailsFromNeuralRecords(neuralRecordLocation,{'samplingRate'});
disp(sprintf(' %2.2f seconds',toc));

% reconstitute neuralDataTimes from start/end based on samplingRate
neuralRecord.neuralDataTimes=linspace(neuralRecord.neuralDataTimes(1),neuralRecord.neuralDataTimes(end),size(neuralRecord.neuralData,1))';

% check if calculated samplingRate is close to expected samplingRate
% if any(abs(((unique(diff(neuralRecord.neuralDataTimes))-(1/neuralRecord.samplingRate))/(1/neuralRecord.samplingRate)))>10^-7)
%     samplingRateInterval=(1/neuralRecord.samplingRate)
%     foundSamplesSpaces=unique(diff(neuralRecord.neuralDataTimes))
%     error('error on the length of one of the frames lengths was more than 1/ ten millionth')
% end

%check channel configuration is good for requestedAnalysis
if ~isfield(neuralRecord,'ai_parameters')
    if isfield(neuralRecord,'channelConfiguration')
        neuralRecord.ai_parameters.channelConfiguration = neuralRecord.channelConfiguration;
        neuralRecord.ai_parameters.digitalConfigration = neuralRecord.digitalConfigration;
    else
        neuralRecord.ai_parameters.channelConfiguration={'framePulse','photodiode','phys1'};
        if size(neuralRecord.neuralData,2)~=3
            error('only expect old unlabeled data with 3 channels total... check assumptions')
        end
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function thesePhysChannelInds = getPhysIndsForTrodeChans(channelConfiguration,currTrode)
chansRequired=unique(currTrode);
for c=1:length(chansRequired)
    chansRequiredLabel{c}=['phys' num2str(chansRequired(c))];
end

if any(~ismember(chansRequiredLabel,channelConfiguration))
    chansRequiredLabel
    channelConfiguration
    error(sprintf('requested analysis on channels %s but thats not available',char(setdiff(chansRequiredLabel,channelConfiguration))))
end
thesePhysChannelLabels = {};
thesePhysChannelInds = [];
for c=1:length(currTrode)
    thesePhysChannelLabels{c}=['phys' num2str(currTrode(c))];
    thesePhysChannelInds(c)=find(ismember(channelConfiguration,thesePhysChannelLabels{c}));
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function currentSpikeRecord = detectSpikeForTrode(currentSpikeRecord,trode,trodeNum,neuralData,neuralDataTimes,...
    samplingRate,spikeDetectionParams,trialNum,chunkInd)
spikeDetectionParams.samplingFreq = samplingRate; % spikeDetectionParams needs samplingRate
[spikes spikeWaveforms spikeTimestamps] = detectSpikesFromNeuralData(neuralData, neuralDataTimes, spikeDetectionParams);

% update currentSpikeRecords
trodeStr = createTrodeName(trode);
currentSpikeRecord.(trodeStr).trodeChans        = trode;
currentSpikeRecord.(trodeStr).spikes            = spikes;
currentSpikeRecord.(trodeStr).spikeWaveforms    = spikeWaveforms;
currentSpikeRecord.(trodeStr).spikeTimestamps   = spikeTimestamps;
% fill in details about trial and chunk
currentSpikeRecord.(trodeStr).chunkIDForDetectedSpikes = chunkInd*ones(size(spikes));
currentSpikeRecord.(trodeStr).trialNumForDetectedSpikes = trialNum*ones(size(spikes));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function spikeRecord = detectPhotoDiodeSpikes(neuralRecord, photoInd, spikeRecord)
[spikeRecord.spikes spikeRecord.spikeWaveforms spikeRecord.photoDiode]=...
    getSpikesFromPhotodiode(neuralRecord.neuralData(:,photoInd),...
    neuralRecord.neuralDataTimes, spikeRecord.correctedFrameIndices,neuralRecord.samplingRate);
spikeRecord.spikeTimestamps = neuralRecord.neuralDataTimes(spikeRecord.spikes);
spikeRecord.assignedClusters=[ones(1,length(spikeRecord.spikeTimestamps))]';
spikeRecord.processedClusters=spikeRecord.assignedClusters'; % select all of them as belonging to a processed group
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function currentSpikeRecord = sortSpikesForTrode(currentSpikeRecord,currTrode,trodeNum,...
    currSpikes, currSpikeWaveforms,currSpikeTimestamps, currSpikeSortingParams, spikeModel,trialNum,chunkID)
trodeStr = createTrodeName(currTrode);
if isstruct(spikeModel) && isfield(spikeModel,trodeStr)
    currSpikeModel = spikeModel.(trodeStr);
else
    currSpikeModel = [];
end
[assignedClusters rankedClusters currSpikeModel] = sortSpikesDetected(currSpikes,...
    currSpikeWaveforms, currSpikeTimestamps, currSpikeSortingParams, currSpikeModel);
spikeDetails = postProcessSpikeClusters(assignedClusters,...
    rankedClusters,currSpikeSortingParams,currSpikeWaveforms);

currentSpikeRecord.(trodeStr).spikeModel = currSpikeModel;
currentSpikeRecord.(trodeStr).assignedClusters = assignedClusters;
currentSpikeRecord.(trodeStr).rankedClusters = {rankedClusters};
currentSpikeRecord.(trodeStr).processedClusters = spikeDetails.processedClusters';
currentSpikeRecord.(trodeStr).trialNumForSortedSpikes = trialNum*ones(size(assignedClusters));
currentSpikeRecord.(trodeStr).chunkIDForSortedSpikes = chunkID*ones(size(assignedClusters));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function quality = getQualityForSpikeRecord(spikeRecord)
quality.chunkID = spikeRecord.chunkID;
quality.passedQualityTest=spikeRecord.passedQualityTest;
quality.chunkHasFrames=spikeRecord.chunkHasFrames;
quality.frameIndices=spikeRecord.frameIndices;
quality.frameTimes=spikeRecord.frameTimes;
quality.frameLengths=spikeRecord.frameLengths;
quality.correctedFrameIndices=spikeRecord.correctedFrameIndices;
quality.correctedFrameTimes=spikeRecord.correctedFrameTimes;
quality.correctedFrameLengths=spikeRecord.correctedFrameLengths;
quality.chunkIDForCorrectedFrames=spikeRecord.chunkIDForCorrectedFrames;
quality.chunkIDForFrames=spikeRecord.chunkIDForFrames;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function quality = filterQualityMetric(quality,chunkID)
which = (quality.chunkID<=chunkID);
quality.chunkID = quality.chunkID(which);
quality.passedQualityTest=quality.passedQualityTest(which);
quality.chunkHasFrames=quality.chunkHasFrames(which);

which = (quality.chunkIDForFrames<=chunkID);
quality.chunkIDForFrames=quality.chunkIDForFrames(which);
quality.frameIndices=quality.frameIndices(which);
quality.frameTimes=quality.frameTimes(which);
quality.frameLengths=quality.frameLengths(which);

which = (quality.chunkIDForCorrectedFrames<=chunkID);
quality.chunkIDForCorrectedFrames=quality.chunkIDForCorrectedFrames(which);
quality.correctedFrameIndices=quality.correctedFrameIndices(which);
quality.correctedFrameTimes=quality.correctedFrameTimes(which);
quality.correctedFrameLengths=quality.correctedFrameLengths(which);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function parameters=getNeuralRecordParameters(neuralRecordLocation,stimRecordLocation,subjectID,...
                            currentTrialNum,currentChunkInd,timestamp,filteredSpikeRecord,spikeDetectionParams)
out=stochasticLoad(neuralRecordLocation,{'parameters'});
if isfield(out,'parameters')
    parameters=out.parameters;
else
    p=[];
    temp = stochasticLoad(neuralRecordLocation,{'samplingRate'});
    p.samplingRate=temp.samplingRate;
    p.subjectID=subjectID;
end
%Add some more activeParameters about the trial
p.trialNumber=currentTrialNum;
p.chunkID=currentChunkInd;
p.date=datenumFor30(timestamp);


%% now make parameters by trode (from filteredSpikeRecord)
trodesInRecord = fieldnames(filteredSpikeRecord);
trodesInRecord = trodesInRecord(~cellfun(@isempty,regexp(trodesInRecord,'^trode')));
for currTrode = trodesInRecord'
    parameters.(currTrode{:}) = p;
    if isfield(spikeDetectionParams.(currTrode{:}),'ISIviolationMS')
        parameters.(currTrode{:}).ISIviolationMS = spikeDetectionParams.(currTrode{:}).ISIviolationMS;
    else
        parameters.(currTrode{:}).ISIviolationMS = 2;
    end
    temp = stochasticLoad(stimRecordLocation,{'refreshRate'});
    parameters.(currTrode{:}).refreshRate = temp.refreshRate;
end
end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cumulativedata,trialRange,stimManagerClass,stepName, replaceCumulative] = getRelevantCumulativeData...
    (physAnalysis,stimRecords,sm,stimRecordLocation)
if ~isempty(physAnalysis) % some analysis already exists
    [prevCumulativedata,prevTrialRange,prevStimManagerClass,prevStepName] = deal(physAnalysis{end}{:});
else
    prevCumulativedata = [];
    prevTrialRange = [];
    prevStimManagerClass = [];
    prevStepName = [];
end

if strcmp(prevStepName,getStepName(stimRecords,sm,stimRecordLocation)) && enableCumulativePhysAnalysis(sm)
    if isfield(prevCumulativedata,'physAnalysisFailed')
        cumulativedata = [];
        trialRange = [];
        stimManagerClass = stimRecords.stimManagerClass;
        stepName = getStepName(stimRecords,sm,stimRecordLocation);
        replaceCumulative = false;
    else
        cumulativedata = prevCumulativedata;
        trialRange = prevTrialRange;
        stimManagerClass = prevStimManagerClass;
        stepName = prevStepName;
        replaceCumulative = true;
    end
else
    cumulativedata = [];
    trialRange = [];
    stimManagerClass = stimRecords.stimManagerClass;
    stepName = getStepName(stimRecords,sm,stimRecordLocation);
    replaceCumulative = false;
end
end
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stepName = getStepName(stimRecords,sm,stimRecordLocation)


[tempPath tempFilename]=fileparts(stimRecordLocation);
tempFilename=['scratchPad' tempFilename(12:end)];
scratchPadFile=fullfile(fileparts(tempPath),'scratchPad',[tempFilename '.mat']);

if exist(scratchPadFile,'file')
    x=load(scratchPadFile);
    stepName = x.stepName;
elseif isfield(stimRecords,'stepName')
    stepName = stimRecords.stepName;
else
    stepName = commonNameForStim(sm,stimRecords.stimulusDetails);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cumulativedata = analyzeCurrentTrode(currTrode,filteredSpikeRecord,stimRecords,...
    physAnalysisParameters,cumulativedata,eyeData,trialNum,chunkID)

trodeStr = createTrodeName(currTrode);
if isfield(cumulativedata,trodeStr)
    cumulativeForTrode = cumulativedata.(trodeStr);
else
    cumulativeForTrode = [];
end
currParams = physAnalysisParameters.(trodeStr);
currParams.subSampleSpikes = physAnalysisParameters.subSampleSpikes;
currParams.subSampleProb = physAnalysisParameters.subSampleProb;
currParams.milliSecondPrecision = physAnalysisParameters.milliSecondPrecision;
currParams.pixelOfInterest = physAnalysisParameters.pixelOfInterest;
currParams.precisionInMS = physAnalysisParameters.precisionInMS;

filterParams.filterMode = 'onlyThisTrodeAndFlatten';

filterParams.trodeStr = trodeStr;
spikeRecordForTrode = filterSpikeRecords(filterParams,filteredSpikeRecord);
spikeRecordForTrode.currentChunk = chunkID;
stimDetails = stimRecords.stimulusDetails;

trialClass = stimRecords.stimManagerClass;
evalStr = sprintf('sm = %s();',trialClass);
eval(evalStr);

plotParameters.showSpikeAnalysis = false;
%plotParameters.plotHandle = physAnalysisParameters.plotHandle;
LFPRecord = [];
[analysisForTrode cumulativeForTrode] = physAnalysis(sm,spikeRecordForTrode,stimDetails,plotParameters,...
    currParams,cumulativeForTrode,eyeData,LFPRecord);
cumulativedata.(trodeStr) = cumulativeForTrode;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function physAnalysis = updatePhysAnalysis(physAnalysis,cumulativedata,replaceCumulative,...
    trialRange,stimManagerClass,stepName,currentTrialNum)
if replaceCumulative
    position = length(physAnalysis);
    trialRange(2) = currentTrialNum;
else
    position = length(physAnalysis)+1;
    trialRange = currentTrialNum;
end
physAnalysis{position} = {cumulativedata,trialRange,stimManagerClass,stepName};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function index = getAnalysisIndexForTrial(trialNum,physAnalysis)
lengthAnalysis = length(physAnalysis);
index = 0;
for currIndex = 1:lengthAnalysis
    currTrialRange = physAnalysis{currIndex}{2};
    if trialNum>=currTrialRange(1) && trialNum<=currTrialRange(end)
        index = currIndex;
        return;
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [figNum figureList] = getRelevantFigForPlotting(figureList,trialRange, stimClass, stepName,trodes,trodeNum)
trodeStr = createTrodeName(trodes{trodeNum});
evalStr = sprintf('sm = %s();',stimClass);
eval(evalStr);
if isempty(figureList) % if there were no figures create a fig list
    minFigNum = length(trodes)+1;
    figNum = minFigNum;
    figInfo.(trodeStr) = figNum;
    figureList = {{stimClass,stepName,trialRange,figInfo}};
else
    if strcmp(figureList{end}{2},stepName)&&enableCumulativePhysAnalysis(sm) % same step name and cumulatve phys analysis is enabled
        if ~any(ismember(figureList{end}{3},trialRange(end))) % attach trial range to the end
            figureList{end}{3} = [figureList{end}{3} trialRange(end)];
        end
        if isfield(figureList{end}{4},trodeStr) % that trode has been displayed before
            figInfo = figureList{end}{4};
            figNum = figInfo.(trodeStr);
        else % trodes data not displayed before
            figInfo = figureList{end}{4};
            trodesInFigList = fieldnames(figInfo);
            maxFigNum = 0;
            for trodeName = trodesInFigList'
                maxFigNum = max(maxFigNum,figInfo.(trodeName{:}));
            end
            figNum = maxFigNum +1;
            figInfo.(trodeStr) = figNum;
            figureList{end}{4} = figInfo;
        end
    else % same step name but no cumulative phys analysis enabled
        figInfo = figureList{end}{4};
        trodesInFigList = fieldnames(figInfo);
        maxFigNum = 0;
        for trodeName = trodesInFigList'
            maxFigNum = max(maxFigNum,figInfo.(trodeName{:}));
        end
        figNum = maxFigNum +1;
        figInfo=[];
        figInfo.(trodeStr) = figNum;
        figureList{end+1} = {stimClass,stepName,trialRange,figInfo};
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotAnalysisForTrode(figNum,figureInfo,cumulativedata,stimRecords,trode)
trodeStr = createTrodeName(trode);
parameters.stimRecords = stimRecords;
parameters.figHandle = figNum;
parameters.stepName = figureInfo{2};
parameters.trialRange = figureInfo{3};
parameters.trodeName = sprintf('trodeChans: %s',mat2str(trode));
stimManagerClass = figureInfo{1};
evalStr = sprintf('sm = %s;',stimManagerClass);
eval(evalStr);
if ~isfield(cumulativedata,'physAnalysisFailed')
currCumulativedata = cumulativedata.(trodeStr);
displayCumulativePhysAnalysis(sm,currCumulativedata,parameters);
else
    figure(figNum);
    text(0.5,0.5,'physAnalysis failed. please check why')
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function currentLFPRecord = filterLFPForTrode(currNeuralData,currNeuralDataTimes,currSamplingRate,spikeDetectionParams,currTrode)
if spikeDetectionParams.sampleLFP
    % spikeRecord.LFPRecord.data = resample(neuralRecord.neuralData(:,thesePhysChannelInds),spikeDetectionParams.LFPSamplingRateHz,neuralRecord.samplingRate);
    currentLFPRecord.(createTrodeName(currTrode)).data = resample(currNeuralData(:,1),spikeDetectionParams.LFPSamplingRateHz,currSamplingRate);
    if isfield(spikeDetectionParams,'LFPBandPass') %smooth each chunk separately? or do it at the end???? currently doing each chunk separately.
        W = spikeDetectionParams.LFPBandPass*2/spikeDetectionParams.LFPSamplingRateHz;
        N = 2; % second order filter...why? because!
        [b a] = butter(N,W);
        currentLFPRecord.(createTrodeName(currTrode)).data=filter(b,a,currentLFPRecord.(createTrodeName(currTrode)).data);
    end
    currentLFPRecord.(createTrodeName(currTrode)).dataTimes = [currNeuralDataTimes(1) currNeuralDataTimes(end)];
    currentLFPRecord.(createTrodeName(currTrode)).LFPSamplingRateHz = spikeDetectionParams.LFPSamplingRateHz;
else
    currentLFPRecord.(createTrodeName(currTrode)).data = [];
    currentLFPRecord.(createTrodeName(currTrode)).dataTimes =[];
    currentLFPRecord.(createTrodeName(currTrode)).LFPSamplingHz = [];
end
end

%% necessary improvements
% 1. ensure that we get "trodes info from analysisBoundary.mat if trodes is
% set to {}. only if it doesn't already exist should the analysis exit.
% ***done balaji july 19
% 2. gratings physanalysis and displayCumulative
% 3. only Sort should sort on all the spikes in the range. *** done balaji
% july 19
% 4. include numChunks in the physiologyServer saves.
% 5. better ISI plotting for complete plots.
% 6. include the voltage thresh in sort plotting
% 7. differential plotting of latest chunk and previous chunks
% 8. allow for + to be in either direction for AP in physiologyServer
% 9. easy lookup on spikePhysChans and NIDAQ chans
% 10. when is neuralDatatimes initialized? if at the beginning of a
% session, session beginning events should be noted in physiologyServer
% (-ve spikeTimestamps can be explained by this). in general diff should be
% inteliigent to changes in trialNum. ****done balaji 21 July 2010
