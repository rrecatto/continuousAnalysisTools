function [success] = plotSpikeClusters(contFile, devsFromMean)
% [ boolean ] = plotSpikeClusters(filename) 
%   extracts, clusters, and plots again all spikes found in
%   continuous file. 
%  PARAMETERS:
%     1. contFile = path of file to detect spikes in
%     2. devsFromMean = (optional with default 10) sets stdDev from mean to
%                       set as upper bound and lower bound of threshold. 
%
%   LATER ADD MORE RETURNS!

% sets default devsFromMean to be 10, otherwise sets to user specified
% number
if nargin < 2
    devsFromMean = 10;
end

% 1. get continuous data using load_open... method
[data, timestamps, info] = load_open_ephys_data(contFile);

% TODO
% 2. get event data using load_open... method


% 3. get mean/stdDev of data
mVal = mean(data);
stdDev = std(data);

% 4. set spikeDetectionParams using mean/stdDev
upperBound = mVal + (devsFromMean*stdDev);
lowerBound = mVal - (devsFromMean*stdDev); 

spikeDetectionParams.method = 'filteredThresh';
spikeDetectionParams.samplingFreq = 30000;
spikeDetectionParams.freqLowHi = [200 10000];
spikeDetectionParams.threshHoldVolts = [lowerBound upperBound];
spikeDetectionParams.waveformWindowMs= 1.5;
spikeDetectionParams.peakWindowMs= 0.6;
spikeDetectionParams.alignMethod = 'atPeak'; %atCrossing
spikeDetectionParams.peakAlignment = 'filtered'; % 'raw'
spikeDetectionParams.returnedSpikes = 'filtered'; % 'raw'
spikeDetectionParams.lockoutDurMs=0.1;  
spikeDetectionParams.thresholdMethod = 'raw';

% adds paths for next methods
addpath('maustrix\util\spikes\');
addpath('maustrix\bootstrap\');

% 5. get spikes using detectSpikes... method
[spikes spikeWaveforms spikeTimestamps]= detectSpikesFromNeuralData(data, timestamps, spikeDetectionParams);

spikeSortingParams.method = 'KLUSTAKWIK';
spikeSortingParams.samplingFreq = 30000;
spikeSortingParams.minClusters=4;
spikeSortingParams.maxClusters=8;  
spikeSortingParams.nStarts=1;
spikeSortingParams.splitEvery=10; 
spikeSortingParams.maxPossibleClusters=10; 
spikeSortingParams.featureList = {'tenPCs'};
spikeSortingParams.arrangeClustersBy = 'averageAmplitude';         
spikeSortingParams.postProcessing= 'biggestAverageAmplitudeCluster'; 

[assignedClusters rankedClusters spikeModel] = sortSpikesDetected(spikes, spikeWaveforms, spikeTimestamps, spikeSortingParams, 'KLUSTAMODEL');

numClusters = length(rankedClusters)
numSpikes = length(spikes)
clusters = [1:numClusters]

for s = 1:numSpikes
    cAssigned = assignedClusters(s);
    append(clusters(cAssigned), spikeWaveforms(s));
end

clusters

end

