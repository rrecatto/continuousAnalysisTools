function db = calcLFP(db,which,params)
[aInd nID subAInd]=selectIndexTool(db,which,params);
for i = 1:length(nID)
    try
        db.data{nID(i)}.analyses{subAInd(i)}.calcLFP(params);
    catch ex
        action = sprintf('skipping calcLFP for n%da%d',nID(i),subAInd(i));
        params = [];
        params.ex = ex;
        db = db.registerAction(action,params);
    end
end
display('............done............');
end