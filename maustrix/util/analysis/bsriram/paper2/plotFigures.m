function plotFigures
temp = load('F:\physiologyData\basOnlyAnesth_20130327T103432.mat');
dbAn = temp.db;
temp = load('F:\physiologyData\bsPaper2_20130222T093653.mat');
dbAw = temp.db;
clear db;

plotFigure0 = false;
plotFigure1 = false;
plotFigure2 = false;
plotFigure3 = true;
plotFigure4Old = false;
plotFigure4 = true;
plotFigure5 = false;
plotFigure6 = false;
plotFigure7 = false;

%% figure 0
if plotFigure0
    subj = dbAw.data{34}.analyses{1}.subject;
    spikeInfo = dbAw.data{34}.analyses{1}.getSpikes;
    neuralInfo = dbAw.data{34}.analyses{1}.getNeuralData;
    analysis = dbAw.data{34}.analyses{1}.getAnalysis;
    
    neuralData = neuralInfo.chunk1.neuralData(:,3);
    N=min(spikeDetectionParams.samplingFreq/200,floor(size(neuralData,1)/3));
    [b,a]=fir1(N,2*spikeDetectionParams.freqLowHi/spikeDetectionParams.samplingFreq);
    filteredSignal=filtfilt(b,a,neuralData);
    
end
%% figure 1
if plotFigure1
    load('F:\physiologyData\bsPaper2_20130222T093653.mat');
    dbAw = db;
    load('F:\physiologyData\basOnlyAnesth_20130222T095113.mat');
    dbAn = db;
    
    clear db;
    
    factsF0Aw = dbAw.getFacts({'tfGrating',{'f0',2}});
    factsF1Aw = dbAw.getFacts({'tfGrating',{'f1',2}});
    
    factsF0An = dbAn.getFacts({'tfGrating',{'f0',2}});
    factsF1An = dbAn.getFacts({'tfGrating',{'f1',2}});
    
    factsF0AwFF = dbAw.getFacts({'tfFullField',{'f0',2}});
    factsF1AwFF = dbAw.getFacts({'tfFullField',{'f1',2}});
    
    f0Aw = [];
    f1Aw = [];
    f0An = [];
    f1An = [];
    
    % f0Aw
    for i = 1:length(factsF0Aw.results)
        f0Aw(end+1) = factsF0Aw.results{i}{1}{2};
    end
    
    for i = 1:length(factsF0AwFF.results)
        f0Aw(end+1) = factsF0AwFF.results{i}{1}{2};
    end
    
    % f1Aw
    for i = 1:length(factsF1Aw.results)
        f1Aw(end+1) = factsF1Aw.results{i}{1}{2};
    end
    
    for i = 1:length(factsF1AwFF.results)
        f1Aw(end+1) = factsF1AwFF.results{i}{1}{2};
    end
    
    % f0An
    for i = 1:length(factsF0An.results)
        f0An(end+1) = factsF0An.results{i}{1}{2};
    end
    
    % f1An
    for i = 1:length(factsF1An.results)
        f1An(end+1) = factsF1An.results{i}{1}{2};
    end
    
    f0An(10) = [];
    f1An(10) = [];
    
    figure;
    
    subplot(2,1,1);
    minmaxF0Aw = minmax(f0Aw);
    minmaxF0An = minmax(f0An);
    minF0 = min(minmaxF0Aw(1),minmaxF0An(1));
    maxF0 = max(minmaxF0Aw(2),minmaxF0An(2));
    edges = linspace(0,70,21);
    histcF0Aw = histc(f0Aw,edges);
    histcF0An = histc(f0An,edges);
    bar1 = bar(edges,histcF0Aw,'EdgeColor','none','FaceColor',[0 0 0],'BarWidth',0.8); hold on;
    bar2 = bar(edges+1,histcF0An,'EdgeColor','none','FaceColor',[0.6 0.6 0.6],'BarWidth',0.8);
    plot([mean(f0Aw) mean(f0Aw)],[30 20],'k','linewidth',3);
    plot([mean(f0An) mean(f0An)],[30 20],'color',[0.6 0.6 0.6],'linewidth',3);
    
    xlabel('f0 (imp/s)','FontName','Times New Roman','FontSize',14);
    ylabel('# units','FontName','Times New Roman','FontSize',14);
    title('a','FontName','Times New Roman','FontSize',24);
    set(gca,'FontName','Times New Roman','FontSize',14,'xlim',[-2 70],'ylim',[0 40]);
    
    subplot(2,1,2);
    minmaxF1Aw = minmax(f1Aw);
    minmaxF1An = minmax(f1An);
    minF1 = min(minmaxF1Aw(1),minmaxF1An(1));
    maxF1 = max(minmaxF1Aw(2),minmaxF1An(2));
    edges = linspace(0,70,21);
    histcF1Aw = histc(f1Aw,edges);
    histcF1An = histc(f1An,edges);
    bar1 = bar(edges,histcF1Aw,'EdgeColor','none','FaceColor',[0 0 0],'BarWidth',0.8); hold on;
    bar2 = bar(edges+1,histcF1An,'EdgeColor','none','FaceColor',[0.6 0.6 0.6],'BarWidth',0.8);
    plot([mean(f1Aw) mean(f1Aw)],[30 20],'k','linewidth',3);
    plot([mean(f1An) mean(f1An)],[30 20],'color',[0.6 0.6 0.6],'linewidth',3);
    xlabel('f1 (imp/s)','FontName','Times New Roman','FontSize',14);
    ylabel('# units','FontName','Times New Roman','FontSize',14);
    title('b','FontName','Times New Roman','FontSize',24);
    set(gca,'FontName','Times New Roman','FontSize',14,'xlim',[-2 70],'ylim',[0 40]);
