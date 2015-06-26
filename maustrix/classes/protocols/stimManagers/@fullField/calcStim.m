function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] =...
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,...
    responsePorts,totalPorts,trialRecords,compiledRecords)
% see ratrixPath\documentation\stimManager.calcStim.txt for argument specification (applies to calcStims of all stim,Managers)
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

scaleFactor=getScaleFactor(stimulus); % dummy value since we are phased anyways; the real scaleFactor is stored in each phase's stimSpec
interTrialLuminance = getInterTrialLuminance(stimulus);
interTrialDuration = getInterTrialDuration(stimulus);
toggleStim=true;
type='expert';

dynamicMode = true; % do things dynamically
% dynamicMode=false;

% =====================================================================================================

details.pctCorrectionTrials=getPercentCorrectionTrials(trialManager);
if ~isempty(trialRecords) && length(trialRecords)>=2
    lastRec=trialRecords(end-1);
else
    lastRec=[];
end
[targetPorts distractorPorts details]=assignPorts(details,lastRec,responsePorts,trialManagerClass,allowRepeats);

% =====================================================================================================
% start calculating frames now
% set up params for computeGabors
height = min(height,getMaxHeight(stimulus));
width = min(width,getMaxWidth(stimulus));


% temporal frequency
if isa(stimulus.frequencies,'grEstimator')&&strcmp(getType(stimulus.frequencies),'driftfrequencies')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
    singleUnitDetails.subjectID = subjectID;
    details.frequencies=chooseValues(stimulus.frequencies,singleUnitDetails);
else
    details.frequencies=stimulus.frequencies;
end

%contrasts
if isa(stimulus.contrasts,'grEstimator')&&strcmp(getType(stimulus.contrasts),'contrasts')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
    singleUnitDetails.subjectID = subjectID;
    details.contrasts=chooseValues(stimulus.contrasts,singleUnitDetails);
else
    details.contrasts=stimulus.contrasts;
end


if isa(stimulus.location,'RFestimator')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
    details.location=getCenter(stimulus.location,subjectID,trialRecords);
elseif isa(stimulus.location,'wnEstimator')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
        singleUnitDetails.subjectID = subjectID;
    details.location=chooseValues(stimulus.location,{singleUnitDetails});
else
    details.location=stimulus.location;
end

details.durations=stimulus.durations;

if isa(stimulus.radii,'grEstimator')&&strcmp(getType(stimulus.radii),'radii')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
    singleUnitDetails.subjectID = subjectID;
    details.radii=chooseValues(stimulus.radii,singleUnitDetails);
else
    details.radii=stimulus.radii; % 1/7/09 - renamed from pixPerCycs to spatialFrequencies (to avoid clashing with compile process)
end

details.radiusType = stimulus.radiusType;
details.annuli=stimulus.annuli;
details.numRepeats=stimulus.numRepeats;
details.doCombos=stimulus.doCombos;
details.method = stimulus.ordering.method;
details.seed = stimulus.ordering.seed;
details.includeBlank = stimulus.ordering.includeBlank;
if ischar(details.seed) && strcmp(details.seed,'clock')
    seedVal =sum(100*clock);
    details.seed = seedVal;
    stimulus.ordering.seed = seedVal;
end
details.changeableAnnulusCenter=stimulus.changeableAnnulusCenter;
details.changeableRadiusCenter=stimulus.changeableRadiusCenter;

details.width=width;
details.height=height;

% NOTE: all fields in details should be MxN now

% =====================================================================================================
stim=[];

stim.width=details.width;
stim.height=details.height;
stim.location=details.location;
stim.numRepeats=details.numRepeats;
stim.changeableAnnulusCenter=details.changeableAnnulusCenter;
stim.changeableRadiusCenter=details.changeableRadiusCenter;

% details has the parameters before combos, stim should have them after combos are taken
if stimulus.doCombos
    % do combos here
    mode = {details.method,details.seed};
    comboMatrix = generateFactorialCombo({details.frequencies,details.contrasts,details.durations,details.radii,details.annuli},[],[],mode);
    stim.frequencies=comboMatrix(1,:);
    stim.contrasts=comboMatrix(2,:); %starting phases in radians
    stim.durations=round(comboMatrix(3,:)*hz); % CONVERTED FROM seconds to frames
    stim.radii=comboMatrix(4,:);
    stim.annuli=comboMatrix(5,:);
else
    stim.frequencies=details.frequencies;
    stim.contrasts=details.contrasts;
    stim.durations=round(details.durations*hz); % CONVERTED FROM seconds to frames    
    stim.radii=details.radii;
    stim.annuli=details.annuli;
