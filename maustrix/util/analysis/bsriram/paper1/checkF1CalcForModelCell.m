%% this script aims to demonstarte the problem with fft calculations
%% things that shouldn't matter
% 1. length of signal
% 2. bin size(spikes/stim)


%% Does length of signal matter? NO
tMaxs = [1:100];
fighan = figure;
clear maxVals
for x = 1:length(tMaxs)
    tMaxs(x)
    % get the spike train
    dt = 0.001; % time step (1 ms)
    tMax = 3;
    t = 0:dt:tMaxs(x); % 3 seconds
    
    f0 = 40; % imp/s mean firing rate
    f1 = 40; % modulation of firing rate
    w = 4; % frequency
    firingRate = f0+f1*sin(2*pi*w*t);
    
    numRepeats = 10;
    spTrain = nan(numRepeats,length(t));
    
    % get spike train
    for i = 1:numRepeats
        for j = 1:length(t)
            spTrain(i,j) = double(rand<firingRate(j)*dt);
        end
    end
    
    % bin into stim frame intervals
    dtStim = 1/60;
    tStim = 0:dtStim:tMax;
    spTrainBinned = zeros(numRepeats,length(tStim));
    stim = f0+f1*sin(2*pi*w*tStim);
    
    % get spike train binned
    for i = 1:numRepeats
        for j = 1:length(tStim)-1
            whichTs = t>tStim(j) & t<tStim(j+1);
            spTrainBinned(i,j) = sum(spTrain(i,whichTs));
        end
    end
    
    % calculate powers autocorr
    f1AC = [];
    f0AC = [];
    maxlag = 128;
    for i = 1:numRepeats
        spike = squeeze(spTrainBinned(i,:));
        [fStimAC freqStimAC] = spectofspike(stim,maxlag,dtStim,'none',false);
        [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,maxlag,dtStim,'none',false);
        f1AC = [f1AC;fSpikeAC];
        f0AC = [f0AC;spRateAC];
    end
%     figure(fighan);

    meanF1AC = sqrt(mean(f1AC,1));
    sdF1AC = sqrt(std(f1AC,[],1));
    [maxVals(x) ind] = max(meanF1AC);
    sdMaxVal(x) = sdF1AC(ind);
%     plot(freqSpikeAC,sqrt(mean(f1AC,1)),'r','linewidth',3);
end
plot(tMaxs,maxVals,'k','linewidth',3); title('Does Signal Length Matter?'); hold on;
for i = 1:length(maxVals)
    plot([tMaxs(i) tMaxs(i)],[maxVals(i)-(sdMaxVal(i)/sqrt(10)) maxVals(i)+(sdMaxVal(i)/sqrt(10))],'k','linewidth',3);
end
xlabel('Signal length(s)');
ylabel('estimated power(imp/s)');
plot([tMaxs(1) tMaxs(end)],[40 40],'r','linewidth',3);
set(gca,'ylim',[0 50])
%% Does binning for spikes matter? NO
dts = logspace(-4,-2,100);
clear maxVals
for x = 1:length(dts)
    dt = dts(x); % time step (1 ms)
    tMax = 3;
    t = 0:dt:tMax; % 3 seconds
    
    f0 = 40; % imp/s mean firing rate
    f1 = 40; % modulation of firing rate
    w = 4; % frequency
    firingRate = f0+f1*sin(2*pi*w*t);
    
    numRepeats = 10;
    spTrain = nan(numRepeats,length(t));
    
    % get spike train
    for i = 1:numRepeats
        for j = 1:length(t)
            spTrain(i,j) = double(rand<firingRate(j)*dt);
        end
    end
    
    % bin into stim frame intervals
    dtStim = 1/60;
    tStim = 0:dtStim:tMax;
    spTrainBinned = zeros(numRepeats,length(tStim));
    stim = f0+f1*sin(2*pi*w*tStim);
    
    % get spike train binned
    for i = 1:numRepeats
        for j = 1:length(tStim)-1
            whichTs = t>tStim(j) & t<tStim(j+1);
            spTrainBinned(i,j) = sum(spTrain(i,whichTs));
        end
    end
    
    % calculate powers autocorr
    f1AC = [];
    f0AC = [];
    maxlag = 128;
    for i = 1:numRepeats
        spike = squeeze(spTrainBinned(i,:));
        [fStimAC freqStimAC] = spectofspike(stim,maxlag,dtStim,'none',false);
        [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,maxlag,dtStim,'none',false);
        f1AC = [f1AC;fSpikeAC];
        f0AC = [f0AC;spRateAC];
    end

    meanF1AC = sqrt(mean(f1AC,1));
    sdF1AC = sqrt(std(f1AC,[],1));
    [maxVals(x) ind] = max(meanF1AC);
    sdMaxVal(x) = sdF1AC(ind);

