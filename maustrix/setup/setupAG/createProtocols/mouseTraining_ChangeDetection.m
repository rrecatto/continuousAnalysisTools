function pMouseTraining_ChangeDetection = mouseTraining_ChangeDetection(subID)
%% This protocol enables the following tasks:
% 1. stochastic free drinks
% 2. earned free drinks
% 3. object recognition 1

% define ratrix version to use
svnRev={''};
svnCheckMode='none';

[fd_sto, fd_Cen] = createFreeDrinksStepsAG_auto_CD(svnRev,svnCheckMode,subID);

[ts_Easy_constDur,ts_Gen_constDur,ts_Easy_varDur,ts_Hard_varDur,ts_Vary_varDur] = createChangeDetectionTrialSteps(svnRev, svnCheckMode, subID);
%%%%%%%%%%% FINALLY make a protocol and put rats on it %%%%%%%%%%%%%%%%%

% here is the protocol
descriptiveString='mouseTraining_ChangeDetection';
pMouseTraining_ChangeDetection = protocol(descriptiveString,{fd_sto,fd_Cen,ts_Easy_constDur,ts_Gen_constDur,ts_Easy_varDur,ts_Hard_varDur,ts_Vary_varDur});
end

