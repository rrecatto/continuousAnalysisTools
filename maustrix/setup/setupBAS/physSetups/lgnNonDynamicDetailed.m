function r = lgnNonDynamicDetailed(r,subjIDs,otherParams)


if ~isa(r,'ratrix')
    error('need a ratrix')
end

if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

if ~exist('otherParams','var') || isempty(otherParams)
    otherParams.stepNum = 1;
end

%% temporal stimuli
% full-field temporal
pixPerCycs=2.^(16); driftfrequencies=2.^(-1:3); orientations=[0]; phases=[0];
contrasts=[1]; durations=[3];
radius=5; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

fakeTRF= gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

%% whiteNoise

% ffgwn
gray=0.5;mean=gray;std=gray*(2/3); 
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
stimLocation=[0,0,maxWidth,maxHeight];
stixelSize = [maxWidth maxHeight];
stimDurationSecs = 30;frameDurationSecs = 0.01;
numFrames = {stimDurationSecs,frameDurationSecs};

randMethod = 'twister';
priorState = rand(randMethod);
rand(randMethod,sum(100*clock));
seed1 = rand;
seed2 = rand;
rand(randMethod,priorState);
ffgwn1 = whiteNoise({'gaussian',gray,std,randMethod,seed1},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
ffgwn2 = whiteNoise({'gaussian',gray,std,randMethod,seed2},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
numFrames = 100;
burnthro = whiteNoise({'gaussian',gray,std,randMethod,seed2},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
% spatialsWhiteNoise
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
stimLocation=[0,0,maxWidth,maxHeight];
stimDurationSecs = 30;frameDurationSecs = 0.01;
numFrames = {stimDurationSecs,frameDurationSecs};

minLum = 0; maxLum = 1; nonSparse = 0.5;sparcity = 0.05;

stixelSize = [128 128];
bin6X8 = whiteNoise({'binary',minLum,maxLum,nonSparse},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseBin6X8Bright = whiteNoise({'binary',minLum,maxLum,sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseBin6X8Dark = whiteNoise({'binary',minLum,maxLum,1-sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
stixelSize = [64 64];
bin12X16 = whiteNoise({'binary',minLum,maxLum,nonSparse},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseBin12X16Bright = whiteNoise({'binary',minLum,maxLum,sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseBin12X16Dark = whiteNoise({'binary',minLum,maxLum,1-sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
stixelSize = [32 32];
bin24X32 = whiteNoise({'binary',minLum,maxLum,nonSparse},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

%% spatial gratings
% changeable annuli for locating RF
pixPerCycs=256; driftfrequencies=2; orientations=[0]; phases=[0];
contrasts=[1]; durations=[3];
radius=5; annuli=[0.05 .1 .2 .3 .4 .5 2];
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
doCombos=true;
changeableAnnulusCenter=true;

findRFManual = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
changeableAnnulusCenter=false; %totally messses with other gratings if set to true

% location of RF
if iswin
    RFdataSource='\\132.239.158.164\onTheFly'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
elseif IsLinux
    RFdataSource='~/Documents/datanetOutput'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
end
prevLocation = RFestimator({'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},{'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},[],RFdataSource,[now-100 Inf]);


% sftuning
pixPerCycs=2.^([6:0.5:10]); driftfrequencies=2; orientations=[0]; phases=[0];
contrasts=[1]; durations=[3];
radius=5; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

radius={.25,'hardEdge'};
contrasts = [1];
sfSmallFullC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.5];
sfSmallHalfC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.25];
sfSmallQuatC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

radius={2,'hardEdge'};
contrasts = [1];
sfFFFullC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.5];
sfFFHalfC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.25];
sfFFQuatC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

% contrasts
pixPerCycs=256; driftfrequencies=2; orientations=[0]; phases=[0];
contrasts = [0:0.2:1]; durations=[3];
radius={.25,'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
doCombos=true;
changeableAnnulusCenter=false;

radius={.25,'hardEdge'};
contrast512Small = gratings(512,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast256Small = gratings(256,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast128Small = gratings(128,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast64Small = gratings(64,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

radius={2,'hardEdge'};
contrast512FF = gratings(512,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast256FF = gratings(256,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast128FF = gratings(128,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast64FF = gratings(64,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

% areaSummation
pixPerCycs=256; driftfrequencies=2; orientations=[0]; phases=[0];
contrasts = 1; durations=[3];
radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

ppC = 256; contrasts = 1;
aSum256FullC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = 0.5;
aSum256HalfC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = 0.25;
aSum256QuatC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = [1 0.5];
aSum256FullAndHalfC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = [1 0.25];
aSum256FullAndQuatC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);


ppC = 128; contrasts = 1;
aSum128FullC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = 0.5;
aSum128HalfC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = 0.25;
aSum128QuatC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = [1 0.5];
aSum128FullAndHalfC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = [1 0.25];
aSum128FullAndQuatC = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

% manual camera calib
numSweeps=int8(3);
background=gray;maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
cmr = manualCmrMotionEyeCal(background,numSweeps,maxWidth,maxHeight,scaleFactor,interTrialLuminance);


%% other stuff
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

%% trainingsteps

svnRev={'svn://132.239.158.177/projects/bsriram/Ratrix/branches/multiTrodeStable'};
svnCheckMode='session';


%% detailed
ts{1}= trainingStep(ap,  fakeTRF, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'trf');%temporal response function only slow temp freqs
ts{2}= trainingStep(ap,  ffgwn1, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'ffgwn1');
ts{3}= trainingStep(ap,  ffgwn2, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'ffgwn2');

ts{4}= trainingStep(ap,  bin6X8,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin6X8'); %full field gaussian white noise
ts{5}= trainingStep(ap,  sparseBin6X8Bright,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBin6X8Bright'); %full field gaussian white noise
ts{6}= trainingStep(ap,  sparseBin6X8Dark,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBin6X8Dark'); %full field gaussian white noise

ts{7}= trainingStep(ap,  bin12X16,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin12x16'); %full field gaussian white noise
ts{8}= trainingStep(ap,  sparseBin12X16Bright,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBin12X16Bright'); %full field gaussian white noise
ts{9}= trainingStep(ap,  sparseBin12X16Dark,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBin12X16Dark'); %full field gaussian white noise

ts{10}= trainingStep(ap,  bin24X32,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin24X32'); %full field gaussian white noise

ts{11} = trainingStep(ap,  findRFManual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'findRFManual');  %temporal response function

ts{12} = trainingStep(ap,  sfSmallFullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfSmallFullC');  %temporal response function
ts{13} = trainingStep(ap,  sfSmallHalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfSmallHalfC');  %temporal response function
ts{14} = trainingStep(ap,  sfSmallQuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfSmallQuatC');  %temporal response function

ts{15} = trainingStep(ap,  sfFFFullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfSmallFullC');  %temporal response function
ts{16} = trainingStep(ap,  sfFFHalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfFFHalfC');  %temporal response function
ts{17} = trainingStep(ap,  sfFFQuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfFFQuatC');  %temporal response function

ts{18} = trainingStep(ap,  contrast512Small,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast512Small');  %temporal response function
ts{19} = trainingStep(ap,  contrast256Small,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256Small');  %temporal response function
ts{20} = trainingStep(ap,  contrast128Small,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast128Small');  %temporal response function
ts{21} = trainingStep(ap,  contrast64Small,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast64Small');  %temporal response function

ts{22} = trainingStep(ap,  contrast512FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast512FF');  %temporal response function
ts{23} = trainingStep(ap,  contrast256FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256FF');  %temporal response function
ts{24} = trainingStep(ap,  contrast128FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast128FF');  %temporal response function
ts{25} = trainingStep(ap,  contrast64FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast64FF');  %temporal response function

ts{26} = trainingStep(ap,  aSum256FullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullC');  %temporal response function
ts{27} = trainingStep(ap,  aSum256HalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256HalfC');  %temporal response function
ts{28} = trainingStep(ap,  aSum256QuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256QuatC');  %temporal response function
ts{29} = trainingStep(ap,  aSum128FullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128FullC');  %temporal response function
ts{30} = trainingStep(ap,  aSum128HalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128HalfC');  %temporal response function
ts{31} = trainingStep(ap,  aSum128QuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128QuatC');  %temporal response function

ts{32} = trainingStep(ap,  aSum256FullAndHalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullAndHalfC');  %temporal response function
ts{33} = trainingStep(ap,  aSum256FullAndQuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullAndQuatC');  %temporal response function
ts{34} = trainingStep(ap,  aSum128FullAndHalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128FullAndHalfC');  %temporal response function
ts{35} = trainingStep(ap,  aSum128FullAndQuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128FullAndQuatC');  %temporal response function

% burnthro
ts{36} = trainingStep(ap,  burnthro,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'burnthro');  %temporal response function
ts{37} = trainingStep(ap,  cmr,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'cmr');  %temporal response function

p=protocol('detailedLGNProtocol',{ts{1:37}});
stepNum=uint8(otherParams.stepNum);

for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'setProtocolLGNNonDynamic','bs');
end