end

semilogx(dts,maxVals,'k','linewidth',3);title('Does Binning(Spikes) Matter?');hold on;
for i = 1:length(maxVals)
    plot([dts(i) dts(i)],[maxVals(i)-(sdMaxVal(i)/sqrt(1)) maxVals(i)+(sdMaxVal(i)/sqrt(1))],'k','linewidth',1);
end
xlabel('Signal length(s)');
ylabel('estimated power(imp/s)');
plot([dts(1) dts(end)],[40 40],'r','linewidth',3);
set(gca,'ylim',[0 50])

%% Does binning for stim matter? KINDA
dtStims = logspace(-2,-1,150);
clear maxVals
for x = 1:length(dtStims)
    dt = 0.001; % time step (1 ms)
    tMax = 3;
    t = 0:dt:tMax; % 3 seconds
    
    f0 = 40; % imp/s mean firing rate
    f1 = 40; % modulation of firing rate
    w = 4; % frequency
    firingRate = f0+f1*sin(2*pi*w*t);
    
    numRepeats = 10;
    spTrain = nan(numRepeats,length(t));
    
    % get spike train
    for i = 1:numRepeats
        for j = 1:length(t)
            spTrain(i,j) = double(rand<firingRate(j)*dt);
        end
    end
    
    %% bin into stim frame intervals
    dtStim = dtStims(x);
    tStim = 0:dtStim:tMax;
    spTrainBinned = zeros(numRepeats,length(tStim));
    stim = f0+f1*sin(2*pi*w*tStim);
    
    % get spike train binned
    for i = 1:numRepeats
        for j = 1:length(tStim)-1
            whichTs = t>tStim(j) & t<tStim(j+1);
            spTrainBinned(i,j) = sum(spTrain(i,whichTs));
        end
    end
    
    %% calculate powers autocorr
    f1AC = [];
    f0AC = [];
    maxlag = 128;
    for i = 1:numRepeats
        spike = squeeze(spTrainBinned(i,:));
        [fStimAC freqStimAC] = spectofspike(stim,maxlag,dtStim,'none',false);
        [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,maxlag,dtStim,'none',false);
        f1AC = [f1AC;fSpikeAC];
        f0AC = [f0AC;spRateAC];
    end
%     figure(fighan);

    meanF1AC = sqrt(mean(f1AC,1));
    sdF1AC = sqrt(std(f1AC,[],1));
    [maxVals(x) ind] = max(meanF1AC);
    sdMaxVal(x) = sdF1AC(ind);
end
semilogx(dtStims,maxVals,'k','linewidth',3);
title('Does Binning(Stim) Matter?','fontname','Bitstream Charter','fontsize',20);
hold on;
for i = 1:length(maxVals)
    plot([dtStims(i) dtStims(i)],[maxVals(i)-(sdMaxVal(i)/sqrt(1)) maxVals(i)+(sdMaxVal(i)/sqrt(1))],'k','linewidth',1);
