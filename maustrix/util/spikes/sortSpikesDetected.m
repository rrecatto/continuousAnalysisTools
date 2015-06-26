function [assignedClusters rankedClusters spikeModel] = sortSpikesDetected(spikes, spikeWaveforms, spikeTimestamps, spikeSortingParams, spikeModel)

% =====================================================================================================================
%% BEGIN SPIKE SORTING
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
        if ~isfield(spikeSortingParams,'featureList')
            warning('features not defined - using default value of ''allRaw''');
            spikeSortingParams.featureList={'allRaw'};
        end
        % arrangeClustersBy
        if ~isfield(spikeSortingParams,'arrangeClustersBy')
            warning('arrangeClustersBy not defined - using default value of ''clusterCount''');
            spikeSortingParams.arrangeClustersBy = 'clusterCount';
        end
        
        
        % we need a file temp.fet.1 as input to KlustaKwik, and the output file will be temp.clu.1
        % change to ratrixPath/KlustaKwik directory
        currentDir=pwd;
        tempDir=fullfile(getRatrixPath,'util','spikes','spike sorting','KlustaKwik');
        cd(tempDir);
        
        [features nrDatapoints spikeModel.featureDetails] = calculateFeatures(spikeWaveforms,spikeSortingParams.featureList);
        
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
        if ispc
            cmdStr=['KlustaKwik.exe temp 1 -MinClusters ' num2str(spikeSortingParams.minClusters) ' -MaxClusters ' num2str(spikeSortingParams.maxClusters) ...
                ' -nStarts ' num2str(spikeSortingParams.nStarts) ' -SplitEvery ' num2str(spikeSortingParams.splitEvery) ...
                ' -MaxPossibleClusters ' num2str(spikeSortingParams.maxPossibleClusters) ' -UseFeatures ' featuresToUse ' -Debug ' num2str(0) ];
        elseif IsLinux
            cmdStr=['./KKLinux temp 1 -MinClusters ' num2str(spikeSortingParams.minClusters) ' -MaxClusters ' num2str(spikeSortingParams.maxClusters) ...
                ' -nStarts ' num2str(spikeSortingParams.nStarts) ' -SplitEvery ' num2str(spikeSortingParams.splitEvery) ...
                ' -MaxPossibleClusters ' num2str(spikeSortingParams.maxPossibleClusters) ' -UseFeatures ' featuresToUse ' -Debug ' num2str(0) ];
        elseif ismac
            cmdStr=['./KKMac temp 1 -MinClusters ' num2str(spikeSortingParams.minClusters) ' -MaxClusters ' num2str(spikeSortingParams.maxClusters) ...
                ' -nStarts ' num2str(spikeSortingParams.nStarts) ' -SplitEvery ' num2str(spikeSortingParams.splitEvery) ...
                ' -MaxPossibleClusters ' num2str(spikeSortingParams.maxPossibleClusters) ' -UseFeatures ' featuresToUse ' -Debug ' num2str(0) ];
        end
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
        catch
            warning('huh? no .clu?')
            keyboard
        end
        
        % throw away first element of assignedClusters - the first line of the cluster file is the number of clusters found
        assignedClusters(1)=[];
        rankedClusters = unique(assignedClusters);
        rankedClusters(rankedClusters==1)=[];
        switch spikeSortingParams.arrangeClustersBy
            case 'clusterCount'
                clusterCounts=zeros(length(rankedClusters),2);
                for i=1:size(clusterCounts,1)
                    clusterCounts(i,1) = i;
                    clusterCounts(i,2) = length(find(assignedClusters==rankedClusters(i)));
                end
                clusterCounts=sortrows(clusterCounts,-2);
                rankedClusters=rankedClusters(clusterCounts(:,1));
            case 'averageAmplitude'
                clusterAmplitude=zeros(length(rankedClusters),2);
                for i=1:size(clusterAmplitude,1)
                    clusterAmplitude(i,1) = i;
                    clusterAmplitude(i,2) = diff(minmax(mean(spikeWaveforms(assignedClusters==rankedClusters(i)),1)));
                end
                clusterAmplitude=sortrows(clusterAmplitude,-2);
                rankedClusters=rankedClusters(clusterAmplitude(:,1));
            case 'averageSpikeWidth'
                clusterSpikeWidth=zeros(length(rankedClusters),2);
                for i=1:size(clusterSpikeWidth,1)
                    clusterSpikeWidth(i,1) = i;
                    avgWaveform = mean(spikeWaveforms(assignedClusters==rankedClusters(i)),1);
                    [junk minInd] = min(avgWaveform);
                    [junk maxInd] = max(avgWaveform);
                    clusterSpikeWidth(i,2) = abs(minInd-maxInd);
                end
                clusterSpikeWidth=sortrows(clusterSpikeWidth,-2);
                rankedClusters=rankedClusters(clusterSpikeWidth(:,1));
            case 'spikeWaveformStdDev'
                clusterStdDev=zeros(length(rankedClusters),2);
                for i=1:size(clusterStdDev,1)
                    clusterStdDev(i,1) = i;
                    clusterStdDev(i,2) = mean(std(spikeWaveforms(assignedClusters==rankedClusters(i)),1));
                end
                clusterStdDev=sortrows(clusterStdDev,2); %ascending 
                rankedClusters=rankedClusters(clusterStdDev(:,1));
            otherwise
                error('unknown arrangeClusterBy method')
        end
        rankedClusters(end+1) = 1;
        fclose(fid);
        
