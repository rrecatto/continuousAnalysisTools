function db=updateAnalyses(db,IDs)
if ~exist('IDs','var') || (ischar('IDs')&&strcmp(IDs,'all'))
    IDs=1:db.numNeurons;
end
fprintf('database has %d analysess. currently doing %d neurons',db.numAnalyses,length(IDs))
for i=IDs
    fprintf('.\n%d - ',i)
    db.data{i}=db.data{i}.updateAnalyses;
end
end