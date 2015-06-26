function [analysisdata cumulativedata] = physAnalysis(stimManager,spikeRecord,stimulusDetails,plotParameters,parameters,cumulativedata,eyeData,LFPRecord)


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
    comboMatrix = generateFactorialCombo({stimulusDetails.frequencies,stimulusDetails.contrasts,stimulusDetails.durations,stimulusDetails.radii,stimulusDetails.annuli},[],[],mode);
    
    frequencies=comboMatrix(1,:);
    contrasts=comboMatrix(2,:); %starting phases in radians
    durations=round(comboMatrix(3,:)*parameters.refreshRate); % CONVERTED FROM seconds to frames
    radii=comboMatrix(4,:);
    annuli=comboMatrix(5,:);
    
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
    [length(unique(frequencies)) length(unique(contrasts)) length(unique(durations))...
    length(unique(radii))  length(unique(annuli))];

%% find which parameters are swept
names={'frequencies','contrasts','durations','radii','annuli'};

sweptParameters = names(find(numValsPerParam>1));
numSweptParams = length(sweptParameters);
valsSwept = cell(length(sweptParameters),0);
for sweptNo = 1:length(find(numValsPerParam>1))
    valsSwept{sweptNo} = eval(sweptParameters{sweptNo});
end

% durations of each condition should be unique
if length(unique(durations))==1
    duration=unique(durations);
else
    error('multiple durations can''t rely on mod to determine the frame type')
end

stimInfo.stimulusDetails = stimulusDetails;
stimInfo.refreshRate = parameters.refreshRate;
stimInfo.sweptParameters = sweptParameters;
stimInfo.numSweptParams = numSweptParams;
stimInfo.valsSwept = valsSwept;
stimInfo.numTypes = numTypes;

%% to begin with no attempt will be made to group acording to type
typesUnordered=repmat([1:numTypes],duration,numRepeats);
typesUnordered=typesUnordered(stimFrames); % vectorize matrix and remove extras
repeats = reshape(repmat([1:numRepeats],[duration*numTypes 1]),[duration*numTypes*numRepeats 1]);
repeats = repeats(stimFrames);
samplingRate=parameters.samplingRate;

% calc phase per frame, just like dynamic
cycsPerFrameVel = frequencies(typesUnordered)*1/(parameters.refreshRate); % in units of cycles/frame
risingPhases = 2*pi*cycsPerFrameVel.*stimFrames';
phases=mod(risingPhases,2*pi); 
phases = phases';

% count the number of spikes per frame
% spikeCount is a 1xn vector of (number of spikes per frame), where n = number of frames
spikeCount=zeros(size(correctedFrameIndices,1),1);
for i=1:length(spikeCount) % for each frame
    spikeCount(i)=length(find(spikes>=correctedFrameIndices(i,1)&spikes<=correctedFrameIndices(i,2))); % inclusive?  policy: include start & stop
end
if numSweptParams>1
    error('unsupported case');
end
valsActual = valsSwept{1};
valsOrdered = sort(valsSwept{1});
types = nan(size(typesUnordered));
for i = 1:length(valsOrdered)
    types(typesUnordered==i) = find(valsOrdered==valsActual(i));
end



% update what we know about te analysis to analysisdata
analysisdata.stimInfo = stimInfo;
analysisdata.trialNumber = parameters.trialNumber;
analysisdata.subjectID = parameters.subjectID;
% here be the meat of the analysis
analysisdata.spikeCount = spikeCount;
analysisdata.phases = phases;
analysisdata.types = types;
analysisdata.repeats = repeats;

% analysisdata.firingRateByPhase = firingRateByPhase;
analysisdata.spikeWaveforms = spikeWaveforms;
analysisdata.spikeTimestamps = spikeTimestamps;


% for storage in cumulative data....sort the relevant fields
stimInfo.frequencies = sort(unique(frequencies));
stimInfo.contrasts = sort(unique(contrasts));
stimInfo.durations = sort(unique(durations));
stimInfo.radii = sort(unique(radii));
stimInfo.annuli = sort(unique(annuli));

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
else
    analysisdata.eyedata = [];
    eyeSig = [];
end

%% now update cumulativedata
if isempty(cumulativedata)
    cumulativedata.trialNumbers = parameters.trialNumber;
    cumulativedata.subjectID = parameters.subjectID;
    cumulativedata.stimInfo = stimInfo;
    cumulativedata.spikeCount = spikeCount; % i shall not store firingRateByPhase in cumulative
    cumulativedata.phases = phases;
    cumulativedata.types = types;
    cumulativedata.repeats = repeats;
    cumulativedata.spikeWaveforms = spikeWaveforms;
    cumulativedata.spikeTimestamps = spikeTimestamps;    
    cumulativedata.eyeData = eyeSig;
elseif ~isequal(rmfield(cumulativedata.stimInfo,{'stimulusDetails','refreshRate','valsSwept'}),rmfield(stimInfo,{'stimulusDetails','refreshRate','valsSwept'}))
    keyboard
    error('something mighty fishy going on here.is it just an issue to do with repeats?');
    
else % now concatenate only along the first dimension of phaseDensity and other stuff
    cumulativedata.trialNumbers = [cumulativedata.trialNumbers;parameters.trialNumber];
    cumulativedata.spikeCount = [cumulativedata.spikeCount;spikeCount]; % i shall not store firingRateByPhase in cumulative
    cumulativedata.phases = [cumulativedata.phases;phases];
    cumulativedata.types = [cumulativedata.types;types];
    repeats = repeats+max(cumulativedata.repeats);
    cumulativedata.repeats = [cumulativedata.repeats;repeats]; % repeats always gets added!
    cumulativedata.spikeWaveforms = [cumulativedata.spikeWaveforms;spikeWaveforms];
    cumulativedata.spikeTimestamps = [cumulativedata.spikeTimestamps;spikeTimestamps];
    cumulativedata.eyeData = [cumulativedata.eyeData;eyeSig];
end
end

