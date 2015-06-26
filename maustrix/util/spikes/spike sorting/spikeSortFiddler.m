% this is a temporary working m-file for testing out the settings of spike sorting
% it is not meant to be called as a function; 

%% twiddle the params and sort it
close all
% path='\\132.239.158.183\rlab_storage\pmeier\backup\devNeuralData_090310'; %b/c i can't see datanet_storage folder on .179
% path='\\132.239.158.183\rlab_storage\pmeier\backup\neuralData_090505';
% path='C:\Documents and Settings\rlab\Desktop\neural';
%path='\\132.239.158.179\datanet_storage' % streaming to C:
%path='H:\datanetOutput'  % local
%path='\\132.239.158.169\datanetOutput'  %on the G drive remote\\

    recordsPath.neuralRecordLoc = '\\132.239.158.158\physdata';
    recordsPath.stimRecordLoc = '\\132.239.158.158\physdata';
    recordsPath.spikeRecordLoc = '\\132.239.158.158\physdata';
    recordsPath.analysisLoc = '\\132.239.158.158\physdata';
    recordsPath.eyeRecordLoc = '\\132.239.158.158\physdata';
% path='C:\Documents and Settings\rlab\My Documents\work\physiology data'  %local computer

if 1 %use filteredThresh
    spikeDetectionParams=[];
    spikeDetectionParams.method = 'filteredThresh';
    spikeDetectionParams.freqLowHi = [200 10000];
    spikeDetectionParams.threshHoldVolts = [-0.1 Inf];
    spikeDetectionParams.waveformWindowMs= 1.5;
    spikeDetectionParams.peakWindowMs= 0.6;
    spikeDetectionParams.alignMethod = 'atPeak'; %atCrossing
    spikeDetectionParams.peakAlignment = 'filtered'; % 'raw'
    spikeDetectionParams.returnedSpikes = 'filtered'; % 'raw'
    spikeDetectionParams.lockoutDurMs=spikeDetectionParams.waveformWindowMs-spikeDetectionParams.peakWindowMs;
else
    spikeDetectionParams=[];
    spikeDetectionParams.method='oSort';
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
end

spikeDetectionParams.ISIviolationMS=2; % just for human reports
    
if 1 %use klusta
    spikeSortingParams=[];
    spikeSortingParams.method='KlustaKwik';
    spikeSortingParams.minClusters=3; % (optional) (default 20) min number of initial clusters - final number may be different due to splitting/deleting
    spikeSortingParams.maxClusters=8;  %%(optional) (default 30) max number of initial clusters - final number may be different due to splitting/deleting
    spikeSortingParams.nStarts=1; %     (optional) (default 1) number of starts of the algorithm for each initial cluster count
    spikeSortingParams.splitEvery=10; %  (optional) (default 50) Test to see if any clusters should be split every n steps. 0 means don't split.
    spikeSortingParams.maxPossibleClusters=10; %(optional) (default 100) Cluster splitting can produce no more than this many clusters.
    %spikeSortingParams.features={'wavePC1','peakToValley','wavePC2'};
    %spikeSortingParams.features={'spikeWidth','peakToValley','energy'};
    %spikeSortingParams.features={'energy','wavePC1','waveFFT'};
    spikeSortingParams.featureList={'wavePC1','peakToValley','wavePC2'};  % peak to valley prob a bad idea for multiple leads, cuz we are not sensitive to per lead facts
    spikeSortingParams.featureList={'wavePC123'};
    spikeSortingParams.postProcessing= 'biggestAverageAmplitudeCluster'; %'largestNonNoiseClusterOnly';
