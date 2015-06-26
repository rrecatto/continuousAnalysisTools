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
    case {'A41F7278B4DE','A41F729213E2','A41F726EC11C' } %gLab-Behavior rigs 1,2,3
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
    case {'7845C4256F4C', '7845C42558DF','A41F729211B1'} %gLab-Behavior rigs 4,5,6
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
    otherwise 
        [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
end

if isnan(resolutionIndex)
    resolutionIndex=1;
end

scaleFactor=getScaleFactor(stimulus); % dummy value since we are phased anyways; the real scaleFactor is stored in each phase's stimSpec
interTrialLuminance = getInterTrialLuminance(stimulus); 

interTrialDuration = getInterTrialDuration(stimulus);

details.pctCorrectionTrials=getPercentCorrectionTrials(trialManager); % need to change this to be passed in from trial manager
if ~isempty(trialRecords) && length(trialRecords)>=2
    lastRec=trialRecords(end-1);
else
    lastRec=[];
end
[targetPorts, distractorPorts, details]=assignPorts(details,lastRec,responsePorts,trialManagerClass,allowRepeats);


toggleStim=true; type='expert';
dynamicMode = true; %false %true

% set up params for computeGabors
height = min(height,getMaxHeight(stimulus));
width = min(width,getMaxWidth(stimulus));

% lets save some of the details for later
possibleStims.numDots        = stimulus.numDots;
possibleStims.bkgdNumDots    = stimulus.bkgdNumDots;
possibleStims.dotCoherence   = stimulus.dotCoherence;
possibleStims.bkgdCoherence  = stimulus.bkgdCoherence;
possibleStims.dotSpeed       = stimulus.dotSpeed;
possibleStims.bkgdSpeed      = stimulus.bkgdSpeed;
possibleStims.dotDirection   = stimulus.dotDirection;
possibleStims.bkgdDirection  = stimulus.bkgdDirection;
possibleStims.dotColor       = stimulus.dotColor;
possibleStims.bkgdDotColor   = stimulus.bkgdDotColor;
possibleStims.dotSize        = stimulus.dotSize;
possibleStims.bkgdSize       = stimulus.bkgdSize;
possibleStims.dotShape       = stimulus.dotShape;
possibleStims.bkgdShape      = stimulus.bkgdShape;
possibleStims.renderMode     = stimulus.renderMode;
possibleStims.maxDuration    = stimulus.maxDuration;
possibleStims.background     = stimulus.background;
possibleStims.doCombos       = stimulus.doCombos;
details.possibleStims        = possibleStims;
details.afcCoherentDotsType  = getType(stimulus,structize(stimulus));

% whats the chosen stim?
if targetPorts==1
    chosenStimIndex = 1;
elseif targetPorts==3
    chosenStimIndex = 2;
else
    error('cannot support this here')
end

stim = [];


stim.height = height;
stim.width = width;
stim.rngMethod = stimulus.ordering.method;
if isempty(stimulus.ordering.seed)
    stim.seedVal = sum(100*clock);
end

if stimulus.doCombos    
    % numDots
    tempVar = randperm(length(stimulus.numDots{chosenStimIndex}));
    stim.numDots = stimulus.numDots{chosenStimIndex}(tempVar(1));
    
    % bkgdNumDots
    tempVar = randperm(length(stimulus.bkgdNumDots{chosenStimIndex}));
    stim.bkgdNumDots = stimulus.bkgdNumDots{chosenStimIndex}(tempVar(1));
    
    % dotCoherence
    tempVar = randperm(length(stimulus.dotCoherence{chosenStimIndex}));
    stim.dotCoherence = stimulus.dotCoherence{chosenStimIndex}(tempVar(1));
    
    % bkgdCoherence
    tempVar = randperm(length(stimulus.bkgdCoherence{chosenStimIndex}));
    stim.bkgdCoherence = stimulus.bkgdCoherence{chosenStimIndex}(tempVar(1));
    
    % dotSpeed
    tempVar = randperm(length(stimulus.dotSpeed{chosenStimIndex}));
    stim.dotSpeed = stimulus.dotSpeed{chosenStimIndex}(tempVar(1));
    
    % bkgdSpeed
    tempVar = randperm(length(stimulus.bkgdSpeed{chosenStimIndex}));
    stim.bkgdSpeed = stimulus.bkgdSpeed{chosenStimIndex}(tempVar(1));
    
    % dotDirection
    tempVar = randperm(length(stimulus.dotDirection{chosenStimIndex}));
    stim.dotDirection = stimulus.dotDirection{chosenStimIndex}(tempVar(1));
    
    % bkgdDirection
    tempVar = randperm(length(stimulus.bkgdDirection{chosenStimIndex}));
    stim.bkgdDirection = stimulus.bkgdDirection{chosenStimIndex}(tempVar(1));
    
    % dotColor
    tempVar = randperm(size(stimulus.dotColor{chosenStimIndex},1));
    stim.dotColor = stimulus.dotColor{chosenStimIndex}(tempVar(1),:);
    
    % bkgdDotColor
    tempVar = randperm(size(stimulus.bkgdDotColor{chosenStimIndex},1));
    stim.bkgdDotColor = stimulus.bkgdDotColor{chosenStimIndex}(tempVar(1),:);
    
    % dotSize
    tempVar = randperm(length(stimulus.dotSize{chosenStimIndex}));
    stim.dotSize = stimulus.dotSize{chosenStimIndex}(tempVar(1));
    
    % bkgdSize
    tempVar = randperm(length(stimulus.bkgdSize{chosenStimIndex}));
    stim.bkgdSize = stimulus.bkgdSize{chosenStimIndex}(tempVar(1));
    
    % dotShape
    tempVar = randperm(length(stimulus.dotShape{chosenStimIndex}));
    stim.dotShape = stimulus.dotShape{chosenStimIndex}(tempVar(1));
    
    % bkgdShape
    tempVar = randperm(length(stimulus.bkgdShape{chosenStimIndex}));
    stim.bkgdShape = stimulus.bkgdShape{chosenStimIndex}(tempVar(1));
    
    % renderMode
    stim.renderMode = stimulus.renderMode;
    
    % maxDuration
    tempVar = randperm(length(stimulus.maxDuration{chosenStimIndex}));
    if ~ismac
        stim.maxDuration = round(stimulus.maxDuration{chosenStimIndex}(tempVar(1))*hz);
    elseif ismac && hz==0
        % macs are weird and return a hz of 0 when they really
        % shouldnt. assume hz = 60 (hack)
        stim.maxDuration = round(stimulus.maxDuration{chosenStimIndex}(tempVar(1))*60);
    end
    
    % background
    stim.background = stimulus.background;
    
    % doCombos
    stim.doCombos = stimulus.doCombos;
    
else
        % numDots
    tempVar = randperm(length(stimulus.numDots{chosenStimIndex}));
    which = tempVar(1);
    
    stim.numDots = stimulus.numDots{chosenStimIndex}(which);
    stim.bkgdNumDots = stimulus.bkgdNumDots{chosenStimIndex}(which);
    stim.dotCoherence = stimulus.dotCoherence{chosenStimIndex}(which);
    stim.bkgdCoherence = stimulus.bkgdCoherence{chosenStimIndex}(which);
    stim.dotSpeed = stimulus.dotSpeed{chosenStimIndex}(which);
    stim.bkgdSpeed = stimulus.bkgdSpeed{chosenStimIndex}(which);
    stim.dotDirection = stimulus.dotDirection{chosenStimIndex}(which);
    stim.bkgdDirection = stimulus.bkgdDirection{chosenStimIndex}(which);
    stim.dotColor = stimulus.dotColor{chosenStimIndex}(which,:);
    stim.bkgdDotColor = stimulus.bkgdDotColor{chosenStimIndex}(which,:);
    stim.dotSize = stimulus.dotSize{chosenStimIndex}(which);
    stim.bkgdSize = stimulus.bkgdSize{chosenStimIndex}(which);
    stim.dotShape = stimulus.dotShape{chosenStimIndex}(which);
    stim.bkgdShape = stimulus.bkgdShape{chosenStimIndex}(which);
    
    % waveform
    stim.renderMode = stimulus.renderMode;

    if ~ismac
        stim.maxDuration = round(stimulus.maxDuration{chosenStimIndex}(which)*hz);
    elseif ismac && hz==0
        % macs are weird and return a hz of 0 when they really
        % shouldnt. assume hz = 60 (hack)
        stim.maxDuration = round(stimulus.maxDuration{chosenStimIndex}(which)*60);
    end
    
    % background
    stim.background = stimulus.background;
    
    % doCombos
    stim.doCombos = stimulus.doCombos;

end


% have a version in ''details''
details.doCombos       = stimulus.doCombos;
details.numDots        = stim.numDots;
details.bkgdNumDots    = stim.bkgdNumDots;
details.dotCoherence   = stim.dotCoherence;
details.bkgdCoherence  = stim.bkgdCoherence;
details.dotSpeed       = stim.dotSpeed;
details.bkgdSpeed      = stim.bkgdSpeed;
details.dotDirection   = stim.dotDirection;
details.bkgdDirection  = stim.bkgdDirection;
details.dotColor       = stim.dotColor;
details.bkgdDotColor   = stim.bkgdDotColor;
details.dotSize        = stim.dotSize;
details.bkgdSize       = stim.bkgdSize;
details.dotShape       = stim.dotShape;
details.bkgdShape      = stim.bkgdShape;
details.renderMode     = stim.renderMode;
details.maxDuration    = stim.maxDuration;
details.background     = stim.background;
details.rngMethod      = stim.rngMethod;
details.seedVal        = stim.seedVal;
details.height         = stim.height;
details.width          = stim.width;


if isinf(stim.maxDuration)
    timeout=[];
else
    timeout=stim.maxDuration;
end

switch stim.renderMode
    case 'perspective'
        % lets make the render distances work here
        stim.dotsRenderDistance = stimulus.renderDistance(1) + rand(stim.numDots,1)*(stimulus.renderDistance(2) - stimulus.renderDistance(1));
        stim.bkgdRenderDistance = stimulus.renderDistance(1) + rand(stim.bkgdNumDots,1)*(stimulus.renderDistance(2) - stimulus.renderDistance(1));
        
        details.dotsRenderDistance = stim.dotsRenderDistance;
        details.bkgdRenderDistance = stim.bkgdRenderDistance;
    case 'flat'
        % lets make the render distances work here
        stim.dotsRenderDistance = ones(stim.numDots,1);
        stim.bkgdRenderDistance = ones(stim.bkgdNumDots,1);
        
        details.dotsRenderDistance = stim.dotsRenderDistance;
        details.bkgdRenderDistance = stim.bkgdRenderDistance;
end

% LEDParams
[details, stim] = setupLED(details, stim, stimulus.LEDParams);


discrimStim=[];
discrimStim.stimulus=stim;
discrimStim.stimType=type;
discrimStim.scaleFactor=scaleFactor;
discrimStim.startFrame=0;
discrimStim.autoTrigger=[];
if isnan(timeout)
    sca;
    keyboard;
end
discrimStim.framesUntilTimeout=timeout;

preRequestStim=[];
preRequestStim.stimulus=interTrialLuminance;
preRequestStim.stimType='loop';
preRequestStim.scaleFactor=0;
preRequestStim.startFrame=0;
preRequestStim.autoTrigger=[];
preRequestStim.punishResponses=false;

preResponseStim = [];

if stimulus.doPostDiscrim
    postDiscrimStim = preRequestStim;
else
    postDiscrimStim = [];
end

interTrialStim.duration = interTrialDuration;
details.interTrialDuration = interTrialDuration;
details.stimManagerClass = class(stimulus);
details.trialManagerClass = trialManagerClass;
details.scaleFactor = scaleFactor;

if strcmp(trialManagerClass,'nAFC') && details.correctionTrial
    text='correction trial!';
else
    text=sprintf('coh: %g',stim.dotCoherence);
end