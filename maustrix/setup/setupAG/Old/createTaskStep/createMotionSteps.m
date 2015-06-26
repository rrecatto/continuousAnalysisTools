function [ts_Moptim, ts_MvelSweep, ts_McohSweep, ts_Mdot1, ts_Mdot2, ts_Mdot3] = createMotionSteps(svnRev,svnCheckMode,subj)

out = getStepDetails(subj);
afc_optim = coherentDots(out.screen_width,out.screen_height,out.num_dotsOpt,...  
    out.coherenceOpt,out.speedOpt,out.contrast,out.dot_sizeOpt,...  
    out.movie_duration,out.screen_zoom,out.maxWidth,out.maxHeight,out.percentCorrectionTrials);

afc_VELSweep = coherentDots(out.screen_width,out.screen_height,out.num_dotsOpt,...  
    out.coherenceOpt,out.speedSweep,out.contrast,out.dot_sizeOpt,...  
    out.movie_duration,out.screen_zoom,out.maxWidth,out.maxHeight,out.percentCorrectionTrials);


afc_COHSweep = coherentDots(out.screen_width,out.screen_height,out.num_dotsOpt,...  
    out.coherenceSweep,out.speedOpt,out.contrast,out.dot_sizeOpt,...  
    out.movie_duration,out.screen_zoom,out.maxWidth,out.maxHeight,out.percentCorrectionTrials);


afc_DOTSweep1 = coherentDots(out.screen_width,out.screen_height,out.num_dots1,...  
    out.coherenceOpt,out.speedOpt,out.contrast,out.dot_size1,...  
    out.movie_duration,out.screen_zoom,out.maxWidth,out.maxHeight,out.percentCorrectionTrials);

afc_DOTSweep2 = coherentDots(out.screen_width,out.screen_height,out.num_dots2,...  
    out.coherenceOpt,out.speedOpt,out.contrast,out.dot_size2,...  
    out.movie_duration,out.screen_zoom,out.maxWidth,out.maxHeight,out.percentCorrectionTrials);

afc_DOTSweep3 = coherentDots(out.screen_width,out.screen_height,out.num_dots3,...  
    out.coherenceOpt,out.speedOpt,out.contrast,out.dot_size3,...  
    out.movie_duration,out.screen_zoom,out.maxWidth,out.maxHeight,out.percentCorrectionTrials);

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
ts_Moptim = trainingStep(tm, afc_optim, crit, sch, svnRev, svnCheckMode,'OptM'); %CHANGE
ts_MvelSweep = trainingStep(tm, afc_VELSweep, crit, sch, svnRev, svnCheckMode,'velSweepM'); %CHANGE
ts_McohSweep = trainingStep(tm, afc_COHSweep, crit, sch, svnRev, svnCheckMode,'cohSweepM');% CHANGE
ts_Mdot1 = trainingStep(tm, afc_DOTSweep1, crit, sch, svnRev, svnCheckMode,'size1M'); %CHANGE
ts_Mdot2 = trainingStep(tm, afc_DOTSweep2, crit, sch, svnRev, svnCheckMode,'size2M'); %CHANGE
ts_Mdot3 = trainingStep(tm, afc_DOTSweep3, crit, sch, svnRev, svnCheckMode,'size3M'); %CHANGE
end

function out = getStepDetails(id)
out.coherenceOpt = .9;             % Percent of dots to move in a specified direction
out.coherenceSweep = [0.15 0.65]; %[.15,.2,.25,.3,.35,.4,.65,.9];             % Percent of dots to move in a specified direction
out.contrast = 1;               % contrast of the dots
out.movie_duration = 2;         % in seconds
out.pctCorrectionTrials=.5;
out.replayMode='loop';
out.LUT=[];
out.LUTbits=0;

