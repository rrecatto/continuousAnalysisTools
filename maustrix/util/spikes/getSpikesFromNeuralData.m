function [spikes spikeWaveforms spikeTimestamps assignedClusters rankedClusters]= ...
    getSpikesFromNeuralData(neuralData,neuralDataTimes,spikeDetectionParams,spikeSortingParams,analysisPath)
% Get spikes using some spike detection method - plugin to Osort, WaveClus, KlustaKwik
% Outputs:
%   spikes - a vector of indices into neuralData that indicate where a spike happened
%   spikeWaveforms - a matrix containing a 4x32 waveform for each spike
%   spikeTimestamps - timestamp of each spike
%   assignedClusters - which cluster each spike belongs to
%   rankedClusters - some ranking of the clusters - we will specify that by convention, the last element of this array is the "noise" cluster



error('this function has been replaced by 2 other function: detectSpikesFromNeuralData and sortSpikesDetected... it is not garaunteed to be up to date for example regarding minmaxVolts')
spikes=[];


% default inputs for all methods

if ~isfield(spikeDetectionParams, 'ISIviolationMS')
    spikeDetectionParams.ISIviolationMS=2; % used for plots and reports of violations
end
if ~isfield(spikeSortingParams, 'ISIviolationMS')
    spikeSortingParams.ISIviolationMS=spikeDetectionParams.ISIviolationMS; % used for plots and reports of violations
end


% =====================================================================================================================
% SPIKE DETECTION

% handle spike detection
% the spikeDetectionParams struct must contain a 'method' field
if isfield(spikeDetectionParams, 'method')
    spikeDetectionMethod = spikeDetectionParams.method;
else
    error('must specify a method for spike detection');
end

