function paper1_figure2(db)
if ~exist('db','var')||isempty(db)
    db = neuronDB({'bsPaper1','latest'});
end
%% fig 2a entire screen
whichID = 1:db.numNeurons;
% whichID = [9];
% whichID = [2 8 9 10 12 13 15 16 17 18];
% whichID = [65 68 82 83];

% allF1 = getFacts(db,{{'sfGratings',{{'f1','f1SEM'},'all'}},params});

whichIDFullyAcceptedNew = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];
whichIDPartAcceptedNew = [7 11 12 19 22 26 27 29 34 35 36 37 41 42 51 56 58 61];
whichIDFullyAcceptedOld = [8 9 12 13 15 16 17]+63;
whichIDPartAcceptedOld = [2 10]+63;
goods = 26;
oks = 22;

whichIDFull = [whichIDFullyAcceptedNew whichIDFullyAcceptedOld];
whichIDPart = [whichIDPartAcceptedNew whichIDPartAcceptedOld];

params = [];
params.includeNIDs = [whichIDFull whichIDPart];
params.deleteDupIDs = false;
params.includeNIDs = 1:db.numNeurons;
% params.includeNIDs = [3 34 72];


% figs = db.plotByAnalysis({{'sfGratings','f1'},params});
% figs = db.plotByAnalysis({{'sfGratings','f2'},params});
% figs = db.plotByAnalysis({{'sfGratings','f1f0'},params});
% figs = db.plotByAnalysis({{'sfGratings','f0'},params});
% figs = db.plotByAnalysis({{'sfGratings','f2f1'},params});
figs = db.plotByAnalysis({{'sfGratings','f1'},params});
% figs = db.plotByAnalysis({{'sfGratings','raster'},params});

%% if you want to plot specal curves
fs = 1./(degPerPix*allF1.results{2}{1}{1});
m=allF1.results{2}{1}{2};
sem=allF1.results{2}{2}{2};
plot(log(fs),m,'color','k','marker','d','markerfacecolor','k'); hold on;
for i = 1:length(m)
    plot([log(fs(i)) log(fs(i))],[m(i)-sem(i) m(i)+sem(i)] ,'k','linewidth',2);
end

whichFit = 2;
balChosen = fitOutput(1).fit(whichFit).chosenRF;
subChosen = fitOutput(4).fit(whichFit).chosenRF;
supraChosen = fitOutput(2).fit(whichFit).chosenRF;
chosen = subChosen;
fsRange = minmax(fs);

stim.FS = linspace(fsRange(1),fsRange(2),100);
stim.m = 0.5;
stim.c = 1;

temp = rfModel(chosen,stim,'1D-DOG-useSensitivity-analytic');
    
% figure;
plot(log(stim.FS),squeeze(temp.f1)+min(m),'linewidth',3);
set(gca,'FontSize',20,'FontName','FontinSans','XTick',sort(log(fs)),'Ytick',[0:10:50]);

%% plot all the f curves for a cell
whichID = [9];
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
allFs = getFacts(db,{{'sfGratings',{{'f0','f0SEM','f1','f1SEM','f2','f2SEM'},'all'}},params});


distToMonitor = 200;
monitorWidth = 405;
xPix = 1024;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

whichResult = 2;

f0s = allFs.results{whichResult}{1}{2};
f0SEMs = allFs.results{whichResult}{2}{2};
f1s = allFs.results{whichResult}{3}{2};
f1SEMs = allFs.results{whichResult}{4}{2};
f2s = allFs.results{whichResult}{5}{2};
f2SEMs = allFs.results{whichResult}{6}{2};
fs = 1./(allFs.results{whichResult}{1}{1}*degPerPix);

figure; 
subplot(3,1,1);hold on;
col = [0.1 0.1 0.1];
plot(log10(fs),f0s,'color',col,'marker','d','markerFaceColor',col,'markersize',5);
for i = 1:length(f0s)
    plot([log10(fs(i)) log10(fs(i))],[f0s(i)-f0SEMs(i) f0s(i)+f0SEMs(i)],'color',col,'linewidth',3);
end
ylims = get(gca,'ylim')
set(gca,'xtick',[],'ylim',[0,ylims(2)]);
    
subplot(3,1,2);hold on;
col = 'b';
plot(log10(fs),f1s,'color',col,'marker','d','markerFaceColor',col,'markersize',5);
for i = 1:length(f1s)
    plot([log10(fs(i)) log10(fs(i))],[f1s(i)-f1SEMs(i) f1s(i)+f1SEMs(i)],'color',col,'linewidth',3);
end
set(gca,'xtick',[]);

subplot(3,1,3);hold on;
col = 'g';
plot(log10(fs),f2s,'color',col,'marker','d','markerFaceColor',col,'markersize',5);
for i = 1:length(f2s)
    plot([log10(fs(i)) log10(fs(i))],[f2s(i)-f2SEMs(i) f2s(i)+f2SEMs(i)],'color',col,'linewidth',3);
end
set(gca,'xtick',[min(log10(fs)) max(log10(fs))],'xticklabel',{'0.01','0.14'});

%% plot the distributions of f0,f1,f2
db = neuronDB({'bsPaper1','latestOldAC'});
whichID = [2 8 9 10 12 13 15 16 17 18];
params.includeNIDs = whichID;
params.deleteDupIDs = true;
allFs = getFacts(db,{{'sfGratings',{{'f0','f1','f2'},'all'}},params});
resultOld.nIDs = allFs.nID;
resultOld.subAInds = allFs.subAInd;
for i = 1:length(resultOld.nIDs)
    resultOld.maxF0(i) = max(allFs.results{i}{1}{2});
    resultOld.maxF1(i) = max(allFs.results{i}{2}{2});
    resultOld.maxF2(i) = max(allFs.results{i}{3}{2});
    whichF1 = allFs.results{i}{2}{2}==max(allFs.results{i}{2}{2});
    resultOld.F0MaxF1(i) = allFs.results{i}{1}{2}(whichF1);
    resultOld.F2MaxF1(i) = allFs.results{i}{3}{2}(whichF1);
end



db = neuronDB({'bsPaper1','latestNewAC'});
whichID = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57 7 11 12 19 22 26 27 29 34 35 36 37 38 41 42 51 56 58 61]
params.includeNIDs = whichID;
params.deleteDupIDs = true;
allFs = getFacts(db,{{'sfGratings',{{'f0','f1','f2'},'all'}},params});
resultNew.nIDs = allFs.nID;
resultNew.subAInds = allFs.subAInd;
for i = 1:length(resultNew.nIDs)
    resultNew.maxF0(i) = max(allFs.results{i}{1}{2});
    resultNew.maxF1(i) = max(allFs.results{i}{2}{2});
    resultNew.maxF2(i) = max(allFs.results{i}{3}{2});
    whichF1 = allFs.results{i}{2}{2}==max(allFs.results{i}{2}{2});
    resultNew.F0MaxF1(i) = allFs.results{i}{1}{2}(whichF1);
    resultNew.F2MaxF1(i) = allFs.results{i}{3}{2}(whichF1);
