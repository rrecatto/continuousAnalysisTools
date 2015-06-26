%% 353
subjectID = '353';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_14_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';
%% 8 Nov 2010
channels={1}; 
thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[3 90]};% ALL

thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[153 199]};% ALL
thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[200 296]};% ALL


subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[3 5]}; %fgwn
subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[25 28]}; %sf
subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[30 34]}; %or

% subjectID = '353'; channels={1}; thrV = [-0.25 Inf 0.5]; cellBoundary={'trialRange',[59 60]}; %ffgwn

% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[87 90]}; %ffgwn


% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[153 199],'trialMask',[173:177]}; %all before
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[200 296],'trialMask',[259 260]}; %all before

subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[160 165],'trialMask',163}; %or1024
% trialRange = [160:165];
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[167 172]}; %sf
% 
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[183 197]}; %bin 6X8
% 
subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[225 227]}; %or after muscimol
subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[228 230]}; %or after muscimol
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[225 235],'trialMask',235}; %or after muscimol
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[241 248],'trialMask',235}; %or after muscimol

% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[251 253],'trialMask',235}; %sf
% subjectID = '353'; channels={1}; thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[265 270]}; %or after muscimol

workFlow = {'onlyDetectAndSort','onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
% workFlow = {'onlyAnalyze','viewAnalysisOnly'};
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
                addCurrentAnalysis = true;
                analysisMode = 'viewAnalysisOnly';
                analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
                    'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
                    'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
            otherwise
                error('not supported in workFlow');
        end
    end
else
    
    analysisMode = 'viewAnalysisOnly';
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
