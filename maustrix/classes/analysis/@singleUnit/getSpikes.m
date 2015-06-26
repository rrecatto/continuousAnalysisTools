function [spikes frames]=getSpikes(s)
%only gets the processed clusters
%spikes=getPhysAnalysis({'spike'},'anything')
%can we get the file names from the saved analysis..

spikeRecordFile = fullfile(s.getAnalysisPath,'spikeRecord.mat');
[x succ]=stochasticLoad(spikeRecordFile,[], 3);
if ~succ
    error('succ sux!')
end

trodeName = createTrodeName(s.channels);
spikes=x.spikeRecord.(trodeName);
frames = rmfield(x.spikeRecord,trodeName);
%note that times will saw tooth (plot(spikes.spikeTimestamps))

trodeName=createTrodeName(s.channels);
frames=x.spikeRecord;
frames=rmfield(frames,trodeName);
spikes=x.spikeRecord.(trodeName);
end