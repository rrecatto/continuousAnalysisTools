function fig = analyzeLFP(s,params)
subj = s.subject;
tr = s.trials;

if IsWindows
    LFPSavePath = fullfile(s.dataPath,s.subject,'analysis',s.sourceFolder);
else 
    LFPSavePath = fullfile(recordsPathLUT(s.dataPath,'Win2Lx'),s.subject,'analysis',s.sourceFolder);
end
LFPFileName = sprintf('LFPRecord_%s.mat',s.sourceFolder);
temp = load(fullfile(LFPSavePath,LFPFileName));
LFPRecord = temp.LFPRecord;

if ~isfield(params,'handle')
    fig = figure;
else 
    fig = figure(params.handle);
end
set(fig,'position',[680 70 560 1028]);

ax = subplot(3,3,1:3); plot2ax(s,ax,{'f1'});

numRepeats = size(LFPRecord,1);
numTypes = size(LFPRecord,2);

% calculate power
plotSpectrogram = true;
if plotSpectrogram
    for rep = 1:numRepeats
        for type = 1:numTypes
            ax = subplot(numTypes,numRepeats,rep+(type-1)*numRepeats);
            Fs = 1000;
            nFFT = 512;
            window = 250;
            noverlap = 249;
            [S F T] = spectrogram(LFPRecord{rep,type},window,noverlap,nFFT,Fs);
            which = F<65;
%             surf(T,F(which),abs(S(which,:)),'edgecolor','none');
            imagesc(T,F(which),flipud(abs(S(which,:))))
            yLabs = get(gca,'yticklabel');
            yLabsNew = {};
            for labNum = 1:length(yLabs)
                yLabsNew{labNum} = yLabs(end-labNum+1,:);
            end
            set(gca,'yticklabel',yLabsNew)
            axis tight;
            view(0,90);
        end
    end
else
    chrParams.tapers = [2 3];
    chrParams.err = [0 0.05];
    chrParams.Fs = 1000; % hard set previously...maybe need to save this in the records somewhere?
    pLFP = {};
    fLFP = {};
    pLFPNorm = {};
    pNormInterp = [];
    fInterp = 0:0.5:19.5;
    ax = subplot(3,3,4:6); hold on;
    for rep = 1:numRepeats
        for type = 1:numTypes
            [pLFP{rep,type} fLFP{rep,type}]= mtspectrumc(LFPRecord{rep,type},chrParams);
            currPow = pLFP{rep,type};
            currPowNorm = (currPow/sum(currPow));
            pLFPNorm{rep,type} = currPowNorm;
            currfLFP = fLFP{rep,type};
            which = currfLFP<20;
            plot(currfLFP(which),0.8*(currPowNorm(which)/max(currPowNorm))+type,'k','linewidth',0.2); % make sure they are all of height 0.8
            pNormInterp(rep,type,:) = interp1(fLFP{rep,type},pLFP{rep,type},fInterp);
        end
    end
    ax = subplot(3,3,7:9); hold on;
    for type = 1:numTypes
        pAvg = mean(squeeze(pNormInterp(:,type,:)),1);
        pSD = std(squeeze(pNormInterp(:,type,:)),[],1);
        subplot(ax);
        plot(fInterp,0.8*(pAvg/max(pAvg))+type,'r','linewidth',3);
    end
end

end