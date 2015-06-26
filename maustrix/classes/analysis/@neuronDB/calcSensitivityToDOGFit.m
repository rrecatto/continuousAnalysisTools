function db = calcSensitivityToDOGFit(db,which,params)
[aInd nID subAInd]=selectIndexTool(db,which,params);
for i = 1:length(nID)
    try
        fprintf('n:%d a:%d\n',nID(i),subAInd(i));
        s = calcSensitivityToDOGFit(db.data{nID(i)}.analyses{subAInd(i)});
        sU = replaceAnalysis(db.data{nID(i)},subAInd(i),s);
        db = replaceUnit(db,nID(i),sU);
        action = sprintf('finished sensitivity for n%da%d',nID(i),subAInd(i));
        params = [];
        db = db.registerAction(action,params); 
        db.save;
    catch ex
%         keyboard
%         rethrow(ex);
        
        action = sprintf('skipping sensitivity for n%da%d',nID(i),subAInd(i));
        params = [];
        params.ex = ex;
        db = db.registerAction(action,params);
    end
end
display('............done............');
end