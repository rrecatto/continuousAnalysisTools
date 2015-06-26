%%
params = [];
params.anesthColor = 'r';
params.defaultColor = 'b';
params.color = 'b';
params.colorAnesthDifferently = true;
params.excludeNIDs = 29;
figs = db.plotByAnalysis({{'orGratings','F1'},params});