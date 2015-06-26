function setupParamsForAnalysis(varargin)
% this is a temporary working m-file for testing out the settings of spike sorting
% it is not meant to be called as a function; 
% cd('C:\Documents and Settings\rlab\Desktop\ratrix\bootstrap')
% setupEnvironment
%% twiddle the params and sort it
close all
% clear variables

%% path
% path='\\132.239.158.183\rlab_storage\pmeier\backup\devNeuralData_090310'; %b/c i can't see datanet_storage folder on .179
% path='\\132.239.158.183\rlab_storage\pmeier\backup\neuralData_090505';
% path='C:\Documents and Settings\rlab\Desktop\neural';
%path='\\132.239.158.179\datanet_storage' % streaming to C:
% path='H:\datanetOutput'  % local
path='\\132.239.158.169\datanetOutput';  %on the G drive remote

% path='C:\Documents and Settings\rlab\My Documents\work\physiology data';  %local computer
% path = 'C:\Users\balaji\Documents\My Dropbox';
%path = '\\132.239.158.158\work\physiology data'

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
        % spikeDetectionParams.samplingFreq=samplingRate; % don't define if using analysis manager, just for temp testing of getSpikesFromNeuralData
        % Wn = [300 4000]/(spikeDetectionParams.samplingFreq/2); % default to bandpass 300Hz - 4000Hz
        % [b,a] = butter(4,Wn); Hd=[]; Hd{1}=b; Hd{2}=a;
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

%% sets CELL BOUNDARY ranges
if 1
% %LGN - 16 ch - 
% subjectID = '356'; channels={[2:6 9:11]}; thrV=[-0.02 Inf]; cellBoundary={'trialRange',[8]};%ffgwn- LGN
% %subjectID = '356'; channels={[11 10 2 3]}; thrV=[-0.02 Inf]; cellBoundary={'trialRange',[110]};%ffgwn- LGN
% subjectID = '356'; channels={[4 11]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[110]};%ffgwn- LGN
% subjectID = '356'; channels={[11 4]}; thrV=[-0.09 Inf]; cellBoundary={'trialRange',[110 118]};%ffgwn- LGN - no temporal STA on these chans (but phys 12 & 15?)
% subjectID = '356'; channels={[8]}; thrV=[-0.09 Inf]; cellBoundary={'trialRange',[110]};%guess 8 is 15? - gets the monitor intensity, 0 lag
% subjectID = '356'; channels={[6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[110 118]};%chart says 6 is 15, this has an STA! yay!
%% multiple cells gwn 
% %3 cells - these leads may or may not have the same cells on them, given their spacing of 50um
% subjectID = '356'; channels={[2:6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[345 354]};%3 cells, gwn
% subjectID = '356'; channels={[2 9:11]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[345 354]};%3 cells, gwn
% %subjectID = '356'; channels={[2:6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[377 380]};%3 cells
% subjectID = '356'; channels={2,9,10,11}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[345]};%3 cells, gwn
% subjectID = '356'; channels={2}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[345 354]};%3 cells, gwn
% %LONG PAUSE, but same 3 cells/ location

% subjectID = '356'; channels={2,9,10}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[397 401]};%3 cells, gwn
% % subjectID = '356'; channels={[10]}; thrV=[-0.06 Inf];
% cellBoundary={'trialRange',[397 403]};
% %subjectID = '356'; channels={[9]}; thrV=[-0.07 Inf]; cellBoundary={'trialRange',[397 403]};
% %subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[397 403]}; % has different temporal shape
% subjectID = '356'; channels={[2],[6],[10],[9]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[397 403]};%3 cells, gwn

% %subjectID = '356'; channels={[2]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[432]}; %
%% spatial
% subjectID = '356'; channels={[10]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[432 444]}; % has spatial, upper right
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[432 444]};  % has a different spatial!
% subjectID = '356'; channels={[9]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[432 442]};  % this is a bit weaker, same lower center location
% subjectID = '356'; channels={[10],[6],[9]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[432 442]};  % this is a bit weaker, same lower center location ** errors at snippeting

% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[377 380]}; %3 cells, stronger response to lower contrast delayed??
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[377]}; %3 cells, stronger response to lower contrast delayed??
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[485]}; %fffc about 3 trials near here 482-485ish?
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc
% subjectID = '356'; channels={[10]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc - probably 2 cells lumped into 1 anay
% subjectID = '356'; channels={[2]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc 
% subjectID = '356'; channels={[1],[2]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[550]};

%% post spatial. muscimol additions
% figuring out the parameters for spike detection
% {2,-0.03}
% {3,-0.02}
% {4,-0.03}
% {5,-0.018}
% {6,-0.025}
% {7,-----}
% {8,-0.02}
% {9,-0.025}
% {10,-0.05}
% {11,-0.04}
% {12 -----}
% {13 -----}
% {14 -----}
%  thrV=[-0.02 Inf -0.2;...
%      -0.04 Inf -0.2;...
%      -0.06 Inf -0.2;...
%      -0.04 Inf -0.2;...
%      -0.06 Inf -0.2;...
%      -0.06 Inf -0.2];
%  
% subjectID = '356'; channels={3,4,5,6,9,11}; cellBoundary={'trialRange',[551]};

%% 357
%% NEW CELL
% range from 1-21 (Pen#5)
% thrV=[-0.05 Inf 0.4;...
%     -0.05 Inf 0.4;...
%     -0.05 Inf 0.4;...
%     -0.04 Inf 0.2;...
%     -0.05 Inf 0.4];
% subjectID = '357'; channels={2,3,6,9,14};  cellBoundary={'trialRange',[1 21]}; pauseForInspect = false;
%% NEW CELL
%  subjectID = '357'; channels={2,3,6,8,9,10,14}; thrV =[-0.04 Inf 0.4]; cellBoundary={'trialRange',[8 21]}; %trf % bad. probably due to frames??? check spike record

% % range from 22-33 ffgwn % chans 9 and 14 have visual spikes
% thrV = [-0.06 Inf 0.4;...
%     -0.10 Inf 0.4;...
%     -0.04 Inf 0.4;...
%     ];
% subjectID = '357'; channels={5,9,14};  cellBoundary={'trialRange',[22 33]}; pauseForInspect = false; 
 
% range from 34-37 trf % both 9 and 14 have spikes that respond to slow trf
% thrV = [-0.10 Inf 0.4;...
%     -0.04 Inf 0.4;...
%     ];
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[34 37]}; pauseForInspect = false;

% % range from 38-43 bin 6X8 % somewhat unbelievable spat STAs
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[38 43]}; pauseForInspect = false;

% % range from 44-48 sf % 9 is not particularly modulated. 14 looks better. 
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[44 48]}; pauseForInspect = false;

% % range from 51 - 81 bin 6X8 % 14 has clear spat rf in lower right. 9 is
% % unclear
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[51 81]}; pauseForInspect = false;

% % range from 83 - 86 or not significantly tuned to any direction
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[83 86]}; pauseForInspect = false;
% % subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[86]}; pauseForInspect = false; % has issues!!!

% range from 83 - 86 or not significantly tuned to any direction
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[83 86]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW LOCATION
% thrV = [-.05 Inf;...
%     -.04 Inf;...
%     ];
% % 171- 191 is ffgwn% only 8 and 11 have stuff in them
% subjectID = '357'; channels={8,11};  cellBoundary={'trialRange',[171 191]};

% % 192- 197 is trf % both respond well to slow frequencies (2 Hz) % actually
% % trode chan 11 has 2 nicely separable spikes having diff trfs.
% subjectID = '357'; channels={8,11};  cellBoundary={'trialRange',[192 197]};

