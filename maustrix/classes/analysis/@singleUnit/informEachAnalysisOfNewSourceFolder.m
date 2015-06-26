function s=informEachAnalysisOfNewSourceFolder(s)
folderName=s.getAnalysisSubFolder(s.trials);
for i=1:length(s.analyses)
    s.analyses{i}.sourceFolder=folderName;
end
end