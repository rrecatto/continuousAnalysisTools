function r = setProtocolAG101101(r,subjIDs)
% protocol for Ghosh lab rats for viral inactivation of V1 experiment
% diverged from setProtocolElementaryVisionTests_100915 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% step 3 motion: 85% coherent motion 
% step 4&5 object recognition 
%   step 4 = go to the S+ stimulus (Nike)
%   step 5 = go to S+ ignore S- (Nike vs Discus)
% step 6&7 orientation 
%   step 6 = go to CW-tilt (only one stim)
%   step 7 = go to CW ignore CCW
% step 8&9 alternative orientation task
%   step 8 = go to CW-tilt BARCODE (only one stim)
%   step 9 = go to CW ignore CCW BARCODE
% step 10&11 alternative object recognition task
%   step 10 = go to the S+ stimulus (Nike)
%   step 11 = go to S+ ignore S- (Nike vs SpaceShuttle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PARAMETERS COACH CAN CHANGE MANUALLY %%
% define subjects
GhoshRats={'368','377','378','385', '386', '387', '388', '999'};
ValidTestSubject={'demo1'}; % use for debugging steps
demoStep = 8; % set to the step you want to test
ratStep = 4; % set the step you want to run a rat on
rewardScalar        =	1; % amount of water per reward (NEEDS TESTING)
msPenalty           =	2000;  % duration of time out
percentCorrectionTrials=0.20; % fraction of trials with correction

%%% COACHES DO NOT EDIT BELOW HERE %%%

%%some baseline utilities are here %%
% path where the log file will be saved (automatically logs each run)
logPath=fullfile(fileparts(fileparts(getRatrixPath)),'ratrix\setup\setupAG',filesep);
logFileName='GhoshV1VirusExperimentLog.txt';
svnRev={'svn://132.239.158.177/projects/ratrix/tags/v1.0.2'}; % version of ratrix to use
svnCheckMode='session'; % if ratrix code has been updated, get updates before each session
% standard stuff for all nAFC training steps
% useful variables rewardScalar,msPenalty,percentCorrectionTrials are set above 
[sm sch easy_pc strict_pc constantRewards tm] = ...
     make_nAFC_utilities_AG(rewardScalar, msPenalty,percentCorrectionTrials); 

% DEFINE THE TRAINING STEPS HERE %
 
% easy motion: 85% coherent motion 
ts_motion1 = createEasyMotion_AG(percentCorrectionTrials, tm, easy_pc, sch, svnRev, svnCheckMode);


%%%%%%% OBJECT RECOGNITION COMPONENT %%%%%%%%%%%%%%%%%%%
%% challenge: try making this a separate function "createObjectRecSteps" %%

%parameters used for all object rec steps:
imageRotation=[-20 20]; imageSize=[.75 1]; % vary size and rotation very slightly
imdir='C:\Documents and Settings\rlab\Desktop\ratrix 1.0.2\AGimageset'; % make LOCAL copy for standalone run **
imagelist=ImageSet_AG; % defines the image list(s) for all image training steps
interTrialLuminance_nAFC = 0.3; %extremely brief during stim calculation
background_nAFC=0; % note must be 0
ypos_nAFC=0; %location of image stimuli is near ports
imageSelectionMode='normal'; % not deck
imageSizeYoked=false; %false means image sizes chosen independently
imageRotationYoked=false; % false means rotation of two images chosen independently
drawingMode='expert'; %required
maxWidth                =1024; % size of the screen
maxHeight               =768; % size of the screen
scaleFactor             =[1 1]; %show image at full size

%create stimulus manager here 
imlist=imagelist.level1; % this one is go to statue not blank
imagestim = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,... %<<< imlist changes every time
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);
%finally this is the training step
ts_object1 = trainingStep(tm, imagestim, easy_pc, sch,svnRev,svnCheckMode);

