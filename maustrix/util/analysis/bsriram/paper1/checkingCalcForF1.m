%% model data
clc;
f0 = 50; f1 = 25; f2 = 3;
dt = 0.001; t = 0:dt:10;
ft = f0+f1*sin(12*t)+f2*sin(24*t);
subplot(4,1,1);
plot(t,ft);
spTrain = nan(size(t));
spTrain = rand(size(t))<ft*dt;
subplot(4,1,2)
plot(t,spTrain)
sum(spTrain)/max(t);

ax1 = subplot(4,1,3);
plot(abs(fft(spTrain)));

ax2 = subplot(4,1,4);
plot(abs(fft(ft)));

linkaxes([ax1 ax2],'x')
%% using actual data. direct fft calculation and plotting
% error('need to change dataLoc to the correct physAnalysis.mat file. can remove error after linking to correct file');
dataLoc = 'C:\Documents and Settings\Owner\My Documents\Downloads\physAnalysis.mat';
temp = load(dataLoc);
physAnalysis = temp.physAnalysis;
c = physAnalysis{1}{1}.trode_1;

% using actual data analysis techniques
s.stimInfo.refreshRate = c.stimInfo.refreshRate; % the refreshrate
numRepeats = length(unique(c.repeats));
numTypes = length(unique(c.types));
s.f0 = nan(numRepeats,numTypes);
s.f1 = nan(numRepeats,numTypes);
s.f2 = nan(numRepeats,numTypes);
s.coh = nan(numRepeats,numTypes);
s.cohLB = nan(numRepeats,numTypes);

