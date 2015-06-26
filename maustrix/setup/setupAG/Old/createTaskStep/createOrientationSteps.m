function [ts_optim, ts_sfSweep, ts_tfSweep, ts_ctrSweep, ts_orSweep] = createOrientationSteps(svnRev,svnCheckMode,subj)

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
requestRewardSize = 10; 
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
ts_optim = trainingStep(tm, afc_optim, crit, sch, svnRev, svnCheckMode,'orOptimal');
ts_sfSweep = trainingStep(tm, afc_sfSweep, crit, sch, svnRev, svnCheckMode,'orSFSweep');
ts_tfSweep = trainingStep(tm, afc_tfSweep, crit, sch, svnRev, svnCheckMode,'orTFSweep');
ts_ctrSweep = trainingStep(tm, afc_ctrSweep, crit, sch, svnRev, svnCheckMode,'orCTRSweep');
ts_orSweep = trainingStep(tm, afc_orSweep, crit, sch, svnRev, svnCheckMode,'orORSweep');
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
out.radiiOpt={inf,inf};
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
        out.msPenalty = 5000; % changed to 25000 05292013,
        out.rewardScalar = 0.1; %changed on 6/17
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
        out.msPenalty = 5000; % changed to 25000 05292013,
        out.rewardScalar = 0.1; % changed on 6/17
    case '69'
        % nothing changes here, but might later
    case '70'
        out.msPenalty = 25000; % changed to 25000 05292013,
        out.rewardScalar = 0.1; %changed on 6/17
    case '79'
        out.rewardScalar = 0.05; 
        %changed to 0.1 on 6/26
        % canged to lower on 7/2
        % changed back to 0.1 on 7/8
        % lowered reward on 8/22. look back in 1 week
    case '84'
        out.rewardScalar = 0.15; % reduced from 0.2 to 0.15 on 6/5
    case '86'
        out.rewardScalar = 0.10; 
        out.msPenalty  = 10000;
        % changed to 10000 05292013, 
        % penalty set to 500 and scalar reduced to 0.15 6/5
        % reduced scalar to 0.1 and increased penalty to 10000 6/12
    case '87'
        out.msPenalty = 10000; % changed to 10000 05292013,
    case '90'
        out.rewardScalar = 0.10;  
        % changed to 10000 05292013,
        % set timeout back to original and set rewardscalar to 0.15 6/5
        % reduced reward to 0.1 on 8/5
    case '91'
        out.rewardScalar = 0.10;  
        % changed to 15000 05292013,
        % set timeout back to original and set rewardscalar to 0.15 6/5
        % reduced scalar to 0.1 6/17
    case '92'
        out.msPenalty = 10000; % changed to 10000 05292013,
        out.rewardScalar = 0.10; % changed for 6/6, changed from 0.15 on 6/12
    case '93'
        out.msPenalty = 15000; 
        % changed to 15000 05292013,
        out.rewardScalar = 0.10; % changed for 6/6, changed from 0.15 on 6/12
    case '95'
        out.rewardScalar = 0.05; % changed to 0.1 on 7/2
        % reduced to 0.05 10/2
        out.msPenalty = 20000; % changed on 8/22
        % increased timeout to 15s 10/2
        % increased timeout to 20 s 10/24
    case '96'
        out.rewardScalar = 0.05; % changed to 0.1 on 8/15, 0,05 on 8/22
        out.msPenalty = 20000; % changed on 8/15
        % increased timeout to 20s 10/2
    case '97'
        out.rewardScalar = 0.05; 
        % changed to 0.1 8/22
        % changed to 0.05 9/20
        out.msPenalty = 10000; % changed on 10/24
    case '98'
        out.rewardScalar = 0.05; 
        % changed to 0.1 9/20
        % changed to 0.05 10/2
        out.msPenalty = 10000; % changed on 10/24
    case '99'
        out.rewardScalar = 0.1; % reduced 10/2
        out.msPenalty = 20000; % changed on 8/22
        % increased to 20 s on 10/2
    case '200'
        out.rewardScalar = 0.10; % changed on 9/20
    case '201'
        % nothing changes here, but might later
    case '202'
        out.rewardScalar = 0.10; % changed 8/22
    case '203'
        out.rewardScalar = 0.05; % changed on 8/15
        out.msPenalty = 20000; % changed 8/22
    case '204'
        out.rewardScalar = 0.05; 
        % changed to 0.1 8/5
        % changed to 0.05 on 9/20
        out.msPenalty = 20000; % changed 8/22
        % increased penalty to 15 s 10/2
        % increased penalty to 20 s 10/24
    case '205'
        out.rewardScalar = 0.05;
        out.msPenalty = 20000; % increased 10/2
        % changed 8/22 to 0.1
        % changed to 0.05 on 9/20
        % increased penalty to 15 seconds
        % increased penalty to 20 s 12/3
    case '206'
        out.rewardScalar = 0.05; % changed on 9/20
        % reduced to 0.05 10/2
        out.msPenalty = 10000; % increased 10/24
    case '207'
        out.rewardScalar = 0.05; 
        % changed to 0.1 on 8/5
        % changed to 0.05 on 9/20
        out.msPenalty = 20000; % changed on 8/22
        % increased penalty tp 20 s 10/2
    case '208'
        out.rewardScalar = 0.05; 
        % changed to 0.1 on 9/20
        % reduced reward to 0.05 on 10/2
        out.msPenalty = 10000; % changed on 10/24
    case '209'
        out.rewardScalar = 0.10; % changed 8/22
        out.msPenalty = 10000; % changed on 9/20
        out.msPenalty = 20000; % changed on 10/2
    case '210'
        out.rewardScalar = 0.10; % changed 8/22
        out.msPenalty = 10000; % changed 10/2
    case '211'
        out.msPenalty = 10000; % changed 8/22
    case '212'
        out.rewardScalar = 0.10; % changed 8/22
        out.msPenalty = 10000; % changed 9/20
    case '213'
        out.rewardScalar = 0.1; 
        % changed to 0.1 on 9/20
        out.msPenalty = 15000; % cahnged 10/2
        % changed 10/24
    case '214'
        out.rewardScalar = 0.05; 
        % changed to 0.1 on 9/20
        % reduced reward scalar 10/24
        out.msPenalty = 25000; % cahnged 11/24
    case '215'
        out.rewardScalar = 0.05;
        out.msPenalty = 10000; % changed 10/2
        % changed to 0.1 on 8/22
        % changed to 0.05 on 9/20
    case '216'
        out.rewardScalar = 0.10; % changed 8/22
        out.msPenalty = 10000; 
        % increased penalty 8/15
    case '217'
        % nothing changes here, but might later
    case '218'
        out.msPenalty = 20000;
    case '219'
        % nothing changes here, but might later
    case '220'
        % nothing changes here, but might later
    case '221'
        out.msPenalty = 10000;
    case '222'
        out.msPenalty = 20000;
        % increased penalty 4/29
    case '223'
        out.msPenalty = 25000;
    case '224'
        % nothing changes here, but might later
    case '225'
        out.rewardScalar = 0.10;
        % nothing changes here, but might later
    case '226'
        out.rewardScalar = 0.10;
        out.msPenalty = 15000; %increased penalty 2/14
    case '227'
        out.rewardScalar = 0.05;
        % nothing changes here, but might later
    case '228'
        out.rewardScalar = 0.10;
        % nothing changes here, but might later
    case '229'
        out.rewardScalar = 0.10;
        % nothing changes here, but might later
    case '230'
        out.rewardScalar = 0.05;
        % reduced reward - make the animal perform better and faster 
        out.msPenalty = 20000; % increased penalty to improve performance
    case '231'
        out.rewardScalar = 0.05;
        out.msPenalty = 10000; %increased penalty 3/11, 4/28
    case '232'
        out.rewardScalar = 0.05;
        out.msPenalty = 10000; %increased penalty 4/28
    case '233'
        out.rewardScalar = 0.10;
        % nothing changes here, but might later
    case '234'
        out.rewardScalar = 0.10;
        % nothing changes here, but might later
    case '235'
        out.rewardScalar = 0.10;
        % nothing changes here, but might later
    case '236'
        out.rewardScalar = 0.10;
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
