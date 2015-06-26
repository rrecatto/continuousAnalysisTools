function plotTemporal(s,axHan,params)
if ~exist('params','var') || isempty(params)
    params.plotNormal = true;
    params.plotHighPrecision = false;
elseif ~isfield(params,'plotHighPrecision')
    params.plotNormal = true;
    params.plotHighPrecision = false;
else
    params.plotNormal = false;
end

sm = whiteNoise;
axes(axHan);hold on;
posMAX = findPixel(s,'maxSTA');
posMIN=findPixel(s,'minSTA');

rng = minmax(makerow(s.STA(:)));
[mean std] = getMeanLuminanceAndStd(sm,s.stimInfo);
timeWindowFramesStim=ceil(s.timeWindow*(s.stimInfo.refreshRate/1000));

% plot the means
timeMs=linspace(-s.timeWindow(1),s.timeWindow(2),size(s.STA,3));
ns=length(timeMs);
if params.plotNormal
    hold off; plot(timeWindowFramesStim([1 1])+1, [0 whiteVal(sm)] ,'k');
    hold on;  plot([1 ns],mean([1 1])*whiteVal(sm),'k');
    try
        [brightSig brightSTV]= getTemporal(s,posMAX);
    catch
        keyboard
    end
    [darkSig darkSTV]= getTemporal(s,posMIN);
    
    brightER95 = brightSTV/s.numSpikes*1.96;
    darkER95 = darkSTV/s.numSpikes*1.96;
    
    brightCI = repmat(brightSig(:),1,2)+brightER95(:)*[-1 1];
    darkCI = repmat(darkSig(:),1,2)+darkER95(:)*[-1 1];
    
    fh=fill([1:ns fliplr([1:ns])]',[darkCI(:,1); flipud(darkCI(:,2))],'b'); set(fh,'edgeAlpha',0,'faceAlpha',.5)
    fh=fill([1:ns fliplr([1:ns])]',[brightCI(:,1); flipud(brightCI(:,2))],'r'); set(fh,'edgeAlpha',0,'faceAlpha',.5)
    plot([1:ns], darkSig(:)','b');
    plot([1:ns], brightSig(:)','r');
    axis([1 ns rng(1)-0.2*(diff(rng)) rng(2)+0.2*(diff(rng))]);
    
    relevantTemporal = getTemporal(s,s.relevantIndex);
    type = classify(s,'ONOFFMaxDev'); type = type{1};
    switch type
        case 'ON'
            peakFrame = find(relevantTemporal==max(relevantTemporal));
        case 'OFF'
            peakFrame = find(relevantTemporal==min(relevantTemporal));
    end
    
    timeInds=[1 peakFrame(end) timeWindowFramesStim(1)+1 size(s.STA,3)];
    set(gca,'XTick',unique(timeInds),'XLim',minmax(timeInds));
    Labels = {};
    whichTimeInds = unique(timeInds);
    for tInd = 1:length(whichTimeInds)
        Labels{tInd} = sprintf('%2.0f',timeMs(whichTimeInds(tInd)));
    end
    set(axHan,'XTickLabel',Labels);
    %             set(axHan,'YLim',[minmax([analysisdata.singleChunkTemporalRecord(:)' darkCI(:)' brightCI(:)'])+[-5 5]])
    ylabel('RGB(gunVal)')
    xlabel('msec')
elseif params.plotHighPrecision
    % find the high precision kernel.
    highPrecisionParams.mode = 'center';
    highPrecisionParams.precisionInMS = 1;
    highPrecisionParams.channels = s.channels;
    [sta stv numSpikes] = getTemporalKernelAtHighPrecision(s,highPrecisionParams);
    timeMSHighPrecision = linspace(-s.timeWindow(1),s.timeWindow(2),length(sta));
    
    nsHighPrecision=length(timeMSHighPrecision);
    sem = stv/numSpikes*1.96;
    if isfield(params,'timeCourse')
        which = timeMSHighPrecision>=-params.timeCourse(1) & timeMSHighPrecision<=params.timeCourse(2);
        timeMSHighPrecision = timeMSHighPrecision(which);
        sta = sta(which);
        sem = sem(which);
    end
    
    hold off; 
    fh = fill([timeMSHighPrecision fliplr(timeMSHighPrecision)]',[((sta+sem-127.5)/127.5) fliplr((sta-sem-127.5)/127.5)]','k');hold on;
    set(fh,'edgeAlpha',0,'faceAlpha',.5)
    plot(timeMSHighPrecision,(sta-127.5)/127.5,'k','linewidth',2);
    
    plot([timeMSHighPrecision(1) timeMSHighPrecision(end)],[0 0],'k');plot([0 0],[-0.5 0.5],'k')
    set(gca,'xlim',[timeMSHighPrecision(1) timeMSHighPrecision(end)],'ylim',[-0.5 0.5],'ytick',[-0.2 0.2],'yticklabel',{'-0.2','0.2'},'xtick',[-200 0 50]);
    xlabel('msec')
end



end