% switch on the detection method
switch upper(spikeDetectionMethod)
    case 'OSORT'
        % spikeDetectionParams should look like this:
        %   method - osort
        %   samplingFreq - sampling frequency of raw signal
        %   Hd - (optional) bandpass frequencies
        %   nrNoiseTraces - (optional) number of noise traces as a parameter to osort's extractSpikes
        %   detectionMethod - (optional) spike detection method to use as a parameter to osort's extractSpikes
        %   extractionThreshold - (optional) threshold for extraction as a parameter to osort's extractSpikes
        %   peakAlignMethod - (optional) peak alignment method to use as a parameter to osort's extractSpikes
        %   alignMethod - (optional) align method to use if we are using "find peak" peakAlignMethod
        %   prewhiten - (optional) whether or not to prewhiten
        %   limit - (optional) the maximal absolute valid value (bigger/smaller than this is treated as out of range)
        
        % ============================================================================================================
        % from Osort's extractSpikes
        %extractionThreshold default is 5
        %params.nrNoiseTraces: 0 if no noise should be estimated
        %               >0 : # of noise traces to be used to estimate autocorr of
        %               noise, returned in variable autocorr
        %
        %
        %params.detectionMethod: 1 -> from power signal, 2 threshold positive, 3 threshold negative, 4 threshold abs, 5 wavelet
        %params.detectionParams: depends on detectionMethod.
        %       if detectionmethod==1, detectionParams.kernelSize
        %       if detectionmethod==4, detectionParams.scaleRanges (the range of scales (2 values))
        %                              detectionParams.waveletName (which wavelet to use)
        %
        %params.peakAlignMethod: 1-> find peak, 2->none, 3->peak of power signal, 4->peak of MTEO signal.
        %params.alignMethod: 1=pos, 2=neg, 3=mix (order if both peaks are sig,otherwise max) - only used if peakAlignMethod==1
        % ============================================================================================================
        
        % check params
        if ~isfield(spikeDetectionParams, 'samplingFreq')
            error('samplingFreq must be defined');
        end
        if isfield(spikeDetectionParams, 'Hd')
            Hd = spikeDetectionParams.Hd;
        else
            % default to bandpass 300Hz - 3000Hz
            n = 4;
            Wn = [300 3000]/(spikeDetectionParams.samplingFreq/2);
            [b,a] = butter(n,Wn);
            Hd=[];
            Hd{1}=b;
            Hd{2}=a;
        end
        if ~isfield(spikeDetectionParams, 'nrNoiseTraces')
            warning('nrNoiseTraces not defined - using default value of 0');
        end
        if ~isfield(spikeDetectionParams, 'detectionMethod')
            spikeDetectionParams.detectionMethod=1;
            spikeDetectionParams.kernelSize=25;
            warning('detectionMethod not defined - using default value of 1; also overwriting kernelSize param if set');
        end
        if ~isfield(spikeDetectionParams, 'extractionThreshold')
            spikeDetectionParams.extractionThreshold = 5;
            warning('extractionThreshold not defined - using default value of 5');
        end
        if ~isfield(spikeDetectionParams, 'peakAlignMethod')
            spikeDetectionParams.peakAlignMethod=1;
            warning('peakAlignMethod not defined - using default value of 1');
        end
        if ~isfield(spikeDetectionParams, 'prewhiten')
            spikeDetectionParams.prewhiten = false;
            warning('prewhiten not defined - using default value of false');
        end
        if ~isfield(spikeDetectionParams, 'limit')
            spikeDetectionParams.limit = Inf;
            warning('limit not defined - using default value of Inf');
        end
        % check that correct params exist for given detectionMethods
        if spikeDetectionParams.detectionMethod==1
            if ~isfield(spikeDetectionParams, 'kernelSize')
                warning('kernelSize not defined - using default value of 25');
            end
        elseif spikeDetectionParams.detectionMethod==5
            if ~isfield(spikeDetectionParams, 'scaleRanges')
                warning('scaleRanges not defined - using default value of [0.5 1.0]');
                spikeDetectionParams.scaleRanges = [0.5 1.0];
            end
            if ~isfield(spikeDetectionParams, 'waveletName')
                warning('waveletName not defined - using default value of ''haar''');
                spikeDetectionParams.waveletName = 'haar';
            end
        end
        
        if spikeDetectionParams.peakAlignMethod==1
            if ~isfield(spikeDetectionParams, 'alignMethod')
                warning('alignMethod not defined - using default value of 1');
                spikeDetectionParams.alignMethod = 1;
            end
        end
        
        channelIDUsedForDetection=1;  % the first be default... never used anything besides this so far
        
        % call to Osort spike detection
        [rawMean, filteredSignal, rawTraceSpikes,spikeWaveforms, spikeTimestampIndices, runStd2, upperlim, noiseTraces] = ...
            extractSpikes(neuralData, Hd, spikeDetectionParams );
        spikeTimestamps = neuralDataTimes(spikeTimestampIndices);
        spikes=spikeTimestampIndices';
        
    case 'FILTEREDTHRESH'
        %         spikeDetectionParams.method = 'filteredThresh'
        %         spikeDetectionParams.freqLowHi = [200 10000];
        %         spikeDetectionParams.threshHoldVolts = [-1.2 Inf];
        %         spikeDetectionParams.waveformWindowMs= 1.5;
        %         spikeDetectionParams.peakWindowMs= 0.5;
        %         spikeDetectionParams.alignMethod = 'atPeak'; %atCrossing
        %         spikeDetectionParams.peakAlignment = 'filtered' % 'raw'
        %         spikeDetectionParams.returnedSpikes = 'filtered' % 'raw'
        %         spikeDetectionParams.spkBeforeAfterMS=[0.6 0.975];
        %         spikeDetectionParams.bottomTopCrossingRate=[];
        
        %   NOT USED
        %         spikeDetectionParams.maxDbUnmasked = [-1.2 Inf];  % this  is not used
        
        if ~isfield(spikeDetectionParams, 'samplingFreq')
            error('samplingFreq must be a field in spikeDetectionParams');
        end
        if ~isfield(spikeDetectionParams, 'freqLowHi')
            spikeDetectionParams.freqLowHi=[200 10000];
            warning('freqLowHi not defined - using default value of [200 10000]');
        end
        if ~isfield(spikeDetectionParams, 'threshHoldVolts')
            if ~isfield(spikeDetectionParams, 'bottomTopCrossingRate') || isempty(spikeDetectionParams.bottomTopCrossingRate)
                spikeDetectionParams.threshHoldVolts = [-1.2 Inf];
                warning('thresholdVolts not defined - using default value of [-1.2 Inf]');
            else
                spikeDetectionParams.threshHoldVolts = []; % will be determined from rate
            end
        end
        if ~isfield(spikeDetectionParams, 'waveformWindowMs')
            spikeDetectionParams.waveformWindowMs=1.5;
            warning('waveformWindowMs not defined - using default value of 1.5');
        end
        if ~isfield(spikeDetectionParams, 'peakWindowMs')
            spikeDetectionParams.peakWindowMs=0.5;
            warning('peakWindowMs not defined - using default value of 0.5');
        end
        if ~isfield(spikeDetectionParams, 'alignMethod')
            spikeDetectionParams.alignMethod='atPeak';
            warning('alignMethod not defined - using default value of ''atPeak''');
        end
        if ~isfield(spikeDetectionParams, 'peakAlignment')
            spikeDetectionParams.peakAlignment='filtered';
            warning('peakAlignment not defined - using default value of ''filtered''');
        end
        if ~isfield(spikeDetectionParams, 'returnedSpikes')
            spikeDetectionParams.returnedSpikes = 'filtered';
            warning('returnedSpikes not defined - using default value of ''filtered''');
        end
        
        if isfield(spikeDetectionParams, 'bottomTopCrossingRate') && ~isempty(spikeDetectionParams.bottomTopCrossingRate)
            if ~isempty(spikeDetectionParams.threshHoldVolts)
                threshHoldVolts=spikeDetectionParams.threshHoldVolts
                bottomTopCrossingRate=spikeDetectionParams.bottomTopCrossingRate
                error('can''t define threshold and crossing rate at the same time')
            end
            doThreshFromRate=true;
            bottomRate=spikeDetectionParams.bottomTopCrossingRate(1);
            topRate=spikeDetectionParams.bottomTopCrossingRate(2);
        else
            loThresh=spikeDetectionParams.threshHoldVolts(1);
            hiThresh=spikeDetectionParams.threshHoldVolts(2);
            doThreshFromRate=false;
        end
        
        N=min(spikeDetectionParams.samplingFreq/200,floor(size(neuralData,1)/3)); %how choose filter orders? one extreme bound: Data must have length more than 3 times filter order.
        [b,a]=fir1(N,2*spikeDetectionParams.freqLowHi/spikeDetectionParams.samplingFreq);
        filteredSignal=filtfilt(b,a,neuralData);
        
        if doThreshFromRate
            % get threshold from desired rate of crossing
            [loThresh hiThresh] = getThreshForDesiredRate(neuralDataTimes,filteredSignal,bottomRate,topRate);
            disp(sprintf('spikeDetectionParams.threshHoldVolts=[%2.3f %2.3f]  %%fit from desired rate',loThresh,hiThresh))
            spikeDetectionParams.threshHoldVolts=[loThresh hiThresh]; % for later display
        end
        
        spkBeforeAfterMS=[spikeDetectionParams.peakWindowMs spikeDetectionParams.waveformWindowMs-spikeDetectionParams.peakWindowMs];
        spkSampsBeforeAfter=round(spikeDetectionParams.samplingFreq*spkBeforeAfterMS/1000);
        %spikeDetectionParams.spkBeforeAfterMS=[0.6 0.975];
        %spkSampsBeforeAfter=[24 39] % at 40000 like default osort:
        %rawTraceLength=64; beforePeak=24; afterPeak=39;
        
        tops=[false; diff(filteredSignal(:,1)>hiThresh)>0]; % only using the first listed channel to detect
        %        tops=[false(1,size(neuralData));  diff(filteredSignal>hiThresh)>0];  % spikes on all channels
        topCrossings=   neuralDataTimes(tops);
        bottoms=[false; diff(filteredSignal(:,1)<loThresh)>0];
        bottomCrossings=neuralDataTimes(bottoms);
        
        [tops    uTops    topTimes]   =extractPeakAligned(tops,1,spikeDetectionParams.samplingFreq,spkSampsBeforeAfter,filteredSignal,neuralData);
        [bottoms uBottoms bottomTimes]=extractPeakAligned(bottoms,-1,spikeDetectionParams.samplingFreq,spkSampsBeforeAfter,filteredSignal,neuralData);
        
        %maybe sort the order...
        spikes=[topTimes;bottomTimes];
        spikeTimestamps=neuralDataTimes(spikes);
        spikeWaveforms=[tops;bottoms];
        
        if doThreshFromRate
            dur=neuralDataTimes(end)-neuralDataTimes(1);
            disp(sprintf('the topRate goal was %2.2fHz but got: %2.2fHz ',topRate,length(topTimes)/dur))
            disp(sprintf('bottomRate  goal was %2.2fHz but got: %2.2fHz ',bottomRate,length(bottomTimes)/dur))
        end
        
    otherwise
        error('unsupported spike detection method');
