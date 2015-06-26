function ts = createEasyOrientation(withDistractor, percentCorrectionTrials, trialManager, performanceCrit, sch, svnRev, svnCheckMode);
% ts = createEasyOrientation(withDistractor, percentCorrectionTrials, ...
%  trialManager, performanceCrit, sch, svnRev, svnCheckMode);
% module % module that creates an easy orientation task
% christina and pam june 2010
% CHANGED stim params 100929 to make more salient

% ====================================================================================================================
% stimManager
% variables for stim managers
pixPerCycs              =[40]; % spatial frequency. changed 20->25 9/15/10 ->40 9/29
targetOrientations      =[pi/4]; %orientation 

if withDistractor,
    distractorOrientations  =[3*pi/4]; % distractor if any, its orientation
else % just go to stim
    distractorOrientations  =[]; % distractor if any, its orientation
end

mean                    =.5;
radius                  =.08; %0.04 too small? changed to .06 9/15/10 to .08 9/29
contrasts               =[1]; %0.6 too low? changed to 0.8 9/15/10 to 1 9/29
thresh                  =.00005;
yPosPct                 =.65;
maxWidth                =1024;
maxHeight               =768;
scaleFactor             =[1 1];
interTrialLuminance     =0; %.5;

%create a stim manager
freeStim = orientedGabors(pixPerCycs,targetOrientations,distractorOrientations,mean,radius,contrasts,thresh,yPosPct,maxWidth,maxHeight,scaleFactor,interTrialLuminance);

%create a training step
ts = trainingStep(trialManager, freeStim,performanceCrit, sch, svnRev, svnCheckMode);  



