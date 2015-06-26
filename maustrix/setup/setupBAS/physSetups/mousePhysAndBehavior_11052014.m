function r = mousePhysAndBehavior_11052014(r,subjIDs,otherParams)
if ~isa(r,'ratrix')
    error('need a ratrix')
end
if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

if ~exist('otherParams','var') || isempty(otherParams)
    otherParams.stepNum = 4;
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
scaleFactor=0;interTrialLuminance={.5,15};
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
scaleFactor=0;interTrialLuminance={.5,15};
stimLocation=[0,0,maxWidth,maxHeight];
stixelSize = [64 64];
stimDurationSecs = 5;frameDurationSecs = 0.01667;
numFrames = {stimDurationSecs,frameDurationSecs};

LEDParams.active = false;
spatNoiseDiffContrasts = whiteNoise({'gaussian',gray,std},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);
LEDParams.active = true;
spatNoiseDiffContrasts_LED = whiteNoise({'gaussian',gray,std},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);

%% white Noise Bubble stimuli

gray=0.5; mean=gray; std = gray;
minLum = 0;maxLum = 1; sparcity = 0.5;
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
scaleFactor=0;interTrialLuminance={.5,15};
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

%% gratings


% basic details for stim
pixPerCycs={[128],[128]};
driftfreqs={[0],[0]};
ors = [45];
orientations={-deg2rad(ors),deg2rad(ors)};
phases={[0 pi/4 pi/2 3*pi/4 pi],[0 pi/4 pi/2 3*pi/4 pi]};

phases={0,0};
contrasts = {[0.15 1],[0.15,1]};
maxDurationSweep={[0.016 0.032 0.048 0.096 0.192],[0.016 0.032 0.048 0.096 0.192]};
radii={1,1};annuli={0,0};location={[.5 .5],[0.5 0.5]};
waveform= 'sine';radiusType='hardEdge';normalizationMethod='normalizeDiagonal';
mean=0.5;thresh=.00005;

scaleFactor=0;
interTrialLuminance={.5,15};
doCombos = true;
doPostDiscrim = false;

maxWidth = 1920;
maxHeight = 1080;

LEDParams.active = false;
apGratings = afcGratings(pixPerCycs,driftfreqs,orientations,phases,contrasts,maxDurationSweep,...
    radii,radiusType,annuli,location,waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,...
    scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);

LEDParams.active = true;
apGratings_LED = afcGratings(pixPerCycs,driftfreqs,orientations,phases,contrasts,maxDurationSweep,...
    radii,radiusType,annuli,location,waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,...
    scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);

%% freeStim
pixPerCycs              =[128];
targetOrientations      =[-pi/4,pi/4];
distractorOrientations  =[];
mean                    =.5;
radius                  =.1;
contrast                =1;
thresh                  =.00005;
yPosPct                 =.5;
scaleFactor            = 0; %[1 1];
interTrialLuminance     ={.5,15};
freeStim = orientedGabors(pixPerCycs,targetOrientations,distractorOrientations,mean,radius,contrast,thresh,yPosPct,maxWidth,maxHeight,scaleFactor,interTrialLuminance);


%% reinforcedAutopilot
rewardSizeULorMS        =50;
requestRewardSizeULorMS =10;
requestMode='first';
msPenalty               =1000;
fractionOpenTimeSoundIsOn=1;
fractionPenaltySoundIsOn=1;
scalar=1;
msAirpuff=msPenalty;
rewardProbability = 0.1;
probConstantRewards=probabilisticConstantReinforcement(rewardSizeULorMS,rewardProbability,requestRewardSizeULorMS,requestMode,msPenalty,...
    fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msAirpuff);
constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,requestMode,msPenalty,...
    fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msAirpuff);
percentCorrectionTrials=.5; sm=makeStandardSoundManager();
eyeController=[];
frameDropCorner={'off'};dropFrames=false;
displayMethod='ptb'; requestPort='none'; 
saveDetailedFramedrops=false; delayManager=[]; responseWindowMs=[]; showText='light';

ap=reinforcedAutopilot(percentCorrectionTrials,sm,constantRewards,eyeController,frameDropCorner,dropFrames,...
    displayMethod,requestPort,saveDetailedFramedrops,delayManager,responseWindowMs,showText);

apProbReward=reinforcedAutopilot(percentCorrectionTrials,sm,probConstantRewards,eyeController,frameDropCorner,dropFrames,...
    displayMethod,requestPort,saveDetailedFramedrops,delayManager,responseWindowMs,showText);

%% freeDrinks
rewardSizeULorMS          =50;
requestRewardSizeULorMS   =10;
requestMode               ='first';
msPenalty                 =1000;
fractionOpenTimeSoundIsOn =1;
fractionPenaltySoundIsOn  =1;
scalar                    =0.1;
msAirpuff                 =msPenalty;

constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,requestMode,msPenalty,fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msAirpuff);

allowRepeats=false;
freeDrinkLikelihood=0.003;
fd = freeDrinksCenterOnly(sm,freeDrinkLikelihood,allowRepeats,constantRewards);

fd2 = freeDrinksSidesOnly(sm,freeDrinkLikelihood,allowRepeats,constantRewards);

fd3 = freeDrinksAlternate(sm,freeDrinkLikelihood,allowRepeats,constantRewards);

%% trainingsteps

svnRev={'svn://132.239.158.177/projects/bsriram/Ratrix/branches/multiTrodeStable'};
svnCheckMode='session';

ts{1} = trainingStep(fd, freeStim, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode, 'fdCenter');
ts{2} = trainingStep(fd2, freeStim, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode, 'fdSide');
ts{3} = trainingStep(fd3, freeStim, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode, 'fdAlternate');

ts{4}= trainingStep(ap,  TRF, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'trf');%temporal response function only slow temp freqs

ts{5}= trainingStep(ap,  spatNoiseDiffContrasts, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'spatNoise_Contrast_NoLED');
ts{6}= trainingStep(ap,  spatNoiseDiffContrasts_LED, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'spatNoise_Contrast_LED');

ts{7}= trainingStep(ap,  bubbleWhiteNoiseStim, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bubbleWN');

ts{8}= trainingStep(apProbReward,  apGratings, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'gratings');
ts{9}= trainingStep(apProbReward,  apGratings_LED, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'gratings_LED');

p=protocol('mousePhysAndBehavior',{ts{1:9}});
stepNum=uint8(otherParams.stepNum);

for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj, r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'mousePhysAndBehavior','bas');
end


end