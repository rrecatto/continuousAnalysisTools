function [overwriteAll onlyAnalyze viewAnalysisOnly onlyDetect onlySort onlyDetectAndSort onlyInspect onlyInspectInteractive] = sst(varargin)
%run('C:\Documents and Settings\rlab\Desktop\ratrix\analysis\spike sorting\setupParamsForAnalysis.m')
overwriteAll = 'overwriteAll';
onlyAnalyze = 'onlyAnalyze';
viewAnalysisOnly = 'viewAnalysisOnly'; 
onlyDetect = 'onlyDetect';
onlySort = 'onlySort';
onlyDetectAndSort = 'onlyDetectAndSort';
onlyInspect = 'onlyInspect';
onlyInspectInteractive = 'onlyInspectInteractive';
if nargin>0
    setupParamsForAnalysis(varargin{1});
else
    setupParamsForAnalysis;
end