else
    spikeSortingParams=[];
    spikeSortingParams.method='oSort';
    spikeSortingParams.doPostDetectionFiltering=0; % - (optional) specify whether or not to do post-detection filtering; see postDetectionFilter. only allow if 'none' which stops realigning;  otherwise deault is same as detection params, will error if not the same as detection params, *unless* detection is 'MTEO' in which case allow 'maxPeak' 'minPeak' 'maxMinPeak' 'power' Q: why can't we call MTEO for the realligning as well?
    spikeSortingParams.peakAlignMethod=1; %(optional)    peak alignment method used by osort's realigneSpikes method;  only for post upsampling jitter, 1=peak, 2=none, 3= power;
    spikeSortingParams.alignParam=2; %(optional) alignParam to be passed in to osort's realigneSpikes method; only for post upsampling jitter, only used if peakAlignMethod is 1=peak; if so (1: peak is max, 2: peak is min, 3: mixed)
    spikeSortingParams.distanceWeightMode=1; %(optional) mode of distance weight calculation used by osort's setDistanceWeight method, 1= weight equally; 2= weight peak more, and falloff gaussian, but check if peak center garaunteed to be 95, also its hard coded to 1 in assignToWaveform
    spikeSortingParams.minClusterSize=50; %(optional) minimum number of elements in each cluster; passed in to osort's createMeanWaveforms method
    spikeSortingParams.maxDistance=30; %(optional) maxDistance parameter passed in to osort's assignToWaveform method; set the thrshold for inclusion to a cluster based on MSE between waveforms, units: std [3-20]
    spikeSortingParams.envelopeSize=10; %(optional) parameter passed in to osort's assignToWaveform method; additionally must fall withing mean +/- envelopeSize*std (i think at every timepoint of waveform); [0.5-3]; set large (>100) for negnigable influence
end

frameThresholds.dropsAcceptableFirstNFrames=2; % first 2 frames won't kill the default quality test
frameThresholds.dropBound = 1.5;   %smallest fractional length of ifi that will cause the long tail to be called a drop(s)
frameThresholds.warningBound = 0.1; %fractional difference that will cause a warning, (after drop adjusting)
frameThresholds.errorBound = 0.6;   %fractional difference of ifi that will cause an error (after drop adjusting)
% this largish value of .6 allows really short frames after drops to not cause errors.  the other way around this is to crank up the drop bound beyond 1.5 but I think thats too dangerous


subjectID = '231'; channels={1}; cellBoundary={'trialRange',[1]};%natural grating drives it %%5.30.2010
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[4]};%TRF - great!


subjectID = '231'; channels={1}; cellBoundary={'trialRange',[30]};%SF
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[25]};%ffflank

subjectID = '231'; channels={1}; cellBoundary={'trialRange',[5 14]};%error in analysis
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[15 21]};%error in analysis
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[38 44]};%sparse bright
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[46 50]};%ffgwn

subjectID = '231'; channels={1}; cellBoundary={'trialRange',[66]};%trf DUPPED
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[93 110   ]};%6x8 bin DUPPED
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[70 91]};%3x4 bin DUPPED

subjectID = '231'; channels={1}; cellBoundary={'trialRange',[70 73]};%ffFlanker
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[75]};%ffFlanker contrast - gamma
% subjectID = '231'; channels={1}; cellBoundary={'trialRange',[79 83]};%ffFlanker contrast - lin
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[81 87]};%ffFlanker contrast - lin
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[90]};%ffFlanker contrast - closer to screen (15)
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[91]};%ffFlanker contrast - closer to screen (15)
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[93 94]};%ffFlanker contrast - 128 ppc - has an error?
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[96]};%confirm cell in there with hammer
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[99]};%luminance ff flankers drive it. (step 7)
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[103 105]};%fff contr drive it weakly. (step 40)
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[106 109]};%fff contr drive it weakly. (step 40)
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[106 124]};%fff contr drive it weakly. (step 40)
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[125]};%

%NEW CELL
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[127 129]};%nat grating

subjectID = '231'; channels={1}; cellBoundary={'trialRange',[134]};%trf
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[140]};%sparse dark
%manual stuff
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[149]};%seems quite suppressed by some gratings
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[149]};%seems quite suppressed by some gratings
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[152 154]};%ffgwn
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[158]};%trf! - may be good but skipped
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[162 163 ]};%bin grid-
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[167]};%fff
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[168]};%fff
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[169 172]};%fff

%NEW CELL
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[269]};%trf
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[271 272]};%fffc

%NEW CELL
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[292]};%trf
%trying to tune it in
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[295]};%trf

