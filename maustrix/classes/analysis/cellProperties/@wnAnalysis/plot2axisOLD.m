function  plot2axisOLD(s,plotsRequested,ax)
if ~exist('plotsRequested','var') || isempty(plotsRequested)
    plotsRequested={'temporalSTA'};
end

if isempty(s.STA)
    s.textPlot('no analysis');
    return
    
    warning('TEMP TESTING MODE:   direct load')
    keyboard
end

set the main requests to the default
[plotsRequested{ismember('main',plotsRequested)}]=deal('temporalSTA');
[plotsRequested{ismember('gaussianFullField',plotsRequested)}]=deal('glm');

wn=whiteNoise;
[meanLuminance std] = getMeanLuminanceAndStd(wn, s.stimInfo);

switch plotsRequested{1} % not handling the list yet
    case 'glm'
        s.plotGLM()
    case 'temporalSTA'
        [brightSignal brightCI brightInd]=getTemporalSignal(wn,s.STA,s.STV,s.numSpikes,'bright');
        [darkSignal darkCI darkInd]=getTemporalSignal(wn,s.STA,s.STV,s.numSpikes,'dark');
        
        %HARD CODED
        timeWindowMsStim=[200 50]; % parameter [300 50]
        refreshRate=s.stimInfo.refreshRate;
        timeWindowFramesStim=ceil(timeWindowMsStim*(refreshRate/1000));
        
        timeMs=linspace(-timeWindowMsStim(1),timeWindowMsStim(2),size(s.STA,3));
        ns=length(timeMs);
        hold off; plot(timeWindowFramesStim([1 1])+1, [0 whiteVal(wn)],'k');
        hold on;  plot([1 ns],meanLuminance([1 1])*whiteVal(wn),'k')
        % try
        %     plot([1:ns], analysisdata.singleChunkTemporalRecord, 'color',[.8 .8 1])
        % catch
        %     keyboard
        % end
        fh=fill([1:ns fliplr([1:ns])]',[darkCI(:,1); flipud(darkCI(:,2))],'b'); set(fh,'edgeAlpha',0,'faceAlpha',.5)
        fh=fill([1:ns fliplr([1:ns])]',[brightCI(:,1); flipud(brightCI(:,2))],'r'); set(fh,'edgeAlpha',0,'faceAlpha',.5)
        plot([1:ns], darkSignal(:)','b')
        plot([1:ns], brightSignal(:)','r')
        
        peakFrame=find(brightSignal==max(brightSignal(:)));
        timeInds=[1 peakFrame(end) timeWindowFramesStim(1)+1 size(s.STA,3)];
        set(gca,'XTickLabel',unique(timeMs(timeInds)),'XTick',unique(timeInds),'XLim',minmax(timeInds));
        %set(gca,'YLim',[minmax([analysisdata.singleChunkTemporalRecord(:)' darkCI(:)' brightCI(:)'])+[-5 5]])
        ylabel('RGB(gunVal)')
        xlabel('msec')
    otherwise
        error('unsupported')
        %using a more formal list we will eventuallt just pass
        %it to the superclass which declares its not there
end
end
