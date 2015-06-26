function pMouseTraining_Motion_Lever = mouseTraining_Motion_Lever(subID)
%% This protocol enables the following tasks:
% 1. stochastic free drinks
% 2. earned free drinks
% 3. object recognition 1

% details for each subject are internally modifiable. 
% define subjects

ValidTestSubject={'demo1','999'};

% define ratrix version to use
svnRev={''};
svnCheckMode='none';

[fd_sto0, fd_sto, fd_Cen, fd_Sides, fd_Alt] = createFreeDrinksStepsAG_auto_Lever(svnRev,svnCheckMode,subID);

[ts_obj1, ts_obj2] = createObjectTrialSteps_auto(svnRev,svnCheckMode,subID);

[ts_Moptim_reqRew, ts_Moptim, ts_MvelSweep, ts_McohSweepEasy, ...
    ts_McohSweepHard, ts_MDistractor1, ts_MDistractor2, ts_MDistractor3, ts_MDistractorSweep] = createAFCMotionSteps_auto(svnRev,svnCheckMode,subID);


%%%%%%%%%%% FINALLY make a protocol and put rats on it %%%%%%%%%%%%%%%%%

% here is the protocol
descriptiveString='mouseTraining_Motion_Lever';
pMouseTraining_Motion_Lever = protocol(descriptiveString,{fd_sto0,fd_sto,fd_Cen,fd_Sides,fd_Alt,ts_obj1, ts_obj2, ts_Moptim_reqRew, ts_Moptim,ts_MvelSweep, ts_McohSweepEasy, ...
    ts_McohSweepHard, ts_MDistractor1, ts_MDistractor2, ts_MDistractor3, ts_MDistractorSweep});
end

