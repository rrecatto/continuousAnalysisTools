function  s=flushAnalysisData(s)
for i=1:length(s.analyses)
    s.analyses{i}=flushAnalysis(s.analyses{i});
end
end