function ctrSensitivityData = analyzeCtrSensitivityTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

ctr = filterBehaviorData(data,'tsName','orctrXsfSweep_nAFC');
ctrSensitivityData.trialNum = [ctr.compiledTrialRecords.trialNumber];
ctrSensitivityData.correct = [ctr.compiledTrialRecords.correct];
ctrSensitivityData.correction = [ctr.compiledTrialRecords.correctionTrial];
ctrSensitivityData.responseTime = [ctr.compiledTrialRecords.responseTime];
whichDetailFileNum = find(strcmp({ctr.compiledDetails.className},'afcGratings'));
ctrSensitivityData.contrast = [ctr.compiledDetails(whichDetailFileNum).records.contrasts];
ctrSensitivityData.pixPerCyc = [ctr.compiledDetails(whichDetailFileNum).records.pixPerCycs];
ctrSensitivityData.time = [ctr.compiledTrialRecords.date];
ctrSensitivityData.date = floor(ctrSensitivityData.time);
ctrSensitivityData.dates = unique(ctrSensitivityData.date);
ctrSensitivityData.contrasts = unique(ctrSensitivityData.contrast);
ctrSensitivityData.pixPerCycs = unique(ctrSensitivityData.pixPerCyc);

% performance on a day by day basis
ctrSensitivityData.trialNumByDate = cell(1,length(ctrSensitivityData.dates));
ctrSensitivityData.numTrialsByDate = nan(1,length(ctrSensitivityData.dates));
ctrSensitivityData.performanceByDate = nan(3,length(ctrSensitivityData.dates));
ctrSensitivityData.colorByCondition = cell(1,length(ctrSensitivityData.dates));
ctrSensitivityData.conditionNum = nan(1,length(ctrSensitivityData.dates));
ctrSensitivityData.dayMetCutOffCriterion = nan(1,length(ctrSensitivityData.dates));

%performance by condition
ctrSensitivityData.trialNumsByCondition = cell(length(ctrSensitivityData.contrasts),length(ctrSensitivityData.pixPerCycs),5);
ctrSensitivityData.numTrialsByCondition = zeros(length(ctrSensitivityData.contrasts),length(ctrSensitivityData.pixPerCycs),5);
ctrSensitivityData.correctByCondition = zeros(length(ctrSensitivityData.contrasts),length(ctrSensitivityData.pixPerCycs),5);
ctrSensitivityData.performanceByCondition = nan(length(ctrSensitivityData.contrasts),length(ctrSensitivityData.pixPerCycs),3,5);

%performance by condition with trial number cutoff
ctrSensitivityData.trialNumsByConditionWCO = cell(length(ctrSensitivityData.contrasts),length(ctrSensitivityData.pixPerCycs),5);
ctrSensitivityData.numTrialsByConditionWCO = zeros(length(ctrSensitivityData.contrasts),length(ctrSensitivityData.pixPerCycs),5);
ctrSensitivityData.correctByConditionWCO = zeros(length(ctrSensitivityData.contrasts),length(ctrSensitivityData.pixPerCycs),5);
ctrSensitivityData.performanceByConditionWCO = nan(length(ctrSensitivityData.contrasts),length(ctrSensitivityData.pixPerCycs),3,5);

