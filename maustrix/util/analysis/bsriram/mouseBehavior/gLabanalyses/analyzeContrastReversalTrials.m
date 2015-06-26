function ctrRevData = analyzeContrastReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

ctrRev = filterBehaviorData(data,'tsName','orCTRSweep_Reversal_nAFC');
ctrRevData.trialNum = [ctrRev.compiledTrialRecords.trialNumber];
ctrRevData.correct = [ctrRev.compiledTrialRecords.correct];
ctrRevData.correction = [ctrRev.compiledTrialRecords.correctionTrial];
whichDetailFileNum = find(strcmp({ctrRev.compiledDetails.className},'afcGratings'));
ctrRevData.contrast = [ctrRev.compiledDetails(whichDetailFileNum).records.contrasts];
ctrRevData.time = [ctrRev.compiledTrialRecords.date];
ctrRevData.date = floor(ctrRevData.time);
ctrRevData.dates = unique(ctrRevData.date);
ctrRevData.contrasts = unique(ctrRevData.contrast);

% performance on a day by day basis
ctrRevData.trialNumByDate = cell(1,length(ctrRevData.dates));
ctrRevData.numTrialsByDate = nan(1,length(ctrRevData.dates));
ctrRevData.performanceByDate = nan(3,length(ctrRevData.dates));
ctrRevData.colorByCondition = cell(1,length(ctrRevData.dates));
ctrRevData.conditionNum = nan(1,length(ctrRevData.dates));
ctrRevData.dayMetCutOffCriterion = nan(1,length(ctrRevData.dates));

%performance by condition
ctrRevData.trialNumsByCondition = cell(length(ctrRevData.contrasts),5);
ctrRevData.numTrialsByCondition = zeros(length(ctrRevData.contrasts),5);
ctrRevData.correctByCondition = zeros(length(ctrRevData.contrasts),5);
ctrRevData.performanceByCondition = nan(length(ctrRevData.contrasts),3,5);

%performance by condition with trial number cutoff
ctrRevData.trialNumsByConditionWCO = cell(length(ctrRevData.contrasts),5);
ctrRevData.numTrialsByConditionWCO = zeros(length(ctrRevData.contrasts),5);
ctrRevData.correctByConditionWCO = zeros(length(ctrRevData.contrasts),5);
ctrRevData.performanceByConditionWCO = nan(length(ctrRevData.contrasts),3,5);

