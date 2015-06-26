%% 356
subjectID = '356';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_14_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';
%% 8 Nov 2010
channels={1}; 
thrV = [-0.2 Inf 0.5]; cellBoundary={'trialRange',[3 90]};% ALL

% %LGN - 16 ch - 
% subjectID = '356'; channels={[2:6 9:11]}; thrV=[-0.02 Inf]; cellBoundary={'trialRange',[8]};%ffgwn- LGN
% %subjectID = '356'; channels={[11 10 2 3]}; thrV=[-0.02 Inf]; cellBoundary={'trialRange',[110]};%ffgwn- LGN
% subjectID = '356'; channels={[4 11]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[110]};%ffgwn- LGN
% subjectID = '356'; channels={[11 4]}; thrV=[-0.09 Inf]; cellBoundary={'trialRange',[110 118]};%ffgwn- LGN - no temporal STA on these chans (but phys 12 & 15?)
% subjectID = '356'; channels={[8]}; thrV=[-0.09 Inf]; cellBoundary={'trialRange',[110]};%guess 8 is 15? - gets the monitor intensity, 0 lag
% subjectID = '356'; channels={[6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[110 118]};%chart says 6 is 15, this has an STA! yay!
%% multiple cells gwn 
% %3 cells - these leads may or may not have the same cells on them, given their spacing of 50um
% subjectID = '356'; channels={[2:6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[345 354]};%3 cells, gwn
% subjectID = '356'; channels={[2 9:11]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[345 354]};%3 cells, gwn
% %subjectID = '356'; channels={[2:6]}; thrV=[-0.03 Inf]; cellBoundary={'trialRange',[377 380]};%3 cells
% subjectID = '356'; channels={2,9,10,11}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[345]};%3 cells, gwn
% subjectID = '356'; channels={2}; thrV=[-0.08 Inf]; cellBoundary={'trialRange',[345 354]};%3 cells, gwn
% %LONG PAUSE, but same 3 cells/ location

% subjectID = '356'; channels={2,9,10}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[397 401]};%3 cells, gwn
% % subjectID = '356'; channels={[10]}; thrV=[-0.06 Inf];
% cellBoundary={'trialRange',[397 403]};
% %subjectID = '356'; channels={[9]}; thrV=[-0.07 Inf]; cellBoundary={'trialRange',[397 403]};
% %subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[397 403]}; % has different temporal shape
% subjectID = '356'; channels={[2],[6],[10],[9]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[397 403]};%3 cells, gwn

% %subjectID = '356'; channels={[2]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[432]}; %
%% spatial
% subjectID = '356'; channels={[10]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[432 444]}; % has spatial, upper right
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[432 444]};  % has a different spatial!
% subjectID = '356'; channels={[9]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[432 442]};  % this is a bit weaker, same lower center location
subjectID = '356'; channels={[10],[6],[9]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[432 442]};  % this is a bit weaker, same lower center location ** errors at snippeting

% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[377 380]}; %3 cells, stronger response to lower contrast delayed??
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[377]}; %3 cells, stronger response to lower contrast delayed??
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[485]}; %fffc about 3 trials near here 482-485ish?
% subjectID = '356'; channels={[6]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc
% subjectID = '356'; channels={[10]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc - probably 2 cells lumped into 1 anay
% subjectID = '356'; channels={[2]}; thrV=[-0.05 Inf]; cellBoundary={'trialRange',[492 498]}; %fffc 
% subjectID = '356'; channels={[1],[2]}; thrV=[-0.06 Inf]; cellBoundary={'trialRange',[550]};

%% post spatial. muscimol additions
% figuring out the parameters for spike detection
% {2,-0.03}
% {3,-0.02}
% {4,-0.03}
% {5,-0.018}
% {6,-0.025}
% {7,-----}
% {8,-0.02}
% {9,-0.025}
% {10,-0.05}
% {11,-0.04}
% {12 -----}
% {13 -----}
% {14 -----}
%  thrV=[-0.02 Inf -0.2;...
%      -0.04 Inf -0.2;...
%      -0.06 Inf -0.2;...
%      -0.04 Inf -0.2;...
%      -0.06 Inf -0.2;...
%      -0.06 Inf -0.2];
%  
% subjectID = '356'; channels={3,4,5,6,9,11};
% cellBoundary={'trialRange',[551]};

workFlow = {'ondblyDetectAndSort','onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
workFlow = {'onlyAnalyze','viewAnalysisOnly'};
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
