function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] =...
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,...
    responsePorts,totalPorts,trialRecords,compiledRecords)
% see ratrixPath\documentation\stimManager.calcStim.txt for argument specification (applies to calcStims of all stimManagers)
% 1/3/0/09 - trialRecords now includes THIS trial
trialManagerClass=class(trialManager);
indexPulses=[];
imagingTasks=[];
LUTbits
displaySize
[LUT stimulus updateSM]=getLUT(stimulus,LUTbits);
% [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[100 60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
[resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[100 60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));

OLED=false;
if OLED
    error('forced to 60 Hz... do you realize that?')
    desiredWidth=800;
    desiredHeight=600;
    desiredHertz=60;
    ratrixEnforcedColor=32;
    resolutionIndex=find(([resolutions.height]==desiredHeight) & ([resolutions.width]==desiredWidth) & ([resolutions.pixelSize]==ratrixEnforcedColor) & ([resolutions.hz]==desiredHertz));
    height=resolutions(resolutionIndex).height
    width=resolutions(resolutionIndex).width
    hz=resolutions(resolutionIndex).hz
    if getMaxWidth(stimulus)~=desiredWidth
        getMaxWidth(stimulus)
        desiredWidth
        error('not expected for OLED')
    end
end

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



background = stimulus.background;
method = stimulus.method;
requestedStimLocation = stimulus.requestedStimLocation;
stixelSize = stimulus.stixelSize;
searchSubspace = stimulus.searchSubspace;


numFrames = stimulus.numFrames;
% numFrames can be empty. What to do if that is the case?
if ~isempty(numFrames) 
    % duration and frameDuration are not set. use hz to resolve this
    numSamples = numFrames;
    numFramesPerSample = 1;
    duration = numFrames/hz;
    frameDuration = 1/hz;
else 
    % here we need to worry about the correspondence between frameDuration and 1/hz
    % make frameDuration an integral multiple of 1/hz;
    frameDuration = stimulus.frameDuration;
    frameDuration = round(frameDuration/(1/hz))*(1/hz);
    duration = stimulus.duration;
    numSamples = round(duration/frameDuration);
    numFramesPerSample = round(frameDuration*hz);
    numFrames = numFramesPerSample*numSamples;
    % things change based on requested and actual frameduration and
    % duration
    frameDuration = numFramesPerSample/hz;
    duration = numSamples*frameDuration;
end

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
spatialDim=stimulus.spatialDim;% =ceil([requestedStimLocation(3)-requestedStimLocation(1) requestedStimLocation(4)-requestedStimLocation(2)]./stixelSize);

% 10/31/08 - dynamic mode stim is a struct of parameters
stim = [];
stim.height = min(height,getMaxHeight(stimulus));
stim.width = min(width,getMaxWidth(stimulus));
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


switch stimulus.distribution.type
    case 'binary'
        whichNum = randperm(length(stimulus.distribution.lowVal));
        stim.distribution.type = 'binary';
        stim.distribution.lowVal = stimulus.distribution.lowVal(whichNum(1));
        stim.distribution.hiVal = stimulus.distribution.hiVal(whichNum(1));
    case 'gaussian'
        whichNum = randperm(length(stimulus.distribution.std));
        stim.distribution.type = 'gaussian';
        stim.distribution.meanLuminance = stimulus.distribution.meanLuminance;
        stim.distribution.std = stimulus.distribution.std(whichNum(1));
end

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
preResponseStim.punishResponses=false;

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
details.distribution = stim.distribution;
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
% =============================

% ================================================================================
if strcmp(trialManagerClass,'nAFC') && details.correctionTrial
    text='correction trial!';
else
    text=sprintf('whiteNoise: %s',stimulus.patternType);
end