%NEW CELL
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[356]};%trf

subjectID = '231'; channels={1}; cellBoundary={'trialRange',[361 368]};%fffc
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[370]};%sf

subjectID = '231'; channels={1}; cellBoundary={'trialRange',[361 368]};%fffc
subjectID = '231'; channels={1}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[361 362]};%fffc
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[362]};%fffc


%NEW DAY CELL
%DUPPED DATA
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[432 437]};%trf 341 +
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[439 445]};%gwn has STA, spikes def visual, though tonic mode may be adding noise?
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[447 455]};%bin 
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[456]};%fff, something pushes through silent mode
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[457]};%sf, something pushes through silent mode
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[460]};%or, oscilates at first, then held off
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[462 465]};%sparse bright, ocation burst then tonic, esp at start flash
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[462 472]};%sparse bright, ocation burst then tonic
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[475 495]};%fffc,
subjectID = '231'; channels={1}; thrV=[-0.2 Inf]; cellBoundary={'trialRange',[474]};%fffc, 5 burst tonic cycles, NOTE: smaller spikes exist about 1/3 the size
subjectID = '231'; channels={1}; thrV=[-0.07 Inf]; cellBoundary={'trialRange',[474]};%fffc, 5 burst tonic cycles, NOTE: smaller spikes exist about 1/3 the size
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[497]};%anulus

%ANOTHER DUP
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[436]};%anulus, centered over the rf
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[437]};%eye fixed

%NEXT DUP
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[433]};%anulus, centered over the rf

subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[443]};%fc, some bursts caused by some of the stim. high SNR
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[446]};%fc, some bursts caused by some of the stim. high SNR

subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[ ]};%fffc, some bursts caused by some of the stim. high SNR

subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[456]};%radii
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[458]};%annuli
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[459]};%flankers 1 phase=
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[461]};%bipartite for XY
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[463]};%bipartite for XY


subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[472 484]};%ffgwn - iso 2
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[499 502]};%ffgwn - iso 0.75, till 506?

subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[508]};%fc- iso 0.75
% some dups 508-510
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[511 519]};%ffgwn- iso 0.75
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[528 529]};%ffgwn- iso 0.25 % lost cell?
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[538 540]};%ffgwn- iso 0.25 % lost cell?
subjectID = '231'; channels={1}; thrV=[-0.18 Inf]; cellBoundary={'trialRange',[592]};%ffgwn- wake

