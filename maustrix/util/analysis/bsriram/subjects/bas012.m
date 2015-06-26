%% bas012
subjectID = 'bas012';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_11_29_2012.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1}; 
%% 29 Nov 2012
% %unit1
thrV = [-0.01 0.5 2]; cellBoundary={'trialRange',[1]};% trf good sort


analysisMode = 'onlyDetectAndSort';
%% ideas for analysisMode implemented
% analysisMode = 'overwriteAll';
% analysisMode = 'onlyAnalyze';
% analysisMode = 'viewAnalysisOnly'; 
% analysisMode = 'onlyDetect';
% analysisMode = 'onlySort';
% analysisMode = 'onlyDetectAndSort';
% analysisMode = 'onlyInspect';
analysisMode = 'onlyInspectInteractive';
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

