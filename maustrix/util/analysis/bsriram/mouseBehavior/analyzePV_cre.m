function analyzePV_cre
plotOpt = false;
plotCntr = true;
plotSpat = true;
%% 11
filter11.imFilter = [];
filter11.optFilter = 735122:735199;
filter11.ctrFilter = 735122:735199;
filter11.sfFilter = 735122:735199;
filter11.orFilter = 735122:735199;
filter11.tfFilter = 735122:735199;
plotOn = false;
out11 = mouse11(filter11,plotOn);

%% 13
filter13.imFilter = [];
filter13.optFilter = 735096:735199;
filter13.ctrFilter = [735185 735186 735187 735188 735189 735190 735192 735193 735194 735195 735196 735199]; %[ 735185 735186 735187 735188 735189 735190 735192 735193 735194 735195 735196 735199],[735104 735105 735108 735109 735110 735111 735112 735116 735117 735122 735123 735124 735125 735126 735129 735130 735131 735132 735133 735136 735137 735138 735139]
filter13.sfFilter = 735122:735199;
filter13.orFilter = 735122:735199;
filter13.tfFilter = 735122:735199;
plotOn = false;
out13 = mouse13(filter13,plotOn);

%% 17
filter17.imFilter = [];
filter17.optFilter = 1:today;
filter17.ctrFilter = [735175  735178 735179 735180 735181 735183 735185 735186 735187 735188 735189 735190 735192 735193 735194 735195 735196 735199]; %[735122      735123      735124      735125      735126      735129      735131      735132      735133      735136      735137      735138      735139]  
filter17.sfFilter = 1:today;
filter17.orFilter = 1:today;
filter17.tfFilter = 1:today;
plotOn = false;
out17 = mouse17(filter17,plotOn);

%% 18
filter18.imFilter = [];
filter18.optFilter = 1:today;
filter18.ctrFilter = [735179      735185      735186      735187      735188      735189      735190      735192      735193      735194      735195      735196      735199];
filter18.sfFilter = 1:today;
filter18.orFilter = 1:today;
filter18.tfFilter = 1:today;
plotOn = false;
out18 = mouse18(filter18,plotOn);

%% 19
filter19.imFilter = [];
filter19.optFilter = 1:today;
filter19.ctrFilter = 1:today;
filter19.sfFilter = 1:today;
filter19.orFilter = 1:today;
filter19.tfFilter = 1:today;
plotOn = false;
out19 = mouse19(filter19,plotOn);

