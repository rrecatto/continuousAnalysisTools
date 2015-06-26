%% set path for neural and trial Records
if IsWin 
    recordsPath='\\EPHYS-DATA-PC\datanetOutput';
elseif IsLinux
    recordsPath = '~/Documents/datanetOutput';
    recordsPath = '/media/LaCie/physiologyData';
else
    error('what?!');
end
out.recordsPath = recordsPath;
%% spikeDetectionParams
spikeDetectionParams.method = 'filteredThresh'; %'filteredThresh'; %'oSort'; %
% fill in the details
switch spikeDetectionParams.method
    case 'filteredThresh' %use filteredThresh
        spikeDetectionParams.freqLowHi = [200 10000];
        spikeDetectionParams.threshHoldVolts = [-0.1 Inf];
        spikeDetectionParams.waveformWindowMs= 1.5;
        spikeDetectionParams.peakWindowMs= 0.6;
        spikeDetectionParams.alignMethod = 'atPeak'; %atCrossing
        spikeDetectionParams.peakAlignment = 'filtered'; % 'raw'
        spikeDetectionParams.returnedSpikes = 'filtered'; % 'raw'
        spikeDetectionParams.lockoutDurMs=0.1; %spikeDetectionParams.waveformWindowMs-spikeDetectionParams.peakWindowMs; %0
    case 'oSort'
        spikeDetectionParams.nrNoiseTraces=0;   % what does this do for us? any effect if set to 2?
        %should be replaced with a string that collapses these two confusing categories into one value;  'maxPeak' 'minPeak' 'maxMinPeak' 'power' 'MTEO'
        % why is 3=power broken? can we fix it?
        spikeDetectionParams.peakAlignMethod=1;  % 1-> find peak, 2->none, 3->peak of power signal (broken), 4->peak of MTEO signal.
        spikeDetectionParams.alignMethod=2;  %only used if peakAlignMethod is 1=peak; if so (1: peak is max, 2: peak is min, 3: mixed)
        spikeDetectionParams.prewhiten = 0;  %will error if true, and less than 400,000 samples ~10 secs / trial; need to understand whittening with Linear Predictor Coefficients to lax requirements (help lpc)
        spikeDetectionParams.detectionMethod=3; % 1 -> from power signal, 2 threshold positive, 3 threshold negative, 4 threshold abs, 5 wavelet
        spikeDetectionParams.kernelSize=25;
        %         spikeDetectionParams.detectionMethod=5
        %         spikeDetectionParams.scaleRanges = [0.5 1.0];
        %         spikeDetectionParams.waveletName = 'haar';
    otherwise
        error('unsupported spikeDetection method');
