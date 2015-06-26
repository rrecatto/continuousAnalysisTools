function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] =... 
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,...
    responsePorts,totalPorts,trialRecords,compiledRecords)
% see ratrixPath\documentation\stimManager.calcStim.txt for argument specification (applies to calcStims of all stimManagers)
indexPulses=[];
imagingTasks=[];

trialManagerClass = class(trialManager);

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
% target port selection
[targetPorts distractorPorts details]=assignPorts(details,lastRec,responsePorts,trialManagerClass,allowRepeats);


toggleStim=true; type='expert';
dynamicMode = true; %false %true

height = min(height,getMaxHeight(stimulus));
width = min(width,getMaxWidth(stimulus));


% choose stimulus
if stimulus.doCombos
    % choose a random value for each
    if length(targetPorts)==1
        stim = [];
        if targetPorts == 1 % the first of the possible values
            % shape
            tempVar = randperm(length(stimulus.shape{1}));
            stim.shape = stimulus.shape{1}{tempVar(1)};
            
            % objSize
            tempVar = randperm(length(stimulus.objSize{1}));
            stim.objSize = stimulus.objSize{1}(tempVar(1));
            
            % orientation
            tempVar = randperm(length(stimulus.orientation{1}));
            stim.orientation = stimulus.orientation{1}(tempVar(1));
            
            % contrast
            tempVar = randperm(length(stimulus.contrast{1}));
            stim.contrast = stimulus.contrast{1}(tempVar(1));
            
            % maxDuration
            tempVar = randperm(length(stimulus.maxDuration{1}));
            if ~ismac
                stim.maxDuration = stimulus.maxDuration{1}(tempVar(1))*hz;
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = stimulus.maxDuration{1}(tempVar(1))*60;
            end
            
            % location
            tempVar = randperm(size(stimulus.location{1},1));
            stim.location = stimulus.location{1}(tempVar(1),:);
            
            % backgroundLuminance
            tempVar = randperm(length(stimulus.backgroundLuminance{1}));
            stim.backgroundLuminance = stimulus.backgroundLuminance{1}(tempVar(1));
            
            % invertedContrast
            tempVar = randperm(length(stimulus.invertedContrast{1}));
            stim.invertedContrast = stimulus.invertedContrast{1}(tempVar(1));
            
            % objectType
            tempVar = randperm(length(stimulus.objectType(1)));
            stim.objectType = stimulus.objectType{1}{tempVar(1)};
            
            stim.drawMode = stimulus.drawMode{1};
        elseif targetPorts == 3% the second of the possible values
            % shape
            tempVar = randperm(length(stimulus.shape{2}));
            stim.shape = stimulus.shape{2}{tempVar(1)};
            
            % objSize
            tempVar = randperm(length(stimulus.objSize{2}));
            stim.objSize = stimulus.objSize{2}(tempVar(1));
            
            % orientation
            tempVar = randperm(length(stimulus.orientation{2}));
            stim.orientation = stimulus.orientation{2}(tempVar(1));
            
            % contrast
            tempVar = randperm(length(stimulus.contrast{2}));
            stim.contrast = stimulus.contrast{2}(tempVar(1));
            
            % maxDuration
            tempVar = randperm(length(stimulus.maxDuration{2}));
            if ~ismac
                stim.maxDuration = stimulus.maxDuration{2}(tempVar(1))*hz;
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = stimulus.maxDuration{2}(tempVar(1))*60;
            end
            
            % location
            tempVar = randperm(size(stimulus.location{2},1));
            stim.location = stimulus.location{2}(tempVar(1),:);
            
            % backgroundLuminance
            tempVar = randperm(length(stimulus.backgroundLuminance{2}));
            stim.backgroundLuminance = stimulus.backgroundLuminance{2}(tempVar(1));
            
            % invertedContrast
            tempVar = randperm(length(stimulus.invertedContrast{2}));
            stim.invertedContrast = stimulus.invertedContrast{2}(tempVar(1));
            
            % objectType
            tempVar = randperm(length(stimulus.objectType{2}));
            stim.objectType = stimulus.objectType{2}(tempVar(1));
            
            stim.drawMode = stimulus.drawMode{1};
        else 
            error('eh? should not come here at all')
        end
    else
        error('not geared for more than one target port. whats wrong??');
    end
