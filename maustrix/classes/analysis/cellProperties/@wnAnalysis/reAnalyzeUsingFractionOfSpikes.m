function [sta stv numSpikes] = reAnalyzeUsingFractionOfSpikes(s,params)

% setup the required variables
trialRange = minmax(s.trials);
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


analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
        'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
        'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis,'subSampleSpikes',params.fraction);
    

trodeName = createTrodeName(params.channels);
sta = analysis{1}{1}.(trodeName).cumulativeSTA;
stv = analysis{1}{1}.(trodeName).cumulativeSTV;
numSpikes = analysis{1}{1}.(trodeName).cumulativeNumSpikes;
end