end
%% figure 2
if plotFigure2
    % awake
    params.includeNIDs = 1:dbAw.numNeurons;
    f1AwGr = dbAw.getFacts({{'tfGrating',{'f1'}},params});
    f1ShuffAwGr = dbAw.getFacts({{'tfGrating',{'f1Shuffled'}},params});
    f1AwFF = dbAw.getFacts({{'tfFullField',{'f1'}},params});
    f1ShuffAwFF = dbAw.getFacts({{'tfFullField',{'f1Shuffled'}},params});
    
    freqs = [];
    for i = 1:length(f1AwGr.nID)
        freqs = union(freqs,f1AwGr.results{i}{1}{1});
    end
    for i = 1:length(f1AwFF.nID)
        freqs = union(freqs,f1AwFF.results{i}{1}{1});
    end
    
    f1s = nan(length(f1AwGr.nID)+length(f1AwFF.nID),length(freqs));
    for i = 1:length(f1AwGr.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1AwGr.results{i}{1}{1})
                posn = find(f1AwGr.results{i}{1}{1}==freqs(j));
                f1s(i,j) = f1AwGr.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    for i = 1:length(f1AwFF.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1AwFF.results{i}{1}{1})
                posn = find(f1AwFF.results{i}{1}{1}==freqs(j));
                f1s(i+length(f1AwGr.nID),j) = f1AwFF.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    
    
    f1sShuff = nan(length(f1ShuffAwGr.nID)+length(f1ShuffAwFF.nID),length(freqs));
    for i = 1:length(f1ShuffAwGr.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1ShuffAwGr.results{i}{1}{1})
                posn = find(f1ShuffAwGr.results{i}{1}{1}==freqs(j));
                f1sShuff(i,j) = f1ShuffAwGr.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    for i = 1:length(f1ShuffAwFF.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1ShuffAwFF.results{i}{1}{1})
                posn = find(f1ShuffAwFF.results{i}{1}{1}==freqs(j));
                f1sShuff(i+length(f1ShuffAwGr.nID),j) = f1ShuffAwFF.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    f1s = f1s-f1sShuff;
    
    maxF1 = max(f1s,[],2);
    maxF1 = repmat(maxF1,1,length(freqs));
    
    F1Norm = f1s./maxF1;
    F1NormMean = nanmean(F1Norm);
    F1NormSTD = nanstd(F1Norm);
    F1NormSEM = F1NormSTD./sqrt(size(F1Norm,1));
    subplot(5,2,[1:4]);
    plot((freqs),F1NormMean,'color',[0 0 0],'linewidth',3,'marker','d','markerfacecolor',[0 0 0]);
    hold on;
    for i = 1:length(F1NormMean)
        plot(([freqs(i) freqs(i)]),[F1NormMean(i)+F1NormSEM(i) F1NormMean(i)-F1NormSEM(i)],'color',[0 0 0],'linestyle','--','linewidth',2);
    end
    
    % anesth
    params.includeNIDs = 1:dbAn.numNeurons;
    f1AwGr = dbAn.getFacts({{'tfGrating',{'f1'}},params});
    f1ShuffAwGr = dbAn.getFacts({{'tfGrating',{'f1Shuffled'}},params});
    
    freqs = [];
    for i = 1:length(f1AwGr.nID)
        freqs = union(freqs,f1AwGr.results{i}{1}{1});
    end
    
    f1s = nan(length(f1AwGr.nID),length(freqs));
    for i = 1:length(f1AwGr.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1AwGr.results{i}{1}{1})
                posn = find(f1AwGr.results{i}{1}{1}==freqs(j));
                f1s(i,j) = f1AwGr.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    
    
    f1sShuff = nan(length(f1ShuffAwGr.nID),length(freqs));
    for i = 1:length(f1ShuffAwGr.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1ShuffAwGr.results{i}{1}{1})
                posn = find(f1ShuffAwGr.results{i}{1}{1}==freqs(j));
                f1sShuff(i,j) = f1ShuffAwGr.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    f1s = f1s-f1sShuff;
    
    maxF1 = max(f1s,[],2);
    maxF1 = repmat(maxF1,1,length(freqs));
    
    F1Norm = f1s./maxF1;
    F1NormMean = nanmean(F1Norm);
    F1NormSTD = nanstd(F1Norm);
    F1NormSEM = F1NormSTD./sqrt(size(F1Norm,1));
    plot((freqs),F1NormMean,'color',[0.6 0.6 0.6],'linewidth',3,'marker','d','markerfacecolor',[0.6 0.6 0.6]);
    hold on;
    for i = 1:length(F1NormMean)
        plot(([freqs(i) freqs(i)]),[F1NormMean(i)+F1NormSEM(i) F1NormMean(i)-F1NormSEM(i)],'color',[0.6 0.6 0.6],'linestyle','--','linewidth',2);
    end
    
    
    set(gca,'xlim',[(0) (20)],'ylim',[0 1],'xtick',([0 10 20]),'xticklabel',{'0','10','20'},'FontSize',14)
    xlabel('temporal frequency(Hz)','FontSize',14,'FontName','Times New Roman')
    ylabel('normalized f1','FontSize',14,'FontName','Times New Roman')
    title('a','FontName','Times New Roman','FontSize',20);
    set(gca,'FontName','Times New Roman');
    
    params.color = [0 0 0];
    params.setYLimMinToZero = true;
    axAwLow = subplot(5,2,5);
    dbAw.data{90}.analyses{1}.plot2ax(axAwLow,{'f1',params});
    title('b','FontSize',20,'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman');
    
    axAwMed = subplot(5,2,7);
    dbAw.data{63}.analyses{2}.plot2ax(axAwMed,{'f1',params});
    title('c','FontSize',20,'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman');
    
    axAwHigh = subplot(5,2,9);
    dbAw.data{60}.analyses{1}.plot2ax(axAwHigh,{'f1',params});
    title('d','FontSize',20,'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman');
    
    params.color = [0.6 0.6 0.6];
    params.setYLimMinToZero = true;
    axAnLow = subplot(5,2,6);
    dbAn.data{11}.analyses{1}.plot2ax(axAnLow,{'f1',params});
    title('e','FontSize',20,'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman');
    
    axAnMed = subplot(5,2,8);
    dbAn.data{1}.analyses{1}.plot2ax(axAnMed,{'f1',params});
    title('f','FontSize',20,'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman');
    
    axAnHigh = subplot(5,2,10);
    dbAn.data{2}.analyses{1}.plot2ax(axAnHigh,{'f1',params});
    title('g','FontSize',20,'FontName','Times New Roman');
    set(gca,'FontName','Times New Roman');
