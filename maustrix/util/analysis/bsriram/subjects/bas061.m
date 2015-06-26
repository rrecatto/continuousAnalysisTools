%% bas060
subjectID = 'bas061';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_11_29_2012.m');

channels={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32};
% trialRange = 13546:15609;

errorTrials = [];

try
    thrV = [5 10 50]; cellBoundary={'trialRange',[13547 13647]};% afcGraitgns
    %         waitbar((trial-min(trialRange))/(max(trialRange)-min(trialRange)),h);
    
    % workFlow = {'onlyDetectAndSort','onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
%     workFlow = {'onlyDetectAndSort'};
            workFlow = {'onlyInspectInteractive'};
    % workFlow = {'onlyDetectAndSort','onlyInspectInteractive'};
    % workFlow = {'onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
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
        enableMilliSecondPrecision = false;
        if enableMilliSecondPrecision
            pixelOfInterest = [1 1];
        else
            pixelOfInterest = [NaN NaN];
        end
        analysisMode = 'onlySortNoInspect';
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
            'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);
    end
catch ex
    getReport(ex);
    %         message = sprintf('error on trial %d',trial);
    %         gmail('sbalaji1984@gmail.com','error',message);
%     errorTrials(end+1) = trial;
rethrow(ex)
end
% end
gmail('sbalaji1984@gmail.com','finished','done all trials');

