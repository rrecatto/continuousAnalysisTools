%% 405
subjectID = '405';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1};

% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[3 5]};% trf


% thrV = [-Inf 0.1 2]; cellBoundary={'trialRange',[69 70]};% trf
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[72 78]};% bin6X8
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[103 113]};% bin12X16
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[79 80]};% sfFF
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[85 88]};% sfSmall
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[89]};% contrast
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[91 93]};% radFullC
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[99 100]};% radFullC
% thrV = [-Inf 0.2 1]; cellBoundary={'trialRange',[94 97]};% radQuatC
% thrV = [-Inf 0.2 2]; cellBoundary={'trialRange',[114 119]};% ffgwn1

% thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[218]};% trf

% thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[220]};% trf
% thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[222 227]};% bin 6X8 on screen but weird

% thrV = [-Inf 0.06 3]; cellBoundary={'trialRange',[244 245]};% trf
% thrV = [-Inf 0.08 3]; cellBoundary={'trialRange',[247 248]};% sfFF_so_weird
thrV = [-Inf 0.08 3]; cellBoundary={'trialRange',[261 271]};% bin6X8_on screen but suspect sort

thrV = [-Inf 0.06 3]; cellBoundary={'trialRange',[280 281]};% trf

thrV = [-Inf 0.06 3]; cellBoundary={'trialRange',[288]};% trf
thrV = [-Inf 0.06 3]; cellBoundary={'trialRange',[289 294]};% bin6X8

thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[305 307]};% trf
thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[309 315]};% bin6Deg_weird
thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[317]};% trf
thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[319 324]};% bin6Deg
thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[326 328]};% bin6Deg after rotation

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[344 345]};% trf 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[347 352]};% bin6Deg 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[353 354]};% sfFull 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[356]};% aSum128FullC 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[358]};% aSum128QuatC 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[360]};% aSum128HalfC 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[362]};% aSum256FullC 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[364]};% aSum256FullC 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[366]};% contrast 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[368 370]};% bin 3Deg 

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[372]};% trf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[374 378]};% bin6Deg
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[379]};% sf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[382]};% cntr
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[384 395]};% bin3Deg weird...
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[397]};% sf

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[405]};% trf suspect

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[411 413]};% trf suspect
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[415]};% sf poor
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[417 424]};% trf suspect
thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[427 432]};% bin6Deg probably same cell
thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[433]};% sf poor
thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[435]};% sf small

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[441]};% trf!

thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[446 448]};% trf bad

thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[447]};% trf is that one cell or two cells? weird!!!
thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[449 452]};% bin6Deg_on screen but weird cell
thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[455]};% aSum256FullC_binSpat
thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[457]};% aSum256QuatC_binSpat

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[465 466]};% trf_numel violation
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[468 471]};% bin6Deg poor
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[472 473]};% sf weird

thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[475]};% trf_numel violation.....
thrV = [-Inf 0.02 3]; cellBoundary={'trialRange',[477 482]};% bin6Deg poor sort

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[503 504]};% trf

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[522]};% trf

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[534]};% trf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[536 541]};% bin6Deg not useful..
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[542 543]};% sf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[557 558]};% sfFF
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[547 551]};% trf

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[552]};% trf


thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[579]};% trf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[581]};% sf
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[583 589]};% bin6Deg
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[590]};% sf

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[604]};%trf not enough
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[610 613]};%ffgwn maybe not visual? unclear
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[618 620]};%contrast512 a really cool cell
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[640 642]};% bin6Deg 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[625 627]};% aSum256FullC_manual 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[629 630]};% aSum256QuatC_manual 

thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[638]};% trf 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[640 645]};% bin6Deg 
thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[646]};% sfFF 

thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[650 651]};% trf 
thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[653]};% sf
thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[655 659]};% bin6Deg
thrV = [-Inf 0.2 3]; cellBoundary={'trialRange',[660 661]};% aSum256FullC_binSpat

% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[683]};% trf 
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[685]};% sfFF 
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[687 689]};% bin6Deg bad

% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[708]};% trf
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[710]};% sfFF
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[712 716]};% bin6Deg messed up cell! but RF on the screen
% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[717 718]};% aSum256FullC_binSpat

% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[722]};% trf 100X
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[724]};% sf
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[726 728]};% bin6Deg
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[730 731]};% a256FullC
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[733 734]};% a256QuatC
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[736]};% a256QuatC

% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[741 742]};% trf
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[744]};% sfFF

% thrV = [-Inf 0.05 1]; cellBoundary={'trialRange',[750 752]};% trf

% thrV = [-Inf 0.05 1]; cellBoundary={'trialRange',[776]};% trf


% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[789 790]};% trf 
% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[792]};% sfFF 
% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[794 798]};% bin6Deg 
% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[799]};% aSum256FullC_binSpat 
% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[801]};% aSum256QuatC_binSpat 
% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[803 804]};% aSum128FullC_binSpat 
% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[806 807]};% aSum128QuatC_binSpat 
% thrV = [-Inf 0.03 3]; cellBoundary={'trialRange',[809]};% aSum128HalfC_binSpat weird!!
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[812 820]};% bin3Deg

% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[823]};% trf
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[825]};% sfFF
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[827 830]};% bin6Deg
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[831 833]};% aSum256FullC_binSpat
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[835 836]};% aSum256QuatC_binSpat
% thrV = [-Inf 0.05 3]; cellBoundary={'trialRange',[840 844]};% bin3Deg
% 
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[854]};% trf
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[856]};% sfFF
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[865]};% aSum
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[858 863]};% bin6Deg ehhh

% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[869 870]};% trf
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[872]};% sfFF
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[874 875]};% bin6Deg ehhh

% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[909 911]};% trf
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[913 914]};% sfFF
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[918 920]};% bin6Deg unclear
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[918 922]};% bin6Deg unclear
% thrV = [-Inf 0.1 3]; cellBoundary={'trialRange',[929 934]};% bin6Deg ehhhh


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
    
    analysisMode = 'onlyInspectInteractive';
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

