function out = getPhysAnalysisObject(sm,subject,tr,channels,dataPath,stim,c,mon,rigState)

if ~exist('c','var')||isempty(c)
    c = struct([]);
end
out = grAnalysis(subject,tr,channels,dataPath,stim,c,mon,rigState);
end