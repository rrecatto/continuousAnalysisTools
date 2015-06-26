%% 375
subjectID = '375';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';
%% 8 Nov 2010
channels={1}; 
thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[393 396]};% ffgwn
thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[398 400]};% trf
thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[402 405]};% spat freq
thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[407 411]};% bix6X8
% thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[393 412]};% ALL

%% 9 Nov 2010
% unit 1 incomplete analysis poor  sort
% channels={1};
thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[477 478]};% ffgwn
thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[480 481]};% sfSin 
thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[486 488]};% ffgwn
thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[493 495]};% sfSin
% thrV = [-0.12 Inf 0.4]; cellBoundary={'trialRange',[477 495]};% sfSin

% unit2
channels={1};
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[535 537]};% ffgwn
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[539 550]};% bin 6X8 bad
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[552 553]};% sfSin
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[555 557]};% sfSqr
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[535 557]};% ALL


%% 14 Nov 2010
% unit 1
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[590 593]};% ffgwn
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[595 606]};% bin 6X8
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[590 606]}; %ALL



%% 22 Nov 2010 First cell held for 69 minutes. Woohoo!
thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[758 761]};% ffgwn
thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[763 764]};% sf
thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[766 769]};% rad
thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[773 775]};% bin12X16
thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[777 778]};% orGr512
thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[785 794]};% bin6X8
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[758 794]};% ALL

%% 23 Nov 2010
% unit 1
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[874 878]};% ffgwn
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[874 878]};% ALL not included
% unit 2
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[880 884]};% ffgwn
thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[885 890]};% trf
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[880 890]};% ALL

%% 01 Dec 2010c
% % unit 1
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[931 933]};% ffgwn

% thrV = [-0.1 Inf 2]; cellBoundary={'trialRange',[1008 1015]};% spat
%% 16 Dec 2010
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1128 1131]};% trf
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1135 1136]};% ffgwn
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1144 1153]};% bin68

% % 
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1166]};% sf
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1168 1172]};% bin68
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1182]};% sf
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1184 1187]};% bin
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1200 1201]};% bin
% 
% 
% thrV = [-0.15 inf 1]; cellBoundary={'trialRange',[1210]};%trf
% thrV = [-0.15 inf 1]; cellBoundary={'trialRange',[1212 1213]};%trf
% thrV = [-0.15 inf 1]; cellBoundary={'trialRange',[1214 1217]};% bin not included
% thrV = [-0.15 inf 1]; cellBoundary={'trialRange',[1219 1222]};% bin???
% thrV = [-0.15 inf 1]; cellBoundary={'trialRange',[1235 1236]};% or
% 
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1277 1286],'trialMask',[1282:1284]};% ffgwn
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1283]};% sf **good to check
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1294 1297]};% bin
% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1298 1299]};% bin



%% USELESS
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1128 1131]};%search trf
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1132]};%search sf
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1135 1136]};%ffgwn
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1137 1143],'trialMask',1140};%whats this? shitty ffgwn?/?
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1144 1154]};%binary

% thrV = [-Inf 0.25 1]; cellBoundary={'trialRange',[1128 1157]};% ALL
%% 17 Dec 2010c
% unit 1
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1182]};%sf
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1184 1194]};%bin6x8
% % 
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1200 1201]};%rad
% % % % thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1203]};%radctr95
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1163 1204]};%ALL

% %% 20 Dec 2010c
% % unit 1
% thrV = [-0.2 Inf 1]; cellBoundary={'trialRange',[1210]};%trf
% thrV = [-0.2 Inf 1]; cellBoundary={'trialRange',[1212 1213]};%sf
% thrV = [-0.2 Inf 1]; cellBoundary={'trialRange',[1214 1217]};%ffgwn

% thrV = [-0.2 Inf 1]; cellBoundary={'trialRange',[1235 1236]};%or1024
% thrV = [-0.2 Inf 1]; cellBoundary={'trialRange',[1209 1236]};%ALL

% %% 21 Dec 2010c
% thrV = [-Inf 0.15 1]; cellBoundary={'trialRange',[1294 1301]};%bin6x8
% thrV = [-Inf 0.15 1]; cellBoundary={'trialRange',[1298 1301]};%bin6x8
% thrV = [-Inf 0.15 1]; cellBoundary={'trialRange',[1305]};%rad this is good
% thrV = [-Inf 0.15 1]; cellBoundary={'trialRange',[1281 1307],'trialMask',[1291 1303]};%ALL
%%%%%%%%%
%new unit
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1350 1351]};%trf
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1353 1359]};%bin looks good
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1361]};%sf ** also looks good
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1344 1348]};%ALL
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1350 1362]};%ALL


thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1366]};%searchTRF
thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1368]};%sf
thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1370 1374]};%bin
thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1386 1394]};%bin
thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1379]};%rad
thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1381 1382]};%rad95
thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1384]};%rad75
thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1386 1392]};%bin6X8
% thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1394 1395]};%rad256_75
% thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1397]};%rad128_75
% thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1365 1399]};%ALL

% new unit
% thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1400 1402]};%ALL bad

% new unit
% thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1404 1406]}; %trf
% thrV = [-0.2 0.2 1]; cellBoundary={'trialRange',[1407 1408]};%sf

%% Jan 21

% thrV = [-0.1 Inf 1]; cellBoundary={'trialRange',[1414]};%ffgwn
% thrV = [-0.1 Inf 1]; cellBoundary={'trialRange',[1417]};%ALL pretty shitty

%% Jan 22
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1614 1618]};%bin12X16 terrible
% 
%% Jan 22
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1622]};%trf

% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1650]};%trf


% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1657]};%trf useless
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[1659 1660]};%6x8 total crap
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1663 1665]};%trf
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1668 1669]};%6x8
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1671 1672]};%sfSin weird one
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1674 1675]};%contrast
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1686 1687]};%rad64C100
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1688 1689]};%rad64C80


%% Jan 25
% unit1
% thrV = [-0.25 Inf 2]; cellBoundary={'trialRange',[1760]};%trf
% thrV = [-0.25 Inf 2]; cellBoundary={'trialRange',[1763]};%sf
% thrV = [-0.25 Inf 2]; cellBoundary={'trialRange',[1765]};%radCntr80PPC128
% thrV = [-0.25 Inf 2]; cellBoundary={'trialRange',[1767]};%radCntr60PPC128

% %% Jan 26
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1770]};%trf
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1775]};%sf double band pass
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[1776]};%cntr


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

