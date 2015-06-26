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

details.pctCorrectionTrials=getPercentCorrectionTrials(trialManager); % need to change this to be passed in from trial manager
if ~isempty(trialRecords) && length(trialRecords)>=2
    lastRec=trialRecords(end-1);
else
    lastRec=[];
end
[targetPorts distractorPorts details]=assignPorts(details,lastRec,responsePorts,trialManagerClass,allowRepeats);


toggleStim=true; type='expert';
dynamicMode = true; %false %true

% set up params for computeGabors
height = min(height,getMaxHeight(stimulus));
width = min(width,getMaxWidth(stimulus));

% lets save some of the details for later
possibleStims.pixPerCycsCenter          = stimulus.pixPerCycsCenter;
possibleStims.pixPerCycsSurround        = stimulus.pixPerCycsSurround;

possibleStims.driftfrequenciesCenter    = stimulus.driftfrequenciesCenter;
possibleStims.driftfrequenciesSurround  = stimulus.driftfrequenciesSurround;

possibleStims.orientationsCenter        = stimulus.orientationsCenter;
possibleStims.orientationsSurround      = stimulus.orientationsSurround;

possibleStims.phasesCenter              = stimulus.phasesCenter;
possibleStims.phasesSurround            = stimulus.phasesSurround;

possibleStims.contrastsCenter           = stimulus.contrastsCenter;
possibleStims.contrastsSurround         = stimulus.contrastsSurround;

possibleStims.waveform                  = stimulus.waveform;
possibleStims.maxDuration               = {stimulus.maxDuration{1}*hz,stimulus.maxDuration{2}*hz};

possibleStims.radiiCenter               = stimulus.radiiCenter;
possibleStims.radiiSurround             = stimulus.radiiSurround;

possibleStims.radiusType                = stimulus.radiusType;
possibleStims.location                  = stimulus.location;
possibleStims.normalizationMethod       = stimulus.normalizationMethod;
possibleStims.mean                      = stimulus.mean;
possibleStims.thresh                    = stimulus.thresh;
possibleStims.width                     = width;
possibleStims.height                    = height;
possibleStims.doCombos                  = stimulus.doCombos;
details.possibleStims                   = possibleStims;
details.afcGratingType                  = getType(stimulus,structize(stimulus));

