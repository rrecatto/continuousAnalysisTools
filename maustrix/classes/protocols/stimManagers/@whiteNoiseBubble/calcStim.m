function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] =...
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,responsePorts,totalPorts,trialRecords,compiledRecords)
% see ratrixPath\documentation\stimManager.calcStim.txt for argument specification (applies to calcStims of all stimManagers)
% 1/3/0/09 - trialRecords now includes THIS trial
trialManagerClass=class(trialManager);
indexPulses=[];
imagingTasks=[];
LUTbits
displaySize
[LUT stimulus updateSM]=getLUT(stimulus,LUTbits);
[resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));

if isnan(resolutionIndex)
    resolutionIndex=1;
end

toggleStim=true;
type = 'expert';
scaleFactor = getScaleFactor(stimulus);
interTrialLuminance = getInterTrialLuminance(stimulus); 
interTrialDuration = getInterTrialDuration(stimulus);

details.pctCorrectionTrials=getPercentCorrectionTrials(trialManager);
if ~isempty(trialRecords) && length(trialRecords)>=2
    lastRec=trialRecords(end-1);
else
    lastRec=[];
end
[targetPorts distractorPorts details]=assignPorts(details,lastRec,responsePorts,trialManagerClass,allowRepeats);

% ================================================================================
% start calculating frames now

stixelSize = stimulus.stixelSize;

% numBubbles

stim = [];
if isnumeric(stimulus.bubbleLocations)
    numBubbles = size(stimulus.bubbleLocations,1);
    stim.bubbleLocations = stimulus.bubbleLocations;
else
    numBubbles = stimulus.bubbleLocations{2};
    % random locations
    stim.bubbleLocations = rand(numBubbles,2);
end

if strcmp(stimulus.bubbleOrder,'random')
    order = randperm(numBubbles);
    stim.bubbleLocations = stim.bubbleLocations(order,:);
end

stim.distribution = stimulus.distribution;


numFrames = stimulus.bubbleDuration*numBubbles*stimulus.bubbleNumRepeats;

% duration and frameDuration are not set. use hz to resolve this
numSamples = numFrames;
numFramesPerSample = 1;
duration = numFrames/hz;
frameDuration = 1/hz;

distribution = stimulus.distribution;
patternType=stimulus.patternType;
if isfield(stimulus,'randomizer')
    randomizer = stimulus.randomizer.method;
    initialSeed = stimulus.randomizer.seed;
else
    randomizer = 'twister';
    initialSeed = 'clock';
end
%calculate spatialDim
spatialDim=stimulus.spatialDim;

% 10/31/08 - dynamic mode stim is a struct of parameters

stim.height = min(height,getMaxHeight(stimulus));
stim.width = min(width,getMaxWidth(stimulus));

stim.LEDParam.LEDOnEveryFrame = false;
stim.LEDParam.LEDOffEveryFrame = false;
stim.LEDParam.LEDOnFirstFrame = false;
stim.LEDParam.LEDOffLastFrame = false;

% set seed values
if isnumeric(initialSeed)
    rand(randomizer,initialSeed);
else
    rand(randomizer,sum(100*clock)); % initialize randn to random starting state
end
% create the seedValues from numSamples & numFramesPerSample
seedVals = ceil(rand(1,numSamples)*1000000);
seedVals = repmat(seedVals,numFramesPerSample,1);
stim.seedValues = reshape(seedVals,1,numSamples*numFramesPerSample);
stim.bubbleDuration = stimulus.bubbleDuration;
stim.numBubbles = numBubbles;
stim.numRepeats = stimulus.bubbleNumRepeats;
stim.bubbleSize = stimulus.bubbleSize;

% LEDParams

[details, stim] = setupLED(details, stim, stimulus.LEDParams);

discrimStim=[];
discrimStim.stimulus=stim;
discrimStim.stimType=type;
discrimStim.scaleFactor=scaleFactor;
discrimStim.startFrame=0;
discrimStim.autoTrigger=[];
discrimStim.framesUntilTimeout=numFrames;
discrimStim.randomizer = randomizer;
discrimStim.seed = initialSeed;

preRequestStim=[];
preRequestStim.stimulus=interTrialLuminance;
preRequestStim.stimType='loop';
preRequestStim.scaleFactor=0;
preRequestStim.startFrame=0;
preRequestStim.autoTrigger=[];
preRequestStim.punishResponses=false;


preResponseStim=discrimStim;
postDiscrimStim = [];
preResponseStim = [];
interTrialStim.duration = interTrialDuration;
details.interTrialDuration = interTrialDuration;
% details.big = {'expert', stim.seedValues}; % store in 'big' so it gets written to file
% variables to be stored for recalculation of stimulus from seed value for rand generator
details.strategy='expert';
details.randomizer = randomizer;
details.seedValues=stim.seedValues;
details.spatialDim = spatialDim;
details.stixelSize = stixelSize;
details.patternType = patternType;
details.numBubbles = numBubbles;
details.bubbleLocations = stim.bubbleLocations;
details.bubbleSize = stimulus.bubbleSize;
details.bubbleDuration = stimulus.bubbleDuration;
details.bubbleNumRepeats = stimulus.bubbleNumRepeats;

 %details.std = stimulus.std;  % in distribution now.
 %details.meanLuminance = meanLuminance; % in distribution now.
details.distribution = distribution;
switch distribution.type
    case 'gaussian'
        % do nothing
    case'binary'
        sparcity = details.distribution.probability;
        minLum = details.distribution.hiVal;
        maxLum = details.distribution.lowVal;
        details.distribution.meanLuminance = ...
            sparcity*minLum+(1-sparcity)*maxLum;
        details.distribution.std = sparcity*(1-sparcity)*(minLum-maxLum);
end
details.numFrames=numFrames;
details.frameDuration = frameDuration;
details.duration = duration;
if isempty(stimulus.numFrames)
    details.repeatFramesON = true;
else
    details.repeatFramesON = false;
end
details.height=stim.height;
details.width=stim.width;
% ================================================================================
if strcmp(trialManagerClass,'nAFC') && details.correctionTrial
    text='correction trial!';
else
    text=sprintf('whiteNoise: %s',stimulus.patternType);
end