function out = plotFiringRatesOverTime(subjectID,recordLoc,trials,plotON)
if ~exist('subjectID','var')||isempty(subjectID)
    error('need to give subjectID');
end

if ~exist('recordLoc','var')||isempty(recordLoc)
    recordLoc = '\\EPHYS-DATA-PC\datanetOutput';
end

if ~exist('trials','var')||isempty(trials)||~isnumeric(trials)
    error('need to give trials which should be numeric');
end

if ~exist('plotON','var')||isempty(plotON)
    plotON = true;;
end

analysisLoc = fullfile(recordLoc,subjectID,'analysis');
spikeNums = nan(length(trials),32);
trialDuration = nan(length(trials),1);
trialStartTime = nan(length(trials),1);
exptStartTime = nan;
for i = 1:length(trials)
    % look for spikeRecord
    currSpikeLoc = fullfile(analysisLoc,num2str(trials(i)),'spikeRecord.mat');
    if ~exist(currSpikeLoc,'file')
        trials(i)
        keyboard
        error('need to run detect spike before calling');
    end
    temp = load(currSpikeLoc);
    trialStartTime(i) = temp.spikeRecord.trialStartTime(1);
    if i == 1
        exptStartTime = temp.spikeRecord.trialStartTime(1);
    end
    trialDuration(i) = temp.spikeRecord.chunkDuration(end);
    for j = 1:31
        trodeStr = createTrodeName(j);
        spikeNums(i,j) = length(temp.spikeRecord.(trodeStr).spikes);
    end
end
spikeRate = spikeNums./(repmat(trialDuration,1,32));
figure;

if plotON
    for i = 1:32
        plot((trialStartTime-exptStartTime)*24*60,spikeRate(:,i)/spikeRate(1,i));hold on
    end
end
out.exptStartTime = exptStartTime;
out.trialStartTime = trialStartTime;
out.spikeRate = spikeRate;
out.normFiringRate = spikeRate./repmat(spikeRate(1,:),size(spikeRate,1),1);

out.trialStartTimeMins = (trialStartTime-exptStartTime)*24*60;
out.sampledMinutes = 0:floor(max(out.trialStartTimeMins));

for i = 1:32
    out.sampledNormFiring(:,i) = interp1(out.trialStartTimeMins,out.normFiringRate(:,i),out.sampledMinutes);
end
xlabel('time(min)');
ylabel('normalized firing rates');
title('32 channel recording')
end