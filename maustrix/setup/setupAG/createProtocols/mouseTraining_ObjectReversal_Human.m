function r = mouseTraining_ObjectReversal_Human(r,subjIDs)
%% This protocol enables the following tasks:
% 1. object recognition 1: go to the object
% 2. object recognition 2: go away from object

% details for each subject are internally modifiable. 
% define subjects

ValidTestSubject={'demo1','999'};

% define ratrix version to use
svnRev={''};
svnCheckMode='none';

for i=1:length(subjIDs)
    % create the trial steps

    [ts_obj1 ts_obj2] = createObjectTrialSteps_Reversal_Human(svnRev,svnCheckMode);
    
    %%%%%%%%%%% FINALLY make a protocol and put rats on it %%%%%%%%%%%%%%%%%
    
    % here is the protocol
    descriptiveString='mouseTraining_ObjectReversal_Human';
    loopedProtocol = true;
    pMouseTraining_ObjectReversal = protocol(descriptiveString,{ts_obj1,ts_obj2},loopedProtocol);

    
    %%%%%%%%%%%%
    thisIsANewProtocol=1; % typically 1
    thisIsANewTrainingStep=1; % typically 1
    thisIsANewStepNum=1;  %  typically 1
    
    if ~ismember(subjIDs{i},ValidTestSubject)
        [correctBox, whichBox] = correctBoxForSubject(subjIDs{i});
        if ~correctBox
            error('you are putting this subject in an unauthorized box. use the correct box num %d',whichBox);
        end
    end
    subjObj = getSubjectFromID(r,subjIDs{i});
    
    [subjObj, r]=setProtocolAndStep(subjObj,pMouseTraining_ObjectReversal,...
        thisIsANewProtocol,thisIsANewTrainingStep,thisIsANewStepNum,1,...
        r, descriptiveString,'bas');

end
end