[a, b] = getMACaddress();
switch b
    case 'A41F7278B4DE' %gLab-Behavior1
        out.screen_width = 128;         % for matrix
        out.screen_height = 72;        % for matrix
        out.num_dotsOpt = 461;              % Number of dots to display
        out.num_dots1 = 1844;              % Number of dots to display
        out.num_dots2 = 461;              % Number of dots to display
        out.num_dots3 = 115;              % Number of dots to display
        out.speedOpt = 0.33;                  % How fast do our little dots move
        out.speedSweep = [0.085 1.32]; %[0.0825,0.0165,0.33,0.66,1.32];                  % How fast do our little dots move
        out.dot_sizeOpt = 2;              % Width of dots in pixels
        out.dot_size1 = 1;              % Width of dots in pixels
        out.dot_size2 = 2;              % Width of dots in pixels
        out.dot_size3 = 4;              % Width of dots in pixels
        out.screen_zoom=[15 15];
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case 'A41F729213E2' %gLab-Behavior2
        out.screen_width = 128;         % for matrix
        out.screen_height = 72;        % for matrix
        out.num_dotsOpt = 461;              % Number of dots to display
        out.num_dots1 = 1844;              % Number of dots to display
        out.num_dots2 = 461;              % Number of dots to display
        out.num_dots3 = 115;              % Number of dots to display
        out.speedOpt = 0.33;                  % How fast do our little dots move
        out.speedSweep = [0.085 1.32]; %[0.0825,0.0165,0.33,0.66,1.32];                  % How fast do our little dots move
        out.dot_sizeOpt = 2;              % Width of dots in pixels
        out.dot_size1 = 1;              % Width of dots in pixels
        out.dot_size2 = 2;              % Width of dots in pixels
        out.dot_size3 = 4;              % Width of dots in pixels
        out.screen_zoom=[15 15];
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case 'A41F726EC11C' %gLab-Behavior3
        out.screen_width = 128;         % for matrix
        out.screen_height = 72;        % for matrix
        out.num_dotsOpt = 461;              % Number of dots to display
        out.num_dots1 = 1844;              % Number of dots to display
        out.num_dots2 = 461;              % Number of dots to display
        out.num_dots3 = 115;              % Number of dots to display
        out.speedOpt = 0.33;                  % How fast do our little dots move
        out.speedSweep = [0.085 1.32]; %[0.0825,0.0165,0.33,0.66,1.32];                  % How fast do our little dots move
        out.dot_sizeOpt = 2;              % Width of dots in pixels
        out.dot_size1 = 1;              % Width of dots in pixels
        out.dot_size2 = 2;              % Width of dots in pixels
        out.dot_size3 = 4;              % Width of dots in pixels
        out.screen_zoom=[15 15];
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case '7845C4256F4C' %gLab-Behavior4
        out.screen_width = 128;         % for matrix
        out.screen_height = 72;        % for matrix
        out.num_dotsOpt = 461;              % Number of dots to display
        out.num_dots1 = 1844;              % Number of dots to display
        out.num_dots2 = 461;              % Number of dots to display
        out.num_dots3 = 115;              % Number of dots to display
        out.speedOpt = 0.33;                  % How fast do our little dots move
        out.speedSweep = [0.085 1.32]; %[0.0825,0.0165,0.33,0.66,1.32];                  % How fast do our little dots move
        out.dot_sizeOpt = 2;              % Width of dots in pixels
        out.dot_size1 = 1;              % Width of dots in pixels
        out.dot_size2 = 2;              % Width of dots in pixels
        out.dot_size3 = 4;              % Width of dots in pixels
        out.screen_zoom=[15 15];
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case '7845C42558DF' %gLab-Behavior5
        out.screen_width = 128;         % for matrix
        out.screen_height = 72;        % for matrix
        out.num_dotsOpt = 461;              % Number of dots to display
        out.num_dots1 = 1844;              % Number of dots to display
        out.num_dots2 = 461;              % Number of dots to display
        out.num_dots3 = 115;              % Number of dots to display
        out.speedOpt = 0.33;                  % How fast do our little dots move
        out.speedSweep = [0.085 1.32]; %[0.0825,0.0165,0.33,0.66,1.32];                  % How fast do our little dots move
        out.dot_sizeOpt = 2;              % Width of dots in pixels
        out.dot_size1 = 1;              % Width of dots in pixels
        out.dot_size2 = 2;              % Width of dots in pixels
        out.dot_size3 = 4;              % Width of dots in pixels
        out.screen_zoom=[15 15];
        out.maxWidth = 1920;
        out.maxHeight = 1080;
    case 'A41F729211B1' %gLab-Behavior6
        out.screen_width = 320;         % for matrix
        out.screen_height = 180;        % for matrix
        out.num_dotsOpt = 320;              % Number of dots to display
        out.num_dots1 = 1280;              % Number of dots to display
        out.num_dots2 = 320;              % Number of dots to display
        out.num_dots3 = 80;              % Number of dots to display
        out.speedOpt = 1;                  % How fast do our little dots move
        out.speedSweep = [0.25 4]; % [0.25,0.5,1,2,4];                  % How fast do our little dots move
        out.dot_sizeOpt = 6;              % Width of dots in pixels
        out.dot_size1 = 3;              % Width of dots in pixels
        out.dot_size2 = 6;              % Width of dots in pixels
        out.dot_size3 = 12;              % Width of dots in pixels
        out.screen_zoom=[5 5];
        out.maxWidth = 1600;
        out.maxHeight = 900;
    case 'BC305BD38BFB' %ephys-stim
        out.screen_width = 128;         % for matrix
        out.screen_height = 72;        % for matrix
        out.num_dotsOpt = 461;              % Number of dots to display
        out.num_dots1 = 1844;              % Number of dots to display
        out.num_dots2 = 461;              % Number of dots to display
        out.num_dots3 = 115;              % Number of dots to display
        out.speedOpt = 0.33;                  % How fast do our little dots move
        out.speedSweep = [0.085 1.32]; %[0.0825,0.0165,0.33,0.66,1.32];                  % How fast do our little dots move
        out.dot_sizeOpt = 2;              % Width of dots in pixels
        out.dot_size1 = 1;              % Width of dots in pixels
        out.dot_size2 = 2;              % Width of dots in pixels
        out.dot_size3 = 4;              % Width of dots in pixels
        out.screen_zoom=[15 15];
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
out.percentCorrectionTrials = 0.5;

% details for reinforcement
out.rewardScalar = 0.2;
out.rewardSize = 50;
out.msPenalty = 5000;
switch id
    case '999'
        % nothing changes here, but might later
    case 'demo1'
        out.maxDurationOpt = {[3],[3]};
        out.doPostDiscrim = true;
    otherwise
        error('unsupported mouse id. are you sure that the mouse is supposed to be here?')
end
end
