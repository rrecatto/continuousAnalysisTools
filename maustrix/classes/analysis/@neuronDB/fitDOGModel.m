function db = fitDOGModel(db,which,params)
if ~exist('which','var')||isempty(which)
    which = 1:db.numNeurons;
end
if ~exist('params','var')||isempty(params)
    params = struct;
end

[~, nID subAInd]=selectIndexTool(db,which,params);
for i = 1:length(nID)
    try
%         f = figure; ax = axes;
%         plot2ax(db.data{nID(i)}.analyses{subAInd(i)},ax,{'f1'});
        
%         rC_UB = input('rC upper bound : ');
%         
%         if isempty(rC_UB)
%             rC_UB = Inf;
%         end
% %         rS_LB = input('rS lower bound : ');
%         if isempty(rS_LB)
%             rS_LB = 0;
%         end
        rC_UB = Inf;
        rS_LB = 0;
        constraints.rC_UB = rC_UB;
        constraints.rS_LB = rS_LB;
        
%         close(f);
% keyboard
fprintf('analysis %dof %d\n',i,length(nID))
        s = fitDOGModel(db.data{nID(i)}.analyses{subAInd(i)},constraints);
        sU = replaceAnalysis(db.data{nID(i)},subAInd(i),s);
        db = replaceUnit(db,nID(i),sU);
    catch ex
%         keyboard
%         rethrow(ex);
        
        action = sprintf('skipping dogFitting for n%da%d',nID(i),subAInd(i));
        params = [];
        params.ex = ex;
        db = db.registerAction(action,params);
    end
end
display('............done............');
end

% function rc_UB = getCenterUB(n)
% nID = [1]
% rc_UBs= []
% end