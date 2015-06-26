function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] =...
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,...
    responsePorts,totalPorts,trialRecords,compiledRecords)
% see ratrixPath\documentation\stimManager.calcStim.txt for argument specification (applies to calcStims of all stimManagers)
% 1/3/0/09 - trialRecords now includes THIS trial
indexPulses=[];
imagingTasks=[];
LUTbits
displaySize
[LUT stimulus updateSM]=getLUT(stimulus,LUTbits);
% [resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[100 60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
[resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));
trialManagerClass = class(trialManager);
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

scaleFactor=getScaleFactor(stimulus); % dummy value since we are phased anyways; the real scaleFactor is stored in each phase's stimSpec
interTrialLuminance = getInterTrialLuminance(stimulus); 
interTrialDuration = getInterTrialDuration(stimulus);
toggleStim=true;
type='expert';

dynamicMode = true; % do things dynamically as in driftdemo2
% dynamicMode=false;

% =====================================================================================================

details.pctCorrectionTrials=.5; % need to change this to be passed in from trial manager
if ~isempty(trialRecords) && length(trialRecords)>=2
    lastRec=trialRecords(end-1);
else
    lastRec=[];
end
[targetPorts distractorPorts details]=assignPorts(details,lastRec,responsePorts,trialManagerClass,allowRepeats);

% =====================================================================================================

% set up params for computeGabors
height = min(height,getMaxHeight(stimulus));
width = min(width,getMaxWidth(stimulus));


% temporal frequency
if isa(stimulus.driftfrequencies,'grEstimator')&&strcmp(getType(stimulus.driftfrequencies),'driftfrequencies')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
    singleUnitDetails.subjectID = subjectID;
    details.driftfrequencies=chooseValues(stimulus.driftfrequencies,singleUnitDetails);
else
    details.driftfrequencies=stimulus.driftfrequencies;
end

%orientation
if isa(stimulus.orientations,'grEstimator')&&strcmp(getType(stimulus.orientations),'orientations')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
    singleUnitDetails.subjectID = subjectID;
    details.orientations=chooseValues(stimulus.orientations,singleUnitDetails);
else
    details.orientations=stimulus.orientations;
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


details.phases=stimulus.phases;

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

if isa(stimulus.pixPerCycs,'grEstimator')&&strcmp(getType(stimulus.pixPerCycs),'spatialFrequencies')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
    singleUnitDetails.subjectID = subjectID;
    details.spatialFrequencies=chooseValues(stimulus.pixPerCycs,singleUnitDetails);    
else
    details.spatialFrequencies=stimulus.pixPerCycs; % 1/7/09 - renamed from pixPerCycs to spatialFrequencies (to avoid clashing with compile process)
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

details.waveform=stimulus.waveform;

details.width=width;
details.height=height;

% NOTE: all fields in details should be MxN now

% =====================================================================================================

% =====================================================================================================
% dynamic mode
% for now we will attempt to calculate each frame on-the-fly, 
% but we might need to precache all contrast/orientation/pixPerCycs pairs and then rotate phase dynamically
% still pass out stimSpecs as in cache mode, but the 'stim' is a struct of parameters
% stim.pixPerCycs - frequency of the grating (how wide the bars are)
% stim.orientations - angle of the grating
% stim.velocities - frequency of the phase (how quickly we go through a 0:2*pi cycle of the sine curve)
% stim.location - where to center each grating (modifies destRect)
% stim.contrasts - contrast of the grating
% stim.durations - duration of each grating (in frames)
% stim.mask - the mask to be used (empty if unmasked)
stim=[];

stim.width=details.width;
stim.height=details.height;
stim.location=details.location;
stim.numRepeats=details.numRepeats;
stim.waveform=details.waveform;
stim.changeableAnnulusCenter=details.changeableAnnulusCenter;
stim.changeableRadiusCenter=details.changeableRadiusCenter;

% details has the parameters before combos, stim should have them after combos are taken
if stimulus.doCombos
    % do combos here
    mode = {details.method,details.seed};
    comboMatrix = generateFactorialCombo({details.spatialFrequencies,details.driftfrequencies,details.orientations,...
        details.contrasts,details.phases,details.durations,details.radii,details.annuli},[],[],mode);
    stim.pixPerCycs=comboMatrix(1,:);
    stim.driftfrequencies=comboMatrix(2,:);
    stim.orientations=comboMatrix(3,:);
    stim.contrasts=comboMatrix(4,:); %starting phases in radians
    stim.phases=comboMatrix(5,:);
    stim.durations=round(comboMatrix(6,:)*hz); % CONVERTED FROM seconds to frames
    stim.radii=comboMatrix(7,:);
    stim.annuli=comboMatrix(8,:);
else
    stim.pixPerCycs=details.spatialFrequencies;
    stim.driftfrequencies=details.driftfrequencies;
    stim.orientations=details.orientations;
    stim.contrasts=details.contrasts;
    stim.phases=details.phases;
    stim.durations=round(details.durations*hz); % CONVERTED FROM seconds to frames    
    stim.radii=details.radii;
    stim.annuli=details.annuli;
end

% support for includeBlank
if details.includeBlank
    stim.pixPerCycs(end+1) = stim.pixPerCycs(end);
    stim.driftfrequencies(end+1)=stim.driftfrequencies(end);
    stim.orientations(end+1)=stim.orientations(end);
    stim.contrasts(end+1)=0; % the blank is a zero contrast stimulus
    stim.phases(end+1)=stim.phases(end);
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

switch stimulus.waveform
    case 'haterenImage1000'
        path='\\132.239.158.183\rlab_storage\pmeier\vanhateren\iml_first1000';
                imName='imk01000.iml';
        f1=fopen(fullfile(path,imName),'rb','ieee-be');
        w=1536;h=1024;
        im=fread(f1,[w,h],'uint16');
        im=im';
        %          subplot(2,2,1); hist(im(:))
        %          subplot(2,2,2); imagesc(im); colormap(gray)
         im=im-mean(im(:));
         im=0.5*im/std(im(:));
         im(im>1)=1;
         im(im<-1)=-1;
         %         subplot(2,2,3); hist(im(:))
         %         subplot(2,2,4); imagesc(im); colormap(gray)
         details.images=im;
         stim.images=details.images;
    case 'catcam530a'
        path='\\132.239.158.183\rlab_storage\pmeier\CatCam\labelb000530a';
        imName='Catt0910.tif';
        im=double(imread(fullfile(path,imName)));
        im=im-mean(im(:));
        im=0.5*im/std(im(:));
        im(im>1)=1;
        im(im<-1)=-1;
        %         subplot(1,2,1); hist(im(:))
        %         subplot(1,2,2); imagesc(im); colormap(gray)
        details.images=im;
        stim.images=details.images;
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
details.percentCorrectionTrials = getPercentCorrectionTrials(trialManager);
if strcmp(trialManagerClass,'nAFC') && details.correctionTrial
    text='correction trial!';
else
    text=sprintf('thresh: %g',stimulus.thresh);
end