% % 199- 216 is bin 6X8; both show good spat RFs. only one of the spikes in
% 11 has a spat rf (the thin one)
% subjectID = '357'; channels={8,11};  cellBoundary={'trialRange',[199 215]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW LOCATION
% 342-355 is ffgwn. finding good chans
% thrV = [-0.07 Inf 0.5;...
%     -0.07 Inf 0.5;...
%     -0.04 Inf 0.5;...
%     -0.035 Inf 0.5...
%     ];
% subjectID = '357'; channels={2,5,8,14};  cellBoundary={'trialRange',[342 355]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 365
% thrV = [-0.20 Inf];
% subjectID = '365'; channels={6,9};  cellBoundary={'trialRange',[32 37]}; % ffgwn
% subjectID = '365'; channels={6};  cellBoundary={'trialRange',[41 50]}; % bin 6X8 % 9 had issues and had very few spikes
% subjectID = '365'; channels={6,9};  cellBoundary={'trialRange',[55 57]}; % sinGrspFr
% subjectID = '365'; channels={6,9};  cellBoundary={'trialRange',[58 60]}; % sqrGrspFr
% % ll this data is useless(seeding is kinda messed up);
% subjectID = '365'; channels={6,9};  cellBoundary={'trialRange',[72]}; % sqrGrspFr
% subjectID = '365'; channels={6,9};  cellBoundary={'trialRange',[74 76]}; % orientations
% subjectID = '365'; channels={6};  cellBoundary={'trialRange',[120 129]}; % bin 6X8
% subjectID = '365'; channels={6};  cellBoundary={'trialRange',[130 140]}; % bin 6X8
% subjectID = '365'; channels={6};  thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[142 145]}; % or
%% 366
% subjectID = '366'; channels={3,4}; thrV = [-0.1 Inf 0.5; -0.08 Inf 0.5]; cellBoundary={'trialRange',[20 33]}; %ffgwn
% subjectID = '366'; channels={3,4}; thrV = [-0.1 Inf 0.5; -0.08 Inf 0.5]; cellBoundary={'trialRange',[35 37]}; %sfSinGr
% subjectID = '366'; channels={3,4}; thrV = [-0.1 Inf 0.5; -0.08 Inf 0.5]; cellBoundary={'trialRange',[38 40]}; %sfSinGr

% subjectID = '366'; channels={3,4}; thrV = [-0.1 Inf 0.5; -0.08 Inf 0.5]; cellBoundary={'trialRange',[45 47]}; %orgr1024

% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[53 72]}; %ffgwn300
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[73 92]}; %ffgwn600


%% new cell
% subjectID = '366'; channels={3,6,8,9,12}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[113 125]}; %ffgwn300


% subjectID = '366'; channels={3,6,8,9}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[166 168]}; %or
% trialRange = [166 167 168];
% subjectID = '366'; channels={3,6}; thrV = [-0.1 Inf 0.5]; %cellBoundary={'trialRange',[166 168]}; %or
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[192 222],'trialMask',[192] }; %ffgwnsearch
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[193 222]}; %ffgwnsearch
% 
% subjectID = '366'; channels={3,6,8}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[268 278]}; %or
% trialRange = [268:278];
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[328 340]}; %ffgwn
% subjectID = '366'; channels={3}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[353 361]}; %or
% 
% 
% subjectID = '366'; channels={3}; thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[367 373]}; %ffgwn
% 
% %% this is just for the sort before and after muscimol......
% %chan 3...whats happeing here?
% subjectID = '366'; channels={3}; thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[113 172],'trialMask',[138:156 177:180 192 366]}; %ffgwn
% subjectID = '366'; channels={3}; thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[181 210],'trialMask',[192]}; %ffgwn
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[140 141]};
% trialRange = [140 141];
% trialRange = [237:240];
% %% 354
% subjectID = '354'; channels={1}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[20 26]}; %trf
% subjectID = '354'; channels={1}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[40 41]}; %or1024
% 
% subjectID = '354'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[53 60]}; %ffgwn
% subjectID = '354'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[61 65]}; %or1024
% subjectID = '354'; channels={1}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[67 90]}; %bin6X8
% % 
% subjectID = '354'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[120 124]}; %sf