end
for i = 1:length(maxVals)
    plot([dtStims(i) dtStims(i)],[maxVals(i)-(sdMaxVal(i)/sqrt(10)) maxVals(i)+(sdMaxVal(i)/sqrt(10))],'k','linewidth',3);
end
xlabel('bin length for stim(s)','fontname','Bitstream Charter','fontsize',20);
ylabel('estimated power(imp/s)','fontname','Bitstream Charter','fontsize',20);
plot([dtStims(1) dtStims(end)],[40 40],'r','linewidth',3);
set(gca,'ylim',[0 50])

%% Does it scale linearly with f1? KINDA
f1s = [0:300];
clear maxVals
for x = 1:length(f1s)
    dt = 0.001; % time step (1 ms)
    tMax = 5; % (s)
    t = 0:dt:tMax; % 3 seconds
    
    f0 = 50; % imp/s mean firing rate
    f1 = f1s(x); % modulation of firing rate
    w = 4; % frequency
    firingRate = f0+f1*sin(2*pi*w*t);
    
    numRepeats = 6;
    spTrain = nan(numRepeats,length(t));
    
    % get spike train
    for i = 1:numRepeats
        for j = 1:length(t)
            spTrain(i,j) = double(rand<firingRate(j)*dt);
        end
    end
    
    %% bin into stim frame intervals
    dtStim = 1/60;
    tStim = 0:dtStim:tMax;
    spTrainBinned = zeros(numRepeats,length(tStim));
    stim = f0+f1*sin(2*pi*w*tStim);
    
    % get spike train binned
    for i = 1:numRepeats
        for j = 1:length(tStim)-1
            whichTs = t>tStim(j) & t<tStim(j+1);
            spTrainBinned(i,j) = sum(spTrain(i,whichTs));
        end
    end
    
    %% calculate powers autocorr
    f1AC = [];
    f0AC = [];
    maxlag = 128;
    for i = 1:numRepeats
        spike = squeeze(spTrainBinned(i,:));
        [fStimAC freqStimAC] = spectofspike(stim,maxlag,dtStim,'none',false);
        [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,maxlag,dtStim,'none',false);
        f1AC = [f1AC;fSpikeAC];
        f0AC = [f0AC;spRateAC];
    end
%     figure(fighan);

    meanF1AC = mean(sqrt(f1AC),1);
    sdF1AC = std(sqrt(f1AC),[],1);
    [maxValsAC(x) ind] = max(meanF1AC);
    sdValsAC(x) = sdF1AC(ind);
%     plot(freqSpikeAC,sqrt(mean(f1AC,1)),'r','linewidth',3);
%     pause(0.1)
end
fighan=figure;
axhan  = axes;
plot(f1s,maxValsAC,'b'); hold on;
for i = 1:length(maxValsAC)
    plot([f1s(i) f1s(i)],[maxValsAC(i)-sdValsAC(i) maxValsAC(i)+sdValsAC(i)],'b');
end
    xlabel('actual F1');ylabel('measured F1');title('How does it scale?');
hold on;
plot(f1s,f1s,'k'); axis square

%% what abt fft?
f1s = [0:300];
clear maxValsAC
for x = 1:length(f1s)
    dt = 0.001; % time step (1 ms)
    tMax = 5; % (s)
    t = 0:dt:tMax; % 3 seconds
    
    f0 = 50; % imp/s mean firing rate
    f1 = f1s(x); % modulation of firing rate
    w = 4; % frequency
    firingRate = f0+f1*sin(2*pi*w*t);
    
    numRepeats = 6;
    spTrain = nan(numRepeats,length(t));
    
    % get spike train
    for i = 1:numRepeats
        for j = 1:length(t)
            spTrain(i,j) = double(rand<firingRate(j)*dt);
        end
    end
    
    %% bin into stim frame intervals
    dtStim = 1/60;
    tStim = 0:dtStim:tMax;
    spTrainBinned = zeros(numRepeats,length(tStim));
    stim = f0+f1*sin(2*pi*w*tStim);
    
    % get spike train binned
    for i = 1:numRepeats
        for j = 1:length(tStim)-1
            whichTs = t>tStim(j) & t<tStim(j+1);
            spTrainBinned(i,j) = sum(spTrain(i,whichTs));
        end
    end