end

% support for includeBlank
if details.includeBlank
    stim.frequencies(end+1)=stim.frequencies(end);
    stim.contrasts(end+1)=0; % the blank is a zero contrast stimulus
    stim.durations(end+1)=round(stim.durations(end)*hz); % CONVERTED FROM seconds to frames
    stim.radii(end+1)=stim.radii(end);
    stim.annuli(end+1)=stim.annuli(end);
end

% convert from radii=[0.8 0.8 0.6 1.2 0.7] to [1 1 2 3 4] (stupid unique automatically sorts when we dont want to)
[a b] = unique(fliplr(stim.radii)); 
unsortedUniques=stim.radii(sort(length(stim.radii)+1 - b));
[garbage stim.maskInds]=ismember(stim.radii,unsortedUniques);

% now make our cell array of masks and the maskInd vector that indexes into the masks for each combination of params
% compute mask only once if radius is not infinite
stim.masks=cell(1,length(unsortedUniques));
for i=1:length(unsortedUniques)
    if unsortedUniques(i)==Inf
        stim.masks{i}=[];
    else
        mask=[];
        maskParams=[unsortedUniques(i) 999 0 0 ...
        1.0 stimulus.thresh details.location(1) details.location(2)]; %11/12/08 - for some reason mask contrast must be 2.0 to get correct result

        switch details.radiusType
            case 'gaussian'
                mask(:,:,1)=ones(height,width,1)*stimulus.mean;
                mask(:,:,2)=computeGabors(maskParams,0,width,height,...
                    'none', stimulus.normalizationMethod,0,0);

                % necessary to make use of PTB alpha blending: 1 - 
                mask(:,:,2) = 1 - mask(:,:,2); % 0 = transparent, 255=opaque (opposite of our mask)
                stim.masks{i}=mask;
            case 'hardEdge'
                mask(:,:,1)=ones(height,width,1)*stimulus.mean;
                [WIDTH HEIGHT] = meshgrid(1:width,1:height);
                mask(:,:,2)=double((((WIDTH-width*details.location(1)).^2)+((HEIGHT-height*details.location(2)).^2)-((unsortedUniques(i))^2*(height^2)))>0);
                stim.masks{i}=mask;

        end
    end
end
% convert from annuli=[0.8 0.8 0.6 1.2 0.7] to [1 1 2 3 4] (stupid unique automatically sorts when we dont want to)
[a b] = unique(fliplr(stim.annuli)); 
unsortedUniquesAnnuli=stim.annuli(sort(length(stim.annuli)+1 - b));
[garbage stim.annuliInds]=ismember(stim.annuli,unsortedUniquesAnnuli);
% annuli array
annulusCenter=stim.location;
stim.annuliMatrices=cell(1,length(unsortedUniquesAnnuli));
for i=1:length(unsortedUniquesAnnuli)
    annulus=[];
    annulusRadius=unsortedUniquesAnnuli(i);
    annulusRadiusInPixels=sqrt((height/2)^2 + (width/2)^2)*annulusRadius;
    annulusCenterInPixels=[width height].*annulusCenter; % measured from top left corner; % result is [x y]
    % center=[256 712];
    %     center=[50 75];
    [x,y]=meshgrid(-width/2:width/2,-height/2:height/2);
    annulus(:,:,1)=ones(height,width,1)*stimulus.mean;
    bool=(x+width/2-annulusCenterInPixels(1)).^2+(y+height/2-annulusCenterInPixels(2)).^2 < (annulusRadiusInPixels+0.5).^2;
    annulus(:,:,2)=bool(1:height,1:width);
    stim.annuliMatrices{i}=annulus;
end

if isinf(stim.numRepeats)
    timeout=[];
else
    timeout=sum(stim.durations)*stim.numRepeats;
end

% LEDParams

[details, stim] = setupLED(details, stim, stimulus.LEDParams);

discrimStim=[];
discrimStim.stimulus=stim;
discrimStim.stimType=type;
discrimStim.scaleFactor=scaleFactor;
discrimStim.startFrame=0;
discrimStim.autoTrigger=[];
discrimStim.framesUntilTimeout=timeout;

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
% =====================================================================================================
% return out.stimSpecs, out.scaleFactors for each phase (only one phase for now?)
% details.big = out; % store in 'big' so it gets written to file % 1/6/09 - unnecessary since we will no longer use cached mode
details.stimManagerClass = class(stimulus);
details.trialManagerClass = trialManagerClass;

if strcmp(trialManagerClass,'nAFC') && details.correctionTrial
    text='correction trial!';
else
    text=sprintf('thresh: %g',stimulus.thresh);
end