function r = lgnNonDynamicBasic(r,subjIDs,rigGeometryParams)

if ~isa(r,'ratrix')
    error('need a ratrix')
end

if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

if ~exist('rigGeometryParams','var')|| isempty(rigGeometryParams)
    rigGeometryParams.distanceToMonitorPlane = 300; %mm
    rigGeometryParams.eyeLevelToMonitorCentre = 100; %mm
end

%% temporal stimuli
% full-field temporal
pixPerCycs=2.^(16); driftfrequencies=[1 2 4 6 8 10 12]; orientations=[0]; phases=[0];
contrasts=[1]; durations=[2];
radius=5; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=2;
maxWidth=1600;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
%maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

fakeTRF= gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
trf = fullField(driftfrequencies,contrasts,durations,radius,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

%% whiteNoise

% ffgwn
gray=0.5;mean=gray;std=gray*(2/3); 
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
maxWidth=1600;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
%maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
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
maxWidth=1600;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
%maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
stimLocation=[0,0,maxWidth,maxHeight];
stimDurationSecs = 30;frameDurationSecs = 0.01;
numFrames = {stimDurationSecs,frameDurationSecs};

minLum = 0; maxLum = 1; nonSparse = 0.5;sparcity = 0.05;

stixelSize = [128 128];
bin6Deg = whiteNoise({'binary',minLum,maxLum,nonSparse},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseBin6DegBright = whiteNoise({'binary',minLum,maxLum,sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseBin6DegDark = whiteNoise({'binary',minLum,maxLum,1-sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
stixelSize = [64 64];
bin3Deg = whiteNoise({'binary',minLum,maxLum,nonSparse},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseBin3DegBright = whiteNoise({'binary',minLum,maxLum,sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseBin3DegDark = whiteNoise({'binary',minLum,maxLum,1-sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
stixelSize = [32 32];
bin1_5Deg = whiteNoise({'binary',minLum,maxLum,nonSparse},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

%% spatial gratings
% changeable annuli for locating RF
pixPerCycs=512; driftfrequencies=4; orientations=[0]; phases=[0];
contrasts=[1]; durations=[2];
radii=[5]; annuli=[0.05 .1 .2 .3 .4 .5 2];
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1600;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
%maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
doCombos=true;
changeableRadiusCenter=false;
changeableAnnulusCenter = true;

findRFManual = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
% findRFManual = fullField(driftfrequencies,contrasts,durations,radius,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
%     maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter,changeableRadiusCenter);

changeableRadiusCenter=false; %totally messses with other gratings if set to true
changeableAnnulusCenter = false;

% location of RF
if IsWin
    RFDataSource='\\132.239.158.169\datanetOutput'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
elseif IsLinux
    RFDataSource='~/Documents/datanetOutput'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
end
manualLocation = RFestimator({'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},{'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},[],RFDataSource,[now-100 Inf]);
RFCenterParams.requestedDetail = 'centerLocation';RFCenterParams.estimationMethod = 'mostModulatedPixel';
binLocation = wnEstimator(RFDataSource,{'binarySpatial'},{'latestSingleUnit'},{RFCenterParams});

% sftuning
pixPerCycs=2.^([6:0.5:10]); driftfrequencies=4; orientations=[0]; phases=[0];
contrasts=[1]; durations=[2];
radius=5; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1600;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
%maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

radius={.25,'hardEdge'};
contrasts = [1];
sfSmallFullC_manual = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.5];
sfSmallHalfC_manual = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.25];
sfSmallQuatC_manual = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [1];
sfSmallFullC_binSpat = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.5];
sfSmallHalfC_binSpat = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.25];
sfSmallQuatC_binSpat = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,binLocation,...
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
pixPerCycs=256; driftfrequencies=4; orientations=[0]; phases=[0];
contrasts = [0:0.2:1]; durations=[2];
radius={.25,'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1600;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
%maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
doCombos=true;
changeableAnnulusCenter=false;

radius={.25,'hardEdge'};
contrast512Small_manual = gratings(512,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast256Small_manual = gratings(256,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast128Small_manual = gratings(128,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast64Small_manual = gratings(64,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrast512Small_binSpat = gratings(512,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast256Small_binSpat = gratings(256,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast128Small_binSpat = gratings(128,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrast64Small_binSpat = gratings(64,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,binLocation,...
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
pixPerCycs=256; driftfrequencies=4; orientations=[0]; phases=[0];
contrasts = 1; durations=[2];
radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
maxWidth=1600;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
%maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

ppC = 256; contrasts = 1;
aSum256FullC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = 0.5;
aSum256HalfC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = 0.25;
aSum256QuatC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = [1 0.5];
aSum256FullAndHalfC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = [1 0.25];
aSum256FullAndQuatC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

ppC = 256; contrasts = 1;
aSum256FullC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = 0.5;
aSum256HalfC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = 0.25;
aSum256QuatC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = [1 0.5];
aSum256FullAndHalfC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 256; contrasts = [1 0.25];
aSum256FullAndQuatC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);



ppC = 128; contrasts = 1;
aSum128FullC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = 0.5;
aSum128HalfC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = 0.25;
aSum128QuatC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = [1 0.5];
aSum128FullAndHalfC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = [1 0.25];
aSum128FullAndQuatC_manual = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,manualLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

ppC = 128; contrasts = 1;
aSum128FullC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = 0.5;
aSum128HalfC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = 0.25;
aSum128QuatC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = [1 0.5];
aSum128FullAndHalfC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
ppC = 128; contrasts = [1 0.25];
aSum128FullAndQuatC_binSpat = gratings(ppC,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);


% manual camera calib
numSweeps=int8(3);
background=gray;
maxWidth=1600;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
%maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
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

%% basic only

ts{1}= trainingStep(ap,  trf, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'trf');

ts{2}= trainingStep(ap,  ffgwn1, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'ffgwn1');
ts{3}= trainingStep(ap,  ffgwn2, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'ffgwn2');

ts{4}= trainingStep(ap,  bin6Deg,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin6Deg'); 
ts{5}= trainingStep(ap,  bin3Deg,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin3Deg'); 

ts{6} = trainingStep(ap,  findRFManual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'findRFManual');

ts{7} = trainingStep(ap,  sfSmallFullC_manual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfSmallFullC_manual'); 
ts{8} = trainingStep(ap,  sfSmallFullC_binSpat,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfSmallFullC_binSpat'); 
ts{9} = trainingStep(ap,  sfFFFullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfFFFullC');

ts{10} = trainingStep(ap,  contrast512Small_manual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast512Small_manual'); 
ts{11} = trainingStep(ap,  contrast256Small_manual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256Small_manual'); 
ts{12} = trainingStep(ap,  contrast512Small_binSpat,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast512Small_binSpat');
ts{13} = trainingStep(ap,  contrast256Small_binSpat,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256Small_binSpat');
ts{14} = trainingStep(ap,  contrast512FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast512FF');
ts{15} = trainingStep(ap,  contrast256FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256FF');

ts{16} = trainingStep(ap,  aSum256FullAndHalfC_manual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullAndHalfC_manual');
ts{17} = trainingStep(ap,  aSum256FullAndQuatC_manual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullAndQuatC_manual');
ts{18} = trainingStep(ap,  aSum128FullAndHalfC_manual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128FullAndHalfC_manual');
ts{19} = trainingStep(ap,  aSum128FullAndQuatC_manual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128FullAndQuatC_manual');

ts{20} = trainingStep(ap,  aSum256FullAndHalfC_binSpat,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullAndHalfC_binSpat');
ts{21} = trainingStep(ap,  aSum256FullAndQuatC_binSpat,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullAndQuatC_binSpat');
ts{22} = trainingStep(ap,  aSum256FullAndHalfC_binSpat,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullAndHalfC_binSpat');
ts{23} = trainingStep(ap,  aSum256FullAndQuatC_binSpat,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullAndQuatC_binSpat');

% burnthro
ts{24} = trainingStep(ap,  burnthro,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'burnthro');
ts{25} = trainingStep(ap,  cmr,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'cmr');

p=protocol('basicLGNProtocol',{ts{1:25}});
stepNum=uint8(9);

for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'setProtocolLGNNonDynamic','bs');
end
%% CHANGELOG
%% June 23 - temporal frequency upped to 4 Hz from 2 Hz. 
% logic? Responses in LGN are better at 4 Hz (for ff) and look here: Girman, Suave and Lund (1999)
