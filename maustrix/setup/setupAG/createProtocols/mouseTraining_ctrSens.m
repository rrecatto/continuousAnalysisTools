function pMouseTraining_ctrSens = mouseTraining_ctrSens(subID)
%% This protocol enables the following tasks:
% 1. stochastic free drinks
% 2. earned free drinks
% 3. object recognition 1
% 4. 45 and -45 degrees orientation task

% details for each subject are internally modifiable. 
% define subjects

ValidTestSubject={'demo1','999'};

% define ratrix version to use
svnRev={''};
svnCheckMode='none';
or_ctrXsfSweep = createSpecialOrientationSteps_auto(svnRev,svnCheckMode,subID);

%%%%%%%%%%% FINALLY make a protocol and put rats on it %%%%%%%%%%%%%%%%%

% here is the protocol
descriptiveString='mouseTraining_ctrSens';
pMouseTraining_ctrSens = protocol(descriptiveString,{or_ctrXsfSweep});
end

