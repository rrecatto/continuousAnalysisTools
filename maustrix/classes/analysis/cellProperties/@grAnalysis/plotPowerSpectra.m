function [out ax] = plotPowerSpectra(s,handle,params)
figure(handle);
c = getAnalysis(s);
out = {};
switch length(s.sweptParameters)
    case 1
        sm = eval(c.stimInfo.stimulusDetails.stimManagerClass);
        numSweptParameters = length(s.sweptParameters);
        refreshRate = c.stimInfo.refreshRate;
        numRepeats = length(unique(c.repeats));
        numTypes = length(unique(c.types));
        powerAlgos = {'directFFT','chronux','autocorr'};
        out{length(powerAlgos)} = struct;
        for currAlgoNum = 1:length(powerAlgos)
            out{currAlgoNum}.method = powerAlgos{currAlgoNum};
            out{currAlgoNum}.f0 = nan(numTypes,numRepeats);
            out{currAlgoNum}.f1 = nan(numTypes,numRepeats);
            out{currAlgoNum}.f2 = nan(numTypes,numRepeats);
            
            for type = 1:numTypes
                for rep = 1:numRepeats
                    stim = cos(c.phases((c.repeats==rep)&(c.types==type)));
                    spike = c.spikeCount((c.repeats==rep)&(c.types==type));
                    switch powerAlgos{currAlgoNum}
                        case 'directFFT'
                            fStim = fft(stim);
                            fSpike = fft(spike);
                            if numel(fStim)>10
                                dc = fSpike(1)/length(stim)*s.stimInfo.refreshRate; % the DC component
                                fStim=abs(fStim(2:floor(length(fStim)/2))); % get rid of DC and symetry
                                fSpike=abs(fSpike(2:floor(length(fSpike)/2)));
                                freqSpike = linspace(0,refreshRate/2,length(fSpike)+1);
                                freqSpike(1) = [];
                                indF1 = min(find(fStim==max(fStim)));
                                indF2 = 2*indF1;
                                subplot(3+numTypes,length(powerAlgos),9+(type-1)*length(powerAlgos)+1);hold on;
                                plot(freqSpike,fSpike,'k','LineWidth',0.5);
                                stdFSpike = std(fSpike);
                                if fSpike(indF1)-mean(fSpike)>2*stdFSpike
                                    plot(freqSpike(indF1),fSpike(indF1),'r.');
                                end
                                if fSpike(indF2)-mean(fSpike)>2*stdFSpike
                                    plot(freqSpike(indF2),fSpike(indF2),'g.');
                                end
                                out{currAlgoNum}.f0(type,rep) = dc;
                                out{currAlgoNum}.f1(type,rep) = fSpike(indF1)/length(spike)*refreshRate;
                                out{currAlgoNum}.f2(type,rep) = fSpike(indF2)/length(spike)*refreshRate;
                                
                                
                                if type~=numTypes
                                    set(gca,'XTick',[]);
                                end
                                set(gca,'xlim',[0 30]);
                            end
                        case 'chronux'
                            if length(stim)>10 % to handle cases when there is no stim for the relevant data
                                chrParams.tapers = [2 3];
                                chrParams.err = [0 0.05];
                                chrParams.Fs = refreshRate;
                                [pStim freqStim]= mtspectrumc(stim,chrParams);
                                chrParams.trialave = 1;
                                [pSpike freqSpike spRate]= mtspectrumpb(spike,chrParams,1); %fscorr is 1
                                subplot(3+numTypes,length(powerAlgos),9+(type-1)*length(powerAlgos)+2);hold on;