% whats the chosen stim?
if stimulus.doCombos
    % choose a random value for each
    if length(targetPorts)==1
        stim = [];
        if targetPorts == 1 % the first of the possible values
            % pixPerCycsCenter
            tempVar = randperm(length(stimulus.pixPerCycsCenter{1}));
            stim.pixPerCycsCenter = stimulus.pixPerCycsCenter{1}(tempVar(1));
            
            % pixPerCycsSurround
            tempVar = randperm(length(stimulus.pixPerCycsSurround{1}));
            stim.pixPerCycsSurround = stimulus.pixPerCycsSurround{1}(tempVar(1));
            
            % driftfrequenciesCenter
            tempVar = randperm(length(stimulus.driftfrequenciesCenter{1}));
            stim.driftfrequenciesCenter = stimulus.driftfrequenciesCenter{1}(tempVar(1));
            
            % driftfrequenciesSurround
            tempVar = randperm(length(stimulus.driftfrequenciesSurround{1}));
            stim.driftfrequenciesSurround = stimulus.driftfrequenciesSurround{1}(tempVar(1));
            
            % orientationsCenter
            tempVar = randperm(length(stimulus.orientationsCenter{1}));
            stim.orientationsCenter = stimulus.orientationsCenter{1}(tempVar(1));
            
            % orientationsSurround
            tempVar = randperm(length(stimulus.orientationsSurround{1}));
            stim.orientationsSurround = stimulus.orientationsSurround{1}(tempVar(1));
            
            % phasesCenter
            tempVar = randperm(length(stimulus.phasesCenter{1}));
            stim.phasesCenter = stimulus.phasesCenter{1}(tempVar(1));
            
            % phasesSurround
            tempVar = randperm(length(stimulus.phasesSurround{1}));
            stim.phasesSurround = stimulus.phasesSurround{1}(tempVar(1));
            
            % contrastsCenter
            tempVar = randperm(length(stimulus.contrastsCenter{1}));
            stim.contrastsCenter = stimulus.contrastsCenter{1}(tempVar(1));
            
            % contrastsSurround
            tempVar = randperm(length(stimulus.contrastsSurround{1}));
            stim.contrastsSurround = stimulus.contrastsSurround{1}(tempVar(1));
            
            % waveform
            stim.waveform = stimulus.waveform;
            
            % maxDuration
            tempVar = randperm(length(stimulus.maxDuration{1}));
            if ~ismac
                stim.maxDuration = stimulus.maxDuration{1}(tempVar(1))*hz;
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = stimulus.maxDuration{1}(tempVar(1))*60;
            end
            
            % radiiCenter
            tempVar = randperm(length(stimulus.radiiCenter{1}));
            stim.radiiCenter = stimulus.radiiCenter{1}(tempVar(1));
            
            % radiiSurround
            tempVar = randperm(length(stimulus.radiiSurround{1}));
            stim.radiiSurround = stimulus.radiiSurround{1}(tempVar(1));
            
            % location
            tempVar = randperm(size(stimulus.location{1},1));
            stim.location = stimulus.location{1}(tempVar(1),:);
        elseif targetPorts == 3% the second of the possible values
            % pixPerCycsCenter
            tempVar = randperm(length(stimulus.pixPerCycsCenter{2}));
            stim.pixPerCycsCenter = stimulus.pixPerCycsCenter{2}(tempVar(1));
            
            % pixPerCycsSurround
            tempVar = randperm(length(stimulus.pixPerCycsSurround{2}));
            stim.pixPerCycsSurround = stimulus.pixPerCycsSurround{2}(tempVar(1));
            
            % driftfrequenciesCenter
            tempVar = randperm(length(stimulus.driftfrequenciesCenter{2}));
            stim.driftfrequenciesCenter = stimulus.driftfrequenciesCenter{2}(tempVar(1));
            
            % driftfrequenciesSurround
            tempVar = randperm(length(stimulus.driftfrequenciesSurround{2}));
            stim.driftfrequenciesSurround = stimulus.driftfrequenciesSurround{2}(tempVar(1));
            
            % orientationsCenter
            tempVar = randperm(length(stimulus.orientationsCenter{2}));
            stim.orientationsCenter = stimulus.orientationsCenter{2}(tempVar(1));
            
            % orientationsSurround
            tempVar = randperm(length(stimulus.orientationsSurround{2}));
            stim.orientationsSurround = stimulus.orientationsSurround{2}(tempVar(1));
            
            % phasesCenter
            tempVar = randperm(length(stimulus.phasesCenter{2}));
            stim.phasesCenter = stimulus.phasesCenter{2}(tempVar(1));
            
            % phasesSurround
            tempVar = randperm(length(stimulus.phasesSurround{2}));
            stim.phasesSurround = stimulus.phasesSurround{2}(tempVar(1));
            
            % contrastsCenter
            tempVar = randperm(length(stimulus.contrastsCenter{2}));
            stim.contrastsCenter = stimulus.contrastsCenter{2}(tempVar(1));
            
            % contrastsSurround
            tempVar = randperm(length(stimulus.contrastsSurround{2}));
            stim.contrastsSurround = stimulus.contrastsSurround{2}(tempVar(1));
            
            % waveform
            stim.waveform = stimulus.waveform;
            
            % maxDuration
            tempVar = randperm(length(stimulus.maxDuration{2}));
            if ~ismac
                stim.maxDuration = stimulus.maxDuration{2}(tempVar(1))*hz;
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = stimulus.maxDuration{2}(tempVar(1))*60;
            end
            
            % radiiCenter
            tempVar = randperm(length(stimulus.radiiCenter{2}));
            stim.radiiCenter = stimulus.radiiCenter{2}(tempVar(1));
            
            % radiiSurround
            tempVar = randperm(length(stimulus.radiiSurround{2}));
            stim.radiiSurround = stimulus.radiiSurround{2}(tempVar(1));
            
            % location
            tempVar = randperm(size(stimulus.location{2},1));
            stim.location = stimulus.location{2}(tempVar(1),:);
        else 
            error('eh? should not come here at all')
        end
    else
        error('not geared for more than one target port. whats wrong??');
    end
