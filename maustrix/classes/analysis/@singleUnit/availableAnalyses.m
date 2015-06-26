function out = availableAnalyses(s)
out = {};
for i = 1:length(s.analyses)
    out{i} = getType(s.analyses{i});
end
end %availableAnalyses