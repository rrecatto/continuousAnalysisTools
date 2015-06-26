%% get data and fit
nID = 34;
sfAnalysisNum = 1;
temp = db.data{nID}.analyses{sfAnalysisNum};
temp1 = temp.fitDOGModel;

%% plots
f = figure; ax = axes;hold on;
params.col = 'k';
plot2ax(temp1,ax,{'f1',params})

stim.FS = logspace(log10(0.01),log10(0.4),100);
stim.m = 0.5;
stim.c = 1;
rf = temp1.model.DOGFit.fitValues{3}.chosenRF;
FSCen = 1/(2*rf.RC);
FSSur = 1/(2*rf.RS);
ylims = get(ax,'ylim');
plot([FSCen FSCen],ylims,'r');
plot([FSSur FSSur],ylims,'b');

out = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
plot(out.FS,squeeze(out.f1),'k','linewidth',2)

rfCen = rf;
rfCen.KS = 0;
outCen = rfModel(rfCen,stim,'1D-DOG-useSensitivity-analytic');
plot(outCen.FS,squeeze(outCen.f1),'r','linewidth',2);

rfSurr = rf;
rfSurr.KC = 0;
outSurr = rfModel(rfSurr,stim,'1D-DOG-useSensitivity-analytic');
plot(outSurr.FS,squeeze(outSurr.f1),'b','linewidth',2)


%%  modelCell
rfMod.RC = 2;
rfMod.RS = 8;
rfMod.KC = 1;
rfMod.KS = 0.125;
f = figure; ax = axes; hold on;
outMod = rfModel(rfMod,stim,'1D-DOG-useSensitivity-analytic');
plot(outMod.FS,squeeze(outMod.f1),'k','linewidth',2)

FSCen = 1/(2*rfMod.RC);
FSSur = 1/(2*rfMod.RS);
ylims = get(ax,'ylim');
plot([FSCen FSCen],ylims,'r');
plot([FSSur FSSur],ylims,'b');

rfModCen = rfMod;
rfModCen.KS = 0;
outModCen = rfModel(rfModCen,stim,'1D-DOG-useSensitivity-analytic');
plot(outModCen.FS,squeeze(outModCen.f1),'r','linewidth',2);

rfModSur = rfMod;
rfModSur.KC = 0;
outModSur = rfModel(rfModSur,stim,'1D-DOG-useSensitivity-analytic');
plot(outModSur.FS,squeeze(outModSur.f1),'b','linewidth',2)

%% fit DOG for all

whichIDFullyAcceptedNew = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];
whichIDPartAcceptedNew = [7 11 12 19 22 26 27 29 34 35 36 37 41 42 51 56 58 61];
whichIDFullyAcceptedOld = [8 9 12 13 15 16 17]+63;
whichIDPartAcceptedOld = [2 10]+63;

whichIDFull = [whichIDFullyAcceptedNew whichIDFullyAcceptedOld];
whichIDPart = [whichIDPartAcceptedNew whichIDPartAcceptedOld];

params = [];
params.includeNIDs = [whichIDFull whichIDPart];
params.deleteDupIDs = false;

db = db.fitDOGModel('sfGratings',params);