else
    if length(targetPorts)==1
        if targetPorts == 1
            tempVar = randperm(length(stimulus.shape{1}));
            which = tempVar(1);
            stim.shape = stimulus.shape{1}{which};
            stim.objSize = stimulus.objSize{1}(which);
            stim.orientation = stimulus.orientation{1}(which);
            stim.contrast = stimulus.contrast{1}(which);
            if ~ismac
                stim.maxDuration = stimulus.maxDuration{1}(which)*hz;
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = stimulus.maxDuration{1}(which)*60;
            end
            stim.location = stimulus.location{1}(which,:);
            stim.backgroundLuminance = stimulus.backgroundLuminance{1}(which);
            stim.invertedContrast = stimulus.invertedContrast{1}(which);
            stim.objectType = stimulus.objectType{1}(which);
        elseif targetPorts == 3
            tempVar = randperm(length(stimulus.shape{2}));
            which = tempVar(1);
            stim.shape = stimulus.shape{2}{which};
            stim.objSize = stimulus.objSize{2}(which);
            stim.orientation = stimulus.orientation{2}(which);
            stim.contrast = stimulus.contrast{2}(which);
            if ~ismac
                stim.maxDuration = stimulus.maxDuration{2}(which)*hz;
            elseif ismac && hz==0
                % macs are weird and return a hz of 0 when they really
                % shouldnt. assume hz = 60 (hack)
                stim.maxDuration = stimulus.maxDuration{2}(which)*60;
            end
            stim.location = stimulus.location{2}(which,:);
            stim.backgroundLuminance = stimulus.backgroundLuminance{2}(which);
            stim.invertedContrast = stimulus.invertedContrast{2}(which);
            stim.objectType = stimulus.objectType{2}(which);
        else
            error('eh? should not come here at all')
        end
    else
        error('not geared for more than one target port. whats wrong??');
    end
end
% normalizationMethod,mean,thresh,height,width,scaleFactor,interTrialLuminance
stim.normalizationMethod=stimulus.normalizationMethod;
stim.height=height;
stim.width=width;
stim.thresh=stimulus.thresh;
stim.doCombos=stimulus.doCombos;
details.chosenStim = stim;


% lets make the images and store in stimulus....
[imX imY] = meshgrid(1:width,1:height); 
im = stim.backgroundLuminance*ones(size(imX));
% {'triangle','square','pentagon','hexagon','octagon','circle'};
switch stim.shape
    case 'triangle'
        locX = stim.location(1)*width;
        locY = stim.location(2)*height;
        error('not yet!');
    case 'square'
        locX = stim.location(1)*width;
        locY = stim.location(2)*height;
        L = stim.objSize*height;
        im1 = ((imX-locX)>-L/2) & ((imX-locX)<L/2);
        im2 = ((imY-locY)>-L/2) & ((imY-locY)<L/2);
        im(im1 & im2) = 1;
    case 'circle'
        locX = stim.location(1)*width;
        locY = stim.location(2)*height;
        L = stim.objSize*height;
        im1 = ((imX-locX).^2+(imY-locY).^2)<=(L/2)^2;
        im(im1) = 1;
end
stimulus.image = 255*im;


discrimStim=[];
discrimStim.stimulus=stim;
discrimStim.stimType=type;
discrimStim.scaleFactor=scaleFactor;
discrimStim.startFrame=0;
discrimStim.autoTrigger=[];

preRequestStim=[];
preRequestStim.stimulus=interTrialLuminance;
preRequestStim.stimType='loop';
preRequestStim.scaleFactor=0;
preRequestStim.startFrame=0;
preRequestStim.autoTrigger=[];
preRequestStim.punishResponses=false;


preResponseStim=discrimStim;
preResponseStim.punishResponses=false;

postDiscrimStim = [];

interTrialStim.duration = interTrialDuration;

details.interTrialDuration = interTrialDuration;
if details.correctionTrial;
    text='correction trial!';
else
    text = '';
end