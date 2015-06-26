function radGrating_figs(db)
if ~exist('db','var')||isempty(db)
    db = neuronDB('bsPaper1');
end

%% plot them all
whichID = 1:db.numNeurons;
whichID = 61:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID = 3;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID = 12;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID = 14;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID = 16;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID = 17;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID = 18;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID = 22;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID = 26;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
%% one by one
whichID =33;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'radiiGratings','f1'},params});
end