end
spikeDetectionParams.ISIviolationMS=2; % just for human reports
%% spikeSortingParams
spikeSortingParams.method = 'KlustaKwik'; %'oSort'; %'useSpikeModelFromPreviousAnalysis'; %
switch  spikeSortingParams.method 
    case 'KlustaKwik'
        spikeSortingParams.minClusters=4; % (optional) (default 20) min number of initial clusters - final number may be different due to splitting/deleting
        spikeSortingParams.maxClusters=8;  %%(optional) (default 30) max number of initial clusters - final number may be different due to splitting/deleting
        spikeSortingParams.nStarts=1; %     (optional) (default 1) number of starts of the algorithm for each initial cluster count
        spikeSortingParams.splitEvery=10; %  (optional) (default 50) Test to see if any clusters should be split every n steps. 0 means don't split.
        spikeSortingParams.maxPossibleClusters=10; %(optional) (default 100) Cluster splitting can produce no more than this many clusters.
        %spikeSortingParams.features={'wavePC1','peakToValley','wavePC2'};
        %spikeSortingParams.features={'spikeWidth','peakToValley','energy'};
        %spikeSortingParams.features={'energy','wavePC1','waveFFT'};
        spikeSortingParams.featureList={'wavePC1','peakToValley','wavePC2'};  % peak to valley prob a bad idea for multiple leads, cuz we are not sensitive to per lead facts
        spikeSortingParams.featureList={'wavePC123'};
        spikeSortingParams.featureList = {'tenPCs'};
        spikeSortingParams.arrangeClustersBy = 'averageAmplitude'; %'averageAmplitude'; %clusterCount; %averageSpikeWidth; %'spikeWaveformStdDev'
        spikeSortingParams.postProcessing= 'biggestAverageAmplitudeCluster'; %'largestNonNoiseClusterOnly';
    case 'oSort'
        spikeSortingParams.doPostDetectionFiltering=0; % - (optional) specify whether or not to do post-detection filtering; see postDetectionFilter. only allow if 'none' which stops realigning;  otherwise deault is same as detection params, will error if not the same as detection params, *unless* detection is 'MTEO' in which case allow 'maxPeak' 'minPeak' 'maxMinPeak' 'power' Q: why can't we call MTEO for the realligning as well?
        spikeSortingParams.peakAlignMethod=1; %(optional)    peak alignment method used by osort's realigneSpikes method;  only for post upsampling jitter, 1=peak, 2=none, 3= power;
        spikeSortingParams.alignParam=2; %(optional) alignParam to be passed in to osort's realigneSpikes method; only for post upsampling jitter, only used if peakAlignMethod is 1=peak; if so (1: peak is max, 2: peak is min, 3: mixed)
        spikeSortingParams.distanceWeightMode=1; %(optional) mode of distance weight calculation used by osort's setDistanceWeight method, 1= weight equally; 2= weight peak more, and falloff gaussian, but check if peak center garaunteed to be 95, also its hard coded to 1 in assignToWaveform
        spikeSortingParams.minClusterSize=50; %(optional) minimum number of elements in each cluster; passed in to osort's createMeanWaveforms method
        spikeSortingParams.maxDistance=30; %(optional) maxDistance parameter passed in to osort's assignToWaveform method; set the thrshold for inclusion to a cluster based on MSE between waveforms, units: std [3-20]
        spikeSortingParams.envelopeSize=10; %(optional) parameter passed in to osort's assignToWaveform method; additionally must fall withing mean +/- envelopeSize*std (i think at every timepoint of waveform); [0.5-3]; set large (>100) for negnigable influence
    case 'useSpikeModelFromPreviousAnalysis'
        % do nothing now look below for details.
        
    otherwise
        error('unsupported spikeSorting method');
end

%% frameThresholds
frameThresholds.dropsAcceptableFirstNFrames=2; % first 2 frames won't kill the default quality test
frameThresholds.dropBound = 1.5;   %smallest fractional length of ifi that will cause the long tail to be called a drop(s)
frameThresholds.warningBound = 0.1; %fractional difference that will cause a warning, (after drop adjusting)
frameThresholds.errorBound = 0.6;   %fractional difference of ifi that will cause an error (after drop adjusting)
% this largish value of .6 allows really short frames after drops to not cause errors.  the other way around this is to crank up the drop bound beyond 1.5 but I think thats too dangerous
out.frameThresholds = frameThresholds;

%% stimClassToAnalyze and timeRangeForTrialSecs
out.stimClassToAnalyze={'all'}; 
% stimClassToAnalyze={'whiteNoise','gratings'};
out.timeRangePerTrialSecs=[0 Inf];

%% post processing
spikeSortingParams.postProcessing= 'biggestAverageAmplitudeCluster';  %'treatAllNonNoiseAsSpike'; %'treatAllAsSpike'; %'biggestAverageAmplitudeCluster';  %'largestNonNoiseClusterOnly',  
out.spikeSortingParams = spikeSortingParams;

%% LFP
spikeDetectionParams.sampleLFP = false; %true;
spikeDetectionParams.LFPSamplingRateHz =500;
out.spikeDetectionParams = spikeDetectionParams;

%% backup?
makeBackup = false;
out.makeBackup = makeBackup;

%% otherParams
otherParams.pauseForInspect = false;
otherParams.forceNoInspect = false;
otherParams.saveFigs = true;
otherParams.forceErrorOnNoAnalysis = true;
otherParams.checkCurrentUnit = true; % false; %true; use this only when you want to check the analysis for a single trode and add it to the currentUnit file in /rat#/analysis/singleUnits
out.otherParams = otherParams;