for i = 1:length(ctrSensitivityData.dates)
    if ismember(ctrSensitivityData.dates(i),filters.ctrFilter)
        dateFilter = ctrSensitivityData.date==ctrSensitivityData.dates(i);
        correctThatDate = ctrSensitivityData.correct(dateFilter);
        correctionThatDate = ctrSensitivityData.correction(dateFilter);
        contrastThatDate = ctrSensitivityData.contrast(dateFilter);
        ppcThatDate = ctrSensitivityData.pixPerCyc(dateFilter);
        
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        contrastThatDate = contrastThatDate(whichGood);
        ppcThatDate = ppcThatDate(whichGood);
        
        ctrSensitivityData.trialNumByDate{i} = ctrSensitivityData.trialNum(dateFilter);
        ctrSensitivityData.trialNumByDate{i} = ctrSensitivityData.trialNumByDate{i}(whichGood);
        ctrSensitivityData.numTrialsByDate(i) = length(ctrSensitivityData.trialNumByDate{i});
        
        x = sum(correctThatDate);
        n = length(correctThatDate);
        ctrSensitivityData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        ctrSensitivityData.performanceByDate(1,i) = phat;
        ctrSensitivityData.performanceByDate(2,i) = pci(1);
        ctrSensitivityData.performanceByDate(3,i) = pci(2);
        
        if ismember(ctrSensitivityData.dates(i),daysPBS)
            ctrSensitivityData.colorByCondition{i} = 'b';
            ctrSensitivityData.conditionNum(i) = 1;
        elseif ismember(ctrSensitivityData.dates(i),daysCNO)
            ctrSensitivityData.colorByCondition{i} = 'r';
            ctrSensitivityData.conditionNum(i) = 2;
        elseif ismember(ctrSensitivityData.dates(i),daysIntact)
            ctrSensitivityData.colorByCondition{i} = 'b';
            ctrSensitivityData.conditionNum(i) = 3;
        elseif ismember(ctrSensitivityData.dates(i),daysLesion)
            ctrSensitivityData.colorByCondition{i} = 'r';
            ctrSensitivityData.conditionNum(i) = 4;
        else
            ctrSensitivityData.colorByCondition{i} = 'k';
            ctrSensitivityData.conditionNum(i) = 5;
        end
        
        if ctrSensitivityData.conditionNum(i) == 1
            for j = 1:length(ctrSensitivityData.contrasts)
                for k = 1:length(ctrSensitivityData.pixPerCycs)
                    whichCurrContrast = contrastThatDate==ctrSensitivityData.contrasts(j);
                    currCtrSensCorrect = correctThatDate(whichCurrContrast);
                    x1 = sum(currCtrSensCorrect);
                    n1 = length(currCtrSensCorrect);
                    ctrSensitivityData.trialNumsByCondition{j,1} = [ctrSensitivityData.trialNumsByCondition{j,1} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast))];
                    ctrSensitivityData.numTrialsByCondition(j,1) = ctrSensitivityData.numTrialsByCondition(j,1)+n1;
                    ctrSensitivityData.correctByCondition(j,1) = ctrSensitivityData.correctByCondition(j,1)+x1;
                    if ctrSensitivityData.dayMetCutOffCriterion(i)
                        ctrSensitivityData.trialNumsByConditionWCO{j,1} = [ctrSensitivityData.trialNumsByConditionWCO{j,1} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast))];
                        ctrSensitivityData.numTrialsByConditionWCO(j,1) = ctrSensitivityData.numTrialsByConditionWCO(j,1)+n1;
                        ctrSensitivityData.correctByConditionWCO(j,1) = ctrSensitivityData.correctByConditionWCO(j,1)+x1;
                    end
                end
            end
        elseif ctrSensitivityData.conditionNum(i) == 2
            for j = 1:length(ctrSensitivityData.contrasts)
                for k = 1:length(ctrSensitivityData.pixPerCycs)
                    whichCurrContrast = contrastThatDate==ctrSensitivityData.contrasts(j);
                    currCtrSensCorrect = correctThatDate(whichCurrContrast);
                    x1 = sum(currCtrSensCorrect);
                    n1 = length(currCtrSensCorrect);
                    ctrSensitivityData.trialNumsByCondition{j,2} = [ctrSensitivityData.trialNumsByCondition{j,2} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast))];
                    ctrSensitivityData.numTrialsByCondition(j,2) = ctrSensitivityData.numTrialsByCondition(j,2)+n1;
                    ctrSensitivityData.correctByCondition(j,2) = ctrSensitivityData.correctByCondition(j,2)+x1;
                    if ctrSensitivityData.dayMetCutOffCriterion(i)
                        ctrSensitivityData.trialNumsByConditionWCO{j,2} = [ctrSensitivityData.trialNumsByConditionWCO{j,2} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast))];
                        ctrSensitivityData.numTrialsByConditionWCO(j,2) = ctrSensitivityData.numTrialsByConditionWCO(j,2)+n1;
                        ctrSensitivityData.correctByConditionWCO(j,2) = ctrSensitivityData.correctByConditionWCO(j,2)+x1;
                    end
                end
            end
        elseif ctrSensitivityData.conditionNum(i) == 3
            for j = 1:length(ctrSensitivityData.contrasts)
                for k = 1:length(ctrSensitivityData.pixPerCycs)
                    whichCurrContrast = contrastThatDate==ctrSensitivityData.contrasts(j);
                    currCtrSensCorrect = correctThatDate(whichCurrContrast);
                    x1 = sum(currCtrSensCorrect);
                    n1 = length(currCtrSensCorrect);
                    ctrSensitivityData.trialNumsByCondition{j,3} = [ctrSensitivityData.trialNumsByCondition{j,3} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast))];
                    ctrSensitivityData.numTrialsByCondition(j,3) = ctrSensitivityData.numTrialsByCondition(j,3)+n1;
                    ctrSensitivityData.correctByCondition(j,3) = ctrSensitivityData.correctByCondition(j,3)+x1;
                    if ctrSensitivityData.dayMetCutOffCriterion(i)
                        ctrSensitivityData.trialNumsByConditionWCO{j,3} = [ctrSensitivityData.trialNumsByConditionWCO{j,3} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast))];
                        ctrSensitivityData.numTrialsByConditionWCO(j,3) = ctrSensitivityData.numTrialsByConditionWCO(j,3)+n1;
                        ctrSensitivityData.correctByConditionWCO(j,3) = ctrSensitivityData.correctByConditionWCO(j,3)+x1;
                    end
                end
            end
        elseif ctrSensitivityData.conditionNum(i) == 4
            for j = 1:length(ctrSensitivityData.contrasts)
                for k = 1:length(ctrSensitivityData.pixPerCycs)
                    whichCurrContrast = contrastThatDate==ctrSensitivityData.contrasts(j);
                    currCtrSensCorrect = correctThatDate(whichCurrContrast);
                    x1 = sum(currCtrSensCorrect);
                    n1 = length(currCtrSensCorrect);
                    ctrSensitivityData.trialNumsByCondition{j,4} = [ctrSensitivityData.trialNumsByCondition{j,4} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast))];
                    ctrSensitivityData.numTrialsByCondition(j,4) = ctrSensitivityData.numTrialsByCondition(j,4)+n1;
                    ctrSensitivityData.correctByCondition(j,4) = ctrSensitivityData.correctByCondition(j,4)+x1;
                    if ctrSensitivityData.dayMetCutOffCriterion(i)
                        ctrSensitivityData.trialNumsByConditionWCO{j,4} = [ctrSensitivityData.trialNumsByConditionWCO{j,4} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast))];
                        ctrSensitivityData.numTrialsByConditionWCO(j,4) = ctrSensitivityData.numTrialsByConditionWCO(j,4)+n1;
                        ctrSensitivityData.correctByConditionWCO(j,4) = ctrSensitivityData.correctByConditionWCO(j,4)+x1;
                    end
                end
            end
        elseif ctrSensitivityData.conditionNum(i) == 5
            for j = 1:length(ctrSensitivityData.contrasts)
                for k = 1:length(ctrSensitivityData.pixPerCycs)
                    whichCurrContrast = contrastThatDate==ctrSensitivityData.contrasts(j);
                    whichCurrPixPerCyc = ppcThatDate==ctrSensitivityData.pixPerCycs(k);
                    currCtrSensCorrect = correctThatDate(whichCurrContrast&whichCurrPixPerCyc);
                    x1 = sum(currCtrSensCorrect);
                    n1 = length(currCtrSensCorrect);
                    ctrSensitivityData.trialNumsByCondition{j,k,5} = [ctrSensitivityData.trialNumsByCondition{j,k,5} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast&whichCurrPixPerCyc))];
                    ctrSensitivityData.numTrialsByCondition(j,k,5) = ctrSensitivityData.numTrialsByCondition(j,k,5)+n1;
                    ctrSensitivityData.correctByCondition(j,k,5) = ctrSensitivityData.correctByCondition(j,k,5)+x1;
                    if ctrSensitivityData.dayMetCutOffCriterion(i)
                        ctrSensitivityData.trialNumsByConditionWCO{j,k,5} = [ctrSensitivityData.trialNumsByConditionWCO{j,k,5} makerow(ctrSensitivityData.trialNumByDate{i}(whichCurrContrast&whichCurrPixPerCyc))];
                        ctrSensitivityData.numTrialsByConditionWCO(j,k,5) = ctrSensitivityData.numTrialsByConditionWCO(j,k,5)+n1;
                        ctrSensitivityData.correctByConditionWCO(j,k,5) = ctrSensitivityData.correctByConditionWCO(j,k,5)+x1;
                    end
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(ctrSensitivityData.contrasts)
    for k = 1:length(ctrSensitivityData.pixPerCycs)
        [phat,pci] = binofit(ctrSensitivityData.correctByCondition(j,k,:),ctrSensitivityData.numTrialsByCondition(j,k,:));
        ctrSensitivityData.performanceByCondition(j,k,1,:) = phat;
        ctrSensitivityData.performanceByCondition(j,k,2:3,:) = pci';
        
        [phat,pci] = binofit([ctrSensitivityData.correctByConditionWCO(j,k,:)],[ctrSensitivityData.numTrialsByConditionWCO(j,k,:)]);
        ctrSensitivityData.performanceByConditionWCO(j,k,1,:) = phat;
        ctrSensitivityData.performanceByConditionWCO(j,k,2:3,:) = pci';
    end
