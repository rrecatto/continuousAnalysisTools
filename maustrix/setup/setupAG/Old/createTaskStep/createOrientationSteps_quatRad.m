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
ts_optim = trainingStep(tm, afc_optim, crit, sch, svnRev, svnCheckMode,'orOptimal_quatRad');
ts_sfSweep = trainingStep(tm, afc_sfSweep, crit, sch, svnRev, svnCheckMode,'orSFSweep_quatRad');
ts_tfSweep = trainingStep(tm, afc_tfSweep, crit, sch, svnRev, svnCheckMode,'orTFSweep_quatRad');
ts_ctrSweep = trainingStep(tm, afc_ctrSweep, crit, sch, svnRev, svnCheckMode,'orCTRSweep_quatRad');
ts_orSweep = trainingStep(tm, afc_orSweep, crit, sch, svnRev, svnCheckMode,'orORSweep_quatRad');
end

function out = getStepDetails(id)

% basic details for stim
out.pixPerCycsOpt={[128],[128]};
out.pixPerCycsSweep={[16,32,64,128,256,512],[16,32,64,128,256,512]};

out.driftfrequenciesOpt={[2],[2]};
out.driftfrequenciesSweep={[0,2,16],[0,2,16]};

orsOpt = [45 225];
orsSweep = [0,3.33,6.67,10,13.33,16.67,20,45,180,183.33,186.67,190,193.33,196.66,200,225];
out.orientationsOpt={-deg2rad(orsOpt),deg2rad(orsOpt)};
out.orientationsSweep={-deg2rad(orsSweep),deg2rad(orsSweep)};

out.phasesOpt={0,0};

out.contrastsOpt={1,1};
out.contrastsSweep={[0 0.05 0.1 0.15 0.2 0.3 0.4 1],[0 0.05 0.1 0.15 0.2 0.3 0.4 1]};

out.maxDurationOpt={inf,inf};
out.radiiOpt={0.25,0.25};
out.annuli={0,0};
out.location={[.5 .5],[0.5 0.5]};      % center of mask
out.waveform= 'sine';
out.radiusType='hardEdge';
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
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case '7845C42558DF' %gLab-Behavior5
        out.maxWidth = 1920;
        out.maxHeight = 1080;
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
out.rewardScalar = 0.2;
out.rewardSize = 50;
out.msPenalty = 5000;
out.doPostDiscrim = false;
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
        out.rewardScalar = 0.05; % changed 9/20
        % reduced on 10/24
        out.msPenalty = 10000; % increased 10/24
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
        out.rewardScalar = 0.05; % changed 9/20
        % decreased penalty 10/2
    case '87'
        out.msPenalty = 20000;
        % increased penalty to 20 s 10/2
        % nothing changes here, but might later
        out.rewardScalar = 0.1; % changed 10/24
    case '90'
        % nothing changes here, but might later
    case '91'
        out.rewardScalar = 0.05; % changed 9/20
        % reduced to 0.05 10/2
    case '92'
        out.rewardScalar = 0.1; % changed 9/20
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
        out.rewardScalar = 0.05; % changed 10/2
        % changed reward on 10/24
        out.msPenalty = 15000; % changed 10/2
        % changed penalty to 15 s on 10/24
    case '201'
        out.rewardScalar = 0.1; % changed 10/2
        out.msPenalty = 10000; % changed 9/20
    case '202'
        out.msPenalty = 10000; % changed 9/20
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
        out.rewardScalar = 0.05; 
        % changed to 0.1 10/24
        % changed to 0.05 11/24
        out.msPenalty = 10000; % changed 10/24
    case '210'
        out.msPenalty = 10000; % changed 9/20
        % increased to 20 s 10/20
        % increased to 10 s 11/24
        out.rewardScalar = 0.05; 
        % changed 10/24 - halved reward to increase trials run
        % changed to 0.05 11/24
    case '211'
        % nothing changes here, but might later
    case '212'
        out.msPenalty = 10000; % changed 10/24
        out.rewardScalar = 0.1; % changed 10/24
    case '213'
        % nothing changes here, but might later
    case '214'
        % nothing changes here, but might later
    case '215'
        out.rewardScalar = 0.1; % changed 10/24
        out.msPenalty = 10000; % changed 10/24
    case '216'
        out.msPenalty = 10000;
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
