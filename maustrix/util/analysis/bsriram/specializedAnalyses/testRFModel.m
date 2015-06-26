rf.thetaMin = -10;
rf.thetaMax = 10;
rf.dTheta = 0.1;
rf.RC = 1;
rf.RS = 3;
rf.ETA = 0.5;
rf.A = 1;

stim.FS = logspace(log10(0.01),log10(0.5),70);
stim.m = 0.5;
stim.c = 1;

tic 
out1D = rfModel(rf,stim,'1D-DOG');
toc

tic
out1Danalytic = rfModel(rf,stim,'1D-DOG-analytic');
toc

% tic
% out2Dconv = rfModel(rf,stim,'2D-DOG-conv');
% toc
% 
% tic
% out2Dloop = rfModel(rf,stim,'2D-DOG-loop');
% toc


% figure;
% out2D1 = squeeze(out2Dconv.f1);
% out2D2 = squeeze(out2Dloop.f1);
out1D1 = squeeze(out1D.f1);
out1D1a = squeeze(out1Danalytic.f1);
%% plotting
for i = 1:length(rf.ETA)
    subplot(1,1,i); hold on;
    plot(out1D.FS,out1D1/max(out1D1),'k');
    plot(out1Danalytic.FS,out1D1a/max(out1D1a)+0.01,'k');
%     plot(out2Dconv.FS,0.01+out2D1/max(out2D1),'b','LineStyle','-');
%     plot(out2Dloop.FS,0.01+out2D2/max(out2D2),'b','LineStyle','--');
end

%% sfDOGFitting
% create a model cell
rf.thetaMin = -10;
rf.thetaMax = 10;
rf.dTheta = 0.1;
rf.RC = 1;
rf.RS = 3;
rf.ETA = 0.5;
rf.A = 1;

stim.FS = logspace(log10(0.01),log10(0.5),70);
stim.m = 0.5;
stim.c = 1;
out1D = rfModel(rf,stim,'1D-DOG-analytic');

%sample form the actual distribution
fs = out1D.FS;
f1 = out1D1;
maxF1 = max(f1);
percentNoise = 5;
noiseF1 = maxF1*percentNoise/100*randn(size(f1));
which = (rand(1,length(fs))<0.5);
% which = ones(size(which));
in.fs = fs(which);
in.f1 = f1(which)+noiseF1(which); % this is the model data

in.model = '1D-DOG-analytic';
in.initialGuessMode = 'preset-2-withJitter';
in.searchAlgorithm = 'fmincon';
in.errorMode = 'sumOfSquares-penalizeSimilarRadii';%'sumOfSquares','SEMWeightedSumOfSquares'

out = sfDOGFit(in);


rf.thetaMin = -10;
rf.thetaMax = 10;
rf.dTheta = 0.1;
rf.RC = out(1);
rf.RS = out(2);
rf.ETA = out(3);
rf.A = out(4);

stim.FS = logspace(log10(0.01),log10(0.5),70);
stim.m = 0.5;
stim.c = 1;
modelFit = rfModel(rf,stim,'1D-DOG-analytic');
modelFitF1 = squeeze(modelFit.f1);

plot(log(in.fs),in.f1,'b');hold on;

plot(log(modelFit.FS),modelFitF1,'r');
%%
testWhichIsFaster = true;
if testWhichIsFaster
    fs = out1D.FS;
    f1 = out1D1;
    maxF1 = max(f1);
    percentNoise = 5;
    noiseF1 = maxF1*percentNoise/100*randn(size(f1));
    which = (rand(1,length(fs))<0.5);
    in.fs = fs(which);
    in.f1 = f1(which)+noiseF1(which);
    in.model = '1D-DOG';
    in.initialGuessMode = 'preset-2-withJitter';
    in.errorMode = 'sumOfSquares';%'sumOfSquares','SEMWeightedSumOfSquares'
    in.doExitCheck = true;
    in.searchAlgorithm = 'fmincon'; %'fmincon','fminsearch','fmincon-balanced','fmincon-suprabalanced','fmincon-subbalanced'
    
    '1D-DOG'
    tic
    out1 = sfDOGFit(in);
    toc
    
    in.model = '1D-DOG-analytic';
    '1D-DOG-analytic'
    tic
    out2 = sfDOGFit(in);
    toc