%                                 plot(freqStim,sqrt(pStim)/max(sqrt(pStim)),'r','LineWidth',0.5);
                                
                                
                                
                                [junk indF1] = min(abs(freqSpike-c.stimInfo.driftfrequencies));
                                [junk indF2] = min(abs(freqSpike-2*c.stimInfo.driftfrequencies));
                                plot(freqSpike,sqrt(pSpike),'k','LineWidth',0.5);
                                
                                stdFSpike = std(sqrt(pSpike));
                                
                                if sqrt(pSpike(indF1))-mean(sqrt(pSpike))>2*stdFSpike
                                    plot(freqSpike(indF1),sqrt(pSpike(indF1)),'r.');
                                end
                                if sqrt(pSpike(indF2))-mean(sqrt(pSpike))>2*stdFSpike
                                    plot(freqSpike(indF2),sqrt(pSpike(indF2)),'g.');
                                end
                                out{currAlgoNum}.f0(type,rep) = spRate;
                                out{currAlgoNum}.f1(type,rep) = sqrt(pSpike(indF1));
                                out{currAlgoNum}.f2(type,rep) = sqrt(pSpike(indF2));
                            end

                            if type~=numTypes
                                set(gca,'XTick',[]);
                            end
                            set(gca,'xlim',[0 30]);
                        case 'autocorr'
                            if length(stim)>10
                                [fStimAC freqStimAC] = spectofspike(stim,128,1/refreshRate,false);
                                [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,128,1/c.stimInfo.refreshRate,false);
                                subplot(3+numTypes,length(powerAlgos),9+(type-1)*length(powerAlgos)+3);hold on;
%                                 plot(freqStimAC,fStimAC/max(fStimAC),'r','LineWidth',0.5);
                                plot(freqSpikeAC,fSpikeAC,'k','LineWidth',2);
                                
                                peakfInd=min(find(fStimAC==max(fStimAC)));
%                                 plot(freqStimAC(peakfInd),fStimAC(peakfInd),'k*');
                                peakf = freqStimAC(peakfInd);
                                
                                [junk indF1] = min(abs(freqSpikeAC-peakf));
                                [junk indF2] = min(abs(freqSpikeAC-2*peakf));

                                stdFSpike = std(fSpikeAC);
                                
%                                 if fSpikeAC(indF1)-mean(fSpikeAC)>2*stdFSpike
                                    plot(freqSpikeAC(indF1),fSpikeAC(indF1),'bd','markersize',5,'markerfacecolor','b');
%                                 end
%                                 if fSpikeAC(indF2)-mean(fSpikeAC)>2*stdFSpike
                                    plot(freqSpikeAC(indF2),fSpikeAC(indF2),'gd','markersize',5,'markerfacecolor','g');