for rep = 1:numRepeats
    for type = 1:numTypes
        % recreate the stim
        stim = 0.5+0.5*cos(c.phases((c.repeats==rep)&(c.types==type)));
        spike = c.spikeCount((c.repeats==rep)&(c.types==type));
        fStim = fft(stim);
        fSpike = fft(spike);
        if ~isempty(fStim) && length(fStim)>10
            s.f0(rep,type) = fSpike(1)/length(stim)*s.stimInfo.refreshRate; % the DC component
            pSpike=angle(fStim(2:floor(length(fStim)/2)));
            fStim=abs(fStim(2:floor(length(fStim)/2))); % get rid of DC and symetry
            fSpike=abs(fSpike(2:floor(length(fSpike)/2)));
            indF1 = min(find(fStim==max(fStim)));
            indF2 = 2*indF1;
            s.f1(rep,type) = fSpike(indF1)/length(stim)*s.stimInfo.refreshRate;
            s.phaseDensity(rep,type) = pSpike(indF1);
            if numel(fSpike)>indF2
                s.f2(rep,type) = fSpike(indF2)/length(stim)*s.stimInfo.refreshRate;
            else
                s.f2(rep,type) = nan;
            end
            % coherency
            chrParam.tapers=[3 5]; % same as default, but turns off warning
            chrParam.err=[2 0.05];  % use 2 for jacknife
            fscorr=true;
            % should check chronux's chrParam,trialave=1 to see how to
            % handle CI's better.. will need to do all repeats at once
            [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=...
                coherencycpb(stim,spike,chrParam,fscorr);
            
            if ~zerosp
                peakFreqInds=find(S1>max(S1)*.95); % a couple bins near the peak of
                [junk maxFreqInd]=max(S1);
                s.coh(rep,type)=mean(C(peakFreqInds)); % mean of coherencey near the peak...what are we doing this?
                s.cohLB(rep,type)=Cerr(1,maxFreqInd); % error is at the max Ind
            else
                s.coh(rep,type)=nan;
                s.cohLB(rep,type)=nan;
            end
            
        else
            s.f0(rep,type) = nan;
            s.f1(rep,type) = nan;
            s.f2(rep,type) = nan;
            s.coh(rep,type) = nan;
            s.cohLB(rep,type) = nan;
        end
    end
end

[repInds typeInds]=find(isnan(s.f1));
s.f0(unique(repInds),:)=nan;   % remove reps with bad power estimates
s.f1(unique(repInds),:)=nan;   % remove reps with bad power estimates
s.f2(unique(repInds),:)=nan;   % remove reps with bad power estimates
s.coh(unique(repInds),:)=nan;   % remove reps with bad power estimates
s.cohLB(unique(repInds),:)=nan; % remove reps with bad power estimates

figure;
subplot(3,1,1),plot(nanmean(s.f0,1));title('f0.normal fft')
subplot(3,1,2),plot(nanmean(s.f1,1));title('f1')
subplot(3,1,3),plot(nanmean(s.f2,1));title('f2')

%% see movie
for rep = 1:numRepeats
    for type = 1:numTypes
        figure(1);
        stim = 0.5+0.5*cos(c.phases((c.repeats==rep)&(c.types==type)));
        spike = c.spikeCount((c.repeats==rep)&(c.types==type));
        subplot(4,1,1); plot(stim);
        title(sprintf('t:%d,r:%d',type,rep));
        subplot(4,1,2); plot(spike);
        fStim = abs(fft(stim));
        fSpike = abs(fft(spike));
        % take away f0
        
        ax1 = subplot(4,1,3); plot(fStim); set(ax1,'xlim',[0 100])
        ax2 = subplot(4,1,4); plot(fSpike);set(ax2,'xlim',[0 100])
        pause(1)
        
    end
end
%% see as mean + error movie
fStim = nan(numTypes,numRepeats,300);
fSpike = nan(numTypes,numRepeats,300);
for type = 1:numTypes
    for rep = 1:numRepeats
        figure(1);
        stim = 0.5+0.5*cos(c.phases((c.repeats==rep)&(c.types==type)));
        spike = c.spikeCount((c.repeats==rep)&(c.types==type));
        fStim(type,rep,:) = abs(fft(stim));
        fSpike(type,rep,:) = abs(fft(spike));
    end
    fStimMean = squeeze(nanmean(fStim(type,:,:),2));
    fStimErr = squeeze(nanstd(fStim(type,:,:),[],2))/sqrt(numRepeats);
    fSpikeMean = squeeze(nanmean(fSpike(type,:,:),2));
    fSpikeErr = squeeze(nanstd(fSpike(type,:,:),[],2))/sqrt(numRepeats);
    ax1 = subplot(2,1,1);cla; hold on;
    plot(fStimMean);
    for i = 1:length(fStimErr)
        plot([i i],[fStimMean(i)-fStimErr(i) fStimMean(i)+fStimErr(i)],'k');
    end
    title(sprintf('t:%d; mean+-stderr',type,rep));
    ax2 = subplot(2,1,2);cla; hold on;
    set(ax2,'ylim',[0 100]);
    plot(fSpikeMean);
    for i = 1:length(fSpikeErr)
        plot([i i],[fSpikeMean(i)-fSpikeErr(i) fSpikeMean(i)+fSpikeErr(i)],'k');
    end
    linkaxes([ax1,ax2],'x');
    
    pause(1);
end

%% see as mean + error for all simultaneously
figure(1);
fStim = nan(numTypes,numRepeats,300);
fSpike = nan(numTypes,numRepeats,300);
axList = nan(10,1);
for type = 1:numTypes
    for rep = 1:numRepeats
        figure(1);
        stim = 0.5+0.5*cos(c.phases((c.repeats==rep)&(c.types==type)));
        spike = c.spikeCount((c.repeats==rep)&(c.types==type));
        fStim(type,rep,:) = abs(fft(stim));
        fSpike(type,rep,:) = abs(fft(spike));
    end
    fStimMean = squeeze(nanmean(fStim(type,:,:),2));
    fStimErr = squeeze(nanstd(fStim(type,:,:),[],2))/sqrt(numRepeats);
    fSpikeMean = squeeze(nanmean(fSpike(type,:,:),2));
    fSpikeErr = squeeze(nanstd(fSpike(type,:,:),[],2))/sqrt(numRepeats);
    ax1 = subplot(10,1,1);cla; hold on;
    plot(fStimMean); title('fStim')
    for i = 1:length(fStimErr)
        plot([i i],[fStimMean(i)-fStimErr(i) fStimMean(i)+fStimErr(i)],'k');
    end
    
    ax2 = subplot(10,1,type+1);cla; hold on;
    axList(type) = ax2;
    title(sprintf('t:%d',type));
    plot(fSpikeMean);
    for i = 1:length(fSpikeErr)
        plot([i i],[fSpikeMean(i)-fSpikeErr(i) fSpikeMean(i)+fSpikeErr(i)],'k');
    end
    set(ax2,'XTickLabel',[],'YLim',[0 100]);
    
%     pause(1);
end
axList(10) = ax1;
linkaxes(axList,'x');

%% using the fft estimate in chronux and plotting
temp = load(dataLoc);
physAnalysis = temp.physAnalysis;
c = physAnalysis{1}{1}.trode_1;

% using actual data analysis techniques
s.stimInfo.refreshRate = c.stimInfo.refreshRate; % the refreshrate
numRepeats = length(unique(c.repeats));
numTypes = length(unique(c.types));
sChronux.f0 = nan(numTypes);
sChronux.f1 = nan(numTypes);
sChronux.f2 = nan(numTypes);

spikes = nan(numTypes,numRepeats,300);
for type = 1:numTypes
    for rep = 1:numRepeats
        % recreate the stim
        stim = 0.5*cos(c.phases((c.repeats==rep)&(c.types==type)));
        spikes(type,rep,:) = c.spikeCount((c.repeats==rep)&(c.types==type));
    end
        params.tapers = [2 3];
        params.err = [2 0.05];
        params.Fs = c.stimInfo.refreshRate;
        [fStim freqStim]= mtspectrumc(stim,params);
        params.trialave = 1;
%         keyboard
        [fSpike freqSpike spRate fErrorSpike]= mtspectrumpb(squeeze(spikes(type,:,:))',params,1); %fscorr is 1
%         subplot(2,1,1);
%         plot(freqStim,fStim)
%         ax = subplot(2,1,2);
%         plot(freqSpike,fSpike);
%         set(ax,'ylim',[0,100])
%         pause(2);
        
        % set the values
        [junk f1Index] = min(abs(freqSpike-c.stimInfo.driftfrequencies));
        [junk f2Index] = min(abs(freqSpike-2*c.stimInfo.driftfrequencies));
        sChronux.f0(type) = spRate;
        sChronux.f1(type) = sqrt(fSpike(f1Index));
        sChronux.f2(type) = sqrt(fSpike(f2Index));
end
figure;
subplot(3,1,1),plot(sChronux.f0);title('f0.chronux')
subplot(3,1,2),plot(sChronux.f1);title('f1')
subplot(3,1,3),plot(sChronux.f2);title('f2')

%% using the fft estimate in chronux and plotting spectrum as a movie
temp = load(dataLoc);
physAnalysis = temp.physAnalysis;
c = physAnalysis{1}{1}.trode_1;

% using actual data analysis techniques
s.stimInfo.refreshRate = c.stimInfo.refreshRate; % the refreshrate
numRepeats = length(unique(c.repeats));
numTypes = length(unique(c.types));


spikes = nan(numTypes,numRepeats,300);
for type = 1:numTypes
    for rep = 1:numRepeats
        % recreate the stim
        stim = 0.5*cos(c.phases((c.repeats==rep)&(c.types==type)));
        spikes(type,rep,:) = c.spikeCount((c.repeats==rep)&(c.types==type));
    end
        params.tapers = [2 3];
        params.err = [2 0.05];
        params.Fs = c.stimInfo.refreshRate;
        [fStim freqStim]= mtspectrumc(stim,params);
        params.trialave = 1;
%         keyboard
        [fSpike freqSpike spRate fErrorSpike]= mtspectrumpb(squeeze(spikes(type,:,:))',params,1); %fscorr is 1
        subplot(2,1,1);
        plot(freqStim,fStim)
        ax = subplot(2,1,2);
        plot(freqSpike,fSpike);
        set(ax,'ylim',[0,100])
        pause(2);
        
%         % set the values
%         [junk f1Index] = min(abs(freqSpike-c.stimInfo.driftfrequencies));
%         [junk f2Index] = min(abs(freqSpike-2*c.stimInfo.driftfrequencies));
%         sChronux.f0(type) = spRate;
%         sChronux.f1(type) = fSpike(f1Index);
%         sChronux.f2(type) = fSpike(f2Index);
end
% figure;
% subplot(3,1,1),plot(sChronux.f0);title('f0.chronux')
% subplot(3,1,2),plot(sChronux.f1);title('f1')
% subplot(3,1,3),plot(sChronux.f2);title('f2')



%%  plot fft in three ways as a movie
dataLoc = 'C:\Documents and Settings\Owner\My Documents\Downloads\physAnalysis.mat';
temp = load(dataLoc);
physAnalysis = temp.physAnalysis;
c = physAnalysis{1}{1}.trode_1;

% using actual data analysis techniques
refreshRate = c.stimInfo.refreshRate;
s.stimInfo.refreshRate = c.stimInfo.refreshRate; % the refreshrate
numRepeats = length(unique(c.repeats));
numTypes = length(unique(c.types));

for rep = 1:numRepeats
    for type = 1:numTypes
        figure(1);
        stim = cos(c.phases((c.repeats==rep)&(c.types==type)));
        spike = c.spikeCount((c.repeats==rep)&(c.types==type));
        subplot(4,1,1); plot(stim);
        title(sprintf('t:%d,r:%d',type,rep));
        subplot(4,1,2); plot(spike);
        
        % direct fft
        fStimFFT = abs(fft(stim))/length(stim)*refreshRate;
        fSpikeFFT = abs(fft(spike))/length(spike)*refreshRate;
        
        %take away DC
        fStimFFTDC = fStimFFT(1); fStimFFT(1) = [];
        fSpikeFFTDC = fSpikeFFT(1); fSpikeFFT(1) = [];
        
        % remove the mirror image
        fStimFFT = fStimFFT(1:length(fStimFFT)/2);
        fSpikeFFT = fSpikeFFT(1:length(fSpikeFFT)/2);
        
        freqFFT = linspace(0,refreshRate/2,length(fStimFFT)+1);
        freqFFT(1) = [];
        
        % using chronux
        params.tapers = [2 3];
        params.err = [0 0.05];
        params.Fs = c.stimInfo.refreshRate;
        [fStimChr freqStimChr]= mtspectrumc(stim,params);
        params.trialave = 0;
        [fSpikeChr freqSpikeChr rChr]= mtspectrumpb(spike',params,1); %fscorr is 1
        
        % using pam's method
        [fStimPam freqStimPam] = spectofspike(stim,128,1/c.stimInfo.refreshRate,false);
        [fSpikePam freqSpikePam rPam] = spectofspike(spike,128,1/c.stimInfo.refreshRate,false);
        
        ax1 = subplot(4,1,3); cla; hold on;  plot(freqFFT,fStimFFT,'k'); plot(freqStimChr,sqrt(fStimChr),'r','LineWidth',2); plot(freqStimPam-min(freqStimPam),fStimPam,'b','LineWidth',2); set(ax1,'xlim',[0 20])
        ax2 = subplot(4,1,4); cla; hold on; plot(freqFFT,fSpikeFFT,'k'); plot(freqSpikeChr,sqrt(fSpikeChr),'r','LineWidth',2); plot(freqSpikePam-min(freqSpikePam),fSpikePam,'b','LineWidth',2); set(ax2,'xlim',[0 20])
        pause(1)
        
    end
end

%%  plot fft pam mentod only
dataLoc = 'C:\Documents and Settings\Owner\My Documents\Downloads\physAnalysis.mat';
temp = load(dataLoc);
physAnalysis = temp.physAnalysis;
c = physAnalysis{1}{1}.trode_1;

% using actual data analysis techniques
refreshRate = c.stimInfo.refreshRate;
s.stimInfo.refreshRate = c.stimInfo.refreshRate; % the refreshrate
numRepeats = length(unique(c.repeats));
numTypes = length(unique(c.types));

for rep = 1:numRepeats
    for type = 1:numTypes
%         figure(1);
        stim = cos(c.phases((c.repeats==rep)&(c.types==type)));
        spike = c.spikeCount((c.repeats==rep)&(c.types==type));
%         subplot(4,1,1); plot(stim);
%         title(sprintf('t:%d,r:%d',type,rep));
%         subplot(4,1,2); plot(spike);
        
        
%         [fStimPam freqStimPam] = spectofspike(stim,128,1/c.stimInfo.refreshRate,true);
        [fSpikePam freqSpikePam rPam] = spectofspike(spike,128,1/c.stimInfo.refreshRate,true);
        
%         ax1 = subplot(4,1,3); cla; hold on;  plot(freqStimPam-min(freqStimPam),fStimPam,'b','LineWidth',2); set(ax1,'xlim',[0 20])
%         ax2 = subplot(4,1,4); cla; hold on; plot(freqSpikePam-min(freqSpikePam),fSpikePam,'b','LineWidth',2); set(ax2,'xlim',[0 20])
        pause()
        
    end
end

%% repeating for each neuron individually
whichID = 1:db.numNeurons;
whichID = [9];
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
[aInd nID subAInd]=selectIndexTool(db,'sfGratings',params);
detailOnWNNew = ...
[1 1 1 1 0 0 0 1 1 inf 0 0 inf 0 0 0 0 1 0 inf 1 0 0 inf inf 1 1 inf 1 ...
1 1 1 1 1 0 0 0 1 inf inf 1 1 0 inf 1 0 inf 1 1 1 1 inf inf inf 0 0 1 0 ...
1 1 0 0 0];
detailOnWNOld = [0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0 0 0 0 inf];

detailLatencyNew = ...
[83 83 100 83 100 83 100 83 83 inf 100 83 inf 83 67 83 83 83 100 inf 83 83 83 inf inf 100 83 inf 83 83 83 83 83 83 83 ...
100 83 117 inf inf 67 83 83 inf 83 100 inf 100 83 83 100 inf inf 83 83 83 83 100 133 83 117 83 133] ;

detailLatencyOld = [50 50 67 50 50 33 33 183 83 54 82 45 92 inf 45 45 45 inf 83 inf];

for i = 1:length(nID)
    han = figure('units','normalized','outerposition',[0 0 1 1]);
    figName = sprintf('n%d_a%d.png',nID(i),subAInd(i));
    params.nID = nID(i);
    params.aInd = subAInd(i);
    params.ON = detailOnWNNew(params.nID);
%     params.ON = detailOnWNOld(params.nID);
    params.latency = detailLatencyNew(params.nID);
%     params.latency = detailLatencyOld(params.nID);
    db.data{nID(i)}.analyses{subAInd(i)}.plotPowerSpectra(han,params);
    saveLoc = 'C:\Documents and Settings\Owner\My Documents\Dropbox';
    plot2svg(fullfile(saveLoc,figName));
%     plot2svg(fullfile(saveLoc,figName),han);
%     pause(1)
    close(han);
    pause(1);
end

%% plot rasters

whichID = 1:db.numNeurons;
% whichID = [17 19 20 22 24 25 26 29 30 32 ];
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
[aInd nID subAInd]=selectIndexTool(db,'sfGratings',params);

for i = 1:length(nID)
    han = figure('units','normalized','outerposition',[0 0 1 1]);
    figName = sprintf('n%d_a%d_r.png',nID(i),subAInd(i));
    params.nID = nID(i);
    params.aInd = subAInd(i);
    
    rasterAx = axes('position',[0.05,0.05,0.45,0.9]);
    rasterParams.handle = rasterAx;
    db.data{nID(i)}.analyses{subAInd(i)}.plotRaster(rasterParams);
    
    isiAx = axes('position',[0.55,0.05,0.4,0.45]);
    isiParams.color = 'k';
    db.data{nID(i)}.analyses{subAInd(i)}.plotISI(isiAx,isiParams);
    
    spikeAx = axes('position',[0.55,0.55,0.4,0.4]);
    spikeParams.color = 'r';
    db.data{nID(i)}.analyses{subAInd(i)}.plotSpikes(spikeAx,spikeParams);
    
    saveLoc = 'C:\Documents and Settings\Owner\Desktop\validation';
    print(han,fullfile(saveLoc,figName),'-dpng','-r300');
%     plot2svg(fullfile(saveLoc,figName),han);
%     pause(1)
    close(han);
    pause(1);
end



%% test model data on autocorr calculation
clc;
f0s = -30:0;
spec = [];
for i = 1:length(f0s)
    f0 = f0s(i); f1 = 25; f2 = 0;noise = 0.1;
    w = 4;
    dt = 0.001; t = 0:dt:10;
    ft = f0+f1*sin(2*pi*w*t)+f2*sin(2*2*pi*w*t)+noise*f0*randn(size(t));
%     subplot(4,1,1);
%     plot(t,ft);
    spTrain = nan(size(t));
    spTrain = rand(size(t))<ft*dt;
%     subplot(4,1,2)
%     plot(t,spTrain)
%     sum(spTrain)/max(t);
    
%     ax1 = subplot(4,1,3);
    [specStim,fbinStim,DC] = spectofspike(ft,round(1/dt),dt,false);
%     plot(fbinStim-min(fbinStim),specStim);
%     set(gca,'xlim',[0 20]);
    
%     ax2 = subplot(4,1,4);
    [specSpike,fbinSpike,DC] = spectofspike(spTrain,round(1/dt),dt,false);
%     plot(fbinSpike-min(fbinSpike),specSpike);

% keyboard
%     set(gca,'xlim',[0 20]);
    spec = [spec;specSpike];
end
% linkaxes([ax1 ax2],'x')
which = fbinSpike>0 & fbinSpike<30;
mesh(f0s,fbinSpike(which),spec(:,which)')

%% plotting eta values
load('C:\SFFit\NewCellsSFFit_AC.mat')
nIDsCompletelyAccepted = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];

nIDsOnTheMargin = [7 11 12 19 22 26 27 29 34 35 36 37 38 41 42 51 56 58 61];

whichID = 1:db.numNeurons;
whichID = [1 3 4 5 6 7 9 12 14 16 17 19 22 26 29 30 31 32 37 43 45 46 48 49 51 56 57 58 ...
    63 11 23 27 33 34 35 36 38 41 42 44 47 61]; 
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;

allF1 = getFacts(db,{{'sfGratings',{{'f1','f1SEM'},'all'}},params});
nIDsInFit = allF1.nID;
subAIndInFit = allF1.subAInd;

whichOK = ismember(nIDsInFit,nIDsCompletelyAccepted);
etasOK = [];
analysisOK = [];
etasMarginal = [];
analysisMarginal = []; 
% fitOutput(1) : balanced
% fitOutput(2) : supra
% fitOutput(4) : sub
minQualDiff = 0.02;
nIDsFinished = [];
for i = 1:length(nIDsInFit)
    if ismember(nIDsInFit(i),nIDsCompletelyAccepted) && ~ismember(nIDsInFit(i),nIDsFinished)
        % get the etas for all the fits
        balQual = fitOutput(1).fit(i).chosenRF.quality;
        supraQual = fitOutput(2).fit(i).chosenRF.quality;
        subQual = fitOutput(4).fit(i).chosenRF.quality;
        
        [junk ind] = max([balQual supraQual -inf subQual]);
        if ind == 2
            % special case to make sure that the supra is actually better! 
            if supraQual-max([balQual subQual])>=minQualDiff
                %keep the ind
            else
                [junk ind] = max([balQual -inf -inf subQual]);
            end                
        end
        
        % now we are home...just find eta for that analysis
        ks = fitOutput(ind).fit(i).chosenRF.KS;
        kc = fitOutput(ind).fit(i).chosenRF.KC;
        rs = fitOutput(ind).fit(i).chosenRF.RS;
        rc = fitOutput(ind).fit(i).chosenRF.RC;
        
        etaAnalysis = (ks*rs*rs)/(kc*rc*rc);
        etasOK(end+1) = etaAnalysis;
        analysisOK(end+1) = i;
        nIDsFinished(end+1) = nIDsInFit(i);
    elseif ismember(nIDsInFit(i),nIDsOnTheMargin)&& ~ismember(nIDsInFit(i),nIDsFinished)
        % get the etas for all the fits
        balQual = fitOutput(1).fit(i).chosenRF.quality;
        supraQual = fitOutput(2).fit(i).chosenRF.quality;
        subQual = fitOutput(4).fit(i).chosenRF.quality;
        
        [junk ind] = max([balQual supraQual -inf subQual]);
        if ind == 2
            % special case to make sure that the supra is actually better! 
            if supraQual-max([balQual subQual])>=minQualDiff
                %keep the ind
            else
                [junk ind] = max([balQual -inf -inf subQual]);
            end                
        end
        
        % now we are home...just find eta for that analysis
        ks = fitOutput(ind).fit(i).chosenRF.KS;
        kc = fitOutput(ind).fit(i).chosenRF.KC;
        rs = fitOutput(ind).fit(i).chosenRF.RS;
        rc = fitOutput(ind).fit(i).chosenRF.RC;
        
        etaAnalysis = (ks*rs*rs)/(kc*rc*rc);
        etasMarginal(end+1) = etaAnalysis;
        analysisMarginal(end+1) = i;   
        nIDsFinished(end+1) = nIDsInFit(i);
    else
        % reject that analysis
    end
end
edges = linspace(-1.5,2,20);
histcOKs = histc(log10(etasOK),edges);
histcMarginals = histc(log10(etasMarginal),edges);
bar(edges,[histcOKs;histcMarginals]','stacked')
set(gca,'fontsize',25,'fontname','FontinSans');
set(gca,'xlim',[-2 2])
