function [ts_Moptim_reqRew, ts_Moptim, ts_MvelSweep, ts_McohSweepEasy, ...
    ts_McohSweepHard, ts_MDistractor1, ts_MDistractor2, ts_MDistractor3, ts_MDistractorSweep] = ...
    createAFCMotionSteps_auto(svnRev,svnCheckMode, subID)

out = getStepDetails();

out = getStimAndRewardParams(out,subID);

afc_optim = afcCoherentDots(out.numDotsOpt,out.bkgdNumDotsOpt, out.dotCoherenceOpt,out.bkgdCoherenceOpt, ...
    out.dotSpeedOpt,out.bkgdSpeedOpt, out.dotDirectionOpt,out.bkgdDirectionOpt,...
    out.dotColorOpt,out.bkgdDotColorOpt, out.dotSizeOpt,out.bkgdSizeOpt, ...
    out.dotShapeOpt,out.bkgdShapeOpt, out.renderMode, out.maxDurationOpt,out.background,...
    out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance, out.doCombos);
           
afc_velSweep = afcCoherentDots(out.numDotsOpt,out.bkgdNumDotsOpt, out.dotCoherenceOpt,out.bkgdCoherenceOpt, ...
    out.dotSpeedSweep,out.bkgdSpeedOpt, out.dotDirectionOpt,out.bkgdDirectionOpt,...
    out.dotColorOpt,out.bkgdDotColorOpt, out.dotSizeOpt,out.bkgdSizeOpt, ...
    out.dotShapeOpt,out.bkgdShapeOpt, out.renderMode, out.maxDurationOpt,out.background,...
    out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance, out.doCombos);


afc_cohSweepEasy = afcCoherentDots(out.numDotsOpt,out.bkgdNumDotsOpt, out.dotCoherenceSweepEasy,out.bkgdCoherenceOpt, ...
    out.dotSpeedOpt,out.bkgdSpeedOpt, out.dotDirectionOpt,out.bkgdDirectionOpt,...
    out.dotColorOpt,out.bkgdDotColorOpt, out.dotSizeOpt,out.bkgdSizeOpt, ...
    out.dotShapeOpt,out.bkgdShapeOpt, out.renderMode, out.maxDurationOpt,out.background,...
    out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance, out.doCombos);

afc_cohSweepHard = afcCoherentDots(out.numDotsOpt,out.bkgdNumDotsOpt, out.dotCoherenceSweep,out.bkgdCoherenceOpt, ...
    out.dotSpeedOpt,out.bkgdSpeedOpt, out.dotDirectionOpt,out.bkgdDirectionOpt,...
    out.dotColorOpt,out.bkgdDotColorOpt, out.dotSizeOpt,out.bkgdSizeOpt, ...
    out.dotShapeOpt,out.bkgdShapeOpt, out.renderMode, out.maxDurationOpt,out.background,...
    out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance, out.doCombos);


afc_distractor1 = afcCoherentDots(out.numDotsOpt,out.bkgdNumDotsDistractor, out.dotCoherenceOpt,out.bkgdCoherenceOpt, ...
    out.dotSpeedOpt,out.bkgdSpeedOpt, out.dotDirectionOpt,out.bkgdDirectionOpt,...
    out.dotColorOpt,out.bkgdDotColorLowNoise, out.dotSizeOpt,out.bkgdSizeOpt, ...
    out.dotShapeOpt,out.bkgdShapeOpt, out.renderMode, out.maxDurationOpt,out.background,...
    out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance, out.doCombos);

afc_distractor2 = afcCoherentDots(out.numDotsOpt,out.bkgdNumDotsDistractor, out.dotCoherenceOpt,out.bkgdCoherenceOpt, ...
    out.dotSpeedOpt,out.bkgdSpeedOpt, out.dotDirectionOpt,out.bkgdDirectionOpt,...
    out.dotColorOpt,out.bkgdDotColorMedNoise, out.dotSizeOpt,out.bkgdSizeOpt, ...
    out.dotShapeOpt,out.bkgdShapeOpt, out.renderMode, out.maxDurationOpt,out.background,...
    out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance, out.doCombos);