%create another stim manager here 
imlist=imagelist.level2; % this one is go to Nike statue not discobolos statue
imagestim = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,... %<< here is where new image list given
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);
ts_object2 = trainingStep(tm, imagestim, easy_pc, sch,svnRev,svnCheckMode); %% give each ts a NEW NAME!!

%create another stim manager here 
imlist=imagelist.level5; % go to nike not shuttle
imagestim = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,...
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);
ts_object3 = trainingStep(tm, imagestim, easy_pc, sch,svnRev,svnCheckMode);

%%%%%%%%%%%%%%% ORIENTATION DISCRIMINATION COMPONENT %%%%%%%
%   step 6 = go to CW-tilt (only one stim)
% first argument zero means no distractor
ts_orientation1 = createEasyOrientation_AG(0, percentCorrectionTrials, tm, easy_pc, sch, svnRev, svnCheckMode);

%   step 7 = go to CW ignore CCW
% first argument 1 means with distractor
ts_orientation2 = createEasyOrientation_AG(1, percentCorrectionTrials, tm, easy_pc, sch, svnRev, svnCheckMode);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% step 8 = alternative orientation task using images
%create stim manager here, a few parameters different from above
imageRotation=[-5 5]; % tiny orientation noise 
imageSize=[.75 1]; % moderate size variation
imageSizeYoked=true; % always match spatial frequencies within trial
%all other params as set above

imlist=imagelist.level3; % go to right-tilt image
imagestim = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,...
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);
ts_orientation3 = trainingStep(tm, imagestim, easy_pc, sch,svnRev,svnCheckMode);

% % step 9 = go to right ori not left ori with images
%create stim manager here
imlist=imagelist.level4; % go to right tilt not left tilt
imagestim = images(imdir,ypos_nAFC, background_nAFC,...
    maxWidth,maxHeight,scaleFactor,interTrialLuminance_nAFC, imlist,...
    imageSelectionMode,imageSize,imageSizeYoked,imageRotation,imageRotationYoked,...
    percentCorrectionTrials,drawingMode);
ts_orientation4 = trainingStep(tm, imagestim, easy_pc, sch,svnRev,svnCheckMode);



%%%%%%%%%%% FINALLY make a protocol and put rats on it %%%%%%%%%%%%%%%%%

% here is the protocol determining which steps occur in what order. you can
% repeat steps.
descriptiveString='pGhosh101101'; % use this string in protocol call and also setProtocolAndStep and logfile
p = protocol(descriptiveString,...
    {ts_motion1 ts_object1 ts_object2 ts_orientation1 ts_orientation2...
    ts_orientation3 ts_orientation4 ts_object1 ts_object3}); %

%%%%%%%%%%%% AUTOMATED STUFF BELOW HERE %%%%%%%%%%%%%%%%%%%
thisIsANewProtocol=1; % typically 1
thisIsANewTrainingStep=1; % typically 1
thisIsANewStepNum=1;  %  typically 1
cd(logPath)
fid=fopen(logFileName,'a'); % logs assignment of rats to this protocol
fprintf(fid, 'svn ver %s\n',svnRev{1});

for i=1:length(subjIDs),% in standalonerun mode this will always be just one rat at a time
    subjObj = getSubjectFromID(r,subjIDs{i});
    
    if ismember(subjIDs{i},GhoshRats) % define ID list at top of this file 
        [subjObj r]=setProtocolAndStep(subjObj,p,...
            thisIsANewProtocol,thisIsANewTrainingStep,thisIsANewStepNum,ratStep,...
            r, descriptiveString,'pr');
        fprintf(fid,'%s finished setting %s to step %d of protocol %s\n', datestr(now),subjIDs{i},ratStep, descriptiveString);

    elseif ismember(subjIDs{i}, ValidTestSubject),% for testing

        [subjObj r]=setProtocolAndStep(subjObj,p,...
            thisIsANewProtocol,thisIsANewTrainingStep,thisIsANewStepNum,demoStep,... % set demoStep at top
            r, descriptiveString,'pr');

    else
        error('unexpected subject ID')
    end
end
fclose(fid)








