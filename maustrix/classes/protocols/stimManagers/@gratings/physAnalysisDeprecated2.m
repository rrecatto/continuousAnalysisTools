function [analysisdata cumulativedata] = physAnalysisDev(stimManager,spikeRecord,stimulusDetails,plotParameters,parameters,cumulativedata,eyeData,LFPRecord)

%% processed clusters and spikes
theseSpikes = logical(spikeRecord.processedClusters);
spikes=spikeRecord.spikes(theseSpikes);
spikeWaveforms = spikeRecord.spikeWaveforms(theseSpikes,:);
spikeTimestamps = spikeRecord.spikeTimestamps(theseSpikes);

%% SET UP RELATION stimInd <--> frameInd
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

%% 
trials = repmat(parameters.trialNumber,length(stimFrames),1);

%% is there randomization?
if ~isfield(stimulusDetails,'method')
    mode = {'ordered',[]};
else
    mode = {stimulusDetails.method,stimulusDetails.seed};
end

%% get the stimulusCombo
if stimulusDetails.doCombos==1
    comboMatrix = generateFactorialCombo({stimulusDetails.spatialFrequencies,stimulusDetails.driftfrequencies,stimulusDetails.orientations,...
        stimulusDetails.contrasts,stimulusDetails.phases,stimulusDetails.durations,stimulusDetails.radii,stimulusDetails.annuli},[],[],mode);
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
    chunkStartFrame = chunkStartFrame';
    chunkEndFrame = chunkEndFrame';
    numChunks=length(chunkStartFrame);
    trialsByChunk = repmat(parameters.trialNumber,numChunks,1);
    numTypes=length(durations); %total number of types even having multiple sweeps  
else
    error('analysis not handled yet for this case')
end

numValsPerParam=...
    [length(unique(pixPerCycs)) length(unique(driftfrequencies))  length(unique(orientations))...
    length(unique(contrasts)) length(unique(startPhases)) length(unique(durations))...
    length(unique(radii))  length(unique(annuli))];

%% find which parameters are swept
names={'pixPerCycs','driftfrequencies','orientations','contrasts','startPhases',...
    'durations','radii','annuli'};

sweptParameters = names(find(numValsPerParam>1));
numSweptParams = length(sweptParameters);
if numSweptParams>2
    error('unsupported for sweeps>2');
end
valsSwept = cell(length(sweptParameters),0);
for sweptNo = 1:length(find(numValsPerParam>1))
    valsSwept{sweptNo} = eval(sprintf('sort(%s)',char(sweptParameters{sweptNo})));
end

% durations of each condition should be unique
if length(unique(durations))==1
    duration=unique(durations);
else
    error('multiple durations can''t rely on mod to determine the frame type')
end


stimInfo.pixPerCycs = unique(pixPerCycs);
stimInfo.driftfrequencies = unique(driftfrequencies);
stimInfo.orientations = unique(orientations);
stimInfo.contrasts = unique(contrasts);
stimInfo.startPhases = unique(startPhases);
stimInfo.durations = unique(durations);
stimInfo.radii = unique(radii);
stimInfo.annuli = unique(annuli);
stimInfo.numRepeats = numRepeats;
stimInfo.sweptParameters = sweptParameters;
stimInfo.numSweptParams = numSweptParams;
stimInfo.valsSwept = valsSwept;
stimInfo.numTypes = numTypes;

%% to begin with no attempt will be made to group acording to type
types=repmat([1:numTypes],duration,numRepeats);
types=types(stimFrames); % vectorize matrix and remove extras

samplingRate=parameters.samplingRate;

% calc phase per frame, just like dynamic
x = 2*pi./pixPerCycs(types); % adjust phase for spatial frequency, using pixel=1 which is likely always offscreen, given roation and oversizeness
cycsPerFrameVel = driftfrequencies(types)*1/(parameters.refreshRate); % in units of cycles/frame
offset = 2*pi*cycsPerFrameVel.*stimFrames';
risingPhases=x+offset+startPhases(types);
phases=mod(risingPhases,2*pi); 
phases = phases';

% count the number of spikes per frame
% spikeCount is a 1xn vector of (number of spikes per frame), where n = number of frames
spikeCount=zeros(size(correctedFrameIndices,1),1);
for i=1:length(spikeCount) % for each frame
    spikeCount(i)=length(find(spikes>=correctedFrameIndices(i,1)&spikes<=correctedFrameIndices(i,2))); % inclusive?  policy: include start & stop