end
%% figure 3
if plotFigure3
    factsAw = dbAw.getFacts({'gaussianFullField','fftOfSTA'});
    factsAn = dbAn.getFacts({'gaussianFullField','fftOfSTA'});
    
    figure;
    
    axAwSTA = subplot(4,2,1);
    plottingParams.plotHighPrecision = true;
    plottingParams.timeCourse = [200 50];
    dbAw.data{31}.analyses{2}.plotTemporal(axAwSTA,plottingParams);
    title('a','FontName','Times New Roman','FontSize',20);
    set(gca,'FontName','Times New Roman','FontSize',14);
    yticks = get(gca,'ytick');
    yticks = (yticks-127.5); yticks = max(abs(yticks));
    set(gca,'ytick',[-yticks+127.5, 127.5, yticks+127.5],'yticklabel',{sprintf('%2.1f',-yticks/127.5),'0',sprintf('%2.1f',yticks/127.5)})
    xlabel('seconds before spike (ms)');
    ylabel('luminance');
    
    axAnSTA = subplot(4,2,3);
    plottingParams.plotHighPrecision = true;
    plottingParams.timeCourse = [200 50];
    dbAn.data{9}.analyses{1}.plotTemporal(axAnSTA,plottingParams);
    title('c','FontName','Times New Roman','FontSize',20)
    set(gca,'FontName','Times New Roman','FontSize',14);
    yticks = get(gca,'ytick');
    yticks = (yticks-127.5); yticks = max(abs(yticks));
    set(gca,'ytick',[-yticks+127.5, 127.5, yticks+127.5],'yticklabel',{sprintf('%2.1f',-yticks/127.5),'0',sprintf('%2.1f',yticks/127.5)})
    xlabel('seconds before spike (ms)');
    ylabel('luminance');
    
    subplot(4,2,2);hold on;
    freqsAw = factsAw.results{16}.freqSTA;
    which = freqsAw<=50;
    freqsWhichAw = freqsAw(which);
    pAw = factsAw.results{16}.pSTAMean(which);
    sumAw = sum(pAw);
    pAw = pAw/sumAw;
    pSTDAw = factsAw.results{16}.pSTASTD(which);
    pSTDAw = pSTDAw/sumAw;
    plot(freqsWhichAw,pAw,'color',[0 0 0],'linewidth',2);%,'marker','d','markerfacecolor',[0 0 0]
    errRibbonAw = fill([freqsWhichAw fliplr(freqsWhichAw)]',[pAw+4*pSTDAw fliplr(pAw-4*pSTDAw)]',[0 0 0]);set(errRibbonAw,'edgeAlpha',0,'faceAlpha',.5)
%     for i = 1:length(pSTDAw)
%         plot([freqsWhichAw(i) freqsWhichAw(i)],[pAw(i)+4*pSTDAw(i) pAw(i)-4*pSTDAw(i)],'color',[0 0 0],'linewidth',2)
%     end
    set(gca,'ylim',[0 0.2],'FontName','Times New Roman','FontSize',14);
    title('b','FontName','Times New Roman','FontSize',20)
    xlabel('frequency (Hz)');
    ylabel('normalized power');
    
    subplot(4,2,4);hold on;
    freqsAn = factsAn.results{7}.freqSTA;
    which = freqsAn<=50;
    freqsWhichAn = freqsAn(which);
    pAn = factsAn.results{7}.pSTAMean(which);
    sumAn = sum(pAn);
    pAn = pAn/sumAn;
    pSTDAn = factsAn.results{7}.pSTASTD(which);
    pSTDAn = pSTDAn/sumAn;
    plot(freqsWhichAw,pAn,'color',[0.6 0.6 0.6],'linewidth',2)%,'marker','d','markerfacecolor',[0.6 0.6 0.6]
    errRibbonAn = fill([freqsWhichAn fliplr(freqsWhichAn)]',[pAn+4*pSTDAn fliplr(pAn-4*pSTDAn)]',[0.6 0.6 0.6]);set(errRibbonAn,'edgeAlpha',0,'faceAlpha',.5)