end

% plotting to show results (for testing);   probably these tools should be
% supported in a gui outside this function...
if 0
    spikePoints=ones(1,length(spikeTimestamps));
    subplot(2,1,1)
    plot(neuralDataTimes,neuralData);
    title('rawSignal and spikes');
    hold on
    size(spikes)
    size(neuralData)
    plot(neuralDataTimes,spikes.*neuralData,'.r');
    hold off
    subplot(2,1,2)
    plot(neuralDataTimes,filteredSignal);
    title('filteredSignal and spikes');
    hold on
    plot(neuralDataTimes,spikes.*filteredSignal,'.r');
    hold off
end

% output of spike detection should be spikes (indices), spikeTimestamps, and spikeWaveforms
% END SPIKE DETECTION
% =====================================================================================================================
% BEGIN SPIKE SORTING
% Inputs are spikeTimestamps, spikeWaveforms

% check for a spike sorting method
if isfield(spikeSortingParams, 'method')
    spikeSortingMethod = spikeSortingParams.method;
else
    error('must specify a spike sorting method');
end

if isempty(spikeTimestamps)
    warning('NO SPIKES FOUND DURING SPIKE DETECTION');
    assignedClusters=[];
    rankedClusters=[];
    return;
end

% switch on the sorting method
switch upper(spikeSortingMethod)
    case 'OSORT'
        % spikeSortingParams can have the following fields:
        %   method - osort
        %   features - (optional) (default) 'allRaw' = use all features (all datapoints of each waveform)
        %           'tenPCs' = use first 10 principal components
        %           features should a cell array of a subset of these possible features
        %   doPostDetectionFiltering - (optional) specify whether or not to do post-detection filtering; see postDetectionFilter.m
        %   alignParam - (optional) alignParam to be passed in to osort's realigneSpikes method
        %   peakAlignMethod - (optional) peak alignment method used by osort's realigneSpikes method
        %   distanceWeightMode - (optional) mode of distance weight calculation used by osort's setDistanceWeight method
        %   minClusterSize - (optional) minimum number of elements in each cluster; passed in to osort's createMeanWaveforms method
        %   maxDistance - (optional) maxDistance parameter passed in to osort's assignToWaveform method; not sure what this does...
        %   envelopeSize - (optional) parameter passed in to osort's assignToWaveform method; not sure what this does...
        
        % check params
        % features
        if ~isfield(spikeSortingParams,'features')
            warning('features not defined - using default value of ''allRaw''');
            spikeSortingParams.features={'allRaw'};
        end
        if ~isfield(spikeSortingParams,'doPostDetectionFiltering')
            warning('doPostDetectionFiltering not defined - using default value of false');
            spikeSortingParams.doPostDetectionFiltering = false;
        end
        %alignParam:   this param is only considered if peakAlignMethod=1.
        %      1: positive (peak is max)
        %      2: negative (peak is min)
        %      3: mixed
        if ~isfield(spikeSortingParams,'alignParam')
            warning('alignParam not defined - using default value of 1');
            spikeSortingParams.alignParam=1;
        end
        %peakAlignMethod: (same as in detectSpikesFromPower.m, see for details).  1-> findPeak, 2 ->none, 3-> peak of power signal
        if ~isfield(spikeSortingParams,'peakAlignMethod')
            warning('peakAlignMethod not defined - using default value of 1');
            spikeSortingParams.peakAlignMethod=1;
        end
        %mode==1:mean waveforms
        %mode==2:assignment
        if ~isfield(spikeSortingParams,'distanceWeightMode')
            warning('distanceWeightMode not defined - using default value of 1');
            spikeSortingParams.distanceWeightMode=1;
        end
        % see createMeanWaveforms.m
        if ~isfield(spikeSortingParams,'minClusterSize')
            warning('minClusterSize not defined - using default value of 50');
            spikeSortingParams.minClusterSize=50;
        end
        % see assignToWaveform.m
        if ~isfield(spikeSortingParams,'maxDistance')
            warning('maxDistance not defined - using default value of 3');
            spikeSortingParams.maxDistance=3;
        end
        % see assignToWaveform.m
        if ~isfield(spikeSortingParams,'envelopeSize')
            warning('envelopeSize not defined - using default value of 4');
            spikeSortingParams.envelopeSize=4;
        end
        
        % end param checks
        % ===============================================================================
        % generate feature file for MClust manual use
        % write the feature file
        [features nrDatapoints] = calculateFeatures(spikeWaveforms,spikeSortingParams.features);
        
        fname = fullfile(analysisPath,'temp.fet.1');
        fid = fopen(fname,'w+');
        fprintf(fid,[num2str(nrDatapoints) '\n']);
        for k=1:length(spikeTimestamps)
            fprintf(fid,'%s\n', num2str(features(k,1:nrDatapoints)));
        end
        fclose(fid);
        
        % first upsample spikes
        spikeWaveforms=upsampleSpikes(spikeWaveforms);
        % get estimate of std from raw signal
        stdEstimate = std(neuralData); %stdEstimate: std estimate of the raw signal. only used if peakAlignMethod=1.
        
        if spikeSortingParams.doPostDetectionFiltering
            % optional post spike-detection filtering
            %filter raw waveforms to get rid of artifacts, non-real spikes and
            %other shit
            [newSpikes,newTimestamps,didntPass] = postDetectionFilter( spikeWaveforms, spikeTimestamps);
            newSpikes = realigneSpikes(newSpikes,spikeTimestamps,spikeSortingParams.alignParam,stdEstimate,spikeSortingParams.peakAlignMethod);
        else
            newSpikes=spikeWaveforms;
            newTimestamps=spikeTimestamps;
        end
        numSpikes=size(newSpikes,1);
        disp(sprintf('got %d spikes; about %2.2g Hz',numSpikes,  numSpikes/diff(neuralDataTimes([1 end]))))
        
        %convert to RBF and realign
        [spikesRBF, spikesSolved] = RBFconv( newSpikes );
        spikesSolved = realigneSpikes(spikesSolved,spikeTimestamps,spikeSortingParams.alignParam,stdEstimate,spikeSortingParams.peakAlignMethod);
        
        %calculate threshold
        x=1:size(spikesSolved,2);
        [weights,weightsInv] = setDistanceWeight(x,spikeSortingParams.distanceWeightMode);
        globalMean = mean(spikesSolved);
        globalStd  = std(spikesSolved);
        initialThres = ((globalStd.^2)*weights)/256;
        
        %cluster to find mean waveforms of cluster
        [NrOfclustersFound, assignedCluster, meanSpikeForms, rankedClusters] = sortBlock(spikesSolved, newTimestamps, initialThres);
        
        %merge mean clusters
        [meanWaveforms,meanClusters] = ...
            createMeanWaveforms( size(spikesSolved,1), meanSpikeForms,rankedClusters,initialThres,spikeSortingParams.minClusterSize);
        
        %now re-cluster, using this new mean waveforms
        [assignedClusters, rankedClusters] = ...
            assignToWaveform(spikesSolved,newTimestamps,meanClusters,initialThres,stdEstimate,spikeSortingParams.maxDistance,spikeSortingParams.envelopeSize);
        % osort's assignToWaveform gives us rankedClusters as indices into the unique cluster numbers in assignedClusters
        % we want rankedClusters to be the actual cluster numbers, not indices - fix here
        % rankedClusters should be sorted in descending order of number of members in cluster, with noise cluster moved to last element
        uniqueClusters = unique(assignedClusters);
        uniqueClusters(uniqueClusters==999)=[]; % move noise cluster to end
        uniqueClusters(end+1)=999;
        rankedClusters=uniqueClusters;
        
        % write cluster file
        fname = fullfile(analysisPath,'temp.clu.1');
        fid = fopen(fname,'w+');
        fprintf(fid,[num2str(length(uniqueClusters)) '\n']);
        for k=1:length(assignedClusters)
            fprintf(fid,'%s\n', num2str(assignedClusters(k)));
        end
        fclose(fid);
        
    case 'KLUSTAKWIK'
        % spikeSortingParams can have the following fields:
        %   minClusters - (optional) (default 20) min number of initial clusters - final number may be different due to splitting/deleting
        %   maxClusters - (optional) (default 30) max number of initial clusters - final number may be different due to splitting/deleting
        %   nStarts - (optional) (default 1) number of starts of the algorithm for each initial cluster count
        %   splitEvery - (optional) (default 50) Test to see if any clusters should be split every n steps. 0 means don't split.
        %   maxPossibleClusters - (optional) (default 100) Cluster splitting can produce no more than this many clusters.
        %   features - (optional) (default) 'allRaw' = use all features (all datapoints of each waveform)
        %           'tenPCs' = use first 10 principal components
        %           features should a cell array of a subset of these possible features
        
        % check params
        % minClusters
        if ~isfield(spikeSortingParams,'minClusters')
            warning('minClusters not defined - using default value of 20');
            spikeSortingParams.minClusters=20;
        end
        % maxClusters
        if ~isfield(spikeSortingParams,'maxClusters')
            warning('maxClusters not defined - using default value of 30');
            spikeSortingParams.maxClusters=30;
        end
        % nStarts
        if ~isfield(spikeSortingParams,'nStarts')
            warning('nStarts not defined - using default value of 1');
            spikeSortingParams.nStarts=1;
        end
        % splitEvery
        if ~isfield(spikeSortingParams,'splitEvery')
            warning('splitEvery not defined - using default value of 50');
            spikeSortingParams.splitEvery=50;
        end
        % maxPossibleClusters
        if ~isfield(spikeSortingParams,'maxPossibleClusters')
            warning('maxPossibleClusters not defined - using default value of 100');
            spikeSortingParams.maxPossibleClusters=100;
        end
        % features
        if ~isfield(spikeSortingParams,'features')
            warning('features not defined - using default value of ''allRaw''');
            spikeSortingParams.features={'allRaw'};
        end
        
        % we need a file temp.fet.1 as input to KlustaKwik, and the output file will be temp.clu.1
        % change to ratrixPath/KlustaKwik directory
        currentDir=pwd;
        tempDir=fullfile(getRatrixPath,'analysis','spike sorting','KlustaKwik');
        cd(tempDir);
        
        [features nrDatapoints] = calculateFeatures(spikeWaveforms,spikeSortingParams.features);
        
        % write the feature file
        fid = fopen('temp.fet.1','w+');
        fprintf(fid,[num2str(nrDatapoints) '\n']);
        for k=1:length(spikeTimestamps)
            fprintf(fid,'%s\n', num2str(features(k,1:nrDatapoints)));
        end
        fclose(fid);
        
        % set which features to use
        featuresToUse='';
        for i=1:nrDatapoints
            featuresToUse=[featuresToUse '1'];
        end
        
        % now run KlustaKwik
        cmdStr=['KlustaKwik.exe temp 1 -MinClusters ' num2str(spikeSortingParams.minClusters) ' -MaxClusters ' num2str(spikeSortingParams.maxClusters) ...
            ' -nStarts ' num2str(spikeSortingParams.nStarts) ' -SplitEvery ' num2str(spikeSortingParams.splitEvery) ...
            ' -MaxPossibleClusters ' num2str(spikeSortingParams.maxPossibleClusters) ' -UseFeatures ' featuresToUse ' -Debug ' num2str(0) ];
        system(cmdStr);
        pause(0.1);
        % read output temp.clu.1 file
        try
            fid = fopen('temp.clu.1');
            assignedClusters=[];
            while 1
                tline = fgetl(fid);
                if ~ischar(tline),   break,   end
                assignedClusters = [assignedClusters;str2num(tline)];
            end
        catch ex
            warning('huh? no .clu?')
            keyboard
        end
        % throw away first element of assignedClusters - the first line of the cluster file is the number of clusters found
        assignedClusters(1)=[];
        % generate rankedClusters by a simple count of number of members
        rankedClusters = unique(assignedClusters);
        clusterCounts=zeros(length(rankedClusters),2);
        for i=1:size(clusterCounts,1)
            clusterCounts(i,1) = i;
            clusterCounts(i,2) = length(find(assignedClusters==rankedClusters(i)));
        end
        clusterCounts=sortrows(clusterCounts,-2);
        rankedClusters=rankedClusters(clusterCounts(:,1));
        %rankedClusters(rankedClusters==1)=[];  % how do we know that 1 is the noise cluster,  does k.kwik enforce or is it a guess based on num samples.
        rankedClusters(end+1)=1; % move noise cluster '1' to end
        fclose(fid);
        
        % now move files from the Klusta directory (temp) to analysisPath
        d=dir;
        for i=1:length(d)
            [matches tokens] = regexpi(d(i).name, 'temp\..*', 'match');
            if length(matches) ~= 1
                %         warning('not a neuralRecord file name');
            else
                [successM messageM messageIDM]=movefile(d(i).name,fullfile(analysisPath,d(i).name));
            end
        end
        
        
        % change back to original directory
        cd(currentDir);
        
        if 0
            kk=klustaModelTextToStruct(fullfile(analysisPath,'temp.model.1'));
            myAssign=clusterFeaturesWithKlustaModel(kk,features,'mvnpdf',assignedClusters) % plot verification
        end
    case 'KLUSTAMODEL'
        kk=klustaModelTextToStruct(fullfile(fileparts(analysisPath),'model'));
        assignedClusters=clusterFeaturesWithKlustaModel(kk,features,'mvnpdf');
        
        rankedClusters = unique(assignedClusters);
            rankedClusters = unique(assignedClusters);
        clusterCounts=zeros(length(rankedClusters),2);
        for i=1:size(clusterCounts,1)
            clusterCounts(i,1) = i;
            clusterCounts(i,2) = length(find(assignedClusters==rankedClusters(i)));
        end
        clusterCounts=sortrows(clusterCounts,-2);
        rankedClusters=rankedClusters(clusterCounts(:,1));
        rankedClusters(end+1)=1
   
    otherwise
        spikeSortingMethod
        error('unsupported spike sorting method');
