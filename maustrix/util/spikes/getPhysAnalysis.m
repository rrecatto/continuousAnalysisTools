function physAnalysis = getPhysAnalysis(analysisPath,parameters)
physAnalysisFile = fullfile(analysisPath,'physAnalysis.mat');
switch parameters.analysisMode
    case {'overwriteAll','viewAnalysisOnly'} 
        % the relevant files are most probably the ones from the current
        % analysis range. no special checks necessary
        if exist(physAnalysisFile,'file')
            temp = stochasticLoad(physAnalysisFile,{'physAnalysis'});
            physAnalysis = temp.physAnalysis;
        else
            physAnalysis = {};
        end
    case {'onlyAnalyze','onlySort','onlySortNoInspect'}
        % if ~enableChunkedPhysAnalysis just check for trialNum else check
        % for both trial and chunkID else just return whats in path
        if ~enableChunkedPhysAnalysis(parameters.stimManager) &&...
                (parameters.boundaryRange(1)==parameters.trialNum)
            physAnalysis = {};
        elseif enableChunkedPhysAnalysis(parameters.stimManager) &&...
                (parameters.boundaryRange(1)==parameters.trialNum) &&...
                (parameters.boundaryRange(2)==parameters.chunkID)
            physAnalysis = {};
        else
            if exist(physAnalysisFile,'file')
                temp = stochasticLoad(physAnalysisFile,{'physAnalysis'});
                physAnalysis = temp.physAnalysis;
            else
                error('it should never come here...hmm');
            end
        end
    otherwise
        error('unsupported analysisMode');
end
end