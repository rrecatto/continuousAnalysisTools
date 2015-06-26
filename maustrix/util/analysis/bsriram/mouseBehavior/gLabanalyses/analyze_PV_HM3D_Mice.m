function analyze_PV_HM3D_Mice

Subjects = {'63','65','67','69'};




%% plot Contrast

analysisFor.analyzeOpt = false;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = true;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = false;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = false;
analysisFor.analyzeRevOrientation = false;
analysisFor.analyzeTempFreq = false;
analysisFor.analyzeRevTempFreq = false;
analysisFor.analyzeCtrSensitivity = false;
analysisFor.analyzeQuatRadContrast = false;
analysisFor.analyzeImagesContrast = false;

filters = 735402:735414; %'Jun-17-2013':today
trialNumCutoff = 25;

splits.daysPBS = [735402 735404 735406 735409 735411 735413];
splits.daysCNO = [735403 735405 735407 735410 735412 735414];
splits.daysIntact = [];
splits.daysLesion = [];

f = figure('name','HM3D PERFORMANCE BY CONTRAST');
plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';

plotDetails.axHan = subplot(3,2,1);
compiledFilesDir = {'\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
%     '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled'};
ctrAll = analyzeMouse({'63','67','69'},filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotResponseTimes = true;
if plotResponseTimes
    temp = ctrAll.ctrData.correction; temp(isnan(temp)) = true;
    whichOK = ~isnan(ctrAll.ctrData.correct)&~(temp);
    goodContrasts = ctrAll.ctrData.contrast(whichOK);
    goodTrialNum = ctrAll.ctrData.trialNum(whichOK);
    goodCorrects = ctrAll.ctrData.correct(whichOK);
    goodResponseTimes = ctrAll.ctrData.responseTime(whichOK);
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
    responseMeanByContrast = nan(size(ctrAll.ctrData.contrasts));
    responseSTDByContrasts = responseMeanByContrast;
    responseSEMByContrasts = responseMeanByContrast;
    contrasts = ctrAll.ctrData.contrasts;
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
    set(gca,'xlim',[-0.1 1.1],'ylim',[1 2]);
    
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
    set(gca,'xlim',[0 11],'ylim',[0.3 0.8])
    plot(1:10,squeeze(performanceByTimeAndContrast(:,end)),'color',1-(8/length(contrasts)*[1 1 1]));
    plot([1 10],[0.5 0.5],'k');
    
    subplot(2,2,4); hold on
    numTrials = cellfun(@length,ctrAll.ctrData.responseTimesByCondition);
    meanRespTimes = cellfun(@nanmean,ctrAll.ctrData.responseTimesByCondition);
    stdRespTimes = cellfun(@nanstd,ctrAll.ctrData.responseTimesByCondition);
    semRespTimes = stdRespTimes./sqrt(numTrials);
    AllTimesPBS = [];
    AllTimesCNO = [];
    for i = 1:size(ctrAll.ctrData.responseTimesByCondition,1)
        AllTimesPBS = [AllTimesPBS ctrAll.ctrData.responseTimesByCondition{i,1}];
        AllTimesCNO = [AllTimesCNO ctrAll.ctrData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(AllTimesPBS,AllTimesCNO);
    
    LowCTimesPBS = [];
    LowCTimesCNO = [];
    
    for i = 1:5
        LowCTimesPBS = [LowCTimesPBS ctrAll.ctrData.responseTimesByCondition{i,1}];
        LowCTimesCNO = [LowCTimesCNO ctrAll.ctrData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(LowCTimesPBS,LowCTimesCNO);
    
    HighCTimesPBS = [];
    HighCTimesCNO = [];
    for i = 6:8
        HighCTimesPBS = [HighCTimesPBS ctrAll.ctrData.responseTimesByCondition{i,1}];
        HighCTimesCNO = [HighCTimesCNO ctrAll.ctrData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(HighCTimesPBS,HighCTimesCNO);
    
        
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
    numTrialsForQuint = nan(length(ctrAll.ctrData.contrasts),2,5);
    correctForQuint = numTrialsForQuint;
    
    for cond = 1:2
        for cont = 1:length(ctrAll.ctrData.contrasts)
            trialNumsForThatContrastAndCondition = ctrAll.ctrData.trialNumsByConditionWCO{cont,cond};
            respTimeForThatContrastAndCondition = ctrAll.ctrData.responseTimesByConditionWCO{cont, cond};
            for quint = 1:length(respQuintiles)-1
                currentQuintTrialFilter = trialNumsForThatContrastAndCondition(respTimeForThatContrastAndCondition>respQuintiles(quint) & respTimeForThatContrastAndCondition<=respQuintiles(quint+1));
                numTrialsForQuint(cont,cond,quint) = length(currentQuintTrialFilter);
                whichTrials = ismember(ctrAll.ctrData.trialNum,currentQuintTrialFilter);
                correctForQuint(cont,cond,quint) = nansum(ctrAll.ctrData.correct(whichTrials));
            end
        end
    end
    
    % find quartiles and then plot performance for those...
    AllRespTimes = [AllTimesPBS AllTimesCNO];
    respQuartiles = quantile(AllRespTimes,3);
    respQuartiles = [0 respQuartiles 5];
    numTrialsForQuart = nan(length(ctrAll.ctrData.contrasts),2,4);
    correctForQuart = numTrialsForQuart;
    
    for cond = 1:2
        for cont = 1:length(ctrAll.ctrData.contrasts)
            trialNumsForThatContrastAndCondition = ctrAll.ctrData.trialNumsByConditionWCO{cont,cond};
            respTimeForThatContrastAndCondition = ctrAll.ctrData.responseTimesByConditionWCO{cont, cond};
            for quart = 1:length(respQuartiles)-1
                currentQuartTrialFilter = trialNumsForThatContrastAndCondition(respTimeForThatContrastAndCondition>respQuartiles(quart) & respTimeForThatContrastAndCondition<=respQuartiles(quart+1));
                numTrialsForQuart(cont,cond,quart) = length(currentQuartTrialFilter);
                whichTrials = ismember(ctrAll.ctrData.trialNum,currentQuartTrialFilter);
                correctForQuart(cont,cond,quart) = nansum(ctrAll.ctrData.correct(whichTrials));
            end
        end
    end
    
    
end

oldFits = false;
if oldFits
    % lets do some fitting
    % PBS
    PBSFit = [];
    PBSQuality = [];
    for i = 1:1000
        in.cntr = ctrAll.ctrData.contrasts;
        in.pHat = nan(size(in.cntr));
        for j = 1:length(in.pHat)
            minPerf = ctrAll.ctrData.performanceByConditionWCO(j,2,1);
            maxPerf = ctrAll.ctrData.performanceByConditionWCO(j,3,1);
            in.pHat(j) = minPerf+rand*(maxPerf-minPerf);
            %         in.pHat(j) = (minPerf+maxPerf)/2+randn*(maxPerf-minPerf)/4;
        end
        fit = fitHyperbolicRatio(in);
        PBSFit(end+1) = fit.c50;
        PBSQuality(end+1) = fit.quality;
        
        if rand<0.01
            hold on;
            plot(gca,fit.fittedModel.c,fit.fittedModel.pModel,'b','linewidth',0.5);
        end
    end
    in.cntr = ctrAll.ctrData.contrasts;
    in.pHat = ctrAll.ctrData.performanceByConditionWCO(:,1,1)';
    fit = fitHyperbolicRatio(in);
    plot(gca,fit.fittedModel.c,fit.fittedModel.pModel,'b','linewidth',3);
    PBSBestC50 = fit.c50;
    PBSFit = PBSFit(PBSQuality>0.64);
    
    CNOFit = [];
    CNOQuality = [];
    for i = 1:1000
        in.cntr = ctrAll.ctrData.contrasts;
        in.pHat = nan(size(in.cntr));
        for j = 1:length(in.pHat)
            minPerf = ctrAll.ctrData.performanceByConditionWCO(j,2,2);
            maxPerf = ctrAll.ctrData.performanceByConditionWCO(j,3,2);
            in.pHat(j) = minPerf+rand*(maxPerf-minPerf);
            %         in.pHat(j) = (minPerf+maxPerf)/2+randn*(maxPerf-minPerf)/4;
        end
        fit = fitHyperbolicRatio(in);
        CNOFit(end+1) = fit.c50;
        CNOQuality(end+1) = fit.quality;
        if rand<0.01
            hold on;
            plot(gca,fit.fittedModel.c,fit.fittedModel.pModel,'r','linewidth',0.5)
        end
    end
end

jackKnifeEstimate = true;
if jackKnifeEstimate
end

numResamples = 10000;
c50Difference = nan(1,numResamples);
c50PBS = c50Difference;
c50CNO = c50Difference;
qPBS = c50Difference;
qCNO = qPBS;

inPBS.cntr = ctrAll.ctrData.contrasts;
inCNO.cntr = ctrAll.ctrData.contrasts;
% lets do the shuffle
numTrialsByConditionPBS = ctrAll.ctrData.numTrialsByConditionWCO(:,1);
numTrialsByConditionCNO = ctrAll.ctrData.numTrialsByConditionWCO(:,2);

correctByConditionPBS = ctrAll.ctrData.correctByConditionWCO(:,1);
correctByConditionCNO = ctrAll.ctrData.correctByConditionWCO(:,2);
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
%     
%     tempPBS = inPBS;
%     which = tempPBS.cntr==0.1;
%     if any(which)
%         tempPBS.cntr(which) = [];
%         tempPBS.pHat(which) = [];
%     end
%     
%     tempCNO = inCNO;
%     which = tempCNO.cntr==0.1;
%     if any(which)
%         tempCNO.cntr(which) = [];
%         tempCNO.pHat(which) = [];
%     end
    
    fitPBS = fitHyperbolicRatio(inPBS);
    qPBS(i) = fitPBS.quality;
    fitCNO = fitHyperbolicRatio(inCNO);
    qCNO(i) = fitCNO.quality;

%     keyboard
    %     plot(inPBS.cntr,inPBS.pHat,'b');
%     plot(inCNO.cntr,inCNO.pHat,'r');
%     plot(inCNO.cntr,inPBS.pHat-inCNO.pHat+0.5,'k');
    c50PBS(i) = fitPBS.c50;
    c50CNO(i) = fitCNO.c50;
    c50Difference(i) = fitPBS.c50-fitCNO.c50;
end
keyboard
% best PBS
in.cntr = ctrAll.ctrData.contrasts;
in.pHat = ctrAll.ctrData.performanceByConditionWCO(:,1,1)';
fit = fitHyperbolicRatio(in);
plot(gca,fit.fittedModel.c,fit.fittedModel.pModel,'b','linewidth',3);
PBSBestC50 = fit.c50;

% best CNO
in.cntr = ctrAll.ctrData.contrasts;
in.pHat = ctrAll.ctrData.performanceByConditionWCO(:,1,2)';
fit = fitHyperbolicRatio(in);
plot(gca,fit.fittedModel.c,fit.fittedModel.pModel,'r','linewidth',3);
CNOBestC50 = fit.c50;
keyboard
% keyboard
plotDetails.axHan = subplot(3,2,2);
edges = 0:0.025:1;
nPBS = histc(PBSFit,edges);
nCNO = histc(CNOFit,edges);
fh = fill([edges fliplr(edges)],[nPBS/length(PBSFit) zeros(size(nPBS))],'b');set(fh,'edgealpha',0,'facealpha',0.5);hold on;
fh = fill([edges fliplr(edges)],[nCNO/length(CNOFit) zeros(size(nCNO))],'r');set(fh,'edgealpha',0,'facealpha',0.5);
xlabel('c50');
ylabel('fraction');
[h p] = ttest2(PBSBestC50,CNOBestC50)
plot(PBSBestC50,0.25,'bd');
plot(CNOBestC50,0.25,'rd');
set(gca,'ylim',[0 0.3]);
% keyboard


plotDetails.axHan = subplot(3,2,3);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
c1 = analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c1.ctrData.contrasts;
fitIn.pHat = c1.ctrData.performanceByConditionWCO(:,1,1)';
fitInd(1,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(1,1).fittedModel.c,fitInd(1,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c1.ctrData.contrasts;
fitIn.pHat = c1.ctrData.performanceByConditionWCO(:,1,2)';
fitInd(1,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(1,2).fittedModel.c,fitInd(1,2).fittedModel.pModel,'r','lineWidth',3);

plotDetails.axHan = subplot(3,2,4);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
c2 = analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c2.ctrData.contrasts;
fitIn.pHat = c2.ctrData.performanceByConditionWCO(:,1,1)';
fitInd(2,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(2,1).fittedModel.c,fitInd(2,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c2.ctrData.contrasts;
fitIn.pHat = c2.ctrData.performanceByConditionWCO(:,1,2)';
fitInd(2,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(2,2).fittedModel.c,fitInd(2,2).fittedModel.pModel,'r','lineWidth',3);


plotDetails.axHan = subplot(3,2,5);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
c3 = analyzeMouse('67',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c3.ctrData.contrasts;
fitIn.pHat = c3.ctrData.performanceByConditionWCO(:,1,1)';
fitInd(3,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(3,1).fittedModel.c,fitInd(3,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c3.ctrData.contrasts;
fitIn.pHat = c3.ctrData.performanceByConditionWCO(:,1,2)';
fitInd(3,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(3,2).fittedModel.c,fitInd(3,2).fittedModel.pModel,'r','lineWidth',3);

plotDetails.axHan = subplot(3,2,6);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box5\Compiled';
c4 = analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
fitIn.cntr = c4.ctrData.contrasts;
fitIn.pHat = c4.ctrData.performanceByConditionWCO(:,1,1)';
fitInd(4,1) = fitHyperbolicRatio(fitIn);
plot(fitInd(4,1).fittedModel.c,fitInd(4,1).fittedModel.pModel,'b','lineWidth',3);
fitIn.cntr = c4.ctrData.contrasts;
fitIn.pHat = c4.ctrData.performanceByConditionWCO(:,1,2)';
fitInd(4,2) = fitHyperbolicRatio(fitIn);
plot(fitInd(4,2).fittedModel.c,fitInd(4,2).fittedModel.pModel,'r','lineWidth',3);

%% PLOT RESPONSE TIMES FOR CONTRAST

%% PLOT ORIENTATION 

analysisFor.analyzeOpt = false;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = false;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = false;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = true;
analysisFor.analyzeRevOrientation = false;
analysisFor.analyzeTempFreq = false;
analysisFor.analyzeRevTempFreq = false;
analysisFor.analyzeQuatRadContrast = false;
analysisFor.analyzeImagesContrast = false;
analysisFor.analyzeCtrSensitivity = false;
filters = 735416:today; %'Jun-17-2013':today
trialNumCutoff = 25;

splits.daysPBS = [735416 735418 735419 735423 735425 735427];
splits.daysCNO = [735417 735420 735421 735424 735426 735428]; % except for 65...
splits.daysIntact = [];
splits.daysLesion = [];

f = figure('name','HM3D PERFORMANCE BY ORIENTATION');
plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';

plotDetails.axHan = subplot(3,2,1);
compiledFilesDir = {'\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled'};
OrAll = analyzeMouse({'63','65','67','69'},filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);


plotResponseTimes = false;
if plotResponseTimes
    temp = OrAll.orData.correction; temp(isnan(temp)) = true;
    whichOK = ~isnan(OrAll.orData.correct)&~(temp);
    goodContrasts = OrAll.orData.orientation(whichOK);
    goodTrialNum = OrAll.orData.trialNum(whichOK);
    goodCorrects = OrAll.orData.correct(whichOK);
    goodResponseTimes = OrAll.orData.responseTime(whichOK);
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
    responseMeanByContrast = nan(size(OrAll.orData.orientations));
    responseSTDByContrasts = responseMeanByContrast;
    responseSEMByContrasts = responseMeanByContrast;
    contrasts = OrAll.orData.orientations;
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
    set(gca,'xlim',[-5 50],'ylim',[1 2]);
    
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
    set(gca,'xlim',[0 11],'ylim',[0.3 0.8])
    plot(1:10,squeeze(performanceByTimeAndContrast(:,end)),'color',1-(8/length(contrasts)*[1 1 1]));
    plot([1 10],[0.5 0.5],'k');
    
    subplot(2,2,4); hold on
    numTrials = cellfun(@length,OrAll.orData.responseTimesByConditionWCO);
    meanRespTimes = cellfun(@nanmean,OrAll.orData.responseTimesByConditionWCO);
    stdRespTimes = cellfun(@nanstd,OrAll.orData.responseTimesByConditionWCO);
    semRespTimes = stdRespTimes./sqrt(numTrials);
    AllTimesPBS = [];
    AllTimesCNO = [];
    for i = 1:size(OrAll.orData.responseTimesByCondition,1)
        AllTimesPBS = [AllTimesPBS OrAll.orData.responseTimesByCondition{i,1}];
        AllTimesCNO = [AllTimesCNO OrAll.orData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(AllTimesPBS,AllTimesCNO);
    
    LowCTimesPBS = [];
    LowCTimesCNO = [];
    
    for i = 1:5
        LowCTimesPBS = [LowCTimesPBS OrAll.orData.responseTimesByCondition{i,1}];
        LowCTimesCNO = [LowCTimesCNO OrAll.orData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(LowCTimesPBS,LowCTimesCNO);
    
    HighCTimesPBS = [];
    HighCTimesCNO = [];
    for i = 6:8
        HighCTimesPBS = [HighCTimesPBS OrAll.orData.responseTimesByCondition{i,1}];
        HighCTimesCNO = [HighCTimesCNO OrAll.orData.responseTimesByCondition{i,2}];
    end
    [h, p, ci, stat] = ttest2(HighCTimesPBS,HighCTimesCNO);
    
        keyboard
    plot(gca, contrasts, meanRespTimes(:,1), 'bd');
    plot(gca, contrasts, meanRespTimes(:,2), 'rd');
    for i = 1:length(contrasts)
        plot([contrasts(i) contrasts(i)],[meanRespTimes(i,1)-2*semRespTimes(i,1) meanRespTimes(i,1)+2*semRespTimes(i,1)],'b');
        plot([contrasts(i) contrasts(i)],[meanRespTimes(i,2)-2*semRespTimes(i,2) meanRespTimes(i,2)+2*semRespTimes(i,2)],'r');
    end
        set(gca,'xlim',[-5 50],'ylim',[1 2]);

        
    % find quintiles and then plot performance for those...
    AllRespTimes = [AllTimesPBS AllTimesCNO];
    respQuintiles = quantile(AllRespTimes,4);
    respQuintiles = [0 respQuintiles 5];
    numTrialsForQuint = nan(length(ctrAll.ctrData.contrasts),2,5);
    correctForQuint = numTrialsForQuint;
    
    for cond = 1:2
        for cont = 1:length(OrAll.orData.orientations)
            trialNumsForThatContrastAndCondition = OrAll.orData.trialNumsByConditionWCO{cont,cond};
            respTimeForThatContrastAndCondition = OrAll.orData.responseTimesByConditionWCO{cont, cond};
            for quint = 1:length(respQuintiles)-1
                currentQuintTrialFilter = trialNumsForThatContrastAndCondition(respTimeForThatContrastAndCondition>respQuintiles(quint) & respTimeForThatContrastAndCondition<=respQuintiles(quint+1));
                numTrialsForQuint(cont,cond,quint) = length(currentQuintTrialFilter);
                whichTrials = ismember(OrAll.orData.trialNum,currentQuintTrialFilter);
                correctForQuint(cont,cond,quint) = nansum(OrAll.orData.correct(whichTrials));
            end
        end
    end
    keyboard
    % find quartiles and then plot performance for those...
    AllRespTimes = [AllTimesPBS AllTimesCNO];
    respQuartiles = quantile(AllRespTimes,3);
    respQuartiles = [0 respQuartiles 5];
    numTrialsForQuart = nan(length(OrAll.orData.orientations),2,4);
    correctForQuart = numTrialsForQuart;
    
    for cond = 1:2
        for cont = 1:length(OrAll.orData.orientations)
            trialNumsForThatContrastAndCondition = OrAll.orData.trialNumsByConditionWCO{cont,cond};
            respTimeForThatContrastAndCondition = OrAll.orData.responseTimesByConditionWCO{cont, cond};
            for quart = 1:length(respQuartiles)-1
                currentQuartTrialFilter = trialNumsForThatContrastAndCondition(respTimeForThatContrastAndCondition>respQuartiles(quart) & respTimeForThatContrastAndCondition<=respQuartiles(quart+1));
                numTrialsForQuart(cont,cond,quart) = length(currentQuartTrialFilter);
                whichTrials = ismember(OrAll.orData.trialNum,currentQuartTrialFilter);
                correctForQuart(cont,cond,quart) = nansum(OrAll.orData.correct(whichTrials));
            end
        end
    end
    
    
end


out = {};

% plotDetails.axHan = subplot(3,2,3);
% compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
% out{1} = analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
% 
% plotDetails.axHan = subplot(3,2,4);
% compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
% out{2} = analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
% 
% plotDetails.axHan = subplot(3,2,5);
% compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
% out{3} = analyzeMouse('67',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
% 
% plotDetails.axHan = subplot(3,2,6);
% compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box5\Compiled';
% out{4} = analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

% PBS only
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

%% plot Contrast QUAT RAD

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
analysisFor.analyzeQuatRadContrast = true;
analysisFor.analyzeImagesContrast = false;
analysisFor.analyzeCtrSensitivity = false;

filters = 735460:735487;%735541; %'Jun-17-2013':today ,,735542,,735486
trialNumCutoff = 25;

splits.daysPBS = [735460 735466 735468 735472 735474 735476 735480 735482 735486 735488 735489];
splits.daysCNO = [735461 735465 735467 735469 735473 735475 735481 735487];
splits.daysIntact = [];
splits.daysLesion = [];

f = figure('name','HM3D PERFORMANCE BY CONTRAST');
plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';


plotDetails.axHan = subplot(3,2,1);
compiledFilesDir = {'\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box5\Compiled'};
ctrAll = analyzeMouse({'63','65','69'},filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);


plotDetails.axHan = subplot(3,2,3);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,4);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,5);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
analyzeMouse('67',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,6);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box5\Compiled';
analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%% Final run of contrast
analysisFor.analyzeOpt = false;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = true;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = false;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = false;
analysisFor.analyzeRevOrientation = false;
analysisFor.analyzeTempFreq = false;
analysisFor.analyzeRevTempFreq = false;
analysisFor.analyzeQuatRadContrast = false;
analysisFor.analyzeImagesContrast = false;

filters = 735576:735578; %'Jun-17-2013':today ,,735542,,735486
trialNumCutoff = 25;

splits.daysPBS = [735576 735578];
splits.daysCNO = [735577];
splits.daysIntact = [];
splits.daysLesion = [];

f = figure('name','HM3D PERFORMANCE BY CONTRAST');
plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';


plotDetails.axHan = subplot(4,2,1:2);
compiledFilesDir = {'\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled'};
ctrAll = analyzeMouse({'61','63','65','69','200','201'},filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);


plotDetails.axHan = subplot(4,2,3);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
analyzeMouse('61',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(4,2,4);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(4,2,5);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(4,2,6);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(4,2,7);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
analyzeMouse('200',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(4,2,8);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
analyzeMouse('201',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%% plot Spat. Freq

analysisFor.analyzeOpt = false;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = false;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = true;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = false;
analysisFor.analyzeRevOrientation = false;
analysisFor.analyzeTempFreq = false;
analysisFor.analyzeRevTempFreq = false;
analysisFor.analyzeQuatRadContrast = false;
analysisFor.analyzeImagesContrast = false;
analysisFor.analyzeCtrSensitivity = false;

sfFilters = 735430:735445;%735541; %'Jun-17-2013':today ,,735542,,735486
trialNumCutoff = 25;
filters = []
    filters.fdFilter = sfFilters;
    filters.imFilter = sfFilters;
    filters.optFilter = sfFilters;
    filters.optRevFilter = sfFilters;
    filters.ctrFilter = sfFilters;
    filters.ctrRevFilter = sfFilters;
    filters.sfFilter = sfFilters;
    filters.sfRevFilter = sfFilters;
    filters.orFilter = sfFilters;
    filters.orRevFilters = sfFilters;
    filters.tfFilter = sfFilters;
    filters.tfRevFilter = sfFilters;
    filters.ctrQuatRadFilter = sfFilters;
    filters.ctrImages = sfFilters;
    filters.ctrSensitivity = sfFilters;
    
    filters.MinResponseTime = 0;
    filters.MaxResponseTime = 1.5666;
    

splits.daysPBS = [735430 735432 735434 735437 735439 735441 735444];
splits.daysCNO = [735431 735433 735438 735440 735445]; % except for 65...
splits.daysIntact = [];
splits.daysLesion = [];


f = figure('name','HM3D PERFORMANCE BY CONTRAST');
plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';


plotDetails.axHan = subplot(3,2,1);
compiledFilesDir = {'\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled'};
sfAll = analyzeMouse({'61','63','65','69'},filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);



plotResponseTimes = false;
if plotResponseTimes
    temp = sfAll.spatData.correction; temp(isnan(temp)) = true;
    whichOK = ~isnan(sfAll.spatData.correct)&~(temp);
    goodContrasts = sfAll.spatData.spatFreq(whichOK);
    goodTrialNum = sfAll.spatData.trialNum(whichOK);
    goodCorrects = sfAll.spatData.correct(whichOK);
    goodResponseTimes = sfAll.spatData.responseTime(whichOK);
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
    responseMeanByContrast = nan(size(sfAll.spatData.spatFreqs));
    responseSTDByContrasts = responseMeanByContrast;
    responseSEMByContrasts = responseMeanByContrast;
    contrasts = sfAll.spatData.spatFreqs;
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
    set(gca,'xlim',[0 1],'ylim',[1 2]);
    
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
    set(gca,'xlim',[0 11],'ylim',[0.3 0.8])
    plot(1:10,squeeze(performanceByTimeAndContrast(:,end)),'color',1-(8/length(contrasts)*[1 1 1]));
    plot([1 10],[0.5 0.5],'k');
    
    subplot(2,2,4); hold on
    numTrials = cellfun(@length,sfAll.spatData.responseTimesByConditionWCO);
    meanRespTimes = cellfun(@nanmean,sfAll.spatData.responseTimesByConditionWCO);
    stdRespTimes = cellfun(@nanstd,sfAll.spatData.responseTimesByConditionWCO);
    semRespTimes = stdRespTimes./sqrt(numTrials);
    AllTimesPBS = [];
    AllTimesCNO = [];
    for i = 1:size(sfAll.spatData.responseTimesByCondition,1)
        AllTimesPBS = [AllTimesPBS sfAll.spatData.responseTimesByConditionWCO{i,1}];
        AllTimesCNO = [AllTimesCNO sfAll.spatData.responseTimesByConditionWCO{i,2}];
    end
    [h, p, ci, stat] = ttest2(AllTimesPBS,AllTimesCNO);
    
    LowCTimesPBS = [];
    LowCTimesCNO = [];
    
    for i = 1:4
        LowCTimesPBS = [LowCTimesPBS sfAll.spatData.responseTimesByConditionWCO{i,1}];
        LowCTimesCNO = [LowCTimesCNO sfAll.spatData.responseTimesByConditionWCO{i,2}];
    end
    [h, p, ci, stat] = ttest2(LowCTimesPBS,LowCTimesCNO);
    
    HighCTimesPBS = [];
    HighCTimesCNO = [];
    for i = 5:6
        HighCTimesPBS = [HighCTimesPBS sfAll.spatData.responseTimesByConditionWCO{i,1}];
        HighCTimesCNO = [HighCTimesCNO sfAll.spatData.responseTimesByConditionWCO{i,2}];
    end
    [h, p, ci, stat] = ttest2(HighCTimesPBS,HighCTimesCNO);
    
        keyboard
    plot(gca, contrasts, meanRespTimes(:,1), 'bd');
    plot(gca, contrasts, meanRespTimes(:,2), 'rd');
    for i = 1:length(contrasts)
        plot([contrasts(i) contrasts(i)],[meanRespTimes(i,1)-2*semRespTimes(i,1) meanRespTimes(i,1)+2*semRespTimes(i,1)],'b');
        plot([contrasts(i) contrasts(i)],[meanRespTimes(i,2)-2*semRespTimes(i,2) meanRespTimes(i,2)+2*semRespTimes(i,2)],'r');
    end
        set(gca,'xlim',[-5 50],'ylim',[1 2]);

        
    % find quintiles and then plot performance for those...
    AllRespTimes = [AllTimesPBS AllTimesCNO];
    respQuintiles = quantile(AllRespTimes,4);
    respQuintiles = [0 respQuintiles 5];
    numTrialsForQuint = nan(length(ctrAll.ctrData.contrasts),2,5);
    correctForQuint = numTrialsForQuint;
    
    for cond = 1:2
        for cont = 1:length(sfAll.spatData.spatFreqs)
            trialNumsForThatContrastAndCondition = sfAll.spatData.trialNumsByConditionWCO{cont,cond};
            respTimeForThatContrastAndCondition = sfAll.spatData.responseTimesByConditionWCO{cont, cond};
            for quint = 1:length(respQuintiles)-1
                currentQuintTrialFilter = trialNumsForThatContrastAndCondition(respTimeForThatContrastAndCondition>respQuintiles(quint) & respTimeForThatContrastAndCondition<=respQuintiles(quint+1));
                numTrialsForQuint(cont,cond,quint) = length(currentQuintTrialFilter);
                whichTrials = ismember(sfAll.spatData.trialNum,currentQuintTrialFilter);
                correctForQuint(cont,cond,quint) = nansum(sfAll.spatData.correct(whichTrials));
            end
        end
    end
    keyboard
    % find quartiles and then plot performance for those...
    AllRespTimes = [AllTimesPBS AllTimesCNO];
    respQuartiles = quantile(AllRespTimes,3);
    respQuartiles = [0 respQuartiles 5];
    numTrialsForQuart = nan(length(sfAll.spatData.spatFreqs),2,4);
    correctForQuart = numTrialsForQuart;
    
    for cond = 1:2
        for cont = 1:length(sfAll.spatData.spatFreqs)
            trialNumsForThatContrastAndCondition = sfAll.spatData.trialNumsByConditionWCO{cont,cond};
            respTimeForThatContrastAndCondition = sfAll.spatData.responseTimesByConditionWCO{cont, cond};
            for quart = 1:length(respQuartiles)-1
                currentQuartTrialFilter = trialNumsForThatContrastAndCondition(respTimeForThatContrastAndCondition>respQuartiles(quart) & respTimeForThatContrastAndCondition<=respQuartiles(quart+1));
                numTrialsForQuart(cont,cond,quart) = length(currentQuartTrialFilter);
                whichTrials = ismember(sfAll.spatData.trialNum,currentQuartTrialFilter);
                correctForQuart(cont,cond,quart) = nansum(sfAll.spatData.correct(whichTrials));
            end
        end
    end
    
    
end



out = {};

plotDetails.axHan = subplot(3,2,3);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
out{1} = analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,4);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
out{2} = analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,5);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
out{3} = analyzeMouse('67',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,6);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\PV-V1-hM3D\Compiled';
out{4} = analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

% PBS only
in = [];
in.fs = sfAll.spatData.spatFreqs;
    in.f1 = sfAll.spatData.performanceByConditionWCO(:,1,1);
    in.f1 = (in.f1-0.5)*2;
    in.model = '1D-DOG-useSensitivity-analytic';
    in.initialGuessMode = 'preset-1-useSensitivity-withJitter';
    in.errorMode = 'sumOfSquares';
    in.searchAlgorithm = 'fmincon-useSensitivity-subbalanced';
    in.constraints.rS_LB = 5;
    in.constraints.rC_UB = 10;
    
    [out fval flag] = sfDOGFit(in);
    out
    
    
    stim.FS = logspace(log10(0.033964721821571),log10(0.989580616499599),100);
    stim.m = 0.5;
    stim.c = 1;
    rfMod.RC = out(1);
    rfMod.RS = out(2);
    rfMod.KC = out(3);
    rfMod.KS = out(4);
    f = figure; ax = axes; hold on;
    outMod = rfModel(rfMod,stim,'1D-DOG-useSensitivity-analytic');
    plot(outMod.FS,0.5+squeeze(outMod.f1)/2,'b','linewidth',2); hold on;
    plot(in.fs,0.5+in.f1/2,'bd')

    
    % CNO only
in = [];
in.fs = sfAll.spatData.spatFreqs;
    in.f1 = sfAll.spatData.performanceByConditionWCO(:,1,2);
    in.f1 = (in.f1-0.5)*2;
    in.model = '1D-DOG-useSensitivity-analytic';
    in.initialGuessMode = 'preset-1-useSensitivity-withJitter';
    in.errorMode = 'sumOfSquares';
    in.searchAlgorithm = 'fmincon-useSensitivity-subbalanced';
    in.constraints.rS_LB = 5;
    in.constraints.rC_UB = 10;
    
    [out fval flag] = sfDOGFit(in);
    out
    
    
    stim.FS = logspace(log10(0.033964721821571),log10(0.989580616499599),100);
    stim.m = 0.5;
    stim.c = 1;
    rfMod.RC = out(1);
    rfMod.RS = out(2);
    rfMod.KC = out(3);
    rfMod.KS = out(4);
    outMod = rfModel(rfMod,stim,'1D-DOG-useSensitivity-analytic');
    plot(outMod.FS,0.5+squeeze(outMod.f1)/2,'r','linewidth',2); hold on;
    plot(in.fs,0.5+in.f1/2,'r.')

    
%% plot Temp. Freq

analysisFor.analyzeOpt = false;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = false;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = false;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = true;
analysisFor.analyzeRevOrientation = false;
analysisFor.analyzeTempFreq = false;
analysisFor.analyzeRevTempFreq = false;
analysisFor.analyzeQuatRadContrast = false;
analysisFor.analyzeImagesContrast = false;
analysisFor.analyzeCtrSensitivity = false;

filters = 1:today;%735541; %'Jun-17-2013':today ,,735542,,735486
trialNumCutoff = 25;


splits.daysPBS = [735430 735432 735434 735437 735439 735441 735444];
splits.daysCNO = [735431 735433 735438 735440 735445]; % except for 65...
splits.daysIntact = [];
splits.daysLesion = [];


f = figure('name','HM3D PERFORMANCE BY TEMP FREQ');
plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';


plotDetails.axHan = subplot(3,2,1);
compiledFilesDir = {'\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';...
    '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box5\Compiled'};
sfAll = analyzeMouse({'61','63','65','69'},filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

out = {};

plotDetails.axHan = subplot(3,2,3);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
out{1} = analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,4);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
out{2} = analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,5);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box4\Compiled';
out{3} = analyzeMouse('67',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,2,6);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box5\Compiled';
out{4} = analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

% PBS only
in = [];
in.fs = sfAll.spatData.spatFreqs;
    in.f1 = sfAll.spatData.performanceByConditionWCO(:,1,1);
    in.f1 = (in.f1-0.5)*2;
    in.model = '1D-DOG-useSensitivity-analytic';
    in.initialGuessMode = 'preset-1-useSensitivity-withJitter';
    in.errorMode = 'sumOfSquares';
    in.searchAlgorithm = 'fmincon-useSensitivity-subbalanced';
    in.constraints.rS_LB = 5;
    in.constraints.rC_UB = 10;
    
    [out fval flag] = sfDOGFit(in);
    out
    
    
    stim.FS = logspace(log10(0.033964721821571),log10(0.989580616499599),100);
    stim.m = 0.5;
    stim.c = 1;
    rfMod.RC = out(1);
    rfMod.RS = out(2);
    rfMod.KC = out(3);
    rfMod.KS = out(4);
    f = figure; ax = axes; hold on;
    outMod = rfModel(rfMod,stim,'1D-DOG-useSensitivity-analytic');
    plot(outMod.FS,0.5+squeeze(outMod.f1)/2,'b','linewidth',2); hold on;
    plot(in.fs,0.5+in.f1/2,'bd')

    
    % CNO only
in = [];
in.fs = sfAll.spatData.spatFreqs;
    in.f1 = sfAll.spatData.performanceByConditionWCO(:,1,2);
    in.f1 = (in.f1-0.5)*2;
    in.model = '1D-DOG-useSensitivity-analytic';
    in.initialGuessMode = 'preset-1-useSensitivity-withJitter';
    in.errorMode = 'sumOfSquares';
    in.searchAlgorithm = 'fmincon-useSensitivity-subbalanced';
    in.constraints.rS_LB = 5;
    in.constraints.rC_UB = 10;
    
    [out fval flag] = sfDOGFit(in);
    out
    
    
    stim.FS = logspace(log10(0.033964721821571),log10(0.989580616499599),100);
    stim.m = 0.5;
    stim.c = 1;
    rfMod.RC = out(1);
    rfMod.RS = out(2);
    rfMod.KC = out(3);
    rfMod.KS = out(4);
    outMod = rfModel(rfMod,stim,'1D-DOG-useSensitivity-analytic');
    plot(outMod.FS,0.5+squeeze(outMod.f1)/2,'r','linewidth',2); hold on;
    plot(in.fs,0.5+in.f1/2,'r.')
    
    
