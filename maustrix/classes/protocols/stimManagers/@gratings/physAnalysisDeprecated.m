function [analysisdata cumulativedata] = physAnalysisDeprecated(stimManager,spikeRecord,stimulusDetails,plotParameters,parameters,cumulativedata,eyeData,LFPRecord)
% stimManager is the stimulus manager
% spikes is an index into neural data samples of the time of a spike
% correctedFrameIndices is an nx2 array of frame start and stop indices - [start stop], n = number of frames
% stimulusDetails are the stimDetails from calcStim (hopefully they contain
% all the information needed to reconstruct stimData)
% plotParameters - currently not used
analysisdata = [];
if 1
    [analysisdata cumulativedata] = physAnalysisDev(stimManager,spikeRecord,stimulusDetails,plotParameters,parameters,cumulativedata,eyeData,LFPRecord);
    return
end
% what to do about the LFP??
if ~exist('LFPRecord','var')||~isfield(LFPRecord,'data')||isempty(LFPRecord.data)
    LFPRecord = [];
    doLFPAnalysis = false;
else
    doLFPAnalysis = true;
end

%CHOOSE CLUSTER
spikes=spikeRecord.spikes; %all waveforms
% old way. not supported
% if isstruct(spikeRecord.spikeDetails) && ismember({'processedClusters'},fields(spikeRecord.spikeDetails))
%     processedClusters=[];
%     for i=1:length(spikeRecord.spikeDetails)
%         processedClusters=[processedClusters spikeRecord.spikeDetails(i).processedClusters];  %this is not a cumulative analysis so by default analyze all chunks available
%     end
%     thisCluster=processedClusters==1;
% else
%     thisCluster=logical(ones(size(spikes)));
%     %use all (photodiode uses this)
% end
thisCluster = spikeRecord.processedClusters;
spikes(~thisCluster)=[]; % remove spikes that dont belong to thisCluster
analysisdata.spikeWaveforms = spikeRecord.spikeWaveforms(logical(thisCluster),:);
analysisdata.spikes = spikes;
analysisdata.spikeTimestamps = spikeRecord.spikeTimestamps(logical(thisCluster));
analysisdata.ISIviolationMS = parameters.ISIviolationMS;

%SET UP RELATION stimInd <--> frameInd
numStimFrames=max(spikeRecord.stimInds);
analyzeDrops=true;
if analyzeDrops
    stimFrames=spikeRecord.stimInds;
    correctedFrameIndices=spikeRecord.correctedFrameIndices;
else
    stimFrames=1:numStimFrames;
    firstFramePerStimInd=~[0 diff(spikeRecord.stimInds)==0];
    correctedFrameIndices=spikeRecord.correctedFrameIndices(firstFramePerStimInd);
end

% get the stimulusCombo
if stimulusDetails.doCombos==1
    comboMatrix = generateFactorialCombo({stimulusDetails.spatialFrequencies,stimulusDetails.driftfrequencies,stimulusDetails.orientations,...
        stimulusDetails.contrasts,stimulusDetails.phases,stimulusDetails.durations,stimulusDetails.radii,stimulusDetails.annuli});
    pixPerCycs=comboMatrix(1,:);
    driftfrequencies=comboMatrix(2,:);
    orientations=comboMatrix(3,:);
    contrasts=comboMatrix(4,:); %starting phases in radians
    startPhases=comboMatrix(5,:);
    durations=round(comboMatrix(6,:)*parameters.refreshRate); % CONVERTED FROM seconds to frames
    radii=comboMatrix(7,:);
    annuli=comboMatrix(8,:);
    
    repeat=ceil(stimFrames/sum(durations));
    numRepeats=ceil(numStimFrames/sum(durations));
    chunkEndFrame=[cumsum(repmat(durations,1,numRepeats))];
    chunkStartFrame=[0 chunkEndFrame(1:end-1)]+1;
    %chunkStartFrame(chunkStartFrame>numStimFrames)=[]; %remove chunks that were never reached. OK TO LEAVE IF WE INDEX BY OTHER THINGS
    %chunkEndFrame(chunkStartFrame>numStimFrames)=[]; %remove chunks that were never reached.
    numChunks=length(chunkStartFrame);
    numTypes=length(durations);
    % analysisdata will contain all this info
    fieldsToInclude = {'pixPerCycs','driftfrequencies','orientations','contrasts','startPhases',...
        'durations','radii','annuli','repeat','numRepeats','chunkEndFrame','chunkStartFrame',...
        'numChunks','numTypes'};
    analysisdata.pixPerCycs = pixPerCycs;
    analysisdata.driftfrequencies = driftfrequencies;
    analysisdata.orientations = orientations;
    analysisdata.contrasts = contrasts;
    analysisdata.startPhases = startPhases;
    analysisdata.durations = durations;
    analysisdata.radii = radii;
    analysisdata.annuli = annuli;
    analysisdata.repeat = repeat;
    analysisdata.numRepeats = numRepeats;
    analysisdata.chunkEndFrame = chunkEndFrame;
    analysisdata.chunkStartFrame = chunkStartFrame;
    analysisdata.numChunks = numChunks;
    analysisdata.numTypes = numTypes;
else
    error('analysis not handled yet for this case')
end

%
% if numStimFrames<max(chunkEndFrame)
%     analysisdata=[];
%     cumulativedata=[];
%     warning('skipping analysis of gratings untill all the chunks are there')
%     return; % don't analyze partial data
% end

% find out what parameter is varying
numValsPerParam=...
    [length(unique(pixPerCycs)) length(unique(driftfrequencies))  length(unique(orientations))  length(unique(contrasts)) length(unique(startPhases)) length(unique(durations))  length(unique(radii))  length(unique(annuli))];
if sum(numValsPerParam>1)==1
    names={'pixPerCycs','driftfrequencies','orientations','contrasts','startPhases','durations','radii','annuli'};
    sweptParameter=names(find(numValsPerParam>1));
else
    error('analysis only for one value at a time now')
    return % to skip
end
% make sure analysisdata knows what is being swept
analysisdata.sweptParameter = sweptParameter;
vals = eval(char(sweptParameter));
% determine the type of stim on each frame
if length(unique(durations))==1
    duration=unique(durations);
    type=repmat([1:numTypes],duration,numRepeats);
    type=type(stimFrames); % vectorize matrix and remove extras
