function inspectSpikes(interactive,analysisPath,plottingInfo,trodes,spikeRecord,neuralRecord)
if ~interactive
numTrodes = length(trodes);
screenSize = get(0,'ScreenSize');
outerPosition = [100 100 screenSize(3)-100 screenSize(4)-100];

for trodeNum = 1:numTrodes
    trodeStr = createTrodeName(trodes{trodeNum});
    spikes = spikeRecord.(trodeStr).spikes;
    
    % create the figures first...leads to fewer confusions
    whichFig = figure(trodeNum);
    clf(whichFig);
    figureName = sprintf('trode:%d. trodeChans:%s. trialRange:%d.%d->%d.%d',trodeNum,mat2str(trodes{trodeNum}),...
        plottingInfo.boundaryRange(1),plottingInfo.boundaryRange(2),plottingInfo.trialNum,plottingInfo.chunkID);
    set(whichFig,'Name',figureName,...
        'NumberTitle','off','OuterPosition',outerPosition);
    clf(whichFig);
    
    % now check if worth plotting
    if isempty(spikes)
        warning('no spikes at all in this trode %d, trodeChans:%s...nothing to plot',trodeNum,mat2str(trodes{trodeNum}));
        continue
    end
    whichThisTrial = (spikeRecord.(trodeStr).trialNumForDetectedSpikes==plottingInfo.trialNum);
    spikeWaveforms = spikeRecord.(trodeStr).spikeWaveforms;
    assignedClusters = spikeRecord.(trodeStr).assignedClusters;
    spikeTimestamps = spikeRecord.(trodeStr).spikeTimestamps;
    trialNumForSpikes = spikeRecord.(trodeStr).trialNumForDetectedSpikes;
    rankedClustersCell = spikeRecord.(trodeStr).rankedClusters;
    rankedClusters = [];
    processedClusters = spikeRecord.(trodeStr).processedClusters;
    for i = 1:length(rankedClustersCell)
        rankedClusters = unique([rankedClusters;makerow(rankedClustersCell{i})']);
    end
    [features nDim] = useFeatures(spikeWaveforms,spikeRecord.(trodeStr).spikeModel.featureList,...
        spikeRecord.(trodeStr).spikeModel.featureDetails);
    
    switch upper(spikeRecord.(trodeStr).spikeModel.clusteringMethod)
        case 'OSORT'
            whichSpikes=find(assignedClusters~=999);
            whichNoise=find(assignedClusters==999);  % i think o sort only... need to be specific to noise clouds in other detection methods
        case 'KLUSTAKWIK'
            whichSpikes = logical(processedClusters);
            whichNoise = ~logical(processedClusters);
        otherwise
            error('bad method')
    end
    candTimes=spikes;
    spikeTimes=candTimes(whichSpikes);
    spikeTimesThisTrial = candTimes(whichSpikes&whichThisTrial);
    noiseTimes=candTimes(whichNoise);
    noiseTimesThisTrial = candTimes(whichNoise&whichThisTrial);
    
    filtAx = axes('Position',[0.03 0.87 0.67 0.1]);
    rawAx = axes('Position',[0.03 0.72 0.67 0.1]);
    isiTotAx = axes('Position',[0.75 0.72 0.22 0.1]);
    isiPartAx = axes('Position',[0.75 0.87 0.22 0.1]);
    waveAx = axes('Position',[0.52 0.355 0.45 0.325]);
    waveMeansAx = axes('Position',[0.52 0.03 0.45 0.325]);
    featAx = axes('Position',[0.03 0.03 0.45 0.65]);
    
    
    %% plot the stuff which will always be plotted
    
    % waveforms and features
    colors=cool(length(rankedClusters));
    for i=2:length(rankedClusters)
        thisCluster=find(assignedClusters==rankedClusters(i));
        if ~isempty(thisCluster)
            axes(waveAx);hold on;plot(spikeWaveforms(thisCluster,:)','color',colors(i,:))
            meanWave = mean(spikeWaveforms(thisCluster,:));
            stdWave = std(spikeWaveforms(thisCluster,:));
            axes(waveMeansAx);hold on;plot(meanWave','color',colors(i,:),'LineWidth',2);
            lengthOfWaveform = size(spikeWaveforms,2);
            fillWave = fill([1:lengthOfWaveform fliplr(1:lengthOfWaveform)]',[meanWave+stdWave fliplr(meanWave-stdWave)]',colors(i,:));set(fillWave,'edgeAlpha',0,'faceAlpha',.2)
            axes(featAx);hold on; plot3(features(thisCluster,1),features(thisCluster,2),features(thisCluster,3),'.','color',colors(i,:));
        end
    end
    axes(waveAx);hold on;plot(spikeWaveforms(whichSpikes,:)','r')
    meanWave = mean(spikeWaveforms(whichSpikes,:),1);
    stdWave = std(spikeWaveforms(whichSpikes,:),[],1);
    axes(waveMeansAx);hold on;plot(meanWave','color','r','LineWidth',2);
    lengthOfWaveform = size(spikeWaveforms,2);
    fillWave = fill([1:lengthOfWaveform fliplr(1:lengthOfWaveform)]',[meanWave+stdWave fliplr(meanWave-stdWave)]','r');set(fillWave,'edgeAlpha',0,'faceAlpha',.3)
    linkaxes([waveAx waveMeansAx],'xy');
    set(waveAx,'XTick',[]);
    axes(waveAx);
    axis([1 size(spikeWaveforms,2)  1.1*minmax(spikeWaveforms(:)') ])
%     box(waveAx,'on');
    axes(waveMeansAx); set(gca,'XTick',[1 25 61],'XTickLabel',{sprintf('%2.2f',-24000/plottingInfo.samplingRate),'0',sprintf('%2.2f',36000/plottingInfo.samplingRate)});xlabel('ms');
%     box(waveMeansAx,'on');
    axes(featAx);hold on; plot3(features(whichSpikes,1),features(whichSpikes,2),features(whichSpikes,3),'r*');
    
    %inter-spike interval distribution
    trialNums = unique(trialNumForSpikes);
    existISILess10MS = false; existISILess10000MS = false;
    maxEdgePart = 0; maxEdgeTot = 0;
    maxProbPart = 0; maxProbTot = 0;
    for i = 2:length(rankedClusters)
        thisCluster = (assignedClusters==rankedClusters(i));
        ISIThisCluster = [];
        for currTrialNum = 1:length(trialNums)
            whichThisTrialThisCluster = (trialNumForSpikes==trialNums(currTrialNum))&thisCluster;
            spikeTimeStampsThisTrialThisCluster = spikeTimestamps(whichThisTrialThisCluster);
            ISIThisCluster = [ISIThisCluster; diff(spikeTimeStampsThisTrialThisCluster*1000)];
        end
        
        % part
        edges = linspace(0,10,100);
        count=histc(ISIThisCluster,edges);
        axes(isiPartAx); hold on;
        if sum(count)>0
            existISILess10MS = true;
            prob=count/sum(count);
            ISIfill = fill([edges(1); edges(:); edges(end)],[0; prob(:); 0],colors(i,:));
            set(ISIfill,'edgeAlpha',1,'faceAlpha',.5);
            maxEdgePart = max(maxEdgePart,max(edges));
            maxProbPart = max(maxProbPart,max(prob));
        end
        
        
        % total
        edges = linspace(0,10000,100);
        count=histc(ISIThisCluster,edges);
        axes(isiTotAx); hold on;
        if sum(count)>0
            existISILess10000MS = true;
            prob=count/sum(count);
            ISIfill = fill([edges(1); edges(:); edges(end)],[0; prob(:); 0],colors(i,:));
            set(ISIfill,'edgeAlpha',1,'faceAlpha',.5);
            maxEdgeTot = max(maxEdgeTot,max(edges));
            maxProbTot = max(maxProbTot,max(prob));
        end
        
    end
    ISIThisCluster = [];
    for currTrialNum = 1:length(trialNums)
        whichThisTrialThisCluster = (trialNumForSpikes==trialNums(currTrialNum))&whichSpikes;
        spikeTimeStampsThisTrialThisCluster = spikeTimestamps(whichThisTrialThisCluster);
        ISIThisCluster = [ISIThisCluster; diff(spikeTimeStampsThisTrialThisCluster*1000)];
    end
    % part
    edges = linspace(0,10,100);
    count=histc(ISIThisCluster,edges);
    axes(isiPartAx); hold on;
    if sum(count)>0
        existISILess10MS = true;
        prob=count/sum(count);
        ISIfill = fill([edges(1); edges(:); edges(end)],[0; prob(:); 0],'r');
        set(ISIfill,'edgeAlpha',1,'faceAlpha',.5);
        maxEdgePart = max(maxEdgePart,max(edges));
        maxProbPart = max(maxProbPart,max(prob));
    end
    if existISILess10MS
        axis([0 maxEdgePart 0 maxProbPart]);
    else
        text(1,1,'no ISI < 10 ms','HorizontalAlignment','right','VerticalAlignment','Top');
    end
    
    hold on
    lockout=1000*39/plottingInfo.samplingRate;  %why is there a algorithm-imposed minimum ISI?  i think it is line 65  detectSpikes
    lockout=edges(max(find(edges<=lockout)));
    plot([lockout lockout],get(gca,'YLim'),'k') %
    plot([2 2], get(gca,'YLim'),'k--')

    
    % total
    edges = linspace(0,10000,100);
    count=histc(ISIThisCluster,edges);
    axes(isiTotAx); hold on;
    if sum(count)>0
        existISILess10000MS = true;
        prob=count/sum(count);
        ISIfill = fill([edges(1); edges(:); edges(end)],[0; prob(:); 0],'r');
        set(ISIfill,'edgeAlpha',1,'faceAlpha',.5);
        maxEdgeTot = max(maxEdgeTot,max(edges));
        maxProbTot = max(maxProbTot,max(prob));
    end    
    if existISILess10000MS
        axis([0 maxEdgeTot 0 maxProbTot]);
    else
        text(1,1,'no ISI < 10 s','HorizontalAlignment','right','VerticalAlignment','Top');
    end

        

    
    
        
%     
%     %full
%     hist(isiTotAx,ISI,100);
    
    %% now for the stuff that may or maynot exist
    if plottingInfo.plotZoom
        whichChans = getPhysIndsForTrodeChans(neuralRecord.ai_parameters.channelConfiguration,trodes{trodeNum});
        zoomWidth=neuralRecord.samplingRate*0.5;  % 500msec default, key board zoom steps by a factor of 2
        lastSpikeTimePad=min([max(spikeTimesThisTrial-spikeRecord.sampleIndAdjustment)+200 size(neuralRecord.neuralDataTimes,1)]);
        zoomInds=[max(lastSpikeTimePad-zoomWidth,1):lastSpikeTimePad ];
        if isempty(zoomInds)
            warning('im not going to bother about this right now...but nothing will happen for this chunk...')
            break
        end
        N=length(whichChans);
        colors=0.8*ones(N,3);
        colors(1,:)=0; %first one is black is main
        
        % rawSignal
        axes(rawAx);
        titleStr = sprintf('rawSignal Zoom for %d.%d',plottingInfo.trialNum,plottingInfo.chunkID);
        title(titleStr);
        hold on
        
        steps=max(std(neuralRecord.neuralData(:,whichChans)));
        for i=1:N
            plot(neuralRecord.neuralDataTimes(zoomInds),neuralRecord.neuralData(zoomInds,whichChans(i))-steps*(i-1),'color',colors(i,:))
         end
        set(gca,'ytick',[])
        
        someNoiseTimes=noiseTimesThisTrial(ismember(noiseTimesThisTrial-spikeRecord.sampleIndAdjustment,zoomInds))-spikeRecord.sampleIndAdjustment;
        someSpikeTimes=spikeTimesThisTrial(ismember(spikeTimesThisTrial-spikeRecord.sampleIndAdjustment,zoomInds))-spikeRecord.sampleIndAdjustment;
        plot(neuralRecord.neuralDataTimes(someNoiseTimes),neuralRecord.neuralData(someNoiseTimes,whichChans(1)),'.b');
        plot(neuralRecord.neuralDataTimes(someSpikeTimes),neuralRecord.neuralData(someSpikeTimes,whichChans(1)),'.r');
        axis([ minmax(neuralRecord.neuralDataTimes(zoomInds)')   ylim ])
        
        % filtered signal
        axes(filtAx);
        titleStr = sprintf('filtSignal Zoom for %d.%d',plottingInfo.trialNum,plottingInfo.chunkID);
        title(titleStr);
        filtOrder=min(neuralRecord.samplingRate/200,floor(size(neuralRecord.neuralData,1)/3)); %how choose filter orders? one extreme bound: Data must have length more than 3 times filter order.
        freqLoHi = [200 10000];
        [b,a]=fir1(filtOrder,2*freqLoHi/neuralRecord.samplingRate);
        filteredSignal=filtfilt(b,a,neuralRecord.neuralData(:,whichChans));
        hold on
        steps=max(std(filteredSignal));
        for i=fliplr(1:N)
            plot(neuralRecord.neuralDataTimes(zoomInds),filteredSignal(zoomInds,i)-steps*(i-1),'color',colors(i,:))
        end
        plot(neuralRecord.neuralDataTimes(someNoiseTimes),filteredSignal(someNoiseTimes),'.b');
        plot(neuralRecord.neuralDataTimes(someSpikeTimes),filteredSignal(someSpikeTimes),'.r');
        axis([neuralRecord.neuralDataTimes(zoomInds([1 end]))'   ylim])
        set(gca,'XTick',[]);
        
        linkaxes([filtAx rawAx],'x');
    end
end
else
    interactiveInspectGUI(analysisPath,plottingInfo,trodes,spikeRecord);
end
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = makerow(x)
%y = makerow(x)

x = squeeze(x);
if(size(x,2) == 1) 
    x = x';
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function thesePhysChannelInds = getPhysIndsForTrodeChans(channelConfiguration,currTrode)
chansRequired=unique(currTrode);
for c=1:length(chansRequired)
    chansRequiredLabel{c}=['phys' num2str(chansRequired(c))];
end

if any(~ismember(chansRequiredLabel,channelConfiguration))
    chansRequiredLabel
    channelConfiguration
    error(sprintf('requested analysis on channels %s but thats not available',char(setdiff(chansRequiredLabel,neuralRecord.ai_parameters.channelConfiguration))))
end
thesePhysChannelLabels = {};
thesePhysChannelInds = [];
for c=1:length(currTrode)
    thesePhysChannelLabels{c}=['phys' num2str(currTrode(c))];
    thesePhysChannelInds(c)=find(ismember(channelConfiguration,thesePhysChannelLabels{c}));
end
end