afc_distractor3 = afcCoherentDots(out.numDotsOpt,out.bkgdNumDotsDistractor, out.dotCoherenceOpt,out.bkgdCoherenceOpt, ...
    out.dotSpeedOpt,out.bkgdSpeedOpt, out.dotDirectionOpt,out.bkgdDirectionOpt,...
    out.dotColorOpt,out.bkgdDotColorHiNoise, out.dotSizeOpt,out.bkgdSizeOpt, ...
    out.dotShapeOpt,out.bkgdShapeOpt, out.renderMode, out.maxDurationOpt,out.background,...
    out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance, out.doCombos);

afc_distractor4 = afcCoherentDots(out.numDotsOpt,out.bkgdNumDotsDistractor, out.dotCoherenceSweepEasy,out.bkgdCoherenceOpt, ...
    out.dotSpeedOpt,out.bkgdSpeedOpt, out.dotDirectionOpt,out.bkgdDirectionOpt,...
    out.dotColorOpt,out.bkgdDotColorHiNoise, out.dotSizeOpt,out.bkgdSizeOpt, ...
    out.dotShapeOpt,out.bkgdShapeOpt, out.renderMode, out.maxDurationOpt,out.background,...
    out.maxWidth,out.maxHeight,out.scaleFactor,out.interTrialLuminance, out.doCombos);

% sound Manager
sm=makeStandardSoundManager_HF();
% scheduler
sch=noTimeOff(); % runs until swapper ends session

% criterion
thresholdPC=performanceCriterionLatestStreak(0.8,int16(200));
numTrialsCrit_cohSweepEasy = numTrialsDoneCriterion(1000); % 1600 trials = 8 conditions * 200 trials/condition
numTrialsCrit_cohSweepHard = numTrialsDoneCriterion(1600); % 1600 trials = 8 conditions * 200 trials/condition
numTrialsCrit_velSweep = numTrialsDoneCriterion(1000); % 1000 trials = 5 conditions * 200 trials/condition
goodTrialRateForNDays = ratePerDayCriterion(125,3); % perform minimum of 125 trials for three consecutive days to graduate...


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
constantRewardsWithReqRewards = constantReinforcement(rewardSize,10,doAllRequests,msPenalty,fractionSoundOn,fractionPenaltySoundOn,rewardScalar,msAirpuff);

tm= nAFC(sm, percentCorrectionTrials, constantRewards);
tmWithReqRew = nAFC(sm, percentCorrectionTrials, constantRewardsWithReqRewards);

% training step using other objects as passed in
ts_Moptim_reqRew = trainingStep(tmWithReqRew, afc_optim, goodTrialRateForNDays, sch, svnRev, svnCheckMode,'OptMAFC_wReqRew'); 
ts_Moptim = trainingStep(tm, afc_optim, thresholdPC, sch, svnRev, svnCheckMode,'OptMAFC');

ts_MvelSweep = trainingStep(tm, afc_velSweep, numTrialsCrit_velSweep, sch, svnRev, svnCheckMode,'velSweepMAFC');

ts_McohSweepEasy = trainingStep(tm, afc_cohSweepEasy, numTrialsCrit_cohSweepEasy, sch, svnRev, svnCheckMode,'cohSweepMAFC_Easy');
ts_McohSweepHard = trainingStep(tm, afc_cohSweepHard, numTrialsCrit_cohSweepHard, sch, svnRev, svnCheckMode,'cohSweepMAFC_Hard');

ts_MDistractor1 = trainingStep(tm, afc_distractor1, thresholdPC, sch, svnRev, svnCheckMode,'Distractor1_MAFC');
ts_MDistractor2 = trainingStep(tm, afc_distractor2, thresholdPC, sch, svnRev, svnCheckMode,'Distractor2_MAFC');
ts_MDistractor3 = trainingStep(tm, afc_distractor3, thresholdPC, sch, svnRev, svnCheckMode,'Distractor3_MAFC');

ts_MDistractorSweep = trainingStep(tm, afc_distractor4, repeatIndefinitely(), sch, svnRev, svnCheckMode,'Distractor_CohSweep_MAFC');
end

function out = getStepDetails()

