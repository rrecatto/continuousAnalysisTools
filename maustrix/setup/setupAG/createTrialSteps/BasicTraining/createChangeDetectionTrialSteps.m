function [ts_Easy_constDur,ts_Gen_constDur,ts_Easy_varDur,ts_Hard_varDur,ts_Vary_varDur] = createChangeDetectionTrialSteps(svnRev, svnCheckMode, subID)

% create the trial manager first
sm=soundManager({soundClip('correctSound','allOctaves',[400],20000), ...
    soundClip('keepGoingSound','empty'), ...
    soundClip('trySomethingElseSound','gaussianWhiteNoise'), ...
    soundClip('wrongSound','tritones',[300 400],20000),...
    soundClip('trialStartSound','empty')...
    });
out.percentCatchTrial = 0.2;

% scheduer 
sch=noTimeOff(); % runs until swapper ends session

% take reinforcement manager from setProtocolTest but with params from Pam
out.requestRewardSize   =	0; 
out.rewardSize          =   50; % try this, may need to increase water rwd
out.doAllRequests       =	'first'; % always do this
out.fractionSoundOn     =	1; % this applies to beeps
out.fractionPenaltySoundOn = 0.10;  % fraction of the timeout that annoying error sound is on
out.msAirpuff           =   0;
out.msPenalty = 5000;
out.rewardScalar = 1;
constantRewards=constantReinforcement(out.rewardSize,out.requestRewardSize,out.doAllRequests,...
    out.msPenalty,out.fractionSoundOn,out.fractionPenaltySoundOn,out.rewardScalar,out.msAirpuff);  %% rewardScalar, msPenalty are arguments to the function

%create a trial manager - 
tm= changeDetectorTM(sm, out.percentCatchTrial, constantRewards); %percentCatchTrial is an argument to the function


% base gratings stimulus
% gratings stim manager
pixPerCycs={[32],[32]};
driftfrequencies={[0],[0]};
orientations={-deg2rad([45]),deg2rad([45])};
phases={linspace(0,2*pi,16),linspace(0,2*pi,16)};
phases = {0 ,0};
contrasts={[1],[1]};
maxDuration={[inf],[inf]};
radii={[Inf],[Inf]};
radiusType = 'hardEdge';
annuli={[0],[0]};
location={[.5 .5],[0.5 0.5]};      % center of mask
waveform= 'sine';     
normalizationMethod='normalizeDiagonal';
mean=0.5;
thresh=.00005;
maxWidth=1920;
maxHeight=1080;
scaleFactor=0;
interTrialLuminance=.5;
doCombos = true;
doPostDiscrim = false;

contrasts={[0],[0]};
AFCGRAT_0C = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
    waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);
contrasts={[0.25],[0.25]};
AFCGRAT_25C = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);
contrasts={[0.75],[0.75]};  
AFCGRAT_75C = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);
contrasts={[1],[1]};  
AFCGRAT_100C = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);

  contrasts={[0.1 0.2 0.3 0.4],[0.1 0.2 0.3 0.4]};  
AFCGRAT_LOC = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);

  contrasts={[0.5 0.6 0.7 0.8],[0.5 0.6 0.7 0.8]};  
AFCGRAT_HIC = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);

durationToFlip = 1;
durationAfterFlip = 4;
ctrCD_0_TO_100_constDur = changeDetectorSM(AFCGRAT_0C,AFCGRAT_100C,durationToFlip,durationAfterFlip,maxWidth,maxHeight,scaleFactor,interTrialLuminance);  

ctrCD_25_TO_100_constDur = changeDetectorSM(AFCGRAT_25C,AFCGRAT_100C,durationToFlip,durationAfterFlip,maxWidth,maxHeight,scaleFactor,interTrialLuminance);  


durationToFlip.type = 'uniform';
durationToFlip.params = [1 6];
durationAfterFlip = 4;
ctrCD_25_TO_100_varDur = changeDetectorSM(AFCGRAT_25C,AFCGRAT_100C,durationToFlip,durationAfterFlip,maxWidth,maxHeight,scaleFactor,interTrialLuminance);  
ctrCD_75_TO_100_varDur = changeDetectorSM(AFCGRAT_75C,AFCGRAT_100C,durationToFlip,durationAfterFlip,maxWidth,maxHeight,scaleFactor,interTrialLuminance);  
ctrCD_LO_TO_HI_varDur = changeDetectorSM(AFCGRAT_LOC,AFCGRAT_HIC,durationToFlip,durationAfterFlip,maxWidth,maxHeight,scaleFactor,interTrialLuminance);  


% training step using other objects as passed in
ts_Easy_constDur = trainingStep(tm, ctrCD_0_TO_100_constDur, repeatIndefinitely(), sch, svnRev, svnCheckMode);
ts_Gen_constDur = trainingStep(tm, ctrCD_25_TO_100_constDur, repeatIndefinitely(), sch, svnRev, svnCheckMode);
ts_Easy_varDur = trainingStep(tm, ctrCD_25_TO_100_varDur, repeatIndefinitely(), sch, svnRev, svnCheckMode);
ts_Hard_varDur = trainingStep(tm, ctrCD_75_TO_100_varDur, repeatIndefinitely(), sch, svnRev, svnCheckMode);
ts_Vary_varDur = trainingStep(tm, ctrCD_LO_TO_HI_varDur, repeatIndefinitely(), sch, svnRev, svnCheckMode);
