function [sm sch strict_pc constantRewards tm]= makeSimpleChangeDetector()

%%%% all this is for the visual tasks %%%%%
%create a sound manager
sm=soundManager({soundClip('correctSound','allOctaves',[400],20000), ...
    soundClip('keepGoingSound','empty'), ...
    soundClip('trySomethingElseSound','gaussianWhiteNoise'), ...
    soundClip('wrongSound','empty'),...
    soundClip('trialStartSound','empty')});
% NOT ANNOYING CHORD soundClip('wrongSound','tritones',[300 400],20000),...
    %soundClip('smallReward','allOctaves',[300],20000),...
    %soundClip('jackpot','allOctaves',[500],20000),...
    
percentCatchTrial = 0.2;
% scheduer 
sch=noTimeOff(); % runs until swapper ends session

% graduation criteria for graduation
strict_pc=performanceCriterion([0.85, 0.8],int16([40, 80]));
 
% take reinforcement manager from setProtocolTest but with params from Pam
requestRewardSize   =	0; 
rewardSize          =   50; % try this, may need to increase water rwd
doAllRequests       =	'first'; % always do this
fractionSoundOn     =	1; % this applies to beeps
fractionPenaltySoundOn = 0.10;  % fraction of the timeout that annoying error sound is on
msAirpuff           =   0;
msPenalty = 5000;
rewardScalar = 1;
constantRewards=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,...
    msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);  %% rewardScalar, msPenalty are arguments to the function

%create a trial manager - 
tm= changeDetectorTM(sm, percentCatchTrial, constantRewards); %percentCatchTrial is an argument to the function