%     for i = 1:length(pSTDAn)
%         plot([freqsWhichAn(i) freqsWhichAn(i)],[pAn(i)+4*pSTDAn(i) pAn(i)-4*pSTDAn(i)],'color',[0.6 0.6 0.6],'linewidth',2)
%     end
    set(gca,'ylim',[0 0.2],'FontName','Times New Roman','FontSize',14);
    title('d','FontName','Times New Roman','FontSize',20)
    xlabel('frequency (Hz)');
    ylabel('normalized power');
    
    subplot(4,2,[5:8])
    hold on;
    pSTAsAw = nan(length(factsAw.results),length(factsAw.results{1}.freqSTA));
    for i = 1:length(factsAw.results)
        pSTAsAw(i,:) = factsAw.results{i}.pSTAMean;
    end
    pSTAsAwMax = sum(pSTAsAw,2);
    pSTAsAwMax = repmat(pSTAsAwMax,1,size(pSTAsAw,2));
    pSTAsAw = pSTAsAw./pSTAsAwMax;
    
    pSTAsAn = nan(length(factsAn.results),length(factsAn.results{1}.freqSTA));
    for i = 1:length(factsAn.results)
        pSTAsAn(i,:) = factsAn.results{i}.pSTAMean;
    end
    pSTAsAnMax = sum(pSTAsAn,2);
    pSTAsAnMax = repmat(pSTAsAnMax,1,size(pSTAsAn,2));
    pSTAsAn = pSTAsAn./pSTAsAnMax;
    
    freq = factsAw.results{1}.freqSTA;
    meanAw = mean(pSTAsAw,1);
    stdAw = std(pSTAsAw,[],1);
    nAw = size(pSTAsAw,1);
    meanAn = mean(pSTAsAn,1);
    stdAn = std(pSTAsAn,[],1);
    nAn = size(pSTAsAn,1);
    which = freq<=50;
    freqWhich = find(which);
    plot(freq(freqWhich),meanAw(freqWhich),'color',[0 0 0],'linewidth',3);
%     errRibbonAw = fill([freq(freqWhich) fliplr(freq(freqWhich))]',[meanAw(freqWhich)+4*(stdAw(freqWhich(i))/sqrt(nAw)) fliplr(meanAw(freqWhich)-4*(stdAw(freqWhich(i))/sqrt(nAw)))]',[0 0 0]);set(errRibbonAw,'edgeAlpha',0,'faceAlpha',.5)
    for i = 1:length(freqWhich)
        plot([freq(freqWhich(i)) freq(freqWhich(i))],[meanAw(freqWhich(i))+(stdAw(freqWhich(i))/sqrt(nAw)) meanAw(freqWhich(i))-(stdAw(freqWhich(i))/sqrt(nAw))],'color',[0 0 0],'linewidth',2);
    end
    
    plot(freq(freqWhich),meanAn(freqWhich),'color',[0.6 0.6 0.6],'linewidth',3);
%     errRibbonAn = fill([freq(freqWhich) fliplr(freq(freqWhich))]',[meanAn(freqWhich)+4*(stdAn(freqWhich(i))/sqrt(nAn)) fliplr(meanAn(freqWhich)-4*(stdAn(freqWhich(i))/sqrt(nAn)))]',[0.6 0.6 0.6]);set(errRibbonAn,'edgeAlpha',0,'faceAlpha',.5)
    for i = 1:length(freqWhich)
        plot([freq(freqWhich(i)) freq(freqWhich(i))],[meanAn(freqWhich(i))+(stdAn(freqWhich(i))/sqrt(nAn)) meanAn(freqWhich(i))-(stdAn(freqWhich(i))/sqrt(nAn))],'color',[0.6 0.6 0.6],'linewidth',2);
    end
    set(gca,'FontName','Times New Roman','FontSize',14);
    title('e','FontName','Times New Roman','FontSize',20);
    xlabel('frequency(Hz)','FontName','Times New Roman','FontSize',14);
    ylabel('normalized power','FontName','Times New Roman','FontSize',14);
