function prevRange = findPrevAnalysisFolder(recordsPath,subjectID,boundaryRange,params)
searchDir = fullfile(recordsPath.analysisLoc,subjectID,'analysis');

switch params.mode
    case 'extraTrialsAtEnd'
        
    otherwise
        error('unknown mode');
end

end