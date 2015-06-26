function x=getAnalysisFacts(s,facts)
%a structure with all the values
if ~exist('facts','var') || isempty(facts)
    facts={'analysisType','thresholdVoltage','quality','included'};
end
for j=1:length(facts)
    x.(facts{j})=s.(facts{j});
end
end