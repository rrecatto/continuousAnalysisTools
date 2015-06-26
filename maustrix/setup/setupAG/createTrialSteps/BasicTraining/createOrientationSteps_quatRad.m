function [ts_optim ts_sfSweep ts_tfSweep ts_ctrSweep ts_orSweep] = createOrientationSteps_quatRad(svnRev,svnCheckMode,subj)

out = getStepDetails(subj);
afc_optim = afcGratings(out.pixPerCycsOpt,out.driftfrequenciesOpt,out.orientationsOpt,out.phasesOpt,out.contrastsOpt,out.maxDurationOpt,...
    out.radiiOpt,out.radiusType,out.annuli,out.location,out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,...
    out.scaleFactor,out.interTrialLuminance,out.doCombos,out.doPostDiscrim);

afc_sfSweep = afcGratings(out.pixPerCycsSweep,out.driftfrequenciesOpt,out.orientationsOpt,out.phasesOpt,out.contrastsOpt,out.maxDurationOpt,...
    out.radiiOpt,out.radiusType,out.annuli,out.location,out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,...
    out.scaleFactor,out.interTrialLuminance,out.doCombos,out.doPostDiscrim);

afc_tfSweep = afcGratings(out.pixPerCycsOpt,out.driftfrequenciesSweep,out.orientationsOpt,out.phasesOpt,out.contrastsOpt,out.maxDurationOpt,...
    out.radiiOpt,out.radiusType,out.annuli,out.location,out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,...
    out.scaleFactor,out.interTrialLuminance,out.doCombos,out.doPostDiscrim);

afc_ctrSweep = afcGratings(out.pixPerCycsOpt,out.driftfrequenciesOpt,out.orientationsOpt,out.phasesOpt,out.contrastsSweep,out.maxDurationOpt,...
    out.radiiOpt,out.radiusType,out.annuli,out.location,out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,...
    out.scaleFactor,out.interTrialLuminance,out.doCombos,out.doPostDiscrim);

afc_orSweep = afcGratings(out.pixPerCycsOpt,out.driftfrequenciesOpt,out.orientationsSweep,out.phasesOpt,out.contrastsOpt,out.maxDurationOpt,...
    out.radiiOpt,out.radiusType,out.annuli,out.location,out.waveform,out.normalizationMethod,out.mean,out.thresh,out.maxWidth,out.maxHeight,...
    out.scaleFactor,out.interTrialLuminance,out.doCombos,out.doPostDiscrim);


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

percentCorrectionTrials = 0.5;

constantRewards=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);

tm= nAFC(sm, percentCorrectionTrials, constantRewards);

% training step using other objects as passed in
ts_optim = trainingStep(tm, afc_optim, impossPC, sch, svnRev, svnCheckMode,'orOptimal_quatRad');
ts_sfSweep = trainingStep(tm, afc_sfSweep, impossPC, sch, svnRev, svnCheckMode,'orSFSweep_quatRad');
ts_tfSweep = trainingStep(tm, afc_tfSweep, impossPC, sch, svnRev, svnCheckMode,'orTFSweep_quatRad');
ts_ctrSweep = trainingStep(tm, afc_ctrSweep, impossPC, sch, svnRev, svnCheckMode,'orCTRSweep_quatRad');
ts_orSweep = trainingStep(tm, afc_orSweep, impossPC, sch, svnRev, svnCheckMode,'orORSweep_quatRad');
end

function out = getStepDetails(id)

% basic details for stim
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
out.radiiOpt={[0.25],[0.25]};
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
switch id
    case {'1','2','4','5','7','8','9','10','11','12','13','14','15','17','18','19','20'}
        % nothing changes here, but might later
    case {'3'}
        % nothing changes here, but might later
    case {'6'}
        % nothing changes here, but might later
    case {'16'}
        out.rewardScalar = 0.5; %07232012
        % nothing changes here, but might later
    case {'21'}
        % nothing changes here, but might later
    case {'22'}
        % nothing changes here, but might later
    case {'23'}
        % nothing changes here, but might later
    case {'24'}
        % nothing changes here, but might later
    case {'25'}
        % nothing changes here, but might later
    case {'ACM1'}
        % nothing changes here, but might later
    case {'ACM2'}
        % nothing changes here, but might later
    case {'ACM3'}
        % nothing changes here, but might later
    case {'ACM4'}
        % nothing changes here, but might later
    case {'ACM5'}
        % nothing changes here, but might later
    case {'demo1','999'}
        out.maxDurationOpt = {[3],[3]};
        out.doPostDiscrim = true;
        % nothing changes here, but might later
    case {'31'}
        % nothing changes here, but might later
    case {'32'}
        % nothing changes here, but might later
    case {'33'}
        % nothing changes here, but might later
    case {'34'}
        % nothing changes here, but might later
    otherwise
        error('unsupported mouse id. are you sure that the mouse is supposed to be here?')
end
end
