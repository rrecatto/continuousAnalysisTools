function pMouseTraining_Reversal = mouseTraining_ObjectReversal_auto(subID)
%% This protocol enables the following tasks:
% 1. object recognition 1: go to the object
% 2. object recognition 2: go away from object

% details for each subject are internally modifiable. 
% define subjects

% define ratrix version to use
svnRev={''};
svnCheckMode='none';

[ts_obj1, ts_obj2] = createObjectTrialSteps_Reversal(svnRev,svnCheckMode,subID);

% here is the protocol
descriptiveString='mouseTraining_ObjectReversal';
loopedProtocol = true;
pMouseTraining_Reversal = protocol(descriptiveString,{ts_obj1,ts_obj2},loopedProtocol);
end