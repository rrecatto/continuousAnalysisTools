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


numFrames = stimulus.stimSpec.numStimuli*stimulus.stimSpec.numFramesPerStim;

stim.contrasts = nan(1,numFrames);
stim.radius= nan(1,numFrames);

stim.location = stimulus.stimSpec.location;

switch stimulus.stimSpec.type
    case 'sequential'
        switch stimulus.stimSpec.contrastSpace{3}
            case 'logspace'
                contrasts = logspace(log10(stimulus.stimSpec.contrastSpace{1}), log10(stimulus.stimSpec.contrastSpace{2}), stimulus.stimSpec.numStimuli);
            case 'linspace'
                contrasts = linspace(stimulus.stimSpec.contrastSpace{1}, stimulus.stimSpec.contrastSpace{2}, stimulus.stimSpec.numStimuli);
        end
        contrasts = repmat(contrasts,stimulus.stimSpec.numFramesPerStim,1);
        stim.contrasts = reshape(contrasts,1,numFrames);
        
        switch stimulus.stimSpec.radiusSpace{3}
            case 'logspace'
                radii = logspace(log10(stimulus.stimSpec.radiusSpace{1}), log10(stimulus.stimSpec.radiusSpace{2}), stimulus.stimSpec.numStimuli);
            case 'linspace'
                radii = linspace(stimulus.stimSpec.radiusSpace{1}, stimulus.stimSpec.radiusSpace{2}, stimulus.stimSpec.numStimuli);
        end
        radii = repmat(radii,stimulus.stimSpec.numFramesPerStim,1);
        stim.radii = reshape(radii,1,numFrames);
    case 'random'
        error('not yet')
end
% 10/31/08 - dynamic mode stim is a struct of parameters

stim.height = min(height,getMaxHeight(stimulus));
stim.width = min(width,getMaxWidth(stimulus));

% LEDParams

[details, stim] = setupLED(details, stim, stimulus.LEDParams);

discrimStim=[];
discrimStim.stimulus=stim;
discrimStim.stimType=type;
discrimStim.scaleFactor=scaleFactor;
discrimStim.startFrame=0;
discrimStim.autoTrigger=[];
discrimStim.framesUntilTimeout=numFrames;

preRequestStim=[];
preRequestStim.stimulus=interTrialLuminance;
preRequestStim.stimType='loop';
preRequestStim.scaleFactor=0;
preRequestStim.startFrame=0;
preRequestStim.autoTrigger=[];
preRequestStim.punishResponses=false;

postDiscrimStim = [];
preResponseStim = [];

interTrialStim.duration = interTrialDuration;
details.interTrialDuration = interTrialDuration;
% details.big = {'expert', stim.seedValues}; % store in 'big' so it gets written to file
% variables to be stored for recalculation of stimulus from seed value for rand generator
details.strategy='expert';
details.contrasts = stim.contrasts;
details.radii =stim.radii;
details.numFrames=numFrames;
if isempty(numFrames)
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
    text=sprintf('contrastSequece');
end