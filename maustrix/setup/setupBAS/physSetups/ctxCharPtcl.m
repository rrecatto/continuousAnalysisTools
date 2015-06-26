function r = ctxCharPtcl(r,subjIDs,otherParams)
if ~isa(r,'ratrix')
    error('need a ratrix')
end

if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

if ~exist('otherParams','var') || isempty(otherParams)
    otherParams.stepNum = 1;
    otherParams.maxWidth = 1920;
    otherParams.maxHeight = 1080;
end

[a,b] = getMACaddress;
switch b
    case 'BC305BD38BFB'
        maxWidth=otherParams.maxWidth;maxHeight=otherParams.maxHeight;
    otherwise
        maxWidth=1920;maxHeight=1080;
end
%% temporal stimuli
% full-field temporal
frequencies=2.^(-1:4);phases=[0];
contrasts=[1]; durations=[3];
radius={inf,'hardEdge'}; annuli=0;
location=[.5 .5];
normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};

TRF= fullField(frequencies,contrasts,durations,radius,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
       maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

%% whiteNoise

% ffgwn
gray=0.5;mean=gray;std=gray*(2/3); 
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
scaleFactor=0;interTrialLuminance=.5;
stimLocation=[0,0,maxWidth,maxHeight];
stixelSize = [maxWidth maxHeight];
stimDurationSecs = 30;frameDurationSecs = 0.01667;
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
scaleFactor=0;interTrialLuminance=.5;
stimLocation=[0,0,maxWidth,maxHeight];
stimDurationSecs = 30;frameDurationSecs = 0.01667;
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
% SF
pixPerCycs=2.^([6:0.5:10]); driftfrequencies=2; orientations=[0]; phases=[0];
contrasts=[1]; durations=[3];
radius={inf,'gaussian'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

radius={inf,'gaussian'};
contrasts = [1];
sfFFFullC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.5];
sfFFHalfC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.25];
sfFFQuatC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

% orientations
pixPerCycs=256; driftfrequencies=2; orientations=[-pi:pi/8:pi]; phases=[0];
contrasts = [1]; durations=[3];
radius={.25,'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

radius={inf,'gaussian'};

orient512FF = gratings(512,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
orient256FF = gratings(256,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
orient128FF = gratings(128,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
orient64FF = gratings(64,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);



% contrasts
pixPerCycs=256; driftfrequencies=2; orientations=[0]; phases=[0];
contrasts = [0:0.2:1]; durations=[3];
radius={.25,'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
scaleFactor=0;interTrialLuminance=.5;
doCombos=true;
changeableAnnulusCenter=false;

radius={inf,'gaussian'};

contrast512FF = gratings(512,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast256FF = gratings(256,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast128FF = gratings(128,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast64FF = gratings(64,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);



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

ts{1}= trainingStep(ap,  TRF, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'trf');%temporal response function only slow temp freqs

ts{2}= trainingStep(ap,  ffgwn1, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'ffgwn1');
ts{3}= trainingStep(ap,  ffgwn2, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'ffgwn2');

ts{4}= trainingStep(ap,  bin6X8, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin6X8'); 
ts{5}= trainingStep(ap,  bin12X16, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin12x16');
ts{6}= trainingStep(ap,  bin24X32, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin24X32');

ts{7}= trainingStep(ap,  sparseBin6X8Bright, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBin6X8Bright');
ts{8}= trainingStep(ap,  sparseBin6X8Dark, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBin6X8Dark');
ts{9}= trainingStep(ap,  sparseBin12X16Bright, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBin12X16Bright');
ts{10}= trainingStep(ap,  sparseBin12X16Dark, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBin12X16Dark');

ts{11} = trainingStep(ap,  sfFFFullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfFullC');
ts{12} = trainingStep(ap,  sfFFHalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfHalfC');
ts{13} = trainingStep(ap,  sfFFQuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfQuatC');


ts{14} = trainingStep(ap,  orient512FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'orient512FF');
ts{15} = trainingStep(ap,  orient256FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'orient256FF');
ts{16} = trainingStep(ap,  orient128FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'orient128FF');
ts{17} = trainingStep(ap,  orient64FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'orient64FF');

ts{18} = trainingStep(ap,  contrast512FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast512FF');
ts{19} = trainingStep(ap,  contrast256FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256FF');
ts{20} = trainingStep(ap,  contrast128FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast128FF');
ts{21} = trainingStep(ap,  contrast64FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast64FF');


ts{22} = trainingStep(ap,  burnthro,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'burnthro');

p=protocol('basicCtxPtclNonDynamic',{ts{1:22}});
stepNum=uint8(otherParams.stepNum);

for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'setProtocolLGNNonDynamic','bs');
end