end

numPhaseBins=8;
edges=linspace(0,2*pi,numPhaseBins+1);
firingRateByPhase=zeros(numRepeats,numPhaseBins,numTypes);
stimUntyped = zeros(numRepeats,numTypes,duration);
spikeCountUntyped = zeros(numRepeats,numTypes,duration);
% [chunkStartFrame chunkEndFrame trialsByChunk...
%     stimFrames spikeCount phases types repeat trials cumulativedata]...
%     = getCompleteRecords(chunkStartFrameThis, chunkEndFrameThis, trialsByChunkThis,...
%     stimFramesThis,spikeCountThis,phasesThis,typesThis, repeatThis,trialsThis,cumulativedata);

for i=1:numRepeats
    for j=1:numTypes
        whichType=find(types==j & repeat==i); % refers to the frames  og type = j and repeat = i
        if length(whichType)>5  % need some spikes, 2 would work mathematically ??is this maybe spikeCount(whichType). actually we are saying that we need atleast 5 frames in this state. is that righyt????
            [n phaseID]=histc(phases(whichType),edges);
            for k=1:numPhaseBins
                whichPhase=find(phaseID==k);
                firingRateByPhase(i,k,j)=sum(spikeCount(whichType(whichPhase)));
                durationThatPhase = length(whichType(whichPhase))*(1/parameters.refreshRate);
                firingRateByPhase(i,k,j) = firingRateByPhase(i,k,j)/durationThatPhase;
            end
            stimUntyped(i,j,:) = resample(.5+cos(phases(whichType))/2,duration,length(whichType));
            spikeCountUntyped(i,j,:) = resample(spikeCount(whichType),duration,length(whichType));
            % everything from here will be taken care of in the display
            % part
%             % find the power in the spikes at the freq of the grating
%             fy=fft(.5+cos(phases(whichType))/2); %fourier of stim
%             fx=fft(spikeCount(whichType)); % fourier of spikes
%             fy=abs(fy(2:floor(length(fy)/2))); % get rid of DC and symetry
%             fx=abs(fx(2:floor(length(fx)/2)));
%             peakFreqInd=find(fy==max(fy)); % find the right freq index using stim
%             pow(i,j)=fx(peakFreqInd); % determine the power at that freq
%             
%             % find the power in the spikes at the freq of the grating
%             fyThis=fft(.5+cos(phases(whichTypeThis))/2); %fourier of stim
%             fxThis=fft(spikeCount(whichTypeThis)); % fourier of spikes
%             fyThis=abs(fyThis(2:floor(length(fyThis)/2))); % get rid of DC and symetry
%             fxThis=abs(fxThis(2:floor(length(fxThis)/2)));
%             peakFreqIndThis=find(fyThis==max(fyThis)); % find the right freq index using stim
%             powThis(i,j)=fx(peakFreqIndThis); % determine the power at that freq
%             
%             % coherency
%             chrParam.tapers=[3 5]; % same as default, but turns off warning
%             chrParam.err=[2 0.05];  % use 2 for jacknife
%             fscorr=true;
%             % should check chronux's chrParam,trialave=1 to see how to
%             % handle CI's better.. will need to do all repeats at once
%             [C,phi,S12,S1,S2,f,zerosp,confC,phistd,Cerr]=...
%                 coherencycpb(cos(phases(whichType)),spikeCount(whichType),chrParam,fscorr);
%             [CThis,phiThis,S12This,S1This,S2This,fThis,zerospThis,confCThis,phistdThis,CerrThis]=...
%                 coherencycpb(cos(phases(whichTypeThis)),spikeCount(whichTypeThis),chrParam,fscorr);
%             
%             if ~zerosp
%                 peakFreqInds=find(S1>max(S1)*.95); % a couple bins near the peak of
%                 [junk maxFreqInd]=max(S1);
%                 coh(i,j)=mean(C(peakFreqInds));
%                 cohLB(i,j)=Cerr(1,maxFreqInd);
%             else
%                 coh(i,j)=nan;
%                 cohLB(i,j)=nan;
%             end
%             
%             if ~zerospThis
%                 peakFreqIndsThis=find(S1This>max(S1This)*.95); % a couple bins near the peak of
%                 [junk maxFreqIndThis]=max(S1This);
%                 cohThis(i,j)=mean(CThis(peakFreqIndsThis));
%                 cohLBThis(i,j)=Cerr(1,maxFreqIndThis);
%             else
%                 cohThis(i,j)=nan;
%                 cohLBThis(i,j)=nan;
%             end
            
        end
    end
