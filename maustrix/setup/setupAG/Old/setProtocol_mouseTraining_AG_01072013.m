function r = setProtocol_mouseTraining_AG_01072013(r,subjIDs)
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

% 29. -45 and 45 orientations with oriented surrounds task - contrast sweep
% 30. -45 and 45 orientations with oriented surrounds task - low contrasts
% 31. -45 and 45 orientations with oriented surrounds task - medium contrasts
% 32. -45 and 45 orientations with oriented surrounds task - high contrasts
% 33. -45 and 45 orientations with oriented surrounds task - full contrasts

% 34. Varied contrast object task

% details for each subject are internally modifiable. 
% define subjects

ValidTestSubject={'demo1','999'};

% define ratrix version to use
svnRev={''};
svnCheckMode='none';

for i=1:length(subjIDs)
    % create the trial steps
    [fd_sto, fd] = createFreeDrinksStepsAG(svnRev,svnCheckMode, subjIDs{i});
    
    [ts_obj1,ts_obj2] = createObjectTrialSteps(svnRev,svnCheckMode,subjIDs{i});

    [ts_Moptim, ts_MvelSweep, ts_McohSweep, ts_Mdot1, ts_Mdot2, ts_Mdot3] = createMotionSteps(svnRev,svnCheckMode,subjIDs{i})
    
    
    [or_optim, or_sfSweep, or_tfSweep, or_ctrSweep, or_orSweep] = createOrientationSteps(svnRev,svnCheckMode,subjIDs{i});
    [or_optimRev, or_sfSweepRev, or_tfSweepRev, or_ctrSweepRev, or_orSweepRev] = createReversalOrientationSteps(svnRev,svnCheckMode,subjIDs{i});
    [or_optimHR, or_sfSweepHR, or_tfSweepHR, or_ctrSweepHR, or_orSweepHR] = createOrientationSteps_halfRad(svnRev,svnCheckMode,subjIDs{i});
    [or_optimQR, or_sfSweepQR, or_tfSweepQR, or_ctrSweepQR, or_orSweepQR] = createOrientationSteps_quatRad(svnRev,svnCheckMode,subjIDs{i});
    [or_optimER, or_sfSweepER, or_tfSweepER, or_ctrSweepER, or_orSweepER] = createOrientationSteps_eighthsRad(svnRev,svnCheckMode,subjIDs{i});
    [orwos_SurrCtrSweep, orwos_SurrLowCtr, orwos_SurrMedCtr, orwos_SurrHighCtr, orwos_SurrFullCtr] = createOrientationWithOrientedSurroundSteps(svnRev,svnCheckMode,subjIDs{i});
    [or_ctrXsfSweep] = createSpecialOrientationSteps(svnRev,svnCheckMode,subjIDs{i});
    %%%%%%%%%%% FINALLY make a protocol and put rats on it %%%%%%%%%%%%%%%%%
    
    % here is the protocol
    descriptiveString='mouseTraining_AG_01072013';
    pMouseTrainingAG07202012 = protocol(descriptiveString,{fd_sto,fd, ...
        ts_Moptim, ts_MvelSweep, ts_McohSweep, ts_Mdot1, ts_Mdot2, ts_Mdot3, ...
        or_optim,or_sfSweep,or_tfSweep,or_ctrSweep,or_orSweep,ts_obj1,...
        or_optimRev,or_sfSweepRev,or_tfSweepRev,or_ctrSweepRev,or_orSweepRev,...
        or_optimHR,or_sfSweepHR,or_tfSweepHR,or_ctrSweepHR,or_orSweepHR,...
        or_optimQR,or_sfSweepQR,or_tfSweepQR,or_ctrSweepQR,or_orSweepQR,...
        or_optimER,or_sfSweepER,or_tfSweepER,or_ctrSweepER,or_orSweepER,...
        orwos_SurrCtrSweep,orwos_SurrLowCtr,orwos_SurrMedCtr,orwos_SurrHighCtr,orwos_SurrFullCtr,...
        ts_obj2,or_ctrXsfSweep});

    
    %%%%%%%%%%%%
    thisIsANewProtocol=1; % typically 1
    thisIsANewTrainingStep=1; % typically 1
    thisIsANewStepNum=1;  %  typically 1
    
    stepNum = getStepNum(subjIDs{i});
    if ~ismember(subjIDs{i},ValidTestSubject)
        [correctBox, whichBox] = correctBoxForSubject(subjIDs{i});
        if ~correctBox
            error('you are putting this subject in an unauthorized box. use the correct box num %d',whichBox);
        end
    end
    subjObj = getSubjectFromID(r,subjIDs{i});
    
    [subjObj, r]=setProtocolAndStep(subjObj,pMouseTrainingAG07202012,...
        thisIsANewProtocol,thisIsANewTrainingStep,thisIsANewStepNum,stepNum,...
        r, descriptiveString,'bas');