end



if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::CONTRAST',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(ctrSensitivityData.dates-min(ctrSensitivityData.dates)+1,ctrSensitivityData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'
                    conditionColor = {'b','r','b','r','k'};
                    for i = 1:size(ctrSensitivityData.performanceByConditionWCO,4)
                        means = squeeze(ctrSensitivityData.performanceByConditionWCO(:,:,1,i));
                        which = ~isnan(ctrSensitivityData.performanceByConditionWCO(:,1,i));
                        surf(ctrSensitivityData.pixPerCycs(which),ctrSensitivityData.contrasts(which),means(which),'color',conditionColor{i})
                    end
                    set(gca,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
                    xlabel('contrast','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByDay'
                    plot([0 max(ctrSensitivityData.dates)-min(ctrSensitivityData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(ctrSensitivityData.dates)-min(ctrSensitivityData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(ctrSensitivityData.dates)
                        if ~isnan(ctrSensitivityData.dayMetCutOffCriterion(i))
                            if ctrSensitivityData.dayMetCutOffCriterion(i)
                                xloc = ctrSensitivityData.dates(i)-min(ctrSensitivityData.dates)+1;
                                plot(xloc,ctrSensitivityData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],ctrSensitivityData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = ctrSensitivityData.dates(i)-min(ctrSensitivityData.dates)+1;
                                plot(xloc,ctrSensitivityData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],ctrSensitivityData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = ctrSensitivityData.dates(i)-min(ctrSensitivityData.dates)+1;
                            plot(xloc,0.5,'Marker','x','color','k');
                        end
                    end
                    set(gca,'ylim',[0.2 1]);
                    xlabel('day num','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                case 'responseTime'
                    keyboard
                otherwise
                    error('wtf!');
            end
            
            
        case {'makeFigure'}
            figName = sprintf('%s::OPTIMAL',mouseID);
            if strcmp(plotDetails.plotWhere,'makeFigure')
                f = figure('name',figName);
            else
                figure(plotDetails.figHan)
            end
            
            % trials by day
            ax1 = subplot(4,2,1); hold on;
            bar(ctrSensitivityData.dates-min(ctrSensitivityData.dates)+1,ctrSensitivityData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performance by day
            ax2 = subplot(4,2,2); hold on;
            plot([0 max(ctrSensitivityData.dates)-min(ctrSensitivityData.dates)+1],[0.5 0.5],'k');
            plot([0 max(ctrSensitivityData.dates)-min(ctrSensitivityData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(ctrSensitivityData.dates)
                if ~isnan(ctrSensitivityData.dayMetCutOffCriterion(i))
                    if ctrSensitivityData.dayMetCutOffCriterion(i)
                        xloc = ctrSensitivityData.dates(i)-min(ctrSensitivityData.dates)+1;
                        plot(xloc,ctrSensitivityData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],ctrSensitivityData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = ctrSensitivityData.dates(i)-min(ctrSensitivityData.dates)+1;
                        plot(xloc,ctrSensitivityData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],ctrSensitivityData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = ctrSensitivityData.dates(i)-min(ctrSensitivityData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax2,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performance by condition
            ax3 = subplot(4,2,3:6); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(ctrSensitivityData.performanceByConditionWCO,4)
                means = squeeze(ctrSensitivityData.performanceByConditionWCO(:,:,1,i));
                if ~any(isnan(means(:)))
                    surf(ctrSensitivityData.pixPerCycs,ctrSensitivityData.contrasts,means)
                end
            end
            %set(gca,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('ppc','FontName','Times New Roman','FontSize',12);
            ylabel('ctr','FontName','Times New Roman','FontSize',12);
            zlabel('perf','FontName','Times New Roman','FontSize',12);
            %set(ax3,'ylim',[0.2 1.1],'xlim',[-0.05 1.05],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            
            % performance by condition now overlay by sf
            ax4 = subplot(4,2,7); hold on;
            ax5 = subplot(4,2,8); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(ctrSensitivityData.performanceByConditionWCO,4)
                means = squeeze(ctrSensitivityData.performanceByConditionWCO(:,:,1,i));
                if ~any(isnan(means(:)))
                    for k = 1:length(ctrSensitivityData.pixPerCycs)
                        dpc = ctrSensitivityData.pixPerCycs(k)*0.054
                        ctrpHat = makerow(means(:,k));
                        in.cntr = ctrSensitivityData.contrasts;
                        in.pHat = ctrpHat;
                        fit = fitHyperbolicRatio(in);
                        fit
                        if fit.exitflag == 2
                            fit.c50 = 1;
                        end
                        axes(ax4)
                        plot(fit.fittedModel.c,fit.fittedModel.pModel,'linewidth',k/2,'color','k');
                        axes(ax5)
                        %                         keyboard
                        plot(1/dpc,1/fit.c50,'k*')
                        ctrSensitivityData.fits(k)= fit;
                        ctrSensitivityData.sfForSens(k) = 1/dpc;
                        ctrSensitivityData.sensForSens(k) = 1/fit.c50;
                        
                    end
                end
            end
            %             keyboard
            %set(gca,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            axes(ax4)
            xlabel('ctr','FontName','Times New Roman','FontSize',12);
            ylabel('perf','FontName','Times New Roman','FontSize',12);
            axes(ax5)
            %set(ax3,'ylim',[0.2 1.1],'xlim',[-0.05 1.05],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            set(ax5,'ylim',[1 20])
            xlabel('sf(cpd)','FontName','Times New Roman','FontSize',12);
            ylabel('ctr.sens','FontName','Times New Roman','FontSize',12);
            
        case {'givenFigure'}
            figName = sprintf('%s::OPTIMAL',mouseID);
            if strcmp(plotDetails.plotWhere,'makeFigure')
                f = figure('name',figName);
            else
                figure(plotDetails.figHan)
            end
            switch plotDetails.requestedPlot
                case 'contrastTuning'
                    numSFs = length(ctrSensitivityData.pixPerCycs);
                    [nx ny] = getGoodArrangement(numSFs);
                    for i = 1:size(ctrSensitivityData.performanceByConditionWCO,4)
                        means = squeeze(ctrSensitivityData.performanceByConditionWCO(:,:,1,i));
                        if ~any(isnan(means(:)))
                            for k = 1:numSFs
                                subplot(nx,ny,k); hold on;
                                dpc = ctrSensitivityData.pixPerCycs(k)*0.054
                                ctrpHat = makerow(means(:,k));
                                in.cntr = ctrSensitivityData.contrasts;
                                in.pHat = ctrpHat;
%                                 if k ==4
%                                     keyboard
%                                 end
%                                 [fitParam,stat] = sigm_fit(in.cntr,in.pHat,[],[]);
                                fit = fitHyperbolicRatio(in);
                                
                                plot(in.cntr,in.pHat,'kd');
                                plot(fit.fittedModel.c,fit.fittedModel.pModel,'k');
                                title(sprintf('%2.2f dpc,c50=%2.2f',dpc,fit.c50));
                                xlabel('ctr','FontName','Times New Roman','FontSize',12);
                                ylabel('perf','FontName','Times New Roman','FontSize',12);
                                set(gca,'xlim',[-0.05 1.05],'ylim',[0.4 1])
                            end
                        end
                    end
                otherwise
                    error('unknown requested plot')
            end
            
    end
end