end
stimInfo.numPhaseBins = numPhaseBins;

% update what we know about te analysis to analysisdata
analysisdata.stimInfo = stimInfo;
analysisdata.trialNumber = parameters.trialNumber;
analysisdata.subjectID = parameters.subjectID;
analysisdata.firingRateByPhase = firingRateByPhase;
analysisdata.spikeWaveforms = spikeWaveforms;
analysisdata.spikeTimestamps = spikeTimestamps;




% firingRateByPhase does not care about the type. now reshape to fit how
% each type varies.
evalPhaseDensityStr = 'phaseDensity  = zeros(numRepeats,numPhaseBins,';
evalStimStr = 'stimByType  = zeros(numRepeats,';
evalSpikeCountStr = 'spikeCountByType  = zeros(numRepeats,';
for sweptNo = 1:numSweptParams
    numSweptValsCurr = length(valsSwept{sweptNo});
    evalPhaseDensityStr = [evalPhaseDensityStr sprintf('%d,',numSweptValsCurr)];
    evalStimStr = [evalStimStr sprintf('%d,',numSweptValsCurr)];
    evalSpikeCountStr = [evalSpikeCountStr sprintf('%d,',numSweptValsCurr)];
end
evalPhaseDensityStr(end) = []; evalPhaseDensityStr = [evalPhaseDensityStr ');'];
evalStimStr = [evalStimStr 'duration);'];
evalSpikeCountStr = [evalSpikeCountStr 'duration);'];

try
    eval(evalPhaseDensityStr);
    eval(evalStimStr);
    eval(evalSpikeCountStr);
catch
    memory
end


% for storage in cumulative data....sort the relevant fields
stimInfo.pixPerCycs = sort(unique(pixPerCycs));
stimInfo.driftfrequencies = sort(unique(driftfrequencies));
stimInfo.orientations = sort(unique(orientations));
stimInfo.contrasts = sort(unique(contrasts));
stimInfo.startPhases = sort(unique(startPhases));
stimInfo.durations = sort(unique(durations));
stimInfo.radii = sort(unique(radii));
stimInfo.annuli = sort(unique(annuli));


% translate firingRateByPhase to phaseDensity
for i = 1:numRepeats
    for j = 1: numPhaseBins
        for k = 1:numTypes
            % firingRateByPhase(i,j,k) is the corresponding data
            % location on phaseDensity has to be determined
            evalStrpD = 'phaseDensity(i,j,';
            evalStrStim = 'stimByType(i,';
            evalStrSpike = 'spikeCountByType(i,';
            for sweptNo = 1:numSweptParams
                sweptParamName = sweptParameters{sweptNo};
                locationAtSweptParam = eval(sprintf('find(stimInfo.%s==%s(k))',sweptParamName,sweptParamName));
                evalStrpD = [evalStrpD sprintf('%d,',locationAtSweptParam)];
                evalStrStim = [evalStrStim sprintf('%d,',locationAtSweptParam)];
                evalStrSpike =[evalStrSpike sprintf('%d,',locationAtSweptParam)];
            end
            evalStrpD(end) = [];
            evalStrpD = [evalStrpD ') = firingRateByPhase(i,j,k);'];
            evalStrStim = [evalStrStim ':) = stimUntyped(i,k,:);'];
            evalStrSpike = [evalStrSpike ':) = spikeCountUntyped(i,k,:);'];
            eval(evalStrpD);
            eval(evalStrStim);
            eval(evalStrSpike);            
        end
    end
end
analysisdata.phaseDensity = phaseDensity;

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
    analysisdata.eyeData = eyeSig;
end

%% now update cumulativedata
if isempty(cumulativedata)
    cumulativedata.trialNumbers = parameters.trialNumber;
    cumulativedata.subjectID = parameters.subjectID;
    cumulativedata.stimInfo = stimInfo;
    cumulativedata.phaseDensity = phaseDensity; % i shall not store firingRateByPhase in cumulative
    cumulativedata.stimByType = stimByType;
    cumulativedata.spikeCountByType = spikeCountByType;
    cumulativedata.spikeWaveforms = spikeWaveforms;
    cumulativedata.spikeTimestamps = spikeTimestamps;
    cumulativedata.eyeData = eyeSig;
