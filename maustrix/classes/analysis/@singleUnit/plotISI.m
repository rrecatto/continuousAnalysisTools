function plotISI(s)
params.violationThreshMs=1.5;
spikes=s.getSpikes();
iEi=diff(spikes.spikeTimestamps*1000);  % all events
numEvents=length(iEi);
iSi=diff(spikes.spikeTimestamps(logical(spikes.processedClusters))*1000);
numSpikes=length(iSi);

edges=linspace(0,10,50);
rlabHist([edges 11],histc(iEi,edges)'/numEvents,[.8 .8 .8]);
hold on;
rlabHist([edges 11],histc(iSi,edges)'/numSpikes,[.2 .2 .2]);
xl=xlim; yl=ylim;

plot(params.violationThreshMs([1 1]),yl,'k-')
numViolations=sum(iSi<params.violationThreshMs & iSi>0);
fracViolations=numViolations/numSpikes;
msg=sprintf('viol: %d (%2.2g%%)\n',numViolations,fracViolations*100);
text(xl(2)*0.2,yl(2)*0.8,msg)
end
