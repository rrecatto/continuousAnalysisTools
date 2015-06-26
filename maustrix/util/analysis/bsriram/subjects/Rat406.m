%% 406
subjectID = '406';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1};
%% May 19 2011
%unit1
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[36 37]};% trf
thrV = [-Inf 0.25 2]; cellBoundary={'trialRange',[39 44]};% bin6X8 nothing to see here BAD
thrV = [-Inf 0.4 2]; cellBoundary={'trialRange',[46 47]};% sfFull
thrV = [-Inf 0.75 2]; cellBoundary={'trialRange',[62 70]};% ffgwn1

%unit2
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[88 89]};% trf

%unit3
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[111 112]};% trf
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[114 118]};% bin6X8 BAD
thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[119 120]};% sf BAD

thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[128 129]};% ffgwn
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[136 142]};% bin6x8_unable to pull out RF BAD
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[144]};% sfSmall BAD
thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[133 134]};% sfFF


thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[163 171]};% bin12X16

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[212 213]};% sfFF
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[216 222]};% ffgwn1

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[316 317]};% trf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[320 325]};% bin 6Deg BAD
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[326 328]};% sfFF
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[330]};% trf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[333 335]};% contrast
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[341 347]};% bin3Deg BAD
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[350 351]};% afullC BAD
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[353 354]};% aQuatC BAD
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[356 357]};% aFullC BAD
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[362 366]};% ffgwn
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[368 380]};% bin 3 Deg BAD
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[382 384]};% sfFF

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[386]};% trf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[388 393]};% Bin6Deg
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[394]};% sfFF
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[396]};% areaFullC
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[398 399]};% areaQuatC
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[404 405]};% areaHalfC
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[401 403]};% areaFullC
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[407 408]};% sfFFFullC
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[409 431]};% BIN3dEG

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[500]};% trf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[506 509]};% bin6Deg
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[510 512]};% bin6Deg
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[513]};% sfFF
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[517 520]};% bin6Deg
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[521 522]};% aSum256FullC_binSpat
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[524]};% aSum256QuatC_binSpat




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