%% 20
filter20.imFilter = [];
filter20.optFilter = 1:today;
filter20.ctrFilter = 1:today
filter20.sfFilter = 1:today;
filter20.orFilter = 1:today;
filter20.tfFilter = 1:today;
plotOn = false;
out20 = mouse20(filter20,plotOn);

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
    % 11 13 17 18 19 20
    figure;
    ax = subplot(1,1,1); hold on;
    contrasts = out13.ctrData.contrasts;
    yPBS = nan(5,length(contrasts));
    
    yVal = squeeze(out13.ctrData.performanceByConditionWCO(:,1,1));
    plot(out13.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out13.ctrData.contrasts)
        which = ismember(contrasts,out13.ctrData.contrasts(i));
        yPBS(1,which) = out13.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out17.ctrData.performanceByConditionWCO(:,1,1));
    plot(out17.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out17.ctrData.contrasts)
        which = ismember(contrasts,out17.ctrData.contrasts(i));
        yPBS(2,which) = out17.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out18.ctrData.performanceByConditionWCO(:,1,1));
    plot(out18.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out18.ctrData.contrasts)
        which = ismember(contrasts,out18.ctrData.contrasts(i));
        yPBS(3,which) = out18.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out19.ctrData.performanceByConditionWCO(:,1,1));
    plot(out19.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out19.ctrData.contrasts)
        which = ismember(contrasts,out19.ctrData.contrasts(i));
        yPBS(4,which) = out19.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out20.ctrData.performanceByConditionWCO(:,1,1));
    plot(out20.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
    for i = 1:length(out20.ctrData.contrasts)
        which = ismember(contrasts,out20.ctrData.contrasts(i));
        yPBS(5,which) = out20.ctrData.performanceByConditionWCO(i,1,1);
    end
    
    yCNO = nan(5,length(contrasts));
    yVal = squeeze(out13.ctrData.performanceByConditionWCO(:,1,2));
    plot(out13.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'r');
    for i = 1:length(out13.ctrData.contrasts)
        which = ismember(contrasts,out13.ctrData.contrasts(i));
        yCNO(1,which) = out13.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out17.ctrData.performanceByConditionWCO(:,1,2));
    plot(out17.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'r');
    for i = 1:length(out17.ctrData.contrasts)
        which = ismember(contrasts,out17.ctrData.contrasts(i));
        yCNO(2,which) = out17.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out18.ctrData.performanceByConditionWCO(:,1,2));
    plot(out18.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'r');
    for i = 1:length(out18.ctrData.contrasts)
        which = ismember(contrasts,out18.ctrData.contrasts(i));
        yCNO(3,which) = out18.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out19.ctrData.performanceByConditionWCO(:,1,2));
    plot(out19.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'r');
    for i = 1:length(out19.ctrData.contrasts)
        which = ismember(contrasts,out19.ctrData.contrasts(i));
        yCNO(4,which) = out19.ctrData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out20.ctrData.performanceByConditionWCO(:,1,2));
    plot(out20.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'r');
    for i = 1:length(out20.ctrData.contrasts)
        which = ismember(contrasts,out20.ctrData.contrasts(i));
        yCNO(5,which) = out20.ctrData.performanceByConditionWCO(i,1,2);
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
    plot(contrastsPBS,avgPBS,'db-','markerfacecolor','b','markersize',5,'linewidth',4);
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
    plot(contrastsCNO,avgCNO,'dr-','markerfacecolor','r','markersize',5,'linewidth',4);
    for i = 1:length(contrastsCNO)
        plot([contrastsCNO(i) contrastsCNO(i)],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'r','linewidth',2);
    end
    
    set(ax,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
    xlabel('contrast','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end

%% SPAT FREQ
if plotSpat
        figure;
    ax = subplot(1,1,1); hold on;
    spatFreqs = out13.spatData.spatFreqs;
    yPBS = nan(6,length(spatFreqs));
    
    yVal = squeeze(out13.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out13.spatData.spatFreqs(~isnan(yVal))/12)));
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out13.spatData.spatFreqs)
        which = ismember(spatFreqs,out13.spatData.spatFreqs(i));
        yPBS(1,which) = out13.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out17.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out17.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out17.spatData.spatFreqs)
        which = ismember(spatFreqs,out17.spatData.spatFreqs(i));
        yPBS(2,which) = out17.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out18.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out18.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out18.spatData.spatFreqs)
        which = ismember(spatFreqs,out18.spatData.spatFreqs(i));
        yPBS(3,which) = out18.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out19.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out19.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out19.spatData.spatFreqs)
        which = ismember(spatFreqs,out19.spatData.spatFreqs(i));
        yPBS(4,which) = out19.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out20.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out20.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out20.spatData.spatFreqs)
        which = ismember(spatFreqs,out20.spatData.spatFreqs(i));
        yPBS(5,which) = out20.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out11.spatData.performanceByConditionWCO(:,1,1));
    xloc = log10(1./rad2deg(atan(44.7/1024*out11.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out11.spatData.spatFreqs)
        which = ismember(spatFreqs,out11.spatData.spatFreqs(i));
        yPBS(6,which) = out11.spatData.performanceByConditionWCO(i,1,1);
    end
    
    yCNO = nan(6,length(spatFreqs));
    yVal = squeeze(out13.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out13.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out13.spatData.spatFreqs)
        which = ismember(spatFreqs,out13.spatData.spatFreqs(i));
        yCNO(1,which) = out13.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out17.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out17.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out17.spatData.spatFreqs)
        which = ismember(spatFreqs,out17.spatData.spatFreqs(i));
        yCNO(2,which) = out17.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out18.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out18.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out18.spatData.spatFreqs)
        which = ismember(spatFreqs,out18.spatData.spatFreqs(i));
        yCNO(3,which) = out18.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out19.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out19.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out19.spatData.spatFreqs)
        which = ismember(spatFreqs,out19.spatData.spatFreqs(i));
        yCNO(4,which) = out19.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out20.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out20.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out20.spatData.spatFreqs)
        which = ismember(spatFreqs,out20.spatData.spatFreqs(i));
        yCNO(5,which) = out20.spatData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out11.spatData.performanceByConditionWCO(:,1,2));
    xloc = log10(1./rad2deg(atan(44.7/1024*out11.spatData.spatFreqs(~isnan(yVal))/12)));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out11.spatData.spatFreqs)
        which = ismember(spatFreqs,out11.spatData.spatFreqs(i));
        yCNO(6,which) = out11.spatData.performanceByConditionWCO(i,1,2);
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
    plot(log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO/12))),avgCNO,'dr-','markerfacecolor','r','markersize',5,'linewidth',4);
    for i = 1:length(spatFreqsCNO)
        plot([log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO(i)/12))) log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO(i)/12)))],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'r','linewidth',2);
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
    orientations = out13.orData.orientations;
    yPBS = nan(6,length(orientations));
    
    yVal = squeeze(out13.orData.performanceByConditionWCO(:,1,1));
    xloc = out13.orData.orientations(~isnan(yVal));
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out13.orData.orientations)
        which = ismember(orientations,out13.orData.orientations(i));
        yPBS(1,which) = out13.orData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out17.orData.performanceByConditionWCO(:,1,1));
    xloc = out17.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out17.orData.orientations)
        which = ismember(orientations,out17.orData.orientations(i));
        yPBS(2,which) = out17.orData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out18.orData.performanceByConditionWCO(:,1,1));
    xloc = out18.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out18.orData.orientations)
        which = ismember(orientations,out18.orData.orientations(i));
        yPBS(3,which) = out18.orData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out19.orData.performanceByConditionWCO(:,1,1));
    xloc = out19.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out19.orData.orientations)
        which = ismember(orientations,out19.orData.orientations(i));
        yPBS(4,which) = out19.orData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out20.orData.performanceByConditionWCO(:,1,1));
    xloc = out20.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out20.orData.orientations)
        which = ismember(orientations,out20.orData.orientations(i));
        yPBS(5,which) = out20.orData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out11.orData.performanceByConditionWCO(:,1,1));
    xloc = out11.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'b');
    for i = 1:length(out11.orData.orientations)
        which = ismember(orientations,out11.orData.orientations(i));
        yPBS(6,which) = out11.orData.performanceByConditionWCO(i,1,1);
    end
    
    yCNO = nan(6,length(orientations));
    yVal = squeeze(out13.orData.performanceByConditionWCO(:,1,2));
    xloc = out13.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out13.orData.orientations)
        which = ismember(orientations,out13.orData.orientations(i));
        yCNO(1,which) = out13.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out17.orData.performanceByConditionWCO(:,1,2));
    xloc = out17.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out17.orData.orientations)
        which = ismember(orientations,out17.orData.orientations(i));
        yCNO(2,which) = out17.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out18.orData.performanceByConditionWCO(:,1,2));
    xloc = out18.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out18.orData.orientations)
        which = ismember(orientations,out18.orData.orientations(i));
        yCNO(3,which) = out18.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out19.orData.performanceByConditionWCO(:,1,2));
    xloc = out19.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out19.orData.orientations)
        which = ismember(orientations,out19.orData.orientations(i));
        yCNO(4,which) = out19.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out20.orData.performanceByConditionWCO(:,1,2));
    xloc = out20.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out20.orData.orientations)
        which = ismember(orientations,out20.orData.orientations(i));
        yCNO(5,which) = out20.orData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out11.orData.performanceByConditionWCO(:,1,2));
    xloc = out11.orData.orientations(~isnan(yVal));    
    plot(xloc,yVal(~isnan(yVal)),'r');
    for i = 1:length(out11.orData.orientations)
        which = ismember(orientations,out11.orData.orientations(i));
        yCNO(6,which) = out11.orData.performanceByConditionWCO(i,1,2);
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
    plot(orientationsCNO,avgCNO,'dr-','markerfacecolor','r','markersize',5,'linewidth',4);
    for i = 1:length(orientationsCNO)
        plot([orientationsCNO(i) orientationsCNO(i)],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'r','linewidth',2);
    end
    xticks = [0 5 15 25 35 45];
    xticklabs = {'0','5','15','25','35','45'};
    set(ax,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',[-5 50],'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('Orientations','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end

%% SPAT FREQ
if plotTemp
        figure;
    ax = subplot(1,1,1); hold on;
    tempFreqs = out13.tempData.tempFreqs;
    yPBS = nan(6,length(tempFreqs));
    
    yVal = squeeze(out13.tempData.performanceByConditionWCO(:,1,1));
    xloc = out13.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out13.tempData.tempFreqs)
        which = ismember(tempFreqs,out13.tempData.tempFreqs(i));
        yPBS(1,which) = out13.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out17.tempData.performanceByConditionWCO(:,1,1));
    xloc = out17.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out17.tempData.tempFreqs)
        which = ismember(tempFreqs,out17.tempData.tempFreqs(i));
        yPBS(2,which) = out17.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out18.tempData.performanceByConditionWCO(:,1,1));
    xloc = out18.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out18.tempData.tempFreqs)
        which = ismember(tempFreqs,out18.tempData.tempFreqs(i));
        yPBS(3,which) = out18.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out19.tempData.performanceByConditionWCO(:,1,1));
    xloc = out19.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out19.tempData.tempFreqs)
        which = ismember(tempFreqs,out19.tempData.tempFreqs(i));
        yPBS(4,which) = out19.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out20.tempData.performanceByConditionWCO(:,1,1));
    xloc = out20.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out20.tempData.tempFreqs)
        which = ismember(tempFreqs,out20.tempData.tempFreqs(i));
        yPBS(5,which) = out20.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yVal = squeeze(out11.tempData.performanceByConditionWCO(:,1,1));
    xloc = out11.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'b');
    for i = 1:length(out11.tempData.tempFreqs)
        which = ismember(tempFreqs,out11.tempData.tempFreqs(i));
        yPBS(6,which) = out11.tempData.performanceByConditionWCO(i,1,1);
    end
    
    yCNO = nan(6,length(tempFreqs));
    yVal = squeeze(out13.tempData.performanceByConditionWCO(:,1,2));
    xloc = out13.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'r');
    for i = 1:length(out13.tempData.tempFreqs)
        which = ismember(tempFreqs,out13.tempData.tempFreqs(i));
        yCNO(1,which) = out13.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out17.tempData.performanceByConditionWCO(:,1,2));
    xloc = out17.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'r');
    for i = 1:length(out17.tempData.tempFreqs)
        which = ismember(tempFreqs,out17.tempData.tempFreqs(i));
        yCNO(2,which) = out17.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out18.tempData.performanceByConditionWCO(:,1,2));
    xloc = out18.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'r');
    for i = 1:length(out18.tempData.tempFreqs)
        which = ismember(tempFreqs,out18.tempData.tempFreqs(i));
        yCNO(3,which) = out18.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out19.tempData.performanceByConditionWCO(:,1,2));
    xloc = out19.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'r');
    for i = 1:length(out19.tempData.tempFreqs)
        which = ismember(tempFreqs,out19.tempData.tempFreqs(i));
        yCNO(4,which) = out19.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out20.tempData.performanceByConditionWCO(:,1,2));
    xloc = out20.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'r');
    for i = 1:length(out20.tempData.tempFreqs)
        which = ismember(tempFreqs,out20.tempData.tempFreqs(i));
        yCNO(5,which) = out20.tempData.performanceByConditionWCO(i,1,2);
    end
    
    yVal = squeeze(out11.tempData.performanceByConditionWCO(:,1,2));
    xloc = out11.tempData.tempFreqs(~isnan(yVal));xloc(xloc==0) = 0.1;    
    plot(log2(xloc),yVal(~isnan(yVal)),'r');
    for i = 1:length(out11.tempData.tempFreqs)
        which = ismember(tempFreqs,out11.tempData.tempFreqs(i));
        yCNO(6,which) = out11.tempData.performanceByConditionWCO(i,1,2);
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
    plot(log2(tempFreqsCNO),avgCNO,'dr-','markerfacecolor','r','markersize',5,'linewidth',4);
    for i = 1:length(tempFreqsCNO)
        plot([log2(tempFreqsCNO(i)) log2(tempFreqsCNO(i))],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'r','linewidth',2);
    end
    xticks = log2([0.0625 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20]);
    xticklabs = {'','0','','','','','','','','','1','','','','','','','','','10',''};
    set(ax,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',log2([0.0625 32]),'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('temp.freq.','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end
