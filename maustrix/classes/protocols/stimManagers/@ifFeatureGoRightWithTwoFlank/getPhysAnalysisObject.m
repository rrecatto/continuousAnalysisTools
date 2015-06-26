function out = getPhysAnalysisObject(sm,subject,tr,channels,dataPath,stim,c)
if ~exist('c','var')||isempty(c)
    c = struct([]);
end
out = fkrAnalysis(subject,tr,channels,dataPath,stim,c);
end