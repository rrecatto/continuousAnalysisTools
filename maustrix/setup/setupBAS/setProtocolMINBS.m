function r = setProtocolMINBS(r,subjIDs)
% NOTE this setProtocol file assumes that your subjID has already been
% added to the ratrix. See the history file associated with the
% experiment/rat.

% this works for running on the ratrix downstairs or standalone
logPath=fullfile(fileparts(fileparts(getRatrixPath)),'ratrix\setup\setupPR',filesep);

% define ratrix version to use
svnRev={};
svnCheckMode='none';

 

%% Eyetrack
eyetrack=false;
if eyetrack
    alpha=12; %deg above...really?
    beta=0;   %deg to side... really?
    settingMethod='none';  % will run with these defaults without consulting user, else 'guiPrompt'
    eyeTracker=geometricTracker('cr-p', 2, 3, alpha, beta, int16([1280,1024]), [42,28], int16([maxWidth,maxHeight]), [400,290], 300, -55, 0, 45, 0,settingMethod,10000);
else
    eyeTracker=[];
end
eyeController=[];


%% DataNet
dataNetOn=false;
if dataNetOn
    ai_parameters.numChans=3;
    ai_parameters.sampRate=40000;
    ai_parameters.inputRanges=repmat([-1 6],ai_parameters.numChans,1);
    dn=datanet('stim','localhost','132.239.158.169','\\132.239.158.169\datanet_storage',ai_parameters)
else
    dn=[];
end

%% Create Sound Manager
sm=makeStandardSoundManager();

%% Reward Manager
rewardSizeULorMS          =50;
requestRewardSizeULorMS   =10;
requestMode               ='first';
msPenalty                 =1000;
fractionOpenTimeSoundIsOn =1;
fractionPenaltySoundIsOn  =1;
scalar                    =1;
msAirpuff                 =msPenalty;

constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,requestMode,msPenalty,fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msAirpuff);

dropFrames=false;
percentCorrectionTrials = 0.5;

tm=nAFC(sm,percentCorrectionTrials,constantRewards,eyeController,{'off'},dropFrames,'ptb','center');

% ts_AFC = createEasyAFCGrating(percentCorrectionTrials,tm, easy_pc, sch, svnRev, svnCheckMode);
% ts_ctrChDetect = createEasyChageDetectorGrating(percentCorrectionTrials,tm, pc, sch, svnRev, svnCheckMode);
% ts_CenterSurr = createEasyAFCGratingWithOrientedSurround(svnRev, svnCheckMode, subjIDs);
% here is the protocol
ts_AFCOBJ = createEasyAFCCoherentDots(tm, repeatIndefinitely(),noTimeOff(), svnRev, svnCheckMode);

descriptiveString='pElementaryVision100915'; % use this in protocol call and also setProtocolAndStep and logfile

pElementaryVision100915 = protocol(descriptiveString,...
    {ts_AFCOBJ});
stepNum = 1;
%%%%%%%%%%%%
for i=1:length(subjIDs)
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,pElementaryVision100915,true,false,true,stepNum,r,'call to setProtocolMIN','bs');
end

