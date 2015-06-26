function calcLFP(s,params)
s.subject
s.trials

LFPSavePath = fullfile(s.dataPath,s.subject,'analysis',s.sourceFolder);
LFPFileName = sprintf('LFPRecord_%s.mat',s.sourceFolder);
LFPRecord = {};
% loop through trials
framesCompleted = 0;
repsCompleted = 0;
c = getAnalysis(s);
for i=1:length(s.trials)
    % find appropriate neuralRecord and load it
    fileName=['neuralRecords_' num2str(s.trials(i)) '-*.mat'];
    d = dir(fullfile(s.dataPath,s.subject,'neuralRecords',fileName));
    if length(d)>1
        warning('multiple files have that trial number')
        keyboard;
    end
    clear data;
    data = stochasticLoad(fullfile(s.dataPath,s.subject,'neuralRecords',d.name),[],5);
    
    % obtain pulse data
        
    pulseRecord = [];
    for chunkInd = 1:max(data.numChunks)
        chunkName = sprintf('chunk%d',chunkInd);
        pulseInd=find(strcmp(data.(chunkName).ai_parameters.channelConfiguration,'framePulse'));
        pulseRecord = [pulseRecord; data.(chunkName).neuralData(:,pulseInd)];
    end
    pulseDataTimes = linspace(data.chunk1.neuralDataTimes(1),data.(chunkName).neuralDataTimes(2),length(pulseRecord));
    sampleRate = data.samplingRate;
    dropsAcceptableFirstNFrames=2; % first 2 frames won't kill the default quality test
    dropBound = 1.5;   %smallest fractional length of ifi that will cause the long tail to be called a drop(s)
    warningBound = 0.1; %fractional difference that will cause a warning, (after drop adjusting)
    errorBound = 0.6;   %fractional difference of ifi that will cause an error (after drop adjusting)

    ifi = 1/s.stimInfo.refreshRate;
    
    % get frameTimes
    [frameIndices frameTimes frameLengths correctedFrameIndices correctedFrameTimes correctedFrameLengths stimInds passedQualityTest] = ...
    getFrameTimes(pulseRecord, pulseDataTimes, sampleRate, dropBound, warningBound, errorBound, ifi,dropsAcceptableFirstNFrames);

    %now split up neuralDataAccording to the frame data and calcLFP. dont
    %need pulserecord anymore
    clear pulseRecord;
    neuralRecord = [];
    for chunkInd = 1:max(data.numChunks)
        chunkName = sprintf('chunk%d',chunkInd);
        pulseInd=find(strcmp(data.(chunkName).ai_parameters.channelConfiguration,'framePulse'));
        photoInd=find(strcmp(data.(chunkName).ai_parameters.channelConfiguration,'photodiode'));
        neuralInd = 1:length(data.(chunkName).ai_parameters.channelConfiguration);
        neuralInd = neuralInd(~ismember(neuralInd,[pulseInd photoInd]));
        neuralRecord = [neuralRecord; data.(chunkName).neuralData(:,neuralInd)];
    end
    
    % now i need the frame to stim type relationship
%     sm = gratings;
%     sp = getSpikes(s);
%     sp.stimInds = frameIndices(:,1);
%     sp.correctedFrameIndices = correctedFrameTimes;
%     parameters.trialNumber = s.trials(i);
%     parameters.refreshRate = s.stimInfo.refreshRate;
%     parameters.samplingRate = data.samplingRate;
%     parameters.subjectID = s.subject;
%     a = physAnalysis(sm,sp,s.stimInfo.stimulusDetails,[],parameters,[],[],[]);
%     
    % numFrames in this Trial
    numFramesThisTrial = length(correctedFrameIndices);
    cCurr = [];
    cCurr.stimInfo = c.stimInfo;
    cCurr.types = c.types(framesCompleted+1:framesCompleted+numFramesThisTrial);
    cCurr.repeats = c.repeats(framesCompleted+1:framesCompleted+numFramesThisTrial);
    %heavy lifting
    for rep = 1:c.stimInfo.stimulusDetails.numRepeats
        for type = 1:size(s.stim,2)
            which = (cCurr.types==type)&(cCurr.repeats==rep+repsCompleted);
            indexStarts = correctedFrameIndices(which,1);
            indexStops = correctedFrameIndices(which,2);
            indexStart = indexStarts(1);
            indexStop = indexStops(end);
            neuralCurr = neuralRecord(indexStart:indexStop);
            N = 200;
            [b,a]=fir1(200,2*[1 100]/data.samplingRate);
            filteredSignal=filtfilt(b,a,neuralCurr); % still sampling at 40000 Hz
            LFPRecord{repsCompleted+rep,type} = resample(filteredSignal,1,40); % now sampling at 1000 Hz
        end
    end
    
    framesCompleted = numFramesThisTrial;
    repsCompleted = repsCompleted+rep;
    
end
save(fullfile(LFPSavePath,LFPFileName),'LFPRecord');
end