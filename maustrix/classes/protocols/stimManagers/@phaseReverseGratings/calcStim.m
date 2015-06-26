function [stimulus,updateSM,resolutionIndex,preRequestStim,preResponseStim,discrimStim,postDiscrimStim,interTrialStim,LUT,targetPorts,distractorPorts,...
    details,interTrialLuminance,text,indexPulses,imagingTasks] =...
    calcStim(stimulus,trialManager,allowRepeats,resolutions,displaySize,LUTbits,responsePorts,totalPorts,trialRecords)
% see ratrixPath\documentation\stimManager.calcStim.txt for argument specification (applies to calcStims of all stimManagers)
% 1/3/0/09 - trialRecords now includes THIS trial
trialManagerClass=class(trialManager);
indexPulses=[];
imagingTasks=[];
LUTbits
displaySize
[LUT stimulus updateSM]=getLUT(stimulus,LUTbits);
[resolutionIndex height width hz]=chooseLargestResForHzsDepthRatio(resolutions,[100 60],32,getMaxWidth(stimulus),getMaxHeight(stimulus));

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

details.pctCorrectionTrials=getPercentCorrectionTrials(trialManager);
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
numFrequencies = length(stimulus.pixPerCycs);
numContrasts = length(stimulus.contrasts);
details.spatialFrequencies=stimulus.pixPerCycs; % 1/7/09 - renamed from pixPerCycs to spatialFrequencies (to avoid clashing with compile process)
details.frequencies=stimulus.frequencies;
details.orientations=stimulus.orientations;
details.startPhases=stimulus.startPhases;
details.contrasts=stimulus.contrasts;
if isa(stimulus.location,'RFestimator')
    if size(trialRecords(end).subjectsInBox,2)==1
        subjectID=char(trialRecords(end).subjectsInBox);
    else
        error('only one subject allowed')
    end
    details.location=getCenter(stimulus.location,subjectID,trialRecords);
else
    details.location=stimulus.location;
end
details.durations=stimulus.durations;
details.radii=stimulus.radii;
details.annuli=stimulus.annuli;
details.numRepeats=stimulus.numRepeats;
details.doCombos=stimulus.doCombos;
details.method = stimulus.ordering.method;
details.seed = stimulus.ordering.seed;
if ischar(details.seed) && strcmp(details.seed,'clock')
    seedVal = sum(100*clock);
    details.seed = seedVal;
    stimulus.ordering.seed = seedVal;
end
details.changeableAnnulusCenter=stimulus.changeableAnnulusCenter;
details.waveform=stimulus.waveform;
details.phaseform = stimulus.phaseform;
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
stim.phaseform = details.phaseform;

% details has the parameters before combos, stim should have them after combos are taken
if stimulus.doCombos
    % do combos here
    mode = {details.method,details.seed};
    comboMatrix = generateFactorialCombo({details.spatialFrequencies,details.frequencies,details.orientations,...
        details.contrasts,details.startPhases,details.durations,details.radii,details.annuli},[],[],mode);
    stim.pixPerCycs=comboMatrix(1,:);
    stim.frequencies=comboMatrix(2,:);
    stim.orientations=comboMatrix(3,:);
    stim.contrasts=comboMatrix(4,:); %starting phases in radians
    stim.phases=comboMatrix(5,:);
    stim.durations=round(comboMatrix(6,:)*hz); % CONVERTED FROM seconds to frames
    stim.radii=comboMatrix(7,:);
    stim.annuli=comboMatrix(8,:);
else
    stim.pixPerCycs=details.spatialFrequencies;
    stim.frequencies=details.driftfrequencies;
    stim.orientations=details.orientations;
    stim.contrasts=details.contrasts;
    stim.phases=details.phases;
    stim.durations=round(details.durations*hz); % CONVERTED FROM seconds to frames    
    stim.radii=details.radii;
    stim.annuli=details.annuli;
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
        % now calculate mask for this grating - we need to pass a mean of 0 to correctly make a mask
        mask(:,:,1)=ones(height,width,1)*stimulus.mean;
        mask(:,:,2)=computeGabors(maskParams,0,width,height,...
            'none', stimulus.normalizationMethod,0,0);

        % necessary to make use of PTB alpha blending: 1 - 
        mask(:,:,2) = 1 - mask(:,:,2); % 0 = transparent, 255=opaque (opposite of our mask)
        stim.masks{i}=mask;
    end
end
% convert from annuli=[0.8 0.8 0.6 1.2 0.7] to [1 1 2 3 4] (stupid unique automatically sorts when we dont want to)
[a b] = unique(fliplr(stim.annuli)); 
unsortedUniques=stim.annuli(sort(length(stim.annuli)+1 - b));
[garbage stim.annuliInds]=ismember(stim.annuli,unsortedUniques);
% annuli array
annulusCenter=stim.location;
stim.annuliMatrices=cell(1,length(unsortedUniques));
for i=1:length(unsortedUniques)
    annulus=[];
    annulusRadius=unsortedUniques(i);
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