% %LGN - 16 ch - 
% subjectID = '356'; channels={[2:6 9:11]}; thrV=[-0.02 Inf]; cellBoundary={'trialRange',[8]};%ffgwn- LGN
% %subjectID = '356'; channels={[11 10 2 3]}; thrV=[-0.02 Inf]; cellBoundary={'trialRange',[110]};%ffgwn- LGN
% subjectID = '356'; channels={[4 11]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[110]};%ffgwn- LGN
% subjectID = '356'; channels={[11 4]}; thrV=[-0.09 Inf]; cellBoundary={'trialRange',[110 118]};%ffgwn- LGN - no temporal STA on these chans (but phys 12 & 15?)
% subjectID = '356'; channels={[8]}; thrV=[-0.09 Inf]; cellBoundary={'trialRange',[110]};%guess 8 is 15? - gets the monitor intensity, 0 lag
% subjectID = '356'; channels={[6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[110 118]};%chart says 6 is 15, this has an STA! yay!
% 
% %3 cells - these leads may or may not have the same cells on them, given their spacing of 50um
% subjectID = '356'; channels={[2:6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[345 354]};%3 cells, gwn
% subjectID = '356'; channels={[2 9:11]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[345 354]};%3 cells, gwn
% %subjectID = '356'; channels={[2:6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[377 380]};%3 cells
% subjectID = '356'; channels={[2 9:11]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[345]};%3 cells, gwn
% %LONG PAUSE, but same 3 cells/ location
% subjectID = '356'; channels={[2]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[397 401]};%3 cells, gwn
% subjectID = '356'; channels={[10]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[397 403]};
% %subjectID = '356'; channels={[9]}; thrV=[-0.07 Inf]; cellBoundary={'trialRange',[397 403]};
% %subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[397 403]}; % has different temporal shape
% %subjectID = '356'; channels={[2]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[432]}; %
% subjectID = '356'; channels={[10]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[432 444]}; % has spatial, upper right
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[432 444]};  % has a different spatial!
% subjectID = '356'; channels={[9]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[432 442]};  % this is a bit weaker, same lower center location
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[377 380]}; %3 cells, stronger response to lower contrast delayed??
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[485]}; %fffc about 3 trials near here 482-485ish?
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc
% subjectID = '356'; channels={[10]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc - probably 2 cells lumped into 1 anay
% subjectID = '356'; channels={[2]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc 
subjectID = '356'; channels={[1],[2]}; thrV=[-0.01 Inf]; cellBoundary={'trialRange',[551]};

subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[615]};%ffgwn- anesth
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[646]};%fff- anesth
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[651 654]};%fffc- anesth
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[651 667]};%fffc- anesth
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[663]};%fffc- cell was more excitable this trial; anesth
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[668]};%ffgwn- 
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[669 675]};%nat gratings
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[675]};%nat gratings
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[677]};%nat gratings, switches to rate coding?
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[681]};%trf
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[682]};%trf
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[686 689]};%sparse brighter
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[701]};%sparse brighter smaller
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[702 706]};%stops spiking, tho the eyes are still opemn
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[709 711]};%bigger
%moving monitor...
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[713 717]};%drives it cnosisyently
% tried to position manulus
% crashed on stop
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[736 737]};%sparse confrim location
%subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[739]};%f contrast in tye right plae but no drive!
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[743]};%f contrast, cicular hack - crashed do to memory eye data
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[745 746]};%sparse
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[748 752]};%fc again - 1 rep
%subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[748 755]};%fc again - 1 rep
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[762]};%fc again - 1 rep
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[760]};%spa
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[762 763]};%fc
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[764 768]};%fffc - iso at 1%
%subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[774]};%fffc - taking iso off, futzing around in front of rat
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[775 769]};%fffc - iso just off
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[780 785]};%fffc - still no whisking, but stable and light
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[786 792]};%fffc - still no whisking, but stable and light
subjectID = '231'; channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[793 797]};%fffc - poking the rat, and trying to get him to wake



%JULY 3rd, 2010
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[806 830]};%gwn
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[831 832]};%NAT GRATING
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[834 836]};%fffc
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[838 844]};%sparse brighter 6x8
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[846 847]};%hbars
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[849 851]};%vbars
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[853]};%sf  - WORTH ANALYZING
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[863]};%manualus, hard to isolate
subjectID = '231'; channels={1}; thrV=[-Inf 0.25 ]; cellBoundary={'trialRange',[866 871]};%bin6x8

%NEW CELL
subjectID = '231'; channels={1}; thrV=[- 0.15 Inf]; cellBoundary={'trialRange',[878 887]};%gwn
subjectID = '231'; channels={1}; thrV=[- 0.15 Inf]; cellBoundary={'trialRange',[889 891]};%fffc - why many dropped frames?
subjectID = '231'; channels={1}; thrV=[- 0.15 Inf]; cellBoundary={'trialRange',[889 906]};%fffc - fewer drops later  (897 has noise)
subjectID = '231'; channels={1}; thrV=[- 0.15 Inf]; cellBoundary={'trialRange',[909 913]};%NAT GRATING
subjectID = '231'; channels={1}; thrV=[- 0.15 Inf ]; cellBoundary={'trialRange',[915 937]};%bin 6x8  nothig obvipus spatial frst run
subjectID = '231'; channels={1}; thrV=[- 0.15 Inf]; cellBoundary={'trialRange',[941]};%sf

%NEW CELL (upward may be retinal, downward else?)
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[956 960]};%gwn
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[965]};%sf, some drops
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[967]};%or, some drops
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[969 977]};%bin 6x8, some drops
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[978 983]};%bin 6x8, some drops
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[995 1009]};%fffc, background firing rate modulation - java mem. NEED TO TURN OFF SOME PLOTS TO SEE IT

subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[1011 1012]};%nat gratings
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[1014 1015]};%sparse BRIGHT and then DARK
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[1022 1027]};%bin6x8
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[1028 1046]};%bin6x8 b, eye moves, drifts
subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[1053 1063]};%bin12x16 %drifting on trials: 1056,1062 (prob others too, but def those)
subjectID = '231'; channels={1}; thrV=[-Inf .19]; cellBoundary={'trialRange',[1066]};%fffc [1065 1070  ], drifting on trials: 1067 x2, correlates to rise in rtae, need to drop thresh, sorting may be challangeing
%subjectID = '231'; channels={1}; thrV=[-Inf .2]; cellBoundary={'trialRange',[1074]};%fffc iso off, on oxy for one trial, then free air
%BASED ON A DECREASE IN SNR for spike quality, this data is probably challengiong to detect and sort spikes.
%subjectID = '231'; channels={1}; thrV=[-Inf .2];
cellBoundary={'trialRange',[1074 1090]};%fffc waking
cellBoundary={'trialRange',[1094]};%fffc first blink
cellBoundary={'trialRange',[1115]};%fffc still under, going to poke whiskers on this trial
subjectID = '231'; channels={1}; thrV=[-0.13 Inf]; cellBoundary={'trialRange',[1100 1104]};%fffc, Downward MUA
subjectID = '231'; channels={1}; thrV=[-Inf .18]; cellBoundary={'trialRange',[1100 1104]};%fffc 
subjectID = '231'; channels={1}; thrV=[-Inf .18]; cellBoundary={'trialRange',[1121]};%awake, eye boggle, whisk
subjectID = '231'; channels={1}; thrV=[-0.13 Inf]; cellBoundary={'trialRange',[1123 1127]};%gwn, passive

% NEW CELL
subjectID = '231'; channels={1}; thrV=[-0.13 Inf]; cellBoundary={'trialRange',[1149]};%gwn, passive

%JULY 5th - A NICE LOOKING SPIKE, LATER HALF VERY STABLE (some drift fixed earlier ~trial 1173)
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1163 1173]};%gwn, passive
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1163 1173]};%sf
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1187 1189]};%hbars
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1191 1195]};%vbars
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1197 1209]};%fffc, random seed set to 1, 6 reps
%subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1201]};%fffc, confirmed visually that the OFF high contrast spiked most... don't trust the contrast... odd
%subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1207]};%fffc
%subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1217 1224]};%fffc, with longer gap,  random seed set to 1, 6 reps; last chunk miss frames, problem
%subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1223]};%fffc, with longer gap,  random seed set to 1, 6 reps
%%subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1228 1234]};%fffc, don't trust this range, fixing bug in randomizer
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1235 1243]};%fffc, randomized to clock once per trial, 4 reps
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1235 1269]};%fffc, more of above
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1270 1273]};%fffc, turning off iso (1270 may have noise from me touching the rig)
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1274]};%fffc, cell gets small
subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1275 1299]};%fffc, hunting while rat gets lighter and stimuli keep running (3 or 4 sorts would be needed, none that interesting)

%NEW CELL
% may have s potential
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1300 1304]};%fffc, found a cell with good enough SNR
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1300 1304]};%ffgwn
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1305 1316]};%ffgwn
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1318]};%sf
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1320]};%6x8bin, eye very squinty
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1326]};%tf
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1327 1336]};%ffgwn
%something else in between
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1340 1350]};%ffgwn
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1352 1362]};%fffc, eyes squinty
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1363]};%fffc, animal moves and brain state changes
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1364]};%sf, balaji wants it;  eye squnity still
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1382]};%td, rat awake now
%subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1384]};%fffc, rat awake now
%subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[13xx]};%fffc, some cell hunting
%subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1398]};%fffc, touching rat tail so eyes open for 1 full trial



subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1197 1209]};%fffc, random seed set to 1, 6 reps
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1361 1362]};%fffc, eyes squinty
subjectID = '231'; channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1352 1361]};%fffc, eyes squinty

subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1217 1223 ]} % 1224 is messed up somehow
%subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1235 1243]};%fffc, randomized to clock once per trial, 4 reps

%subjectID = '357'; channels={9,14}; thrV=[]; cellBoundary={'trialRange',[23 31]};%ffgwn (to 36?)
%subjectID = '357'; channels={9}; thrV=[-0.1 Inf]; cellBoundary={'trialRange',[87 103]};%fffc - a decent detect, sort has 2 cells tho (splitable in pc space)

subjectID = '231'; channels={1}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[1217 1218 ]} %2 to test
subjectID = '231'; channels={1}; thrV=[-0.08 Inf 0.3]; cellBoundary={'trialAndChunkRange',{[1217  10],[ 1217 13 ]}} %2 to test

%THIS IS ONE CELL FROM trial 24 to 160... balaji has some spatial RF analysis that we did
subjectID = '364'; channels={1}; thrV=[-0.15 Inf 0.4]; cellBoundary={'trialRange',[43 62]} %ffc, at top of screen, but cell is more active
%subjectID = '364'; channels={1}; thrV=[-0.08 Inf 0.3];cellBoundary={'trialAndChunkRange',{[145 16?],[ 1217 13 ]}} %ffc, after center on screen


subjectID = '231'; channels={1}; cellBoundary={'trialRange',[269]}; thrV=[-Inf 0.1 0.5]; %trf
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[272]};thrV=[-Inf 0.1 2]; %fffc
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[356]};thrV=[-0.05 Inf 0.4]; %fffc, MUA
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[615]};thrV=[-0.25 Inf 2]; %trf

subjectID = '231'; channels={1}; cellBoundary={'trialRange',[51 63]}; thrV=[-Inf 0.1 2];%ffgwn
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[646]}; thrV=[-0.2 Inf 2]; %'fff- anesth'
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[868 871]}; thrV=[-Inf 0.2 2]; %'spatial'
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[838 844]}; thrV=[-Inf 0.2 2]; %'spatial'
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[615 620]}; thrV=[-0.2 Inf 2]; %%'spatial'
subjectID = '231'; channels={1}; cellBoundary={'trialRange',[640 646],'trialMask',[644 645]}; thrV=[-0.2 Inf 2]; %%'spatial'



%subjectID = '188dev'; channels={1}; cellBoundary={'trialRange',[30 48]}; thrV=[-0.1 Inf 2]; %%'old data format - before chunks!'

subjectID = '364'; channels={1}; cellBoundary={'trialRange',[145 160]}; thrV=[-0.1 Inf 2]; %
subjectID = '364'; channels={1}; cellBoundary={'trialRange',[43 62]}; thrV=[-0.1 Inf 2]; %
subjectID = '364'; channels={1}; cellBoundary={'trialRange',[26 32]}; thrV=[-0.1 Inf 2]; %


subjectID = '262'; channels={1}; cellBoundary={'trialRange',[34 41]}; thrV=[-0.1 Inf 2]; %
subjectID = '262'; channels={1}; cellBoundary={'trialRange',[118 123]}; thrV=[-0.2 Inf 2]; %spatial bin

subjectID = '261'; channels={1}; cellBoundary={'trialRange',[186 190]}; thrV=[-0.1 Inf 2]; %no sta,  visual?
subjectID = '261'; channels={1}; cellBoundary={'trialRange',[244 272],'trialMask',[245:251 253:270]}; thrV=[-0.1 Inf 2]; %
subjectID = '261'; channels={1}; cellBoundary={'trialRange',[262]}; thrV=[-0.1 Inf 2]; %no sta,  visual?
subjectID = '261'; channels={1}; cellBoundary={'trialRange',[294]}; thrV=[-0.1 Inf 2]; %why no sf? 
% subjectID = '261'; channels={1}; cellBoundary={'trialRange',[341 359],'trialMask',[347:350]}; thrV=[-0.2 Inf .4]; %low qual at 6X8
% subjectID = '261'; channels={1}; cellBoundary={'trialRange',[324 332]}; thrV=[-0.2 Inf .4]; %3x4
% subjectID = '261'; channels={1}; cellBoundary={'trialRange',[288 293]}; thrV=[-0.2 Inf .4]; %ffgwn

