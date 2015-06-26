%% 408
subjectID = '408';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1};
%% 28 June 2011
%unit1
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[31]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[35]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[37 42]};% bin
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[43 44]};% sfFF
% 
% %unit2
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[60 65]};% bin6Deg
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[66]};% sfFull
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[68 69]};% aSum256FullC_binSpat
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[71]};% aSum256QuatC_binSpat

%% July 6 2011
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[94 100]};% bin5Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[105 108]};% ffgwn1
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[116 120]};% ffgwn2


%% July 7 2011
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[236]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[238]};% sfFF
% % thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[242 245]};% bin6Deg
% % thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[267 268]};% bin6Deg
thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[277 282]};% bin6Deg


%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[284 286]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[287 295]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[296 299]};% sfFF_bimodal
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[300 302]};% aSum256FullC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[303 305]};% aSum256QuatC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[306 308]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[309 312]};% cntr512FF_suppressed by contrast
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[313 318]};% bin3Deg_shitty
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[319 321]};% aSum256HalfC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[322 326]};% aSum256QuatC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[327 328]};% sfSmall
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[330 331]};% aSum128FullC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[333 334]};% aSum128QuatC_binSpat

%%% shitty
% thrV = [-0.1 Inf 2]; cellBoundary={'trialRange',[349 351]};% trf
% thrV = [-0.1 Inf 2]; cellBoundary={'trialRange',[352 353]};% sfFF

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[363 364]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[365 366]};% sfFF

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[373 374]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[375 376]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[378 379]};% bin6Deg_decent

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[384]};% trf??
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[386]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[388 395]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[396]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[386 397],'trialMask',[388:395]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[398 399]};% aSum256FullC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[401 403]};% aSum256QuatC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[404 405]};% cntr512FF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[406 407]};% sfSmall
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[408 415]};% bin3Deg_weird

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[514 515]};% binrDeg_poor

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[556 557]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[559]};% sfFF_poor

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[595]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[598 602]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[603]};% sfFFNotComplete
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[595 603],'trialMask',[597:602]};% sfFF

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[607 610]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[611 614]};% bin3Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[615]};% aSum256FullC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[617]};% aSum256QuatC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[619 620]};% cntr256FF

%%%
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[625]};% sfFF
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[627 631]};% bin6Deg
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[632]};% sfFF
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[625 633],'trialMask',[627:631]};% sfFF
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[634 635]};% aSum256FullC_binSpat

%%%
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[669]};% sfFF
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[671 678],'trialMask',[675 676]};% bin6Deg
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[680 681]};% aSum256FullC_binSpat % good example for bursting
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[683 684]};% aSum128FullC_binSpat
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[686 687]};% aSum128QuatC_binSpat 
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[689 690]};% aSum128FullC_binSpat 
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[694 700]};% bin6Deg
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[671 700],'trialMask',[675 676 679:693]};% bin6Deg
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[703 704]};% sfSmall
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[709 710]};% cntr512
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[712 723]};% ffgwn1
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[724 731]};% ffgwn2
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[734]};% trf
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[733]};% trf
thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[671 700],'trialMask',[675 679:693]};% bin6Deg




%%%
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[876]};% trf
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[878 885]};% bin3Deg

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[891]};% sfFF_showsDoublePeak
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[893 897]};% bin3Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[898 904]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[905 906]};% aSum256FullC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[908 909]};% aSum256QuatC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[911 912]};% aSum256HalfC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[916]};% aSum256FullAndQuatC_binSpat

%%% weird cell
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[841]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[844 849]};% bin6Deg_poor
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[850]};% cntr256_weird!
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[852]};% cntr512_weird!


%%% weird cell
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[982 986]};% bin6Deg %weird cell
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[987]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[992 996]};% bin6Deg

%%%
% thrV = [-0.10 Inf 2]; cellBoundary={'trialRange',[940]};% sf
% thrV = [-0.10 Inf 2]; cellBoundary={'trialRange',[942 948]};% bin6Deg
% thrV = [-0.10 Inf 2]; cellBoundary={'trialRange',[949 950]};% aSum256FullC_binSpat
% thrV = [-0.10 Inf 2]; cellBoundary={'trialRange',[952 953]};% aSum256QuatC_binSpat
% thrV = [-0.10 Inf 2]; cellBoundary={'trialRange',[955]};% cntr512
% thrV = [-0.10 Inf 2]; cellBoundary={'trialRange',[957]};% aSum256FullAndQuatC_binSpat_poor

%%%
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[978 980]};% bin6Deg
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[983 985]};% bin6Deg
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[992 994]};% bin6Deg

%%%
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[1186 1190]};% bin6Deg
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[1191]};% sfFF

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1207 1208]};% sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1210 1211]};% trf
% thrV = [-Inf 0.15 2]; cellBoundary={'trialRange',[1213 1215]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1218]};% cntr512
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1220]};% cnt256
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1234 1235]};% sfSmall
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1222]};% aSum256FullC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1237]};% aSum128FullC_binSpat_poor
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1224 1225]};% aSum256FullAndQuatC_binSpat_terrible
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1227 1233]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1239]};% aSum128HalfC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1241]};% aSum128QuatC_binSpat


%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1304 1308]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1309]};% sf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1311]};% cntr512
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1313]};% cntr256
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1315]};% aSum256FullAndQuatC_binSpat

%%% 
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1320 1327]};% bin6Deg

%%% 
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1340 1341]};% bin6Deg

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1348]};% sfFullC
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1350 1352]};% bin6Deg_poor
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1353]};% cntr256

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1368]};% sf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1370 1373]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1374]};% aSum256FullAndQuatC_binSpat
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1377 1383]};% bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1384]};% sfSmall
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1386]};% cntr265
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1388 1389]};% trf
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1391 1396]};% ffgwn_good
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1397 1398]};% ffgwn_extrcell

%%%
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[1430 1432]};%sfFF ***
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[1434 1440]};%bin6Deg
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[1441 1442]};%aSum256FullAndQuatC_binSpat_very nice!
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[1444 1445]};%sfSmall
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[1447 1449]};%sfFF
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[1451 1453]};%cntr512
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[1456 1457]};%trf
% thrV = [-Inf 0.07 2]; cellBoundary={'trialRange',[1459 1470]};%bin3Deg_very nice

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1479]};%sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1481 1486]};%bin6Deg
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1487 1488]};%sfSmall
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1490 1497]};%bin3Deg_nice
% thrV = [-Inf 0.03 2]; cellBoundary={'trialRange',[1499 1500]};%aSum256FullAndQuatC_binSpat_weird
% thrV = [-Inf 0.03 2]; cellBoundary={'trialRange',[1502 1503]};%cntr256_small

%%%
% thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[1512]};%sfFF 
% thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[1514 1520]};%bin6Deg
% thrV = [-0.2 Inf 2]; cellBoundary={'trialRange',[1521 1522]};%sfSmall

%%%
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1525]};%sfFF
% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1527 1528]};%bin6Deg_sorta crappy

% % % thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1557 1559]};%bin6Deg
% % % 
% % % thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[1584 1588]};%bin6Deg
% % % 
% % % thrV = [-Inf 0.7 2]; cellBoundary={'trialRange',[1603 1606]};%bin6Deg

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

