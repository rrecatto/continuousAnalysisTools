function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] =...
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,...
    responsePorts,totalPorts,trialRecords,compiledRecords)
% see ratrixPath\documentation\stimManager.calcStim.txt for argument specification (applies to calcStims of all stimManagers)
trialManagerClass = class(trialManager);
% 1/30/09 - trialRecords now includes THIS trial
indexPulses=[];
imagingTasks=[];
[LUT stimulus updateSM]=getLUT(stimulus,LUTbits);

[junk, mac] = getMACaddress();
switch mac
    case {'A41F7278B4DE','A41F729213E2','A41F726EC11C','A41F729211B1' } %gLab-Behavior rigs
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
    case {'7845C4256F4C', '7845C42558DF'}
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[50],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
    otherwise 
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
end

if isnan(resolutionIndex)
    resolutionIndex=1;
end

scaleFactor=getScaleFactor(stimulus); % dummy value since we are phased anyways; the real scaleFactor is stored in each phase's stimSpec
interTrialLuminance = getInterTrialLuminance(stimulus); 
interTrialDuration = getInterTrialDuration(stimulus);

details.pctCatchTrials=getPercentCatchTrials(trialManager); % need to change this to be passed in from trial manager
if ~isempty(trialRecords) && length(trialRecords)>=2
    lastRec=trialRecords(end-1);
else
    lastRec=[];
end
[targetPorts distractorPorts details]=assignPorts(details,lastRec,responsePorts,trialManagerClass,allowRepeats); %% xx needs work
targetPorts = [1];
distractorPorts =[3];

toggleStim=true; type='expert';
dynamicMode = true; %false %true

% set up params for computeGabors
height = min(height,getMaxHeight(stimulus));
width = min(width,getMaxWidth(stimulus));

% lets get the stimuli corresponding to the different parts calculated
[stimulus1,~,~,~,~,discrimStim1,~,~,~,~,~,details1,~,~,~,imagingTasks1] =...
    calcStim(stimulus.stim1,trialManager,allowRepeats,resolutions,displaySize,LUTbits,responsePorts,totalPorts,trialRecords);

[stimulus2,~,~,~,~,discrimStim2,~,~,~,~,~,details2,~,~,~,imagingTasks2] =...
    calcStim(stimulus.stim2,trialManager,allowRepeats,resolutions,displaySize,LUTbits,responsePorts,totalPorts,trialRecords);

% normalizationMethod,mean,thresh,height,width,scaleFactor,interTrialLuminance

preRequestStim=[];
preRequestStim.stimulus=interTrialLuminance;
preRequestStim.stimType='loop';
preRequestStim.scaleFactor=0;
preRequestStim.startFrame=0;
preRequestStim.autoTrigger=[];
preRequestStim.punishResponses=false;

[details1, stimulus1] = setupLED(details1, stimulus1, getLEDParams(stimulus1));

preResponseStim = [];
preResponseStim.stimulus.stimObject=stimulus1;
preResponseStim.stimulus.details=details1;
preResponseStim.stimulus.height=height;
preResponseStim.stimulus.width = width;
preResponseStim.stimType='expert';
preResponseStim.scaleFactor=scaleFactor;
preResponseStim.startFrame=0;
preResponseStim.autoTrigger=[];
preResponseStim.punishResponses=false;
try
preResponseStim.framesUntilTimeout=ceil(sampleDistribution(stimulus,'durationToFlip')*hz);
catch
    sca;
    keyboard
end

% LEDParams

% [details, stimulus2] = setupLED(details, stimulus2, getLEDParams(stimulus2));


discrimStim=[];
% if rand<stimulus.pCatchTrial
%     discrimStim = [];
%     details.isCatchTrial = true;
% else
    discrimStim.stimulus.stimObject=stimulus2;
    discrimStim.stimulus.details=details2;
    discrimStim.stimulus.height=height;
    discrimStim.stimulus.width = width;
    discrimStim.stimType='expert';
    discrimStim.scaleFactor=scaleFactor;
    discrimStim.startFrame=0;
    discrimStim.autoTrigger=[];
    discrimStim.framesUntilTimeout=ceil(sampleDistribution(stimulus,'durationAfterFlip')*hz);
    details.isCatchTrial = false;
% end

postDiscrimStim = [];

interTrialStim.duration = interTrialDuration;

details.interTrialDuration = interTrialDuration;
details.stimManagerClass = class(stimulus);
details.trialManagerClass = trialManagerClass;
details.scaleFactor = scaleFactor;
% 
% if strcmp(trialManagerClass,'nAFC') && details.correctionTrial
%     text='correction trial!';
% else
%     text=sprintf('thresh: %g',stimulus.thresh);
% end
text = 'not important';