end
end

function step = getStepNum(id)
switch id
    case '26' % WT
        step = 10;
        error('not being run'); % changed on 6/24
        % changed from step 8 on 6/3/2013
        % changed from rev on 6/17
    case '37' % SOM-cre
        step = 4; 
        % changed from step 4 6/4
        % changed to step 8 in prep for lesioning. 6/18
        % couple of days of orientation data week of 6/24
        % changed to step 8 for week of 7/8
        % back to optimal for week of 7/15
        error('not being run');
    case '38' % SOM-cre
        step = 4; 
        % changed from step 4 6/4
        % changed to step 8 in prep for lesioning. 6/18
        % couple of days of orientation data week of 6/24
        % changed to step 8 for week of 7/8
        % back to optimal for week of 7/15
        error('not being run');
    case '40' % SOM-cre
        step = 8; 
        % changed from step 3 on 6/3/2013; actually 40 has a lot of data on step 8. It will continue to run on step 3 for a week.
        % getting data on step 4 for wek of 6/24
        % moved to step 8 week of 7/1
        error('not being run');
    case '41' % SOM-cre
        step = 4;
        error('not being run'); % decided on 6/4/2013
    case '45' % WT
        step = 7; 
        % changed from step 4 6/4
        % changed to step 8 in prep for lesioning. 6/18
        % couple of days of orientation data week of 6/24
        % 1 week of step 8 week of 7/15
        % varied contrast week starting 1/8
        % varied orientation week of 12/8
    case '47' % WT
        step = 8;
        % getting more images trials for week of 6/17
        % step 4 for week of 6/24
        % moved to step 8 week of 7/1
        error('not being run');
    case '48' % WT
        step = 4; % changed from step 7 on 6/3/2013
        error('not being run'); % finished week of 6/17
    case '50' % WT
        step = 7; 
        % changed from step 4 6/4
        % changed to step 8 in prep for lesioning. 6/18
        % couple of days of orientation data week of 6/24
        % 1 week of step 8 week of 7/15
        % varied contrast week starting 1/8
        % varied orientation week of 12/8
    case '53' % CART-cre
        step = 8;
        % obtaining more object task trials week of 6/17
        % step 4 for week of 6/24
        % moved to step 8 week of 7/1
        error('not being run');
    case '56' % CART-cre
        step = 4;
        % knows step 3 will go to varied contrast week of 6/17
        % performed ~ 750 trials onstep 6 now on step 7 6/24   
        % moved to step 4 week of 7/1
        error('not being run');
    case '59' % CHAT-cre
        step = 7;
        % knows step 3. goes to step 6 6/24
        % moved to step 7 week of 7/1
        error('not being run');
    case '60' % PV-cre
        step = 6; 
        % lots of autograduations ! now hard set to 3. 6/5
        % changed from step 3 to step 6 on 6/17
        % varied s.f. week of 7/15
        % small aperture starting 7/31
        % increased aperture size 8/6
        % varied contrast with aperture 8/12
        % varied orientation starting 9/20
        % back to step 19 11/19
        % back after TRN surgery. doing go to stim 12/8
        % moving to orientation task this week 12/16
        % moved to varied contrast on orientation 2/11
        % moved to object task post sc lesion 4/14
        % moved to optimal orientation task 4/28
        % moved to varied contrast 5/13
    case '61' % PV-cre
        step = 6;
        % back from the injections. going to run 8/19
        % performed admirably at step 3 for a day. will start on step 19 9/10
        % back to step 8 11/19
        % sent to step 34. 11/25
        % doing step 3 12/7 to be used for var contrast
        % going to var contrast for week of 12/8
        % moved to object task post sc lesion 4/14
        % cuople of days of varied contrast on object task 4/20
        % moved to optimal orientation task 4/28
        % moved to varied contrast 5/13
    case '62' % PV-cre
        step = 19; 
        % graduated from step 8 to step 3 for 6/6
        % changed from step 3 to step 6 on 6/17
        % varied s.f. week of 7/15
        % small aperture starting 7/31
        % increased aperture size 8/6
        % varied contrast with aperture 8/12
        % back to step 19 11/19
    case '63' % PV-cre
        step = 6; 
        % changed 6/4
        % changed from step 3 to step 6 on 6/17
        % varied s.f. week of 7/15
        % small aperture starting 7/31
        % increased aperture size 8/6
        % varied contrast with aperture 8/12
        % varied orientation with aperture 9/10
        % changed back to varied contrast with aperture starting 10/9
        % back to step 8 11/19
        % sent to step 34. 11/25
        % doing step 3 12/7 to be used for var contrast
        % going to var contrast for week of 12/8
    case '64' % PV-cre
        step = 3; 
        % changed to step 3 for 6/10 from step 8
        % changed from step 3 to step 6 on 6/17
        % varied s.f. week of 7/15
        % small aperture starting 7/31
        % increased aperture size 8/6
        % varied contrast with aperture 8/12
        % varied orientation with aperture 9/10
        % back to step 19 11/19
        % back after TRN surgery. doing go to stim 12/8
        % moving to orientation task this week 12/16
    case '65' % PV-cre
        step = 6; 
        % changed 6/4
        % changed from step 3 to step 6 on 6/17
        % varied s.f. week of 7/15
        % small aperture starting 7/31
        % increased aperture size 8/6
        % varied contrast with aperture 8/12
        % varied orientation with aperture 9/10
        % changed back to varie dcontrast with aperture starting 10/9
        % back to step 8 11/19
        % sent to step 34. 11/25
        % doing step 3 12/7 to be used for var contrast
        % going to var contrast for week of 12/8
        % moved to object task post sc lesion 4/14
        % cuople of days of varied contrast on object task 4/20
        % moved to optimal orientation task
        % moved to varied contrast 5/13
    case '66' % PV-cre
        step = 6; 
        % changed protocol for 6/10
        % changed from step 3 to step 6 on 6/17
        % varied s.f. week of 7/15
        % small aperture starting 7/31
        % increased aperture size 8/6
        % varied contrast with aperture 8/12
        % varied orientation with aperture 9/10
        % back to step 19 11/19
        % back after TRN surgery. doing go to stim 12/8
        % moving to orientation task this week 12/16
        % moving to varied contrast task - 2/10
        % moved to object task post sc lesion 4/14
        % cuople of days of varied contrast on object task 4/20
        % moved to optimal orientation task
        % moved to varied contrast 5/13
    case '67' % PV-cre
        step = 22; 
        % graduated from 8 on 6/5
        % changed from step 3 to step 6 on 6/17
        % varied s.f. week of 7/15
        % small aperture starting 7/31
        error('died on 8/5');
    case '68' % PV-cre
        step = 3;
        error('not being run'); % not doing enough trials, 6/24
    case '69' % PV-cre
        step = 6; 
        % changed 6/4
        % changed from step 3 to step 6 on 6/17
        % moved to varied orientation 
        % varied s.f. week of 7/15
        % small aperture starting 7/31
        % increased aperture size 8/6
        % varied contrast with aperture 8/12
        % varied orientation with aperture 9/10 
        % changed back to varied contrast with aperture starting 10/9
        % back to step 8 11/19
        % sent to step 34. 11/25
        % doing step 3 12/7 to be used for var contrast
        % going to var contrast for week of 12/8
    case '70' % PV-cre
        step = 3;
        error('not being run'); % poor performer and not doing enough trials 6/24
    case '79' % SOM-cre
        step = 3;
        % graduated to step 3 on 6/19
    case '84' % SOM-cre
        step = 3;
        error('not being run'); % as of 6/22
    case '86' % SOM-cre
        step = 3;
        % back with step 8 on 8/1
        % starting on step 3 for a week with pbs inj.
        % aperture on 8/26
        % not doing well on quat rad. shifting to half rad
        % going back to step 3 :( 12/3
        % okay going to use this mouse for SC lesion
        % varied contrast on the object task
        % step 3 for a while % 1/27
    case '87' % SOM-cre
        step = 14;
        % back with step 8 on 8/1
        % starting on step 3 for a week with pbs inj.
        % aperture on 8/26
        % not doing well on quat rad. shifting to half rad
    case '88' % SOM-cre
        step = 8;
    case '89' % SOM-cre
        step = 8;
    case '90' % SOM-cre
        step = 3;
        error('not being run'); % as of 6/22
    case '91' % SOM-cre
        step = 14;
        % back with step 8 on 8/1
        % starting on step 3 for a week with pbs inj.
        % aperture on 8/26
        % poor performance on quat rad. now go to half-rad
    case '92' % VIP-cre + V1 hM3D
        step = 34;
        % back with step 8 on 8/1
        % starting on step 3 for a week with pbs inj.
        % aperture on 8/26
        % moving to varied contrast with aperture 11/4
        % back to step 19 11/19
        % sent to varied C for manipulation
        % okay step 8 for a couple of days and then back to 34
        % step 34 starting 2/10
    case '93' % VIP-cre
        step = 3;
    case '95' % SOM-cre future V1 hM3D?
        step = 3; 
        % force graduate starting on 6/10
        % graduated to step 3 7/22
        % ok was shit - sent to step 8 for SC lesion?
        % sent to step 34 1/30
        % sent to orientation to see if the num trials is still high
    case '96' % SOM-cre
        step = 3;
        % force graduate starting on 6/10
        % graduated to step 3 7/2
    case '97' % SOM-cre plan to remove
        step = 3;
        % graduated to step 2 6/12
        % graduated to step 8 7/8
        % graduated to step 3 8/19
    case '98' % SOM-cre Future SC lesion
        step = 3;
        % graduated to step 2 6/12
        % graduated to step 8 on 7/2
        % graduate step 3 on 8/26
        % sent to varied C for future sc lesion 12/8
        % going to one day for object task. then onto varied contrast for
        % future lesion
        %sent to varied object contrast 2/4
        % going to varied or for a day to see if number of trials is still
        % high
    case '99' % SOM-cre
        step = 3; 
        % graduated to step 2 6/12
        % graduated to step 8 6/18
        % graduated to step 3 7/8
    case '200' % PV-cre
        step = 6;
        % graduated to step 2 6/12
        % gradauted to step 8 6/14
        % graduated to step 3 7/2
        % back from injections. starting 8/19
        % all good at step 8. Continue at step 3 8/22
        % showing small aperture starting 9/30
        % back to step 8 11/19
        % sent to step 34. 11/25
        % doing step 3 12/7 to be used for var contrast
        % going to var contrast for week of 12/8
        % moved to object task post sc lesion 4/14
        % cuople of days of varied contrast on object task 4/20
        % moved to optimal orientaiton task 4/28
        % moved to varied contrast 5/13
    case '201' % PV-cre
        step = 6;
        % graduated to step 2 6/12
        % gradauted to step 8 6/14
        % graduated to step 3 7/2
        % back from injections. starting 8/19
        % all good at step 8. Continue at step 3 8/22
        % aperture task starting 9/10
        % starting varied contrast with aperture starting 10/9
        % back to step 8 11/19
        % sent to step 34. 11/25
        % doing step 3 12/7 to be used for var contrast
        % going to var contrast for week of 12/8
        % moved to object task post sc lesion 4/14
        % cuople of days of varied contrast on object task 4/20
        % moved to optimal orientaiton task 4/28
        % moved to varied contrast 5/13
    case '202' % PV-cre
        step = 6;
        % graduated to step 2 6/12
        % graduated to step 8 6/21
        % aperture task starting 9/10
        % back to training  start step 8 for week of dec 2
        % varied contrast in the object task 12/15
        % moved to object task post sc lesion 4/14
        % cuople of days of varied contrast on object task 4/20
        % moved to optimal orientaiton task 4/28
        % moved to varied contrast 5/13
    case '203' % PV-cre
        step = 3;
        % graduated to step 2 6/12
        % gradauted to step 8 6/14
        % graduated to step 3 7/2
    case '204' % PV-cre Future SC lesion
        step = 8;
        % graduated to step 2 6/12
        % graduated to step 8 6/18
        % graduated to step 3 7/15
        % graduating to half rad step 14 on 11/26
        % sent to full screen or task 12/8
        % varied contrast for week of 12/15
        % step 8 for a days
    case '205' % VIP-cre Future SC lesion
        step = 4;
        % graduated to step 2 6/26
        % graduated to step 8 7/8
        % graduate to step 3 8/2
        % varied contrast starting 1/27
        % sent to object task 2/4 
        % varied contrast on object starting 2/11
        % testing on orientatino task 3/4
        % varied contrast starting 3/11
        % varied or 3/20
        % varies sf 4/1
    case '206' % VIP-cre plan to remove
        step = 8;
        % graduated to step 2 6/26
        % graduated to step 8 8/6
        % graduated to step 3 8/26
        % going to use animal for SC lesion
        % sent to varied contrast object task for 12/15
        % sucked at or task - but coming back to it 1/27
    case '207' % VIP-cre
        step = 3;
        % graduated to step 2 6/26
        % graduated to step 8 7/2
        % graduated to step 3 7/22
    case '208' % VIP-cre plan to remove
        step = 3;
        % graduated to step 2 6/26
        % graduated to step 8 7/8
        % graduated to step 3 on 8/26
    case '209' % PV-cre Future SC lesion
        step = 4;
        % graduated to step 2 7/8
		% graduated to step 8 7/22
        % graduated to step 3 9/10
        % graduated to step 19 10/24
        % varied contrast orientation week of 12/15
        % go to object task for a couple of days then varied contrast on
        % object 1/27
        % somehow went to step 34. going to step 8 1/30
        % varied contrast on object task starting tomorrow
        % testing on orientatino task 3/4
        % varied contrast starting 3/11
        % varied or 3/20
        % varies sf 4/1
    case '210' % PV-cre Future SC lesion
        step = 6;
        % graduated to step 2 7/8
		% graduated to step 8 7/22
        % graduated to step 3 8/8
        % graduated to step 19 9/10
        % sent to varied C before SC lesion
        % doing step 8 today but moving to step 34 tomorrow 12/15
        % movied to varied object with contrast
        % moved to object task - 4/14
        % cuople of days of varied contrast on object task 4/20
        % moved to optimal orientaiton task 4/28
        % moved to varied contrast 5/13
    case '211' % PV-cre + TRN hM3D
        step = 6;
        % graduated to step 2 7/8
		% graduated to step 8 7/22
        % graduated to step 3 8/12
        % graduated to step 19 9/10
        % back to training  start step 8 for week of dec 2
        % varied contrast in the object task 12/15
        % moved to object task post sc lesion 4/14
        % cuople of days of varied contrast on object task 4/20
        % moved to optimal orientaiton task 4/28
        % moved to varied contrast 5/13
    case '212' % PV-cre + TRN hM3D
        step = 34;
        % graduated to step 2 7/8
		% graduated to step 8 7/22
        % graduated to step 3 9/10
        % graduated to step 19 10/2
        % back to training  start step 8 for week of dec 2
        % varied contrast in the object task 12/15
    case '213' % VGAT-cre future SC lesion
        step = 35;
        % graduated to step 2 7/8
		% graduated to step 8 7/22
        % gradauted to step 3 on 8/22
        % graduating to half-rad step 14 on 11/26 
        % going back to step 3 for a few days
        % sent to varied C. for future SC lesion
        % sent to object today and then onto varied c on obj 1/27
        % sent to varied contrast on object 2/4
        % sent to orientaiion for a few days before sending to ctrXsf
        % ctrxsf 3/20
    case '214' % VGAT-cre
        step = 3;
        % graduated to step 2 7/8
		% graduated to step 8 7/22
        % graduate to step 3 on 8/22
        % going to use this guys for the object task 12/8
        % varied contrast on object task 12/16
        % sending back to orientation hoping he lenrs 2/4
    case '215' % VGAT-cre Future SC lesion
        step = 3;
        % graduated to step 2 7/8
        % graduated to step 8 7/22
        % graduate to step 3 8/25
        % varied orientation starting 12/3
        % varied contrast starting 12/15
        % object for today and then step 34 tomorrow
        % step 34 starting 1/30
        % sending to irientation for a day - seeing potential use for beads
    case '216' % VGAT-cre Future SC Lesion
        step = 35;
        % graduated to step 2 7/8
        % graduated to step 8 7/22
        % graduated to step 3 8/6
        % graduated to step 19 9/10
        % went to varied contrast task 12/3 (sent to step 7 instead)
        % sent mouse to wrong step :( 12/8. now sent to step 6
        % step 8 one day (12/15) but will move to step 34 tomorrow 12/16
        % movied to varied contrast with object 12/16
        % sent to orientaiion for a few days before sending to ctrXsf
        % sfxctr 3/20
    case '217' % PV-cre
        step = 8;
        % graduated to step 8 11/24
        % not doing enough trials - sending back to step 2 1/27
        % okay back to step 8 - 1/30
    case '218' % PV-cre
        step = 3;
        % graduated to step 8 11/24
        % graduated to step 3 1/27
    case '219' % PV-cre
        step = 2;
        % graduated to step 8 11/24
        % not doing enough trials -sending back tp step 2
    case '220' % PV-cre
        step = 35; 
        % graduated to step 8 11/24
        % graduated to step 3 1/24
        % contrast sf sweep 3/11
    case '221' % VGAT-cre
        step = 35;
        % graduated to step 8 11/24
        % graduated to step 3 1/27
        % contrast sf sweep 3/11
    case '222' % VGAT-cre
        step = 3;
        % graduated to step 8 11/24
        % graduate to step 3 1/27
    case '223' % VGAT-cre
        step = 3;
        % graduated to step 2 12/3
        % graduated to object task 12/15
        % graduated to orientation 1/27
    case '224' % VGAT-cre
        step = 8;
        % graduated to step 2 12/3
        % graduated to object task 12/15
    case '225' % PV-cre
        step = 35;
        % graduated to object task 12/15
        % graduated to orientation 1/27
        % sfxctr 3/20
    case '226' % PV-cre
        step = 35;
        % graduated to step 2 12/3
        % graduated to step 8 1/14
        % graduated to step 3 2/4
        % sf x ctr 3/20
    case '227' % PV-cre
        step = 3;
        % graduated to step 8 1/14
        % graduate to step 3 2/14
    case '228'
        step = 8;
        % started 2/2
        % gradauted to step 2 2/4
        % graduated to step 8 for 2/9
        % graduated to step 8 2/11
        % sent back to step 2 because of not rials - 3/3
        % ok trying step 8 again 3/11
    case '229'
        step = 8;
        % started 2/2
        % gradauted to step 2 2/4
        % graduated to step 8 2/10
        % sent back to step 2 - not doing enough trials 3/3
        % sent to step 8 4/20
    case '230'
        step = 3;
        % started 2/2
        % gradauted to step 2 2/4
        % graduate to step 8 2/10
        % sent back to step 2 - not doing enough trials 3/3
        % okay back to 8 3/11
    case '231'
        step = 3;
        % started 2/2
        % gradauted to step 2 2/4
        % graduate to step 8 2/11
        % graduate to tep 3 2/14
    case '232'
        step = 8;
        % started 2/2
        % gradauted to step 2 2/4
        % graduated to step 8 2/14
        % getting back to step 2 as not doing enough trials 3/11
        % back to step 8 3/20
    case '233'
        step = 1;
        % started 2/4
        % graduated to step 2 2/9
        % not doing enough trials.getting back to step 1 2/14 pStosub=0.001
    case '234'
        step = 8;
        % started 2/4
        % graduated to step 2 2/9
        % graduate to step 8 2/14 (look to see if subject performs plenty
        % of trials
    case '235'
        step = 8;
        % started 2/17
        %graduated to step 2 2/20
        % graduate to step 8 3/11
    case '236'
        step = 8;
        % started 2/17
        %graduated to step 2 2/20
        % sending to step 8 3/11
    case '999'
        step = 3;
    otherwise
        error('unsupported mouse id. are you sure that the mouse is supposed to be here?')
end
end

function [correctBox, whichBox] = correctBoxForSubject(subjID)
Box1Subjects = {'223','225'}; % 87 found dead 11/27, '224' f.d.
Box2Subjects = {'216','220','221'}; % 60 gone for inj,'64' sacced
Box3Subjects = {'213','214','227'}; % 91 sacced 11/27,'212' f.d.
Box4Subjects = {'226','228','232'}; % '204' sacced, '63' sacced
Box5Subjects = {'215','218','222'}; % '69' f.d., '233' f.d.
Box6Subjects = {}; %'219' f.d., '217' removed due to low trial numbers
Subjects = {Box1Subjects,Box2Subjects,Box3Subjects,Box4Subjects,Box5Subjects,Box6Subjects};
currSubj = {subjID,subjID,subjID,subjID,subjID,subjID};
whichBox = find(cellfun(@ismember,currSubj,Subjects));
[junk, mac] = getMACaddress();
correctBox = false;
switch mac
    case 'A41F7278B4DE' %gLab-Behavior1
        if whichBox==1
            correctBox = true;
        end
    case 'A41F729213E2' %gLab-Behavior2
        if whichBox==2
            correctBox = true;
        end
    case 'A41F726EC11C' %gLab-Behavior3
        if whichBox==3
            correctBox = true;
        end
    case '7845C4256F4C' %gLab-Behavior4
        if whichBox==4
            correctBox = true;
        end
    case '7845C42558DF' %gLab-Behavior5
        if whichBox==5
            correctBox = true;
        end
    case 'A41F729211B1' %gLab-Behavior6
        if whichBox==6
            correctBox = true;
        end
end
end
