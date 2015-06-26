function out = getAnalysis(s,type)
if nargin==1
    type = 'all';
    which = ones(size(s.analyses));
else
    which = ismember(s.analysisType,type);
end
out.analyses = s.analyses(which);
out.analysisType = s.analysisType(which);
end