%         % now move files from the Klusta directory (temp) to analysisPath
%         d=dir;
%         for i=1:length(d)
%             [matches tokens] = regexpi(d(i).name, 'temp\..*', 'match');
%             if length(matches) ~= 1
%                 %         warning('not a neuralRecord file name');
%             else
%                 [successM messageM messageIDM]=movefile(d(i).name,fullfile(analysisPath,d(i).name));
%             end
%         end
        % create the model files from the model file
        modelFilePath = fullfile(tempDir,'temp.model.1');
        spikeModel.clusteringModel = klustaModelTextToStruct(modelFilePath);
        spikeModel.clusteringMethod = 'KlustaKwik';
        spikeModel.featureList = spikeSortingParams.featureList;
        
        
        % change back to original directory
        cd(currentDir);
        
        if 0
            kk=klustaModelTextToStruct(fullfile(analysisPath,'temp.model.1'));
            myAssign=clusterFeaturesWithKlustaModel(kk,features,'mvnpdf',assignedClusters) % plot verification
        end
    case 'KLUSTAMODEL'
        if ~strcmp(upper(spikeModel.clusteringMethod),'KLUSTAKWIK')
            error('unsupported clustering method')
        end
        klustaModel = spikeModel.clusteringModel;
        [features nrDatapoints] = useFeatures(spikeWaveforms,spikeSortingParams.featureList,spikeModel.featureDetails);
        assignedClusters=clusterFeaturesWithKlustaModel(klustaModel,features,'mvnpdf');
        
        rankedClusters = unique(assignedClusters);
            rankedClusters = unique(assignedClusters);
        clusterCounts=zeros(length(rankedClusters),2);
        for i=1:size(clusterCounts,1)
            clusterCounts(i,1) = i;
            clusterCounts(i,2) = length(find(assignedClusters==rankedClusters(i)));
        end
        clusterCounts=sortrows(clusterCounts,-2);
        rankedClusters=rankedClusters(clusterCounts(:,1));
        rankedClusters(rankedClusters==1)=[];  % how do we know that 1 is the noise cluster,  does k.kwik enforce or is it a guess based on num samples.
        rankedClusters(end+1)=1;
   
    otherwise
        spikeSortingMethod
        error('unsupported spike sorting method');
end

% output of spike sorting should be assignedCluster and rankedClusters
% assignedCluster is a 1xN vector, which is the assigned cluster number for each spike (numbers are arbitrary)

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