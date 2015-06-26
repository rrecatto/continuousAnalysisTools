function ts = createEasyAFCGrating(percentCorrectionTrials, trialManager, performanceCrit, sch, svnRev, svnCheckMode);  % EK added percetCorrentionTrials
% makes a basic, easy drifting grating training step
% correct response = side toward which grating drifts?

% gratings stim manager
pixPerCycs={[256,128],[256,128]};
driftfrequencies={[2],[2]};
orientations={-deg2rad([5,45,185,225]),deg2rad([5,45,185,225])};
phases={[0],[0]};
contrasts={[1],[1]};
maxDuration={[inf],[inf]};
radii={[2],[2]};
radiusType = 'hardEdge';
annuli={[0],[0]};
location={[.5 .5],[0.5 0.5]};      % center of mask
waveform= 'sine';     
normalizationMethod='normalizeDiagonal';
mean=0.5;
thresh=.00005;
maxWidth=1440;
maxHeight=900;
scaleFactor=0;
interTrialLuminance=.5;
doCombos = true;

AFCGRAT = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos);

% training step using other objects as passed in
ts = trainingStep(trialManager, AFCGRAT, performanceCrit, sch, svnRev, svnCheckMode);