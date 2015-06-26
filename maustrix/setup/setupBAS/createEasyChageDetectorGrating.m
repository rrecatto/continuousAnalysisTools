function ts = createEasyChageDetectorGrating(percentCorrectionTrials, trialManager, performanceCrit, sch, svnRev, svnCheckMode)
% makes a basic, easy drifting grating training step
% correct response = side toward which grating drifts?

% gratings stim manager
pixPerCycs={[32],[32]};
driftfrequencies={[0],[0]};
orientations={-deg2rad([45]),deg2rad([45])};
phases={linspace(0,2*pi,16),linspace(0,2*pi,16)};
phases = {0 ,0}
contrasts={[0.25],[0.25]};
maxDuration={[inf],[inf]};
radii={[Inf],[Inf]};
radiusType = 'hardEdge';
annuli={[0],[0]};
location={[.5 .5],[0.5 0.5]};      % center of mask
waveform= 'sine';     
normalizationMethod='normalizeDiagonal';
mean=0.5;
thresh=.00005;
maxWidth=1024;
maxHeight=780;
scaleFactor=0;
interTrialLuminance=.5;
doCombos = true;
doPostDiscrim = false;

AFCGRAT_HighC = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);

% contrasts={[0.5],[0.5]};
orientations={-deg2rad([44]),deg2rad([44])};

AFCGRAT_LowC = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,radiusType,annuli,location,...
      waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);

%   durationToFlip = 3;
  durationToFlip.type = 'uniform';
  durationToFlip.params = [1 6];
  durationAfterFlip = 4;
contrastChangeDetector = changeDetectorSM(AFCGRAT_HighC,AFCGRAT_LowC,durationToFlip,durationAfterFlip,maxWidth,maxHeight,scaleFactor,interTrialLuminance);  
% training step using other objects as passed in
ts = trainingStep(trialManager, contrastChangeDetector, performanceCrit, sch, svnRev, svnCheckMode);