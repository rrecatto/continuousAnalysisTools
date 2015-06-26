function [ts_obj1, ts_obj2]=createObjectTrialSteps(svnRev,svnCheckMode,subjectID)

out = getStepDetails(subjectID);


%utilities function: standard stuff for all nAFC training steps
rewardScalar = out.rewardScalar;
msPenalty = out.msPenalty;
percentCorrectionTrials=0.3;

sm=soundManager({soundClip('correctSound','allOctaves',[400],20000), ...
    soundClip('keepGoingSound','empty'), ...
    soundClip('trySomethingElseSound','gaussianWhiteNoise'), ...
    soundClip('wrongSound','empty'),...
    soundClip('trialStartSound','empty')});

% scheduer 
sch=noTimeOff(); % runs until swapper ends session

% graduation criteria for graduation
easy_pc=performanceCriterion([0.8],int16([200]));
strict_pc=performanceCriterion([0.85, 0.8],int16([200, 500]));
crit = repeatIndefinitely();
% take reinforcement manager from setProtocolTest but with params from Pam
requestRewardSize   =	0; 
rewardSize          =   out.rewardSize; % try this, may need to increase water rwd
doAllRequests       =	'first'; % always do this
fractionSoundOn     =	1; % this applies to beeps
fractionPenaltySoundOn = 0.10;  % fraction of the timeout that annoying error sound is on
msAirpuff           =   0;

constantRewards=constantReinforcement(rewardSize,requestRewardSize,doAllRequests,...
    msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);  %% rewardScalar, msPenalty are arguments to the function

%create a trial manager - 
tm= nAFC(sm, percentCorrectionTrials, constantRewards); %percentCorrectionTrials is an argument to the function


%%%%%%% OBJECT RECOGNITION COMPONENT %%%%%%%%%%%%%%%%%%%
%parameters used for all object rec steps:
% vary size and rotation very slightly
imageRotation=[-20 20]; imageSize=[.75 1];

try 
    imdir = '\\ghosh-nas.ucsd.edu\ghosh\imFiles\PRimageset';
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
ts_obj1 = trainingStep(tm, imagestim, crit, sch,svnRev,svnCheckMode,'GotoObject_FullC');

% % step 5 = go to S+ ignore S- (try discobolos, mirror imaged)
% step 4 = go to S+
%create stim manager here
imlist=imagelist.level5; % go to nike not blank
imagestim = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,...
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);
ts_obj2 = trainingStep(tm, imagestim, crit, sch,svnRev,svnCheckMode,'GotoObject_VarC');
end

function out = getStepDetails(id)
out.rewardScalar = 0.25;
out.msPenalty = 5000;
out.rewardSize = 50;
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
        out.msPenalty = 5000;
        out.rewardScalar = 0.15;
        % changed to 15000 05292013,
        % changed back to 5000 6/5
    case '84'
        % nothing changes here, but might later
    case '86'
        % nothing changes here, but might later
    case '87'
        % nothing changes here, but might later
    case '90'
        % nothing changes here, but might later
    case '91'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 8/5
    case '92'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 8/5
    case '93'
        % nothing changes here, but might later
    case '95'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 6/26
    case '96'
        out.rewardScalar = 0.15;
        % nothing changes here, but might later
    case '97'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 8/5
    case '98'
        out.rewardScalar = 0.05; 
        % reward reduced to 0.1 on 8/5
        % reward reduced to 0.05 8/22
    case '99'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 6/26
    case '200'
        % nothing changes here, but might later
    case '201'
        % nothing changes here, but might later
    case '202'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 7/8
    case '203'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 6/26
    case '204'
        out.rewardScalar = 0.08;
        % reward reduced to 0.1 on 6/26
    case '205'
        % nothing changes here, but might later
    case '206'
        out.rewardScalar = 0.10; % changed on 8/22
    case '207'
        % nothing changes here, but might later
    case '208'
        out.rewardScalar = 0.10; % changed on 8/5
    case '209'
        out.rewardScalar = 0.05; 
        % reward reduced to 0.1 on 8/5
        % reduced to 0.05 on 8/15
    case '210'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 8/5
    case '211'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 8/5
    case '212'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 8/5
    case '213'
        % nothing changes here, but might later
    case '214'
        % nothing changes here, but might later
    case '215'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 8/5
    case '216'
        out.rewardScalar = 0.1; 
        % reward reduced to 0.1 on 8/5
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
        out.rewardScalar = 0.1;
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
        out.rewardScalar = 0.05;
        % reduced reward 4/28
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