end

% output of spike sorting should be assignedCluster and rankedClusters
% assignedCluster is a 1xN vector, which is the assigned cluster number for each spike (numbers are arbitrary)

if spikeSortingParams.plotSortingForTesting % view plots (for testing)
    
    switch upper(spikeSortingMethod)
        case 'OSORT'
            whichSpikes=find(assignedClusters~=999);
            whichNoise=find(assignedClusters==999);  % i think o sort only... need to be specific to noise clouds in other detection methods
        case 'KLUSTAKWIK'
            whichSpikes=find(assignedClusters==rankedClusters(1)); % biggest
            whichNoise=find(assignedClusters~=rankedClusters(1));  % not the biggest
        otherwise
            error('bad method')
    end
    
    candTimes=spikes;
    %candTimes=find(spikes);
    spikeTimes=candTimes(whichSpikes);
    noiseTimes=candTimes(whichNoise);
    
    
    N=20; %downsampling for the display of the whole trace; maybe some user control?
    
    %choose y range for raw, crop extremes is more than N std
    whichChan=1;  % the one used for detecting
    dataMinMax=1.1*minmax(neuralData(:,whichChan)');
    stdRange=6*(std(neuralData(:,whichChan)'));
    if range(dataMinMax)<stdRange*2
        yRange=dataMinMax;
    else
        yRange=mean(neuralData(:,whichChan)')+[-stdRange stdRange ];
    end
    
    %should do same for filt if functionized, but its not needed
    yRangeFilt= 1.1*minmax(filteredSignal(:,1)');
    
    
    % a smart way to choose a zoom center on a spike
    % this should be able to be a user selected spike (click on main timeline nearest x-val  AND  key combo for prev / next spike)
    % but for now its the last one
    zoomWidth=spikeDetectionParams.samplingFreq*0.05;  % 50msec default, key board zoom steps by a factor of 2
    lastSpikeTimePad=min([max(spikeTimes)+200 size(neuralDataTimes,1)]);
    zoomInds=[max(lastSpikeTimePad-zoomWidth,1):lastSpikeTimePad ];
    
    figure
    %         if ~isempty(whichNoise)
    %             plot(spikeWaveforms(whichNoise,:)','color',[.7 .7 .7])
    %         end
    %colors=brighten(brighten(bone(length(rankedClusters)),1),1);
    colors=cool(length(rankedClusters));
    subplot(1,3,3);hold on;
    subplot(2,3,4); hold on;
    for i=2:length(rankedClusters)
        thisCluster=find(assignedClusters==rankedClusters(i));
        if ~isempty(thisCluster)
            subplot(1,3,3); plot(spikeWaveforms(thisCluster,:)','color',colors(i,:))
            subplot(2,3,4); plot3(features(thisCluster,1),features(thisCluster,2),features(thisCluster,3),'.','color',colors(i,:))
        end
    end
    subplot(1,3,3); plot(spikeWaveforms(whichSpikes,:)','r')
    axis([ 1 size(spikeWaveforms,2)  1.1*minmax(spikeWaveforms(:)') ])
    subplot(2,3,4); plot3(features(whichSpikes,1),features(whichSpikes,2),features(whichSpikes,3),'r.')
    
    
    xlabel(sprintf('%d spikes, %2.2g Hz', length(spikeTimes),length(spikeTimes)/diff(neuralDataTimes([1 end]))))
    
    subplot(2,3,1)
    %inter-spike interval distribution
    ISI=diff(1000*neuralDataTimes(spikeTimes));
    edges=linspace(0,10,100);
    count=histc(ISI,edges);
    if sum(count)>0
        prob=count/sum(count);
        bar(edges,prob,'histc');
        axis([0 max(edges) 0 max(prob)])
    else
        text(0,0,'no ISI < 10 msec')
    end
    hold on
    lockout=1000*39/spikeDetectionParams.samplingFreq;  %why is there a algorithm-imposed minimum ISI?  i think it is line 65  detectSpikes
    lockout=edges(max(find(edges<=lockout)));
    plot([lockout lockout],get(gca,'YLim'),'k') %
    plot([2 2], get(gca,'YLim'),'k--')
    
    
    N=size(neuralData,2);
    colors=0.8*ones(N,3);
    colors(1,:)=0; %first one is black is main
    
    subplot(2,3,2)
    title('rawSignal zoom');
    %plot(neuralDataTimes(zoomInds),neuralData(zoomInds),'k');
    hold on
    
    steps=max(std(neuralData));
    for i=1:N
        plot(neuralDataTimes(zoomInds),neuralData(zoomInds,i)-steps*(i-1),'color',colors(i,:))
        %text(xMinMax(1)-diff(xMinMax)*0.05,steps*i,num2str(i-2)) % add the name of channel... consider doing all phys channels
    end
    set(gca,'ytick',[])
    
    someNoiseTimes=noiseTimes(ismember(noiseTimes,zoomInds));
    someSpikeTimes=spikeTimes(ismember(spikeTimes,zoomInds));
    plot(neuralDataTimes(someNoiseTimes),neuralData(someNoiseTimes),'.b');
    plot(neuralDataTimes(someSpikeTimes),neuralData(someSpikeTimes),'.r');
    axis([ minmax(neuralDataTimes(zoomInds)')   ylim ])
    
    
    if 0
        subplot(2,3,4)
        title('filtSignal and spikes');
        plot(downsample(neuralDataTimes,N),downsample(filteredSignal,N),'k');
        hold on
        plot(neuralDataTimes(noiseTimes),filteredSignal(noiseTimes),'.b');
        plot(neuralDataTimes(spikeTimes),filteredSignal(spikeTimes),'.r');
        axis([ minmax(neuralDataTimes')   1.1*minmax(filteredSignal') ])
    end
    % a button should allow selection between filtered or non-filtered (only show one kind)
    
    %     title('rawSignal and spikes');
    %     plot(downsample(neuralDataTimes,N),downsample(neuralData,N),'k');
    %     hold on
    %     plot(neuralDataTimes(noiseTimes),neuralData(noiseTimes),'.b');
    %     plot(neuralDataTimes(spikeTimes),neuralData(spikeTimes),'.r');
    %      axis([ minmax(neuralDataTimes')   yRange ])
    
    
    subplot(2,3,5)
    title('filtSignal zoom');
    %plot(neuralDataTimes(zoomInds),filteredSignal(zoomInds),'k');
    hold on
    steps=max(std(filteredSignal));
    for i=fliplr(1:N)
        plot(neuralDataTimes(zoomInds),filteredSignal(zoomInds,i)-steps*(i-1),'color',colors(i,:))
        %text(xMinMax(1)-diff(xMinMax)*0.05,steps*i,num2str(i-2)) % add the name of channel... consider doing all phys channels
    end
    
    xl=xlim;
    set(gca,'xtick',xlim,'xticklabel',{num2str(xl(1),'%2.2f'),num2str(xl(2),'%2.2f')})
    if isfield(spikeDetectionParams, 'threshHoldVolts')
        xlabel(sprintf('thresh = [%2.3f %2.3f]',spikeDetectionParams.threshHoldVolts))
        yTickVal=[spikeDetectionParams.threshHoldVolts(1) 0 spikeDetectionParams.threshHoldVolts(2)];
        set(gca,'ytick',yTickVal,'yticklabel',{num2str(yTickVal(1),'%2.2f'),'0',num2str(yTickVal(3),'%2.2f')})
        plot(xl,spikeDetectionParams.threshHoldVolts([1 1]),'color',[.8 .8 .8])
        plot(xl,spikeDetectionParams.threshHoldVolts([2 2]),'color',[.8 .8 .8])
    else
        set(gca,'ytick',[])
    end
    
    plot(neuralDataTimes(someNoiseTimes),filteredSignal(someNoiseTimes),'.b');
    plot(neuralDataTimes(someSpikeTimes),filteredSignal(someSpikeTimes),'.r');
    axis([ neuralDataTimes(zoomInds([1 end]))'   ylim])
    %axis([ minmax(neuralDataTimes(zoomInds)')   1.1*minmax(filteredSignal(zoomInds)') ])
    
    %     figure()
    %     allSpikesDecorrelated=spikeWaveforms; %this is not decorellated!
    %     allSpikesOrig=spikeWaveforms;
    %     assigned=?
    %     clNr1=just ID?
    %     clNr2=justID?
    %     plabel='';
    %     mode=1; %maybe 2 later
    %     [d,residuals1,residuals2,Rsquare1, Rsquare2] = figureClusterOverlap(allSpikesDecorrelated, allSpikesOrig, assigned, clNr1, clNr2,plabel ,mode , {'b','r'})
    
    
    
    
    %%
end

% END SPIKE SORTING
% =====================================================================================================================

end % end function


function [group uGroup groupPts]=extractPeakAligned(group,flip,sampRate,spkSampsBeforeAfter,filt,data)
maxMSforPeakAfterThreshCrossing=.5; %this is equivalent to a lockout, because all peaks closer than this will be called one peak, so you'd miss IFI's smaller than this.
% we should check for this by checking if we said there were multiple spikes at the same time.
% but note this is ONLY a consequence of peak alignment!  if aligned on thresh crossings, no lockout necessary (tho high frequency noise riding on the spike can cause it
% to cross threshold multiple times, causing you to count it multiple times w/timeshift).
% our remaining problem is if the decaying portion of the spike has high freq noise that causes it to recross thresh and get counted again, so need to look in past to see
% if we are on the tail of a previous spk -- but this should get clustered away anyway because there's no spike-like peak in the immediate period following the crossing.
% ie the peak is in the past, so it's a different shape, therefore a different cluster
maxPeakSamps=round(sampRate*maxMSforPeakAfterThreshCrossing/1000);

spkLength=sum(spkSampsBeforeAfter)+1;
spkPts=[-spkSampsBeforeAfter(1):spkSampsBeforeAfter(2)];
%spkPts=(1:spkLength)-ceil(spkLength/2); % centered

group=find(group)';
groupPts=group((group+spkLength-1)<length(filt) & group-ceil(spkLength/2)>0)';
group=data(repmat(groupPts,1,maxPeakSamps)+repmat(0:maxPeakSamps-1,length(groupPts),1)); %use (sharper) unfiltered peaks!

[junk loc]=max(flip*group,[],2);
groupPts=((loc-1)+groupPts);
groupPts=groupPts((groupPts+floor(spkLength/2))<length(filt));



group= filt(repmat(groupPts,1,spkLength)+repmat(spkPts,length(groupPts),1));
uGroup=data(repmat(groupPts,1,spkLength)+repmat(spkPts,length(groupPts),1));
uGroup=uGroup-repmat(mean(uGroup,2),1,spkLength);
end

function [loThresh hiThresh] = getThreshForDesiredRate(neuralDataTimes,filtV,bottomRate,topRate)

numSteps=50;
dRate=5000; % down sampled rate
secDur=neuralDataTimes(end)-neuralDataTimes(1);
dTimes=linspace(neuralDataTimes(1),neuralDataTimes(end),secDur*dRate);
whichChan=1;  % only detect off of the first listed chan
dFilt=interp1(neuralDataTimes,filtV(:,whichChan),dTimes,'linear'); %without downsampling, the following line runs out of memory even for singles when > ~15s @40kHz

mm=minmax(filtV);
if any(ismember(mm,[0 -999 999]))
    mm
    error('filtered voltages should always minmax non-zero, and not expected to be -999 or 999')
end

if mm(1)>0
    mm
    error('expected some negative values in filtered min')
end

if mm(2)<0
    mm
    error('expected some posiitve values in filtered max')
end

% loop through: coarse low, coarse high, fine low, fine high
for w=[mm -999 999]
    switch w
        case -999 % 2nd pass fine grain low
            stepSz=abs(mm(1))/numSteps;
            v=linspace(loThresh-stepSz,loThresh+stepSz,numSteps)';
        case 999  % 2nd pass fine grain high
            stepSz=abs(mm(2))/numSteps;
            v=linspace(hiThresh+stepSz,hiThresh-stepSz,numSteps)';
        otherwise % first pass coarse full rage: [min 0] and [max 0]
            v=linspace(w,0,numSteps)';
    end
    
    crossHz=sum(diff((w*repmat(dFilt,numSteps,1))>(w*repmat(single(v),1,length(dFilt))),1,2)>0,2)/secDur;
    if w>0
        hiThresh=v(find(crossHz>topRate,1,'first'));
        if isempty(hiThresh)
            hiThresh=0;
        end
    elseif w<0
        loThresh=v(find(crossHz>bottomRate,1,'first'));
        if isempty(loThresh)
            loThresh=0;
        end
    end
end

end

function kk=klustaModelTextToStruct(modelFile)

fid=fopen(modelFile,'r');  % this is only the first one!
if fid==-1
    modelFile
    error('bad file')
end
kk.headerJunk= fgetl(fid);
ranges= str2num(fgetl(fid));
sz=str2num(fgetl(fid));
kk.numDims=sz(1);
kk.numClust=sz(2);
kk.numOtherThing=sz(3); % this is not num features? 
kk.ranges=reshape(ranges,[],kk.numDims);
kk.mean=nan(kk.numClust,kk.numDims);
xx.cov=nan(kk.numDims,kk.numDims,kk.numClust);
for c=1:kk.numClust
    clustHeader=str2num(fgetl(fid));
    if clustHeader(1)~=c-1
        %just double check
        error('wrong cluster')
    end
    kk.mean(c,:)=str2num(fgetl(fid));
    kk.weight(c)=clustHeader(2);
    for i=1:kk.numDims
        kk.cov(i,:,c)=str2num(fgetl(fid));
    end
end
fclose(fid);
end

function assignments=clusterFeaturesWithKlustaModel(kk,features,distanceMethod,verifyAgainst)

%%

%normalize from 0-->1 extrema of training set
F=features;
n=size(F,1);
for d=1:kk.numDims
    F(:,d)=F(:,d)-kk.ranges(1,d);
    F(:,d)=F(:,d)/diff(kk.ranges(:,d));      
end

switch distanceMethod
    case 'mvnpdf'
        %calculate the probability that each point belongs to each cluster
        %OLD GUESS USING MVNPDF 
        thisMean=kk.mean; % verified empirically to be the mean per cluster after normalization
        p=nan(size(features,1),kk.numClust);
        for c=1:kk.numClust
            chol=reshape(kk.cov(:,:,c),[kk.numDims kk.numDims]);
            thisCov=chol*chol';
            p(:,c)=mvnpdf(F,kk.mean(c,:),thisCov);
        end
        [junk assignments]=max(p,[],2);
        distnce=abs(log(p));
        %distnce=abs(log(p)-log(repmat(kk.weight,n,1)));
        %[junk assignments]=max(distnce,[],2);
    case 'mah'
        %mimick Mahalanobis stuff in Klusta
        %calculate the distance from each point to each cluster
        invcov = cov(features)\eye( size(features,2)); % see pdist
        %Y = pdistmex(features','mah',invcov); % why fail mex?
        mahal = nan(size(features,1),kk.numClust);
        for c = 1:kk.numClust
            del = repmat(kk.mean(c,:),size(features,1),1) - features;
            mahal(:,c)= sqrt(sum((del*invcov).*del,2));
            
            chol=reshape(kk.cov(:,:,c),[kk.numDims kk.numDims]);
            LogRootDet(c)=sum(log(diag(chol)));
            distnce(:,c)=mahal(:,c)/2+log(kk.weight(c))-LogRootDet(c); %WHAT?
            % does klust calc an overall goodness of fit of all points?
            % and how does the weight relate to the classification?
            distnce(:,c)=mahal(:,c)%+log(kk.weight(c))/2; %;%-LogRootDet(c)+
        end
        %distnce(:,1)=Inf;
        [junk assignments]=min(distnce,[],2);
end

if exist('verifyAgainst','var')
    figure;
    subplot(1,2,1); plot(distnce,'.')
    subplot(1,2,2); hold on
    colors=jet(kk.numClust);
    darker=colors*.6;
    for c=1:kk.numClust
        which=verifyAgainst==c;
        plot3(F(which,1),F(which,2),F(which,3),'.','color',colors(c,:));
        which=assignments==c;
        plot3(F(which,1),F(which,2),F(which,3),'o','color',colors(c,:));
        plot3(kk.mean(c,1),kk.mean(c,2),kk.mean(c,3),'+','MarkerSize',20,'color',darker(c,:))
        
        which=verifyAgainst==c;
        plot3(mean(F(which,1)),mean(F(which,2)),mean(F(which,3)),'o','MarkerSize',20,'color',darker(c,:))
    end
end
%%
end