end
f0s = [resultOld.maxF0 resultNew.maxF0];
f1s = [resultOld.maxF1 resultNew.maxF1];
f2s = [resultOld.maxF2 resultNew.maxF2];
edgesF0 = linspace(0,40,40); diffF0 = min(diff(edgesF0));
edgesF1 = linspace(0,40,40); diffF1 = min(diff(edgesF1));
edgesF2 = linspace(0,40,40); diffF2 = min(diff(edgesF2));
nF0s = histc(f0s*60,edgesF0);
nF1s = histc(f1s,edgesF1);
nF2s = histc(f2s,edgesF2);

subplot(3,1,1);
bar(edgesF0+diffF0,nF0s,'edgecolor','none','facecolor','k');
set(gca,'ylim',[0 40]);
subplot(3,1,2);
bar(edgesF1+diffF1,nF1s,'edgecolor','none','facecolor','b');
set(gca,'ylim',[0 40]);
subplot(3,1,3);
bar(edgesF2+diffF2,nF2s,'edgecolor','none','facecolor','g');
set(gca,'ylim',[0 40]);

%% model cell
stim.FS = logspace(log10(0.01),log10(3),100);
stim.m = 0.5;
stim.c = 1;

rf.RC = 1;
rf.RS = 3;
rf.KC = 1;
rf.KS = 1/9;

%only center
rf.KS = 0;temp = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
figure; hold on;
plot(log(stim.FS),squeeze(temp.f1),'r','linewidth',5);

%surr subbal
rf.KC = 0;
rf.KS = 1/18;temp = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1),'b','linewidth',5);

%surr bal
rf.KS = 1/9;temp = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1),'b','linewidth',5);

%surr supbal
rf.KS = 1/4;temp = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1),'b','linewidth',5);

set(gca,'xtick',[min(log(stim.FS)) max(log(stim.FS))],'ytick',[])
ylims = [0 4.5];

figure;
% subbal
subplot(3,1,1); hold on;
rf.KC = 1;
rf.KS = 1/18;temp = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1),'color',[0.5 0.5 0.5],'linewidth',5);
set(gca,'xtick',[min(log(stim.FS)) max(log(stim.FS))],'xticklabel',{'',''},'ylim',ylims,'ytick',[])

% bal
subplot(3,1,2); hold on;
rf.KC = 1;
rf.KS = 1/9;temp = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1),'color',[0.5 0.5 0.5],'linewidth',5);
set(gca,'xtick',[min(log(stim.FS)) max(log(stim.FS))],'xticklabel',{'',''},'ylim',ylims,'ytick',[])

% supbal
subplot(3,1,3); hold on;
rf.KC = 1;
rf.KS = 1/4;temp = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1),'color',[0.5 0.5 0.5],'linewidth',5);
set(gca,'xtick',[min(log(stim.FS)) max(log(stim.FS))],'xticklabel',{'0.01','3'},'ylim',ylims,'ytick',[])

%% fit for all the conditions
distToMonitor = 200;
monitorWidth = 405;
xPix = 1024;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

distToMonitor = 300;
monitorWidth = 571.5;
xPix = 1920;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;



whichAnalysis = 5;
fs = 1./(degPerPix*allFs.results{whichAnalysis}{2}{1});
f1 = allFs.results{whichAnalysis}{2}{2};


fsRange = minmax(fs);

stim.FS = linspace(fsRange(1),fsRange(2),100);
stim.m = 0.5;
stim.c = 1;

    


% subbalanced
subplot(3,1,1); hold on;
plot(log(fs),f1,'kd','markersize',10,'markerfacecolor','k');
set(gca,'xtick',[min(log(fs)) max(log(fs))],'xticklabel',{'0.01','0.14'},'ytick',[0 40],...
    'fontname','Fontin Sans','fontsize',30,'xlim',[-0.1+min(log(fs)) max(log(fs))+0.1]);
rfSub = fitOutput(4).fit(whichAnalysis).chosenRF;
temp = rfModel(rfSub,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1)+min(f1),'linewidth',3,'color','r');

% balanced
subplot(3,1,2); hold on;
plot(log(fs),f1,'kd','markersize',10,'markerfacecolor','k');
set(gca,'xtick',[min(log(fs)) max(log(fs))],'xticklabel',{'0.01','0.14'},'ytick',[0 40],...
    'fontname','Fontin Sans','fontsize',30,'xlim',[-0.1+min(log(fs)) max(log(fs))+0.1]);
rfBal = fitOutput(1).fit(whichAnalysis).chosenRF;
temp = rfModel(rfBal,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1)+min(f1),'linewidth',3,'color',[1 0 1]);

% suprabalanced
subplot(3,1,3); hold on;
plot(log(fs),f1,'kd','markersize',10,'markerfacecolor','k');
set(gca,'xtick',[min(log(fs)) max(log(fs))],'xticklabel',{'0.01','0.14'},'ytick',[0 40],...
    'fontname','Fontin Sans','fontsize',30,'xlim',[-0.1+min(log(fs)) max(log(fs))+0.1]);
rfSup = fitOutput(2).fit(whichAnalysis).chosenRF;
temp = rfModel(rfSup,stim,'1D-DOG-useSensitivity-analytic');
plot(log(stim.FS),squeeze(temp.f1)+min(f1),'linewidth',3,'color','b');

%% modulation only
figure;
f1f0 = f1s./(60*f0s);
edgesF1F0 = linspace(0,0.3,20); diffF1F0 = min(diff(edgesF1F0));
nF1F0 = histc(f1f0,edgesF1F0);
bar(edgesF1F0+diffF1F0,nF1F0,'edgecolor','none','facecolor','k');
set(gca,'xlim',[0 0.5],'ylim',[0 7]);
%% nonlinearness only
figure;
f2f1 = f2s./f1s;
edgesF2F1 = linspace(0,1.1,20); diffF2F1 = min(diff(edgesF2F1));
nF2F1 = histc(f2f1,edgesF2F1);
bar(edgesF2F1+diffF2F1,nF2F1,'edgecolor','none','facecolor','k');
set(gca,'xlim',[0 1.2],'ylim',[0 10]);
%% fig 2a1 entire screen
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'sfGratings','f1'},params});