end
%% figure 4
if plotFigure4Old
    factsAwLatency = dbAw.getFacts({'gaussianFullField','timeToMaxDev'});
    factsAnLatency = dbAn.getFacts({'gaussianFullField','timeToMaxDev'});
    awLatency = [factsAwLatency.results{:}];
    anLatency = [factsAnLatency.results{:}];
    
    factsAwDuration = dbAw.getFacts({'gaussianFullField','duration'});
    factsAnDuration = dbAn.getFacts({'gaussianFullField','duration'});
    awDuration = [factsAwDuration.results{:}];
    for i = 1:length(factsAnDuration.results)
        if isempty(factsAnDuration.results{i})
            factsAnDuration.results{i} = NaN;
        end
    end
    anDuration = [factsAnDuration.results{:}];
    
    factsAw = dbAw.getFacts({'gaussianFullField','fftOfSTA'});
    factsAn = dbAn.getFacts({'gaussianFullField','fftOfSTA'});
    
    
    whichAw = awDuration>50 & awDuration<340;
    whichAn = anDuration>50 & anDuration<340;
    awDuration = awDuration(whichAw);
    anDuration = anDuration(whichAn);
    awLatency = awLatency(whichAw);
    anLatency = anLatency(whichAn);
    
    figure;set(gcf,'position',[680 100 560 882]);
    
    axTempScatter = axes('position',[0.4 0.6 0.55 0.35]); hold on;
    scatter(-awLatency,awDuration,'Marker','o','markerfacecolor','k','markeredgecolor','k');%,'markersize',5
    scatter(-anLatency,anDuration,'Marker','o','markerfacecolor',[0.5 0.5 0.5],'markeredgecolor',[0.5 0.5 0.5]);
    axis square
    set(gca,'xlim',[0 200],'ylim',[0 350],'ytick',[50 150 250 350],'xticklabel',{},'yticklabel',{},'FontName','Times New Roman','FontSize',12);
    
    axLatencyHist = axes('position',[0.4 0.45 0.55 0.125]);hold on;
    edges = 0:20:200;
    nLatencyAw = histc(-awLatency,edges);
    nLatencyAn = histc(-anLatency,edges);
    bh = bar(edges,nLatencyAw,'facecolor','k','edgecolor','none');%set(get(bh,'children'),'facealpha',0.75);
    bh = bar(edges+5,nLatencyAn,'facecolor',[0.5 0.5 0.5],'edgecolor','none');%set(get(bh,'children'),'facealpha',0.75);
    xlabel('Latency to First maximum(ms)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[0 200],'ylim',[0 10],'FontName','Times New Roman','FontSize',12,'ytick',[0 5 10],'xtick',[0 50 100 150 200]);
    
    
    axDurationHist = axes('position',[0.1 0.6 0.25 0.35]); hold on;
    edges = 0:35:350;
    nDurationAw = histc(awDuration,edges);
    nDurationAn = histc(anDuration,edges);
    bh = barh(edges,nDurationAw,'facecolor','k','edgecolor','none');%set(get(bh,'children'),'facealpha',0.75);
    bh = barh(edges+5,nDurationAn,'facecolor',[0.5 0.5 0.5],'edgecolor','none');%set(get(bh,'children'),'facealpha',0.75);
    ylabel('duration of significant deviation(ms)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[0 10],'ylim',[0 350],'FontName','Times New Roman','FontSize',12,'xtick',[0 5 10],'ytick',[50 150 250 350]);
    

    
    peakPowerFreqAw = [];
    peakPowerFreqAn = [];
    
    highFreqCutoffAw = [];
    highFreqCutoffAn = [];
    
    fractionalPowerAw = [];
    fractionalPowerAn = [];
    
    for i = 1:length(factsAw.results)
        peakPowerFreqAw = [peakPowerFreqAw mean(factsAw.results{i}.peakPowerFreq)];
        highFreqCutoffAw = [highFreqCutoffAw mean(factsAw.results{i}.highFreqCutOff)];
        fractionalPowerAw = [fractionalPowerAw mean(factsAw.results{i}.fractionalPowerAtLowTF)];
    end
    
    for i = 1:length(factsAn.results)
        peakPowerFreqAn = [peakPowerFreqAn mean(factsAn.results{i}.peakPowerFreq)];
        highFreqCutoffAn = [highFreqCutoffAn mean(factsAn.results{i}.highFreqCutOff)];
        fractionalPowerAn = [fractionalPowerAn mean(factsAn.results{i}.fractionalPowerAtLowTF)];
    end
    
    whichAw = highFreqCutoffAw<100;
    whichAn = highFreqCutoffAn<100;
    axScatter = axes('position',[0.25 0.1 0.5 0.3]);hold on;
    scatter3(peakPowerFreqAw(whichAw),highFreqCutoffAw(whichAw),fractionalPowerAw(whichAw),'Marker','o','markerfacecolor','k','markeredgecolor','k');
    scatter3(peakPowerFreqAn(whichAn),highFreqCutoffAn(whichAn),fractionalPowerAn(whichAn),'Marker','o','markerfacecolor',[0.5 0.5 0.5],'markeredgecolor',[0.5 0.5 0.5]);
    xlabel('Peak Power Frequency(Hz)');
    ylabel('High Freq cutoff(Hz)');
    zlabel('fraction power at low freq');
end
%% figure 4
if plotFigure4
    factsAwLatency = dbAw.getFacts({'gaussianFullField','timeToFirstMaxDev'});
    factsAnLatency = dbAn.getFacts({'gaussianFullField','timeToFirstMaxDev'});
    awLatency = [factsAwLatency.results{:}];
    anLatency = [factsAnLatency.results{:}];
    
    factsAwDuration = dbAw.getFacts({'gaussianFullField','halfWidthAtFirstMax'});
    factsAnDuration = dbAn.getFacts({'gaussianFullField','halfWidthAtFirstMax'});
    awDuration = [factsAwDuration.results{:}];
    for i = 1:length(factsAnDuration.results)
        if isempty(factsAnDuration.results{i})
            factsAnDuration.results{i} = NaN;
        end
    end
    anDuration = [factsAnDuration.results{:}];
    
    factsAw = dbAw.getFacts({'gaussianFullField','fftOfSTA'});
    factsAn = dbAn.getFacts({'gaussianFullField','fftOfSTA'});
    
    
%     whichAw = awDuration>50 & awDuration<340;
%     whichAn = anDuration>50 & anDuration<340;
%     awDuration = awDuration(whichAw);
%     anDuration = anDuration(whichAn);
%     awLatency = awLatency(whichAw);
%     anLatency = anLatency(whichAn);
    
    figure;set(gcf,'position',[680 100 560 882]);
    
    axLatencyHist = subplot(5,1,1);hold on;
    edges = 0:125/20:125;
    nLatencyAw = histc(-awLatency,edges);
    nLatencyAn = histc(-anLatency,edges);
    bh = bar(edges,nLatencyAw);set(bh,'edgecolor','none','facecolor','k');
    bh = bar(edges+5,nLatencyAn);set(bh,'edgecolor','none','facecolor',[0.5 0.5 0.5]);
    plot([-mean(awLatency) -mean(awLatency)],[9 7],'linewidth',2,'color','k');
    plot([-mean(anLatency) -mean(anLatency)],[9 7],'linewidth',2,'color',[0.5 0.5 0.5]);
    xlabel('Latency to First maximum(ms)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[-5 125],'ylim',[0 15],'FontName','Times New Roman','FontSize',12,'ytick',[0 5 10],'xtick',[0 50 100]);
    title('a','FontName','Times New Roman','FontSize',14);
    
    axDurationHist = subplot(5,1,2); hold on;
    edges = 0:7.5:150;
    nDurationAw = histc(awDuration,edges);
    nDurationAn = histc(anDuration,edges);
    bh = bar(edges,nDurationAw);set(bh,'edgecolor','none','facecolor','k');
    bh = bar(edges+8,nDurationAn);set(bh,'edgecolor','none','facecolor',[0.5 0.5 0.5]);
    plot([mean(awDuration) mean(awDuration)],[9 7],'linewidth',2,'color','k');
    plot([mean(anDuration) mean(anDuration)],[9 7],'linewidth',2,'color',[0.5 0.5 0.5]);
    xlabel('duration of significant deviation(ms)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[-10 150],'ylim',[0 15],'FontName','Times New Roman','FontSize',12,'xtick',[0 50 100],'ytick',[0 5 10]);
    title('b','FontName','Times New Roman','FontSize',14);

    
    peakPowerFreqAw = [];
    peakPowerFreqAn = [];
    
    highFreqCutoffAw = [];
    highFreqCutoffAn = [];
    
    fractionalPowerAw = [];
    fractionalPowerAn = [];
    
    for i = 1:length(factsAw.results)
        peakPowerFreqAw = [peakPowerFreqAw mean(factsAw.results{i}.peakPowerFreq)];
        highFreqCutoffAw = [highFreqCutoffAw mean(factsAw.results{i}.highFreqCutOff)];
        fractionalPowerAw = [fractionalPowerAw mean(factsAw.results{i}.fractionalPowerAtLowTF)];
    end
    
    for i = 1:length(factsAn.results)
        peakPowerFreqAn = [peakPowerFreqAn mean(factsAn.results{i}.peakPowerFreq)];
        highFreqCutoffAn = [highFreqCutoffAn mean(factsAn.results{i}.highFreqCutOff)];
        fractionalPowerAn = [fractionalPowerAn mean(factsAn.results{i}.fractionalPowerAtLowTF)];
    end
    
    axPeakPowerHist = subplot(5,1,3); hold on;
    edges = 0:2:40;
    nPeakPowerAw = histc(peakPowerFreqAw,edges);
    nPeakPowerAn = histc(peakPowerFreqAn,edges);
    bh = bar(edges,nPeakPowerAw);set(bh,'edgecolor','none','facecolor','k');
    bh = bar(edges+0.5,nPeakPowerAn);set(bh,'edgecolor','none','facecolor',[0.5 0.5 0.5]);
    plot([mean(peakPowerFreqAw) mean(peakPowerFreqAw)],[9 7],'linewidth',2,'color','k');
    plot([mean(peakPowerFreqAn) mean(peakPowerFreqAn)],[9 7],'linewidth',2,'color',[0.5 0.5 0.5]);
    xlabel('Peak Power Frequency(Hz)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[-2 42],'ylim',[0 15],'FontName','Times New Roman','FontSize',12,'xtick',[0 10 20 30 40],'ytick',[0 5 10]);
    title('c','FontName','Times New Roman','FontSize',14);
    
    axCutoffHist = subplot(5,1,4); hold on;
    edges = 0:2:40;
    highFreqCutoffAnTemp = highFreqCutoffAn(highFreqCutoffAn<100);
    nCutoffAw = histc(highFreqCutoffAw,edges);
    nCutoffAn = histc(highFreqCutoffAnTemp,edges);
    bh = bar(edges,nCutoffAw);set(bh,'edgecolor','none','facecolor','k');
    bh = bar(edges+0.5,nCutoffAn);set(bh,'edgecolor','none','facecolor',[0.5 0.5 0.5]);
    plot([mean(highFreqCutoffAw) mean(highFreqCutoffAw)],[9 7],'linewidth',2,'color','k');
    plot([mean(highFreqCutoffAnTemp) mean(highFreqCutoffAnTemp)],[9 7],'linewidth',2,'color',[0.5 0.5 0.5]);
    xlabel('High frequency Cutoff(Hz)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[-2 42],'ylim',[0 15],'FontName','Times New Roman','FontSize',12,'xtick',[0 10 20 30 40],'ytick',[0 5 10]);
    title('d','FontName','Times New Roman','FontSize',14);
    
    axFracPowerHist = subplot(5,1,5); hold on;
    edges = 0:0.05:1;
    nFracPowerAw = histc(fractionalPowerAw,edges);
    nFracPowerAn = histc(fractionalPowerAn,edges);
    bh = bar(edges,nFracPowerAw);set(bh,'edgecolor','none','facecolor','k');
    bh = bar(edges+0.01,nFracPowerAn);set(bh,'edgecolor','none','facecolor',[0.5 0.5 0.5]);
    plot([mean(fractionalPowerAw) mean(fractionalPowerAw)],[9 7],'linewidth',2,'color','k');
    plot([mean(fractionalPowerAn) mean(fractionalPowerAn)],[9 7],'linewidth',2,'color',[0.5 0.5 0.5]);
    xlabel('Fractional power at low freq(Hz)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[-0.05 1.05],'ylim',[0 15],'FontName','Times New Roman','FontSize',12,'xtick',[0 0.25 0.5 0.75 1],'ytick',[0 5 10]);
    title('e','FontName','Times New Roman','FontSize',14);
end
%% figure 5
if plotFigure5
    disp('you already have it!');
end
%% figure 6
if plotFigure6
    % awake
    params.excludeNIDs = [10 20 22 24 27 79 112 114];
    f1AwGr = dbAw.getFacts({{'sfGratings',{'f1'}},params});
    f1ShuffAwGr = dbAw.getFacts({{'sfGratings',{'f1Shuffled'}},params});
    f1DPP = dbAw.getFacts({'sfGratings',{'degPerPix'}});
    freqs = [];
    for i = 1:length(f1AwGr.nID)
        freqs = union(freqs,f1AwGr.results{i}{1}{1}*f1DPP.results{i}{1});
    end
    
    f1s = nan(length(f1AwGr.nID),length(freqs));
    for i = 1:length(f1AwGr.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1AwGr.results{i}{1}{1}*f1DPP.results{i}{1})
                posn = find((f1AwGr.results{i}{1}{1}*f1DPP.results{i}{1})==freqs(j));
                f1s(i,j) = f1AwGr.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    
    
    f1sShuff = nan(length(f1ShuffAwGr.nID),length(freqs));
    for i = 1:length(f1ShuffAwGr.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1ShuffAwGr.results{i}{1}{1}*f1DPP.results{i}{1})
                posn = find((f1ShuffAwGr.results{i}{1}{1}*f1DPP.results{i}{1})==freqs(j));
                f1sShuff(i,j) = f1ShuffAwGr.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    f1s = f1s-f1sShuff;
    
    maxF1 = max(f1s,[],2);
    maxF1 = repmat(maxF1,1,length(freqs));
    
    F1Norm = f1s./maxF1;
    F1NormMean = nanmean(F1Norm);
    F1NormSTD = nanstd(F1Norm);
    F1NormSEM = F1NormSTD./sqrt(size(F1Norm,1));
    subplot(4,2,[1:4]);
    plot(log10(1./freqs),F1NormMean,'color',[0 0 0],'linewidth',3,'marker','d','markerfacecolor',[0 0 0]);
    hold on;
    for i = 1:length(F1NormMean)
        plot(log10([1/freqs(i) 1/freqs(i)]),[F1NormMean(i)+F1NormSEM(i) F1NormMean(i)-F1NormSEM(i)],'color',[0 0 0],'linestyle','--','linewidth',2);
    end
    
    % anesth
    params.includeNIDs = 1:dbAn.numNeurons;
    f1AwGr = dbAn.getFacts({{'sfGratings',{'f1'}},params});
    f1ShuffAwGr = dbAn.getFacts({{'sfGratings',{'f1Shuffled'}},params});
    f1DPP = dbAn.getFacts({'sfGratings',{'degPerPix'}});
    
    freqs = [];
    for i = 1:length(f1AwGr.nID)
        freqs = union(freqs,f1AwGr.results{i}{1}{1}*f1DPP.results{i}{1});
    end
    
    f1s = nan(length(f1AwGr.nID),length(freqs));
    for i = 1:length(f1AwGr.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1AwGr.results{i}{1}{1}*f1DPP.results{i}{1})
                posn = find((f1AwGr.results{i}{1}{1}*f1DPP.results{i}{1})==freqs(j));
                f1s(i,j) = f1AwGr.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    
    
    f1sShuff = nan(length(f1ShuffAwGr.nID),length(freqs));
    for i = 1:length(f1ShuffAwGr.nID)
        for j = 1:length(freqs)
            
            if ismember(freqs(j),f1ShuffAwGr.results{i}{1}{1}*f1DPP.results{i}{1})
                posn = find((f1ShuffAwGr.results{i}{1}{1}*f1DPP.results{i}{1})==freqs(j));
                f1sShuff(i,j) = f1ShuffAwGr.results{i}{1}{2}(posn);
            else % leave as is
            end
        end
    end
    f1s = f1s-f1sShuff;
    
    maxF1 = max(f1s,[],2);
    maxF1 = repmat(maxF1,1,length(freqs));
    
    F1Norm = f1s./maxF1;
    F1NormMean = nanmean(F1Norm);
    F1NormSTD = nanstd(F1Norm);
    F1NormSEM = F1NormSTD./sqrt(size(F1Norm,1));
    plot(log10(1./freqs),F1NormMean,'color',[0.6 0.6 0.6],'linewidth',3,'marker','d','markerfacecolor',[0.6 0.6 0.6]);
    hold on;
    for i = 1:length(F1NormMean)
        plot(log10([1/freqs(i) 1/freqs(i)]),[F1NormMean(i)+F1NormSEM(i) F1NormMean(i)-F1NormSEM(i)],'color',[0.6 0.6 0.6],'linestyle','--','linewidth',2);
    end
    
    xticksAt = log10([0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6]);
    xtickLabs = {'0.01','','','','','','','','','0.1','','','','',''};
    set(gca,'xlim',[(-2.1) (-0.2)],'ylim',[-0.1 1],'xtick',xticksAt,'xticklabel',xtickLabs,'FontSize',14)
    xlabel('spatial frequency(cpd)','FontSize',14,'FontName','Times New Roman')
    ylabel('normalized f1','FontSize',14,'FontName','Times New Roman')
    title('a','FontName','Times New Roman','FontSize',20);
    set(gca,'FontName','Times New Roman');
    
    params.color = [0 0 0];
    params.setYLimMinToZero = true;
    axAwLow = subplot(4,2,5);
    dbAw.data{54}.analyses{3}.plot2ax(axAwLow,{'f1',params});
    title('b','FontSize',20,'FontName','Times New Roman');
    xticksAt = log10([0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6]);
    xtickLabs = {'0.01','','','','','','','','','0.1','','','','',''};
    set(gca,'xlim',[(-2.1) (-0.2)],'xtick',xticksAt,'xticklabel',xtickLabs,'FontName','Times New Roman');
    
    axAwMed = subplot(4,2,7);
    dbAw.data{101}.analyses{1}.plot2ax(axAwMed,{'f1',params});
    title('c','FontSize',20,'FontName','Times New Roman');
    xticksAt = log10([0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6]);
    xtickLabs = {'0.01','','','','','','','','','0.1','','','','',''};
    set(gca,'xlim',[(-2.1) (-0.2)],'xtick',xticksAt,'xticklabel',xtickLabs,'FontName','Times New Roman');
    
    params.color = [0.6 0.6 0.6];
    params.setYLimMinToZero = true;
    axAnLow = subplot(4,2,6);
    dbAn.data{21}.analyses{2}.plot2ax(axAnLow,{'f1',params});
    title('d','FontSize',20,'FontName','Times New Roman');
    xticksAt = log10([0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6]);
    xtickLabs = {'0.01','','','','','','','','','0.1','','','','',''};
    set(gca,'xlim',[(-2.1) (-0.2)],'xtick',xticksAt,'xticklabel',xtickLabs,'FontName','Times New Roman');
    
    axAnMed = subplot(4,2,8);
    dbAn.data{15}.analyses{1}.plot2ax(axAnMed,{'f1',params});
    title('e','FontSize',20,'FontName','Times New Roman');
    xticksAt = log10([0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5 0.6]);
    xtickLabs = {'0.01','','','','','','','','','0.1','','','','',''};
    set(gca,'xlim',[(-2.1) (-0.2)],'xtick',xticksAt,'xticklabel',xtickLabs,'FontName','Times New Roman');
end
%% figure 7
if plotFigure7
    params = [];
    params.excludeNIDs = [10 20 22 24 27 79 112 114];
    factsAwPeakF1 = dbAw.getFacts({{'sfGratings',{'peakF1Condition'}},params});
    factsAnPeakF1 = dbAn.getFacts({'sfGratings',{'peakF1Condition'}});
    awPeakF1 = [];
    anPeakF1 = [];
    for i = 1:length(factsAwPeakF1.results)
        awPeakF1 = [awPeakF1 factsAwPeakF1.results{i}{1}];
    end
    for i = 1:length(factsAnPeakF1.results)
        anPeakF1 = [anPeakF1 factsAnPeakF1.results{i}{1}];
    end
    
    params.excludeNIDs = [10 20 22 24 27 79 112 114];
    factsAwSFCutoff = dbAw.getFacts({{'sfGratings',{'highSFCutoff'}},params});
    factsAnSFCutoff = dbAn.getFacts({'sfGratings',{'highSFCutoff'}});
    awSFCutoff = [];
    anSFCutoff = [];
    for i = 1:length(factsAwSFCutoff.results)
        awSFCutoff = [awSFCutoff factsAwSFCutoff.results{i}{1}];
    end
    for i = 1:length(factsAnSFCutoff.results)
        anSFCutoff = [anSFCutoff factsAnSFCutoff.results{i}{1}];
    end
    
    params.excludeNIDs = [10 20 22 24 27 79 112 114];
    factsAwLowSFPower = dbAw.getFacts({{'sfGratings',{'fractionalPowerAtLowSF'}},params});
    factsAnLowSFPower = dbAn.getFacts({'sfGratings',{'fractionalPowerAtLowSF'}});
    awLowSFPower = [];
    anLowSFPower = [];
    for i = 1:length(factsAwLowSFPower.results)
        awLowSFPower = [awLowSFPower factsAwLowSFPower.results{i}{1}];
    end
    for i = 1:length(factsAnLowSFPower.results)
        anLowSFPower = [anLowSFPower factsAnLowSFPower.results{i}{1}];
    end
    
    figure;set(gcf,'position',[680 100 560 882]);
    
    axPeakF1 = subplot(5,1,1);hold on;
    edges = 0:0.01:0.2;
    nLatencyAw = histc(awPeakF1,edges);
    nLatencyAn = histc(anPeakF1,edges);
    bh = bar(edges,nLatencyAw);set(bh,'edgecolor','none','facecolor','k');
    bh = bar(edges+0.002,nLatencyAn);set(bh,'edgecolor','none','facecolor',[0.5 0.5 0.5]);
    plot([mean(awPeakF1) mean(awPeakF1)],[15 10],'linewidth',2,'color','k');
    plot([mean(anPeakF1) mean(anPeakF1)],[15 10],'linewidth',2,'color',[0.5 0.5 0.5]);
    xlabel('Peak response frequency(cpd)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[-0.02 0.25],'ylim',[0 30],'FontName','Times New Roman','FontSize',12,'ytick',[0 15 30],'xtick',[0 0.05 0.1 0.15 0.2]);
    title('a','FontName','Times New Roman','FontSize',14);
    
    axDurationHist = subplot(5,1,2); hold on;
    edges = 0:0.02:0.3;    
    nDurationAw = histc(awSFCutoff,edges);
    nDurationAn = histc(anSFCutoff,edges);
    bh = bar(edges,nDurationAw);set(bh,'edgecolor','none','facecolor','k');
    bh = bar(edges+0.005,nDurationAn);set(bh,'edgecolor','none','facecolor',[0.5 0.5 0.5]);
    plot([mean(awSFCutoff) mean(awSFCutoff)],[20 15],'linewidth',2,'color','k');
    plot([mean(anSFCutoff) mean(anSFCutoff)],[20 15],'linewidth',2,'color',[0.5 0.5 0.5]);
    xlabel('High frequency cutoff(cpd)','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[-0.005 0.3],'ylim',[0 20],'FontName','Times New Roman','FontSize',12,'xtick',[0 0.25 0.5 0.75 1 1.25],'ytick',[0 20 40]);
    title('b','FontName','Times New Roman','FontSize',14);
    
    axDurationHist = subplot(5,1,3); hold on;
    edges = 0:0.05:1;
    nDurationAw = histc(awLowSFPower,edges);
    nDurationAn = histc(anLowSFPower,edges);
    bh = bar(edges,nDurationAw);set(bh,'edgecolor','none','facecolor','k');
    bh = bar(edges+0.01,nDurationAn);set(bh,'edgecolor','none','facecolor',[0.5 0.5 0.5]);
    plot([mean(awLowSFPower) mean(awLowSFPower)],[20 10],'linewidth',2,'color','k');
    plot([mean(anLowSFPower) mean(anLowSFPower)],[20 10],'linewidth',2,'color',[0.5 0.5 0.5]);
    xlabel('Low frequency power','FontName','Times New Roman','FontSize',12);
    set(gca,'xlim',[-0.05 1.1],'ylim',[0 40],'FontName','Times New Roman','FontSize',12,'xtick',[0 0.25 0.5 0.75 1],'ytick',[0 20 40]);
    title('c','FontName','Times New Roman','FontSize',14);
end
end

