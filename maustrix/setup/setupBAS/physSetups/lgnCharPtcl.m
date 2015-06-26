function r = lgnCharPtcl(r,subjIDs)

if ~isa(r,'ratrix')
    error('need a ratrix')
end

if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

%% define stim managers
pixPerCycs              =[20];
mean                    =.5;
radius                  =.04;
contrast                =1;
thresh                  =.00005;
yPosPct                 =.65;
maxWidth                =1024;
maxHeight               =768;
scaleFactor             =[1 1];
interTrialLuminance     =.5;


% gratings
pixPerCycs=2.^([4:0.5:8]); % freq
driftfrequencies=[2];  % in cycles per second


%% temporal stimuli
% full-field temporal
annuli=0;                        % reset
location=[.5 .5];                % center of mask
driftfrequencies=2.^(-1:3);      % in cycles per second
orientations=[0];                % in radians, vert
phases=[0];                      % initial phase
contrasts=[1];                   % contrast of the grating
durations=[3];                   % duration of each grating
pixPerCycs=2.^(16);              % freq really broad approximates fullfield homogenous
radius=5;              % radius of the circular mask, 5= five times screen hieght
location=[.5 .5];      % center of mask
waveform='sine';     
normalizationMethod='normalizeDiagonal';
mean=0.5;
numRepeats=3;
scaleFactor=0;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;

fakeTRF= gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

%% whiteNoise
gray=0.5;
mean=gray;
std=gray*(2/3); 
searchSubspace=[1];
background=gray;
method='texOnPartOfScreen';
stixelSize = [32 32];% [128 128];% [128 128]; %[32,32];
changeable=false;

%fullField 
stimLocation=[0,0,maxWidth,maxHeight];
numFrames=3000;   %100 to test; 5*60*100=30000 for experiment
numFrames={30,0.2}; %100 to test; 5*60*100=30000 for experiment
stixelSize = [maxWidth maxHeight ];