%% fig 2b cpd peak f1
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
params.maxValAndLocForAllLessThan = 512;
peakF1 = getFacts(db,{{'sfGratings',{'f1','maxValueAndLoc'}},params});
peakF1s = nan(1,length(peakF1.results));
valForPeak = nan(size(peakF1s));
for i = 1:length(peakF1.results)
    peakF1s(i) = peakF1.results{i}{1}{2};
    valForPeak(i) = peakF1.results{i}{1}{1};
end
xPix = 1920;
monitorWidth = 571.5; monitorHeight = 480;
distToMonitor = 300;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;
figure;
% subplot(2,1,1);
hist(peakF1s,20);
% subplot(2,1,2);
% hist(degPerPix*valForPeak);

%% 
allF1 = getFacts(db,{{'sfGratings',{{'f1','f1SEM'},'all'}},params});
plot(1./(degPerPix*allF1.results{1}{1}{1}),allF1.results{1}{1}{2})

%%  sfFitting without using sensitivity
clc
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;

allF1 = getFacts(db,{{'sfGratings',{{'f1','f1SEM'},'all'}},params});

temp.allF1 = allF1;
distToMonitor = 300;
monitorWidth = 571.5;
xPix = 1920;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

algosToUse = {'fmincon-surroundMuchLargerThanCenter-subbalanced','fmincon-surroundMuchLargerThanCenter-balanced','fmincon-surroundMuchLargerThanCenter-suprabalanced'};
% algosToUse = {'fmincon-penalizeSimilarRadii'};
fitOutput = struct;
for currAlgoNum = 1:length(algosToUse)
    currFitOutput = struct;
    currFitOutput.rc = [];
    currFitOutput.rs = [];
    currFitOutput.eta = [];
    currFitOutput.a = [];
    currFitOutput.fval = [];
    currFitOutput.flag = [];
    
    
    for i = 1:length(temp.allF1.results)
        exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
        exampleF1 = temp.allF1.results{i}{1}{2};
        exampleF1SEM = temp.allF1.results{i}{2}{2};
        sub = min(exampleF1);
        
        %     plot(exampleFs,exampleF1);
        in = struct;
        in.fs = exampleFs;
        in.f1 = exampleF1-sub;
        in.SEM = exampleF1SEM;
        in.model = '1D-DOG-analytic';
        in.initialGuessMode = 'preset-2-withJitter';
        in.errorMode = 'sumOfSquares';%'sumOfSquares','SEMWeightedSumOfSquares'
        in.doExitCheck = true;
        in.searchAlgorithm = algosToUse{currAlgoNum};
        %'fmincon','fminsearch','fmincon-balanced','fmincon-suprabalanced','fmincon-subbalanced','fmincon-notsubbalanced','fmincon-surroundMuchLargerThanCenter'
        % 'fmincon-surroundMuchLargerThanCenter-subbalanced','fmincon-surroundMuchLargerThanCenter-balanced','fmincon-surroundMuchLargerThanCenter-suprabalanced'
        numRepeats = 100;
        for j = 1:numRepeats
            fprintf('%d of %d,%d:',i,length(temp.allF1.results),j);
            [out fval flag] = sfDOGFit(in);
            
            currFitOutput(i).rc(j) = out(1);
            currFitOutput(i).rs(j) = out(2);
            currFitOutput(i).eta(j) = out(3);
            currFitOutput(i).a(j) = out(4);
            currFitOutput(i).fval(j) = fval;
            currFitOutput(i).flag(j) = flag;            
        end
        [junk which] = min([currFitOutput(i).fval]);
        rf = struct;
        rf.RC = currFitOutput(i).rc(which);
        rf.RS = currFitOutput(i).rs(which);
        rf.ETA = currFitOutput(i).eta(which);
        rf.A = currFitOutput(i).a(which);
        rf.fval = currFitOutput(i).fval(which);
        rf.flag = currFitOutput(i).flag(which);
        
        currFitOutput(i).chosenRF = rf;
        
        stim.FS = in.fs;        
        stim.m = 0.5;
        stim.c = 1;

        rf.thetaMin = -10;
        rf.thetaMax = 10;
        rf.dTheta = 0.1;
        
        modelOut = rfModel(rf,stim,'1D-DOG-analytic');
        modelF1 = squeeze(modelOut.f1);
        corrtemp = corrcoef(modelF1,in.f1);
        currFitOutput(i).chosenRF.quality = corrtemp(2);
    end
    fitOutput(currAlgoNum).algoName = algosToUse{currAlgoNum};
    fitOutput(currAlgoNum).fit = currFitOutput;
end
%% only plotting
figure;
for i = 1:length(temp.allF1.results)
    exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
    exampleF1 = temp.allF1.results{i}{1}{2};
    exampleF1SEM = temp.allF1.results{i}{2}{2};
    sub = min(exampleF1);

