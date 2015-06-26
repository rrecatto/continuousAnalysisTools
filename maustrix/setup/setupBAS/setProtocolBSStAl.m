function r = setProtocolBSStAl(r,subjIDs)
%% Check for basics
if ~isa(r,'ratrix')
    error('need a ratrix')
end

if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

%% Create Sound Manager
sm=makeStandardSoundManager();

%% Reward Manager
rewardSizeULorMS          =50;
requestRewardSizeULorMS   =10;
requestMode               ='first';
msPenalty                 =1000;
fractionOpenTimeSoundIsOn =1;
fractionPenaltySoundIsOn  =1;
scalar                    =1;
msAirpuff                 =msPenalty;

constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,requestMode,msPenalty,fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msAirpuff);

allowRepeats=false;
freeDrinkLikelihood=0.003;
fd = freeDrinks(sm,freeDrinkLikelihood,allowRepeats,constantRewards);

freeDrinkLikelihood=0;
fd2 = freeDrinks(sm,freeDrinkLikelihood,allowRepeats,constantRewards);

percentCorrectionTrials=.5;

maxWidth               = 800;
maxHeight              = 600;

%% gratings


% basic details for stim
pixPerCycs={[128],[128]};
driftfreqs={[0],[0]};
ors = [45];
orientations={-deg2rad(ors),deg2rad(ors)};
phases={[0 pi/4 pi/2 3*pi/4 pi],[0 pi/4 pi/2 3*pi/4 pi]};

phases={0,0};
contrasts = {[0.15 1],[0.15,1]};
maxDurationSweep={0.016,0.016};
radii={1,1};annuli={0,0};location={[.5 .5],[0.5 0.5]};
waveform= 'sine';radiusType='hardEdge';normalizationMethod='normalizeDiagonal';
mean=0.5;thresh=.00005;

scaleFactor=0;
interTrialLuminance={.5,5};
doCombos = true;
doPostDiscrim = false;

maxWidth = 1920;
maxHeight = 1080;

LEDParams.active = false;
apGratings = afcGratings(pixPerCycs,driftfreqs,orientations,phases,contrasts,maxDurationSweep,...
    radii,radiusType,annuli,location,waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,...
    scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);

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

%% Eyetrack
eyetrack=false;
if eyetrack
    alpha=12; %deg above...really?
    beta=0;   %deg to side... really?
    settingMethod='none';  % will run with these defaults without consulting user, else 'guiPrompt'
    eyeTracker=geometricTracker('cr-p', 2, 3, alpha, beta, int16([1280,1024]), [42,28], int16([maxWidth,maxHeight]), [400,290], 300, -55, 0, 45, 0,settingMethod,10000);
else
    eyeTracker=[];
end
eyeController=[];


%% DataNet
dataNetOn=false;
if dataNetOn
    ai_parameters.numChans=3;
    ai_parameters.sampRate=40000;
    ai_parameters.inputRanges=repmat([-1 6],ai_parameters.numChans,1);
    dn=datanet('stim','localhost','132.239.158.169','\\132.239.158.169\datanet_storage',ai_parameters)
else
    dn=[];
end

%% Start Creating Trial Managers

%% Vertical Horizontal Discrimination
% {'flickerRamp',[0 .5]}
dropFrames=false;
vh=nAFC(sm,percentCorrectionTrials,constantRewards,eyeController,{'off'},dropFrames,'ptb','center');

%% Oriented Grating autopilot

frameDropCorner={'off'};
displayMethod='ptb';
requestPort='center';
saveDetailedFramedrops=false;  % default is false... do we want this info, yes if few of them
delayManager=[];
responseWindowMs=[];
showText='light';

og=autopilot(percentCorrectionTrials,sm,constantRewards,eyeController,{'off'}, dropFrames,displayMethod,requestPort,saveDetailedFramedrops,delayManager,responseWindowMs,showText); 

ap=autopilot(percentCorrectionTrials,sm,constantRewards,eyeController,frameDropCorner,dropFrames,displayMethod,requestPort,saveDetailedFramedrops,delayManager,responseWindowMs,showText);

apProbReward=reinforcedAutopilot(percentCorrectionTrials,sm,probConstantRewards,eyeController,frameDropCorner,dropFrames,...
    displayMethod,requestPort,saveDetailedFramedrops,delayManager,responseWindowMs,showText);
%% Start Creating Stim Managers