else
    if length(targetPorts)==1
        if targetPorts == 1
            tempVar = randperm(length(stimulus.pixPerCycs{1}));
            which = tempVar(1);            
            stim.pixPerCycsCenter=stimulus.pixPerCycsCenter{1}(which);
            stim.pixPerCycsSurround=stimulus.pixPerCycsSurround{1}(which);
            stim.driftfrequenciesCenter=stimulus.driftfrequenciesCenter{1}(which);
            stim.driftfrequenciesSurround=stimulus.driftfrequenciesSurround{1}(which);
            stim.orientationsCenter=stimulus.orientationsCenter{1}(which);
            stim.orientationsSurround=stimulus.orientationsSurround{1}(which);
            stim.phasesCenter=stimulus.phasesCenter{1}(which);
            stim.phasesSurround=stimulus.phasesSurround{1}(which);
            stim.contrastsCenter=stimulus.contrastsCenter{1}(which);
            stim.contrastsSurround=stimulus.contrastsSurround{1}(which);
            stim.waveform=stimulus.waveform;
            if ~ismac
                stim.maxDuration=stimulus.maxDuration{1}(which)*hz;
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = stimulus.maxDuration{1}(which)*60;
            end
            stim.radiiCenter=stimulus.radiiCenter{1}(which);
            stim.radiiSurround=stimulus.radiiSurround{1}(which);
            stim.annuli=stimulus.annuli{1}(which);
            stim.location=stimulus.location{1}(which,:);
        elseif targetPorts == 3
            tempVar = randperm(length(stimulus.pixPerCycs{2}));
            which = tempVar(1);            
            stim.pixPerCycsCenter=stimulus.pixPerCycsCenter{2}(which);
            stim.pixPerCycsSurround=stimulus.pixPerCycsSurround{2}(which);
            stim.driftfrequenciesCenter=stimulus.driftfrequenciesCenter{2}(which);
            stim.driftfrequenciesSurround=stimulus.driftfrequenciesSurround{2}(which);
            stim.orientationsCenter=stimulus.orientationsCenter{2}(which);
            stim.orientationsSurround=stimulus.orientationsSurround{2}(which);
            stim.phasesCenter=stimulus.phasesCenter{2}(which);
            stim.phasesSurround=stimulus.phasesSurround{2}(which);
            stim.contrastsCenter=stimulus.contrastsCenter{2}(which);
            stim.contrastsSurround=stimulus.contrastsSurround{2}(which);
            stim.waveform=stimulus.waveform;
            if ~ismac
                stim.maxDuration=stimulus.maxDuration{2}(which)*hz;
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = stimulus.maxDuration{2}(which)*60;
            end
            stim.radiiCenter=stimulus.radiiCenter{2}(which);
            stim.radiiSurround=stimulus.radiiSurround{2}(which);
            stim.annuli=stimulus.annuli{2}(which);
            stim.location=stimulus.location{2}(which,:);
        else
            error('eh? should not come here at all')
        end
    else
        error('not geared for more than one target port. whats wrong??');
    end
end
% normalizationMethod,mean,thresh,height,width,scaleFactor,interTrialLuminance
stim.radiusType = stimulus.radiusType;
stim.normalizationMethod=stimulus.normalizationMethod;
stim.height=height;
stim.width=width;
stim.mean=stimulus.mean;
stim.thresh=stimulus.thresh;
stim.doCombos=stimulus.doCombos;
details.chosenStim = stim;