end

%% plotting
plot(in.fs,in.f1);hold on;
rf.thetaMin = -10;
rf.thetaMax = 10;
rf.dTheta = 0.1;

rf.RC = out2(1);
rf.RS = out2(2);
rf.ETA = out2(3);
rf.A = out2(4);

stim.FS = in.fs;
stim.m = 0.5;
stim.c = 1;

fitted = rfModel(rf,stim,'1D-DOG-analytic');
plot(fitted.FS,squeeze(fitted.f1),'r');

%% using real data
clc
whichID = 1:db.numNeurons;
% whichID = [1 3 4 5 6 16 29 30 34 35 63];
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
 
searchAlgos = {'balanced','suprabalanced','subbalanced'};
presets = {'preset-1-withJitter','preset-1-withJitter','preset-2-withJitter'};
saveLoc = 'C:\Documents and Settings\Owner\My Documents\Dropbox\sfFitting';
for algNum = 2:length(searchAlgos)
    saveFileName = sprintf('%s.mat',searchAlgos{algNum});
    fitOutput = struct;
    for i = 1:length(temp.allF1.results)
        exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
        exampleF1 = temp.allF1.results{i}{1}{2};
        exampleF1SEM = temp.allF1.results{i}{2}{2};
        sub = min(exampleF1);
        
        %     plot(exampleFs,exampleF1);
        in = struct;
        in.fs = exampleFs; in.f1 = exampleF1-sub; in.SEM = exampleF1SEM;
        in.model = '1D-DOG';
        in.initialGuessMode = presets{algNum};%'preset-1-withJitter','preset-2-withJitter'
        in.errorMode = 'sumOfSquares';%'sumOfSquares','SEMWeightedSumOfSquares'
        in.doExitCheck = true;
        in.searchAlgorithm = sprintf('fmincon-%s',searchAlgos{algNum}); %'fmincon','fminsearch','fmincon-balanced','fmincon-suprabalanced','fmincon-subbalanced'
        
        numRepeats = 100;
        for j = 1:numRepeats
            fprintf('%d of %d,%d:',i,length(temp.allF1.results),j);
            [out fval flag] = sfDOGFit(in);
            fitOutput(i).rc(j) = out(1);
            fitOutput(i).rs(j) = out(2);
            fitOutput(i).eta(j) = out(3);
            fitOutput(i).a(j) = out(4);
            fitOutput(i).fval(j) = fval;
            fitOutput(i).flag(j) = flag;            
        end
    end
    save(fullfile(saveLoc,saveFileName),'fitOutput');
    clear('fitOutput');
end