% opt
out.numDotsOpt = {100,100};                            % Number of dots to display
out.bkgdNumDotsOpt = {0,0};                            % task irrelevant dots
out.dotCoherenceOpt = {0.99, 0.99};                    % Percent of dots to move in a specified direction
out.bkgdCoherenceOpt = {0.8, 0.8};                     % percent of bkgs dots moving in the specified direction
out.dotSpeedOpt = {2,2};                               % How fast do our little dots move (dotSize/sec)
out.bkgdSpeedOpt = {0.9,0.9};                          % speed of bkgd dots
out.dotDirectionOpt = {[pi],[0]};                      % 0 is to the right. pi is to the left
out.bkgdDirectionOpt = {[0:pi/4:2*pi],[0:pi/4:2*pi]};  % 0 is to the right. pi is to the left
out.dotColorOpt = {[1 1 1 0.5],[1 1 1 0.5]};           % can be a single number< 1 (used as a gray scale value); a single row of 3/4 (RGB/RGBA) ; or many rows o4 the above number sets in which case randomly chosen 
out.bkgdDotColorOpt = {[1 0 1 0.05],[1 0 1 0.05]};     % can be a single number< 1 (used as a gray scale value); a single row of 3/4 (RGB/RGBA) ; or many rows o4 the above number sets in which case randomly chosen 
out.dotSizeOpt = {[60],[60]};                          % Width of dots in pixels
out.bkgdSizeOpt = {[30],[30]};                         % Width in pixels
out.dotShapeOpt = {{'circle'},{'circle'}};             % 'circle' or 'rectangle'
out.bkgdShapeOpt = {{'square'},{'square'}};            % 'circle' or 'square'
out.renderMode = {'flat'};                             % {'flat'} or {'perspective',[renderDistances]}{'perspective',[1 5]}; 
out.renderDistance = NaN;                              % is 1 for flat and is a range for perspective
out.maxDurationOpt = {inf, inf};                       % in seconds (inf is until response)
out.background = 0;                                 % black background
out.maxWidth=1920;
out.maxHeight=1080;
out.scaleFactor=0;
out.interTrialLuminance=.5;
out.doCombosOpt = true;


[a, b] = getMACaddress();
switch b
    case {'A41F7278B4DE','A41F729213E2','A41F726EC11C','7845C4256F4C','7845C42558DF'}%gLab-Behavior1-5
        error('not yet');
    case 'A41F729211B1' %gLab-Behavior6
        out.maxWidth=1600;
        out.maxHeight=900;
        out.scaleFactor=0;
        out.interTrialLuminance={.2,120}; % low luminance for 2 seconds and no responses.

        out.numDotsOpt = {320,320};
        
        out.dotSpeedSweep = {2.^(-1:3),2.^(-1:3)}; %[0.5,1,2,4,8]
        
        out.dotCoherenceSweepEasy = {0.2:0.2:1,0.2:0.2,1};
        out.dotCoherenceSweep = {logspace(-1,0,8),logspace(-1,0,8)};
        
        out.bkgdNumDotsDistractor = {100,100};
        out.bkgdDotColorLowNoise = {[1 0 1 0.05],[1 0 1 0.05]};
        out.bkgdDotColorMedNoise = {[1 0 1 0.1],[1 0 1 0.1]};
        out.bkgdDotColorHiNoise  = {[1 0 1 0.25],[1 0 1 0.25]};
    case 'BC305BD38BFB' %ephys-stim
        out.maxWidth=1920;
        out.maxHeight=1080;
        out.scaleFactor=0;
        out.interTrialLuminance={.2,120}; % low luminance for 2 seconds and no responses.

        out.numDotsOpt = {461,461};
        
        out.dotSpeedSweep = {2.^(-1:3),2.^(-1:3)}; %[0.5,1,2,4,8]
        
        out.dotCoherenceSweepEasy = {0.2:0.2:1,0.2:0.2:1};
        out.dotCoherenceSweep = {logspace(-1,0,8),logspace(-1,0,8)};
        
        out.bkgdNumDotsDistractor = {100,100};
        out.bkgdDotColorLowNoise = {[1 0 1 0.05],[1 0 1 0.05]};
        out.bkgdDotColorMedNoise = {[1 0 1 0.1],[1 0 1 0.1]};
        out.bkgdDotColorHiNoise  = {[1 0 1 0.25],[1 0 1 0.25]};

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

end
