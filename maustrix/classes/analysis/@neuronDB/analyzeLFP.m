function figs = analyzeLFP(db,which,params)
[aInd nID subAInd]=selectIndexTool(db,which,params);
figs = [];
for i = 1:length(nID)
    figHan = figure;
    figs(end+1) = figHan;
    analysisParams.handle = figHan;
    db.data{nID(i)}.analyses{subAInd(i)}.analyzeLFP(analysisParams);
    filename = sprintf('n%da%d.png',nID(i),subAInd(i));
    print(figHan,fullfile('F:\LFP\',filename),'-dpng','-r300');
end

display('............done............');
end