elseif ~isequal(rmfield(cumulativedata.stimInfo,'numRepeats'),rmfield(stimInfo,'numRepeats')) 
    keyboard    
    error('something mighty fishy going on here.is it just an issue to do with repeats?');       
    
else % now concatenate only along the first dimension of phaseDensity and other stuff
    cumulativedata.trialNumbers = [cumulativedata.trialNumbers;parameters.trialNumber];
    cumulativedata.phaseDensity = [cumulativedata.phaseDensity;phaseDensity];
    cumulativedata.stimByType = [cumulativedata.stimByType;stimByType];
    cumulativedata.spikeCountByType = [cumulativedata.spikeCountByType;spikeCountByType];
    cumulativedata.spikeWaveforms = [cumulativedata.spikeWaveforms;spikeWaveforms];
    cumulativedata.spikeTimestamps = [cumulativedata.spikeTimestamps;spikeTimestamps];
    cumulativedata.eyeData = [cumulativedata.eyeData;eyeSig];
end

%% all details that are necessary to be plotted will be calculated in displayCumulativePhysAnalysis

% events(events>possibleEvents)=possibleEvents % note: more than one spike could occur per frame, so not really binomial
% [pspike pspikeCI]=binofit(events,possibleEvents);

% fullRate=events./possibleEvents;
% fullRateThis = eventsThis./possibleEventsThis;
% rate=reshape(sum(events,1)./sum(possibleEvents,1),numTypesThis,numPhaseBins); % combine repetitions
% rateThis = reshape(sum(eventsThis,1)./sum(possibleEventsThis,1),numTypesThis,numPhaseBins);
% 
% [repInds typeInds]=find(isnan(pow));
% [repIndsThis typeIndsThis] = find(isnan(powThis));
% 
% pow(unique(repInds),:)=[];   % remove reps with bad power estimates
% coh(unique(repInds),:)=[];   % remove reps with bad power estimates
% cohLB(unique(repInds),:)=[]; % remove reps with bad power estimates
% 
% powThis(unique(repIndsThis),:)=[];   % remove reps with bad power estimates
% cohThis(unique(repIndsThis),:)=[];   % remove reps with bad power estimates
% cohLBThis(unique(repIndsThis),:)=[]; % remove reps with bad power estimates
% 
% if numRepeatsThis>2
%     rateSEM=reshape(std(events(1:end-1,:,:)./possibleEvents(1:end-1,:,:)),numTypesThis,numPhaseBins)/sqrt(numRepeatsThis-1);
%     rateSEMThis=reshape(std(eventsThis(1:end-1,:,:)./possibleEventsThis(1:end-1,:,:)),numTypesThis,numPhaseBins)/sqrt(numRepeatsThis-1);
% else
%     rateSEM=nan(size(rate));
%     rateSEMThis = nan(size(rate));
% end
% 
% if size(pow,1)>1
%     powSEM=std(pow)/sqrt(size(pow,1));
%     pow=mean(pow);
%     
%     cohSEM=std(coh)/sqrt(size(coh,1));
%     coh=mean(coh);
%     cohLB=mean(cohLB);  % do you really want the mean of the lower bound?
% else
%     powSEM=nan(1,size(pow,2));
%     cohSEM=nan(1,size(pow,2));
%     cohLB_SEM=nan(1,size(pow,2));
% end
% 
% if size(powThis,1)>1
%     powSEMThis=std(powThis)/sqrt(size(powThis,1));
%     powThis=mean(powThis);
%     
%     cohSEMThis=std(cohThis)/sqrt(size(cohThis,1));
%     cohThis=mean(cohThis);
%     cohLBThis=mean(cohLBThis);  % do you really want the mean of the lower bound?
% else
%     powSEMThis=nan(1,size(powThis,2));
%     cohSEMThis=nan(1,size(powThis,2));
%     cohLB_SEMThis=nan(1,size(powThis,2));
% end

