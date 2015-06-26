function r = lgnDynamic(r,subjIDs,otherParams)

if ~isa(r,'ratrix')
    error('need a ratrix')
end

if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

if ~exist('otherParams','var') || isempty(otherParams)
    otherParams.stepNum = 1;
    rigGeometryParams.monitorWidth = 566; %mm
    rigGeometryParams.monitorHeight = 368; %mm
    rigGeometryParams.angleWithNormalToMonitor = 0; %degrees
    rigGeometryParams.distanceToMonitorPlane = 300; %mm
    rigGeometryParams.eyeLevelToMonitorCentre = 100; %mm
    otherParams.rigGeometryParams = rigGeometryParams;    
end

%% temporal stimuli
% full-field temporal
pixPerCycs=2.^(16); driftfrequencies=2.^(0:4); orientations=[0]; phases=[0];
contrasts=[1]; durations=[3];
radius=5; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
%maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
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
%maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
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
%maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
stimLocation=[0,0,maxWidth,maxHeight];
stimDurationSecs = 30;frameDurationSecs = 0.01;
numFrames = {stimDurationSecs,frameDurationSecs};

minLum = 0; maxLum = 1; nonSparse = 0.5;sparcity = 0.05;
%% figure out 
degreesHorizontal = 180/pi*2*atan(rigGeometryParams.monitorWidth/(2*rigGeometryParams.distanceToMonitorPlane));
degreesVertical = 180/pi*2*atan(rigGeometryParams.monitorHeight/(2*rigGeometryParams.distanceToMonitorPlane));

