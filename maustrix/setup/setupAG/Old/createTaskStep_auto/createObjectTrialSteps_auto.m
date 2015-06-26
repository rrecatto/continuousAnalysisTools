function [ts_obj_with_req, ts_obj, ts_obj2]=createObjectTrialSteps_auto(svnRev,svnCheckMode,subID)

out.rewardScalar = 1;
out.msPenalty = 5000;
out.rewardSize = 20;


out = getStimAndRewardParams(out,subID);

%utilities function: standard stuff for all nAFC training steps


sm=makeStandardSoundManager();

% scheduer 
sch=noTimeOff(); % runs until swapper ends session

% graduation criteria for graduation\
thresholdForResponseWithRequestReward = ratePerDayCriterion(250,2); % make sure animals do 250 per day for a couple of days
thresholdPC=performanceCriterionLatestStreak(0.8,int16(200)); % average of 80% correct for the past 200 trials

% take reinforcement manager from setProtocolTest but with params from Pam
requestRewardSize   =	20; 
rewardSize          =   out.rewardSize; % try this, may need to increase water rwd
doAllRequests       =	'first'; % always do this
fractionSoundOn     =	1; % this applies to beeps
fractionPenaltySoundOn = 0.10;  % fraction of the timeout that annoying error sound is on
msAirpuff           =   0;
rewardScalar = out.rewardScalar;
msPenalty = out.msPenalty;
percentCorrectionTrials=0.3;

constantRewardsWithRequest=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,...
    msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);  %% rewardScalar, msPenalty are arguments to the function


requestRewardSize   =	0; 
rewardSize          =   out.rewardSize*1.5; % try this, may need to increase water rwd
constantRewards=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,...
    msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);  %% rewardScalar, msPenalty are arguments to the function

%create a trial manager - 
tmWithRequest= nAFC(sm, percentCorrectionTrials, constantRewardsWithRequest); %percentCorrectionTrials is an argument to the function
tm= nAFC(sm, percentCorrectionTrials, constantRewards); %percentCorrectionTrials is an argument to the function


%%%%%%% OBJECT RECOGNITION COMPONENT %%%%%%%%%%%%%%%%%%%
%parameters used for all object rec steps:
% vary size and rotation very slightly
imageRotation=[-20 20]; imageSize=[.75 1];

try 
    imdir = '\\ghosh-16-159-221.ucsd.edu\ghosh\imFiles\PRimageset';
catch ex
    sca;
    keyboard;
end

imagelist = struct;
% contains nike and blank, nike is target
imagelist.level1 ={ { {'Nike_standardcontrast' 'blank'} 1.0} };
%  contains nike and a mirror image of discobolus (better match of overall shape); 
%  in this task nike is target
imagelist.level2 ={ { {'Nike_standardcontrast' 'DiscobolusMirror2_standardcontrast' } 1.0} }; %
% this is for our white noise oriented stim
imagelist.level3 ={ { {'Right45Lg' 'blank'} 1.0} };  
% with distractor
imagelist.level4 ={ { {'Right45Lg' 'Left45Lg'} 1.0} }; % populate struct, each training step has a field for its list
% varied contrast
imagelist.level5 = { ...
    { {'Nike_C0' 'blank'} 0.125},...
    { {'Nike_C05' 'blank'} 0.125},...
    { {'Nike_C10' 'blank'} 0.125},...
    { {'Nike_C15' 'blank'} 0.125},...
    { {'Nike_C20' 'blank'} 0.125},...
    { {'Nike_C30' 'blank'} 0.125},...
    { {'Nike_C40' 'blank'} 0.125},...
    { {'Nike_C100' 'blank'} 0.125},...
    };

interTrialLuminance_nAFC = 0.3; %extremely brief during stim calculation
background_nAFC=0; % note must be 0
ypos_nAFC=0; %location of image stimuli is near ports
imageSelectionMode='normal'; % not deck
imageSizeYoked=false; %true; % images have same size
imageRotationYoked=false; % rotation of two images chosen independently
drawingMode='expert';

[a,b] = getMACaddress();
switch b
    case 'A41F7278B4DE' %gLab-Behavior1
        maxWidth = 1920;
        maxHeight = 1080;
    case 'A41F729213E2' %gLab-Behavior2
        maxWidth = 1920;
        maxHeight = 1080;
    case 'A41F726EC11C' %gLab-Behavior3
        maxWidth = 1920;
        maxHeight = 1080;
    case '7845C4256F4C' %gLab-Behavior4
        maxWidth = 1920;
        maxHeight = 1080;
    case '7845C42558DF' %gLab-Behavior5
        maxWidth = 1920;
        maxHeight = 1080;
    case 'A41F729211B1' %gLab-Behavior6
        maxWidth = 1600;
        maxHeight = 900;
    case 'BC305BD38BFB' %ephys-stim
        maxWidth = 1920;
        maxHeight = 1080;
    case '180373337162' %ephys-data
        maxWidth = 1920;
        maxHeight = 1080;
    otherwise
        a
        b
        warning('not sure which computer you are using. add that mac to this step. delete db and then continue. also deal with the other createStep functions.');
        keyboard;
end

scaleFactor             =[1 1]; %show image at full size
percentCorrectionTrials = 0.5;

% step 4 = go to S+
%create stim manager here
imlist=imagelist.level1; % go to nike not blank
imagestim = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,...
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);
ts_obj_with_req = trainingStep(tmWithRequest, imagestim, thresholdForResponseWithRequestReward, sch,svnRev,svnCheckMode,'GotoObject_FullC_ReqReward');

ts_obj = trainingStep(tm, imagestim, thresholdPC, sch,svnRev,svnCheckMode,'GotoObject_FullC');

% % step 5 = go to S+ ignore S- (try discobolos, mirror imaged)
% step 4 = go to S+
%create stim manager here
percentCorrectionTrials = 0;
numTrialsCrit = numTrialsDoneCriterion(1600); % 1600 trials = 8 conditions * 200 trials/condition
imlist=imagelist.level5; % go to nike not blank
imagestim = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,...
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);
ts_obj2 = trainingStep(tm, imagestim, numTrialsCrit, sch,svnRev,svnCheckMode,'GotoObject_VarC');
end
