function out = getPhysAnalysisObject(sm,subject,trials,channels,dataPath,stim,c)
        %      getPhysAnalysisObject(sm,s.subject,trials,chans,dataPath,physRecords,c);
if ~exist('c','var')||isempty(c)
    c = struct([]);
end
out = physiologyAnalysis(subject,trials,channels,dataPath,stim,c);
end