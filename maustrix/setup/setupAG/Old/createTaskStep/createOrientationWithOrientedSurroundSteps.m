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
ts_SurrCtrSweep = trainingStep(tm, afcwos_SurrCtrSweep, crit, sch, svnRev, svnCheckMode,'SurrCtrSweep');
ts_SurrLowCtr = trainingStep(tm, afcwos_SurrLowCtr, crit, sch, svnRev, svnCheckMode,'SurrLowCtr');
ts_SurrMedCtr = trainingStep(tm, afcwos_SurrMedCtr, crit, sch, svnRev, svnCheckMode,'SurrMedCtr');
ts_SurrHighCtr = trainingStep(tm, afcwos_SurrHighCtr, crit, sch, svnRev, svnCheckMode,'SurrHighCtr');
ts_SurrFullCtr = trainingStep(tm, afcwos_SurrFullCtr, crit, sch, svnRev, svnCheckMode,'SurrFullCtr');
end

function out = getStepDetails(id)

out.pixPerCycs={{128,128},{256,256}};
out.driftfrequencies={{2,2},{0,0}};
out.orientations={{-deg2rad([45 225]),deg2rad([45 225])},{[0 pi/2],[0 pi/2]}};
orsSweep = [0,3.33,6.67,10,13.33,16.67,20,45,180,183.33,186.67,190,193.33,196.66,200,225];
out.orientationsSweep={{-deg2rad(orsSweep),deg2rad(orsSweep)},{[0 pi/2],[0 pi/2]}};
out.phases={{0,0},{0:pi/8:pi,0:pi/8:pi}};
out.contrastsSweep={{1,1},{[0.0625 0.125 0.25 0.5 0.75 0.9 0.99],[0.0625 0.125 0.25 0.5 0.75 0.9 0.99]}};

out.contrastsLow={{1,1},{0.125,0.125}};
out.contrastsMedium={{1,1},{0.33,0.33}};
out.contrastsHigh={{1,1},{0.6,0.6}};
out.contrastsFull={{1,1},{1,1}};



out.maxDuration={inf,inf};
out.radii={{0.125,0.125},{inf,inf}};
out.radiusType = 'hardEdge';
out.location={[0.5 0.5],[0.5 0.5]};      % center of mask
out.waveform= 'sine';     
out.normalizationMethod='normalizeDiagonal';
out.mean=0.5;
out.thresh=.00005;



[a, b] = getMACaddress();
switch b
    case 'A41F7278B4DE' %gLab-Behavior1
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case 'A41F729213E2' %gLab-Behavior2
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case 'A41F726EC11C' %gLab-Behavior3
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case '7845C4256F4C' %gLab-Behavior4
        out.maxWidth = 1280;
        out.maxHeight = 720;
    case '7845C42558DF' %gLab-Behavior5
        out.maxWidth = 1280;
        out.maxHeight = 720;
    case 'A41F729211B1' %gLab-Behavior6
        out.maxWidth = 1600;
        out.maxHeight = 900;
    case 'BC305BD38BFB' %ephys-stim
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case '180373337162' %ephys-data
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    otherwise
        a
        b
        warning('not sure which computer you are using. add that mac to this step. delete db and then continue. also deal with the other createStep functions.');
        keyboard;
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
    case '26'
        % nothing changes here, but might later
    case '37'
        % nothing changes here, but might later
    case '38'
        % nothing changes here, but might later
    case '40'
        % nothing changes here, but might later
    case '41'
        % nothing changes here, but might later
    case '45'
        % nothing changes here, but might later
    case '47'
        % nothing changes here, but might later
    case '48'
        % nothing changes here, but might later
    case '50'
        % nothing changes here, but might later
    case '53'
        % nothing changes here, but might later
    case '56'
        % nothing changes here, but might later
    case '59'
        % nothing changes here, but might later
    case '60'
        % nothing changes here, but might later
    case '61'
        % nothing changes here, but might later
    case '62'
        % nothing changes here, but might later
    case '63'
        % nothing changes here, but might later
    case '64'
        % nothing changes here, but might later
    case '65'
        % nothing changes here, but might later
    case '66'
        % nothing changes here, but might later
    case '67'
        % nothing changes here, but might later
    case '68'
        % nothing changes here, but might later
    case '69'
        % nothing changes here, but might later
    case '70'
        % nothing changes here, but might later
    case '79'
        % nothing changes here, but might later
    case '84'
        % nothing changes here, but might later
    case '86'
        % nothing changes here, but might later
    case '87'
        % nothing changes here, but might later
    case '90'
        % nothing changes here, but might later
    case '91'
        % nothing changes here, but might later
    case '92'
        % nothing changes here, but might later
    case '93'
        % nothing changes here, but might later
    case '95'
        % nothing changes here, but might later
    case '96'
        % nothing changes here, but might later
    case '97'
        % nothing changes here, but might later
    case '98'
        % nothing changes here, but might later
    case '99'
        % nothing changes here, but might later
    case '200'
        % nothing changes here, but might later
    case '201'
        % nothing changes here, but might later
    case '202'
        % nothing changes here, but might later
    case '203'
        % nothing changes here, but might later
    case '204'
        % nothing changes here, but might later
    case '205'
        % nothing changes here, but might later
    case '206'
        % nothing changes here, but might later
    case '207'
        % nothing changes here, but might later
    case '208'
        % nothing changes here, but might later
    case '209'
        % nothing changes here, but might later
    case '210'
        % nothing changes here, but might later
    case '211'
        % nothing changes here, but might later
    case '212'
        % nothing changes here, but might later
    case '213'
        % nothing changes here, but might later
    case '214'
        % nothing changes here, but might later
    case '215'
        % nothing changes here, but might later
    case '216'
        % nothing changes here, but might later
    case '217'
        % nothing changes here, but might later
    case '218'
        % nothing changes here, but might later
    case '219'
        % nothing changes here, but might later
    case '220'
        % nothing changes here, but might later
    case '221'
        % nothing changes here, but might later
    case '222'
        % nothing changes here, but might later
    case '223'
        % nothing changes here, but might later
    case '224'
        % nothing changes here, but might later
    case '225'
        % nothing changes here, but might later
    case '226'
        % nothing changes here, but might later
    case '227'
        % nothing changes here, but might later
    case '228'
        % nothing changes here, but might later
    case '229'
        % nothing changes here, but might later
    case '230'
        % nothing changes here, but might later
    case '231'
        % nothing changes here, but might later
    case '232'
        % nothing changes here, but might later
    case '233'
        % nothing changes here, but might later
    case '234'
        % nothing changes here, but might later
    case '235'
        % nothing changes here, but might later
    case '236'
        % nothing changes here, but might later
    case '999'
        % nothing changes here, but might later
    case 'demo1'
        out.maxDurationOpt = {[3],[3]};
        out.doPostDiscrim = true;
    otherwise
        error('unsupported mouse id. are you sure that the mouse is supposed to be here?')
end
end