%                                 end
                                
                                out{currAlgoNum}.f0(type,rep) = spRateAC;
                                out{currAlgoNum}.f1(type,rep) = fSpikeAC(indF1);
                                out{currAlgoNum}.f2(type,rep) = fSpikeAC(indF2);
                                
                            end

                            if type~=numTypes
                                set(gca,'XTick',[]);
                            end
                            set(gca,'xlim',[0 15],'ylim',[0 50]);
                        otherwise
                            error('unsupported method to calculate power');
                    end
                end
            end
            
        end
        for currAlgoNum = 1:length(powerAlgos)
            switch out{currAlgoNum}.method
                case 'directFFT'
                    col = 'r';
                    pos = [1,1];
                    textColor = 'red';
                case 'chronux'
                    col = 'g';
                    pos = [1,0.9];
                    textColor = 'green';
                case 'autocorr'
                    col = 'b';
                    pos = [1,0.8];
                    textColor = 'blue';
            end
            subplot(numTypes,length(powerAlgos),[1 4]); % f0
            hold on;
            f0mean = nanmean(out{currAlgoNum}.f0,2);
            % normalize the first response to 1
            fact = max(f0mean);
            plot(f0mean/fact,'color',col);
            for i = 1:numTypes
                f0sem = nanstd(out{currAlgoNum}.f0(i,:))/sqrt(sum(~isnan(out{currAlgoNum}.f0(i,:))));
                plot([i,i],[f0mean(i)/fact+f0sem/fact,f0mean(i)/fact-f0sem/fact],'color',col);
            end
                        ylims = get(gca,'ylim');
            ylims(1) = 0;
            set(gca,'ylim',ylims);
            title('f0')
            
            subplot(numTypes,length(powerAlgos),[2 5]); % f1
            hold on;
            f1mean = nanmean(out{currAlgoNum}.f1,2);
            % normalize the first response to 1
            fact = max(f1mean);
            plot(f1mean/fact,'color',col);
            for i = 1:numTypes
                f1sem = nanstd(out{currAlgoNum}.f1(i,:))/sqrt(sum(~isnan(out{currAlgoNum}.f1(i,:))));
                plot([i,i],[f1mean(i)/fact+f1sem/fact,f1mean(i)/fact-f1sem/fact],'color',col);
            end
            tuning = (max(f1mean)-min(f1mean))/mean(f1mean);
            tuningText = sprintf('color{%s}%2.2f',textColor,tuning);
            tuningText = ['\' tuningText];
%             keyboard
            text(pos(1),pos(2),tuningText,'units','normalized','horizontalalignment','right','verticalalignment','top');
                        ylims = get(gca,'ylim');
            ylims(1) = 0;
            set(gca,'ylim',ylims);
            title('f1');
            
            subplot(numTypes,length(powerAlgos),[3 6]); % f2
            hold on;
            f2mean = nanmean(out{currAlgoNum}.f2,2);
            % normalize the first response to 1
            fact = max(f2mean);
            plot(f2mean/fact,'color',col);
            for i = 1:numTypes
                f2sem = nanstd(out{currAlgoNum}.f2(i,:))/sqrt(sum(~isnan(out{currAlgoNum}.f2(i,:))));
                plot([i,i],[f2mean(i)/fact+f2sem/fact,f2mean(i)/fact-f2sem/fact],'color',col);
            end
            ylims = get(gca,'ylim');
            ylims(1) = 0;
            set(gca,'ylim',ylims);
            title('f2')
        end
        
        ax1 = axes('position',[0.2,0.01,0.1,0.05]);
        text(0.5,0.5,'directFFT','units','normalized','horizontalalignment','center','verticalalignment','middle');
        axis off
        set(gca,'Xtick',[],'ytick',[]);
        
        ax2 = axes('position',[0.45,0.01,0.1,0.05]);
        text(0.5,0.5,'chronux','units','normalized','horizontalalignment','center','verticalalignment','middle');
        axis off
        set(gca,'Xtick',[],'ytick',[]);
        
        ax3 = axes('position',[0.7,0.01,0.1,0.05]);
        text(0.5,0.5,'autocorr','units','normalized','horizontalalignment','center','verticalalignment','middle');
        axis off
        set(gca,'Xtick',[],'ytick',[]);
%         if isfield('nID',params)
            
            ax4 = axes('position',[0.9,0.5,0.095,0.45]);
%             nIDText = sprintf('nID:%d',params.nID);
%             subAText = sprintf('AInd:%d',params.aInd);
nIDText = '';
subAText = '';
ONText = '';
latencyText = '';

%             switch params.ON
%                 case 1
%                     ONText = 'ON';
%                     latencyText = sprintf('L:%2.0f ms',params.latency);
%                 case 0
%                     ONText = 'OFF';
%                     latencyText = sprintf('L:%2.0f ms',params.latency);
%                 otherwise
%                     ONText = 'unknown';
%                     latencyText = '?';
%             end
            textDetails = {nIDText,subAText,ONText,latencyText};
            text(0.5,0.5,textDetails,'units','normalized','horizontalalignment','center','verticalalignment','middle');
            axis off;
            set(gca,'Xtick',[],'ytick',[]);
%         end
        %         text(0.5,0.9,'chronux','units','normalized');
%         text(0.75,0.9'autocorr','units','normalized');

        
    otherwise
        error('unsupported numSweptParams');
end
end