%     in = struct;
%     in.fs = exampleFs;
%     in.f1 = exampleF1-sub;
%     in.SEM = exampleF1SEM;
    subplot(7,10,i); hold on;
    for p = 1:length(exampleFs)
        plot(log(exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
        plot([log(exampleFs(p)) log(exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
    end
    numRepeats = 100;
    % look at all three and choose the best one
    
    qualities = [fitOutput(1).fit(i).chosenRF.quality fitOutput(2).fit(i).chosenRF.quality fitOutput(3).fit(i).chosenRF.quality];
    [junk chosenAlgoNum] = max(qualities);

    rf = fitOutput(chosenAlgoNum).fit(i).chosenRF;    
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    
    
    stim.FS = logspace(log10(min(exampleFs)),log10(max(exampleFs)),70);
    stim.m = 0.5;
    stim.c = 1;
    
    modelOut = rfModel(rf,stim,'1D-DOG-analytic');
    modelF1 = squeeze(modelOut.f1);
    if fitOutput(chosenAlgoNum).fit(i).chosenRF.ETA <0.95
        col = [0 0 1];
    elseif fitOutput(chosenAlgoNum).fit(i).chosenRF.ETA <1.05
        col = [0 1 0];
    else
        col = [1 0 0];
    end
%     switch chosenAlgoNum
%         case 1
%             col = [0 0 1];
%         case 2
%             col = [0 1 0];
%         case 3
%             col = [1 0 0];
%     end
%     
    plot(log(stim.FS),modelF1+sub,'color',col,'LineWidth',2);
    
    neuronText = sprintf('n%da%d',temp.allF1.nID(i),temp.allF1.subAInd(i));
    paramsText = {sprintf('s/c=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.RS/fitOutput(chosenAlgoNum).fit(i).chosenRF.RC),...
        sprintf('e=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.ETA),...
        sprintf('a=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.A)};
    text(0.03,1,neuronText,'units','normalized','HorizontalAlignment','left','VerticalAlignment','top');
    text(1,1,paramsText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','top');
end

%%  sfFitting USING sensitivity new
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
db = db.fitDOGModel('sfGratings',params);
%% sfFitting sensitivity to fit
clc
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
db = db.calcSensitivityToDOGFit('sfGratings',params);


%%  sfFitting USING sensitivity old
clc
whichID = 1:db.numNeurons;
% whichID = [9,12,15,16,2,5,8,10,13,14,18,20];
whichID = [9];
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;

allF1 = getFacts(db,{{'sfGratings',{{'f1','f1SEM'},'all'}},params});

temp.allF1 = allF1;
% distToMonitor = 300;
% monitorWidth = 571.5;
% xPix = 1920;
% mmPerPix = monitorWidth/xPix;
% degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

distToMonitor = 200;
monitorWidth = 405;
xPix = 1024;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

algosToUse = {'fmincon-surroundMuchLargerThanCenter-subbalanced','fmincon-surroundMuchLargerThanCenter-balanced','fmincon-surroundMuchLargerThanCenter-suprabalanced'};
% algosToUse = {'fmincon-penalizeSimilarRadii'};
algosToUse = {'fmincon-useSensitivity'};
algosToUse = {'fmincon-useSensitivity-balanced','fmincon-useSensitivity-suprabalanced','fmincon-useSensitivity','fmincon-useSensitivity-subbalanced'};

fitOutput = struct;
for currAlgoNum = 1:length(algosToUse)
    currFitOutput = struct;
    currFitOutput.rc = [];
    currFitOutput.rs = [];
    currFitOutput.eta = [];
    currFitOutput.a = [];
    currFitOutput.fval = [];
    currFitOutput.flag = [];
    
    
    for i = 1:length(temp.allF1.results)
        exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
        exampleF1 = temp.allF1.results{i}{1}{2};
        exampleF1SEM = temp.allF1.results{i}{2}{2};
        sub = min(exampleF1);
        
        %     plot(exampleFs,exampleF1);
        in = struct;
        in.fs = exampleFs;
        in.f1 = exampleF1-sub;
        in.SEM = exampleF1SEM;
        in.model = '1D-DOG-useSensitivity-analytic';
        in.initialGuessMode = 'preset-1-useSensitivity-withJitter';
%         in.errorMode = 'penalize-(Ks-Kc)-(rs-rc)-rc-Kc-product';%'sumOfSquares','SEMWeightedSumOfSquares'
        in.errorMode = 'sumOfSquares';
        in.doExitCheck = true;
        in.searchAlgorithm = algosToUse{currAlgoNum};
        %'fmincon','fminsearch','fmincon-balanced','fmincon-suprabalanced','fmincon-subbalanced','fmincon-notsubbalanced','fmincon-surroundMuchLargerThanCenter'
        % 'fmincon-surroundMuchLargerThanCenter-subbalanced','fmincon-surroundMuchLargerThanCenter-balanced','fmincon-surroundMuchLargerThanCenter-suprabalanced'
        numRepeats = 100;
        for j = 1:numRepeats
            fprintf('%d of %d,%d:',i,length(temp.allF1.results),j);
            [out fval flag] = sfDOGFit(in);
            
            currFitOutput(i).rc(j) = out(1);
            currFitOutput(i).rs(j) = out(2);
            currFitOutput(i).kc(j) = out(3);
            currFitOutput(i).ks(j) = out(4);
            currFitOutput(i).fval(j) = fval;
            currFitOutput(i).flag(j) = flag;            
        end
        [junk which] = min([currFitOutput(i).fval]);
        rf = struct;
        rf.RC = currFitOutput(i).rc(which);
        rf.RS = currFitOutput(i).rs(which);
        rf.KC = currFitOutput(i).kc(which);
        rf.KS = currFitOutput(i).ks(which);
        rf.fval = currFitOutput(i).fval(which);
        rf.flag = currFitOutput(i).flag(which);
        
        currFitOutput(i).chosenRF = rf;
        
        stim.FS = in.fs;        
        stim.m = 0.5;
        stim.c = 1;

        rf.thetaMin = -10;
        rf.thetaMax = 10;
        rf.dTheta = 0.1;
        
        modelOut = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
        modelF1 = squeeze(modelOut.f1);
        corrtemp = corrcoef(modelF1,in.f1);
        currFitOutput(i).chosenRF.quality = corrtemp(2);
    end
    fitOutput(currAlgoNum).algoName = algosToUse{currAlgoNum};
    fitOutput(currAlgoNum).fit = currFitOutput;
end
%% only plotting
figure; hold on;set(gcf,'Position',[98 84 1211 1004]);
whichAnalyses = 1:length(temp.allF1.results);%[38];
% whichAnalyses = [38 36 32 3];%[38];
for num_i = 1:length(whichAnalyses)%length(temp.allF1.results)
    i = whichAnalyses(num_i);
    exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
    exampleF1 = temp.allF1.results{i}{1}{2};
    exampleF1SEM = temp.allF1.results{i}{2}{2};
    sub = min(exampleF1);

%     in = struct;
%     in.fs = exampleFs;
%     in.f1 = exampleF1-sub;
%     in.SEM = exampleF1SEM;
    subplot(7,10,num_i); hold on;
%     subplot(4,5,num_i); hold on;

% subplot(2,2,num_i); hold on;
    for p = 1:length(exampleFs)
        plot(log10(exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
        plot([log10(exampleFs(p)) log10(exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
%         plot((exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
%         plot([(exampleFs(p)) (exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
%         semilogx((exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
%         semilogx([(exampleFs(p)) (exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
    end
    plot(log10(exampleFs),exampleF1,'k');
    numRepeats = 100;
    % look at all three and choose the best one
    
    qualities = nan(1,length(length(fitOutput)));
    for j = 1:length(fitOutput)
        qualities(j) = fitOutput(j).fit(i).chosenRF.quality;
    end
    [junk chosenAlgoNum] = max(qualities);

    rf = fitOutput(chosenAlgoNum).fit(i).chosenRF;    
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    
    
    stim.FS = logspace(log10(min(exampleFs)),log10(max(exampleFs)),70);
    stim.m = 0.5;
    stim.c = 1;
    
    modelOut = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
    modelF1 = squeeze(modelOut.f1);
%     
%     if fitOutput(chosenAlgoNum).fit(i).chosenRF.ETA <0.95
%         col = [0 0 1];
%     elseif fitOutput(chosenAlgoNum).fit(i).chosenRF.ETA <1.05
%         col = [0 1 0];
%     else
%         col = [1 0 0];
%     end

% col = [0 0 1];
    switch chosenAlgoNum
        case 1
            col = [0 0 1];
        case 2
            col = [0 1 0];
        case 3
            col = [1 0 0];
    end
%     
    plot(log10(stim.FS),modelF1+sub,'color',col,'LineWidth',2);
    
    xLabs = get(gca,'XTickLabel');
    newLabs = {};
    for labNum = 1:size(xLabs,1)
        newLabs{labNum} = sprintf('%2.3f',(10^(str2double(xLabs(labNum,:)))));
    end
    set(gca,'xTickLabel',newLabs)
%     semilogx((stim.FS),modelF1+sub,'color',col,'LineWidth',2);
%     plot((stim.FS),modelF1+sub,'color',col,'LineWidth',2);
%     axis tight
%     neuronText = sprintf('n%da%d',temp.allF1.nID(i),temp.allF1.subAInd(i));
    qualityText = sprintf('%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.quality);
%     paramsText = {sprintf('s/c=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.RS/fitOutput(chosenAlgoNum).fit(i).chosenRF.RC),...
%         sprintf('ks/kc=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.KS/fitOutput(chosenAlgoNum).fit(i).chosenRF.KC),...
%          sprintf('kc=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.KC)};
    currETA = (fitOutput(chosenAlgoNum).fit(i).chosenRF.KS*(fitOutput(chosenAlgoNum).fit(i).chosenRF.RS^2))/(fitOutput(chosenAlgoNum).fit(i).chosenRF.KC*(fitOutput(chosenAlgoNum).fit(i).chosenRF.RC^2));
        paramsText = {sprintf('s=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.RS),...
        sprintf('c=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.RC),...
         sprintf('e=%2.2f',currETA)};
%     text(0.03,1,neuronText,'units','normalized','HorizontalAlignment','left','VerticalAlignment','top');
    text(1,1,paramsText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','top','FontSize',12);
    text(1,0,qualityText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',12);
    
end

%% choose the best algorithm 
whichAlgos = {fitOutput.algoName};
whichNew = ismember(whichAlgos,'fmincon-useSensitivity-suprabalanced');
whichOthers = ismember(whichAlgos,{'fmincon-useSensitivity-balanced','fmincon-useSensitivity-subbalanced'});
fitNew = fitOutput(whichNew);
fitOthers = fitOutput(whichOthers);
fitBestFromOthers = struct;
% choose the best from others
for i = 1:length(fitOthers(1).fit)
    if fitOthers(1).fit(i).chosenRF.quality>fitOthers(2).fit(i).chosenRF.quality
        fitBestFromOthers.fit(i) = fitOthers(1).fit(i);
    else
        fitBestFromOthers.fit(i) = fitOthers(2).fit(i);
    end
end

% plot improvement
figure; hold on;
for i = 1:length(fitBestFromOthers.fit)
    plot(fitBestFromOthers.fit(i).chosenRF.quality,fitNew.fit(i).chosenRF.quality,'kd','MarkerFaceColor','k');
end
plot([0 1],[0 1],'k');

% now plot which is chosen
minImprovement = 0.05;
figure; hold on;
fitQuals = [];

for i = 1:length(fitBestFromOthers.fit)
    if (fitNew.fit(i).chosenRF.quality-fitBestFromOthers.fit(i).chosenRF.quality)<minImprovement
        plot(fitBestFromOthers.fit(i).chosenRF.quality,fitNew.fit(i).chosenRF.quality,'kd','MarkerFaceColor','k');
        fitQuals(end+1) = fitBestFromOthers.fit(i).chosenRF.quality;
    else
        plot(fitBestFromOthers.fit(i).chosenRF.quality,fitNew.fit(i).chosenRF.quality,'rd','MarkerFaceColor','r');
        fitQuals(end+1) = fitNew.fit(i).chosenRF.quality;
    end
end
plot([0 1],[0 1],'k');

% choose the bestAlgo of them all
bestFitAll = struct;
for i = 1:length(fitBestFromOthers.fit)
    if (fitNew.fit(i).chosenRF.quality-fitBestFromOthers.fit(i).chosenRF.quality)<minImprovement
        bestFitAll.fit(i) = fitBestFromOthers.fit(i);
    else
        bestFitAll.fit(i) = fitNew.fit(i);
    end
end

%% plot the fits
for num_i = 1:length(whichAnalyses)%length(temp.allF1.results)
    i = whichAnalyses(num_i);
    exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
    exampleF1 = temp.allF1.results{i}{1}{2};
    exampleF1SEM = temp.allF1.results{i}{2}{2};
    sub = min(exampleF1);

%     subplot(7,10,num_i); hold on;
    subplot(4,4,num_i); hold on;

    for p = 1:length(exampleFs)
        plot(log10(exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
        plot([log10(exampleFs(p)) log10(exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
    end
    plot(log10(exampleFs),exampleF1,'k');
    

    rf = bestFitAll.fit(i).chosenRF;    
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    
    
    stim.FS = logspace(log10(min(exampleFs)),log10(max(exampleFs)),70);
    stim.m = 0.5;
    stim.c = 1;
    
    modelOut = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
    modelF1 = squeeze(modelOut.f1);

    % color scheme based on eta
    currETA = (bestFitAll.fit(i).chosenRF.KS*(bestFitAll.fit(i).chosenRF.RS^2))/(bestFitAll.fit(i).chosenRF.KC*(bestFitAll.fit(i).chosenRF.RC^2));
    
    if currETA<0.95
        col = [1 0 0];
    elseif currETA<1.05
        col = [0 1 0];
    else
        col = [0 0 1];
    end

    
    plot(log10(stim.FS),modelF1+sub,'color',col,'LineWidth',2);
    
    xLabs = get(gca,'XTickLabel');
    newLabs = {};
%     for labNum = 1:size(xLabs,1)
%         newLabs{labNum} = sprintf('%2.3f',(10^(str2double(xLabs(labNum,:)))));
%     end
%     set(gca,'xTickLabel',newLabs)

    qualityText = sprintf('%2.2f',bestFitAll.fit(i).chosenRF.quality);
    paramsText = {sprintf('s/c=%2.2f',bestFitAll.fit(i).chosenRF.RS/fitOutput(chosenAlgoNum).fit(i).chosenRF.RC),...
        sprintf('eta=%2.2f',currETA)};
%     text(0.03,1,neuronText,'units','normalized','HorizontalAlignment','left','VerticalAlignment','top');
    text(1,1,paramsText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','top','FontSize',12);
    text(1,0,qualityText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',12);
    
end

%% plot parameterDistributions
figure;
RCs = nan(1,length(bestFitAll.fit));
RSs = RCs;
ETAs = RCs;
for i = 1:length(bestFitAll.fit)
    RCs(i) = bestFitAll.fit(i).chosenRF.RC;
    RSs(i) = bestFitAll.fit(i).chosenRF.RS;
    
   
    ETAs(i) = (bestFitAll.fit(i).chosenRF.KS*(bestFitAll.fit(i).chosenRF.RS^2))/(bestFitAll.fit(i).chosenRF.KC*(bestFitAll.fit(i).chosenRF.RC^2));
end
subplot(2,1,1);
% for i = 1:length(RCs)
whichBlue = ETAs>1.05;
whichGreen = ETAs>0.95 & ETAs<=1.05;
whichRed = ETAs<0.95;

plot(RCs(whichBlue),RSs(whichBlue),'bd','MarkerFaceColor','b');hold on;
plot(RCs(whichGreen),RSs(whichGreen),'gd','MarkerFaceColor','g');hold on;
plot(RCs(whichRed),RSs(whichRed),'rd','MarkerFaceColor','r');hold on;
% end
xlim([min((RCs)) max((RCs))]);
ylim([min((RCs)) max((RCs))]);
plot([min((RCs)) max((RCs))],[min((RCs)) max((RCs))],'k','LineWidth',2)
subplot(2,1,2);
figure;
hist(log10(ETAs),40);title('log(ETA)')
figure;
hist(RCs);title('RC hist');
figure;
hist(fitQuals,20); title('fitQuals')
%% what do the receptive fields look like?
figure; hold on;set(gcf,'Position',[98 84 1211 1004]);
whichAnalyses = 1:length(temp.allF1.results);%[38];
% whichAnalyses = [38 36 32 3];%[38];
for num_i = 1:length(whichAnalyses)%length(temp.allF1.results)
    i = whichAnalyses(num_i);
    exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
    exampleF1 = temp.allF1.results{i}{1}{2};
    exampleF1SEM = temp.allF1.results{i}{2}{2};
    sub = min(exampleF1);

    subplot(7,10,num_i); hold on;
% subplot(2,2,num_i); hold on;
%     for p = 1:length(exampleFs)
%         plot(log10(exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
%         plot([log10(exampleFs(p)) log10(exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
% %         plot((exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
% %         plot([(exampleFs(p)) (exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
% %         semilogx((exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
% %         semilogx([(exampleFs(p)) (exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
%     end
%     plot(log10(exampleFs),exampleF1,'k');
    numRepeats = 100;
    % look at all three and choose the best one
    
    qualities = nan(1,length(length(fitOutput)));
    for j = 1:length(fitOutput)
        qualities(j) = fitOutput(j).fit(i).chosenRF.quality;
    end
    [junk chosenAlgoNum] = max(qualities);

    rf = fitOutput(chosenAlgoNum).fit(i).chosenRF;    
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    x = -20:0.1:20;
%     keyboard
    C = rf.KC*exp(-x.*x/(rf.RC*rf.RC));
    S = rf.KS*exp(-x.*x/(rf.RS*rf.RS));
    
    switch chosenAlgoNum
        case 1
            col = [0 0 1];
        case 2
            col = [0 1 0];
        case 3
            col = [1 0 0];
        case 4
            col = [0 0 0];
    end
    plot(x,C-S,'color',col,'LineWidth',3)
    
%     neuronText = sprintf('n%da%d',temp.allF1.nID(i),temp.allF1.subAInd(i));
%     qualityText = sprintf('%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.quality);
    paramsText = {sprintf('s/c=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.RS/fitOutput(chosenAlgoNum).fit(i).chosenRF.RC),...
        sprintf('ks/kc=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.KS/fitOutput(chosenAlgoNum).fit(i).chosenRF.KC),...
         sprintf('rc=%2.2f',fitOutput(chosenAlgoNum).fit(i).chosenRF.RC)};
%     text(0.03,1,neuronText,'units','normalized','HorizontalAlignment','left','VerticalAlignment','top');
    text(1,1,paramsText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','top','FontSize',12);
    text(1,0,qualityText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',12);
    
end

%% rf curation
% include = logical([...
%     1 1 1 1 1 1 1 1 1 1,...
%     1 1 1 0 1 1 1 1 1 1,...
%     0 0 1 0 1 1 1 1 1 1,...
%     1 1 1 1 1 1 1 1 1 1,...
%     1 1 1 1 0 1 1 1 1 1,...
%     1 1 1 1 1 1 1 0 1 1,...
%     1 0 1 1 1 0 1 1]);
% nID = ([...
%     1 1 3 3 4 5 5 6 6 7,...
%     7 7 9 10 11 12 14 16 16 17,...
%     19 20 22 22 23 24 25 26 26 27,...
%     29 30 30 31 32 32 33 34 35 36,...
%     37 38 38 39 40 41 42 43 44 45,...
%     46 47 48 49 51 51 52 52 54 56,...
%     56 56 57 57 58 61 63 63]);


include = logical([...
    1 1 1 1 1 1 1 1 1 1,...
    1 1 1 1 1]);
nID = ([...
    1 1 3 3 4 5 5 6 6 7,...
    7 7 9 10 11 12 14 16 16 17,...
    19 20 22 22 23 24 25 26 26 27,...
    29 30 30 31 32 32 33 34 35 36,...
    37 38 38 39 40 41 42 43 44 45,...
    46 47 48 49 51 51 52 52 54 56,...
    56 56 57 57 58 61 63 63]);


whichAnalysesInc = whichAnalyses(include);
nIDInc = allF1.nID(include);
subAIndInc = allF1.subAInd(include);
fitOutputInc = fitOutput;
for i = 1:length(fitOutputInc)
    fitOutputInc(i).fit = fitOutputInc(i).fit(include);
end

% chosenAnalysis = [...
%     1 2 2 2 2 1 4 4 4 2,...
%     2 2 4 2 2 2 2 2 4 4,...
%     4 4 2 1 4 2 4 4 4 1,...
%     1 4 4 1 2 2 2 2 4 2,...
%     4 4 2 2 4 1 2 4 1 4,...
%     2 4 2 4 4 4 4 2 4 2];

chosenAnalysis = [...
    1 4 4 2 2 1 1 1 2 2,...
    2 1 2 2 2];
chosenAnalysis = [...
    4 4 2 1 4 1 1 2 2 4,...
    1 2 2 2 4];

bestFit = struct;%.fit(length(find(include)))
for i = 1:length(find(include))
    bestFit.fit(i) = fitOutputInc(chosenAnalysis(i)).fit(i);
end
tempInc.allF1Inc.nIDInc = nIDInc;
tempInc.allF1Inc.subAIndInc = subAIndInc;
tempInc.allF1Inc.resultsInc = temp.allF1.results(include);
nID = nID(include);
%% plot fits
for num_i = 1:length(whichAnalysesInc)%length(temp.allF1.results)
%     i = whichAnalysesInc(num_i);
    i = num_i;
    exampleFs = 1./(tempInc.allF1Inc.resultsInc{i}{1}{1}*degPerPix);
    exampleF1 = tempInc.allF1Inc.resultsInc{i}{1}{2};
    exampleF1SEM = tempInc.allF1Inc.resultsInc{i}{2}{2};
    sub = min(exampleF1);

    subplot(3,5,num_i); title(sprintf('n%d',nID(num_i))); hold on;
    for p = 1:length(exampleFs)
        plot(log10(exampleFs(p)),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
        plot([log10(exampleFs(p)) log10(exampleFs(p))],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
    end
    plot(log10(exampleFs),exampleF1,'k');
    

    rf = bestFit.fit(i).chosenRF;    
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    
    
    stim.FS = logspace(log10(min(exampleFs)),log10(max(exampleFs)),70);
    stim.m = 0.5;
    stim.c = 1;
    
    modelOut = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
    modelF1 = squeeze(modelOut.f1);

    % color scheme based on eta
    currETA = (bestFit.fit(i).chosenRF.KS*(bestFit.fit(i).chosenRF.RS^2))/(bestFit.fit(i).chosenRF.KC*(bestFit.fit(i).chosenRF.RC^2));
    
    if currETA<0.95
        col = [1 0 0];
    elseif currETA<1.05
        col = [0 1 0];
    else
        col = [0 0 1];
    end

    
    plot(log10(stim.FS),modelF1+sub,'color',col,'LineWidth',2);
    
    xLabs = get(gca,'XTickLabel');
    newLabs = {};
    for labNum = 1:size(xLabs,1)
        newLabs{labNum} = sprintf('%2.3f',(10^(str2double(xLabs(labNum,:)))));
    end
    set(gca,'xTickLabel',newLabs)

    qualityText = sprintf('%2.2f',bestFit.fit(i).chosenRF.quality);
    paramsText = {sprintf('c=%2.2f',bestFit.fit(i).chosenRF.RC),...
        sprintf('s=%2.2f',bestFit.fit(i).chosenRF.RS),...
        sprintf('eta=%2.2f',currETA)};
%     text(0.03,1,neuronText,'units','normalized','HorizontalAlignment','left','VerticalAlignment','top');
    text(1,1,paramsText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','top','FontSize',12);
    text(1,0,qualityText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom','FontSize',12);
    
end
%% what do the receptive fields look like?
figure; hold on;set(gcf,'Position',[98 84 1211 1004]);

for num_i = 1:length(whichAnalysesInc)%length(temp.allF1.results)
    i = num_i;
    subplot(6,10,num_i)
    rf = bestFit.fit(i).chosenRF;    
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    x = -20:0.1:20;
%     keyboard
    C = rf.KC*exp(-x.*x/(rf.RC*rf.RC));
    S = rf.KS*exp(-x.*x/(rf.RS*rf.RS));
    
    currETA = (bestFit.fit(i).chosenRF.KS*(bestFit.fit(i).chosenRF.RS^2))/(bestFit.fit(i).chosenRF.KC*(bestFit.fit(i).chosenRF.RC^2));
    
    if currETA<0.95
        col = [1 0 0];
    elseif currETA<1.05
        col = [0 1 0];
    else
        col = [0 0 1];
    end
    
    plot(x,C-S,'color',col,'LineWidth',3)
    
    paramsText = {sprintf('s/c=%2.2f',bestFit.fit(i).chosenRF.RS/bestFit.fit(i).chosenRF.RC),...
         sprintf('rc=%2.2f',bestFit.fit(i).chosenRF.RC)};
%     text(0.03,1,neuronText,'units','normalized','HorizontalAlignment','left','VerticalAlignment','top');
    text(1,1,paramsText,'units','normalized','HorizontalAlignment','right','VerticalAlignment','top','FontSize',12);
end

%% plot distributions
fits = [bestFit.fit];
fits = [fits.chosenRF];
RCs = [fits.RC];
RSs = [fits.RS];
KCs = [fits.KC];
KSs = [fits.KS];
ETAs = (KSs.*RSs.*RSs)./(KCs.*RCs.*RCs);

rngETAs = minmax(log10(ETAs));
edges = linspace(rngETAs(1),rngETAs(2),20);
histETAs= histc(log10(ETAs),edges);
bar(edges,histETAs);
hold on;
mL10ETAs = mean(log10(ETAs));
sL10ETAs = std(log10(ETAs))/sqrt(60);
plot(mL10ETAs,40 ,'kd','MarkerSize',5,'MarkerFaceColor','k');
plot([mL10ETAs-2*sL10ETAs mL10ETAs+2*sL10ETAs],[40 40],'k','LineWidth',3);
plot([-0.125 -0.125],[10 15],'k','LineWidth',3);
axis([-1,1,0,50]);

%% RCs
figure;
hist(RCs,20)

%% RC vs RS
figure;
plot(RCs,RSs,'kd','MarkerFaceColor','k'); hold on;
plot([0 max(RCs)],[0 max(RCs)],'k','LineWidth',3);
axis([0 max(RCs) 0 max(RCs)])

%% compare RFs across analyses
% get the WN analysis here
WNData = load('C:\Documents and Settings\Owner\My Documents\Dropbox\wnAnalysisForComp.mat');
SFData.nID = tempInc.allF1Inc.nIDInc;
SFData.subAInd = tempInc.allF1Inc.subAIndInc;
SFData.RCs = RCs;
SFData.RSs = RSs;
SFData.KCs = KCs;
SFData.KSs = KSs;
figure;hold on;
wnSizes = [];
sfSizes = [];
nIDsForComp = [];
for i = 1:max([WNData.nID SFData.nID])
    % is the nID in both?
    existWN = ismember(i,WNData.nID);
    existSF = ismember(i,SFData.nID);
    if ~(existWN && existSF)
        continue;
    end
%     keyboard
    whichWN = find(ismember(WNData.nID,i));
    whichSF = find(ismember(SFData.nID,i));
    
    wnSizeCurr = mean(WNData.xSizes(whichWN));
    sfSizeCurr = mean(SFData.RCs(whichSF));
    wnSizes(end+1) = wnSizeCurr;
    sfSizes(end+1) = sfSizeCurr;
    nIDsForComp(end+1) = i;
    plot(wnSizeCurr,sfSizeCurr,'kd','MarkerFaceColor','k');
    text(wnSizeCurr+0.1,sfSizeCurr,sprintf('%d',i));
end
plot([0 max([wnSizes sfSizes])],[0 max([wnSizes sfSizes])],'k','LineWidth',3);

%% is corrcoef significant?
figure;ax = axes;
nSamples=10000;
corrCoeff=nan(1,nSamples);
numAnalyses =length(wnSizes);


for i = 1:nSamples
    xThisSample = wnSizes(randperm(numAnalyses));
    yThisSample = sfSizes(randperm(numAnalyses));
    coefThis = corrcoef(xThisSample,yThisSample);
    corrCoeff(i) = coefThis(1,2);
end
[n,x]=hist(corrCoeff,100);
actualCorr = corrcoef(wnSizes,sfSizes);
actualCorr = actualCorr(1,2);
hold on;
histfill = fill([x fliplr(x)],[n/nSamples zeros(1,length(n))],'b');
plot([actualCorr actualCorr],[0 .01],'r');
bads = [9 37 36 38 26 41 42 57];
whichX = (x>actualCorr);
pValue = sum(n(whichX)/nSamples);
pText = sprintf('p=%2.3f',pValue);

text(actualCorr,0.011,pText,'HorizontalAlignment','center','VerticalAlignment','bottom');

%% compare only highQ
whichNIDs = ~ismember(nIDsForComp,bads);
wnSizesHQ = wnSizes(whichNIDs); sfSizesHQ = sfSizes(whichNIDs);



figure;ax = axes;
nSamples=10000;
corrCoeff=nan(1,nSamples);
numAnalyses =length(wnSizesHQ);


for i = 1:nSamples
    xThisSample = wnSizesHQ(randperm(numAnalyses));
    yThisSample = sfSizesHQ(randperm(numAnalyses));
    coefThis = corrcoef(xThisSample,yThisSample);
    corrCoeff(i) = coefThis(1,2);
end
[n,x]=hist(corrCoeff,100);
actualCorr = corrcoef(wnSizesHQ,sfSizesHQ);
actualCorr = actualCorr(1,2);
hold on;
histfill = fill([x fliplr(x)],[n/nSamples zeros(1,length(n))],'b');
plot([actualCorr actualCorr],[0 .01],'r');
whichX = (x>actualCorr);
pValue = sum(n(whichX)/nSamples);
pText = sprintf('p=%2.3f',pValue);

text(actualCorr,0.011,pText,'HorizontalAlignment','center','VerticalAlignment','bottom');

%% calcLFP
whichID = 6:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
% allF1 = getFacts(db,{{'sfGratings',{{'f1','f1SEM'},'all'}},params});

db = db.calcLFP('sfGratings',params);
%  db.analyzeLFP('sfGratings',params);
%% plotting shit with new database
whichIDFullyAcceptedNew = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];
whichIDPartAcceptedNew = [7 11 12 19 22 26 27 29 34 35 36 37 41 42 51 56 58 61];
whichIDFullyAcceptedOld = [8 9 12 13 15 16 17]+63;
whichIDPartAcceptedOld = [2 10]+63;
goods = 26;
oks = 22;

whichIDFull = [whichIDFullyAcceptedNew whichIDFullyAcceptedOld];
whichIDPart = [whichIDPartAcceptedNew whichIDPartAcceptedOld];



whichID = whichIDFull;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = true;
figs1 = db.plotByAnalysis({{'sfGratings','f1'},params});

whichID = whichIDPart;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = true;
figs2 = db.plotByAnalysis({{'sfGratings','f1'},params});
%% get sf details
whichID = [whichIDFull whichIDPart];
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = true;
figs1 = db.plotByAnalysis({{'sfGratings','f1'},params});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555

%% paper1_JoV

%% autocorr
db = neuronDB({'bsPaper2','latest_autocorr'});
whichIDFullyAcceptedNew = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];
whichIDPartAcceptedNew = [7 11 12 19 22 26 27 29 34 35 36 37 41 42 51 56 58 61];
whichIDFullyAcceptedOld = [8 9 12 13 15 16 17]+63;
whichIDPartAcceptedOld = [2 10]+63;

whichIDFull = [whichIDFullyAcceptedNew whichIDFullyAcceptedOld];
whichIDPart = [whichIDPartAcceptedNew whichIDPartAcceptedOld];

params = [];
params.includeNIDs = [whichIDFull whichIDPart];
params.includeNIDs = 1:db.numNeurons;
params.deleteDupIDs = false;

figs = db.plotByAnalysis({{'sfGratings','f1'},params});

%% fft
db = neuronDB({'bsPaper2','latest_fft'});
whichIDFullyAcceptedNew = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];
whichIDPartAcceptedNew = [7 11 12 19 22 26 27 29 34 35 36 37 41 42 51 56 58 61];
whichIDFullyAcceptedOld = [8 9 12 13 15 16 17]+63;
whichIDPartAcceptedOld = [2 10]+63;

whichIDFull = [whichIDFullyAcceptedNew whichIDFullyAcceptedOld];
whichIDPart = [whichIDPartAcceptedNew whichIDPartAcceptedOld];

params = [];
params.includeNIDs = [whichIDFull whichIDPart];
params.includeNIDs = 1:db.numNeurons;
params.deleteDupIDs = false;

figs = db.plotByAnalysis({{'sfGratings','f1'},params});

%% chronux
db = neuronDB({'bsPaper2','latest_chronux'});
whichIDFullyAcceptedNew = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];
whichIDPartAcceptedNew = [7 11 12 19 22 26 27 29 34 35 36 37 41 42 51 56 58 61];
whichIDFullyAcceptedOld = [8 9 12 13 15 16 17]+63;
whichIDPartAcceptedOld = [2 10]+63;

whichIDFull = [whichIDFullyAcceptedNew whichIDFullyAcceptedOld];
whichIDPart = [whichIDPartAcceptedNew whichIDPartAcceptedOld];

params = [];
params.includeNIDs = [whichIDFull whichIDPart];
params.includeNIDs = 1:db.numNeurons;
params.deleteDupIDs = false;

figs = db.plotByAnalysis({{'sfGratings','f1-addedf0'},params});


%% distribution of f1/f0
whichIDFullyAcceptedNew = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];
whichIDPartAcceptedNew = [7 11 12 19 22 26 27 29 34 35 36 37 41 42 51 56 58 61];
whichIDFullyAcceptedOld = [8 9 12 13 15 16 17]+63;
whichIDPartAcceptedOld = [2 10]+63;

whichIDFull = [whichIDFullyAcceptedNew whichIDFullyAcceptedOld];
whichIDPart = [whichIDPartAcceptedNew whichIDPartAcceptedOld];

params = [];
params.includeNIDs = [whichIDFull whichIDPart];