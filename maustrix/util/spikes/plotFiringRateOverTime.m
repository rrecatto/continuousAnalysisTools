function plotFiringRateOverTime(subjectID, path, cellBoundary, trodes)
%% START ERROR CHECKING AND CORRECTION
if ~exist('subjectID','var') || isempty(subjectID)
    subjectID = 'demo1'; %
end

if ~exist('path','var') || isempty(path)
    % path = '\\Reinagel-lab.AD.ucsd.edu\RLAB\Rodent-Data\Fan\datanet' % OLD
    path = '\\132.239.158.179\datanet_storage\';
end

% needed for physLog boundaryType
neuralRecordsPath = fullfile(path, subjectID, 'neuralRecords');
if ~isdir(neuralRecordsPath)
    disp(neuralRecordsPath);
    error('unable to find directory to neuralRecords');
end
    %% cellBoundary with support for masking
if ~exist('cellBoundary','var') || isempty(cellBoundary)
    error('cellBoundary must be a valid input argument - default value is too dangerous here!');
else 
    [boundaryRange maskInfo] = validateCellBoundary(cellBoundary);
end
    %% create the analysisPath and see if it exists
[analysisPath]= createAnalysisPathString(boundaryRange,path,subjectID);
prevAnalysisExists =  exist(analysisPath,'dir');
if ~prevAnalysisExists
    error('cannot plot firing rates when spikes have not been identified. detect spikes first');
end
analysisBoundaryFile = fullfile(analysisPath,'analysisBoundary.mat');
    %% spikeChannelsAnalyzed
if ~exist('trodes','var') || isempty(trodes)
    % see if trodes is present in the analysisBoundaryFile
    temp = stochasticLoad(analysisBoundaryFile,{'trodes'});
    if ~isfield(temp,'trodes')||isempty(temp.trodes)
        error('if you analyzed the trial, then trodes should not be set to empty. whats happenieng here?');
    else
        trodes = temp.trodes;
    end
end
%% DONE ERROR CHECKING

%% load the spikeRecords.
spikeRecordFile = fullfile(analysisPath,'spikeRecord.mat');
temp = stochasticLoad(spikeRecordFile,{'spikeRecord'});
if ~isfield(temp,'spikeRecord')||isempty(temp.spikeRecord)
    error('spikeRecord does not exist or is empty. should not be the case');
else
    spikeRecord = temp.spikeRecord;
end
totalNumTrials = boundaryRange(3)-boundaryRange(1)+1;
numTrodes = length(trodes);
if maskInfo.maskON && strcmp(maskInfo.maskType,'trialMask')
    totalNumTrials = totalNumTrials-length(maskInfo.maskRange);
end
trialStartTimes = nan(totalNumTrials,3);
spikingRateForTrodes = nan(totalNumTrials,numTrodes);
% loop through the trials
currentTrialNum = boundaryRange(1);
done = false;
whichTrialNum = 0;
while ~done
    analyzeTrial = verifyAnalysisForTrial(boundaryRange,maskInfo,currentTrialNum);
    if analyzeTrial
        disp(sprintf('analyzing trial number %d',currentTrialNum));
        whichTrialNum = whichTrialNum+1;
        whichInds = find(spikeRecord.trialNum==currentTrialNum);
        startTimeForThisTrial = (spikeRecord.trialStartTime(whichInds,:));
        if length(unique(startTimeForThisTrial))~=1
            disp(currentTrialNum);
            error('what!!!!')
        else
            startTimeForThisTrial=unique(startTimeForThisTrial);
        end
        totalTimeForTrial = sum(spikeRecord.chunkDuration(whichInds));
        trialStartTimes(whichTrialNum,:) = [currentTrialNum startTimeForThisTrial totalTimeForTrial];
        % loop through the trodes and find the number of spikes in each
        % trodes
        for currTrodeNum = 1:numTrodes
            trodeStr = createTrodeName(trodes{currTrodeNum});
            spikingRateForTrodes(whichTrialNum,currTrodeNum) = length(find(spikeRecord.(trodeStr).trialNumForDetectedSpikes==currentTrialNum));
        end        
    end
    currentTrialNum = currentTrialNum+1;
    if currentTrialNum>boundaryRange(3)
        done = true;
    end
end
f = figure;
set(f,'Name','firing Rate of all neurons over time','NumberTitle','off');
[ax h1 h2]=plotyy((trialStartTimes(:,2)-min(trialStartTimes(:,2)))*86400,spikingRateForTrodes./trialStartTimes(:,3),...
    (trialStartTimes(:,2)-min(trialStartTimes(:,2)))*86400,trialStartTimes(:,3));
% plot(trialStartTimes(:,2),spikingRateForTrodes./trialStartTimes(:,3),'LineWidth',2,'Color','r');
% plot(trialStartTimes(:,2),trialStartTimes(:,3),'Color',0.5*[1 1 1],'LineStyle','--');
% XTickLabels = trialStartTimes(:,1);
% set(ax,'XTickLabels',XTickLabels);
set(h1,'LineWidth',2,'Color','r');
set(h2,'Color',0.5*[1 1 1],'LineStyle','--');
xlabel('(s)')
axes(ax(1));
ylabel('spikes/s');
axis tight
axes(ax(2));
ylabel('seconds');
axis tight
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FUNCTIONS TO IMPROVE CODE FLOW
function analyzeTrial = verifyAnalysisForTrial(boundaryRange, maskInfo, currentTrialNum)
analyzeTrial = true;
if (currentTrialNum<boundaryRange(1) || currentTrialNum>boundaryRange(3)) ||...
        (maskInfo.maskON && strcmp(maskInfo.maskType,'trialMask') && any(maskInfo.maskRange==currentTrialNum))    
    analyzeTrial = false;    
end
end