%             doPlot = false;
%             if doPlot
%                 rf.thetaMin = -10;
%                 rf.thetaMax = 10;
%                 rf.dTheta = 0.1;
%                 
%                 rf.RC = out(1);
%                 rf.RS = out(2);
%                 rf.ETA = out(3);
%                 rf.A = out(4);
%                 
%                 stim.FS = logspace(log10(min(in.fs)),log10(max(in.fs)),70);
%                 stim.m = 0.5;
%                 stim.c = 1;
%                 
%                 fitted = rfModel(rf,stim,'1D-DOG');
%                 subplot(7,10,i);
%                 plot(in.fs,in.f1+sub,'b'); hold on;plot(fitted.FS,squeeze(fitted.f1)+sub,'r');axis tight;
%                 textToPrint = {sprintf('rc=%2.2f',out(1)), sprintf('rs=%2.2f',out(2)),sprintf('e=%2.2f',out(3))};
%                 neuronText = sprintf('n%da%d',temp.allF1.nID(i),temp.allF1.subAInd(i));
%                 text(1,1,textToPrint,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
%                 text(0.5,1,neuronText,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
%             end

%% only plotting
figure;
for i = 1:length(temp.allF1.results)
    exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
    exampleF1 = temp.allF1.results{i}{1}{2};
    exampleF1SEM = temp.allF1.results{i}{2}{2};
    sub = min(exampleF1);

    in = struct;
    in.fs = exampleFs;
    in.f1 = exampleF1-sub;
    in.SEM = exampleF1SEM;
    subplot(4,5,i); hold on;
    for p = 1:length(exampleFs)
        plot(exampleFs(p),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
        plot([exampleFs(p) exampleFs(p)],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
    end
    numRepeats = 100;
    for j = 1:numRepeats
        rf.thetaMin = -10;
        rf.thetaMax = 10;
        rf.dTheta = 0.1;
        
        rf.RC = fitOutput(i).rc(j);
        rf.RS = fitOutput(i).rs(j);
        rf.ETA = fitOutput(i).eta(j);
        rf.A = fitOutput(i).a(j);
        
        stim.FS = logspace(log10(min(in.fs)),log10(max(in.fs)),70);
        stim.m = 0.5;
        stim.c = 1;
        
        fitted = rfModel(rf,stim,'1D-DOG');
        y = squeeze(fitted.f1);
        plot(fitted.FS,y+sub,'r');axis tight;
        %         textToPrint = {sprintf('rc=%2.2f',out(1)), sprintf('rs=%2.2f',out(2)),sprintf('e=%2.2f',out(3))};
        
    end
    neuronText = sprintf('n%da%d',temp.allF1.nID(i),temp.allF1.subAInd(i));
    %         text(1,1,textToPrint,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
    text(0.5,1,neuronText,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
end

%%
figure;
for i = 1:length(temp.allF1.results)
end
%%
figure; 
subplot(3,4,1),hist(fitOutput(1).rc,20);title('rc');
subplot(3,4,2),hist(fitOutput(1).rs,20);title('rs');
subplot(3,4,3),hist(fitOutput(1).eta,20);title('eta');
subplot(3,4,4),hist(fitOutput(1).a,20),title('a');

subplot(3,4,5),hist(fitOutput(2).rc,20);
subplot(3,4,6),hist(fitOutput(2).rs,20);
subplot(3,4,7),hist(fitOutput(2).eta,20);
subplot(3,4,8),hist(fitOutput(2).a,20),

subplot(3,4,9),hist(fitOutput(3).rc,20);
subplot(3,4,10),hist(fitOutput(3).rs,20);
subplot(3,4,11),hist(fitOutput(3).eta,20);
subplot(3,4,12),hist(fitOutput(3).a,20);
%% use modified algorithm
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
fitOutput = struct;
fitOutput.rc = [];
fitOutput.rs = [];
fitOutput.eta = [];
fitOutput.a = [];

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
    in.errorMode = 'SEMWeightedSumOfSquares';%'sumOfSquares','SEMWeightedSumOfSquares'
    in.doExitCheck = true;
    in.searchAlgorithm = 'fmincon-notsubbalanced'; %'fmincon','fminsearch','fmincon-balanced','fmincon-suprabalanced','fmincon-subbalanced','fmincon-notsubbalanced'
    
    numRepeats = 100;
    for j = 1:numRepeats
        fprintf('%d of %d,%d:',i,length(temp.allF1.results),j);
        [out fval flag] = sfDOGFit(in);
        
        doPlot = false;
        if doPlot
            rf.thetaMin = -10;
            rf.thetaMax = 10;
            rf.dTheta = 0.1;
            
            rf.RC = out(1);
            rf.RS = out(2);
            rf.ETA = out(3);
            rf.A = out(4);
            
            stim.FS = logspace(log10(min(in.fs)),log10(max(in.fs)),70);
            stim.m = 0.5;
            stim.c = 1;
            
            fitted = rfModel(rf,stim,'1D-DOG');
            subplot(7,10,i);
            plot(in.fs,in.f1+sub,'b'); hold on;plot(fitted.FS,squeeze(fitted.f1)+sub,'r');axis tight;
            textToPrint = {sprintf('rc=%2.2f',out(1)), sprintf('rs=%2.2f',out(2)),sprintf('e=%2.2f',out(3))};
            neuronText = sprintf('n%da%d',temp.allF1.nID(i),temp.allF1.subAInd(i));
            text(1,1,textToPrint,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
            text(0.5,1,neuronText,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
        end
        fitOutput(i).rc(j) = out(1);
        fitOutput(i).rs(j) = out(2);
        fitOutput(i).eta(j) = out(3);
        fitOutput(i).a(j) = out(4);
        fitOutput(i).fval(j) = fval;
        fitOutput(i).flag(j) = flag;    
        
    end
end
%% only plotting
figure;
for i = 1:length(temp.allF1.results)
    exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
    exampleF1 = temp.allF1.results{i}{1}{2};
    exampleF1SEM = temp.allF1.results{i}{2}{2};
    sub = min(exampleF1);

    in = struct;
    in.fs = exampleFs;
    in.f1 = exampleF1-sub;
    in.SEM = exampleF1SEM;
    subplot(7,10,i); hold on;
    for p = 1:length(exampleFs)
        plot(exampleFs(p),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
        plot([exampleFs(p) exampleFs(p)],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
    end
    numRepeats = 100;
    for j = 1:numRepeats
        rf.thetaMin = -10;
        rf.thetaMax = 10;
        rf.dTheta = 0.1;
        
        rf.RC = fitOutput(i).rc(j);
        rf.RS = fitOutput(i).rs(j);
        rf.ETA = fitOutput(i).eta(j);
        rf.A = fitOutput(i).a(j);
        
        stim.FS = logspace(log10(min(in.fs)),log10(max(in.fs)),70);
        stim.m = 0.5;
        stim.c = 1;
        
        fitted = rfModel(rf,stim,'1D-DOG-analytic');
        y = squeeze(fitted.f1);
        plot(fitted.FS,y+sub,'r');axis tight;
        %         textToPrint = {sprintf('rc=%2.2f',out(1)), sprintf('rs=%2.2f',out(2)),sprintf('e=%2.2f',out(3))};
        
    end
    neuronText = sprintf('n%da%d',temp.allF1.nID(i),temp.allF1.subAInd(i));
    %         text(1,1,textToPrint,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
    text(0.5,1,neuronText,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
end

%% check quality
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;

allF1 = getFacts(db,{{'sfGratings',{{'f1','f1SEM'},'all'}},params});
temp.allF1 = allF1;

constraintFile = 'C:\Documents and Settings\Owner\My Documents\Dropbox\analytic-sumSq-notSub.mat';
noConstraintFile = 'C:\Documents and Settings\Owner\My Documents\Dropbox\analytic-sumSq.mat';
whichFile = noConstraintFile;
clear fitOutput;
load(whichFile);
distToMonitor = 300;
monitorWidth = 571.5;
xPix = 1920;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

for i = 1:length(temp.allF1.results)
    exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
    exampleF1 = temp.allF1.results{i}{1}{2};
    exampleF1SEM = temp.allF1.results{i}{2}{2};
    sub = min(exampleF1);

    in = struct;
    in.fs = exampleFs;
    in.f1 = exampleF1-sub;
    in.SEM = exampleF1SEM;
    subplot(7,10,i); hold on;
    for p = 1:length(exampleFs)
        plot(exampleFs(p),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
        plot([exampleFs(p) exampleFs(p)],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
    end
    numRepeats = 100;
    for j = 1:numRepeats
        rf.thetaMin = -10;
        rf.thetaMax = 10;
        rf.dTheta = 0.1;
        
        rf.RC = fitOutput(i).rc(j);
        rf.RS = fitOutput(i).rs(j);
        rf.ETA = fitOutput(i).eta(j);
        rf.A = fitOutput(i).a(j);
        
        stim.FS =in.fs;
        stim.m = 0.5;
        stim.c = 1;
        
        fitted = rfModel(rf,stim,'1D-DOG-analytic');
        y = squeeze(fitted.f1);
        corrtemp = corrcoef(in.f1,y);
        fitOutput(i).quality(j) = corrtemp(2);
        
    end
    [maxQual which] = max(fitOutput(i).quality); %find the best fit
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    
    rf.RC = fitOutput(i).rc(which);
    rf.RS = fitOutput(i).rs(which);
    rf.ETA = fitOutput(i).eta(which);
    rf.A = fitOutput(i).a(which);
    
    stim.FS = logspace(log10(min(in.fs)),log10(max(in.fs)),70);
    stim.m = 0.5;
    stim.c = 1;
    fitOutput(i).chosen.which = which;
    fitOutput(i).rf = rf;
    fitOutput(i).rf.quality = maxQual;
    fitted = rfModel(rf,stim,'1D-DOG-analytic');
    y = squeeze(fitted.f1);
    
    plot(stim.FS,y+sub,'r');
    
    qualText = sprintf('%2.2f',maxQual);
    %         text(1,1,textToPrint,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
    text(1,1,qualText,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
    
    
end

save(whichFile,'fitOutput');

%% lets look at the phases
allPhases = getFacts(db,{{'sfGratings',{{'phaseDensity'},'all'}},params});
distToMonitor = 300;
monitorWidth = 571.5;
xPix = 1920;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;
tempPhases.allPhases = allPhases;
figure;
fitPhase = struct;
for i = 1:length(tempPhases.allPhases.results)
    subplot(7,10,i);hold on;
    currFs = 1./(tempPhases.allPhases.results{i}{1}{1}*degPerPix);
    currPhase = tempPhases.allPhases.results{i}{1}{2};
    plot(log10(currFs),currPhase-currPhase(end),'b');
    tempPhases.allPhases.results{1}{2} = polyfit(log10(currFs),currPhase,1);
    fitVals = polyval(tempPhases.allPhases.results{1}{2},log10(currFs));
    plot(log10(currFs),fitVals-currPhase(end),'r');
    slope = (fitVals(1)-fitVals(end));
    slopeText = sprintf('%2.2f',slope);
    %         text(1,1,textToPrint,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
    text(1,1,slopeText,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
end

%% compare constraints
noConstraintFile = 'C:\Documents and Settings\Owner\My Documents\Dropbox\analytic-sumSq.mat';
constraintFile = 'C:\Documents and Settings\Owner\My Documents\Dropbox\analytic-sumSq-notSub.mat';

temp = load(noConstraintFile);
noConsFit = temp.fitOutput;
temp = load(constraintFile);
consFit = temp.fitOutput;

noConsRF = [noConsFit.rf];
consRF = [consFit.rf];

noConsETA = [noConsRF.ETA];
consETA = [consRF.ETA];

noConsQual = [noConsRF.quality];
consQual = [consRF.quality];

figure; hold on;

numAnalyses = length(consRF);

for i = 1:numAnalyses
    if noConsETA(i)<2
        col = [1 0 0];
    elseif noConsETA(i)>0.95
        col = 0.5*[1 1 1];
    else
        col = [0 0 1];
    end
    plot(noConsETA(i),noConsQual(i),'d','color',col,'MarkerSize',5,'MarkerFaceColor','k');
    plot(consETA(i),consQual(i),'d','color',col,'MarkerSize',5);
    plot([consETA(i) noConsETA(i)],[consQual(i) noConsQual(i)],'color',col);
end

%% compare constraints
noConstraintFile = 'C:\Documents and Settings\Owner\My Documents\Dropbox\analytic-sumSq.mat';
constraintFile = 'C:\Documents and Settings\Owner\My Documents\Dropbox\analytic-sumSq-notSub.mat';

temp = load(noConstraintFile);
noConsFit = temp.fitOutput;
temp = load(constraintFile);
consFit = temp.fitOutput;

finalSolution = consFit(1);

numAnalyses = length(consFit);
thresholdImprovement = 0.1;
for i = 1:numAnalyses
    if (noConsFit(i).rf.quality-consFit(i).rf.quality)<thresholdImprovement
        finalSolution(i) = consFit(i);
    else
        finalSolution(i) = noConsFit(i);
    end
end


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

for i = 1:length(temp.allF1.results)
    exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
    exampleF1 = temp.allF1.results{i}{1}{2};
    exampleF1SEM = temp.allF1.results{i}{2}{2};
    sub = min(exampleF1);

    in = struct;
    in.fs = exampleFs;
    in.f1 = exampleF1-sub;
    in.SEM = exampleF1SEM;
    subplot(7,10,i); hold on;
    for p = 1:length(exampleFs)
        plot(exampleFs(p),exampleF1(p),'kd','MarkerFaceColor','k','MarkerSize',5);
        plot([exampleFs(p) exampleFs(p)],[exampleF1(p)-exampleF1SEM(p) exampleF1(p)+exampleF1SEM(p)],'k','LineWidth',2);
    end
    numRepeats = 100;
    
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    
    rf.RC = finalSolution(i).rf.RC;
    rf.RS = finalSolution(i).rf.RS;
    rf.ETA = finalSolution(i).rf.ETA;
    rf.A = finalSolution(i).rf.A;
    
    stim.FS = logspace(log10(min(in.fs)),log10(max(in.fs)),70);
    stim.m = 0.5;
    stim.c = 1;

    fitted = rfModel(rf,stim,'1D-DOG-analytic');
    y = squeeze(fitted.f1);
    
    plot(stim.FS,y+sub,'r');
    
    qualText = sprintf('%2.2f',finalSolution(i).rf.quality);
    %         text(1,1,textToPrint,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
    text(1,1,qualText,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','top');
end

%% distributions
finalSolutionFile = 'C:\Documents and Settings\Owner\My Documents\Dropbox\finalSolution.mat';
clear finalSolution
load(finalSolutionFile);
numAnalyses = length(finalSolution);

finalParams = [finalSolution.rf];

figure;
subplot(2,2,1);hist(log([finalParams.ETA]),20); axis tight; xlabel('log(eta)'); ylabel('num units');
subplot(2,2,2);plot([finalParams.RC],[finalParams.RS],'b.');axis square;hold on;
plot([min([finalParams.RC]) max([finalParams.RC])],[min([finalParams.RC]) max([finalParams.RC])],'k'); xlabel('rc');ylabel('rs')

subplot(2,2,3);plot([finalParams.RC],log([finalParams.ETA]),'b.');axis square;hold on;xlabel('rc'); ylabel('log(eta)');
subplot(2,2,4);plot([finalParams.RS],log([finalParams.ETA]),'b.');axis square;hold on;xlabel('rs'); ylabel('log(eta)');


%% compare rf sizes
finalSolutionFile = 'C:\Documents and Settings\Owner\My Documents\Dropbox\finalSolution.mat';
clear finalSolution
load(finalSolutionFile);
numAnalyses = length(finalSolution);
figure;

finalParams = [finalSolution.rf];

rc = [finalParams.RC];
rs = [finalParams.RS];
eta = [finalParams.ETA];
a = [finalParams.A];

for i = 1:numAnalyses
    subplot(7,10,i);hold on;
    x = -5:0.01:5;
    yC = eta(i)*exp(-x.*x/(rc(i)*rc(i)));
    yS = -exp(-x.*x/(rs(i)*rs(i)));
    plot(x,yC,'r','LineWidth',2);
    plot(x,yS,'b','LineWidth',2);
    textForCell = {sprintf('s/c=%2.2f',rs(i)/rc(i)),sprintf('e=%2.2f',eta(i)),sprintf('a=%2.2f',a(i))};
    text(1,0,textForCell,'units','normalized','HorizontalAlignment','Right','VerticalAlignment','bottom');
end