%% Oriented Gabors
pixPerCycs              =[20];
targetOrientations      =[pi/4 5*pi/4];
distractorOrientations  =[];
mean                    =.5;
radius                  =.04;
contrast                =1;
thresh                  =.00005;
yPosPct                 =.65;
%screen('resolutions') returns values too high for our NEC MultiSync FE992's -- it must just consult graphics card
scaleFactor            = 0; %[1 1];
interTrialLuminance     =.5;
freeStim = orientedGabors(pixPerCycs,targetOrientations,distractorOrientations,mean,radius,contrast,thresh,yPosPct,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

pixPerCycs=[20];
distractorOrientations=[];
discrimStim = orientedGabors(pixPerCycs,targetOrientations,distractorOrientations,mean,radius,contrast,thresh,yPosPct,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

%% Oriented Grating Stimulus
driftFrequencies = [-5 5];
Orientation = [0:pi/12:pi];
Phase = [0];
Contrast = logspace(0,-1,3);
Duration = [1];
Radii = [1];
Annuli = [0];
Location = [0.5 0.5];
Waveform = 'sine';
normalizationMethod = 'normalizeDiagonal';
mean = [0.5];
thresh = [0.85];
numRepeats = [1];
doCombos = {true,'twister','clock'};
gratingStim = gratings(pixPerCycs,driftFrequencies,Orientation,Phase,Contrast,Duration,Radii,Annuli,Location,Waveform,...
    normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance, doCombos);

%% phase reverse gratings
% gratings
pixPerCycs=2.^([5:11]); % freq
pixPerCycs=2.^([7:0.5:11]); % freq
%pixPerCycs=2.^([9]);   % freq
%driftfrequencies=[4];  % in cycles per second
driftfrequencies=[0.5];  % in cycles per second
orientations=[pi/2];   % in radians, horiz
orientations=[0];       % in radians, vert
phases=[0];            % initial phase
contrasts=[0.5];       % contrast of the grating
durations=[3];         % duration of each grating
radius=5;              % radius of the circular mask, 5= five times screen hieght
annuli=0;              % radius of inner annuli
location=[.5 .5];      % center of mask
%waveform='square';     
waveform='sine';     
normalizationMethod='normalizeDiagonal';
mean=0.5;
numRepeats=2;
scaleFactor=0;
doCombos={true,'twister','clock'};
changeableAnnulusCenter=false;
phaseform = 'sine';



numOrientations=8;
orientations=([2*pi]*[1:numOrientations])/numOrientations; % in radians
pixPerCycs=128; %2^9;%temp [64];  % reset to one value
%orPhaseRevGratings = phaseReverseGratings(pixPerCycs,driftfrequencies,orientations,phases,waveform,contrasts,durations,radius,annuli,location,...
%    phaseform,normalizationMethod,mean,thresh,numRepeats,maxWidth,maxHeight,scaleFactor,interTrialLuminance,changeableAnnulusCenter,doCombos);

%% whiteNoise
gray=0.5;
mean=gray;
std=gray*(2/3); 
searchSubspace=[1];
background=gray;
method='texOnPartOfScreen';
stixelSize = [32 32]% [128 128];% [128 128]; %[32,32];
changeable=false;

%fullField 
stimLocation=[0,0,maxWidth,maxHeight];
numFrames=3000;   %100 to test; 5*60*100=30000 for experiment
stixelSize = [maxWidth maxHeight ];
ffgwn = whiteNoise({'gaussian',gray,std,'twister',300},background,method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

frequencies = 2;contrasts = 0.5; durations = 3;radii = {[0.1,0.2,0.5],'hardEdge'};annuli = 0; location = [0.5 0.5]; 
normalizationMethod = 'normalizeDiagonal';mean = 0.5;thresh = 0.0005; numRepeats = 3;
maxWidth=800;maxHeight=600;scaleFactor=0;interTrialLuminance=.5;
doCombos = true;
trf = fullField(frequencies,contrasts,durations,radii,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,false,true);
%% Svn check
svnRev={'svn://132.239.158.177/projects/ratrix/trunk'};
svnCheckMode='session';

%% Define trainingStep
% ts1 = trainingStep(vh, noiseStim,  repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %filteredNoise discrim
% ts2 = trainingStep(vh, unfilteredNoise,  repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %unfiltered goToSide
% ts3 = trainingStep(vh, hateren,  repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %filteredNoise discrim
% ts4 = trainingStep(vh, fullfieldFlicker,  repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %unfiltered goToSide
% ts5 = trainingStep(led, hateren,  repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %hateren
% ts6 = trainingStep(led, fullfieldFlicker,  repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %fullfieldFlicker
% ts7 = trainingStep(led, crftrf,  repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %crf/trf
% ts8 = trainingStep(og, gratingStim, repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %grating stim
% ts9 = trainingStep(vh, crftrf,  repeatIndefinitely(), noTimeOff(), svnRev,svnCheckMode); %crf/trf
% ts1 = trainingStep(ap,orGratings,repeatIndefinitely(),noTimeOff(),svnRev,svnCheckMode,'orGratings');
ts1 = trainingStep(ap,trf,repeatIndefinitely(),noTimeOff(),svnRev,svnCheckMode,'ffgwn');
ts2 = trainingStep(apProbReward,apGratings,repeatIndefinitely(),noTimeOff(),svnRev,svnCheckMode,'gratings');
%% Create protocol
p=protocol('gabor test',{ts1,ts2});
stepNum=uint8(2); % Which stepNum to start at
for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'call to setProtocolBSStAl','bs');
end
