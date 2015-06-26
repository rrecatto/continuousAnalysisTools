function displayCumulativePhysAnalysis(sm,cumulativeData,parameters)
% called by analysis manager when overwrite spikes is false, and analsis
% has generates a cumulative data for this range.  allows for display,
% without recomputation
%%

c=cumulativeData;
if isempty(c) || all(c.numSpikesAnalyzed==0) 
    disp('NO SPIKES --> SO SKIPPING CUM PHYS ANALYSIS FOR FLANKERS')
    return
end

if ~isfield(parameters,'plotsRequested') || isempty(parameters.plotsRequested)
    plotsRequested=c.plotsRequested;
end
%plotsRequested={'raster','viewSort'};



plotsRequested={'viewSort','meanPhotoTargetSpike';'viewDrops','rasterDensity'};

plotsRequested={'viewSort','viewDrops','rasterDensity';
    'plotEyes','photodiodeAlignment','raster';
    'meanPhotoTargetSpike','PSTH','ratePerCondition'};
plotsRequested={'PSTH_context','PSTH','ratePerConditionOff';'raster','rasterDensity','photodiodeAlignment'};
plotsRequested={'ratePerConditionOn','ratePerConditionOff';'raster','rasterDensity'};
plotsRequested={'viewSort'};
plotsRequested={'loglogISI','logISI'};
plotsRequested={'ratePerConditionOn','ratePerConditionOff';'raster','rasterDensity'};

if 0 %
    %filter out some of them
    amp= calculateFeatures(c.spikeWaveforms,{'peakToValley'});
    which=amp<.4
    c.spikeWaveforms=c.spikeWaveforms(which,:) % remove the filtered..
    if length(c.spike.times)~=size(c.spikeWaveforms,1)
        error('need to track waveform identity, or better, only include the ones that are in c.spike')
    end
    f=fields(c.spike);
    for i=1:length(f)
        c.spike.(f{i})=c.spike.(f{i})(which)
    end
end
%%

[numConditions numCycles numInstances nthOccurence displayHeight]=getNumConditionsEtc(sm,c);




[h w]=size(plotsRequested);
figure(parameters.figHandle)
set(gcf,'Name',sprintf('flankers trial [%d %d], %s',parameters.trialRange(1),parameters.trialRange(length(parameters.trialRange)),parameters.trodeName))
set(gcf,'position',[10 40 1200 900])