else
    error('multiple durations can''t rely on mod to determine the frame type')
end

%empirically is the old way
%samplingRate=round(diff(minmax(spikes'))/ diff(spikeRecord.spikeTimestamps([1 end])));
samplingRate=parameters.samplingRate;
analysisdata.samplingRate = samplingRate;

% calc phase per frame, just like dynamic
x = 2*pi./pixPerCycs(type); % adjust phase for spatial frequency, using pixel=1 which is likely always offscreen, given roation and oversizeness
cycsPerFrameVel = driftfrequencies(type)*1/(parameters.refreshRate); % in units of cycles/frame
offset = 2*pi*cycsPerFrameVel.*stimFrames';
risingPhases=x + offset+startPhases(type);
phases=mod(risingPhases,2*pi);

% count the number of spikes per frame
% spikeCount is a 1xn vector of (number of spikes per frame), where n = number of frames
spikeCount=zeros(1,size(correctedFrameIndices,1));
for i=1:length(spikeCount) % for each frame
    spikeCount(i)=length(find(spikes>=correctedFrameIndices(i,1)&spikes<=correctedFrameIndices(i,2))); % inclusive?  policy: include start & stop
end
analysisdata.spikeCount = spikeCount;

%% maybe everything from here on out should be calculated for cumulative
%% data???
% probablity of a spike per phase
numPhaseBins=8;
analysisdata.numPhaseBins = numPhaseBins;
edges=linspace(0,2*pi,numPhaseBins+1);
events=zeros(numRepeats,numTypes,numPhaseBins);
possibleEvents=events;
phaseDensity=zeros(numRepeats*numTypes,numPhaseBins);
pow=nan(numRepeats,numTypes);
for i=1:numRepeats
    for j=1:numTypes
        chunk=(i-1)*numTypes+j;
        sf=min(find(stimFrames==chunkStartFrame(chunk)));
        ef=max(find(stimFrames==chunkEndFrame(chunk)));
        
        whichType=find(type==j & repeat==i);
        if length(whichType)>5  % need some spikes, 2 would work mathematically ??is this maybe spikeCount(whichType)
            
            
            [n phaseID]=histc(phases(whichType),edges);
            for k=1:numPhaseBins
                whichPhase=find(phaseID==k);
                events(i,j,k)=sum(spikeCount(whichType(whichPhase)));
                possibleEvents(i,j,k)=length(whichPhase);
                
                %in last repeat density = 0, for parsing and avoiding misleading half data
                if 1 %numRepeats~=i
                    y=(j-1)*(numRepeats)+i;
                    phaseDensity(y,k)=events(i,j,k)/possibleEvents(i,j,k);
                end
            end
            
            % find the power in the spikes at the freq of the grating
            fy=fft(.5+cos(phases(whichType))/2); %fourier of stim
            fx=fft(spikeCount(whichType)); % fourier of spikes
            fy=abs(fy(2:floor(length(fy)/2))); % get rid of DC and symetry
            fx=abs(fx(2:floor(length(fx)/2)));
            peakFreqInd=find(fy==max(fy)); % find the right freq index using stim
            pow(i,j)=fx(peakFreqInd); % determine the power at that freq
            
            
            warning('had to turn coherency off... there is possibly a formating error b/c stimFrames is a sawtooth which we could fix here, but ought to be fixed at the concatenation point')
            if ~isempty(ef) % turn off until matrices are the right size
                chrParam.tapers=[3 5]; % same as default, but turns off warning
                chrParam.err=[2 0.05];  % use 2 for jacknife
                fscorr=true;
                % should check chronux's chrParam,trialave=1 to see how to
                % handle CI's better.. will need to do all repeats at once
                [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=coherencycpb(cos(phases(whichType)'),spikeCount(sf:ef)',chrParam,fscorr);
            end
            
            if ~isempty(ef) && ~zerosp
                peakFreqInds=find(S1>max(S1)*.95); % a couple bins near the peak of
                [junk maxFreqInd]=max(S1);
                coh(i,j)=mean(C(peakFreqInds));
                cohLB(i,j)=Cerr(1,maxFreqInd);
            else
                coh(i,j)=nan;
                cohLB(i,j)=nan;
            end
            
            if 0 && j==3  && ~isempty(ef) % 1; %chunk==6 %chronuxDev
                
                
                %get the spikes times as a pt process
                sf=min(find(stimFrames==chunkStartFrame(chunk)));
                ef=max(find(stimFrames==chunkEndFrame(chunk)));
                
                ss=correctedFrameIndices(sf,1); % start samp
                es=correctedFrameIndices(ef,2); % end samp
                whichSpikes=spikes>=ss & spikes<=es;
                
                %durE=durations(j)/parameters.refreshRate; %expected if not frame drops
                %samplingRate/driftfrequencies(j)
                %dur=(es-ss)/samplingRate; % actual w/ frame drops
                
                cycs=driftfrequencies(j)*durations(j)/parameters.refreshRate;
                eFreq=1/cycs; % in normalized units
                
                %fRange=(1./(cycs*[2 1/2]));
                
                
                
                %chrParam.tapers=[dur/3 dur 1];  %width, dur,
                %chrParam.pad=[0];
                %chrParam.Fs=[1];
                %chrParam.fpass=fRange;
                %chrParam.err=[2 0.05];  % use 2 for jacknife
                
                
                
                
                chrParam.tapers=[3 5];
                chrParam.pad=[0];
                chrParam.Fs=[1];
                chrParam.fpass=[0 .5];
                chrParam.err=[2 0.05];  % use 2 for jacknife
                
                chrParam.fpass=[0.0 0.08] % these values are not dynamic to stim type... just for viewing
                fscorr=true;   % maybe should be true so that the finit size correction for spikes is used
                [C3,phi3,S13,S1,S3,f,zerosp,confC3,phistd3,Cerr3]=coherencycpb(cos(phases(whichType)'),spikeCount(sf:ef)',chrParam,fscorr);
                [junk maxFreqIndFewTapers]=max(S1);
                
                figure
                t1s=[3 5]% [1 3 5 20];
                t2s=[5 9]% [ 5 10 20]
                for ii=1:length(t1s)
                    for jj=1:length(t2s)
                        chrParam.tapers=[t1s(ii) t2s(jj)];
                        [C3,phi3,S13,S1,S3,f,zerosp,confC3,phistd3,Cerr3]=coherencycpb(cos(phases(whichType)'),spikeCount(sf:ef)',chrParam,fscorr);
                        
                        [junk expectedFreqInd]=min(abs(eFreq-f));
                        [junk maxFreqInd]=max(S1);
                        peakFreqInds=find(S1>max(S1)*.95);
                        
                        subplot(length(t2s),length(t1s),(ii-1)*length(t1s)+jj)
                        hold off
                        fill([f, fliplr(f)],[Cerr3(1,:), fliplr(Cerr3(2,:))],'m','faceAlpha',0.2,'edgeAlpha',0);
                        hold on;
                        plot(f,S1/max(S1),'k');
                        plot(f,S3/max(S3),'b');
                        plot(f,C3/max(C3),'r');
                        
                        %plot(f(expectedFreqInd),0,'r*')
                        plot(f(maxFreqInd),0,'b*')
                        plot(f(peakFreqInds),0.1,'b.')
                        plot(f(maxFreqIndFewTapers),0.1,'g*')
                    end
                    
                end
                
                if 0 % compare pt process estimates, which seem noiser
                    pt.times=[spikeRecord.spikeTimestamps(whichSpikes)];  % are times in the right format?  seconds in a range
                    t=[]; % should calc the time grid for the start and stop of the trial.
                    fscorr=true;   % maybe should be true so that the finit size correction for spikes is used
                    if chrParam.err(1)==2
                        [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=coherencycpt(cos(phases(whichType)'),pt,chrParam,fscorr,t);
                        [C3,phi3,S13,S1,S3,f,zerosp,confC3,phistd3,Cerr3]=coherencycpb(cos(phases(whichType)'),spikeCount(sf:ef)',chrParam,fscorr);
                    else
                        [C,phi,S12,S1,S2,f,zerosp]=coherencycpt(cos(phases(whichType)'),pt,chrParam,fscorr,t);
                        [C3,phi3,S13,S1,S3,f,zerosp]=coherencycpb(cos(phases(whichType)'),spikeCount(sf:ef)',chrParam,fscorr);
                    end
                    
                    
                    figure
                    plot(f,S1/max(S1),'k');             hold on;
                    plot(f,S2/max(S2),'b');
                    fill([f, fliplr(f)],[Cerr(1,:), fliplr(Cerr(2,:))],'c','faceAlpha',0.2,'edgeAlpha',0);
                    plot(f,S3/max(S3),'r');
                    fill([f, fliplr(f)],[Cerr3(1,:), fliplr(Cerr3(2,:))],'m','faceAlpha',0.2,'edgeAlpha',0);
                    plot(f(expectedFreqInd),0,'r*')
                    
                end
                
                
                
            end
            
            if 0 %development
                
                [b,a] = butter(1,.1);
                x=spikeCount(whichType);
                y=.5+cos(phases(whichType))/2;
                
                %could smooth spikes, but we only care about an accurate power
                %estimate of a fixed freq, don't care about the presence of
                %higher freqs in the data
                xx=filtfilt(b,a,x);
                xxx=conv2(x,fspecial('gauss',[1 20],2),'same'); % similar to bw filter
                figure; plot(y,'k'); hold on; plot(x/3,'g');  plot(xx,'r'); plot(xxx,'b');
                
                fy=fft(y);  fx=fft(x);
                fy=abs(fy(2:length(fy)/2));
                fx=abs(fx(2:length(fx)/2));
                peakFreqInd=find(fy==max(fy));
                pow=fx(peakFreqInd); % thi is what we use
                figure; plot(fy); hold on; plot(fx,'r')
            end
            
            if 0 % fancier spectral ideas not used
                Fs=parameters.refreshRate;
                
                %Hs = spectrum.music(2);  % supported setup
                %[POW,F]=powerest(Hs,y,Fs)%,) strange error
                [freq,pow] = rootmusic(y,2,Fs); % this works
                %pmusic(x,2) % see the est
                
                h = spectrum.welch;                  % Create a Welch spectral estimator.
                Xpsd = psd(h,x,'Fs',Fs);             % Calculate the PSD
                Ypsd = psd(h,y,'Fs',Fs);             % Calculate the PSD
                %peakFreqInd=find(Ypsd.data==max(Ypsd.data));  % might not be as reliable
                
                f_diff=abs(Ypsd.Frequencies-freq(1));
                peakFreqInd=find(f_diff==min(f_diff)); % index nearest music freq est
                f=Ypsd.Frequencies(peakFreqInd);
                pow=Ypsd.data(peakFreqInd);
                
                plot(Xpsd)
            end
        end
    end
end
analysisdata.phaseDensity = phaseDensity;


if 0
    %% radon transform
    %doRadonTransform
    figure(parameters.trialNumber+10); % new for each trial
    [spikingPhasePerType{1:numTypes}]=deal([]);  % 0 to 2 pi
    %[spikingRisingPhasesPerType{1:numTypes}]=deal([]); % 0 and upward, no modulus
    colors=jet(numTypes);
    numPhaseBins=360;
    edges=linspace(0,2*pi,numPhaseBins+1);
    w=floor(sqrt(numTypes));
    h=ceil(numTypes/w);
    for j=1:numTypes
        spikeIDPerType{j}=find(type==j & spikeCount'==1);
        spikingPhasePerType{j}=phases(spikeIDPerType{j});
        %spikingRisingPhasesPerType{j}=risingPhases(spikeIDPerType{j});
        nm=length(spikingPhasePerType{j});
        [n phaseIDnotUsed]=histc(spikingPhasePerType{j},edges);
        n=n(1:end-1); %remove last bin
        boxCarDegrees=30;
        boxcar=ones(1,floor(boxCarDegrees*360/numPhaseBins));
        hw=(length(boxcar)/2)-1;
        smoothed=conv([n(end-floor(hw):end) n n(1:ceil(hw))] ,boxcar,'valid');
        subplot(h,w,j);
        p=polar(spikingPhasePerType{j},2-rand(1,nm)/3,'.'); hold on; set(p,'Color',colors(j,:))
        p=polar(edges(1:end-1)+(pi/numPhaseBins),1.5*smoothed/max(smoothed),'k');
        set(p,'lineWidth',2)
        %polar(edges(1:end-1)+(pi/numPhaseBins),1.5*n/max(n),'r')
        %[x y]=pol2cart(edges(1:end)+(pi/numPhaseBins),1.5*n/max(n));
        %fill(x,y,'k')
        set(gca,'xTickLabel',[])
    end
    
    % each phase corresponse to a particular onEdge location, and a particular
    % 'offEdge' location.  here we find out what that location is along the
    % axis of of orientation used.  phase zero is in the upper right when the
    % rotation of the grating is zero (vertical).  as the orientation changes
    % is still in the upper right of the SOURCE, and so we do not need to back
    % calculate to project... we simply caluclate where that edge is in the
    % source grating.
    
    % since this is expected to be used with square gratings, we use the hard
    % edge, still could work with sine wave, but less clear where the edge is.
    % (ie. does the mean crossing really cause a spike?)
    
    % we will use all edges in the source (even if they would have been cropped
    % in the destination rect actually on the screen)... could rmeove the ones
    % off screen in future... or maybe weight by the length on the screen?
    
    % we fit a spline to the density per phase, and then insert the
    %%
    if length(stimulusDetails.phases)>1
        stimulusDetails.phases
        error('initial phase is expected to be the same in this caluclation')
        %double check as startPhases may already acount for this in the
        %calculation of phases = [ 1 x numFrames ]
    end
    
    if ~isfield(stimulusDetails,'width')
        warning('width is not a field, and should be after november 2009')
        stimWidth=1024;  %should get this from stimulusDetails.width! added it to calc stim nov 2009 pmm
    else
        stimWidth=stimulusDetails.width;
    end
    
    ppc=stimulusDetails.spatialFrequencies; % spatialFrequencies is actually a value of picPerCyc's that fan renamed to avoid clash
    
    %x=(1:stimWidth*2)*2*pi/ppc; at the fidelity of screen pixels in source...too high
    numBinsInRadon=40;
    x=linspace(1/numBinsInRadon,1,numBinsInRadon)*2*2*pi*(stimWidth/ppc);
    delta=(1/numBinsInRadon)*2*2*pi*(stimWidth/ppc);
    radonTransformOnEdge=zeros(numBinsInRadon,numTypes); % zero density at first
    radonTransformOffEdge=zeros(numBinsInRadon,numTypes); % zero density at first
    onEdgePhase=pi/2;
    offEdgePhase=pi*3/2;
    for j=1:numTypes
        for k=1:length(spikingPhasePerType{j})  % num spiking phases
            %spikingPhasePerType{j}
            %grating=square(x + offset+stimulusDetails.phases+pi/2); % same as sine, but adjust for cosine
            thisSpatialPhase=mod(x+ phases(spikeIDPerType{j}(k)),2*pi);
            onEdgeIDs=(thisSpatialPhase <=onEdgePhase+delta & thisSpatialPhase> onEdgePhase);
            offEdgeIDs=(thisSpatialPhase <=offEdgePhase+delta & thisSpatialPhase> offEdgePhase);
            %[sum(onEdgeIDs) sum(offEdgeIDs)] numEdges found
            radonTransformOnEdge(onEdgeIDs,j)=radonTransformOnEdge(onEdgeIDs,j)+spikeCount(spikeIDPerType{j}(k));
            radonTransformOffEdge(offEdgeIDs,j)=radonTransformOffEdge(offEdgeIDs,j)+spikeCount(spikeIDPerType{j}(k));
        end
    end
    
    theta=180*orientations/(pi);
    
    figure(parameters.trialNumber+20); % new for each trial
    subplot(2,2,1); imagesc(radonTransformOnEdge)
    subplot(2,2,2); imagesc(radonTransformOffEdge)
    subplot(2,2,3); imagesc(iradon(radonTransformOnEdge,theta)); title('on rf')
    subplot(2,2,4); imagesc(iradon(radonTransformOffEdge,theta)); title('off rf')
end

%%
%get eyeData for phase-eye analysis
if ~isempty(eyeData)
    [px py crx cry]=getPxyCRxy(eyeData,10);
    eyeSig=[crx-px cry-py];
    eyeSig(end,:)=[]; % remove last ones to match (not principled... what if we should throw out the first ones?)
    
    if length(unique(eyeSig(:,1)))>10 % if at least 10 x-positions
        
        regionBoundsXY=[1 .5]; % these are CRX-PY bounds of unknown degrees
        [within ellipses]=selectDenseEyeRegions(eyeSig,1,regionBoundsXY);
        
        whichOne=0; % various things to look at
        switch whichOne
            case 0
                %do nothing
            case 1 % plot eye position and the clusters
                regionBoundsXY=[1 .5]; % these are CRX-PY bounds of unknown degrees
                within=selectDenseEyeRegions(eyeSig,3,regionBoundsXY,true);
            case 2  % coded by phase
                [n phaseID]=histc(phases,edges);
                figure; hold on;
                phaseColor=jet(numPhaseBins);
                for i=1:numPhaseBins
                    plot(eyeSig(phaseID==i,1),eyeSig(phaseID==i,2),'.','color',phaseColor(i,:))
                end
            case 3
                density=hist3(eyeSig);
                imagesc(density)
            case 4
                eyeMotion=diff(eyeSig(:,1));
                mean(eyeMotion>0)/mean(eyeMotion<0);   % is close to 1 so little bias to drift and snap
                bound=3*std(eyeMotion(~isnan(eyeMotion)));
                motionEdges=linspace(-bound,bound,100);
                count=histc(eyeMotion,motionEdges);
                
                figure; bar(motionEdges,log(count),'histc'); ylabel('log(count)'); xlabel('eyeMotion (crx-px)''')
                
                figure; plot(phases',eyeMotion,'.'); % no motion per phase (more interesting for sqaure wave single freq)
        end
    else
        disp(sprintf('no good eyeData on trial %d',parameters.trialNumber))
    end
end




% events(events>possibleEvents)=possibleEvents % note: more than one spike could occur per frame, so not really binomial
% [pspike pspikeCI]=binofit(events,possibleEvents);

fullRate=events./possibleEvents;
rate=reshape(sum(events,1)./sum(possibleEvents,1),numTypes,numPhaseBins); % combine repetitions

[repInds typeInds]=find(isnan(pow));
pow(unique(repInds),:)=[];   % remove reps with bad power estimates
coh(unique(repInds),:)=[];   % remove reps with bad power estimates
cohLB(unique(repInds),:)=[]; % remove reps with bad power estimates
if numRepeats>2
    rateSEM=reshape(std(events(1:end-1,:,:)./possibleEvents(1:end-1,:,:)),numTypes,numPhaseBins)/sqrt(numRepeats-1);
else
    rateSEM=nan(size(rate));
end

if size(pow,1)>1
    powSEM=std(pow)/sqrt(size(pow,1));
    pow=mean(pow);
    
    cohSEM=std(coh)/sqrt(size(coh,1));
    coh=mean(coh);
    cohLB=mean(cohLB);  % do you really want the mean of the lower bound?
else
    powSEM=nan(1,size(pow,2));
    cohSEM=nan(1,size(pow,2));
    cohLB_SEM=nan(1,size(pow,2));
end

analysisdata.rate = rate;
analysisdata.repInds = repInds;
analysisdata.typeInds = typeInds;
analysisdata.rateSEM = rateSEM;
analysisdata.powSEM = powSEM;
analysisdata.pow = pow;
analysisdata.cohSEM = cohSEM;
analysisdata.coh = coh;
analysisdata.cohLB = cohLB;
analysisdata.refreshRate = parameters.refreshRate;
% analysisdata.rate = rate;
% analysisdata.rate = rate;


% if plotParameters.showSpikeAnalysis
%     % setup for plotting
%     vals=eval(char(sweptParameter));
%     if strcmp(sweptParameter,'orientations')
%         vals=rad2deg(vals);
%     end
%     
%     if all(rem(vals,1)==0)
%         format='%2.0f';
%     else
%         format='%1.2f';
%     end
%     for i=1:length(vals);
%         valNames{i}=num2str(vals(i),format);
%     end;
%     
%     colors=jet(numTypes);
%     figure(parameters.trialNumber); % new for each trial
%     set(gcf,'position',[100 300 560 620])
%     subplot(3,2,1); hold off; %p=plot([1:numPhaseBins]-.5,rate')
%     plot([0 numPhaseBins], [rate(1) rate(1)],'color',[1 1 1]); hold on;% to save tight axis chop
%     x=[1:numPhaseBins]-.5;
%     for i=1:numTypes
%         plot(x,rate(i,:),'color',colors(i,:))
%         plot([x; x]+(i*0.05),[rate(i,:); rate(i,:)]+(rateSEM(i,:)'*[-1 1])','color',colors(i,:))
%     end
%     maxPowerInd=find(pow==max(pow));
%     maxPowerInd = maxPowerInd(1);
%     if ~isempty(pow)
%         plot(x,rate(maxPowerInd,:),'color',colors(maxPowerInd,:),'lineWidth',2);
%     end
%     xlabel('phase');  set(gca,'XTickLabel',{'0','pi','2pi'},'XTick',([0 .5 1]*numPhaseBins)); ylabel('rate'); set(gca,'YTickLabel',[0:.1:1]*parameters.refreshRate,'YTick',[0:.1:1])
%     axis tight
%     
%     %rate density over phase... doubles as a legend
%     subplot(3,2,2); hold off;
%     im=zeros([size(phaseDensity) 3]);
%     hues=rgb2hsv(colors);  % get colors to match jet
%     hues=repmat(hues(:,1)',numRepeats,1); % for each rep
%     hues=repmat(hues(:),1,numPhaseBins);  % for each phase bin
%     im(:,:,1)=hues; % hue
%     im(:,:,2)=1; % saturation
%     im(:,:,3)=phaseDensity/max(phaseDensity(:)); % value
%     rgbIm=hsv2rgb(im);
%     image(rgbIm); hold on
%     axis([0 size(im,2) 0 size(im,1)]+.5);
%     ylabel(sweptParameter); set(gca,'YTickLabel',valNames,'YTick',size(im,1)*([1:length(vals)]-.5)/length(vals))
%     xlabel('phase');  set(gca,'XTickLabel',{'0','pi','2pi'},'XTick',([0 .5 1]*numPhaseBins)+.5);
%     
%     subplot(3,2,3); hold off; plot(mean(rate'),'k','lineWidth',2); hold on; %legend({'Fo'})
%     xlabel(sweptParameter); set(gca,'XTickLabel',valNames,'XTick',[1:length(vals)]); ylabel('rate (f0)'); set(gca,'YTickLabel',[0:.1:1]*parameters.refreshRate,'YTick',[0:.1:1])
%     set(gca,'XLim',[1 length(vals)])
%     
%     
%     subplot(3,2,4); hold off
%     if ~isempty(pow)
%         modulation=pow./(parameters.refreshRate*mean(rate'))
%         plot(pow,'k','lineWidth',1); hold on;
%         plot(modulation,'--k','lineWidth',2); hold on;
%         cohScaled=coh*max(pow); %1 is peak FR
%         plot(cohScaled,'color',[.8 .8 .8],'lineWidth',1);
%         sigs=find(cohLB>0);
%         plot(sigs,cohScaled(sigs),'o','color',[.6 .6 .6]);
%         legend({'f1','f1/f0','coh'})
%         
%         
%         plot([1:length(vals); 1:length(vals)],[pow; pow]+(powSEM'*[-1 1])','k')
%         %plot([1:length(vals); 1:length(vals)],[pow; pow]+(powSEM'*[-1 1])','k')
%         plot([1:length(vals); 1:length(vals)]+0.1,[coh; coh]+(cohSEM'*[-1 1])','color',[.8 .8 .8])
%         xlabel(sweptParameter); set(gca,'XTickLabel',valNames,'XTick',[1:length(vals)]); ylabel('modulation (f1/f0)');
%         ylim=get(gca,'YLim'); yvals=[ ylim(1) mean(ylim) ylim(2)];set(gca,'YTickLabel',yvals,'YTick',yvals)
%         set(gca,'XLim',[1 length(vals)])
%     else
%         xlabel(sprintf('not enough data for all %s yet',sweptParameter{1}))
%     end
%     meanRate=(length(spikes))/diff(spikeRecord.spikeTimestamps([1 end]));
%     isi=diff(spikeRecord.spikeTimestamps(thisCluster))*1000;
%     N=sum(isi<parameters.ISIviolationMS); percentN=100*N/length(isi);
%     %datestr(parameters.date,22)
%     infoString=sprintf('subj: %s  trial: %d Hz: %d',parameters.subjectID,parameters.trialNumber,round(meanRate));
%     ylim=get(gca,'YLim');
%     text(1.2,ylim(2),infoString);
%     
%     subplot(3,2,5);
%     numBins=40; maxTime=10; % ms
%     edges=linspace(0,maxTime,numBins); [count]=histc(isi,edges);
%     hold off; bar(edges,count,'histc'); axis([0 maxTime get(gca,'YLim')]);
%     hold on; plot(parameters.ISIviolationMS([1 1]),get(gca,'YLim'),'k' )
%     xvalsName=[0 parameters.ISIviolationMS maxTime]; xvals=xvalsName*samplingRate/(1000*numBins);
%     set(gca,'XTickLabel',xvalsName,'XTick',xvals)
%     infoString=sprintf('viol: %2.2f%%\n(%d /%d)',percentN,N,length(isi))
%     text(xvals(3),max(count),infoString,'HorizontalAlignment','right','VerticalAlignment','top');
%     ylabel('count'); xlabel('isi (ms)')
%     
%     subplot(3,2,6); hold off;
%     if ~isempty(eyeData)
%         plot(eyeSig(1,1),eyeSig(1,2),'.k');  hold on; % plot one dot to flush history
%         if exist('ellipses','var')
%             plotEyeElipses(eyeSig,ellipses,within,true)
%         else
%             text(.5,.5,'no good eye data')
%         end
%         xlabel('eye position (cr-p)')
%     else
%         text(.5,.5,'no eye data')
%     end
% end
%rasterDurationSec=1;
%linesPerChunk=round((unique(durations/parameters.refreshRate))/rasterDurationSec);

if 0
    %old raster per type- not that informative
    figure; hold on
    for j=1:numTypes
        for i=1:numRepeats
            sf=chunkStartFrame((i-1)*numTypes+j); %frame start
            ef=min(chunkEndFrame((i-1)*numTypes+j),numFrames); % frame end
            
            %TIME
            %st=correctedFrameIndices(sf,1); % time start index
            %et=correctedFrameIndices(ef,2); % time stop index
            %times=find(spikes(st:et))/samplingRate; error('wrong spike definition'))
            %times=times*pixPerCycs(j);  % hack rescaling of time, to match phases... increases "apparent" firing rate
            %plot(times,(j-1)*numRepeats+i,'.','color',colors(j,:))
            
            %PHASE - scatter
            spikedPhases=phases(find(spikeCount(sf:ef)>0));
            disp(length(unique(spikedPhases)))
            %allPhases=phases(sf:ef);
            %allPhases=allPhases+0.02*randn(1,length(allPhases));
            %spikedPhases=spikedPhases+0.02*randn(1,length(spikedPhases)); %%NOISE - visualize overlap?
            if length(spikedPhases>0)
                plot(spikedPhases,(j-1)*numRepeats+i,'.','MarkerSize',5,'color',colors(j,:))
            end
            %DENSITY IN PHASE
            
        end
    end
    %axis([0 max(times) 0 numTypes*numRepeats]) % hack rescaling of time, to match phases... increases "apparent" firing rate
end


%% LFP Analysis ONLY SUPPORTS SINGLE TYPE OF SWEEP RIGHT NOW
correctedFrameTimes = spikeRecord.correctedFrameTimes;
if doLFPAnalysis
    
    % setup for plotting
    vals=eval(char(sweptParameter));
    if strcmp(sweptParameter,'orientations')
        vals=rad2deg(vals);
    end
    
    if all(rem(vals,1)==0)
        format='%2.0f';
    else
        format='%1.2f';
    end
    for i=1:length(vals);
        valNames{i}=num2str(vals(i),format);
    end;
    
    %     % Average LFP over all repeats
    %     numIdealLFPSamplesPerRepeat = ceil(mean(LFPRecord.LFPSamplingRateHz)*numTypes*duration/parameters.refreshRate);
    %     timeByRepeat = linspace(0,numTypes*duration/parameters.refreshRate,numIdealLFPSamplesPerRepeat);
    %     LFPByRepeat = nan(numRepeats,numIdealLFPSamplesPerRepeat);
    %     for currRepeatNum = 1:numRepeats
    %         which = find(repeat==currRepeatNum);
    %         currRepeatTime = [min(correctedFrameTimes(which,1)) max(correctedFrameTimes(which,1))];
    %         whichInLFPRecord = LFPRecord.dataTimes>=min(correctedFrameTimes(which,1))& ...
    %             LFPRecord.dataTimes<=max(correctedFrameTimes(which,2));
    % %         figure; plot(LFPRecord.dataTimes(whichInLFPRecord)-currRepeatTime(1),LFPRecord.data(whichInLFPRecord));
    %         LFPByRepeat(currRepeatNum,:) = resample(LFPRecord.data(whichInLFPRecord),numIdealLFPSamplesPerRepeat,length(find(whichInLFPRecord)));
    %     end
    %     figure(LFPfig);
    %     stdDevByRepeat = std(LFPByRepeat,0,1);
    %     subplot(3,3,2:3);
    %     hold on;
    %     plot(timeByRepeat,mean(LFPByRepeat,1),'Color','b','LineWidth',2);
    %     plot(timeByRepeat,mean(LFPByRepeat,1)+stdDevByRepeat,'Color',[0.8 0.8 1],'LineWidth',1);
    %     plot(timeByRepeat,mean(LFPByRepeat,1)-stdDevByRepeat,'Color',[0.8 0.8 1],'LineWidth',1);
    %     axis tight
    %     title('average LFP over all repeats +/- std');
    %     xlabel('time(s)');
    %     ylabel('voltage(V)');
    %     hold off
    
    
    
    % LFP over each swept type
%     
%     numIdealLFPSamplesPerTypePerRepeat = ceil(mean(LFPRecord.LFPSamplingRateHz)*duration/parameters.refreshRate);
%     timeByTypeByRepeat = linspace(0,duration/parameters.refreshRate,numIdealLFPSamplesPerTypePerRepeat);
%     LFPByType = nan(numTypes,numRepeats,numIdealLFPSamplesPerTypePerRepeat,size(LFPRecord.data,2));
%     for currTypeNum = 1:numTypes
%         for currRepeatNum = 1:numRepeats
%             which = find((repeat==currRepeatNum)&(type==currTypeNum));
%             if length(which)>0 %PMM
%                 currTypeTime = [min(correctedFrameTimes(which,1)) max(correctedFrameTimes(which,1))];
%                 whichInLFPRecord = LFPRecord.dataTimes>=currTypeTime(1)& ... %PMM
%                     LFPRecord.dataTimes<=currTypeTime(2);
%                 LFPByType(currTypeNum,currRepeatNum,:,:) = resample(LFPRecord.data(whichInLFPRecord,:),numIdealLFPSamplesPerTypePerRepeat,length(find(whichInLFPRecord)));
%             else
%                 % else its left as a nan
%             end
%         end
%     end
%     
%     %% LFP PLOTTING
%     developmentPlotting = true;
%     LFPAverageThroughRepeat = squeeze(mean(LFPByType,2));
%     LFPRange = [min(LFPAverageThroughRepeat(~isnan(LFPAverageThroughRepeat))) max(LFPAverageThroughRepeat(~isnan(LFPAverageThroughRepeat)))];
%     if developmentPlotting
%         %% Average LFP by lead
%         LFPByLead = figure('Name','LFP By Lead','NumberTitle','off');
%         for numLead = 1:size(LFPByType,4)
%             currAxes(numLead) = subplot(ceil(sqrt(size(LFPByType,4))),ceil(sqrt(size(LFPByType,4))),numLead);
%             imagesc([1 ],[],squeeze(LFPAverageThroughRepeat(:,:,numLead)),LFPRange);
% %             set(gca,'XTick',[],'YTick',[]);
%             title(['Chan:' num2str(numLead)]);
%         end
%         for numLead = 1:ceil(sqrt(size(LFPByType,4))):length(currAxes)
%             set(currAxes(numLead),'YTickMode','auto');
%         end
%     end
%     stdDevByTypeByRepeat = std(LFPByType,0,2);%nan(numTypes,numIdealLFPSamplesPerTypePerRepeat)
%     rangeOfLFP = [min(LFPByType(~isnan(LFPByType))) max(LFPByType(~isnan(LFPByType)))]; % PMM
    
    %     if plotParameters.showLFPAnalysis
    %         LFPfig = figure('Name','LFP analysis','NumberTitle','off');
    %         cmap = jet(numTypes);
    %         subplot(9,3,[1 4 7 10 13 16 19 22 25]);
    %         hold on;
    %         for currTypeNum = 1:numTypes
    %             currPlotColor = cmap(currTypeNum,:);
    %             LFPForCurrType = (mean(squeeze(LFPByType(currTypeNum,:,:)),1)-rangeOfLFP(1))/diff(rangeOfLFP);
    %             LFPForCurrTypePlusStd = ((mean(squeeze(LFPByType(currTypeNum,:,:)),1)+squeeze(stdDevByTypeByRepeat(currTypeNum,:)))-rangeOfLFP(1))/diff(rangeOfLFP);
    %             LFPForCurrTypeMinusStd = ((mean(squeeze(LFPByType(currTypeNum,:,:)),1)-squeeze(stdDevByTypeByRepeat(currTypeNum,:)))-rangeOfLFP(1))/diff(rangeOfLFP);
    %             stimPhases = phases((repeat==1)&(type==currTypeNum));
    % %             plot(timeByTypeByRepeat,currTypeNum+LFPForCurrTypePlusStd-mean(LFPForCurrType),'LineWidth',.5,'Color',currPlotColor);
    % %             plot(timeByTypeByRepeat,currTypeNum+LFPForCurrTypeMinusStd-mean(LFPForCurrType),'LineWidth',.5,'Color',currPlotColor);
    %             yWrap=[currTypeNum+LFPForCurrTypeMinusStd-mean(LFPForCurrType) fliplr(currTypeNum+LFPForCurrTypePlusStd-mean(LFPForCurrType))];
    %             palerColor=brighten(mean([currPlotColor; 0.5 0.5 0.5]),.8); % less saturated the lightened
    %             fill([timeByTypeByRepeat fliplr(timeByTypeByRepeat)],yWrap,'k','faceColor',palerColor,'edgeAlpha',0);
    %             plot(timeByTypeByRepeat,currTypeNum+LFPForCurrType-mean(LFPForCurrType),'LineWidth',3,'Color',currPlotColor); % minimize clutter
    %             %plot(timeByTypeByRepeat,currTypeNum+0.25*resample(sin(stimPhases),length(timeByTypeByRepeat),length(stimPhases)),'LineWidth',.5,'LineStyle','--','Color',currPlotColor);
    %             plot(timeByTypeByRepeat,currTypeNum+0.25*resample(sin(stimPhases),length(timeByTypeByRepeat),length(stimPhases)),'LineWidth',.5,'Color','k'); % for contrast
    %         end
    %         axis tight;
    %         titleLabel = sprintf('average over swept parameter: %s', sweptParameter{:});
    %         xLabel = 'time(s)';
    %         yLabel = sprintf('%s is', sweptParameter{:});
    %         title(titleLabel);
    %         xlabel(xLabel);
    %         ylabel(yLabel);
    %         set(gca,'YTickLabel',valNames,'Ytick',1:(numTypes));
    %         hold off;
    %     end
    
    
    % LFP Power
    %     currRepeatNum = 1; which = find(repeat==currRepeatNum);
    %     whichInLFPRecordBeforeStim = LFPRecord.dataTimes<min(correctedFrameTimes(which,1));
    %     currRepeatNum = numRepeats; which = find(repeat==currRepeatNum);
    %     whichInLFPRecordAfterStim = LFPRecord.dataTimes>max(correctedFrameTimes(which,2));
    %     %LFPBeforeStim = LFPRecord.data(whichInLFPRecordBeforeStim);
    %     %LFPAfterStim = LFPRecord.data(whichInLFPRecordAfterStim);
    %     %LFPAfterStim = LFPAfterStim-(LFPAfterStim(1)-LFPBeforeStim(end));  % WHAT?
    %     %LFPWithoutStim = [LFPBeforeStim; LFPAfterStim];
    %     LFPWithoutStim=LFPRecord.data(whichInLFPRecordBeforeStim | whichInLFPRecordAfterStim);  % MAYBE you mean this?
    %     params.Fs = mean(LFPRecord.LFPSamplingRateHz);
    %     %     params.fpass = [0 150];
    %     params.fpass = [0 30];
    %     params.err = [2 0.05];
    %     params.tapers = [3 5];
    %     [specWithoutStim freq specWithoutStimErr] = mtspectrumc(LFPWithoutStim,params);
    %     log10specWithoutStim = 10*log10(specWithoutStim);
    %
    
    
    %     if plotParameters.showLFPAnalysis
    %         currAxes = subplot(9,3,[2 3]);
    %         plot_vector(specWithoutStim,freq,'l',specWithoutStimErr,[0.8 0.8 0.9],2,[LFPfig currAxes],{'','','logP(dB)'});
    %         axis tight;
    %         currAxes = subplot(9,3,[5 6]);
    %         plot_vector(specWithoutStim,freq,'n',specWithoutStimErr,[0.8 0.8 0.9],2,[LFPfig currAxes],{'','','P'});
    %         axis tight;
    %     end
    
    %     LFPPowerByType = nan(numTypes,numRepeats,length(specWithoutStim));
    %     params = [];
    %     params.Fs = mean(LFPRecord.LFPSamplingRateHz);
    % %   params.fpass = [0 150];
    %     params.fpass = [0 30];
    %     params.tapers = [3 5];
    %
    %
    %     for currTypeNum = 1:numTypes
    %         for currRepeatNum = 1:numRepeats
    %             which = find((repeat==currRepeatNum)&(type==currTypeNum));
    %             if length(which)>0 %PMM
    %                 whichInLFPRecord = LFPRecord.dataTimes>=min(correctedFrameTimes(which,1))& ...
    %                     LFPRecord.dataTimes<=max(correctedFrameTimes(which,2));
    %                 [spec freq] = mtspectrumc(LFPRecord.data(whichInLFPRecord),params);
    %                 LFPPowerByType(currTypeNum,currRepeatNum,:) = interp1(freq,spec,linspace(min(freq),max(freq),length(specWithoutStim)));
    %             end
    %         end
    %     end
    
    %     if plotParameters.showLFPAnalysis
    %         currAxes = subplot(9,3,[8 9]);
    %         hold on;
    %         for currTypeNum = 1:numTypes
    %             currPlotColor = cmap(currTypeNum,:);
    %             %         log10LFPPowerByType = 10*log10(squeeze(mean(LFPPowerByType(currTypeNum,:,:),2)));
    %             %         log10LFPPowerErrByType = 10*log10(squeeze(std(LFPPowerByType(currTypeNum,:,:),2)));
    %             plot_vector((squeeze(mean(LFPPowerByType(currTypeNum,:,:),2))-specWithoutStim),linspace(min(freq),max(freq),length(specWithoutStim)),'n',[],currPlotColor,1,[LFPfig currAxes],{'','f','\DeltaP'});
    %             %         plot(freq,log10LFPPowerByType-log10specWithoutStim,'Color',currPlotColor,'LineWidth',1);
    %         end
    %         axis tight;
    %         hold off;
    %     end
    
    % LFP Coherence
    %    stdOfMean = squeeze(std(mean(LFPByType,2),0,3));
%     coherencyCoeffMatrix = [];
%     coherencyPhaseMatrix = [];
%     if plotParameters.showLFPAnalysis
%         for currTypeNum = 1:numTypes
%             LFPForCurrType = (squeeze(mean(LFPByType(currTypeNum,:,:),2))-rangeOfLFP(1))/diff(rangeOfLFP);
%             stimPhases = sin(phases((repeat==1)&(type==currTypeNum)));
%             stimIntensity = resample(sin(stimPhases),length(timeByTypeByRepeat),length(stimPhases));
%             params.Fs = ceil(length(timeByTypeByRepeat)/range(timeByTypeByRepeat));
%             params.pad = 0;
%             params.tapers = [3 5];
%             params.err = [2 0.05];
%             [C,phi,S12,S1,S2,f,confC,phistd,Cerr] = coherencyc(stimIntensity,LFPForCurrType,params);
%             %             plot_vector(S1,f,'l',[],cmap(currNumType,:),1,[LFPfig currAxes]);
%             coherencyCoeffMatrix(end+1,:) = C';
%             coherencyPhaseMatrix(end+1,:) = phi';
%         end
%         hold off;
%         subplot(9,3,[11 12]);
%         imagesc(coherencyCoeffMatrix); colorbar;
%         XTicks = [0 size(coherencyCoeffMatrix,2)];
%         newXTickLabels = [min(f) max(f)]
%         set(gca,'XTick',XTicks,'XTickLabel',newXTickLabels);
%         yLabel = 'Coh';
%         ylabel(yLabel);
%         axis tight
%         
%         subplot(9,3,[14 15]);
%         imagesc(coherencyPhaseMatrix); colorbar;
%         XTicks = [0 size(coherencyPhaseMatrix,2)];
%         newXTickLabels = [min(f) max(f)]
%         set(gca,'XTick',XTicks,'XTickLabel',newXTickLabels);
%         yLabel = 'Phase';
%         ylabel(yLabel);
%         axis tight
%         
%         %         axis tight;
%     end
% end


%CUMULATIVE IS NOT USED YET:
% % fill in analysisdata with new values if the cumulative values don't exist (first analysis)
% if ~isfield(analysisdata, 'cumulativeEvents') % && check that params did not change
%     analysisdata.cumulativeEvents = events;
%     analysisdata.cumulativePossibleEvents=possibleEvents
% else
%     analysisdata.cumulativeEvents = analysisdata.cumulativeEvents + events;
%     analysisdata.cumulativePossibleEvents = analysisdata.cumulativePossibleEvents + possibleEvents;
% end
end

%% update relevant stuff
analysisdata.rate=rate;
analysisdata.sweptParameter=sweptParameter;
analysisdata.spikeCount = spikeCount;
analysisdata.totalTime = sum(spikeRecord.chunkDuration);
analysisdata.eyeData = eyeData;
cumulativedata=analysisdata; % why are we emptying out cumulativedata? do we not have anything cumulative in gratings?



end % end function
% ===============================================================================================