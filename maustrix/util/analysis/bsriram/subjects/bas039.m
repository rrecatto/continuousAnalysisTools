%% bas016
subjectID = 'bas039';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_11_29_2012.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31};
% channels={2,3,4,10,11,12,13,19,20,21,25,26,27,28,29,30};
thrV = [-0.05 Inf 0.5]; cellBoundary={'trialRange',[3]};% ffgwn

channels={1};

thrV = [-0.01 Inf 0.5]; cellBoundary={'trialRange',[27 29]};% trf
thrV = [-0.01 Inf 0.5]; cellBoundary={'trialRange',[30 32]};% or
% thrV = [-0.01 Inf 0.5]; cellBoundary={'trialRange',[34 35]};% ctr
% thrV = [-0.01 Inf 0.5]; cellBoundary={'trialRange',[37 47]};% bin

% 6/17
channels={25,26};
thrV = [-0.08 Inf 0.5]; cellBoundary={'trialRange',[112 113]};% trf


workFlow = {'onlyDetectAndSort','onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
workFlow = {'onlyDetectAndSort','onlyInspectInteractive'};
% workFlow = {'onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
workFlow = {'onlyAnalyze','viewAnalysisOnly'};
% workFlow = {'viewAnalysisOnly'};
enableWorkFlow = true; %true; %false

if enableWorkFlow
    for i = 1:length(workFlow)
        intelligentUpdate = {false,'extraTrialsAtEnd','identDetAndSortParams'};
        switch workFlow{i}
            case 'onlyDetectAndSort'
                forceNoInspect = true;
                addCurrentAnalysis = false;
                analysisMode = 'onlyDetectAndSort';
                analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
                    'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
                    'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
            case 'onlyInspectInteractive'
                forceNoInspect = false;
                addCurrentAnalysis = false;
                analysisMode = 'onlyInspectInteractive';
                analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
                    'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
                    'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
            case 'onlyAnalyze'
                forceNoInspect = false;
                addCurrentAnalysis = false;
                analysisMode = 'onlyAnalyze';
                analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
                    'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
                    'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
            case 'viewAnalysisOnly'
                forceNoInspect = false;
                addCurrentAnalysis = false; % true % false
                analysisMode = 'viewAnalysisOnly';
                analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
                    'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
                    'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
            otherwise
                error('not supported in workFlow');
        end
    end
else
    enableMilliSecondPrecision = true;
    if enableMilliSecondPrecision
        pixelOfInterest = [1 1];
    else
        pixelOfInterest = [NaN NaN];
    end
    analysisMode = 'onlyAnalyze';
    %% ideas for analysisMode implemented
    % analysisMode = 'overwriteAll';
    % analysisMode = 'onlyAnalyze';
    % analysisMode = 'viewAnalysisOnly';
    % analysisMode = 'onlyDetect';
    % analysisMode = 'onlySort';
    % analysisMode = 'onlyDetectAndSort';
    % analysisMode = 'onlyInspect';
    % analysisMode = 'onlyInspectInteractive';
    switch analysisMode
        case 'onlyDetectAndSort'
            forceNoInspect = true;
        otherwise
            forceNoInspect = false;
    end
    intelligentUpdate = {false,'extraTrialsAtEnd','identDetAndSortParams'};
    addCurrentAnalysis = false;
%     analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
%         'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
%         'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
    
    analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
        'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
        'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis,'milliSecondPrecision',pixelOfInterest);
end

