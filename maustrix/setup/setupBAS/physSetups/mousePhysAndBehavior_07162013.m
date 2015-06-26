function r = mousePhysAndBehavior_07162013(r,subjIDs,otherParams)
if ~isa(r,'ratrix')
    error('need a ratrix')
end
if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

if ~exist('otherParams','var') || isempty(otherParams)
    otherParams.stepNum = 8;
end

[a,b] = getMACaddress;
switch b
    case 'BC305BD38BFB'
        maxWidth=1920;maxHeight=1080;
    otherwise
        maxWidth=1920;maxHeight=1080;
end


%% setup basic LED Params
LEDParams.active = true;
LEDParams.numLEDs = 2;
LEDParams.IlluminationModes{1}.whichLED = 1;
LEDParams.IlluminationModes{1}.intensity = 1;
LEDParams.IlluminationModes{1}.fraction = 0.25;
LEDParams.IlluminationModes{2}.whichLED = 2;
LEDParams.IlluminationModes{2}.intensity = 1;
LEDParams.IlluminationModes{2}.fraction = 0.25;
LEDParams.IlluminationModes{3}.whichLED = [1 2];
LEDParams.IlluminationModes{3}.intensity = [1 1];
LEDParams.IlluminationModes{3}.fraction = 0.25;
LEDParams.IlluminationModes{4}.whichLED = [1 2];
LEDParams.IlluminationModes{4}.intensity = [0 0];
LEDParams.IlluminationModes{4}.fraction = 0.25;

%% temporal stimuli
% full-field temporal
LEDParams.active = false;
frequencies=2.^(-1:4);phases=[0];
contrasts=[1]; durations=[3];
radius=5; annuli=0;
location=[.5 .5];
normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
scaleFactor=0;interTrialLuminance={.5,30};
doCombos={true,'twister','clock'};

changeableAnnulusCenter = false;
changeableRadiusCenter = false;
TRF= fullField(frequencies,contrasts,durations,radius,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
       maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter,changeableRadiusCenter,LEDParams);

   
%% spatial noise stimuli with 

gray=0.5; mean=gray; std = gray*[0.1:0.1:1];
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
scaleFactor=0;interTrialLuminance={.5,30};
stimLocation=[0,0,maxWidth,maxHeight];
stixelSize = [64 64];
stimDurationSecs = 5;frameDurationSecs = 0.01667;
numFrames = {stimDurationSecs,frameDurationSecs};

LEDParams.active = false;
spatNoiseDiffContrasts = whiteNoise({'gaussian',gray,std},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);
LEDParams.active = true;
spatNoiseDiffContrasts_LED = whiteNoise({'gaussian',gray,std},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);

%% gratings
LEDParams.active = false;

% orientations
 driftfrequencies=2; orientations=[-pi:pi/8:pi]; phases=[0];
contrasts = [1]; durations=[3];
radius={.25,'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=1;
scaleFactor=0;interTrialLuminance={.5,30};
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;
changeableRadiusCenter = false;

radius={2,'hardEdge'};
LEDParams.active = true;

pixPerCycs=256;
orient256FF = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter,changeableRadiusCenter,LEDParams);

% contrasts
pixPerCycs=256; driftfrequencies=2; phases=[0];
contrasts = [0:0.2:1]; durations=[3];
radius={2,'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=1;
scaleFactor=0;interTrialLuminance={.5,30};
doCombos=true;
changeableAnnulusCenter=false;
changeableRadiusCenter = false;

orientations=[pi/4 5*pi/4];
contrast256FF_Right = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter,changeableRadiusCenter,LEDParams);
orientations=[-pi/4 3*pi/4];
contrast256FF_Left = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter,changeableRadiusCenter,LEDParams);

%% autopilot
rewardSizeULorMS        =150;
requestRewardSizeULorMS =50;
requestMode='first';
msPenalty               =1000;
fractionOpenTimeSoundIsOn=1;
fractionPenaltySoundIsOn=1;
scalar=1;
msAirpuff=msPenalty;
constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,requestMode,msPenalty,...
    fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msAirpuff);
percentCorrectionTrials=.5; sm=makeStandardSoundManager();
eyeController=[];
frameDropCorner={'off'};dropFrames=false;
displayMethod='ptb'; requestPort='none'; 
saveDetailedFramedrops=false; delayManager=[]; responseWindowMs=[]; showText='light';

