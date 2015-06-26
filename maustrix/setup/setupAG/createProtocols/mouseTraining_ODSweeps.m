function pMouseTraining_ODSweeps = mouseTraining_ODSweeps(subID)
%% This protocol enables the following tasks:
% 1. stochastic free drinks
% 2. earned free drinks
% 3. object recognition 1
% 4. 45 and -45 degrees orientation task

% details for each subject are internally modifiable. 
% define subjects

% define ratrix version to use
svnRev={''};
svnCheckMode='none';

[fd_sto, fd] = createFreeDrinksStepsAG_auto(svnRev,svnCheckMode,subID);

[ts_obj1, ts_obj2] = createObjectTrialSteps_auto(svnRev,svnCheckMode,subID);

[ts_optim, ts_sfSweep, ts_ctrSweep, ts_orSweep] = createOrientationSteps_auto(svnRev,svnCheckMode,subID);

%%%%%%%%%%% FINALLY make a protocol and put rats on it %%%%%%%%%%%%%%%%%

% here is the protocol
descriptiveString='mouseTraining_ODSweeps';
pMouseTraining_ODSweeps = protocol(descriptiveString,{fd_sto,fd,ts_obj1,ts_obj2,...
    ts_optim,ts_sfSweep,ts_ctrSweep,ts_orSweep...
    });
end