for i = 1:length(ctrRevData.dates)
    if ismember(ctrRevData.dates(i),filters.ctrFilter)
        dateFilter = ctrRevData.date==ctrRevData.dates(i);
        correctThatDate = ctrRevData.correct(dateFilter);
        correctionThatDate = ctrRevData.correction(dateFilter);
        contrastThatDate = ctrRevData.contrast(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        contrastThatDate = contrastThatDate(whichGood);
 
        ctrRevData.trialNumByDate{i} = ctrRevData.trialNum(dateFilter);
        ctrRevData.trialNumByDate{i} = ctrRevData.trialNumByDate{i}(whichGood);
        ctrRevData.numTrialsByDate(i) = length(ctrRevData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        ctrRevData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        ctrRevData.performanceByDate(1,i) = phat;
        ctrRevData.performanceByDate(2,i) = pci(1);
        ctrRevData.performanceByDate(3,i) = pci(2);
        
        if ismember(ctrRevData.dates(i),daysPBS)
            ctrRevData.colorByCondition{i} = 'b';
            ctrRevData.conditionNum(i) = 1;
        elseif ismember(ctrRevData.dates(i),daysCNO)
            ctrRevData.colorByCondition{i} = 'r';
            ctrRevData.conditionNum(i) = 2;
        elseif ismember(ctrRevData.dates(i),daysIntact)
            ctrRevData.colorByCondition{i} = 'b';
            ctrRevData.conditionNum(i) = 3;
        elseif ismember(ctrRevData.dates(i),daysLesion)
            ctrRevData.colorByCondition{i} = 'r';
            ctrRevData.conditionNum(i) = 4;
        else
            ctrRevData.colorByCondition{i} = 'k';
            ctrRevData.conditionNum(i) = 5;
        end
                
        if ctrRevData.conditionNum(i) == 1
            for j = 1:length(ctrRevData.contrasts)
                whichCurrContrast = contrastThatDate==ctrRevData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrRevData.trialNumsByCondition{j,1} = [ctrRevData.trialNumsByCondition{j,1} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                ctrRevData.numTrialsByCondition(j,1) = ctrRevData.numTrialsByCondition(j,1)+n1;
                ctrRevData.correctByCondition(j,1) = ctrRevData.correctByCondition(j,1)+x1;
                if ctrRevData.dayMetCutOffCriterion(i)
                    ctrRevData.trialNumsByConditionWCO{j,1} = [ctrRevData.trialNumsByConditionWCO{j,1} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                    ctrRevData.numTrialsByConditionWCO(j,1) = ctrRevData.numTrialsByConditionWCO(j,1)+n1;
                    ctrRevData.correctByConditionWCO(j,1) = ctrRevData.correctByConditionWCO(j,1)+x1;
                end
            end
        elseif ctrRevData.conditionNum(i) == 2
            for j = 1:length(ctrRevData.contrasts)
                whichCurrContrast = contrastThatDate==ctrRevData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrRevData.trialNumsByCondition{j,2} = [ctrRevData.trialNumsByCondition{j,2} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                ctrRevData.numTrialsByCondition(j,2) = ctrRevData.numTrialsByCondition(j,2)+n1;
                ctrRevData.correctByCondition(j,2) = ctrRevData.correctByCondition(j,2)+x1;
                if ctrRevData.dayMetCutOffCriterion(i)
                    ctrRevData.trialNumsByConditionWCO{j,2} = [ctrRevData.trialNumsByConditionWCO{j,2} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                    ctrRevData.numTrialsByConditionWCO(j,2) = ctrRevData.numTrialsByConditionWCO(j,2)+n1;
                    ctrRevData.correctByConditionWCO(j,2) = ctrRevData.correctByConditionWCO(j,2)+x1;
                end
            end
        elseif ctrRevData.conditionNum(i) == 3
            for j = 1:length(ctrRevData.contrasts)
                whichCurrContrast = contrastThatDate==ctrRevData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrRevData.trialNumsByCondition{j,3} = [ctrRevData.trialNumsByCondition{j,3} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                ctrRevData.numTrialsByCondition(j,3) = ctrRevData.numTrialsByCondition(j,3)+n1;
                ctrRevData.correctByCondition(j,3) = ctrRevData.correctByCondition(j,3)+x1;
                if ctrRevData.dayMetCutOffCriterion(i)
                    ctrRevData.trialNumsByConditionWCO{j,3} = [ctrRevData.trialNumsByConditionWCO{j,3} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                    ctrRevData.numTrialsByConditionWCO(j,3) = ctrRevData.numTrialsByConditionWCO(j,3)+n1;
                    ctrRevData.correctByConditionWCO(j,3) = ctrRevData.correctByConditionWCO(j,3)+x1;
                end
            end
        elseif ctrRevData.conditionNum(i) == 4
            for j = 1:length(ctrRevData.contrasts)
                whichCurrContrast = contrastThatDate==ctrRevData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrRevData.trialNumsByCondition{j,4} = [ctrRevData.trialNumsByCondition{j,4} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                ctrRevData.numTrialsByCondition(j,4) = ctrRevData.numTrialsByCondition(j,4)+n1;
                ctrRevData.correctByCondition(j,4) = ctrRevData.correctByCondition(j,4)+x1;
                if ctrRevData.dayMetCutOffCriterion(i)
                    ctrRevData.trialNumsByConditionWCO{j,4} = [ctrRevData.trialNumsByConditionWCO{j,4} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                    ctrRevData.numTrialsByConditionWCO(j,4) = ctrRevData.numTrialsByConditionWCO(j,4)+n1;
                    ctrRevData.correctByConditionWCO(j,4) = ctrRevData.correctByConditionWCO(j,4)+x1;
                end
            end
        elseif ctrRevData.conditionNum(i) == 5
            for j = 1:length(ctrRevData.contrasts)
                whichCurrContrast = contrastThatDate==ctrRevData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrRevData.trialNumsByCondition{j,5} = [ctrRevData.trialNumsByCondition{j,5} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                ctrRevData.numTrialsByCondition(j,5) = ctrRevData.numTrialsByCondition(j,5)+n1;
                ctrRevData.correctByCondition(j,5) = ctrRevData.correctByCondition(j,5)+x1;
                if ctrRevData.dayMetCutOffCriterion(i)
                    ctrRevData.trialNumsByConditionWCO{j,5} = [ctrRevData.trialNumsByConditionWCO{j,5} makerow(ctrRevData.trialNumByDate{i}(whichCurrContrast))];
                    ctrRevData.numTrialsByConditionWCO(j,5) = ctrRevData.numTrialsByConditionWCO(j,5)+n1;
                    ctrRevData.correctByConditionWCO(j,5) = ctrRevData.correctByConditionWCO(j,5)+x1;
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(ctrRevData.contrasts)
    [phat,pci] = binofit(ctrRevData.correctByCondition(j,:),ctrRevData.numTrialsByCondition(j,:));
    ctrRevData.performanceByCondition(j,1,:) = phat;
    ctrRevData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([ctrRevData.correctByConditionWCO(j,:)],[ctrRevData.numTrialsByConditionWCO(j,:)]);
    ctrRevData.performanceByConditionWCO(j,1,:) = phat;
    ctrRevData.performanceByConditionWCO(j,2:3,:) = pci';
end



if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::CONTRAST',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(ctrRevData.dates-min(ctrRevData.dates)+1,ctrRevData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'
                    conditionColor = {'b','r','b','r','k'};
                    for i = 1:size(ctrRevData.performanceByConditionWCO,3)
                        for j = 1:size(ctrRevData.performanceByConditionWCO,1)
                            if ~isnan(ctrRevData.performanceByConditionWCO(j,1,i))
                                plot(ctrRevData.contrasts(j),ctrRevData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                                plot([ctrRevData.contrasts(j) ctrRevData.contrasts(j)],[ctrRevData.performanceByConditionWCO(j,2,i) ctrRevData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                            end
                        end
                    end
                    set(gca,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
                    xlabel('contrast','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByDay'
                    plot([0 max(ctrRevData.dates)-min(ctrRevData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(ctrRevData.dates)-min(ctrRevData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(ctrRevData.dates)
                        if ~isnan(ctrRevData.dayMetCutOffCriterion(i))
                            if ctrRevData.dayMetCutOffCriterion(i)
                                xloc = ctrRevData.dates(i)-min(ctrRevData.dates)+1;
                                plot(xloc,ctrRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],ctrRevData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = ctrRevData.dates(i)-min(ctrRevData.dates)+1;
                                plot(xloc,ctrRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],ctrRevData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = ctrRevData.dates(i)-min(ctrRevData.dates)+1;
                            plot(xloc,0.5,'Marker','x','color','k');
                        end
                    end
                    set(gca,'ylim',[0.2 1]);
                    xlabel('day num','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                otherwise
                    error('wtf!');
            end
            
            
        case {'givenFigure','makeFigure'}
            figName = sprintf('%s::OPTIMAL',mouseID);
            if strcmp(plotDetails.plotWhere,'makeFigure')
                f = figure('name',figName);
            else
                figure(plotDetails.figHan)
            end
            
            % trials by day
            ax1 = subplot(3,2,1); hold on;
            bar(ctrRevData.dates-min(ctrRevData.dates)+1,ctrRevData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performance by day
            ax2 = subplot(3,2,2); hold on;
            plot([0 max(ctrRevData.dates)-min(ctrRevData.dates)+1],[0.5 0.5],'k');
            plot([0 max(ctrRevData.dates)-min(ctrRevData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(ctrRevData.dates)
                if ~isnan(ctrRevData.dayMetCutOffCriterion(i))
                    if ctrRevData.dayMetCutOffCriterion(i)
                        xloc = ctrRevData.dates(i)-min(ctrRevData.dates)+1;
                        plot(xloc,ctrRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],ctrRevData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = ctrRevData.dates(i)-min(ctrRevData.dates)+1;
                        plot(xloc,ctrRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],ctrRevData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = ctrRevData.dates(i)-min(ctrRevData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax2,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performance by condition
            ax3 = subplot(3,2,3:6); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(ctrRevData.performanceByConditionWCO,3)
                for j = 1:size(ctrRevData.performanceByConditionWCO,1)
                    if ~isnan(ctrRevData.performanceByConditionWCO(j,1,i))
                        plot(ctrRevData.contrasts(j),ctrRevData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([ctrRevData.contrasts(j) ctrRevData.contrasts(j)],[ctrRevData.performanceByConditionWCO(j,2,i) ctrRevData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax3,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('contrast','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
    end
end