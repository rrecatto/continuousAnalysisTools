%% 356
subjectID = '356';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_14_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';
%% 8 Nov 2010
channels={1}; 
thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[3 90]};% ALL
%% 357
%% NEW CELL
% range from 1-21 (Pen#5)
thrV=[-0.05 Inf 0.4;...
    -0.05 Inf 0.4;...
    -0.05 Inf 0.4;...
    -0.04 Inf 0.2;...
    -0.05 Inf 0.4];
subjectID = '357'; channels={2,3,6,9,14};  cellBoundary={'trialRange',[9 20]}; pauseForInspect = false;
%% NEW CELL
%  subjectID = '357'; channels={2,3,6,8,9,10,14}; thrV =[-0.04 Inf 0.4]; cellBoundary={'trialRange',[8 21]}; %trf % bad. probably due to frames??? check spike record

% % range from 22-33 ffgwn % chans 9 and 14 have visual spikes
% thrV = [-0.06 Inf 0.4;...
%     -0.10 Inf 0.4;...
%     -0.04 Inf 0.4;...
%     ];
% subjectID = '357'; channels={5,9,14};  cellBoundary={'trialRange',[22 33]}; pauseForInspect = false; 
 
% range from 34-37 trf % both 9 and 14 have spikes that respond to slow trf
% thrV = [-0.10 Inf 0.4;...
%     -0.04 Inf 0.4;...
%     ];
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[34 37]}; pauseForInspect = false;

% % range from 38-43 bin 6X8 % somewhat unbelievable spat STAs
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[38 43]}; pauseForInspect = false;

% % range from 44-48 sf % 9 is not particularly modulated. 14 looks better. 
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[44 48]}; pauseForInspect = false;

% % range from 51 - 81 bin 6X8 % 14 has clear spat rf in lower right. 9 is
% % unclear
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[51 81]}; pauseForInspect = false;

% % range from 83 - 86 or not significantly tuned to any direction
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[83 86]}; pauseForInspect = false;
% % subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[86]}; pauseForInspect = false; % has issues!!!

% range from 83 - 86 or not significantly tuned to any direction
% subjectID = '357'; channels={9,14};  cellBoundary={'trialRange',[83 86]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW LOCATION
% thrV = [-.05 Inf;...
%     -.04 Inf;...
%     ];
% % 171- 191 is ffgwn% only 8 and 11 have stuff in them
% subjectID = '357'; channels={8,11};  cellBoundary={'trialRange',[171 191]};

% % 192- 197 is trf % both respond well to slow frequencies (2 Hz) % actually
% % trode chan 11 has 2 nicely separable spikes having diff trfs.
% subjectID = '357'; channels={8,11};  cellBoundary={'trialRange',[192 197]};

% % 199- 216 is bin 6X8; both show good spat RFs. only one of the spikes in
% 11 has a spat rf (the thin one)
% subjectID = '357'; channels={8,11};  cellBoundary={'trialRange',[199 215]};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NEW LOCATION
% 342-355 is ffgwn. finding good chans
% thrV = [-0.07 Inf 0.5;...
%     -0.07 Inf 0.5;...
%     -0.04 Inf 0.5;...
%     -0.035 Inf 0.5...
%     ];
% subjectID = '357'; channels={2,5,8,14};  cellBoundary={'trialRange',[342 355]};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