subjectID = '249'; channels={1}; cellBoundary={'trialRange',[523 554]}; thrV=[-0.1 Inf 2]; %

subjectID = '249'; channels={1}; cellBoundary={'trialRange',[196 225]}; thrV=[-0.1 Inf 2]; %
subjectID = '249'; channels={1}; cellBoundary={'trialRange',[187 190]}; thrV=[-0.1 Inf 2]; %
subjectID = '249'; channels={1}; cellBoundary={'trialRange',[175]}; thrV=[-0.1 Inf 2]; %

%subjectID = '250'; channels={1}; thrV=[-0.1 Inf 2]; %'
%cellBoundary={'trialRange',[478]}; 
%cellBoundary={'trialRange',[496]}; 
%ifFeatureGoRightWithTwoFlank.physAnalysis at 191 more than 1 unique value in a condition is an error

subjectID = '252'; channels={1}; cellBoundary={'trialRange',[478]}; thrV=[-0.05 Inf 2]; %sf?
subjectID = '230'; channels={1}; cellBoundary={'trialRange',[16]}; thrV=[-0.05 Inf 2]; % grating?
subjectID = '230'; channels={1}; cellBoundary={'trialRange',[142]}; thrV=[-0.05 Inf 2]; %fffc
subjectID = '230'; channels={1}; cellBoundary={'trialRange',[137 140]}; thrV=[-0.05 Inf 2]; %fffc

%% finetuning
spikeSortingParams.postProcessing= 'treatAllAsSpike';  %'treatAllNonNoiseAsSpike'; %'treatAllAsSpike'; %'biggestAverageAmplitudeCluster';  %'largestNonNoiseClusterOnly',  
spikeDetectionParams.sampleLFP = false; %true;
spikeDetectionParams.LFPSamplingRateHz =500;
spikeSortingParams.plotSortingForTesting =false;
makeBackup = false;
stimClassToAnalyze={'all'}; timeRangePerTrialSecs=[0 Inf];

%% SET THE ANALYSIS MODE
analysisMode = 'overwriteAll';
%analysisMode = 'onlyAnalyze';
%analysisMode = 'viewAnalysisOnly'; 
% analysisMode = 'onlyAnalyze';
% analysisMode = 'onlyDetect';
%analysisMode = 'onlySort';
% analysisMode = 'onlyDetectAndSort';

%IDEAS:
% 'viewFirst','detectAndSortOnFirst','detectAndSortOnAll','interactiveDetectAndSortOnFirst','interactiveDetectAndSortOnAll'; 
% 'viewContinuous', 'viewLast','analyzeAtEnd','onlyDetectSpikes','onlySortSpikes','interactiveOnlyDetectSpikes',
% 'interactiveOnlySortSpikes','usePhotoDiodeSpikes';

%%
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
        spikeSortingParams.path = recordsPath.spikeRecordLoc;
        spikeSortingParams.modelBoundaryRange = []; %% need to specify this here
end
     
plottingParams.pauseForInspect = false;
plottingParams.forceNoInspect = false;
%% actual call to analysis
timeStart = now;
failedTrials = {};
% for currentTrialNum = 1218
%     cellBoundary={'trialRange',[currentTrialNum]};
%     try
plottingParams.foreNoInspect = true
analyzeBoundaryRange(subjectID, recordsPath, cellBoundary, channels,spikeDetectionParams, spikeSortingParams,...
        timeRangePerTrialSecs,stimClassToAnalyze,analysisMode,plottingParams,frameThresholds,makeBackup);
%     catch exception
%         failedTrials{end+1}{1} =  currentTrialNum;
%         failedTrials{end}{2} =  exception;        
%     end
% end
fprintf('That analysis took %2.2f seconds.\n',(now-timeStart)*84600);
%edit historicalSpikeFiddlerCalls
