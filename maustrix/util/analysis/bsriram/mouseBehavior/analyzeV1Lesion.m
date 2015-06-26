function analyzeV1Lesion
%% %%
% %% 22
% filter22.imFilter = [735206 735213 735304 735305 735306];
% filter22.optFilter = [735166 735167 735168 735169 735171 735172 735173 735174 735175 735176 735178 735179 735181 735182 735183 735239 735241 735242 735243 735244 735245 735246 735248 735249 735250 735251 735262 735263 735264];
% filter22.ctrFilter = [1:today];
% filter22.sfFilter = 1:today;
% filter22.orFitler = 1:today;
% plotOn = true;
% out22 = mouse22(filter22,plotOn);
% 
% %% 23
% filter23.imFilter = 1:today;
% filter23.optFilter = [735109 735110 735111 735112 735116 735117 735118 735119 735122 735123 735124 735125 735131 735139 735140 735143 735144 735145 735158 735159 735160 735239 735241 735242 735243 735244 735245 735256 735257 735258 735259 735292 735301];
% filter23.ctrFilter = [  735161      735164      735165      735166      735167      735168 ...
%     735169      735186      735189      735190      735277      735278      735279      735280      735282      735283      735284      735285      735286      735287      735290      735291      735293      735294      735299      735300];
% filter23.sfFilter = 1:today;
% filter23.orFitler = 1:today;
% plotOn = true;
% out23 = mouse23(filter23,plotOn);
% 
% %% 25
% filter25.imFilter = [];
% filter25.optFilter = [735118 735119 735122 735123 735124 735125 735126 735129 735136 735239 735241 735242 735243 735244 735245 735256 735257 735258 735259];
% filter25.ctrFilter = [1:today];
% filter25.sfFilter = 1:today;
% filter25.orFitler = 1:today;
% plotOn = true;
% out25 = mouse25(filter25,plotOn);
% %% STANDARD
% figure;
% subplot(2,2,1); hold on;
% plot([1 2],[out22.optData.performanceByConditionWCO(1,3) out22.optData.performanceByConditionWCO(1,4)],'k','linewidth',2);
% plot([1 2],[out23.optData.performanceByConditionWCO(1,3) out23.optData.performanceByConditionWCO(1,4)],'k','linewidth',2);
% plot([1 2],[out25.optData.performanceByConditionWCO(1,3) out25.optData.performanceByConditionWCO(1,4)],'k','linewidth',2);
% plot([1 1 1],[out22.optData.performanceByConditionWCO(1,3) out23.optData.performanceByConditionWCO(1,3) out25.optData.performanceByConditionWCO(1,3)],'bd','markerSize',10,'markerfacecolor','b');
% plot([1 1],[out22.optData.performanceByConditionWCO(2,3) out22.optData.performanceByConditionWCO(3,3)],'linewidth',5,'color','b');
% plot([1 1],[out23.optData.performanceByConditionWCO(2,3) out23.optData.performanceByConditionWCO(3,3)],'linewidth',5,'color','b');
% plot([1 1],[out25.optData.performanceByConditionWCO(2,3) out25.optData.performanceByConditionWCO(3,3)],'linewidth',5,'color','b');
% plot([2 2 2],[out22.optData.performanceByConditionWCO(1,4) out23.optData.performanceByConditionWCO(1,4) out25.optData.performanceByConditionWCO(1,4)],'rd','markerSize',10,'markerfacecolor','r');
% plot([2 2],[out22.optData.performanceByConditionWCO(2,4) out22.optData.performanceByConditionWCO(3,4)],'linewidth',5,'color','r');
% plot([2 2],[out23.optData.performanceByConditionWCO(2,4) out23.optData.performanceByConditionWCO(3,4)],'linewidth',5,'color','r');
% plot([2 2],[out25.optData.performanceByConditionWCO(2,4) out25.optData.performanceByConditionWCO(3,4)],'linewidth',5,'color','r');
% plot([0.5 2.5],[0.5 0.5],'k-');plot([0.5 2.5],[0.7 0.7],'k--');
% set(gca,'xlim',[0.5 2.5],'ylim',[0.45 1],'xtick',[1 2],'xticklabel',{'Pre-Lesion','Post-Lesion'},'ytick',[0.2 0.5 0.7 1],'FontName','Times New Roman','FontSize',12);
% 
% subplot(2,2,2); hold on;
% dates22 = [735239 735241 735242];
% dates23 = [735239 735241 735242];
% dates25 = [735239 735241 735242];
% plot([1 2 3],out22.optData.performanceByDate(1,ismember(out22.optData.dates,dates22)),'linewidth',3,'color','r','marker','d','markersize',5);
% plot([1 2 3],out23.optData.performanceByDate(1,ismember(out23.optData.dates,dates23)),'linewidth',3,'color','r','marker','d','markersize',5);
% plot([1 2 3],out25.optData.performanceByDate(1,ismember(out25.optData.dates,dates25)),'linewidth',3,'color','r','marker','d','markersize',5);
% plot([0.5 3.5],[0.5 0.5],'k-');plot([0.5 3.5],[0.7 0.7],'k--');
% set(gca,'xlim',[0.5 3.5],'ylim',[0.45 1],'xtick',[1 2 3],'ytick',[0.2 0.5 0.7 1],'FontName','Times New Roman','FontSize',12);
% 
% %% CONTRAST
% if plotCntr
%     % 9 10 31 32 34
%     figure;
%     ax = subplot(1,1,1); hold on;
%     contrasts = out22.ctrData.contrasts;
%     yPBS = nan(3,length(contrasts));
%     
%     yVal = squeeze(out22.ctrData.performanceByConditionWCO(:,1,3));
%     plot(out22.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
%     for i = 1:length(out22.ctrData.contrasts)
%         which = ismember(contrasts,out22.ctrData.contrasts(i));
%         yPBS(1,which) = out22.ctrData.performanceByConditionWCO(i,1,3);
%     end
%     
%     yVal = squeeze(out23.ctrData.performanceByConditionWCO(:,1,3));
%     plot(out23.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
%     for i = 1:length(out23.ctrData.contrasts)
%         which = ismember(contrasts,out23.ctrData.contrasts(i));
%         yPBS(2,which) = out23.ctrData.performanceByConditionWCO(i,1,3);
%     end
%     
%     yVal = squeeze(out25.ctrData.performanceByConditionWCO(:,1,3));
%     plot(out25.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'b');
%     for i = 1:length(out25.ctrData.contrasts)
%         which = ismember(contrasts,out25.ctrData.contrasts(i));
%         yPBS(3,which) = out25.ctrData.performanceByConditionWCO(i,1,3);
%     end
%     
%     yCNO = nan(3,length(contrasts));
%     yVal = squeeze(out22.ctrData.performanceByConditionWCO(:,1,4));
%     plot(out22.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'color',[0 1 0]);
%     for i = 1:length(out22.ctrData.contrasts)
%         which = ismember(contrasts,out22.ctrData.contrasts(i));
%         yCNO(1,which) = out22.ctrData.performanceByConditionWCO(i,1,4);
%     end
%     
%     yVal = squeeze(out23.ctrData.performanceByConditionWCO(:,1,4));
%     plot(out23.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'color',[0 1 0]);
%     for i = 1:length(out23.ctrData.contrasts)
%         which = ismember(contrasts,out23.ctrData.contrasts(i));
%         yCNO(2,which) = out23.ctrData.performanceByConditionWCO(i,1,4);
%     end
%     
%     yVal = squeeze(out25.ctrData.performanceByConditionWCO(:,1,4));
%     plot(out25.ctrData.contrasts(~isnan(yVal)),yVal(~isnan(yVal)),'color',[0 1 0]);
%     for i = 1:length(out25.ctrData.contrasts)
%         which = ismember(contrasts,out25.ctrData.contrasts(i));
%         yCNO(3,which) = out25.ctrData.performanceByConditionWCO(i,1,4);
%     end
%     
%     avgPBS = nanmean(yPBS,1);
%     stdPBS = nanstd(yPBS,[],1);
%     nPBS = sum(~isnan(yPBS),1);
%     whichgood = ~isnan(avgPBS);
%     avgPBS = avgPBS(whichgood);
%     stdPBS = stdPBS(whichgood);
%     nPBS = nPBS(whichgood);
%     contrastsPBS = contrasts(whichgood);
%     semPBS = stdPBS./sqrt(nPBS);
%     plot(contrastsPBS,avgPBS,'d-','color',[0,0,1],'markerfacecolor','b','markersize',5,'linewidth',4);
%     for i = 1:length(contrastsPBS)
%         plot([contrastsPBS(i) contrastsPBS(i)],[avgPBS(i)-semPBS(i) avgPBS(i)+semPBS(i)],'b','linewidth',2);
%     end
%     
%     avgCNO = nanmean(yCNO,1);
%     stdCNO = nanstd(yCNO,[],1);
%     nCNO = sum(~isnan(yCNO),1);
%     whichgood = ~isnan(avgCNO);
%     avgCNO = avgCNO(whichgood);
%     stdCNO = stdCNO(whichgood);
%     nCNO = nCNO(whichgood);
%     contrastsCNO = contrasts(whichgood);
%     semCNO = stdCNO./sqrt(nCNO);
%     plot(contrastsCNO,avgCNO,'d-','color',[0 1 0],'markerfacecolor','r','markersize',5,'linewidth',4);
%     for i = 1:length(contrastsCNO)
%         plot([contrastsCNO(i) contrastsCNO(i)],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'color',[0 1 0],'linewidth',2);
%     end
%     
%     set(ax,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',24);plot([0 1],[0.5 0.5],'k-','linewidth',2);plot([0 1],[0.7 0.7],'k--','linewidth',2);
%     xlabel('Contrast','FontName','Times New Roman','FontSize',24);
%     ylabel('PCorrect','FontName','Times New Roman','FontSize',24);       
% end
% 
% %% SPAT FREQ
% if plotSpat
%         figure;
%     ax = subplot(1,1,1); hold on;
%     spatFreqs = out23.spatData.spatFreqs;
%     yPBS = nan(3,length(spatFreqs));
% 
%     
%     yVal = squeeze(out23.spatData.performanceByConditionWCO(:,1,3));
%     xloc = log10(1./rad2deg(atan(44.7/1024*out23.spatData.spatFreqs(~isnan(yVal))/12)));    
%     plot(xloc,yVal(~isnan(yVal)),'b');
%     for i = 1:length(out23.spatData.spatFreqs)
%         which = ismember(spatFreqs,out23.spatData.spatFreqs(i));
%         yPBS(2,which) = out23.spatData.performanceByConditionWCO(i,1,3);
%     end
%     
%     yVal = squeeze(out25.spatData.performanceByConditionWCO(:,1,3));
%     xloc = log10(1./rad2deg(atan(44.7/1024*out25.spatData.spatFreqs(~isnan(yVal))/12)));    
%     plot(xloc,yVal(~isnan(yVal)),'b');
%     for i = 1:length(out25.spatData.spatFreqs)
%         which = ismember(spatFreqs,out25.spatData.spatFreqs(i));
%         yPBS(3,which) = out25.spatData.performanceByConditionWCO(i,1,3);
%     end
%     
%     yCNO = nan(3,length(spatFreqs));
%     
%     yVal = squeeze(out23.spatData.performanceByConditionWCO(:,1,4));
%     xloc = log10(1./rad2deg(atan(44.7/1024*out23.spatData.spatFreqs(~isnan(yVal))/12)));    
%     plot(xloc,yVal(~isnan(yVal)),'color',[0 1 0]);
%     for i = 1:length(out23.spatData.spatFreqs)
%         which = ismember(spatFreqs,out23.spatData.spatFreqs(i));
%         yCNO(2,which) = out23.spatData.performanceByConditionWCO(i,1,4);
%     end
%     
%     yVal = squeeze(out25.spatData.performanceByConditionWCO(:,1,4));
%     xloc = log10(1./rad2deg(atan(44.7/1024*out25.spatData.spatFreqs(~isnan(yVal))/12)));    
%     plot(xloc,yVal(~isnan(yVal)),'color',[0 1 0]);
%     for i = 1:length(out25.spatData.spatFreqs)
%         which = ismember(spatFreqs,out25.spatData.spatFreqs(i));
%         yCNO(3,which) = out25.spatData.performanceByConditionWCO(i,1,4);
%     end
%     
%     avgPBS = nanmean(yPBS,1);
%     stdPBS = nanstd(yPBS,[],1);
%     nPBS = sum(~isnan(yPBS),1);
%     whichgood = ~isnan(avgPBS);
%     avgPBS = avgPBS(whichgood);
%     stdPBS = stdPBS(whichgood);
%     nPBS = nPBS(whichgood);
%     spatFreqsPBS = spatFreqs(whichgood);
%     semPBS = stdPBS./sqrt(nPBS);
%     plot(log10(1./rad2deg(atan(44.7/1024*spatFreqsPBS/12))),avgPBS,'db-','markerfacecolor','b','markersize',5,'linewidth',4);
%     for i = 1:length(spatFreqsPBS)
%         plot([log10(1./rad2deg(atan(44.7/1024*spatFreqsPBS(i)/12))) log10(1./rad2deg(atan(44.7/1024*spatFreqsPBS(i)/12)))],[avgPBS(i)-semPBS(i) avgPBS(i)+semPBS(i)],'b','linewidth',2);
%     end
%     
%     avgCNO = nanmean(yCNO,1);
%     stdCNO = nanstd(yCNO,[],1);
%     nCNO = sum(~isnan(yCNO),1);
%     whichgood = ~isnan(avgCNO);
%     avgCNO = avgCNO(whichgood);
%     stdCNO = stdCNO(whichgood);
%     nCNO = nCNO(whichgood);
%     spatFreqsCNO = spatFreqs(whichgood);
%     semCNO = stdCNO./sqrt(nCNO);
%     plot(log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO/12))),avgCNO,'d-','color',[0 1 0],'markerfacecolor','r','markersize',5,'linewidth',4);
%     for i = 1:length(spatFreqsCNO)
%         plot([log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO(i)/12))) log10(1./rad2deg(atan(44.7/1024*spatFreqsCNO(i)/12)))],[avgCNO(i)-semCNO(i) avgCNO(i)+semCNO(i)],'color',[0 1 0],'linewidth',2);
%     end
%     xticks = log10([0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4]);
%     xticklabs = {'0.01','','','','','','','','','0.1','','','0.4'};
%     set(ax,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',[log10(0.0075) log10(0.5)],'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
%     xlabel('spat.freq.','FontName','Times New Roman','FontSize',12);
%     ylabel('performance','FontName','Times New Roman','FontSize',12);       
% end

%% new set
set1Lesion = {'26','48'};
set2Lesion = {'40','47','53','56','59'};
set3Lesion = {'37','38','45','50'};

Lesions = {'48','40','47','53','56','59'};
FutureLesions  ={'37','38','45','50'};
f = figure('name','V1 LESION ANIMALS');

plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByDay';

analysisFor.analyzeOpt = true;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = false;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = false;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = false;
analysisFor.analyzeRevOrientation = false;

trialNumCutoff = 25;

splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = {};
splits.daysLesion = {};

plotDetails.axHan = subplot(3,3,1);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('48',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,3,2);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box1\Compiled';
analyzeMouse('40',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,3,3);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box2\Compiled';
analyzeMouse('47',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,3,4);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box2\Compiled';
analyzeMouse('53',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,3,6);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box1\Compiled';
analyzeMouse('56',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,3,8);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('59',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

plotDetails.axHan = subplot(3,3,5);
analysisFor.analyzeOpt = false; 
analysisFor.analyzeRevOpt = true;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('26',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%% Performance by condition separate
f = figure('name','V1 LESION ANIMALS');

plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';
plotDetails.plotSignificance = true;
plotDetails.forStudy = 'Lesion';


analysisFor.analyzeOpt = true;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = false;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = false;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = false;
analysisFor.analyzeRevOrientation = false;

trialNumCutoff = 25;

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [735336      735339      735340      735341      735342      735343];
splits.daysLesion = [735353      735354      735355];
plotDetails.axHan = subplot(3,3,1);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('48',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [735367      735368];
splits.daysLesion = [ 735381      735382      735383      735384      735388      735390      735391      735392      735395      735396      735397      735398      735399      735402      735403      735404      735405  735406      735409];
plotDetails.axHan = subplot(3,3,2);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box1\Compiled';
analyzeMouse('40',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735367      735368];
splits.daysLesion = [ 735381      735382      735383 735388      735389      735390      735391      735395      735396      735397      735398      735399];
plotDetails.axHan = subplot(3,3,3);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box2\Compiled';
analyzeMouse('47',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735360      735361      735362      735363      735364      735367      735368];
splits.daysLesion = [ 735381      735382      735383      735388      735389      735390      735391      735392      735395      735396     735397      735398      735399];
plotDetails.axHan = subplot(3,3,4);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box2\Compiled';
analyzeMouse('53',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735356      735357      735360      735361      735362      735366      735367];
splits.daysLesion = [ 735381      735382      735383      735384      735388      735389      735390      735391      735392      735395      735396      735397      735398      735399];
plotDetails.axHan = subplot(3,3,6);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box1\Compiled';
analyzeMouse('56',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735356      735357      735360      735361      735362      735367];
splits.daysLesion = [ 735381      735382      735383      735384      735385      735388      735389      735390      735391      735392      735395      735396      735397      735398      735399      735402      735403      735404      735405      735406];
plotDetails.axHan = subplot(3,3,8);
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('59',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735339      735340      735341      735342      735343 ] ;
splits.daysLesion = [ 735353      735354      735355      735356      735357      735360      735382      735388      735389      735390      735391      735392      735395      735396      735397      735398      735399];
plotDetails.axHan = subplot(3,3,5);
analysisFor.analyzeOpt = false; 
analysisFor.analyzeRevOpt = true;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('26',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
%% Performance by condition together
f = figure('name','V1 LESION ANIMALS');

plotDetails.plotOn = true;
plotDetails.plotWhere = 'givenAxes';
plotDetails.requestedPlot = 'performanceByCondition';
plotDetails.plotSignificance = false;
plotDetails.forStudy = 'Lesion';


analysisFor.analyzeOpt = true;
analysisFor.analyzeImages = false;
analysisFor.analyzeRevOpt = false;
analysisFor.analyzeContrast = false;
analysisFor.analyzeRevContrast = false;
analysisFor.analyzeSpatFreq = false;
analysisFor.analyzeRevSpatFreq = false;
analysisFor.analyzeOrientation = false;
analysisFor.analyzeRevOrientation = false;

trialNumCutoff = 25;
ax = axes;
%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [735336      735339      735340      735341      735342      735343];
splits.daysLesion = [735353      735354      735355];
plotDetails.axHan = ax;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('48',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [735367      735368];
splits.daysLesion = [ 735381      735382      735383      735384      735388      735390      735391      735392      735395      735396      735397      735398      735399      735402      735403      735404      735405  735406      735409];
plotDetails.axHan = ax;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box1\Compiled';
analyzeMouse('40',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735367      735368];
splits.daysLesion = [ 735381      735382      735383 735388      735389      735390      735391      735395      735396      735397      735398      735399];
plotDetails.axHan = ax;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box2\Compiled';
analyzeMouse('47',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735360      735361      735362      735363      735364      735367      735368];
splits.daysLesion = [ 735381      735382      735383      735388      735389      735390      735391      735392      735395      735396     735397      735398      735399];
plotDetails.axHan = ax;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box2\Compiled';
analyzeMouse('53',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735356      735357      735360      735361      735362      735366      735367];
splits.daysLesion = [ 735381      735382      735383      735384      735388      735389      735390      735391      735392      735395      735396      735397      735398      735399];
plotDetails.axHan = ax;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box1\Compiled';
analyzeMouse('56',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735356      735357      735360      735361      735362      735367];
splits.daysLesion = [ 735381      735382      735383      735384      735385      735388      735389      735390      735391      735392      735395      735396      735397      735398      735399      735402      735403      735404      735405      735406];
plotDetails.axHan = ax;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('59',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);

%
splits.daysPBS = {};
splits.daysCNO = {};
splits.daysIntact = [ 735339      735340      735341      735342      735343 ] ;
splits.daysLesion = [ 735353      735354      735355      735356      735357      735360      735382      735388      735389      735390      735391      735392      735395      735396      735397      735398      735399];
plotDetails.axHan = ax;
analysisFor.analyzeOpt = false; 
analysisFor.analyzeRevOpt = true;
compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Box3\Compiled';
analyzeMouse('26',[],plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir);
