function [rate subsTypes] = getFiringRate(s,analysisType)
if ischar('analysisType')&&strcmp(analysisType,'all')
    whichAnalyses = true(1,length(s.analysisType));
elseif iscell(analysisType)
    whichAnalyses = ismember(s.analysisTypes,analysisType);
end
subs = s.analyses(whichAnalyses);
subsTypes = s.analysisType(whichAnalyses);
rate = nan(1,length(subs));
for i = 1:length(subs)
    rate(i)=getFiringRate(s.analyses{i});
end
end