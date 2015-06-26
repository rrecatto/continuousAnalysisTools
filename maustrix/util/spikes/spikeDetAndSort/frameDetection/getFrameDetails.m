function spikeRecord =  getFrameDetails(neuralRecord,pulseInd,photoInd,frameThresholds,ifi,trialNum,chunkInd)
[spikeRecord.frameIndices spikeRecord.frameTimes spikeRecord.frameLengths spikeRecord.correctedFrameIndices...
    spikeRecord.correctedFrameTimes spikeRecord.correctedFrameLengths spikeRecord.stimInds spikeRecord.passedQualityTest] = ...
    getFrameTimes(neuralRecord.digitalData(:,pulseInd),neuralRecord.neuralDataTimes,neuralRecord.samplingRate,...
    frameThresholds.dropBound, frameThresholds.warningBound, frameThresholds.errorBound,ifi, frameThresholds.dropsAcceptableFirstNFrames);
% get the integral below the photoDiode
if isempty(photoInd)
    spikeRecord.photoDiode = [];
else
    spikeRecord.photoDiode = getPhotoDiode(neuralRecord.neuralData(:,photoInd),spikeRecord.correctedFrameIndices);
end
spikeRecord.chunkIDForCorrectedFrames=ones(length(spikeRecord.stimInds),1)*chunkInd;
spikeRecord.chunkIDForFrames=ones(size(spikeRecord.frameIndices,1),1)*chunkInd;
spikeRecord.trialNumForCorrectedFrames=ones(length(spikeRecord.stimInds),1)*trialNum;
spikeRecord.trialNumForFrames=ones(size(spikeRecord.frameIndices,1),1)*trialNum;
end