function db=flushAnalysisData(db)
if ~exist('IDs','var')
    IDs=1:db.numNeurons;
end
fprintf('database has %d analysess. flushing them all... update to reload',db.numAnalyses)
for i=IDs
    fprintf('.\n%d - ',i)
    db.data{i}=db.data{i}.flushAnalysisData;
end
end