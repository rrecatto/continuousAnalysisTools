function COSYNE2011_plotSFExamples
%%
whichAwake = [5 16 13 14 ];
whichAnesth = [27 29 36 41];
params = [];
params.anesthColor = 'r';
params.defaultColor = 'r';
params.color = 'r';
% params.cosyneMode = 'onlyVertical';
params.includeNIDs = whichAwake;
params.deleteDupIDs = true;
p.colorAnesthDifferently = true
figs = db.plotByAnalysis({{'sfGratings','F1'},p});
% settings.fontSize=25;
% cleanUpFigure(figs,settings)
end