% have a version in ''details''
details.doCombos                        = stimulus.doCombos;

details.pixPerCycsCenter                = stim.pixPerCycsCenter;
details.driftfrequenciesCenter          = stim.driftfrequenciesCenter;
details.orientationsCenter              = stim.orientationsCenter;
details.phasesCenter                    = stim.phasesCenter;
details.contrastsCenter                 = stim.contrastsCenter;
details.radiiCenter                     = stim.radiiCenter;

details.pixPerCycsSurround              = stim.pixPerCycsSurround;
details.driftfrequenciesSurround        = stim.driftfrequenciesSurround;
details.orientationsSurround            = stim.orientationsSurround;
details.phasesSurround                  = stim.phasesSurround;
details.contrastsSurround               = stim.contrastsSurround;
details.radiiSurround                   = stim.radiiSurround;

details.maxDuration                   = stim.maxDuration;
details.waveform                      = stim.waveform;

% radiiCenter
if stim.radiiCenter==Inf
    sca;
    error('center cannot have infinite radius');
else
    mask=[];
    maskParams=[stim.radiiCenter 999 0 0 ...
        1.0 stim.thresh stim.location(1) stim.location(2)]; %11/12/08 - for some reason mask contrast must be 2.0 to get correct result
    
    switch details.chosenStim.radiusType
        case 'gaussian'
                mask(:,:,1)=ones(height,width,1)*stim.mean;
                mask(:,:,2)=computeGabors(maskParams,0,width,height,...
                    'none', stim.normalizationMethod,0,0);
                % necessary to make use of PTB alpha blending: 1 -
                mask(:,:,2) = 1 - mask(:,:,2); % 0 = transparent, 255=opaque (opposite of our mask)
                stim.centerMask{1}=mask;
        case 'hardEdge'
                mask(:,:,1)=ones(height,width,1)*stimulus.mean;
                [WIDTH HEIGHT] = meshgrid(1:width,1:height);
                mask(:,:,2)=double((((WIDTH-width*details.chosenStim.location(1)).^2)+((HEIGHT-height*details.chosenStim.location(2)).^2)-((stim.radiiCenter)^2*(height^2)))>0);
                stim.centerMask{1}=mask;
    end    
    stim.centerSize = 2*stim.radiiCenter*height;
end
details.centerMask = stim.centerMask;
details.centerSize = stim.centerSize;
% radiiSurround
if stim.radiiSurround==Inf
    stim.surroundMask = [];
else
    mask=[];
    maskParams=[stim.radiiSurround 999 0 0 ...
        1.0 stim.thresh stim.location(1) stim.location(2)]; %11/12/08 - for some reason mask contrast must be 2.0 to get correct result
    
    switch details.chosenStim.radiusType
        case 'gaussian'
                mask(:,:,1)=ones(height,width,1)*stim.mean;
                mask(:,:,2)=computeGabors(maskParams,0,width,height,...
                    'none', stim.normalizationMethod,0,0);
                % necessary to make use of PTB alpha blending: 1 -
                mask(:,:,2) = 1 - mask(:,:,2); % 0 = transparent, 255=opaque (opposite of our mask)
                stim.surroundMask{1}=mask;
        case 'hardEdge'
                mask(:,:,1)=ones(height,width,1)*stimulus.mean;
                [WIDTH HEIGHT] = meshgrid(1:width,1:height);
                mask(:,:,2)=double((((WIDTH-width*details.chosenStim.location(1)).^2)+((HEIGHT-height*details.chosenStim.location(2)).^2)-((stim.radiiSurround)^2*(height^2)))>0);
                stim.surroundMask{1}=mask;
    end    
end
details.surroundMask = stim.surroundMask;


if isinf(stim.maxDuration)
    timeout=[];
else
    timeout=stim.maxDuration;
end

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
    text=sprintf('thresh: %g',stimulus.thresh);
end