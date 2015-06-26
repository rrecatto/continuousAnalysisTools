function [sm sch easy_pc strict_pc constantRewards tm]= make_nAFC_utilities_AG(rewardScalar, msPenalty,percentCorrectionTrials);
%function [sm sch easy_pc strict_pc constantRewards tm]= 
%  make_nAFC_utilitiesCS(rewardScalar, msPenalty,percentCorrectionTrials);
% function encapsulating the setup of standard utilities for 2afc tasks.

% later could implement default values
% rewardScalar        =	1;
% msPenalty           =	2000;  
% percentCorrectionTrials=0.20;  

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
    
    
% scheduer 
sch=noTimeOff(); % runs until swapper ends session

% graduation criteria for graduation
easy_pc=performanceCriterion([0.8],int16([200]));
strict_pc=performanceCriterion([0.85, 0.8],int16([200, 500]));
 
% take reinforcement manager from setProtocolTest but with params from Pam
requestRewardSize   =	0; 
rewardSize          =   50; % try this, may need to increase water rwd
doAllRequests       =	'first'; % always do this
fractionSoundOn     =	1; % this applies to beeps
fractionPenaltySoundOn = 0.10;  % fraction of the timeout that annoying error sound is on
msAirpuff           =   0;

constantRewards=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,...
    msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);  %% rewardScalar, msPenalty are arguments to the function

%create a trial manager - 
tm= nAFC(sm, percentCorrectionTrials, constantRewards); %percentCorrectionTrials is an argument to the function

