function out = getPhysAnalysisObject(sm,subject,tr,channels,dataPath,stim,c,monitor,rigState)
if ~exist('c','var')||isempty(c)
    c = struct([]);
end
out = ffAnalysis(subject,tr,channels,dataPath,stim,c,monitor,rigState);
end