viewSort=any(ismember(plotsRequested(:),'viewSort'));
if viewSort
    sub=find(strcmp(plotsRequested','viewSort'));
    subplot(h,w,sub)
    plot(c.spikeWaveforms([c.processedClusters]~=1,:)','color',[0.2 0.2 0.2]);  hold on
    plot(c.spikeWaveforms(find([c.processedClusters]==1),:)','r');
    waveLn=size(c.spikeWaveforms,2);
    set(gca,'xLim',[1 waveLn],'yTick',[])
    ylabel('volts'); xlabel('msec')
    centerGuess=24;
    waveLn*1000/c.samplingRate;
    preMs=centerGuess*1000/c.samplingRate;
    postMs=(waveLn-centerGuess)*1000/c.samplingRate;
    set(gca,'xTickLabel',[-preMs 0 postMs],'xTick',[1 centerGuess waveLn])
end

viewDrops=any(ismember(plotsRequested(:),'viewDrops'));
if viewDrops
    sub=find(strcmp(plotsRequested','viewDrops'));
    subplot(h,w,sub)
    dropFraction=conv(c.droppedFrames,ones(1,100));
    plot(dropFraction)
    ylabel(sprintf('drops: %d',sum(c.droppedFrames)))
end

photodiodeAlignment=any(ismember(plotsRequested(:),'photodiodeAlignment'));
if photodiodeAlignment
    sub=find(strcmp(plotsRequested','photodiodeAlignment'));
    subplot(h,w,sub)
    imagesc(c.photodiodeRaster);  colormap(gray);
end


meanPhotoTargetSpike=any(ismember(plotsRequested(:),'meanPhotoTargetSpike'));
if meanPhotoTargetSpike
    sub=find(strcmp(plotsRequested','meanPhotoTargetSpike'));
    subplot(h,w,sub);hold on;
    
    meanLuminanceSignal=mean(c.photodiodeRaster);
    meanLuminanceSignal=meanLuminanceSignal-min(meanLuminanceSignal);
    meanLuminanceSignal=meanLuminanceSignal/max(meanLuminanceSignal);
    PSTH=mean(c.rasterDensity);
    PSTH=PSTH/max(PSTH);
    plot(meanLuminanceSignal,'r');
    plot(PSTH,'g');
    %plot(mean(tOn2),'.k');
    legend('photo','PSTH','Location','NorthWest') %'target',
    set(gca,'ytick',[0 1],'xtick',xlim,'xlim',[0 length(PSTH)]);
    xlabel('frame')
    title(sprintf('spikes: %d',sum(c.numSpikesAnalyzed)))
end

plotEyes=any(ismember(plotsRequested(:),'plotEyes'));
if plotEyes
    sub=find(strcmp(plotsRequested','plotEyes'));
    subplot(h,w,sub);hold on;
    
    if ~isempty(c.eyeSig)
        if length(unique(c.eyeSig(:,1)))>10 % if at least 10 x-positions
            regionBoundsXY=[1 .5]; % these are CRX-PY bounds of unknown degrees
            [within ellipses]=selectDenseEyeRegions(c.eyeSig,1,regionBoundsXY);
        else
            disp(sprintf('no good eyeData on trials [%s]',num2str(c.trialNumbers)))
            text(0.5,0.5,'bad eye data')
        end
    else
        text(0.5,0.5,'no eye data');
        set(gca,'xTick',[],'yTick',[])
    end
end



plotRasterDensity=any(ismember(plotsRequested(:),'rasterDensity'));
if plotRasterDensity
    sub=find(strcmp(plotsRequested','rasterDensity'));
    subplot(h,w,sub); hold on;
    numRepeats=max(c.spike.repetition);
    imagesc(flipud(c.rasterDensity));  colormap(gray)
    yTickVal=(numRepeats/2)+[0:numConditions-1]*numRepeats;
    set(gca,'YTickLabel',fliplr(c.conditionNames),'YTick',yTickVal);
    ylabel([c.swept]);
    xlabel('time (msec)');
    
    dur=diff(c.targetOnOff);
    shiftAmount=c.targetOnOff(1)/2;
    xloc=[0  shiftAmount shiftAmount+dur c.targetOnOff(2)]+ 0.5;
    xvals=[ -shiftAmount 0 dur shiftAmount+dur]*c.ifi*1000;
    set(gca,'XTickLabel',xvals,'XTick',xloc);
    
    plot(xloc([2 2]),[0.5 size(c.rasterDensity,1)+0.5],'g')
    plot(xloc([3 3]),[0.5 size(c.rasterDensity,1)+0.5],'g')
    axis([xloc([1 4]) 0.5+[0 size(c.rasterDensity,1)]])
    
    set(gca,'TickLength',[0 0])
end


%%
doRasterPlot=any(ismember(plotsRequested(:),'raster'));
if doRasterPlot
    sub=find(strcmp(plotsRequested','raster'));
    subplot(h,w,sub); hold on;
    plotRaster(sm,c);
end


%OLD RASTER MAY HAVE USED A DIFFERENT HEIGHT?
%CALCULATE DISPLAY HEIGHT
%     for i=1:numConditions
%         which=find(conditionPerCycle==i);
%         %this is prob not needed, but it garauntees temporal order as a secondary sort
%         [junk order]=sort(cycleOnset(which));
%         which=which(order);
%         nthOccurence(which)=1:length(which);  %nthOccurence of this condition in this list
%     end
%     instancesPerTrial=length(conditionPerCycle)/numConditions; % 24 in this test
%     displayHeight=nthOccurence(spike.cycle)+(spike.condition-1)*instancesPerTrial;
%     plotRaster=any(ismember(plotsRequested(:),'raster'));
%     if plotRaster
%         figure(parameters.trialNumber);
%         sub=find(strcmp(plotsRequested','raster'));
%         subplot(h,w,sub); hold on;
%
%         for i=1:numConditions
%             which=spike.condition==i;
%             plot(spike.relTimes(which),-displayHeight(which),'.','color',brighten(colors(i,:),-0.2))
%         end
%
%         yTickVal=-fliplr((instancesPerTrial/2)+[0:numConditions-1]*instancesPerTrial);
%         set(gca,'YTickLabel',fliplr(conditionNames),'YTick',yTickVal);
%         ylabel([swept]);
%
%         xlabel('time (msec)');
%         xvals=[ -timeToTarget 0  (double(s.targetOnOff)*ifi)-timeToTarget];
%         set(gca,'XTickLabel',xvals*1000,'XTick',xvals);
%
%         n=length(cycleOnset);
%         plot(xvals([2 2]),0.5+[-n 0],'k')
%         plot(xvals([3 3]),0.5+[-n 0],'k')
%
%         axis([xvals([1 4]) 0.5+[-n 0]])
%         set(gca,'TickLength',[0 0])
%     end
%%
plotRatePerConditionOn=any(ismember(plotsRequested(:),'ratePerConditionOn'));
if plotRatePerConditionOn
    sub=find(strcmp(plotsRequested','ratePerConditionOn'));
    subplot(h,w,sub); hold on;
    doRatePerCondition(c,'on') 
end

plotRatePerConditionOff=any(ismember(plotsRequested(:),'ratePerConditionOff'));
if plotRatePerConditionOff
    sub=find(strcmp(plotsRequested','ratePerConditionOff'));
    subplot(h,w,sub); hold on;
    doRatePerCondition(c,'off') 
end

showPSTH=any(ismember(plotsRequested(:),'PSTH'));
if showPSTH
    sub=find(strcmp(plotsRequested','PSTH'));
    subplot(h,w,sub); hold on;
    numTrials=length(unique(c.spike.trial));
    for i=1:numConditions
        spTm=c.spike.relTimes(c.spike.condition==i);
        countPerTrial=sum(c.spike.condition==i)/numTrials;
        if countPerTrial>0
            [fi,ti] = ksdensity(spTm,'width',.01);
            plot(ti*1000,fi*countPerTrial/c.targetOnOff(2),'color',c.colors(i,:));
            plot(spTm*1000,-i+0.5*(rand(1,length(spTm))-0.5),'.','color',brighten(c.colors(i,:),-0.9));
            histc(spTm,[])
        end
    end
    xlabel('time (msec)');
    timeToTarget=c.targetOnOff(1)*c.ifi/2;
    xvals=1000*[ -timeToTarget 0  (c.targetOnOff*c.ifi)-timeToTarget];
    set(gca,'xLim',xvals([1 4]))
    set(gca,'XTickLabel',xvals,'XTick',xvals);
    
    ylabel('rate');
    yl=ylim;
    set(gca,'yLim',[-(numConditions+1) yl(2)])
    set(gca,'yTickLabel',[0 yl(2)],'yTick',[0 yl(2)]);
end

showLoglogISI=any(ismember(plotsRequested(:),'loglogISI'));
if showLoglogISI
    sub=find(strcmp(plotsRequested','loglogISI'));
    subplot(h,w,sub); hold on;
    isi=diff(c.spike.times);
    if any(isi<0)
        error('assumed to be sorted')
    end
    isiB4=isi(1:end-1);
    isiAfter=isi(2:end);
    
    firstInBurst=isiAfter<0.008 & isiB4>.05;
    plot(log10(isiAfter),log10(isiB4),'k.'); hold on
    plot(log10(isiAfter(firstInBurst)),log10(isiB4(firstInBurst)),'r.')
    %loglog(isiAfter,isiB4,'k.')
    %loglog(isiAfter(firstInBurst),isiB4(firstInBurst),'r.')
    %i2si=c.spike.times(3:end)-c.spike.times(1:end-2);
    axis([-3 1 -3 1])
    vals=[1 10 100 1000 10000]
    set(gca,'xtick',[-3:1],'ytick',[-3:1],'ytickLabel',vals,'xtickLabel',vals)
    xlabel('isi after')
    ylabel('isi before')
    
end

showLogISI=any(ismember(plotsRequested(:),'logISI'));
if showLogISI
    sub=find(strcmp(plotsRequested','logISI'));
    subplot(h,w,sub); hold on;
    isi=diff(c.spike.times)*1000;
    if any(isi<0)
        error('assumed to be sorted')
    end
    edges=linspace(0,10,100);
    count=histc(isi,edges);
    bar(edges,count,'histc');
    
    set(gca,'xlim',[0 10])
    xlabel('isi')
    ylabel('count')
    
end

showPSTH_context=any(ismember(plotsRequested(:),'PSTH_context'));
if showPSTH_context
    sub=find(strcmp(plotsRequested','PSTH_context'));
    subplot(h,w,sub); hold on;
    unqTrials=unique(c.spike.trial);
    numTrials=length(unqTrials);
    numRepeats=max(c.spike.repetition);
    minTrial=min(c.spike.trial);
    adjTrial=c.spike.trial-minTrial;
    cumulativeRep=adjTrial*numRepeats+c.spike.repetition;
    for i=1:numConditions
        spTm=c.spike.relRepTimes(c.spike.condition==i);
        countPerTrial=sum(c.spike.condition==i)/numTrials;
        if countPerTrial>0
            [fi,ti] = ksdensity(spTm,'width',.01);
            time=1*20;
            plot(ti,fi*countPerTrial/time,'color',c.colors(i,:));
            plot(spTm,-cumulativeRep(c.spike.condition==i),'.','color',brighten(c.colors(i,:),-0.9));
            %histc(spTm,[])
        end
    end
    xlabel('time (sec)');
    %     timeToTarget=c.targetOnOff(1)*c.ifi/2;
    %     xvals=1000*[ -timeToTarget 0  (c.targetOnOff*c.ifi)-timeToTarget];
    %     set(gca,'xLim',xvals([1 4]))
    %     set(gca,'XTickLabel',xvals,'XTick',xvals);
    %
    ylabel('rate');
    yl=ylim;
    set(gca,'yLim',[-(max(cumulativeRep)+1) yl(2)])
    set(gca,'yTickLabel',[0 yl(2)],'yTick',[0 yl(2)],'xlim',[0 max(c.spike.relRepTimes)]);
end



cleanUpFigure
drawnow
%%
end


function doRatePerCondition(c,timeWindow)

numConditions=length(c.conditionNames);
numCycles=size(c.conditionPerCycle,1);
numInstances=numCycles/numConditions; 

dur=diff(c.targetOnOff)*c.ifi;
numTrials=length(unique(c.spike.trial));
numRepeats=max(c.spike.repetition);

warning('add in repeat per trial')
%which=(c.spike.relTimes<0 | c.spike.relTimes>dur); %perdiod before and after (contains off response)
which=(c.spike.relTimes<0 ); % period before
for r=1:numRepeats
    baseline(r)=sum(which & c.spike.repetition==r);
end
baselineRate=baseline./(c.targetOnOff(2)/2*c.ifi*numInstances*numTrials);
meanBaseLine=mean(baselineRate);
stdBaseLine=std(baselineRate)/sqrt(numRepeats);
minmaxBaseLine=[min(baselineRate) max(baselineRate)];

for i=1:numConditions
    switch timeWindow
        case 'on'
            which=(c.spike.condition==i & c.spike.relTimes>0 & c.spike.relTimes<dur);
        case 'off'
            which=(c.spike.condition==i & c.spike.relTimes>dur & c.spike.relTimes<dur*2);
    end
    count(i)=sum(which);
    for r=1:numRepeats
        countPerRep(i,r)=sum(which & c.spike.repetition==r);
    end
end
meanRatePerCond=count/(dur*numInstances*numTrials);
SEMRatePerCond=std(countPerRep/(dur*numInstances*numTrials/numRepeats),[],2)/sqrt(numRepeats);

fill([0 0 numConditions([1 1])+1 ],minmaxBaseLine([2 1 1 2]),'m','FaceColor',[.9 .9 .9],'EdgeAlpha',0)
fill([0 0 numConditions([1 1])+1 ],meanBaseLine+stdBaseLine*[1 -1 -1 1],'m','FaceColor',[.8 .8 .8],'EdgeAlpha',0)
for i=1:numConditions
    errorbar(i,meanRatePerCond(i),SEMRatePerCond(i),'color',c.colors(i,:));
    plot(i,meanRatePerCond(i),'.','color',c.colors(i,:));
end
ylabel(sprintf('<rate>_{%s}',timeWindow));
set(gca,'xLim',[0.5 numConditions+0.5]);
yl=ylim;
set(gca,'yLim',[0 yl(2)]);
set(gca,'XTickLabel',c.conditionNames,'XTick',1:numConditions);
end