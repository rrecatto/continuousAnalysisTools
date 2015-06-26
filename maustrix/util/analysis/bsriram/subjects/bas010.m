%% bas009
subjectID = 'bas010';
standardParams = fullfile(getRatrixPath,'analysis','bsriram','analysisParameters','params_11_29_2012.m');
% standardParams = 'C:\Documents and Settings\rlab\Desktop\ratrix\analysis\bsriram\analysisParameters\params_11_11_2010.m';

channels={1}; 
%% 29 Nov 2012
% %unit1
thrV = [-0.01 0.5 2]; cellBoundary={'trialRange',[1]};% trf good sort
thrV = [-0.01 0.5 2]; cellBoundary={'trialRange',[4 5]};% trf good sort
% 
% thrV = [-0.01 0.5 2]; cellBoundary={'trialRange',[7]};% or tuning
% 
% thrV = [-0.01 0.5 2]; cellBoundary={'trialRange',[9]};% ffflashing
% 
% %changed to quartz
thrV = [-0.01 0.5 2]; cellBoundary={'trialRange',[15]};% ffflashing
thrV = [-inf 0.02 2]; cellBoundary={'trialRange',[16]};% oriwentatuion
% 
% thrV = [-0.01 0.5 2]; cellBoundary={'trialRange',[36]};% orientation
% thrV = [-0.01 0.5 2]; cellBoundary={'trialRange',[35]};% orientation
% 
% thrV = [-0.5 0.01 2]; cellBoundary={'trialRange',[40]};% orientation
% 
% thrV = [-0.5 0.01 2]; cellBoundary={'trialRange',[42]};% orientation
% 
% thrV = [-0.5 0.03 2]; cellBoundary={'trialRange',[43]};% orientation

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

