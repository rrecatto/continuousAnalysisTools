function [ts_SurrCtrSweep ts_SurrLowCtr ts_SurrMedCtr ts_SurrHighCtr ts_SurrFullCtr] = createOrientationWithOrientedSurroundSteps(svnRev,svnCheckMode,subj)

out = getStepDetails(subj);
afcwos_SurrCtrSweep = afcGratingsWithOrientedSurround(out.pixPerCycs,out.driftfrequencies,out.orientations,out.phases,out.contrastsSweep,out.maxDuration,out.radii,out.radiusType,out.location,...
      out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance,out.doCombos);
  
afcwos_SurrLowCtr = afcGratingsWithOrientedSurround(out.pixPerCycs,out.driftfrequencies,out.orientations,out.phases,out.contrastsLow,out.maxDuration,out.radii,out.radiusType,out.location,...
      out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance,out.doCombos);
  
afcwos_SurrMedCtr = afcGratingsWithOrientedSurround(out.pixPerCycs,out.driftfrequencies,out.orientations,out.phases,out.contrastsMedium,out.maxDuration,out.radii,out.radiusType,out.location,...
      out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance,out.doCombos);
  
afcwos_SurrHighCtr = afcGratingsWithOrientedSurround(out.pixPerCycs,out.driftfrequencies,out.orientations,out.phases,out.contrastsHigh,out.maxDuration,out.radii,out.radiusType,out.location,...
      out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance,out.doCombos);
  
afcwos_SurrFullCtr = afcGratingsWithOrientedSurround(out.pixPerCycs,out.driftfrequencies,out.orientations,out.phases,out.contrastsFull,out.maxDuration,out.radii,out.radiusType,out.location,...
      out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance,out.doCombos);
  

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

% reinf
rewardScalar = out.rewardScalar;
requestRewardSize = 0; 
rewardSize = out.rewardSize;
doAllRequests =	'first'; 
fractionSoundOn = 1; % this applies to beeps
fractionPenaltySoundOn = 0.10;  % fraction of the timeout that annoying error sound is on
msAirpuff = 0;
msPenalty = out.msPenalty;

percentCorrectionTrials = out.percentCorrectionTrials;

constantRewards=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);

tm= nAFC(sm, percentCorrectionTrials, constantRewards);
    
% training step using other objects as passed in
ts_SurrCtrSweep = trainingStep(tm, afcwos_SurrCtrSweep, impossPC, sch, svnRev, svnCheckMode,'SurrCtrSweep');
ts_SurrLowCtr = trainingStep(tm, afcwos_SurrLowCtr, impossPC, sch, svnRev, svnCheckMode,'SurrLowCtr');
ts_SurrMedCtr = trainingStep(tm, afcwos_SurrMedCtr, impossPC, sch, svnRev, svnCheckMode,'SurrMedCtr');
ts_SurrHighCtr = trainingStep(tm, afcwos_SurrHighCtr, impossPC, sch, svnRev, svnCheckMode,'SurrHighCtr');
ts_SurrFullCtr = trainingStep(tm, afcwos_SurrFullCtr, impossPC, sch, svnRev, svnCheckMode,'SurrFullCtr');
end

function out = getStepDetails(id)

out.pixPerCycs={{128,128},{256,256}};
out.driftfrequencies={{2,2},{0,0}};
out.orientations={{-deg2rad([45 225]),deg2rad([45 225])},{[0 pi/2],[0 pi/2]}};
orsSweep = [0,5,15,25,35,45,45,45,45,45,180,185,195,205,215,225,225,225,225,225];
out.orientationsSweep={{-deg2rad(orsSweep),deg2rad(orsSweep)},{[0 pi/2],[0 pi/2]}};
out.phases={{0,0},{0:pi/8:pi,0:pi/8:pi}};
out.contrastsSweep={{1,1},{[0.0625 0.125 0.25 0.5 0.75 0.9 0.99],[0.0625 0.125 0.25 0.5 0.75 0.9 0.99]}};

out.contrastsLow={{1,1},{0.125,0.125}};
out.contrastsMedium={{1,1},{0.33,0.33}};
out.contrastsHigh={{1,1},{0.6,0.6}};
out.contrastsFull={{1,1},{1,1}};



out.maxDuration={[inf],[inf]};
out.radii={{0.125,0.125},{inf,inf}};
out.radiusType = 'hardEdge';
out.location={[.5 .5],[0.5 0.5]};      % center of mask
out.waveform= 'sine';     
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
out.rewardScalar = 0.20;
out.rewardSize = 50;
out.msPenalty = 5000;
out.doPostDiscrim = false;

out.percentCorrectionTrials = 0.5;

% make changes for specific mice here
switch id
    case '10'
    case '111'
    case '1111'
    case '118'
    case '13'
    case '134'    
    case '139' 
    case '17'
    case '18'
    case '19'
    case '20'
    case '22'
    case '23'
    case '24'
    case '25'
    case '26'
    case '27'
    case '30'
    case '31'
    case '32'
    case '34'
    case '35'
    case '36'
    case '37'
    case '38'
    case '39'    
    case '40'
    case '41'
    case '42'
    case '43'
    case '44'
    case '45'
    case '46'
    case '47'
    case '48'
    case '49'
    case '50'
    case '51'
    case '52'
    case '53'
    case '54'
    case '55'
    case '56'
    case '57'
    case '58'
    case '59'
    case '60'
    case '61'
    case '62'
    case '63'
    case {'demo1','999'}
    otherwise
        error('unsupported mouse id. are you sure that the mouse is supposed to be here?')
end
end