ap=autopilot(percentCorrectionTrials,sm,constantRewards,eyeController,frameDropCorner,dropFrames,...
    displayMethod,requestPort,saveDetailedFramedrops,delayManager,responseWindowMs,showText);

%% change detector stims
gray=0.5; mean=gray; std = gray*[0.1:0.1:1];
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
scaleFactor=0;interTrialLuminance={.5,30};
stimLocation=[0,0,maxWidth,maxHeight];
stixelSize = [64 64];
stimDurationSecs = 5;frameDurationSecs = 0.01667;
numFrames = {stimDurationSecs,frameDurationSecs};

LEDParams.active = false;
changeDetectorWhiteNoiseStim = whiteNoise({'gaussian',gray,std},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);

durationToFlip.type = 'delta';
durationToFlip.params = 2;
durationAfterFlip = durationToFlip;
  
contrastChangeDetector = changeDetectorSM(changeDetectorWhiteNoiseStim,changeDetectorWhiteNoiseStim,durationToFlip,durationAfterFlip,maxWidth,maxHeight,scaleFactor,interTrialLuminance);  

%% white Noise Bubble stimuli

gray=0.5; mean=gray; std = gray;
minLum = 0;maxLum = 1; sparcity = 0.5;
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
scaleFactor=0;interTrialLuminance={.5,30};
% maxWidth = 1280;maxHeight = 720;
stimLocation=[0,0,maxWidth,maxHeight];
stixelSize = [64 64];
stimDurationSecs = 5;frameDurationSecs = 0.01667;
numFrames = inf;
bubbleDetails.bubbleLocations = {'random',5};
bubbleDetails.bubbleOrder = 'random';
bubbleDetails.bubbleDuration = 100;
bubbleDetails.bubbleNumRepeats = 1;
bubbleDetails.bubbleSize = 0.15;

LEDParams.active = false;
bubbleWhiteNoiseStim = whiteNoiseBubble({'binary',minLum,maxLum,sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,bubbleDetails);

%% contrast and radius sequences
background=gray;
stimSpec.type = 'sequential';
stimSpec.pattern = 'grating';
stimSpec.orientation = 0;
stimSpec.contrastSpace = {1,100,'linspace'};
stimSpec.radiusSpace = {0.3, 0.3, 'linspace'};
stimSpec.location = [0.5 0.5];
stimSpec.numStimuli = 100;
stimSpec.numFramesPerStim = 1;

LEDParams = [];
contrastSequence = contrastDynamics(background,stimSpec,LEDParams,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

stimSpec.numStimuli = 10;
stimSpec.numFramesPerStim = 10;
stimSpec.contrastSpace = {100,100,'linspace'};
stimSpec.radiusSpace = {0.01, 0.3, 'linspace'};
radiusSequence = contrastDynamics(background,stimSpec,LEDParams,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

%% trainingsteps

svnRev={'svn://132.239.158.177/projects/bsriram/Ratrix/branches/multiTrodeStable'};
svnCheckMode='session';

ts{1}= trainingStep(ap,  TRF, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'trf');%temporal response function only slow temp freqs

ts{2}= trainingStep(ap,  spatNoiseDiffContrasts, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'spatNoise_Contrast_NoLED');
ts{3}= trainingStep(ap,  spatNoiseDiffContrasts_LED, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'spatNoise_Contrast_LED');

ts{4}= trainingStep(ap,  orient256FF, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'orientation');
ts{5}= trainingStep(ap,  contrast256FF_Right, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256FF_Right');
ts{6}= trainingStep(ap,  contrast256FF_Left, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256FF_Left');

ts{7}= trainingStep(ap,  contrastChangeDetector, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrastChangeDetector_whiteNoise');

ts{8}= trainingStep(ap,  bubbleWhiteNoiseStim, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode, 'whiteNoiseBubble');

ts{9}= trainingStep(ap,  contrastSequence, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode, 'contrastSequence');
ts{10}= trainingStep(ap,  radiusSequence, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode, 'radiusSequence');

p=protocol('mousePhysAndBehavior',{ts{1:10}});
stepNum=uint8(otherParams.stepNum);

for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'mousePhysAndBehavior','bas');
end


end