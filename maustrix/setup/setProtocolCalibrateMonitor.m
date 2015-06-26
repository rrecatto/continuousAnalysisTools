function r = setProtocolCalibrateMonitor(r,subjIDs)

if ~isa(r,'ratrix')
    error('need a ratrix')
end

if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

% soundManager
sm=soundManager({soundClip('correctSound','allOctaves',[400],20000), ...
    soundClip('keepGoingSound','allOctaves',[300],20000), ...
    soundClip('trySomethingElseSound','gaussianWhiteNoise'), ...
    soundClip('wrongSound','tritones',[300 400],20000), ...
    soundClip('trialStartSound','allOctaves',[500],20000)});


rewardSizeULorMS        =50;
requestRewardSizeULorMS = 0;
doAllRequests = 'first';
msPenalty               =1000;
fractionOpenTimeSoundIsOn=1;
fractionPenaltySoundIsOn=1;
scalar=1;
msAirpuff=msPenalty;

constantRewards=constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,doAllRequests,msPenalty,fractionOpenTimeSoundIsOn...
    ,fractionPenaltySoundIsOn,scalar,msAirpuff);

ap = autopilot(0.5,sm,constantRewards);
frequencies =1;
durations = 10;
radii = 4;
annuli = 0;
location = [0.5 0.5];
normalizationMethod = 'normalizeDiagonal';
mean = 0.5;
thresh = 0.005;
numRepeats = 1;
maxWidth                =1024;
maxHeight               =768;
scaleFactor             =[1 1];
interTrialLuminance     =.5;
doCombos = false;

contrasts = 1;
s_c100 = fullField(frequencies,contrasts,durations,radii,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

contrasts = 0.8;
s_c80 = fullField(frequencies,contrasts,durations,radii,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

contrasts = 0.6;
s_c60 = fullField(frequencies,contrasts,durations,radii,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

contrasts = 0.5;
s_c50 = fullField(frequencies,contrasts,durations,radii,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

contrasts = 0.25;
s_c25 = fullField(frequencies,contrasts,durations,radii,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

contrasts = 0.125;
s_c12 = fullField(frequencies,contrasts,durations,radii,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

svnRev={'svn://132.239.158.177/projects/ratrix/trunk'};
svnCheckMode = 'session';

ts1 = trainingStep(ap, s_c100, numTrialsDoneCriterion(3), noTimeOff(), svnRev,svnCheckMode);   %stochastic free drinks
ts2 = trainingStep(ap, s_c80, numTrialsDoneCriterion(3), noTimeOff(), svnRev,svnCheckMode);   %stochastic free drinks
ts3 = trainingStep(ap, s_c60, numTrialsDoneCriterion(3), noTimeOff(), svnRev,svnCheckMode);   %stochastic free drinks
ts4 = trainingStep(ap, s_c50, numTrialsDoneCriterion(3), noTimeOff(), svnRev,svnCheckMode);   %stochastic free drinks
ts5 = trainingStep(ap, s_c25, numTrialsDoneCriterion(3), noTimeOff(), svnRev,svnCheckMode);   %stochastic free drinks
ts6 = trainingStep(ap, s_c12, numTrialsDoneCriterion(3), noTimeOff(), svnRev,svnCheckMode);   %stochastic free drinks

p=protocol('gabor test',{ts1, ts2, ts3,ts4,ts5,ts6});
stepNum=1;

for i=1:length(subjIDs),
    subj=getSubjectFromID(r,subjIDs{i});
    [subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'call to setProtocolDEMO','bs');
end

end