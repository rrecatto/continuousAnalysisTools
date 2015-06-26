function ts = createEasyAFCGratingWithOrientedSurround(svnRev, svnCheckMode,subjIDs)
% makes a basic, easy drifting grating training step
% correct response = side toward which grating drifts?

% gratings stim manager
pixPerCycs={{128,128},{256,256}};
driftfrequencies={{2,2},{0,0}};
orientations={{-deg2rad([45 225]),deg2rad([45 225])},{0,0}};
phases={{0,0},{0,0}};
contrasts={{1,1},{0.1,0.1}};
maxDuration={[inf],[inf]};
radii={{0.125,0.125},{0.2,0.2}};
radiusType = 'hardEdge';
annuli={[0],[0]};
location={[.5 .5],[0.5 0.5]};      % center of mask
waveform= 'sine';     
normalizationMethod='normalizeDiagonal';
mean=0.5;
thresh=.00005;
maxWidth=1440;
maxHeight=900;
scaleFactor=0;
interTrialLuminance=.5;
doCombos = true;

AFCGRAT = afcGratingsWithOrientedSurround(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

  
  % sound Manager
sm=soundManager({soundClip('correctSound','allOctaves',[400],20000), ...
    soundClip('keepGoingSound','empty'), ...
    soundClip('trySomethingElseSound','gaussianWhiteNoise'), ...
    soundClip('wrongSound','empty'),...
    soundClip('trialStartSound','empty')});

% scheduler
sch=noTimeOff(); % runs until swapper ends session

% criterion
crit = repeatIndefinitely();
impossPC=performanceCriterion([0.99],int16([200]));


%%
out.pixPerCycsOpt={[128],[128]};
out.pixPerCycsSweep={[32,64,128,256,512],[32,64,128,256,512]};

out.driftfrequenciesOpt={[2],[2]};
out.driftfrequenciesSweep={[0.25,0.5,1,2,4,8,16],[0.25,0.5,1,2,4,8,16]};

orsOpt = [45 225];
orsSweep = [0,5,15,25,35,45,45,45,45,45,180,185,195,205,215,225,225,225,225,225];
out.orientationsOpt={-deg2rad(orsOpt),deg2rad(orsOpt)};
out.orientationsSweep={-deg2rad(orsSweep),deg2rad(orsSweep)};

out.phasesOpt={[0],[0]};

out.contrastsOpt={[1],[1]};
out.contrastsSweep={[0.1:0.1:1],[0.1:0.1:1]};

out.maxDurationOpt={[inf],[inf]};
out.radiiOpt={[3],[3]};
out.annuli={[0],[0]};
out.location={[.5 .5],[0.5 0.5]};      % center of mask
out.waveform= 'sine';
out.radiusType='hardEdge';
out.normalizationMethod='normalizeDiagonal';
out.mean=0.5;
out.thresh=.00005;

[a b] = getMACaddress;
if strcmp(b,'BC305BD38BFB') % balaji's personal computer
    out.maxWidth = 1920;
    out.maxHeight = 1080;
else
    out.maxWidth=1024;
    out.maxHeight=768;
end

out.scaleFactor=0;
out.interTrialLuminance=.5;
out.doCombos = true;

% details for reinforcement
out.rewardScalar = 0.2;
out.rewardSize = 50;
out.msPenalty = 5000;
out.doPostDiscrim = false;
%%
% reinf
rewardScalar = out.rewardScalar;
requestRewardSize = 0; 
rewardSize = out.rewardSize;
doAllRequests =	'first'; 
fractionSoundOn = 1; % this applies to beeps
fractionPenaltySoundOn = 0.10;  % fraction of the timeout that annoying error sound is on
msAirpuff = 0;
msPenalty = out.msPenalty;

percentCorrectionTrials = 0.5;

constantRewards=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);

tm= nAFC(sm, percentCorrectionTrials, constantRewards);

% training step using other objects as passed in
ts = trainingStep(tm, AFCGRAT, impossPC, sch, svnRev, svnCheckMode);