% cumulativedata.numPhaseBins = numPhaseBins;
% cumulativedata.phaseDensity = phaseDensity;
% cumulativedata.pow = pow;
% cumulativedata.coh = coh;
% cumulativedata.cohLB = cohLB;
% cumulativedata.rate = rate;
% cumulativedata.rateSEM = rateSEM;
% cumulativedata.powSEM = powSEM;
% cumulativedata.cohSEM = cohSEM;
% cumulativedata.cohLB = cohLB;
% cumulativedata.ISIviolationMS = parameters.ISIviolationMS;
% cumulativedata.eyeData = [];
% cumulativedata.refreshRate = parameters.refreshRate;
% cumulativedata.samplingRate = parameters.samplingRate;


% if ~isfield(cumulativedata,'spikeWaveforms')
%     cumulativedata.spikeWaveforms = spikeWaveformsThis;
%     cumulativedata.spikeTimestamps = spikeTimestampsThis;
% else
%     cumulativedata.spikeWaveforms = [cumulativedata.spikeWaveforms;spikeWaveformsThis];
%     cumulativedata.spikeTimestamps = [cumulativedata.spikeTimestamps;spikeTimestampsThis];
% end
    
% analysisdata.phaseDensity = phaseDensityThis;
% analysisdata.pow = powThis;
% analysisdata.coh = cohThis;
% analysisdata.cohLB = cohLBThis;
% analysisdata.rate = rateThis;
% analysisdata.rateSEM = rateSEMThis;
% analysisdata.powSEM = powSEMThis;
% analysisdata.cohSEM = cohSEMThis;
% analysisdata.cohLB = cohLBThis;
% analysisdata.trialNumber = parameters.trialNumber;
% analysisdata.ISIviolationMS = parameters.ISIviolationMS;
% analysisdata.spikeWaveforms = spikeWaveformsThis;

end

% function [chunkStartFrame chunkEndFrame trialsByChunk...
%     stimFrames spikeCount phases type repeat trials cumulativedata]...
%     = getCompleteRecords(chunkStartFrameThis, chunkEndFrameThis, trialsByChunkThis,...
%     stimFramesThis,spikeCountThis,phasesThis,typeThis,repeatThis,trialsThis,cumulativedata)
% if ~isfield(cumulativedata,'chunkStartFrame')
%     chunkStartFrame = chunkStartFrameThis;
%     chunkEndFrame = chunkEndFrameThis;
%     trialsByChunk = trialsByChunkThis;
%     stimFrames = stimFramesThis;
%     spikeCount = spikeCountThis;
%     phases = phasesThis;
%     type = typeThis;
%     repeat = repeatThis;
%     trials = trialsThis;
%     % update the cumulativedata
%     cumulativedata.chunkStartFrame = chunkStartFrame;
%     cumulativedata.chunkEndFrame = chunkEndFrame;
%     cumulativedata.trialsByChunk = trialsByChunk;
%     cumulativedata.stimFrames = stimFrames;
%     cumulativedata.spikeCount = spikeCount;
%     cumulativedata.phases = phases;
%     cumulativedata.type = type;
%     cumulativedata.repeat = repeat;
%     cumulativedata.trials = trials;
% else
%     chunkStartFrame = [cumulativedata.chunkStartFrame; chunkStartFrameThis];
%     chunkEndFrame = [cumulativedata.chunkEndFrame; chunkEndFrameThis];
%     trialsByChunk = [cumulativedata.trialsByChunk; trialsByChunkThis];
%     stimFrames = [cumulativedata.stimFrames; stimFramesThis];
%     spikeCount = [cumulativedata.spikeCount; spikeCountThis];
%     phases = [cumulativedata.phases; phasesThis];
%     type = [cumulativedata.type; typeThis];
%     repeat = [cumulativedata.repeat; repeatThis];
%     trials = [cumulativedata.trials; trialsThis];
%     % update the cumulativedata
%     cumulativedata.chunkStartFrame = chunkStartFrame;
%     cumulativedata.chunkEndFrame = chunkEndFrame;
%     cumulativedata.trialsByChunk = trialsByChunk;
%     cumulativedata.stimFrames = stimFrames;
%     cumulativedata.spikeCount = spikeCount;
%     cumulativedata.phases = phases;
%     cumulativedata.type = type;
%     cumulativedata.repeat = repeat;
%     cumulativedata.trials = trials;
% end
% 
% end
