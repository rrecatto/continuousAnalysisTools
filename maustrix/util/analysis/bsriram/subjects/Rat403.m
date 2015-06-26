%% 403
subjectID = '403';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_01_06_2011.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1}; 
%% 8 Nov 2010
% %unit1
% thrV = [-Inf 0.5 2]; cellBoundary={'trialRange',[7 11]};% trf good sort



analysisMode = 'onlyDetectAndSort';
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
addCurrentAnalysis = true;
analysis = runAnalysis('subjectID',subjectID,'channels',channels,'thrV',thrV,'cellBoundary',cellBoundary,...
    'standardParams',standardParams,'analysisMode',analysisMode,'forceNoInspect',forceNoInspect,...
    'intelligentUpdate',intelligentUpdate,'addCurrentAnalysis',addCurrentAnalysis);

