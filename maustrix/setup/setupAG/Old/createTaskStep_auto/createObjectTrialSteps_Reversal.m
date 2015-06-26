function [ts1, ts2]=createObjectTrialSteps_Reversal(svnRev,svnCheckMode,subID)

out.rewardScalar = 1;
out.msPenalty = 5000;
out.rewardSize = 20;

out = getStimAndRewardParams(out,subID);

%utilities function: standard stuff for all nAFC training steps
sm=makeStandardSoundManager();

% scheduer 
sch=noTimeOff(); % runs until swapper ends session

% graduation criteria for graduation\
thresholdPC=performanceCriterionLatestStreak(0.8,int16(200)); % average of 80% correct for the past 200 trials

% take reinforcement manager from setProtocolTest but with params from Pam
requestRewardSize   =	10; 
rewardSize          =   out.rewardSize; % try this, may need to increase water rwd
doAllRequests       =	'first'; % always do this
fractionSoundOn     =	1; % this applies to beeps
fractionPenaltySoundOn = 0.10;  % fraction of the timeout that annoying error sound is on
msAirpuff           =   0;
rewardScalar = out.rewardScalar;
msPenalty = out.msPenalty;
percentCorrectionTrials=0;

constantRewards=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,...
    msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);  %% rewardScalar, msPenalty are arguments to the function

%create a trial manager - 
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
imagelist.level2 ={ { {'blank' 'Nike_standardcontrast'} 1.0} }; %
% here blank is target

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

% step 4 = go to S+
%create stim manager here
imlist=imagelist.level1; % go to nike not blank
imagestim1 = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,...
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);

imlist=imagelist.level2; % go to nike not blank
imagestim2 = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,...
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);


ts1 = trainingStep(tm, imagestim1, thresholdPC, sch,svnRev,svnCheckMode,'GotoObject_FullC');
ts2 = trainingStep(tm, imagestim2, thresholdPC, sch,svnRev,svnCheckMode,'GoAwayFromObject_FullC');
end