%     keyboard
    %% calculate powers autocorr
    f1FFT = [];
    f0FFT = [];
    maxlag = 128;
    for i = 1:numRepeats
        spike = squeeze(spTrainBinned(i,:));
        fStim = fft(stim);
        fSpike = fft(spike);
        spRateFFT = fSpike(1)/length(stim)*(1/dtStim);
        fStim=abs(fStim(2:floor(length(fStim)/2)));
        fSpike=2*abs(fSpike(2:floor(length(fSpike)/2)))/length(stim)*(1/dtStim);
        
        f1FFT = [f1FFT;fSpike];
        f0FFT = [f0FFT;spRateFFT];
    end
%     figure(fighan);

    meanF1FFT = (mean(f1FFT,1));
    sdF1FFT = std(f1FFT,[],1);
    [maxValsFFT(x) ind] = max(meanF1FFT);    
    sdValsFFT(x) = sdF1FFT(ind);
    
    
%     plot(freqSpikeAC,sqrt(mean(f1AC,1)),'r','linewidth',3);
%     pause(0.1)
end
axes(axhan);
plot(f1s,maxValsFFT,'r');

for i = 1:length(maxValsFFT)
    plot([f1s(i)+.1 f1s(i)+.1],[maxValsFFT(i)-sdValsFFT(i) maxValsFFT(i)+sdValsFFT(i)],'r');
end


%% Is it independent of Lag?
clear maxValsAC maxValsFFT maxVals
for x = 1:length(f1s)
    dt = 0.001; % time step (1 ms)
    tMax = 5; % (s)
    t = 0:dt:tMax; % 3 seconds
    
    f0 = 50; % imp/s mean firing rate
    f1 = f1s(x); % modulation of firing rate
    w = 4; % frequency
    firingRate = f0+f1*sin(2*pi*w*t);
    
    numRepeats = 6;
    spTrain = nan(numRepeats,length(t));
    
    % get spike train
    for i = 1:numRepeats
        for j = 1:length(t)
            spTrain(i,j) = double(rand<firingRate(j)*dt);
        end
    end
    
    %% bin into stim frame intervals
    dtStim = 1/60;
    tStim = 0:dtStim:tMax;
    spTrainBinned = zeros(numRepeats,length(tStim));
    stim = f0+f1*sin(2*pi*w*tStim);
    
    % get spike train binned
    for i = 1:numRepeats
        for j = 1:length(tStim)-1
            whichTs = t>tStim(j) & t<tStim(j+1);
            spTrainBinned(i,j) = sum(spTrain(i,whichTs));
        end
    end
    
    %% calculate powers autocorr
    f1AC = [];
    f0AC = [];
    maxlag = 180;
    for i = 1:numRepeats
        spike = squeeze(spTrainBinned(i,:));
        [fStimAC freqStimAC] = spectofspike(stim,maxlag,dtStim,'none',false);
        [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,maxlag,dtStim,'none',false);
        f1AC = [f1AC;fSpikeAC];
        f0AC = [f0AC;spRateAC];
    end
%     figure(fighan);

    meanF1AC = mean(sqrt(f1AC),1);
    sdF1AC = std(sqrt(f1AC),[],1);
    [maxValsAC(x) ind] = max(meanF1AC);
    sdValsAC(x) = sdF1AC(ind);
%     plot(freqSpikeAC,sqrt(mean(f1AC,1)),'r','linewidth',3);
%     pause(0.1)
end
fighan=figure;
axhan  = axes;
plot(f1s,maxValsAC,'r'); hold on;
for i = 1:length(maxValsAC)
    plot([f1s(i) f1s(i)],[maxValsAC(i)-sdValsAC(i) maxValsAC(i)+sdValsAC(i)],'r');
