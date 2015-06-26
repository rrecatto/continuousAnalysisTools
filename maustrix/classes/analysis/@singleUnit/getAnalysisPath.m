function path=getAnalysisPath(s)
folderName=s.getAnalysisSubFolder(s.trials);
path=fullfile(s.subjectDataPath,'analysis',folderName);
end
