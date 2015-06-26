%% 354
subjectID = '354';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1};
%% 28 June 2011
%unit1
channels={1}; thrV=[-0.1 Inf 0.5]; cellBoundary={'trialRange',[20 26]};%trf?

% channels={1}; 
% thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[20 41]};% ALL
% thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[53 90]};% ALL
thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[90 124]};% ALL


% subjectID = '354'; channels={1}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[20 26]}; %trf
subjectID = '354'; channels={1}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[40 41]}; %or1024
% 
% subjectID = '354'; channels={1}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[53 60]}; %ffgwn
subjectID = '354'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[61 65]}; %or1024
% subjectID = '354'; channels={1}; thrV = [-0.1 Inf 0.5]; cellBoundary={'trialRange',[67 90]}; %bin6X8
% % 
% subjectID = '354'; channels={1}; thrV = [-0.2 Inf 0.5];
% cellBoundary={'trialRange',[120 124]}; %sf

workFlow = {'onlyDetectAndSort','onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
% workFlow = {'onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
% workFlow = {'onlyAnalyze','viewAnalysisOnly'};
workFlow = {'viewAnalysisOnly'};
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
                addCurrentAnalysis = false;
                analysisMode = 'viewAnalysisOnly';
                analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
                    'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
                    'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
            otherwise
                error('not supported in workFlow');
        end
    end
else
    
    analysisMode = 'onlyInspect';
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
    analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
        'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
        'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
end

