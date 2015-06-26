function plotOne(db,which)
[aInd nID subAInd]=d.selectIndexTool(which);

for i=1:length(aInds)
    figure;
    methods(db.data{nID(i)}.analyses{subAInd(i)})
    db.data{nID(i)}.analyses{subAInd(i)}.plot
end
end