end
    xlabel('actual F1');ylabel('measured F1');title('How does it scale?');
hold on;
plot(f1s,f1s,'k'); axis square

%% Does it scale linearly with f1? KINDA
f1s = [0:100];
clear maxValsAC
f = figure; axhan = axes;
for x = 1:length(f1s)
    dt = 0.001; % time step (1 ms)
    tMax = 5; % (s)
    t = 0:dt:tMax; % 3 seconds
    
    f0 = 50; % imp/s mean firing rate
    f1 = f1s(x); % modulation of firing rate
    w = 4; % frequency
    firingRate = f0+f1*sin(2*pi*w*t);
    
    numRepeats = 6;
    spTrain = nan(numRepeats,length(t));
    
    % get spike train
    for i = 1:numRepeats
        for j = 1:length(t)
            spTrain(i,j) = double(rand<firingRate(j)*dt);
        end
    end
    
    %% bin into stim frame intervals
    dtStim = 1/60;
    tStim = 0:dtStim:tMax;
    spTrainBinned = zeros(numRepeats,length(tStim));
    stim = f0+f1*sin(2*pi*w*tStim);
    
    % get spike train binned
    for i = 1:numRepeats
        for j = 1:length(tStim)-1
            whichTs = t>tStim(j) & t<tStim(j+1);
            spTrainBinned(i,j) = sum(spTrain(i,whichTs));
        end
    end
    
    %% calculate powers autocorr
    f1AC = [];
    f0AC = [];
    maxlag = 150;
    for i = 1:numRepeats
        spike = squeeze(spTrainBinned(i,:));
        [fStimAC freqStimAC] = spectofspike(stim,maxlag,dtStim,'none',false);
        [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,maxlag,dtStim,'none',false);
        f1AC = [f1AC;fSpikeAC];
        f0AC = [f0AC;spRateAC];
    end
%     figure(fighan);

    meanF1AC = mean(sqrt(f1AC),1);
    sdF1AC = std(sqrt(f1AC),[],1);
    [maxValsAC(x) ind] = max(meanF1AC);
    sdValsAC(x) = sdF1AC(ind);
%     plot(freqSpikeAC,sqrt(mean(f1AC,1)),'r','linewidth',3);
%     pause(0.1)
end
axes(axhan);
plot(f1s,maxValsAC,'g'); hold on;
for i = 1:length(maxValsAC)
    plot([f1s(i) f1s(i)],[maxValsAC(i)-sdValsAC(i) maxValsAC(i)+sdValsAC(i)],'g');
end


%% Does it scale linearly with f1? KINDA
f1s = [0:100];
clear maxValsFFT
for x = 1:length(f1s)
    dt = 0.001; % time step (1 ms)
    tMax = 5; % (s)
    t = 0:dt:tMax; % 3 seconds
    
    f0 = 50; % imp/s mean firing rate
    f1 = f1s(x); % modulation of firing rate
    w = 4; % frequency
    firingRate = f0+f1*sin(2*pi*w*t);
    
    numRepeats = 6;
    spTrain = nan(numRepeats,length(t));
    
    % get spike train
    for i = 1:numRepeats
        for j = 1:length(t)
            spTrain(i,j) = double(rand<firingRate(j)*dt);
        end
    end
    
    %% bin into stim frame intervals
    dtStim = 1/60;
    tStim = 0:dtStim:tMax;
    spTrainBinned = zeros(numRepeats,length(tStim));
    stim = f0+f1*sin(2*pi*w*tStim);
    
    % get spike train binned
    for i = 1:numRepeats
        for j = 1:length(tStim)-1
            whichTs = t>tStim(j) & t<tStim(j+1);
            spTrainBinned(i,j) = sum(spTrain(i,whichTs));
        end
    end
    
    %% calculate powers autocorr
    f1AC = [];
    f0AC = [];
    maxlag = 120;
    for i = 1:numRepeats
        spike = squeeze(spTrainBinned(i,:));
        [fStimAC freqStimAC] = spectofspike(stim,maxlag,dtStim,'none',false);
        [fSpikeAC freqSpikeAC spRateAC] = spectofspike(spike,maxlag,dtStim,'none',false);
        f1AC = [f1AC;fSpikeAC];
        f0AC = [f0AC;spRateAC];
    end