numPix5Degrees = round((5/degreesHorizontal)*maxWidth);
% make the numPix a Round number thats divides maxWidth
numPix5Degrees = maxWidth/(round(maxWidth/numPix5Degrees));
stixelSize = [numPix5Degrees numPix5Degrees];
bin5Deg = whiteNoise({'binary',minLum,maxLum,nonSparse},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sp5DegBright = whiteNoise({'binary',minLum,maxLum,sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sp5DegDark = whiteNoise({'binary',minLum,maxLum,1-sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

numPix2_5Degrees = round(numPix5Degrees/2);

stixelSize = [numPix2_5Degrees numPix2_5Degrees];
bin2_5Deg = whiteNoise({'binary',minLum,maxLum,nonSparse},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sp2_5DegBright = whiteNoise({'binary',minLum,maxLum,sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sp2_5DegDark = whiteNoise({'binary',minLum,maxLum,1-sparcity},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

%% spatial gratings
% changeable annuli for locating RF (20 Degrees)
numPix20Degrees = 4*numPix5Degrees;
pixPerCycs=numPix20Degrees; driftfrequencies=2; orientations=[0]; phases=[0];
contrasts=[1]; durations=[3];
radius=5; annuli=[0.05 .1 .2 .3 .4 .5 2];
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
%maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
doCombos=true;
changeableAnnulusCenter=true;

findRFManual = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
changeableAnnulusCenter=false; %totally messses with other gratings if set to true

% location of RF
if IsWin
    RFDataSource='\\132.239.158.169\datanetOutput'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
elseif IsLinux
    RFDataSource='~/Documents/datanetOutput'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
end
manualLocation = RFestimator({'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},{'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},[],RFDataSource,[now-100 Inf]);
locationParams.requestedDetail = 'centerLocation';locationParams.estimationMethod = 'mostMosulatedPixel';
binLocation = wnEstimator(RFDataSource,{'binarySpatial'},{'latestSingleUnit'},locationParams);

% sftuning
pixPerCycs=numPix5Degrees*[0.5 1 2 4 8 16]; driftfrequencies=2; orientations=[0]; phases=[0]; %[2.5 5 10 20 40 80] in degrees
contrasts=[1]; durations=[3];
radius=5; annuli=0;
center=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
%maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

smallRadius={.25,'hardEdge'};
contrasts = [1];
sfSmallFullC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,smallRadius,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.25];
sfSmallQuatC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,smallRadius,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [1 0.5 0.25];
sfMultipleC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,smallRadius,annuli,binLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

FFRadius={2,'hardEdge'};
contrasts = [1];
sfFFFullC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,FFRadius,annuli,center,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [0.25];
sfFFQuatC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,FFRadius,annuli,center,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrasts = [1 0.5 0.25];
sfFFMultipleC = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,FFRadius,annuli,center,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

%% everything is optimized from here on
% trf after choosing an SF
sfParams.estimationMethod = 'optimalF1GreaterThan'; sfParams.value = numPix5Degrees*3; %15 degrees
chosenSF = grEstimator(RFDataSource,{'sfGratings'},{'latestSingleUnit'},sfParams);
setSF = 256;
trfSmallOptimalSF = gratings(chosenSF,driftfrequencies,orientations,phases,contrasts,durations,smallRadius,annuli,center,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
trfFFOptimalSF = gratings(chosenSF,driftfrequencies,orientations,phases,contrasts,durations,FFRadius,annuli,center,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
trfSmallSetSF = gratings(setSF,driftfrequencies,orientations,phases,contrasts,durations,smallRadius,annuli,center,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
trfFFSetFF = gratings(setSF,driftfrequencies,orientations,phases,contrasts,durations,FFRadius,annuli,center,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);



tfParams.estimationMethod = 'highestF1';
chosenTF = grEstimator(RFDataSource,{'tfGratings'},{'latestSingleUnit'},tfParams);

% contrasts
pixPerCycs=256; driftfrequencies=2; orientations=[0]; phases=[0];
contrasts = [0:0.2:1]; durations=[3];
radius={.25,'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
%maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
doCombos=true;
changeableAnnulusCenter=false;

contrastOptTF_SF_Small = gratings(chosenSF,chosenTF,orientations,phases,contrasts,durations,smallRadius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrastNonOpt_Small = gratings(numPix5Degrees*3,driftfrequencies,orientations,phases,contrasts,durations,smallRadius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrastOptTF_SF_FF = gratings(chosenSF,chosenTF,orientations,phases,contrasts,durations,FFRadius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
contrastNonOpt_FF = gratings(numPix5Degrees*3,driftfrequencies,orientations,phases,contrasts,durations,FFRadius,annuli,prevLocation,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

% areaSummation
pixPerCycs=256; driftfrequencies=2; orientations=[0]; phases=[0];
contrasts = 1; durations=[3];
radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'hardEdge'}; annuli=0;
location=[.5 .5];
waveform='sine'; normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
%maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
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
background=gray;
%maxWidth=1024;maxHeight=768;scaleFactor=0;interTrialLuminance=.5;
maxWidth=1920;maxHeight=1200;scaleFactor=0;interTrialLuminance=.5;
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

ts{1}= trainingStep(ap,  fakeTRF, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'trf');%temporal response function only slow temp freqs
ts{2}= trainingStep(ap,  ffgwn1, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'ffgwn1');
ts{3}= trainingStep(ap,  ffgwn2, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'ffgwn2');
ts{4}= trainingStep(ap,  bin6X8,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin6X8'); %full field gaussian white noise
ts{5}= trainingStep(ap,  bin12X16,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin12x16'); %full field gaussian white noise
ts{6} = trainingStep(ap,  findRFManual,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'findRFManual');  %temporal response function
ts{7} = trainingStep(ap,  sfSmallFullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfSmallFullC');  %temporal response function
ts{8} = trainingStep(ap,  sfFFFullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfFFFullC');  %temporal response function
ts{9} = trainingStep(ap,  contrast512Small,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast512Small');  %temporal response function
ts{10} = trainingStep(ap,  contrast256Small,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256Small');  %temporal response function
ts{11} = trainingStep(ap,  contrast512FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast512FF');  %temporal response function
ts{12} = trainingStep(ap,  contrast256FF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'contrast256FF');  %temporal response function
ts{13} = trainingStep(ap,  aSum256FullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256FullC');  %temporal response function
ts{14} = trainingStep(ap,  aSum256HalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256HalfC');  %temporal response function
ts{15} = trainingStep(ap,  aSum256QuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum256QuatC');  %temporal response function
ts{16} = trainingStep(ap,  aSum128FullC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128FullC');  %temporal response function
ts{17} = trainingStep(ap,  aSum128HalfC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128HalfC');  %temporal response function
ts{18} = trainingStep(ap,  aSum128QuatC,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'aSum128QuatC');  %temporal response function
% burnthro
ts{19} = trainingStep(ap,  burnthro,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'burnthro');  %temporal response function
ts{20} = trainingStep(ap,  cmr,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'cmr');  %temporal response function

p=protocol('basicLGNProtocol',{ts{1:20}});
stepNum=uint8(1);

for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'setProtocolLGNNonDynamic','bs');
end