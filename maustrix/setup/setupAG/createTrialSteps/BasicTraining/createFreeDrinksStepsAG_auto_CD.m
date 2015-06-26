function [stochdrinkLever_Center, freedrinkLever_Center]=createFreeDrinksStepsAG_auto_CD(svnRev,svnCheckMode,subID)

out.rewardSizeULorMS = 20;
out.scalar = 1;
out.msPenalty = 1000;
out.requestRewardSizeULorMS = 0;
out.pStochastic = 0.001;
out.PPC = 64;

out = getStimAndRewardParams(out,subID);

% key variables for reinforcement and trial managers
rewardSizeULorMS = out.rewardSizeULorMS;
scalar = out.scalar;
fractionOpenTimeSoundIsOn = 1;
doAllRequests = 'first';

% these should not matter in FD because there are no wrong answers
msPenalty = out.msPenalty;
fractionPenaltySoundIsOn = 1;
msAirpuff = 0;
% should not matter because there is no "request" defined

requestRewardSizeULorMS = out.requestRewardSizeULorMS;

% TO DO low priority: once the FD steps are tested and work, try setting
% all the ones that don't matter to [] and see if it still works.

sm=makeStandardSoundManager();

% reinforcement manager
constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,doAllRequests,msPenalty,fractionOpenTimeSoundIsOn...
    ,fractionPenaltySoundIsOn,scalar,msAirpuff);

%trialManager
allowRepeats=true;
pStochastic=out.pStochastic;
fd_sto_Cen = freeDrinksCenterOnly(sm,pStochastic,allowRepeats,constantRewards); % Stochastic reward (fixed rate)

pStochastic=0;
fd_Center = freeDrinksCenterOnly(sm,pStochastic,allowRepeats,constantRewards); % lick center for reward


% stimManager Details
pixPerCycs = out.PPC;
targetOrientations = pi/2;
distractorOrientations = [];
mean = .5;
radius = .1;
contrasts = [1 .5];
thresh = .00005;
yPosPct = .65;

[a, b] = getMACaddress();
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

scaleFactor = [1 1];
interTrialLuminance  = .5;

freeStim = orientedGabors(pixPerCycs,targetOrientations,distractorOrientations,mean,radius,contrasts,thresh,yPosPct,maxWidth,maxHeight,scaleFactor,interTrialLuminance);
runFor3Days=numDaysCriterion(3); %Run for a minimum of 3 days (for each fd)
runFor2Days=numDaysCriterion(2); %Run for a minimum of 2 days (for each fd)
goodTrialRateForNDays = ratePerDayCriterion(125,1); % perform minimum of 125 trials for one consecutive days to graduate...

stochdrinkLever_Center = trainingStep(fd_sto_Cen, freeStim, numDaysCriterion(1) , noTimeOff(), svnRev, svnCheckMode);   %stochastic free drinks
freedrinkLever_Center = trainingStep(fd_Center, freeStim, goodTrialRateForNDays , noTimeOff(), svnRev, svnCheckMode);  % fd center lick
end
