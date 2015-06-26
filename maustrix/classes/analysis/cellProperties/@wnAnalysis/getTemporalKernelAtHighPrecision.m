function [sta stv numSpikes] = getTemporalKernelAtHighPrecision(s,params)

if isempty(s)
    sta = NaN;
    stv = NaN;
    numSpikes = NaN;
    return;
end
% setup the required variables
trialRange = minmax(makerow(s.trials));
trialMask = setdiff(min(s.trials):max(s.trials),s.trials);

subjectID = s.subject;
channels = {getChannels(s)};
thrV = [NaN NaN NaN];
cellBoundary = {'trialRange',trialRange,'trialMask',trialMask};
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
analysisMode = 'onlyAnalyze'; % most important
forceNoInspect = true;
intelligentUpdate = false;
addCurrentAnalysis = false;

switch params.mode
    case 'center'
        pixel = s.relevantIndex;
        pixel = pixel(1:2);
    case 'input'
        pixel = params.pixel;
end
if ~all(size(pixel)==[1 2])
    pixel
    error('need to input the pixel as a 1X2 vector');
end
if isfield(params,'precisionInMS')
    precisionInMS = params.precisionInMS;
else
    precisionInMS = 1;
end

analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
        'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
        'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis,'milliSecondPrecision',pixel,'precisionInMS',precisionInMS);
    

trodeName = createTrodeName(params.channels);
sta = analysis{1}{1}.(trodeName).cumulativeSTA;
stv = analysis{1}{1}.(trodeName).cumulativeSTV;
numSpikes = analysis{1}{1}.(trodeName).cumulativeNumSpikes;
end