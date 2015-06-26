function analyzeSOM_cre
plotOpt = false;
plotCntr = true;
plotSpat = true;
plotOr = true;
%% 9
filter9.imFilter = [];
filter9.optFilter = 1:today;
filter9.ctrFilter = [735169      735171      735172      735173      735174      735175      735176      735178      735179      735180      735181      735182      735183];
filter9.sfFilter = 1:today;
filter9.orFilter = 1:today;
filter9.tfFilter = 1:today;
plotOn = false;
out9 = mouse9(filter9,plotOn);

%% 10
filter10.imFilter = [];
filter10.optFilter = 1:today;
filter10.ctrFilter = [735185 735186 735187 735188 735189 735190 735192 735193 735194 735195 735196 735199]; %[ 735185 735186 735187 735188 735189 735190 735192 735193 735194 735195 735196 735199],[735104 735105 735108 735109 735110 735111 735112 735116 735117 735122 735123 735124 735125 735126 735129 735130 735131 735132 735133 735136 735137 735138 735139]
filter10.sfFilter = 1:today;
filter10.orFilter = 1:today;
filter10.tfFilter = 1:today;
plotOn = false;
out10 = mouse10(filter10,plotOn);

%% 31
filter31.imFilter = [];
filter31.optFilter = 1:today;
filter31.ctrFilter = [735175  735178 735179 735180 735181 735183 735185 735186 735187 735188 735189 735190 735192 735193 735194 735195 735196 735199]; %[735122      735123      735124      735125      735126      735129      735131      735132      735133      735136      735137      735138      735139]  
filter31.sfFilter = 1:today;
filter31.orFilter = 1:today;
filter31.tfFilter = 1:today;
plotOn = false;
out31 = mouse31(filter31,plotOn);

%% 32
filter32.imFilter = [];
filter32.optFilter = 1:today;
filter32.ctrFilter = [735179      735185      735186      735187      735188      735189      735190      735192      735193      735194      735195      735196      735199];
filter32.sfFilter = 1:today;
filter32.orFilter = 1:today;
filter32.tfFilter = 1:today;
plotOn = false;
out32 = mouse32(filter32,plotOn);

%% 34
filter34.imFilter = [];
filter34.optFilter = 1:today;
filter34.ctrFilter = 1:today;
filter34.sfFilter = 1:today;
filter34.orFilter = 1:today;
filter34.tfFilter = 1:today;
plotOn = false;
out34 = mouse34(filter34,plotOn);

%% STANDARD
if plotOpt
    figure;
    subplot(2,2,1); hold on;
    plot([1 2],[out22.optData.performanceByConditionWCO(1,3) out22.optData.performanceByConditionWCO(1,4)],'k','linewidth',2);
    plot([1 2],[out23.optData.performanceByConditionWCO(1,3) out23.optData.performanceByConditionWCO(1,4)],'k','linewidth',2);
    plot([1 2],[out25.optData.performanceByConditionWCO(1,3) out25.optData.performanceByConditionWCO(1,4)],'k','linewidth',2);
    plot([1 1 1],[out22.optData.performanceByConditionWCO(1,3) out23.optData.performanceByConditionWCO(1,3) out25.optData.performanceByConditionWCO(1,3)],'bd','markerSize',10,'markerfacecolor','b');
    plot([1 1],[out22.optData.performanceByConditionWCO(2,3) out22.optData.performanceByConditionWCO(3,3)],'linewidth',5,'color','b');
    plot([1 1],[out23.optData.performanceByConditionWCO(2,3) out23.optData.performanceByConditionWCO(3,3)],'linewidth',5,'color','b');
    plot([1 1],[out25.optData.performanceByConditionWCO(2,3) out25.optData.performanceByConditionWCO(3,3)],'linewidth',5,'color','b');
    plot([2 2 2],[out22.optData.performanceByConditionWCO(1,4) out23.optData.performanceByConditionWCO(1,4) out25.optData.performanceByConditionWCO(1,4)],'rd','markerSize',10,'markerfacecolor','r');
    plot([2 2],[out22.optData.performanceByConditionWCO(2,4) out22.optData.performanceByConditionWCO(3,4)],'linewidth',5,'color','r');
    plot([2 2],[out23.optData.performanceByConditionWCO(2,4) out23.optData.performanceByConditionWCO(3,4)],'linewidth',5,'color','r');
    plot([2 2],[out25.optData.performanceByConditionWCO(2,4) out25.optData.performanceByConditionWCO(3,4)],'linewidth',5,'color','r');
    plot([0.5 2.5],[0.5 0.5],'k-');plot([0.5 2.5],[0.7 0.7],'k--');
    set(gca,'xlim',[0.5 2.5],'ylim',[0.45 1],'xtick',[1 2],'xticklabel',{'Pre-Lesion','Post-Lesion'},'ytick',[0.2 0.5 0.7 1],'FontName','Times New Roman','FontSize',12);
    
    subplot(2,2,2); hold on;
    dates22 = [735239 735241 735242];
    dates23 = [735239 735241 735242];
    dates25 = [735239 735241 735242];
    plot([1 2 3],out22.optData.performanceByDate(1,ismember(out22.optData.dates,dates22)),'linewidth',3,'color','r','marker','d','markersize',5);
    plot([1 2 3],out23.optData.performanceByDate(1,ismember(out23.optData.dates,dates23)),'linewidth',3,'color','r','marker','d','markersize',5);
    plot([1 2 3],out25.optData.performanceByDate(1,ismember(out25.optData.dates,dates25)),'linewidth',3,'color','r','marker','d','markersize',5);
    plot([0.5 3.5],[0.5 0.5],'k-');plot([0.5 3.5],[0.7 0.7],'k--');
    set(gca,'xlim',[0.5 3.5],'ylim',[0.45 1],'xtick',[1 2 3],'ytick',[0.2 0.5 0.7 1],'FontName','Times New Roman','FontSize',12);
