function updateInspectGUI(handles)
whichFig = handles.inspectGUIFig;
spikes =  handles.currentSpikeRecord.spikes;
spikeWaveforms =  handles.currentSpikeRecord.spikeWaveforms;
assignedClusters =  handles.currentSpikeRecord.assignedClusters;
spikeTimestamps = handles.currentSpikeRecord.spikeTimestamps;
trialNumForSpikes = handles.currentSpikeRecord.trialNumForDetectedSpikes;
rankedClustersCell = handles.currentSpikeRecord.rankedClusters;
processedClusters = handles.currentSpikeRecord.processedClusters;

% now check if worth plotting
if isempty(spikes)
    warning('no spikes at all in this trode');
    return
end
if iscell(rankedClustersCell)
    rankedClusters = [];
    for i = 1:length(rankedClustersCell)
        rankedClusters = unique([rankedClusters;makerow(rankedClustersCell{i})']);
    end
else
    rankedClusters = rankedClustersCell;
end
[features nDim] = useFeatures(spikeWaveforms,handles.currentSpikeRecord.spikeModel.featureList,...
    handles.currentSpikeRecord.spikeModel.featureDetails);

switch upper(handles.currentSpikeRecord.spikeModel.clusteringMethod)
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
noiseTimes=candTimes(whichNoise);


isiTotAx = handles.hist10000MSAxis;
cla(isiTotAx);
isiPartAx = handles.hist10MSAxis;
cla(isiPartAx);
waveAx = handles.waveAxis;
cla(waveAx);
waveMeansAx = handles.waveMeansAxis;
cla(waveMeansAx);
featAx = handles.featureAxis;
cla(featAx);

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
title('waveforms');
meanWave = mean(spikeWaveforms(whichSpikes,:),1);
stdWave = std(spikeWaveforms(whichSpikes,:),[],1);
axes(waveMeansAx);hold on;plot(meanWave','color','r','LineWidth',2);
lengthOfWaveform = size(spikeWaveforms,2);
fillWave = fill([1:lengthOfWaveform fliplr(1:lengthOfWaveform)]',[meanWave+stdWave fliplr(meanWave-stdWave)]','r');set(fillWave,'edgeAlpha',0,'faceAlpha',.3)
linkaxes([waveAx waveMeansAx],'xy');
set(waveAx,'XTick',[]);
axes(waveAx);
axis([1 size(spikeWaveforms,2)  1.1*minmax(spikeWaveforms(:)') ])
axes(waveMeansAx); set(gca,'XTick',[1 25 61],'XTickLabel',{sprintf('%2.2f',-24000/handles.plottingParams.samplingRate),'0',sprintf('%2.2f',36000/handles.plottingParams.samplingRate)});xlabel('ms');
axes(featAx);hold on; plot3(features(whichSpikes,1),features(whichSpikes,2),features(whichSpikes,3),'r*');
title('features')

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
    title('ISI<10S')
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
    text(maxEdgePart/2,maxProbPart,'ISI<10ms','HorizontalAlignment','center','VerticalAlignment','Top')
else
    text(1,1,'no ISI < 10 ms','HorizontalAlignment','right','VerticalAlignment','Top');
end

hold on
lockout=1000*39/handles.plottingParams.samplingRate;  %why is there a algorithm-imposed minimum ISI?  i think it is line 65  detectSpikes
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
    text(maxEdgeTot/2,maxProbTot,'ISI<10s','HorizontalAlignment','center','VerticalAlignment','Top')
else
    text(1,1,'no ISI < 10 s','HorizontalAlignment','right','VerticalAlignment','Top');
end
end

function x = makerow(x)
%y = makerow(x)

x = squeeze(x);
if(size(x,2) == 1) 
    x = x';
end
end