%% 353
subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[3 5]}; %fgwn
subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[25 28]}; %sf
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[30 34]}; %or

% subjectID = '353'; channels={1}; thrV = [-0.25 Inf 0.5]; cellBoundary={'trialRange',[59 60]}; %ffgwn

% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[87 90]}; %ffgwn


% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[153 199],'trialMask',[173:177]}; %all before
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[200 296],'trialMask',[259 260]}; %all before

% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[160 165],'trialMask',163}; %or1024
% trialRange = [160:165];
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[167 172]}; %sf
% 
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[183 197]}; %bin 6X8
% 
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[225 227]}; %or after muscimol
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[228 230]}; %or after muscimol
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[225 235],'trialMask',235}; %or after muscimol
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[241 248],'trialMask',235}; %or after muscimol

% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[251 253],'trialMask',235}; %sf
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[265 270]}; %or after muscimol
% trialRange = [265:270];


% spatial frequency before muscimol
% subjectID = '364'; channels={1}; thrV = [-0.15 Inf 0.4]; cellBoundary={'trialRange',[137 138]};% sf
% spatial frequency after muscimol
% subjectID = '364'; channels={1}; thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[222 225]};% sf

end

%% stimClassToAnalyze and timeRangeForTrialSecs
stimClassToAnalyze={'all'}; 
% stimClassToAnalyze={'whiteNoise','gratings'};
timeRangePerTrialSecs=[0 Inf];

%% finetuning
spikeSortingParams.postProcessing= 'treatAllNonNoiseAsSpike';  %'treatAllNonNoiseAsSpike'; %'treatAllAsSpike'; %'biggestAverageAmplitudeCluster';  %'largestNonNoiseClusterOnly',  
spikeDetectionParams.sampleLFP = false; %true;
spikeDetectionParams.LFPSamplingRateHz =500;

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
switch spikeSortingParams.method
    case 'useSpikeModelFromPreviousAnalysis'
        spikeSortingParams.subjectID = subjectID;
        spikeSortingParams.path = path;
        spikeSortingParams.modelBoundaryRange = []; %% need to specify this here
end
        
%% historical logicals not currently in use
overwriteAll=1; % if not set, analysis wont sort spikes again, do we need?: 0=do if not there, and write, 1= do always and overwrite, 2= do always, only write if not there or user confirm?
usePhotoDiodeSpikes=0;
%spikeDetectionParams.method='activeSortingParametersThisAnalysis';  % will override this files choices with the active params for this *subject*
%spikeSortingParams.method='klustaModel';  NEED TO NOT DELETE THE MODEL
%FOLDER FILE>>>

%% SET THE ANALYSIS MODE HERE
if nargin>0
    analysisMode = varargin{1};
else
    analysisMode = 'viewAnalysisOnly';
end
%% ideas for analysisMode implemented
% analysisMode = 'overwriteAll';
% analysisMode = 'onlyAnalyze';
% analysisMode = 'viewAnalysisOnly'; 
% analysisMode = 'onlyDetect';
% analysisMode = 'onlySort';
% analysisMode = 'onlyDetectAndSort';
% analysisMode = 'onlyInspect';
% analysisMode = 'onlyInspectInteractive';
%% unimplemented ideas for analysisMode
% analysisMode = 'viewFirst';
% analysisMode = 'detectAndSortOnFirst'; %without user interaction
% analysisMode = 'detectAndSortOnAll'; %without user interaction
% analysisMode = 'interactiveDetectAndSortOnFirst'; %with user interaction
% analysisMode = 'interactiveDetectAndSortOnAll'; %with user interaction
% analysisMode = 'viewContinuous';
% analysisMode = 'viewLast';
% analysisMode = 'analyzeAtEnd';
% analysisMode = 'onlyDetectSpikes';
% analysisMode = 'onlySortSpikes';
% analysisMode = 'interactiveOnlyDetectSpikes';
% analysisMode = 'interactiveOnlySortSpikes';
% analysisMode = 'usePhotoDiodeSpikes';

