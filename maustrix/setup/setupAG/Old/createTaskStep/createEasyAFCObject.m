function ts = createEasyAFCObject(percentCorrectionTrials, trialManager, performanceCrit, sch, svnRev, svnCheckMode)
% makes a basic, easy AFCOBJECT training step

shapes = {{'square'},{'circle'}};
sizes = {0.2,0.2};
orientations = {0,0};
contrasts = {1,1};
maxDurations = {inf,inf};
locations = {[0.5 0.5;0.5 0.4;0.5 0.6],[0.5 0.5]};
normalizationMethod = 'none';
backgroundLuminance = {0,0};
invertedContrast = {false;false};
drawMode = {'expert','expert'};
objectType = {{'block'},{'block'}};
mask = {[],[]};
thresh = 0.005;
maxWidth = 1024;
maxHeight = 768;
scaleFactor = 0;
interTrialLuminance = 0.5;
doCombos = true;
doPostDiscrim = false;

AFCOBJ = afcObjects(shapes,sizes,orientations,contrasts,maxDurations,locations,normalizationMethod,backgroundLuminance,invertedContrast,drawMode,objectType,...
    mask,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,doPostDiscrim);
ts = trainingStep(trialManager, AFCOBJ, performanceCrit, sch, svnRev, svnCheckMode);
