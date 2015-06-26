function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] =...
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,...
    responsePorts,totalPorts,trialRecords,compiledRecords)
% see ratrixPath\documentation\stimManager.calcStim.txt for argument specification (applies to calcStims of all stimManagers)
trialManagerClass = class(trialManager);
% 1/30/09 - trialRecords now includes THIS trial
indexPulses=[];
imagingTasks=[];
[LUT, stimulus, updateSM]=getLUT(stimulus,LUTbits);

[junk, mac] = getMACaddress();
switch mac
    case {'A41F7278B4DE','A41F729213E2','A41F726EC11C' } %gLab-Behavior rigs 1,2,3
        [resolutionIndex, height, width, hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
    case {'7845C4256F4C', '7845C42558DF','A41F729211B1'} %gLab-Behavior rigs 4,5,6
        [resolutionIndex, height, width, hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
    otherwise 
        [resolutionIndex, height, width, hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
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
possibleStims.pixPerCycs            = stimulus.pixPerCycs;
possibleStims.driftfrequencies      = stimulus.driftfrequencies;
possibleStims.orientations          = stimulus.orientations;
possibleStims.phases                = stimulus.phases;
possibleStims.contrasts             = stimulus.contrasts;
possibleStims.waveform              = stimulus.waveform;
possibleStims.maxDuration           = {stimulus.maxDuration{1}*hz,stimulus.maxDuration{2}*hz};
possibleStims.radii                 = stimulus.radii;
possibleStims.radiusType            = stimulus.radiusType;
possibleStims.annuli                = stimulus.annuli;
possibleStims.location              = stimulus.location;
possibleStims.normalizationMethod   = stimulus.normalizationMethod;
possibleStims.mean                  = stimulus.mean;
possibleStims.thresh                = stimulus.thresh;
possibleStims.width                 = width;
possibleStims.height                = height;
possibleStims.doCombos              = stimulus.doCombos;
details.possibleStims               = possibleStims;
details.afcGratingType              = getType(stimulus,structize(stimulus));

% whats the chosen stim?
if stimulus.doCombos
    % choose a random value for each
    if length(targetPorts)==1
        stim = [];
        if targetPorts == 1 % the first of the possible values
            % pixPerCycs
            tempVar = randperm(length(stimulus.pixPerCycs{1}));
            stim.pixPerCycs = stimulus.pixPerCycs{1}(tempVar(1));
            
            % driftfrequencies
            tempVar = randperm(length(stimulus.driftfrequencies{1}));
            stim.driftfrequencies = stimulus.driftfrequencies{1}(tempVar(1));
            
            % orientations
            tempVar = randperm(length(stimulus.orientations{1}));
            stim.orientations = stimulus.orientations{1}(tempVar(1));
            
            % phases
            tempVar = randperm(length(stimulus.phases{1}));
            stim.phases = stimulus.phases{1}(tempVar(1));
            
            % contrasts
            tempVar = randperm(length(stimulus.contrasts{1}));
            stim.contrasts = stimulus.contrasts{1}(tempVar(1));
            
            % waveform
            stim.waveform = stimulus.waveform;
            
            % maxDuration
            tempVar = randperm(length(stimulus.maxDuration{1}));
            if ~ismac
                stim.maxDuration = round(stimulus.maxDuration{1}(tempVar(1))*hz);
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = round(stimulus.maxDuration{1}(tempVar(1))*60);
            end
            
            % radii
            tempVar = randperm(length(stimulus.radii{1}));
            stim.radii = stimulus.radii{1}(tempVar(1));
            
            % annuli
            tempVar = randperm(length(stimulus.annuli{1}));
            stim.annuli = stimulus.annuli{1}(tempVar(1));
            
            % location
            tempVar = randperm(size(stimulus.location{1},1));
            stim.location = stimulus.location{1}(tempVar(1),:);
        elseif targetPorts == 3% the second of the possible values
            % pixPerCycs
            tempVar = randperm(length(stimulus.pixPerCycs{2}));
            stim.pixPerCycs = stimulus.pixPerCycs{2}(tempVar(1));
            
            % driftfrequencies
            tempVar = randperm(length(stimulus.driftfrequencies{2}));
            stim.driftfrequencies = stimulus.driftfrequencies{2}(tempVar(1));
            
            % orientations
            tempVar = randperm(length(stimulus.orientations{2}));
            stim.orientations = stimulus.orientations{2}(tempVar(1));
            
            % phases
            tempVar = randperm(length(stimulus.phases{2}));
            stim.phases = stimulus.phases{2}(tempVar(1));
            
            % contrasts
            tempVar = randperm(length(stimulus.contrasts{2}));
            stim.contrasts = stimulus.contrasts{2}(tempVar(1));
            
            % waveform
            stim.waveform = stimulus.waveform;
            
            % maxDuration
            tempVar = randperm(length(stimulus.maxDuration{2}));
            if ~ismac
                stim.maxDuration = round(stimulus.maxDuration{2}(tempVar(1))*hz);
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = round(stimulus.maxDuration{2}(tempVar(1))*60);
            end
            
            % radii
            tempVar = randperm(length(stimulus.radii{2}));
            stim.radii = stimulus.radii{2}(tempVar(1));
            
            % annuli
            tempVar = randperm(length(stimulus.annuli{2}));
            stim.annuli = stimulus.annuli{2}(tempVar(1));
            
            % location
            tempVar = randperm(size(stimulus.location{2},1));
            stim.location = stimulus.location{2}(tempVar(1),:);
        else 
            targetPorts
            sca;
            keyboard
            error('eh? should not come here at all')
        end
    else
        targetPorts
        error('not geared for more than one target port. whats wrong??');
    end
else
    if length(targetPorts)==1
        if targetPorts == 1
            tempVar = randperm(length(stimulus.pixPerCycs{1}));
            which = tempVar(1);            
            stim.pixPerCycs=stimulus.pixPerCycs{1}(which);
            stim.driftfrequencies=stimulus.driftfrequencies{1}(which);
            stim.orientations=stimulus.orientations{1}(which);
            stim.phases=stimulus.phases{1}(which);
            stim.contrasts=stimulus.contrasts{1}(which);
            stim.waveform=stimulus.waveform;
            if ~ismac
                stim.maxDuration=round(stimulus.maxDuration{1}(which)*hz);
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = round(stimulus.maxDuration{1}(which)*60);
            end
            stim.radii=stimulus.radii{1}(which);
            stim.annuli=stimulus.annuli{1}(which);
            stim.location=stimulus.location{1}(which,:);
        elseif targetPorts == 3
            tempVar = randperm(length(stimulus.pixPerCycs{2}));
            which = tempVarVar(1);            
            stim.pixPerCycs=stimulus.pixPerCycs{2}(which);
            stim.driftfrequencies=stimulus.driftfrequencies{2}(which);
            stim.orientations=stimulus.orientations{2}(which);
            stim.phases=stimulus.phases{2}(which);
            stim.contrasts=stimulus.contrasts{2}(which);
            stim.waveform=stimulus.waveform;
            if ~ismac
                stim.maxDuration=round(stimulus.maxDuration{2}(which)*hz);
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = round(stimulus.maxDuration{2}(which)*60);
            end
            stim.radii=stimulus.radii{2}(which);
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
details.doCombos            = stimulus.doCombos;
details.pixPerCycs          = stim.pixPerCycs;
details.driftfrequencies    = stim.driftfrequencies;
details.orientations        = stim.orientations;
details.phases              = stim.phases;
details.contrasts           = stim.contrasts;
details.maxDuration         = stim.maxDuration;
details.radii               = stim.radii;
details.annuli              = stim.annuli;
details.waveform            = stim.waveform;

% radii
if stim.radii==Inf
    stim.masks={[]};
else
    mask=[];
    maskParams=[stim.radii 999 0 0 ...
        1.0 stim.thresh stim.location(1) stim.location(2)]; %11/12/08 - for some reason mask contrast must be 2.0 to get correct result
    
    switch details.chosenStim.radiusType
            case 'gaussian'
                mask(:,:,1)=ones(height,width,1)*stim.mean;
                mask(:,:,2)=computeGabors(maskParams,0,width,height,...
                    'none', stim.normalizationMethod,0,0);
                % necessary to make use of PTB alpha blending: 1 -
                mask(:,:,2) = 1 - mask(:,:,2); % 0 = transparent, 255=opaque (opposite of our mask)
                stim.masks{1}=mask;
        case 'hardEdge'
                mask(:,:,1)=ones(height,width,1)*stimulus.mean;
                [WIDTH HEIGHT] = meshgrid(1:width,1:height);
                mask(:,:,2)=double((((WIDTH-width*details.chosenStim.location(1)).^2)+((HEIGHT-height*details.chosenStim.location(2)).^2)-((stim.radii)^2*(height^2)))>0);
                stim.masks{1}=mask;
    end    
end
% annulus
if ~(stim.annuli==0)
    annulusCenter=stim.location;
    annulusRadius=stim.annuli;
    annulusRadiusInPixels=sqrt((height/2)^2 + (width/2)^2)*annulusRadius;
    annulusCenterInPixels=[width height].*annulusCenter;
    [x,y]=meshgrid(-width/2:width/2,-height/2:height/2);
    annulus(:,:,1)=ones(height,width,1)*stimulus.mean;
    bool=(x+width/2-annulusCenterInPixels(1)).^2+(y+height/2-annulusCenterInPixels(2)).^2 < (annulusRadiusInPixels+0.5).^2;
    annulus(:,:,2)=bool(1:height,1:width);
    stim.annuliMatrices{1}=annulus;
else
    stim.annuliMatrices = {[]};
end

if isinf(stim.maxDuration)
    timeout=[];
else
    timeout=stim.maxDuration;
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
    text=sprintf('thresh: %g',stimulus.thresh);
end