end
%% CONTRAST
if plotCntr
    % 9 10 31 32 34
    figure;
    ax = subplot(1,1,1); hold on;
    contrasts = out9.ctrData.contrasts;
    yPBS = nan(5,length(contrasts));
    
    yVal = squeeze(out9.ctrData.performanceByConditionWCO(:,1,1));
    plot(out9.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out9.ctrData.contrasts)
        which = ismember(contrasts,out9.ctrData.contrasts(i));
        yPBS(1,which) = out9.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out31.ctrData.performanceByConditionWCO(:,1,1));
    plot(out31.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out31.ctrData.contrasts)
        which = ismember(contrasts,out31.ctrData.contrasts(i));
        yPBS(2,which) = out31.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out32.ctrData.performanceByConditionWCO(:,1,1));
    plot(out32.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out32.ctrData.contrasts)
        which = ismember(contrasts,out32.ctrData.contrasts(i));
        yPBS(3,which) = out32.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out34.ctrData.performanceByConditionWCO(:,1,1));
    plot(out34.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out34.ctrData.contrasts)
        which = ismember(contrasts,out34.ctrData.contrasts(i));
        yPBS(4,which) = out34.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out10.ctrData.performanceByConditionWCO(:,1,1));
    plot(out10.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out10.ctrData.contrasts)
        which = ismember(contrasts,out10.ctrData.contrasts(i));
        yPBS(5,which) = out10.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yCNO = nan(5,length(contrasts));
    yVal = squeeze(out9.ctrData.performanceByConditionWCO(:,1,2));
    plot(out9.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out9.ctrData.contrasts)
        which = ismember(contrasts,out9.ctrData.contrasts(i));
        yCNO(1,which) = out9.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out31.ctrData.performanceByConditionWCO(:,1,2));
    plot(out31.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out31.ctrData.contrasts)
        which = ismember(contrasts,out31.ctrData.contrasts(i));
        yCNO(2,which) = out31.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out32.ctrData.performanceByConditionWCO(:,1,2));
    plot(out32.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out32.ctrData.contrasts)
        which = ismember(contrasts,out32.ctrData.contrasts(i));
        yCNO(3,which) = out32.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out34.ctrData.performanceByConditionWCO(:,1,2));
    plot(out34.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out34.ctrData.contrasts)
        which = ismember(contrasts,out34.ctrData.contrasts(i));
        yCNO(4,which) = out34.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out10.ctrData.performanceByConditionWCO(:,1,2));
    plot(out10.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out10.ctrData.contrasts)
        which = ismember(contrasts,out10.ctrData.contrasts(i));
        yCNO(5,which) = out10.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    avgPBS = nanmean(yPBS,1);
    stdPBS = nanstd(yPBS,[],1);
    nPBS = sum(~isnan(yPBS),1);
    whichgood = ~isnan(avgPBS);
    avgPBS = avgPBS(whichgood);
    stdPBS = stdPBS(whichgood);
    nPBS = nPBS(whichgood);
    contrastsPBS = contrasts(whichgood);
    semPBS = stdPBS./sqrt(nPBS);
    plot(contrastsPBS,avgPBS,'d-','color',[0,0,1],'markerfacecolor','b','markersize',5,'linewidth',4);
    for i = 1:length(contrastsPBS)
        plot([contrastsPBS(i) contrastsPBS(i)],[avgPBS(i)-semPBS(i) avgPBS(i)+semPBS(i)],'b','linewidth',2);
    end
    
    avgCNO = nanmean(yCNO,1);
    stdCNO = nanstd(yCNO,[],1);
    nCNO = sum(~isnan(yCNO),1);
    whichgood = ~isnan(avgCNO);
    avgCNO = avgCNO(whichgood);
    stdCNO = stdCNO(whichgood);
    nCNO = nCNO(whichgood);
    contrastsCNO = contrasts(whichgood);
    semCNO = stdCNO./sqrt(nCNO);
    plot(contrastsCNO,avgCNO,'d-','color',[1,.5,0.27],'markerfacecolor','r','markersize',5,'linewidth',4);
    for i = 1:length(contrastsCNO)
        plot([contrastsCNO(i) contrastsCNO(i)],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'color',[1,.5,0.27],'linewidth',2);
    end
    
    set(ax,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',24);plot([0 1],[0.5 0.5],'k-','linewidth',2);plot([0 1],[0.7 0.7],'k--','linewidth',2);
    xlabel('Contrast','FontName','Times New Roman','FontSize',24);
    ylabel('PCorrect','FontName','Times New Roman','FontSize',24);       
end

%% SPAT FREQ
if plotSpat
        figure;
    ax = subplot(1,1,1); hold on;
    spatFreqs = out9.spatData.spatFreqs;
    yPBS = nan(6,length(spatFreqs));
    
    yVal = squeeze(out9.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out9.spatData.spatFreqs(~isnan(yVal))/12)));
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out9.spatData.spatFreqs)
        which = ismember(spatFreqs,out9.spatData.spatFreqs(i));
        yPBS(1,which) = out9.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out31.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out31.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out31.spatData.spatFreqs)
        which = ismember(spatFreqs,out31.spatData.spatFreqs(i));
        yPBS(2,which) = out31.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out32.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out32.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out32.spatData.spatFreqs)
        which = ismember(spatFreqs,out32.spatData.spatFreqs(i));
        yPBS(3,which) = out32.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out34.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out34.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out34.spatData.spatFreqs)
        which = ismember(spatFreqs,out34.spatData.spatFreqs(i));
        yPBS(4,which) = out34.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out9.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out9.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out9.spatData.spatFreqs)
        which = ismember(spatFreqs,out9.spatData.spatFreqs(i));
        yPBS(6,which) = out9.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yCNO = nan(6,length(spatFreqs));
    yVal = squeeze(out9.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out9.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out9.spatData.spatFreqs)
        which = ismember(spatFreqs,out9.spatData.spatFreqs(i));
        yCNO(1,which) = out9.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out31.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out31.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out31.spatData.spatFreqs)
        which = ismember(spatFreqs,out31.spatData.spatFreqs(i));
        yCNO(2,which) = out31.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out32.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out32.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out32.spatData.spatFreqs)
        which = ismember(spatFreqs,out32.spatData.spatFreqs(i));
        yCNO(3,which) = out32.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out34.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out34.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out34.spatData.spatFreqs)
        which = ismember(spatFreqs,out34.spatData.spatFreqs(i));
        yCNO(4,which) = out34.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out34.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out34.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out34.spatData.spatFreqs)
        which = ismember(spatFreqs,out34.spatData.spatFreqs(i));
        yCNO(5,which) = out34.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out9.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out9.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out9.spatData.spatFreqs)
        which = ismember(spatFreqs,out9.spatData.spatFreqs(i));
        yCNO(6,which) = out9.spatData.performanceByConditionWCO(i,1,2);
    end
    
    avgPBS = nanmean(yPBS,1);
    stdPBS = nanstd(yPBS,[],1);
    nPBS = sum(~isnan(yPBS),1);
    whichgood = ~isnan(avgPBS);
    avgPBS = avgPBS(whichgood);
    stdPBS = stdPBS(whichgood);
    nPBS = nPBS(whichgood);
    spatFreqsPBS = spatFreqs(whichgood);
    semPBS = stdPBS./sqrt(nPBS);
    plot(log10(1./rad2deg(atan(44.7/1024*spatFreqsPBS/12))),avgPBS,'db-','markerfacecolor','b','markersize',5,'linewidth',4);
    for i = 1:length(spatFreqsPBS)
        plot([log10(1./rad2deg(atan(44.7/1024*spatFreqsPBS(i)/12))) log10(1./rad2deg(atan(44.7/1024*spatFreqsPBS(i)/12)))],[avgPBS(i)-semPBS(i) avgPBS(i)+semPBS(i)],'b','linewidth',2);
    end
    
    avgCNO = nanmean(yCNO,1);
    stdCNO = nanstd(yCNO,[],1);
    nCNO = sum(~isnan(yCNO),1);
    whichgood = ~isnan(avgCNO);
    avgCNO = avgCNO(whichgood);
    stdCNO = stdCNO(whichgood);
    nCNO = nCNO(whichgood);
    spatFreqsCNO = spatFreqs(whichgood);
    semCNO = stdCNO./sqrt(nCNO);
    plot(log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO/12))),avgCNO,'d-','color',[1,.5,0.27],'markerfacecolor','r','markersize',5,'linewidth',4);
    for i = 1:length(spatFreqsCNO)
        plot([log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO(i)/12))) log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO(i)/12)))],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'color',[1,.5,0.27],'linewidth',2);
    end
    xticks = log10([0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2]);
    xticklabs = {'0.01','','','','','','','','','0.1','0.2'};
    set(ax,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',[log10(0.0075) log10(0.25)],'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('spat.freq.','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end

%% OR
if plotOr
        figure;
    ax = subplot(1,1,1); hold on;
    orientations = out31.orData.orientations;
    yPBS = nan(6,length(orientations));
%     
%     yVal = squeeze(out9.orData.performanceByConditionWCO(:,1,1));
%     xloc = out9.orData.orientations(~isnan(yVal));
%     plot(xloc,yVal(~isnan(yVal)),'b');
%     for i = 1:length(out9.orData.orientations)
%         which = ismember(orientations,out9.orData.orientations(i));
%         yPBS(1,which) = out9.orData.performanceByConditionWCO(i,1,1);
%     end
    
    yVal = squeeze(out31.orData.performanceByConditionWCO(:,1,1));
    xloc = out31.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out31.orData.orientations)
        which = ismember(orientations,out31.orData.orientations(i));
        yPBS(2,which) = out31.orData.performanceByConditionWCO(i,1,1);
    end
%     
%     yVal = squeeze(out32.orData.performanceByConditionWCO(:,1,1));
%     xloc = out32.orData.orientations(~isnan(yVal));    
%     plot(xloc,yVal(~isnan(yVal)),'b');
%     for i = 1:length(out32.orData.orientations)
%         which = ismember(orientations,out32.orData.orientations(i));
%         yPBS(3,which) = out32.orData.performanceByConditionWCO(i,1,1);
%     end
    
%     yVal = squeeze(out34.orData.performanceByConditionWCO(:,1,1));
%     xloc = out34.orData.orientations(~isnan(yVal));    
%     plot(xloc,yVal(~isnan(yVal)),'b');
%     for i = 1:length(out34.orData.orientations)
%         which = ismember(orientations,out34.orData.orientations(i));
%         yPBS(4,which) = out34.orData.performanceByConditionWCO(i,1,1);
%     end
%     
    yVal = squeeze(out10.orData.performanceByConditionWCO(:,1,1));
    xloc = out34.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out34.orData.orientations)
        which = ismember(orientations,out34.orData.orientations(i));
        yPBS(5,which) = out34.orData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out9.orData.performanceByConditionWCO(:,1,1));
    xloc = out9.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out9.orData.orientations)
        which = ismember(orientations,out9.orData.orientations(i));
        yPBS(6,which) = out9.orData.performanceByConditionWCO(i,1,1);
    end
    
    yCNO = nan(6,length(orientations));
    yVal = squeeze(out9.orData.performanceByConditionWCO(:,1,2));
    xloc = out9.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out9.orData.orientations)
        which = ismember(orientations,out9.orData.orientations(i));
        yCNO(1,which) = out9.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out31.orData.performanceByConditionWCO(:,1,2));
    xloc = out31.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out31.orData.orientations)
        which = ismember(orientations,out31.orData.orientations(i));
        yCNO(2,which) = out31.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out32.orData.performanceByConditionWCO(:,1,2));
    xloc = out32.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out32.orData.orientations)
        which = ismember(orientations,out32.orData.orientations(i));
        yCNO(3,which) = out32.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out34.orData.performanceByConditionWCO(:,1,2));
    xloc = out34.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out34.orData.orientations)
        which = ismember(orientations,out34.orData.orientations(i));
        yCNO(4,which) = out34.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out34.orData.performanceByConditionWCO(:,1,2));
    xloc = out34.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out34.orData.orientations)
        which = ismember(orientations,out34.orData.orientations(i));
        yCNO(5,which) = out34.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out9.orData.performanceByConditionWCO(:,1,2));
    xloc = out9.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out9.orData.orientations)
        which = ismember(orientations,out9.orData.orientations(i));
        yCNO(6,which) = out9.orData.performanceByConditionWCO(i,1,2);
    end
    
    avgPBS = nanmean(yPBS,1);
    stdPBS = nanstd(yPBS,[],1);
    nPBS = sum(~isnan(yPBS),1);
    whichgood = ~isnan(avgPBS);
    avgPBS = avgPBS(whichgood);
    stdPBS = stdPBS(whichgood);
    nPBS = nPBS(whichgood);
    orientationsPBS = orientations(whichgood);
    semPBS = stdPBS./sqrt(nPBS);
    plot(orientationsPBS,avgPBS,'db-','markerfacecolor','b','markersize',5,'linewidth',4);
    for i = 1:length(orientationsPBS)
        plot([orientationsPBS(i) orientationsPBS(i)],[avgPBS(i)-semPBS(i) avgPBS(i)+semPBS(i)],'b','linewidth',2);
    end
    
    avgCNO = nanmean(yCNO,1);
    stdCNO = nanstd(yCNO,[],1);
    nCNO = sum(~isnan(yCNO),1);
    whichgood = ~isnan(avgCNO);
    avgCNO = avgCNO(whichgood);
    stdCNO = stdCNO(whichgood);
    nCNO = nCNO(whichgood);
    orientationsCNO = orientations(whichgood);
    semCNO = stdCNO./sqrt(nCNO);
    plot(orientationsCNO,avgCNO,'d-','color',[1,.5,0.27],'markerfacecolor','r','markersize',5,'linewidth',4);
    for i = 1:length(orientationsCNO)
        plot([orientationsCNO(i) orientationsCNO(i)],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'color',[1,.5,0.27],'linewidth',2);
    end
    xticks = [0 5 15 25 35 45];
    xticklabs = {'0','5','15','25','35','45'};
    set(ax,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',[-5 50],'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('Orientations','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end

%% TEMP FREQ
if plotTemp
        figure;
    ax = subplot(1,1,1); hold on;
    tempFreqs = out9.tempData.tempFreqs;
    yPBS = nan(6,length(tempFreqs));
    
    yVal = squeeze(out9.tempData.performanceByConditionWCO(:,1,1));
    xloc = out9.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out9.tempData.tempFreqs)
        which = ismember(tempFreqs,out9.tempData.tempFreqs(i));
        yPBS(1,which) = out9.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out31.tempData.performanceByConditionWCO(:,1,1));
    xloc = out31.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out31.tempData.tempFreqs)
        which = ismember(tempFreqs,out31.tempData.tempFreqs(i));
        yPBS(2,which) = out31.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out32.tempData.performanceByConditionWCO(:,1,1));
    xloc = out32.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out32.tempData.tempFreqs)
        which = ismember(tempFreqs,out32.tempData.tempFreqs(i));
        yPBS(3,which) = out32.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out34.tempData.performanceByConditionWCO(:,1,1));
    xloc = out34.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out34.tempData.tempFreqs)
        which = ismember(tempFreqs,out34.tempData.tempFreqs(i));
        yPBS(4,which) = out34.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out34.tempData.performanceByConditionWCO(:,1,1));
    xloc = out34.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out34.tempData.tempFreqs)
        which = ismember(tempFreqs,out34.tempData.tempFreqs(i));
        yPBS(5,which) = out34.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out9.tempData.performanceByConditionWCO(:,1,1));
    xloc = out9.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out9.tempData.tempFreqs)
        which = ismember(tempFreqs,out9.tempData.tempFreqs(i));
        yPBS(6,which) = out9.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yCNO = nan(6,length(tempFreqs));
    yVal = squeeze(out9.tempData.performanceByConditionWCO(:,1,2));
    xloc = out9.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out9.tempData.tempFreqs)
        which = ismember(tempFreqs,out9.tempData.tempFreqs(i));
        yCNO(1,which) = out9.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out31.tempData.performanceByConditionWCO(:,1,2));
    xloc = out31.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out31.tempData.tempFreqs)
        which = ismember(tempFreqs,out31.tempData.tempFreqs(i));
        yCNO(2,which) = out31.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out32.tempData.performanceByConditionWCO(:,1,2));
    xloc = out32.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out32.tempData.tempFreqs)
        which = ismember(tempFreqs,out32.tempData.tempFreqs(i));
        yCNO(3,which) = out32.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out34.tempData.performanceByConditionWCO(:,1,2));
    xloc = out34.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out34.tempData.tempFreqs)
        which = ismember(tempFreqs,out34.tempData.tempFreqs(i));
        yCNO(4,which) = out34.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out34.tempData.performanceByConditionWCO(:,1,2));
    xloc = out34.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out34.tempData.tempFreqs)
        which = ismember(tempFreqs,out34.tempData.tempFreqs(i));
        yCNO(5,which) = out34.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out9.tempData.performanceByConditionWCO(:,1,2));
    xloc = out9.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'color',[1,.5,0.27]);
    for i = 1:length(out9.tempData.tempFreqs)
        which = ismember(tempFreqs,out9.tempData.tempFreqs(i));
        yCNO(6,which) = out9.tempData.performanceByConditionWCO(i,1,2);
    end
    
    avgPBS = nanmean(yPBS,1);
    stdPBS = nanstd(yPBS,[],1);
    nPBS = sum(~isnan(yPBS),1);
    whichgood = ~isnan(avgPBS);
    avgPBS = avgPBS(whichgood);
    stdPBS = stdPBS(whichgood);
    nPBS = nPBS(whichgood);
    tempFreqsPBS = tempFreqs(whichgood);tempFreqsPBS(tempFreqsPBS==0) = 0.1;
    semPBS = stdPBS./sqrt(nPBS);
    plot(log2(tempFreqsPBS),avgPBS,'db-','markerfacecolor','b','markersize',5,'linewidth',4);
    for i = 1:length(tempFreqsPBS)
        plot([log2(tempFreqsPBS(i)) log2(tempFreqsPBS(i))],[avgPBS(i)-semPBS(i) avgPBS(i)+semPBS(i)],'b','linewidth',2);
    end
    
    avgCNO = nanmean(yCNO,1);
    stdCNO = nanstd(yCNO,[],1);
    nCNO = sum(~isnan(yCNO),1);
    whichgood = ~isnan(avgCNO);
    avgCNO = avgCNO(whichgood);
    stdCNO = stdCNO(whichgood);
    nCNO = nCNO(whichgood);
    tempFreqsCNO = tempFreqs(whichgood);tempFreqsCNO(tempFreqsCNO==0) = 0.1;
    semCNO = stdCNO./sqrt(nCNO);
    plot(log2(tempFreqsCNO),avgCNO,'d-','color',[1,.5,0.27],'markerfacecolor','r','markersize',5,'linewidth',4);
    for i = 1:length(tempFreqsCNO)
        plot([log2(tempFreqsCNO(i)) log2(tempFreqsCNO(i))],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'color',[1,.5,0.27],'linewidth',2);
    end
    xticks = log2([0.0625 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20]);
    xticklabs = {'','0','','','','','','','','','1','','','','','','','','','10',''};
    set(ax,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',log2([0.0625 32]),'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('temp.freq.','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end
