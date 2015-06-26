function [stochdrink freedrink]=createFreeDrinksStepsAG(svnRev,svnCheckMode,subjectID)

out = getStepDetails(subjectID);

% key variables for reinforcement and trial managers
rewardSizeULorMS = out.rewardSizeULorMS;
scalar = out.scalar;
fractionOpenTimeSoundIsOn = 1;
doAllRequests = 'first';

% these should not matter in FD because there are no wrong answers
msPenalty = out.msPenalty;
fractionPenaltySoundIsOn = 1;
msAirpuff = msPenalty;
percentCorrectionTrials = 0.5;
% should not matter because there is no "request" defined

requestRewardSizeULorMS = out.requestRewardSizeULorMS;

% TO DO low priority: once the FD steps are tested and work, try setting
% all the ones that don't matter to [] and see if it still works.

sm=soundManager({soundClip('correctSound','allOctaves',[400],20000), ...
    soundClip('keepGoingSound','empty'), ...
    soundClip('trySomethingElseSound','gaussianWhiteNoise'), ...
    soundClip('wrongSound','empty'),...
    soundClip('trialStartSound','empty')});

% reinforcement manager
constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,doAllRequests,msPenalty,fractionOpenTimeSoundIsOn...
    ,fractionPenaltySoundIsOn,scalar,msAirpuff);


%trialManager
allowRepeats=false;
pStochastic=out.pStochastic;
fd_sto = freeDrinks(sm,pStochastic,allowRepeats,constantRewards);

pStochastic=0;
fd = freeDrinks(sm,pStochastic,allowRepeats,constantRewards);

% stimManager Details
pixPerCycs = out.PPC;
targetOrientations = pi/2;
distractorOrientations = [];
mean = .5;
radius = .1;
contrasts = [1 .5];
thresh = .00005;
yPosPct = .65;
[a b] = getMACaddress;
if strcmp(b,'BC305BD38BFB') % balaji's personal computer
    maxWidth = 800;
    maxHeight = 600;
elseif strcmp (b,'7CD1C3E5176F')
    maxWidth = 1440;
    maxHeight = 900;
else
    maxWidth = 1024;
    maxHeight = 768;
end
scaleFactor = [1 1];
interTrialLuminance  = .5;

freeStim = orientedGabors(pixPerCycs,targetOrientations,distractorOrientations,mean,radius,contrasts,thresh,yPosPct,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
graduationCriterion=performanceCriterion([.1], int16([10])); %10 pct correct for 10 trials in a row?

stochdrink = trainingStep(fd_sto, freeStim, graduationCriterion , noTimeOff(), svnRev, svnCheckMode);   %stochastic free drinks
freedrink = trainingStep(fd, freeStim, graduationCriterion , noTimeOff(), svnRev, svnCheckMode);  %free drinks
end

function out = getStepDetails(id)
switch id
    case {'1','2','4','5','7','8','9','10','11','12','13','14','15','17','18','19','20'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case {'3'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case {'6'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case {'16'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case {'21'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case {'22'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case {'23'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case {'24'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case {'25'}
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case 'ACM1'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case 'ACM2'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case 'ACM3'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case 'ACM4'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case 'ACM5'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case 'demo1'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.004;
        
        out.PPC = 64;
    case '999'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.003;

        out.PPC = 32;

    case '31'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.003;

        out.PPC = 64;
    case '32'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.002;

        out.PPC = 64;
    case '33'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.002;

        out.PPC = 64;
    case '34'
        out.rewardSizeULorMS = 50;
        out.scalar = 1;
        out.msPenalty = 1000;
        out.requestRewardSizeULorMS = 10;
        out.pStochastic = 0.002;

        out.PPC = 64;
    otherwise
        error('unsupported mouse id. are you sure that the mouse is supposed to be here?')
end
end
