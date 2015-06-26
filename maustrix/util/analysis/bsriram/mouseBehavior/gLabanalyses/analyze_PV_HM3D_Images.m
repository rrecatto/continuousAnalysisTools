function analyze_PV_HM3D_Images

Subjects = {'61','63','65','69','200','201'};




%% plot Images

analysisFor.analyzeOpt = false;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = false;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = false;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = false;
analysisFor.analyzeRevOrientation = false;
analysisFor.analyzeTempFreq = false;
analysisFor.analyzeRevTempFreq = false;
analysisFor.analyzeQuatRadContrast = false;
analysisFor.analyzeImagesContrast = true;


filters = 735564:735574;
trialNumCutoff = 25;

splits.daysPBS = [735565 735569 735570 735572];
splits.daysCNO = [735564 735571 735573 735574];
splits.daysIntact = [];
splits.daysLesion = [];

f = figure('name','HM3D PERFORMANCE BY CONTRAST');
plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';

plotDetails.axHan = subplot(3,3,1:3);
compiledFilesDir = {...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled'};
ctrAll = analyzeMouse({'61','63','65','69','200','201'},filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
hold on;

plotResponseTimes = false;
if plotResponseTimes
    temp = ctrAll.ctrImageData.correction; temp(isnan(temp)) = true;
    whichOK = ~isnan(ctrAll.ctrImageData.correct)&~(temp);
    goodContrasts = ctrAll.ctrImageData.contrast(whichOK);
    goodTrialNum = ctrAll.ctrImageData.trialNum(whichOK);
    goodCorrects = ctrAll.ctrImageData.correct(whichOK);
    goodResponseTimes = ctrAll.ctrImageData.responseTime(whichOK);
    whichOK = goodResponseTimes<5;
    goodContrasts = goodContrasts(whichOK);
    goodTrialNum = goodTrialNum(whichOK);
    goodCorrects = goodCorrects(whichOK);
    goodResponseTimes = goodResponseTimes(whichOK);
    
    figure; 
    
    subplot(2,2,1);
    [nRespTimes, xout] = hist(goodResponseTimes,100); 
    hist(goodResponseTimes,100,'k'); hold on;
    plot(nanmean(goodResponseTimes),1000,'kd');
    plot([(nanmean(goodResponseTimes)-nanstd(goodResponseTimes)) (nanmean(goodResponseTimes)+nanstd(goodResponseTimes))],[1000 1000],'k');
    set(gca,'xlim',[0 5],'ylim',[0 1200]);
    
    subplot(2,2,2);
    responseMeanByContrast = nan(size(ctrAll.ctrImageData.contrasts));
    responseSTDByContrasts = responseMeanByContrast;
    responseSEMByContrasts = responseMeanByContrast;
    contrasts = ctrAll.ctrImageData.contrasts;
    for i = 1:length(contrasts)
        trialsThatContrast = goodContrasts==contrasts(i);
        responseTimesThatContrast = goodResponseTimes(trialsThatContrast);
        responseMeanByContrast(i) = nanmean(responseTimesThatContrast);
        responseSTDByContrasts(i) = nanstd(responseTimesThatContrast);
        responseSEMByContrasts(i) = responseSTDByContrasts(i)/sqrt(length(responseTimesThatContrast));
    end
    plot(contrasts,responseMeanByContrast,'kd');hold on;
    for i = 1:length(contrasts)
        plot([contrasts(i) contrasts(i)],[responseMeanByContrast(i)+2*responseSEMByContrasts(i) responseMeanByContrast(i)-2*responseSEMByContrasts(i)],'k')
    end
    set(gca,'xlim',[-5 105],'ylim',[0.5 1.5]);
    
    subplot(2,2,3); hold on;
    deciles = quantile(goodResponseTimes,9);
    performanceByTimeAndContrast = nan(10,length(contrasts));
    deciles = [0 deciles]; deciles = [deciles 5];
    perfByTime = nan(10,1);
    perfCIByTime = nan(10,2);
    averageContrastBytime = perfByTime;
    for i = 1:10
        whichTrialsThatDecile = (goodResponseTimes>deciles(i)) & ((goodResponseTimes<deciles(i+1)));
        correctsThatDecile = goodCorrects(whichTrialsThatDecile);
        [perfByTime(i) perfCIByTime(i,:)] = binofit(nansum(correctsThatDecile),length(correctsThatDecile));
        averageContrastBytime(i) = nanmean(goodContrasts(whichTrialsThatDecile));
        for j = 1:length(contrasts)
            whichTrialsThatContrastThatDecile = (goodContrasts == contrasts(j)) & (goodResponseTimes>deciles(i)) & ((goodResponseTimes<deciles(i+1)));
            correctsThatContrastThatDecile = goodCorrects(whichTrialsThatContrastThatDecile);
            performanceByTimeAndContrast(i,j) = nansum(correctsThatContrastThatDecile)/length(correctsThatContrastThatDecile);
        end
    end
    plot(1:10, perfByTime,'k','linewidth',3)
    for i = 1:2:length(contrasts)
        plot(1:10,squeeze(performanceByTimeAndContrast(:,i)),'color',1-(i/length(contrasts)*[1 1 1]));
    end
    set(gca,'xlim',[0 11],'ylim',[0.4 1])
    plot(1:10,squeeze(performanceByTimeAndContrast(:,end)),'color',1-(8/length(contrasts)*[1 1 1]));
    plot([1 10],[0.5 0.5],'k');
    
    subplot(2,2,4); hold on
    numTrials = cellfun(@length,ctrAll.ctrImageData.responseTimesByCondition);
    meanRespTimes = cellfun(@nanmean,ctrAll.ctrImageData.responseTimesByCondition);
    stdRespTimes = cellfun(@nanstd,ctrAll.ctrImageData.responseTimesByCondition);
    semRespTimes = stdRespTimes./sqrt(numTrials);
    AllTimesPBS = [];
    AllTimesCNO = [];
    for i = 1:size(ctrAll.ctrImageData.responseTimesByCondition,1)
        AllTimesPBS = [AllTimesPBS ctrAll.ctrImageData.responseTimesByCondition{i,1}];
        snapnow;
        AllTimesCNO = [AllTimesCNO ctrAll.ctrImageData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(AllTimesPBS,AllTimesCNO);
    
    LowCTimesPBS = [];
    LowCTimesCNO = [];
    
    for i = 1:5
        LowCTimesPBS = [LowCTimesPBS ctrAll.ctrImageData.responseTimesByCondition{i,1}];
        LowCTimesCNO = [LowCTimesCNO ctrAll.ctrImageData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(LowCTimesPBS,LowCTimesCNO);
    
    HighCTimesPBS = [];
    HighCTimesCNO = [];
    for i = 6:8
        HighCTimesPBS = [HighCTimesPBS ctrAll.ctrImageData.responseTimesByCondition{i,1}];
        HighCTimesCNO = [HighCTimesCNO ctrAll.ctrImageData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(HighCTimesPBS,HighCTimesCNO);
    
        keyboard
    plot(gca, contrasts, meanRespTimes(:,1), 'bd');
    plot(gca, contrasts, meanRespTimes(:,2), 'rd');
    for i = 1:length(contrasts)
        plot([contrasts(i) contrasts(i)],[meanRespTimes(i,1)-2*semRespTimes(i,1) meanRespTimes(i,1)+2*semRespTimes(i,1)],'b');
        plot([contrasts(i) contrasts(i)],[meanRespTimes(i,2)-2*semRespTimes(i,2) meanRespTimes(i,2)+2*semRespTimes(i,2)],'r');
    end
        set(gca,'xlim',[-0.1 1.1],'ylim',[1 2]);

        
    % find quintiles and then plot performance for those...
    AllRespTimes = [AllTimesPBS AllTimesCNO];
    respQuintiles = quantile(AllRespTimes,4);
    respQuintiles = [0 respQuintiles 5];
    numTrialsForQuint = nan(length(ctrAll.ctrImageData.contrasts),2,5);
    correctForQuint = numTrialsForQuint;
    
    for cond = 1:2
        for cont = 1:length(ctrAll.ctrImageData.contrasts)
            trialNumsForThatContrastAndCondition = ctrAll.ctrImageData.trialNumsByConditionWCO{cont,cond};
            respTimeForThatContrastAndCondition = ctrAll.ctrImageData.responseTimesByConditionWCO{cont, cond};
            for quint = 1:length(respQuintiles)-1
                currentQuintTrialFilter = trialNumsForThatContrastAndCondition(respTimeForThatContrastAndCondition>respQuintiles(quint) & respTimeForThatContrastAndCondition<=respQuintiles(quint+1));
                numTrialsForQuint(cont,cond,quint) = length(currentQuintTrialFilter);
                whichTrials = ismember(ctrAll.ctrImageData.trialNum,currentQuintTrialFilter);
                correctForQuint(cont,cond,quint) = nansum(ctrAll.ctrImageData.correct(whichTrials));
            end
        end
    end
    keyboard
    % find quartiles and then plot performance for those...
    AllRespTimes = [AllTimesPBS AllTimesCNO];
    respQuartiles = quantile(AllRespTimes,3);
    respQuartiles = [0 respQuartiles 5];
    numTrialsForQuart = nan(length(ctrAll.ctrImageData.contrasts),2,4);
    correctForQuart = numTrialsForQuart;
    
    for cond = 1:2
        for cont = 1:length(ctrAll.ctrImageData.contrasts)
            trialNumsForThatContrastAndCondition = ctrAll.ctrImageData.trialNumsByConditionWCO{cont,cond};
            respTimeForThatContrastAndCondition = ctrAll.ctrImageData.responseTimesByConditionWCO{cont, cond};
            for quart = 1:length(respQuartiles)-1
                currentQuartTrialFilter = trialNumsForThatContrastAndCondition(respTimeForThatContrastAndCondition>respQuartiles(quart) & respTimeForThatContrastAndCondition<=respQuartiles(quart+1));
                numTrialsForQuart(cont,cond,quart) = length(currentQuartTrialFilter);
                whichTrials = ismember(ctrAll.ctrImageData.trialNum,currentQuartTrialFilter);
                correctForQuart(cont,cond,quart) = nansum(ctrAll.ctrImageData.correct(whichTrials));
            end
        end
    end
    
    
end
keyboard

fitIn.cntr = ctrAll.ctrImageData.contrasts/100;
fitIn.pHat = ctrAll.ctrImageData.performanceByConditionWCO(:,1,1)';
fitOut(1) = fitHyperbolicRatio(fitIn);
plot(fitOut(1).fittedModel.c,fitOut(1).fittedModel.pModel,'b','lineWidth',3);

fitIn.cntr = ctrAll.ctrImageData.contrasts/100;
fitIn.pHat = ctrAll.ctrImageData.performanceByConditionWCO(:,1,2)';
fitOut(2) = fitHyperbolicRatio(fitIn);
plot(fitOut(2).fittedModel.c,fitOut(2).fittedModel.pModel,'r','lineWidth',3);



plotDetails.axHan = subplot(3,3,4);hold on;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
c1 = analyzeMouse('61',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c1.ctrImageData.contrasts/100;
fitIn.pHat = c1.ctrImageData.performanceByConditionWCO(:,1,1)';
fitInd(1,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(1,1).fittedModel.c,fitInd(1,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c1.ctrImageData.contrasts/100;
fitIn.pHat = c1.ctrImageData.performanceByConditionWCO(:,1,2)';
fitInd(1,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(1,2).fittedModel.c,fitInd(1,2).fittedModel.pModel,'r','lineWidth',3);

plotDetails.axHan = subplot(3,3,5); hold on;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
c2 = analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c2.ctrImageData.contrasts/100;
fitIn.pHat = c2.ctrImageData.performanceByConditionWCO(:,1,1)';
fitInd(2,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(2,1).fittedModel.c,fitInd(2,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c2.ctrImageData.contrasts/100;
fitIn.pHat = c2.ctrImageData.performanceByConditionWCO(:,1,2)';
fitInd(2,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(2,2).fittedModel.c,fitInd(2,2).fittedModel.pModel,'r','lineWidth',3);

plotDetails.axHan = subplot(3,3,6);hold on;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
c3 = analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c3.ctrImageData.contrasts/100;
fitIn.pHat = c3.ctrImageData.performanceByConditionWCO(:,1,1)';
fitInd(3,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(3,1).fittedModel.c,fitInd(3,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c3.ctrImageData.contrasts/100;
fitIn.pHat = c3.ctrImageData.performanceByConditionWCO(:,1,2)';
fitInd(3,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(3,2).fittedModel.c,fitInd(3,2).fittedModel.pModel,'r','lineWidth',3);

plotDetails.axHan = subplot(3,3,7);hold on;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
c4 = analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c4.ctrImageData.contrasts/100;
fitIn.pHat = c4.ctrImageData.performanceByConditionWCO(:,1,1)';
fitInd(4,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(4,1).fittedModel.c,fitInd(4,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c4.ctrImageData.contrasts/100;
fitIn.pHat = c4.ctrImageData.performanceByConditionWCO(:,1,2)';
fitInd(4,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(4,2).fittedModel.c,fitInd(4,2).fittedModel.pModel,'r','lineWidth',3);

plotDetails.axHan = subplot(3,3,8);hold on;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
c5 = analyzeMouse('200',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c5.ctrImageData.contrasts/100;
fitIn.pHat = c5.ctrImageData.performanceByConditionWCO(:,1,1)';
fitInd(5,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(5,1).fittedModel.c,fitInd(5,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c5.ctrImageData.contrasts/100;
fitIn.pHat = c5.ctrImageData.performanceByConditionWCO(:,1,2)';
fitInd(5,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(5,2).fittedModel.c,fitInd(5,2).fittedModel.pModel,'r','lineWidth',3);

plotDetails.axHan = subplot(3,3,9);hold on;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
c6 = analyzeMouse('201',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c6.ctrImageData.contrasts/100;
fitIn.pHat = c6.ctrImageData.performanceByConditionWCO(:,1,1)';
fitInd(6,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(6,1).fittedModel.c,fitInd(6,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c6.ctrImageData.contrasts/100;
fitIn.pHat = c6.ctrImageData.performanceByConditionWCO(:,1,2)';
fitInd(6,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(6,2).fittedModel.c,fitInd(6,2).fittedModel.pModel,'r','lineWidth',3);


c50PBS = [];
c50CNO = [];

for i = 1:6
    c50PBS(i) = fitInd(i,1).c50;
    c50CNO(i) = fitInd(i,2).c50;
end



in = []
in.cntr = OrAll.orData.orientations;
in.pHat = OrAll.orData.performanceByConditionWCO(:,1,1)';
whichGood = ~isnan(in.pHat);

in.cntr = in.cntr(whichGood);
in.pHat = in.pHat(whichGood);
in.cntr = in.cntr/45;


fitPBS = fitHyperbolicRatio(in);
fitPBS.c50*45
plot(fitPBS.fittedModel.c*45,fitPBS.fittedModel.pModel,'b','linewidth',3); hold on
plot (in.cntr*45,in.pHat,'bd')

% CNO only
in = [];
in.cntr = OrAll.orData.orientations;
in.pHat = OrAll.orData.performanceByConditionWCO(:,1,2)';
whichGood = ~isnan(in.pHat);

in.cntr = in.cntr(whichGood);
in.pHat = in.pHat(whichGood);
in.cntr = in.cntr/45;


fitCNO = fitHyperbolicRatio(in);
fitCNO.c50*45
(fitCNO.c50*45 - fitPBS.c50*45)/45
plot(fitCNO.fittedModel.c*45,fitCNO.fittedModel.pModel,'r','linewidth',3); hold on
plot (in.cntr*45,in.pHat,'rd')


numResamples = 10000;
c50Difference = nan(1,numResamples);
c50PBS = c50Difference;
c50CNO = c50Difference;
qPBS = c50Difference;
qCNO = qPBS;

inPBS.cntr = OrAll.orData.orientations/45;
inCNO.cntr = OrAll.orData.orientations/45;
% lets do the shuffle
numTrialsByConditionPBS = OrAll.orData.numTrialsByConditionWCO(:,1);
numTrialsByConditionCNO = OrAll.orData.numTrialsByConditionWCO(:,2);

correctByConditionPBS = OrAll.orData.correctByConditionWCO(:,1);
correctByConditionCNO = OrAll.orData.correctByConditionWCO(:,2);

oneZerosForResample = cell(length(inPBS.cntr),1);
for j = 1:length(inPBS.cntr)
    oneZerosForResample{j} = zeros(1,numTrialsByConditionPBS(j)+numTrialsByConditionCNO(j));
    oneZerosForResample{j}(1:correctByConditionPBS(j)+correctByConditionCNO(j)) = 1;
end
currentShuffle = oneZerosForResample;
for i = 1:numResamples
    currentPBS = nan(1,length(numTrialsByConditionPBS));
    currentCNO = nan(1,length(numTrialsByConditionCNO));
    for j = 1:length(inPBS.cntr)
        currentShuffle{j} = oneZerosForResample{j}(randperm(length(oneZerosForResample{j})));
        currentPBS(j) = sum(currentShuffle{j}(1:numTrialsByConditionPBS(j)));
        currentCNO(j) = sum(currentShuffle{j}(numTrialsByConditionPBS(j)+1:end));
    end
    inPBS.pHat = currentPBS./numTrialsByConditionPBS';
    inCNO.pHat = currentCNO./numTrialsByConditionCNO';

    fitPBS = fitHyperbolicRatio(inPBS);
    qPBS(i) = fitPBS.quality;
    fitCNO = fitHyperbolicRatio(inCNO);
    qCNO(i) = fitCNO.quality;

    c50PBS(i) = fitPBS.c50;
    c50CNO(i) = fitCNO.c50;
    c50Difference(i) = fitPBS.c50-fitCNO.c50;
end
keyboard
% best PBS
in.cntr = OrAll.orData.orientations;
in.pHat = OrAll.orData.performanceByConditionWCO(:,1,1)';
fit = fitHyperbolicRatio(in);
plot(gca,fit.fittedModel.c,fit.fittedModel.pModel,'b','linewidth',3);
PBSBestC50 = fit.c50;

% best CNO
in.cntr = OrAll.orData.orientations;
in.pHat = OrAll.orData.performanceByConditionWCO(:,1,2)';
fit = fitHyperbolicRatio(in);
plot(gca,fit.fittedModel.c,fit.fittedModel.pModel,'r','linewidth',3);
CNOBestC50 = fit.c50;