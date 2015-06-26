
function doRatePerCondition(sm,c,timeWindow)

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

hold on
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