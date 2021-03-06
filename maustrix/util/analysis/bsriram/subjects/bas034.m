%% bas016
subjectID = 'bas034';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_11_29_2012.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';



%% 29 Nov 2012
% channels={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31};
% channels={
%     [2 3 12 22],...
%     [3 4 21 12 2],...
%     [4 5 13 21 3],...
%     [5 6 20 13 4],...
%     [6 7 14 20 5],...
%     [7 8 19 14 6],...
%     [8 9 15 19 7],...
%     [9 10 18 15 8],...
%     [10 16 18 9],...
%     [11 22 32],...
%     [12 2 3 21 30 31 22],...
%     [13 4 5 20 28 29 21],...
%     [14 6 7 19 26 27 20],...
%     [15 8 9 18 24 25 19],...
%     [16 10 17 23 18],...
%     [17 16],...
%     [18 9 10 16 23 24 15],...
%     [19 7 8 15 25 26 14],...
%     [20 5 6 14 27 28 13],...
%     [21 3 4 13 29 30 12],...
%     [22 2 12 31 32 11],...
%     [23 18 16 24],...
%     [24 15 18 23 25],...
%     [25 19 15 24 26],...
%     [26 14 19 25 27],...
%     [27 20 14 26 28],...
%     [28 13 20 27 29],...
%     [29 21 13 28 30],...
%     [30 12 21 29 31],...
%     [31 22 12 30 32],...
%     [32 11 22 31]}; % poly 3
% for i = 1:31
%     channels{i} = channels{i}-1;
% end

% thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[7 12]};% trf

% channels={
%     [3 4 21 12 2],...
%     [4 5 13 21 3],...
%     [5 6 20 13 4],...
%     [11 22 32],...
%     [12 2 3 21 30 31 22],...
%     [13 4 5 20 28 29 21],...
%     [14 6 7 19 26 27 20],...
%     [20 5 6 14 27 28 13],...
%     [21 3 4 13 29 30 12],...
%     [22 2 12 31 32 11],...
%     [26 14 19 25 27],...
%     [27 20 14 26 28],...
%     [28 13 20 27 29],...
%     [29 21 13 28 30],...
%     [30 12 21 29 31],...
%     [31 22 12 30 32],...
%     [32 11 22 31]}; % poly 3

channels={
    3,...
    [3 4 21 12 2],...
    [4 5 13 21 3],...
    [5 6 20 13 4],...
%     [11 22 32],...
%     [12 2 3 21 30 31 22],...
%     [13 4 5 20 28 29 21],...
%     [14 6 7 19 26 27 20],...
%     [20 5 6 14 27 28 13],...
%     [21 3 4 13 29 30 12],...
%     [22 2 12 31 32 11],...
%     [26 14 19 25 27],...
%     [27 20 14 26 28],...
%     [28 13 20 27 29],...
%     [29 21 13 28 30],...
%     [30 12 21 29 31],...
%     [31 22 12 30 32],...
%     [32 11 22 31],...
    }; % poly 3

for i = 1:length(channels)
    channels{i} = channels{i}-1;
end

% channels={2,3,4,10,11,12,13,19,20,21,25,26,27,28,29,30};
thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[17 18]};% trf
% thrV = [-0.15 Inf 0.5]; cellBoundary={'trialRange',[20 28]};% ffgwn1

% workFlow = {'onlyDetectAndSort','onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
workFlow = {'onlyDetectAndSort','onlyInspectInteractive'};
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

