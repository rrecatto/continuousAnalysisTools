%% 407
subjectID = '407';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1};
%% 28 June 2011
%unit1
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[31]};% trf
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[35]};% sfFF
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[37 42]};% bin
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[43 44]};% sfFF
% 
% %unit2
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[60 65]};% bin6Deg
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[66]};% sfFull
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[68 69]};% aSum256FullC_binSpat
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[71]};% aSum256QuatC_binSpat

%% July 7
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[139]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[143 144]};% trf

% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[189 190]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[191 192]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[194 201]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[204 205]};% aSum256FullC_manual
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[207 208]};% aSum256QuatC_manual
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[211 217]};% bin6Deg

thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[223]};% trf
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[226]};% trf

thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[229]};% trf

thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[246 247]};% trf

thrV = [-0.1 Inf 2]; cellBoundary={'trialRange',[259]};% trf

%% July 9
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[292]};% trf
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[294]};% sfFF
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[296 297]};% bin6Deg

thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[335]};% trf

thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[346]};% trf
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[348]};%sfFF
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[350 352]};%bin6Deg


thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[362 363]};% sfFF
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[365 372]};% bin3Deg


% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[381]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[383]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[385 391]};% bin 3 deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[392 393]};% aSum128FullC_binSpat

% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[533]};%trf

% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[567 568]};%sf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[569 571]};%trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[572]};%sfFF

% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[581 582]};%trf

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