%% backup?
makeBackup = false;

%% otherParams
otherParams.pauseForInspect = false;
otherParams.forceNoInspect = false;
otherParams.saveFigs = true;
otherParams.forceErrorOnNoAnalysis = true;
%% actual call to analysis
whichAnalysis = 'physAnalysis'; % 'extraAnalysis'; % 'physAnalysis';
switch whichAnalysis
    case 'physAnalysis'
        doNewAnalysis = true;
        if doNewAnalysis
            timeStart = now;
%             failedTrials = {};
%             pauseON = false;
%             for currentTrialNum = trialRange
%                 cellBoundary={'trialRange',[currentTrialNum]};
%                 try
            analyzeBoundaryRange(subjectID, path, cellBoundary, channels,spikeDetectionParams, spikeSortingParams,...
                timeRangePerTrialSecs,stimClassToAnalyze,analysisMode,otherParams,frameThresholds,makeBackup);
%                 catch exception
%                     failedTrials{end+1}{1} =  currentTrialNum;
%                     failedTrials{end}{2} =  exception;
%                 end
%                 if pauseON
%                     pause
%                 end
%             end
            fprintf('That analysis took %2.2f seconds.\n',(now-timeStart)*84600);
        end
        %% earlier calls for analysis
        useOldAnalysis = false;
        if useOldAnalysis
            analysisManagerByChunk(subjectID, path, cellBoundary, channels,spikeDetectionParams, spikeSortingParams,...
                timeRangePerTrialSecs,stimClassToAnalyze,overwriteAll,usePhotoDiodeSpikes,[],frameThresholds)
            optimizeSortingByChannel(subjectID, path, cellBoundary, channels,spikeDetectionParams, spikeSortingParams, ...
                timeRangePerTrialSecs,stimClassToAnalyze,overwriteAll,usePhotoDiodeSpikes)
        end
    case 'extraAnalysis'
        %edit historicalSpikeFiddlerCalls
        extraAnalysesOn = true;
        if extraAnalysesOn
            singleUnitFile = 'C:\Documents and Settings\rlab\My Documents\work\results\singleUnits\unit1.mat';
            if ~exist(singleUnitFile,'file')
                unit=singleUnit(subjectID,[]);
                save(singleUnitFile,'unit');
            else
                temp = load(singleUnitFile);
                unit = temp.unit;
            end
            numChans = length(channels);
            currChanNum = 1;
            trialRange = cellBoundary{2}; 
            if length(trialRange)==2
                str = sprintf('%d-%d',trialRange(1),trialRange(2));
            else
                str = sprintf('%d',trialRange(1));
            end
            analysisFile = fullfile(path,subjectID,'analysis',str,'physAnalysis.mat');
            temp = load(analysisFile);
            physAnalysis = temp.physAnalysis;
            if length(physAnalysis)>1
                error
            end
            c= physAnalysis{1}{1};
            trodeStr = createTrodeName(channels{currChanNum});
            trialNums = physAnalysis{1}{2};
            switch physAnalysis{1}{3}
                case 'whiteNoise'
                    if size(c.(trodeStr).cumulativeSTA(:,:,1))==1
                        currAnalysis = FFSTA(subjectID,trialNums(1):trialNums(2),c.(trodeStr));
                    else
                        currAnalysis = STSTA(subjectID,trialNums(1):trialNums(2),c.(trodeStr));
                    end
                case 'gratings'
                    % do nothing right now'
            end
            keyboard
            unit = singleUnit(unit,currAnalysis);
        end
end



warndlg('done','done');
% plotFiringRateOverTime(subjectID, path, cellBoundary, channels)
end