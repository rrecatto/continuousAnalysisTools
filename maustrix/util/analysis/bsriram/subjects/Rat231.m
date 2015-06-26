%% 231
subjectID = '231';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1};
%% 28 June 2011
%unit1
% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[4]};%TRF - great!
% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[15 24]};%ffgwn strf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[31]};% sf
channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[26 37]};%sf
% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[46 63],'trialMask',[49 52:57 59:61]}; %ffgwn
% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[66]};%TRF
% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[117 124]};%phases

% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[75 76]};%good sort but what the hell is the stim???

% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[96]};%TRF?

% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[134]};%trf


channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[149]};%sf
% channels={1}; thrV=[-Inf 0.15 1]; cellBoundary={'trialRange',[152 154]};%ffgwn poor
% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[157 158]};%annuli
% channels={1}; thrV=[-Inf 0.5 1]; cellBoundary={'trialRange',[158]};%trf

% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[269 270]};%trf

% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[356]};%trf

% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[430 431]};%trf failing...
% channels={1}; thrV=[-0.05 Inf 1]; cellBoundary={'trialRange',[435 436]};%phases

% channels={1}; thrV=[-Inf 0.05 1]; cellBoundary={'trialRange',[435 436]};%phases swept

% channels={1}; thrV=[-0.05 Inf 1]; cellBoundary={'trialRange',[497 498]};%phases swept
% channels={1}; thrV=[-0.05 Inf 1]; cellBoundary={'trialRange',[499 502]};%ffgwn

% channels={1}; thrV=[-0.05 Inf 1]; cellBoundary={'trialRange',[615]};%trf?
% channels={1}; thrV=[-0.05 Inf 1]; cellBoundary={'trialRange',[615 628]};%ffgwn
% channels={1}; thrV=[-0.05 Inf 1]; cellBoundary={'trialRange',[629 634]};%trf


% channels={1};  thrV=[-0.25 Inf]; cellBoundary={'trialRange',[681]};%trf
% channels={1}; thrV=[-0.25 Inf]; cellBoundary={'trialRange',[681 682]};%trf


% channels={1}; thrV=[-Inf 0.2 2]; cellBoundary={'trialRange',[806 830]};%ffgwn

channels={1}; thrV=[-Inf 0.2 2]; cellBoundary={'trialRange',[853]};%sf

% channels={1}; thrV=[-0.15 Inf 2]; cellBoundary={'trialRange',[878 887]};%ffgwn

channels={1}; thrV=[-0.15 Inf 2]; cellBoundary={'trialRange',[941]};%sf bad

% channels={1}; thrV=[-Inf .2 2]; cellBoundary={'trialRange',[956 960]};%ffgwn
channels={1}; thrV=[-Inf .2 2]; cellBoundary={'trialRange',[965]};%sf
% channels={1}; thrV=[-Inf .2 2]; cellBoundary={'trialRange',[967]};%or

% channels={1}; thrV=[-0.08 Inf 2]; cellBoundary={'trialRange',[1163 1173]};%ffgwn



%  channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1326]};%tf

%  channels={1}; thrV=[-0.3 Inf]; cellBoundary={'trialRange',[1382]};%td, rat awake now
 

workFlow = {'onlyDetectAndSort','onlyInspectInteractive','onlyAnalyze','viewAnalysisOnly'};
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