ffgwn = whiteNoise({'gaussian',gray,std},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

bin6x8 = whiteNoise({'binary',0,1,.5},background,method,stimLocation,[128 128],searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
bin12x16 = whiteNoise({'binary',0,1,.5},background,method,stimLocation,[64 64],searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

sparseness=0.05; %sparseness
sparseBright=whiteNoise({'binary',0.5,1,sparseness},background,method,stimLocation,[64 64],searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
sparseDark=whiteNoise({'binary',0,0.5,1-sparseness},background,method,stimLocation,[64 64],searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

% burn thro
burnthro = whiteNoise({'gaussian',gray,std},background,method,stimLocation,stixelSize,searchSubspace,5,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

%% changeable - find RF centre

radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'gaussian'}; % radii of the grating
contrasts=1; % reset to one value
pixPerCycs = 256;
changeableAnnulusCenter = true;
driftfrequencies=2;
radGratingsChangeable = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

radius = 5;
annuli=[0.02 0.05 .1 .2 .3 .4 .5 2]; % annulus of the grating
anGratingsChangeable = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

changeableAnnulusCenter = false;
% location of RF
if iswin
    RFdataSource='\\132.239.158.164\onTheFly'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
elseif IsLinux
    RFdataSource='~/Documents/datanetOutput'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
end
dynamicLocation = RFestimator({'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},{'gratingWithChangeableAnnulusCenter','lastDynamicSettings',[]},[],RFdataSource,[now-100 Inf]);

radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'hardEdge'}; % radii of the grating
%% gratings - basic chars
pixPerCycs=2.^([4:0.5:8]); % freq
driftfrequencies=[2];  % in cycles per second
orientations=[0];       % in radians, vert
phases=[0];            % initial phase
contrasts=[1];       % contrast of the grating
durations=[3];         % duration of each grating
annuli=0;              % radius of inner annuli
location=dynamicLocation;      % center of mask
waveform='sine';     
normalizationMethod='normalizeDiagonal';
mean=0.5;
numRepeats=3;
scaleFactor=0;
doCombos = true;
changeableAnnulusCenter=false;

% sfGratings
radius={.25,'hardEdge'};
sfGratingsSine = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
radius={2,'hardEdge'};
sfGratingsSineFF = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

if iswin
    SFdataSource='\\132.239.158.164\onTheFly'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
elseif IsLinux
    SFdataSource='~/Documents/datanetOutput'; % good only as long as default stations don't change, %how do we get this from the dn in the station!?
end

optimalSF = SFestimator(SFdataSource,{'gratingsSF','highestF1'},[floor(now) Inf]);
contrasts = [0:0.2:1];

% cntrGrating
radius={.25,'hardEdge'};
cntrGratingsSine256 = gratings(256,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
cntrGratingsSine128 = gratings(128,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
cntrGratingsSine64 = gratings(64,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
cntrGratingsSine32 = gratings(32,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
%ff contrast
radius={2,'hardEdge'};
cntrGratingsSine256FF = gratings(256,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
cntrGratingsSine128FF = gratings(128,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
cntrGratingsSine64FF = gratings(64,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);
cntrGratingsSine32FF = gratings(32,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

cntrGratingsSineOptimal = gratings(optimalSF,driftfrequencies,orientations,phases,contrasts,durations,radius,annuli,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

%% area summation
% 256
annulus = 0;
changeableAnnulusCenter = false;
radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'hardEdge'};
pixPerCycs = 256;

contrasts = 1; 
radGratingsPPC256Ctr100 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.8;
radGratingsPPC256Ctr80 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.6;
radGratingsPPC256Ctr60 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.4; 
radGratingsPPC256Ctr40 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.2;
radGratingsPPC256Ctr20 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

% 128
annulus = 0;
changeableAnnulusCenter = false;
radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'hardEdge'};
pixPerCycs = 128;

contrasts = 1; 
radGratingsPPC128Ctr100 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.8;
radGratingsPPC128Ctr80 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.6;
radGratingsPPC128Ctr60 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.4; 
radGratingsPPC128Ctr40 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.2;
radGratingsPPC128Ctr20 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);


% 64
annulus = 0;
changeableAnnulusCenter = false;
radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'hardEdge'};
pixPerCycs = 64;

contrasts = 1; 
radGratingsPPC64Ctr100 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.8;
radGratingsPPC64Ctr80 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.6;
radGratingsPPC64Ctr60 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.4; 
radGratingsPPC64Ctr40 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.2;
radGratingsPPC64Ctr20 = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

% optimalSF
annulus = 0;
changeableAnnulusCenter = false;
radii={[0.02 0.05 .1 .2 .3 .4 .5 1],'hardEdge'};

contrasts = 1; 
radGratingsOptimalSFCtr100 = gratings(optimalSF,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.8;
radGratingsOptimalSFCtr80 = gratings(optimalSF,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.6;
radGratingsOptimalSFCtr60 = gratings(optimalSF,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.4; 
radGratingsOptimalSFCtr40 = gratings(optimalSF,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

contrasts = 0.2;
radGratingsOptimalSFCtr20 = gratings(optimalSF,driftfrequencies,orientations,phases,contrasts,durations,radii,annulus,location,...
    waveform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter);

%% other stuff
eyeController=[];

sm=makeStandardSoundManager();


rewardSizeULorMS        =150;
requestRewardSizeULorMS =50;
requestMode='first';
msPenalty               =1000;
fractionOpenTimeSoundIsOn=1;
fractionPenaltySoundIsOn=1;
scalar=1;
msAirpuff=msPenalty;
constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,requestMode,msPenalty,fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msAirpuff);

percentCorrectionTrials=.5;
frameDropCorner=false;
dropFrames=false;
frameDropCorner={'off'};
displayMethod='ptb';
requestPort='center'; 

saveDetailedFramedrops=false;  % default is false... do we want this info, yes if few of them
delayManager=[];
responseWindowMs=[];
showText='light';
afc=nAFC(sm,percentCorrectionTrials,constantRewards,eyeController,frameDropCorner,dropFrames,displayMethod,requestPort,saveDetailedFramedrops,delayManager,responseWindowMs,showText);
requestPort='none'; 
allowRepeats=false;
ap=autopilot(percentCorrectionTrials,sm,constantRewards,eyeController,frameDropCorner,dropFrames,displayMethod,requestPort,saveDetailedFramedrops,delayManager,responseWindowMs,showText);

freeDrinkLikelihood=0.003;
fd = freeDrinks(sm,freeDrinkLikelihood,allowRepeats,constantRewards,eyeController,frameDropCorner,dropFrames,displayMethod,requestPort);
freeDrinkLikelihood=0;
fd2 = freeDrinks(sm,freeDrinkLikelihood,allowRepeats,constantRewards,eyeController,frameDropCorner,dropFrames,displayMethod,requestPort);

% rfIsGood=receptiveFieldCriterion(0.05,RFdataSource,1,'box',3);

numSweeps=int8(3);
cmr = manualCmrMotionEyeCal(background,numSweeps,maxWidth,maxHeight,scaleFactor,interTrialLuminance);


%% trainingsteps

svnRev={'svn://132.239.158.177/projects/ratrix/trunk'};
svnCheckMode='session';

%Search stim
ts{1}= trainingStep(ap,  fakeTRF, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'searchTRF');%temporal response function only slow temp freqs
ts{2}= trainingStep(ap,  ffgwn, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'searchFFGWN');
% RF localization stims whiteNoise
ts{3}= trainingStep(ap,  bin6x8,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin6X8'); %full field gaussian white noise
ts{4}= trainingStep(ap,  bin12x16,       repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'bin12x16'); %full field gaussian white noise
ts{5} = trainingStep(ap,  sparseBright,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseBright');  %temporal response function
ts{6} = trainingStep(ap,  sparseDark,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sparseDark');  %temporal response function

% changeable annuli stims
ts{7} = trainingStep(ap,  radGratingsChangeable,  numTrialsDoneCriterion(3), noTimeOff(), svnRev, svnCheckMode,'radGratingsChangeable');  %temporal response function
ts{8} = trainingStep(ap,  anGratingsChangeable,  numTrialsDoneCriterion(3), noTimeOff(), svnRev, svnCheckMode,'anGratingsChangeable');  %temporal response function

% gratings chars
ts{9} = trainingStep(ap,  sfGratingsSine,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfGratingsSine');  %spatial response function
ts{10} = trainingStep(ap,  sfGratingsSineFF,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'sfGratingsSineFF');  %spatial response function


ts{11} = trainingStep(ap,  cntrGratingsSine256,  numTrialsDoneCriterion(3), noTimeOff(), svnRev, svnCheckMode,'cntrGratingsSine256');  %temporal response function
ts{12} = trainingStep(ap,  cntrGratingsSine256FF,  numTrialsDoneCriterion(3), noTimeOff(), svnRev, svnCheckMode,'cntrGratingsSine256FF');  %temporal response function
% ts{10} = trainingStep(ap,  cntrGratingsSine256,  numTrialsDoneCriterion(3), noTimeOff(), svnRev, svnCheckMode,'cntrGratingsSine256');  %temporal response function
% ts{11} = trainingStep(ap,  cntrGratingsSine128,  numTrialsDoneCriterion(3), noTimeOff(), svnRev, svnCheckMode,'cntrGratingsSine128');  %temporal response function
% ts{12} = trainingStep(ap,  cntrGratingsSine64,  numTrialsDoneCriterion(3), noTimeOff(), svnRev, svnCheckMode,'cntrGratingsSine64');  %temporal response function
% ts{13} = trainingStep(ap,  cntrGratingsSine32,  numTrialsDoneCriterion(3), noTimeOff(), svnRev, svnCheckMode,'cntrGratingsSine32');  %temporal response function

% area summation
% ts{11} = trainingStep(ap,  radGratingsOptimalSFCtr100,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr100');  %temporal response function
% ts{12} = trainingStep(ap,  radGratingsOptimalSFCtr80,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr80');  %temporal response function
% ts{13} = trainingStep(ap,  radGratingsOptimalSFCtr60,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr60');  %temporal response function
% ts{14} = trainingStep(ap,  radGratingsOptimalSFCtr40,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr40');  %temporal response function
% ts{15} = trainingStep(ap,  radGratingsOptimalSFCtr20,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr20');  %temporal response function


ts{13} = trainingStep(ap,  radGratingsPPC256Ctr100,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr100');  %temporal response function
ts{14} = trainingStep(ap,  radGratingsPPC256Ctr80,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr80');  %temporal response function
ts{15} = trainingStep(ap,  radGratingsPPC256Ctr60,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr60');  %temporal response function
ts{16} = trainingStep(ap,  radGratingsPPC256Ctr40,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr40');  %temporal response function
ts{17} = trainingStep(ap,  radGratingsPPC256Ctr20,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC256Ctr20');  %temporal response function
% 
% 
ts{18} = trainingStep(ap,  radGratingsPPC128Ctr100,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC128Ctr100');  %temporal response function
ts{19} = trainingStep(ap,  radGratingsPPC128Ctr80,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC128Ctr80');  %temporal response function
ts{20} = trainingStep(ap,  radGratingsPPC128Ctr60,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC128Ctr60');  %temporal response function
ts{21} = trainingStep(ap,  radGratingsPPC128Ctr40,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC128Ctr40');  %temporal response function
ts{22} = trainingStep(ap,  radGratingsPPC128Ctr20,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC128Ctr20');  %temporal response function
% 
% 
ts{23} = trainingStep(ap,  radGratingsPPC64Ctr100,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC64Ctr100');  %temporal response function
ts{24} = trainingStep(ap,  radGratingsPPC64Ctr80,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC64Ctr80');  %temporal response function
ts{25} = trainingStep(ap,  radGratingsPPC64Ctr60,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC64Ctr60');  %temporal response function
ts{26} = trainingStep(ap,  radGratingsPPC64Ctr40,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC64Ctr40');  %temporal response function
ts{27} = trainingStep(ap,  radGratingsPPC64Ctr20,  numTrialsDoneCriterion(2), noTimeOff(), svnRev, svnCheckMode,'radGratingsPPC64Ctr20');  %temporal response function

% burnthro
ts{28} = trainingStep(ap,  burnthro,  repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode,'burnthro');  %temporal response function



%% make and set it


p=protocol('practice phys',{ts{1:28}});
stepNum=uint8(1);

for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'call to setProtocolPhys','pmm');
end
