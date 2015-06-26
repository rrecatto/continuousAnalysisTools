function r = setProtocol_mouseTraining_AG_11242012(r,subjIDs)
%% This protocol enables the following tasks:
% 1. stochastic free drinks
% 2. earned free drinks
% 3. object recognition 1
% 4. 45 and -45 degrees orientation task
% 5. 45 and -45 degrees spatial freqency sweep
% 6. 45 and -45 degrees temporal frequency sweep
% 7. 45 and -45 degrees contrasts sweep
% 8. 45,35,25,15,5,0,-5,-15,-25,-35,-45 orientation sweep

% 9. -45 and 45 degrees orientation task REVERSAL
% 10. -45 and 45 degrees spatial freqency sweep REVERSAL
% 11. -45 and 45 degrees temporal frequency sweep REVERSAL
% 12. -45 and 45 degrees contrasts sweep REVERSAL
% 13. -45,-35,-25,-15,-5,0,5,15,25,35,45 orientation sweep REVERSAL

% 14. -45 and 45 degrees orientation task HALFRAD
% 15. -45 and 45 degrees spatial freqency sweep HALFRAD
% 16. -45 and 45 degrees temporal frequency sweep HALFRAD
% 17. -45 and 45 degrees contrasts sweep HALFRAD
% 18. -45,-35,-25,-15,-5,0,5,15,25,35,45 orientation sweep HALFRAD

% 19. -45 and 45 degrees orientation task QUATRAD
% 20. -45 and 45 degrees spatial freqency sweep QUATRAD
% 21. -45 and 45 degrees temporal frequency sweep QUATRAD
% 22. -45 and 45 degrees contrasts sweep QUATRAD
% 23. -45,-35,-25,-15,-5,0,5,15,25,35,45 orientation sweep QUATRAD

% 24. -45 and 45 degrees orientation task EIGHTSRAD
% 25. -45 and 45 degrees spatial freqency sweep EIGHTSRAD
% 26. -45 and 45 degrees temporal frequency sweep EIGHTSRAD
% 27. -45 and 45 degrees contrasts sweep EIGHTSRAD
% 28. -45,-35,-25,-15,-5,0,5,15,25,35,45 orientation sweep EIGHTSRAD

% details for each subject are internally modifiable. 
% define subjects

MouseTrainingCohort_AG={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','31','32','33','34'};
ValidTestSubject={'demo1','999'};

% define ratrix version to use
svnRev={'svn://132.239.158.177/projects/bsriram/Ratrix/branches/multiTrodeStable'};
svnCheckMode='session';

for i=1:length(subjIDs)
    % create the trial steps
    [fd_sto fd] = createFreeDrinksStepsAG(svnRev,svnCheckMode, subjIDs{i});
    
    [ts_obj1] = createObjectTrialSteps(svnRev,svnCheckMode,subjIDs{i});

    
    [or_optim or_sfSweep or_tfSweep or_ctrSweep or_orSweep] = createOrientationSteps(svnRev,svnCheckMode,subjIDs{i});
    [or_optimRev or_sfSweepRev or_tfSweepRev or_ctrSweepRev or_orSweepRev] = createReversalOrientationSteps(svnRev,svnCheckMode,subjIDs{i});
    [or_optimHR or_sfSweepHR or_tfSweepHR or_ctrSweepHR or_orSweepHR] = createOrientationSteps_halfRad(svnRev,svnCheckMode,subjIDs{i});
    [or_optimQR or_sfSweepQR or_tfSweepQR or_ctrSweepQR or_orSweepQR] = createOrientationSteps_quatRad(svnRev,svnCheckMode,subjIDs{i});
    [or_optimER or_sfSweepER or_tfSweepER or_ctrSweepER or_orSweepER] = createOrientationSteps_eighthsRad(svnRev,svnCheckMode,subjIDs{i});
    
    %%%%%%%%%%% FINALLY make a protocol and put rats on it %%%%%%%%%%%%%%%%%
    
    % here is the protocol
    descriptiveString='mouseTraining_AG_11242012';
    pMouseTrainingAG07202012 = protocol(descriptiveString,{fd_sto,fd,or_optim,or_sfSweep,or_tfSweep,or_ctrSweep,or_orSweep,ts_obj1,...
        or_optimRev,or_sfSweepRev,or_tfSweepRev,or_ctrSweepRev,or_orSweepRev,...
        or_optimHR,or_sfSweepHR,or_tfSweepHR,or_ctrSweepHR,or_orSweepHR,...
        or_optimQR,or_sfSweepQR,or_tfSweepQR,or_ctrSweepQR,or_orSweepQR,...
        or_optimER,or_sfSweepER,or_tfSweepER,or_ctrSweepER,or_orSweepER});

    
    %%%%%%%%%%%%
    thisIsANewProtocol=1; % typically 1
    thisIsANewTrainingStep=1; % typically 1
    thisIsANewStepNum=1;  %  typically 1
    
    stepNum = getStepNum(subjIDs{i});
    
    subjObj = getSubjectFromID(r,subjIDs{i});
    
    if ismember(subjIDs{i},MouseTrainingCohort_AG) % define ID list at top of this file
        [subjObj r]=setProtocolAndStep(subjObj,pMouseTrainingAG07202012,...
            thisIsANewProtocol,thisIsANewTrainingStep,thisIsANewStepNum,stepNum,...
            r, descriptiveString,'bas');
    elseif ismember(subjIDs{i}, ValidTestSubject),% for testing
        
        [subjObj r]=setProtocolAndStep(subjObj,pMouseTrainingAG07202012,...
            thisIsANewProtocol,thisIsANewTrainingStep,thisIsANewStepNum,stepNum,... % set demoStep at top
            r, descriptiveString,'bas');
    else
        error('unexpected ID')
    end
end
end

function step = getStepNum(id)
switch id
    case '1'
        step = 4;
    case '2'
        step = 4;
    case '3'
        step = 4;
    case '4'
        step = 4;
    case '5'
        step = 4;
    case '6'
        step = 4;
    case '7'
        step = 4;
    case '8'
        step = 4;
    case '9'
        step = 4;
    case '10'
        step = 4;
    case '11'
        step = 4;
    case '12'
        step = 4;
    case '13'
        step = 4;
    case '14'
        step = 4;
    case '15'
        step = 4;
    case '16'
        step = 4;
    case '17'
        step = 4;
    case '18'
        step = 8;
    case '19'
        step = 8;
    case '20'
        step = 8;
    case '21'
        step = 8;
    case '22'
        step = 8;
    case '23'
        step = 8;
    case '24'
        step = 4;
    case '25'
        step = 4;
    case 'ACM1'
        step = 1;
    case 'ACM2'
        step = 1;
    case 'ACM3'
        step = 1;
    case 'ACM4'
        step = 1;
    case 'ACM5'
        step = 1;
    case 'demo1'
        step = 7;
    case '999'
        step = 1;
    case '31'
        step = 1;
    case '32'
        step = 1;
    case '33'
        step = 1;
    case '34'
        step = 1;
     case '26'
        step = 2;
      case '28'
        step = 2;   
    otherwise
        error('unsupported mouse id. are you sure that the mouse is supposed to be here?')
end

end
