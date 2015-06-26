%% 389
subjectID = '389';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1};
%% 8 Nov 2010
% %unit1
subjectID = '389-old';
thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[7 11]};% trf good sort
thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[13 19]};% spatial
% thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[11 19]};% 6x8 clean spatial this is weird....

%unit2
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[21]};% trf decent sort
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[23 24]}; %ffgwn use combo
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[25 26]};% 6x8 spatial at bottom use combo
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[23 26]}; %ffgwn
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[29]};% sf bad
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[27]};% 6x8



thrV = [-0.15 Inf 2]; cellBoundary={'trialRange',[45 50]};% 6x8 poor

%% Jan 28
% unit 1
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[55 58]};% 6x8
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[60 61]};% radC100
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[62 63]};% radC80 whats happening here?
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[65 67]};% 6x8
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[55 67],'trialMask',[59:64]};% 6x8


% % unit 2
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[72 76]};% 6x8
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[78]};% RAD 256 C100
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[80]};% RAD 256 C60
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[82 84]};% sf
%
% % I THINK I TRIED TO CHANGE THE POSITION OF THE ANNULUS AFTER GETTING THIS
% % DATA
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[85 87]};% 12x16
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[91]};% rad256C100
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[92 93]};% rad256C80
% %
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[96]};% rad256C100*
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[97 98]};% rad256C80*
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[99]};% rad256C60 eh???
% %
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[101]};% rad128C100 shows no suppression
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[102]};% rad128C80 shows no suppression
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[103]};% rad128C80 shows no suppression weird
%
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[85 87]};% just checking
%
% %% Jan 30
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[113 118]};% bin12X16 weird


warning('i changed the rat from 389-old to 389');pause(1);
subjectID = '389';
% March 23
% % unit 2
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[6]};% trf
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[8 10]};% ffgwn
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[11 13]};% bin6X8
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[14 17]};% bin12X16

%uint3
thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[20]};% trf
thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[22 24]};% ffgwn
thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[25 27]};% bin6X8
thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[28 35]};% bin12X16

%% April 14 2011
% unit 1 not included
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[81 82]};% trf
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[83 85]};% ffgwn2

% unit2 not included
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[86 87]};% trf bsd
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[88 91]};% ffgwn bads

% unit 3
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[94 98]};% trf
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[99 105]};% ffgwn
% thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[106 112]};% bin6X8 too slow
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[115 117]};% sfbig


%% Apr 15 2011.
% unit 1
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[120 124]};% trf
%% April 17 2011
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[128 129]};% trf
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[131 132]};% ffgwn
% unit 2
% thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[125 127]};% ffgwn bad
% unit 2
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[140]};% ffgwn
%% April 17
% % unit 1
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[128 130]};% trf
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[131 132]};% ffgwn1
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[135 137]};% bin6X8
% % 
% % % %unit 2
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[138 139]};% trf
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[140 142]};% ffgwn
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[143 144]};% ffgwn
thrV = [-Inf 0.3 2]; cellBoundary={'trialRange',[140 144]};% ffgwn


%%
% %unit 1
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[247 251]};% bin6X8
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[268 273]};% ffgwn visual but unable to get bin
% 
% % unit 2
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[280 292]};% bin 6X8 such a slpow cell
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[297 300]};% ffgwn
% 
% %% may4
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[314 325]};% 6X8 326 is weird whole cell is weird
% 
% %%may5
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[378 379]};% 6X8 sucks
% 
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[383]};% trf
% 
% 
% 
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[395 396]};% 6X8 bad

% may 11
% unit 1
thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[425 430]};% 6X8 good candidate for eye movement
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[395 396]};% 6X8
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[395 396]};% 6X8

%unit 2
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[461]};% on off!
thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[463 464]};% 6X8 good candidate for eye movement
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange,[395 396]};% 6X8

%% May 13
%unit1
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[490 492]};% trf
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[493 502]};% 6X8 pretty bad

% % %% May 16
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[526]};% trf
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[528 535]};% 12X16
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[536 537]};% sfFull
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[540 541]};% sfSmall
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[543]};% contrast
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[545]};% radFullContrast
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[547]};% radQuatContrast
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[549 552]};% ffgwn

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

