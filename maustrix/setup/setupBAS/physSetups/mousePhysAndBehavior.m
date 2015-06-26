function r = mousePhysAndBehavior_07162013(r,subjIDs,otherParams)
if ~isa(r,'ratrix')
    error('need a ratrix')
end
if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

if ~exist('otherParams','var') || isempty(otherParams)
    otherParams.stepNum = 1;
end

[a,b] = getMACaddress;
switch b
    case 'BC305BD38BFB'
        maxWidth=1920;maxHeight=1080;
    otherwise
        maxWidth=1920;maxHeight=1080;
end


%% setup basic LED Params
LEDParams.active = true;
LEDParams.fractionMode = 'byTrial';
LEDParams.fraction = 0.5;
LEDParams.LEDDriverMode = 'pulsedAll';

%% temporal stimuli
% full-field temporal
LEDParams.active = false;
frequencies=2.^(-1:4);phases=[0];
contrasts=[1]; durations=[3];
radius=5; annuli=0;
location=[.5 .5];
normalizationMethod='normalizeDiagonal';
mean=0.5; thresh=.00005; numRepeats=3;
scaleFactor=0;interTrialLuminance=.5;
doCombos={true,'twister','clock'};

changeableAnnulusCenter = false;
changeableRadiusCenter = false;
TRF_LEDOFF= fullField(frequencies,contrasts,durations,radius,annuli,location,normalizationMethod,mean,thresh,numRepeats,...
       maxWidth,maxHeight,scaleFactor,interTrialLuminance,doCombos,changeableAnnulusCenter,changeableRadiusCenter,LEDParams);

   
%% spatial noise stimuli
LEDParams.active = false;

gray=0.5; mean=gray; std100=gray; std66=gray*0.66; std33 = gray*0.33; std10 = gray*0.10;
searchSubspace=[1];background=gray;
method='texOnPartOfScreen';
changeable=false;
scaleFactor=0;interTrialLuminance=.5;
stimLocation=[0,0,maxWidth,maxHeight];
stixelSize = [64 64];
stimDurationSecs = 30;frameDurationSecs = 0.01667;
numFrames = {stimDurationSecs,frameDurationSecs};
blankDuration = 1; % seconds
spatNoise100 = whiteNoise({'gaussian',gray,std100},{background,blankDuration},method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);
spatNoise66 = whiteNoise({'gaussian',gray,std66},{background,blankDuration},method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);
spatNoise33 = whiteNoise({'gaussian',gray,std33},{background,blankDuration},method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);
spatNoise10 = whiteNoise({'gaussian',gray,std10},{background,blankDuration},method,stimLocation,stixelSize,searchSubspace,numFrames,changeable,maxWidth,maxHeight,scaleFactor,interTrialLuminance,LEDParams);

end