%     figure(fighan);

    meanF1AC = mean(sqrt(f1AC),1);
    sdF1AC = std(sqrt(f1AC),[],1);
    [maxValsAC(x) ind] = max(meanF1AC);
    sdValsAC(x) = sdF1AC(ind);
%     plot(freqSpikeAC,sqrt(mean(f1AC,1)),'r','linewidth',3);
%     pause(0.1)
end
axes(axhan);
plot(f1s,maxValsAC,'b'); hold on;
for i = 1:length(maxValsAC)
    plot([f1s(i) f1s(i)],[maxValsAC(i)-sdValsAC(i) maxValsAC(i)+sdValsAC(i)],'b');
end
xlabel('actual F1','fontname','Bitstream Charter','fontsize',20);
ylabel('measured F1','fontname','Bitstream Charter','fontsize',20);
title('How does it scale?','fontname','Bitstream Charter','fontsize',20);
plot([f1s(1),f1s(end)],[50 50],'k','linewidth',3);

plot(f1s,f1s,'color',[0.4 0.4 0.4],'linewidth',3); axis square
%% calculate powers fft
% f1FFT = [];
% f0FFT = [];
% for i = 1:numRepeats
%     spike = squeeze(spTrainBinned(i,:));
%     fStim = fft(stim);
%     fSpike = fft(spike);
%     spRateFFT = fSpike(1)/length(stim)*(1/dtStim);
%     fStim=abs(fStim(2:floor(length(fStim)/2)));
%     fSpike=2*abs(fSpike(2:floor(length(fSpike)/2)))/length(stim)*(1/dtStim);
%
%     f1FFT = [f1FFT;fSpike];
%     f0FFT = [f0FFT;spRateFFT];
% end
% ax = subplot(3,1,3); hold on;
% freqs = linspace(0,1/(2*dtStim),size(f1FFT,2)+1);
% freqs(1) = [];
% for i = 1:numRepeats
%     plot(freqs,(f1FFT(i,:)),'b','linewidth',0.5);
% end
%
% plot(freqs,(mean(f1FFT,1)),'k','linewidth',3);
% plot(w,mean(f0FFT),'kd','markerSize',10);
%
% title('amplitudes using fft');ylabel('amplitude(imp/s)');xlabel('Frequency(Hz)');
% set(gca,'FontSize',15);

%
% saveLoc = '/media/USB DISK/JoV';
% filename = 'f0-40-f1-40.tiff';
% print(fullfile(saveLoc,filename),'-dtiff','-r300');


%% plot the stim
%     figure;  ax = subplot(3,1,1); hold on;
%     plot(tStim,stim,'r','linewidth',1);
%     titleStr = sprintf('instantaneous firing rate. f0=%d, f1=%d',f0,f1);
%     title(titleStr); xlabel('time(s)');ylabel('firing rate(imp/s)');
%     set(gca,'FontSize',15);

%% 
stim.m = 0.5;stim.c = 1; stim.FS = logspace(-2,-0.75,100);
rf.thetaMin= -40;rf.dTheta = 0.01;rf.thetaMax = 40;
rf.KS = 0.1;rf.KC = 2;rf.RC = 2;rf.RS = 10;
out1 = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
out2 = rfModel(rf,stim,'1D-DOG-useSensitivity');
% semilogx(stim.FS,squeeze(out1.f1));
% hold on;semilogx(stim.FS,2*squeeze(out2.f1),'r');
hold on;semilogx(stim.FS,squeeze(out1.f1)./(squeeze(out2.f1)),'r');