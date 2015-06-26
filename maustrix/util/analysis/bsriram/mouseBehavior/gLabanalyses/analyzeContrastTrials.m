function ctrData = analyzeContrastTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

ctr = filterBehaviorData(data,'tsName','orCTRSweep');
ctrData.trialNum = [ctr.compiledTrialRecords.trialNumber];
ctrData.correct = [ctr.compiledTrialRecords.correct];
ctrData.correction = [ctr.compiledTrialRecords.correctionTrial];
ctrData.responseTime = [ctr.compiledTrialRecords.responseTime];
whichDetailFileNum = find(strcmp({ctr.compiledDetails.className},'afcGratings'));
ctrData.contrast = [ctr.compiledDetails(whichDetailFileNum).records.contrasts];
ctrData.time = [ctr.compiledTrialRecords.date];
ctrData.date = floor(ctrData.time);
ctrData.dates = unique(ctrData.date);
ctrData.contrasts = unique(ctrData.contrast);

% performance on a day by day basis
ctrData.trialNumByDate = cell(1,length(ctrData.dates));
ctrData.numTrialsByDate = nan(1,length(ctrData.dates));
ctrData.performanceByDate = nan(3,length(ctrData.dates));
ctrData.colorByCondition = cell(1,length(ctrData.dates));
ctrData.conditionNum = nan(1,length(ctrData.dates));
ctrData.dayMetCutOffCriterion = nan(1,length(ctrData.dates));

%performance by condition
ctrData.trialNumsByCondition = cell(length(ctrData.contrasts),5);
ctrData.numTrialsByCondition = zeros(length(ctrData.contrasts),5);
ctrData.correctByCondition = zeros(length(ctrData.contrasts),5);
ctrData.performanceByCondition = nan(length(ctrData.contrasts),3,5);
ctrData.responseTimesByCondition = cell(length(ctrData.contrasts),5);
ctrData.responseTimesForCorrectByCondition = cell(length(ctrData.contrasts),5);

%performance by condition with trial number cutoff
ctrData.trialNumsByConditionWCO = cell(length(ctrData.contrasts),5);
ctrData.numTrialsByConditionWCO = zeros(length(ctrData.contrasts),5);
ctrData.correctByConditionWCO = zeros(length(ctrData.contrasts),5);
ctrData.performanceByConditionWCO = nan(length(ctrData.contrasts),3,5);
ctrData.responseTimesByConditionWCO = cell(length(ctrData.contrasts),5);
ctrData.responseTimesForCorrectByConditionWCO = cell(length(ctrData.contrasts),5);

for i = 1:length(ctrData.dates)
    if ismember(ctrData.dates(i),filters.ctrFilter)
        dateFilter = ctrData.date==ctrData.dates(i);
        correctThatDate = ctrData.correct(dateFilter);
        correctionThatDate = ctrData.correction(dateFilter);
        contrastThatDate = ctrData.contrast(dateFilter);
        responseTimeThatDate = ctrData.responseTime(dateFilter);

        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate & responseTimeThatDate<5;
        correctThatDate = correctThatDate(whichGood);
        contrastThatDate = contrastThatDate(whichGood);
        responseTimeThatDate = responseTimeThatDate(whichGood);
        
        ctrData.trialNumByDate{i} = ctrData.trialNum(dateFilter);
        ctrData.trialNumByDate{i} = ctrData.trialNumByDate{i}(whichGood);
        ctrData.numTrialsByDate(i) = length(ctrData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        ctrData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        ctrData.performanceByDate(1,i) = phat;
        ctrData.performanceByDate(2,i) = pci(1);
        ctrData.performanceByDate(3,i) = pci(2);
        
        if ismember(ctrData.dates(i),daysPBS)
            ctrData.colorByCondition{i} = 'b';
            ctrData.conditionNum(i) = 1;
        elseif ismember(ctrData.dates(i),daysCNO)
            ctrData.colorByCondition{i} = 'r';
            ctrData.conditionNum(i) = 2;
        elseif ismember(ctrData.dates(i),daysIntact)
            ctrData.colorByCondition{i} = 'b';
            ctrData.conditionNum(i) = 3;
        elseif ismember(ctrData.dates(i),daysLesion)
            ctrData.colorByCondition{i} = 'r';
            ctrData.conditionNum(i) = 4;
        else
            ctrData.colorByCondition{i} = 'k';
            ctrData.conditionNum(i) = 5;
        end
                
        if ctrData.conditionNum(i) == 1
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,1} = [ctrData.trialNumsByCondition{j,1} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,1) = ctrData.numTrialsByCondition(j,1)+n1;
                ctrData.correctByCondition(j,1) = ctrData.correctByCondition(j,1)+x1;
                ctrData.responseTimesByCondition{j,1} = [ctrData.responseTimesByCondition{j,1} makerow(currResponseTimes)];
                ctrData.responseTimesForCorrectByCondition{j,1} = [ctrData.responseTimesForCorrectByCondition{j,1} makerow(currCorrectResponseTimes)];

                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,1} = [ctrData.trialNumsByConditionWCO{j,1} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,1) = ctrData.numTrialsByConditionWCO(j,1)+n1;
                    ctrData.correctByConditionWCO(j,1) = ctrData.correctByConditionWCO(j,1)+x1;
                    ctrData.responseTimesByConditionWCO{j,1} = [ctrData.responseTimesByConditionWCO{j,1} makerow(currResponseTimes)];
                    ctrData.responseTimesForCorrectByConditionWCO{j,1} = [ctrData.responseTimesForCorrectByConditionWCO{j,1} makerow(currCorrectResponseTimes)];
                end
            end
        elseif ctrData.conditionNum(i) == 2
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,2} = [ctrData.trialNumsByCondition{j,2} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,2) = ctrData.numTrialsByCondition(j,2)+n1;
                ctrData.correctByCondition(j,2) = ctrData.correctByCondition(j,2)+x1;
                ctrData.responseTimesByCondition{j,2} = [ctrData.responseTimesByCondition{j,2} makerow(currResponseTimes)];
                ctrData.responseTimesForCorrectByCondition{j,2} = [ctrData.responseTimesForCorrectByCondition{j,2} makerow(currCorrectResponseTimes)];
                
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,2} = [ctrData.trialNumsByConditionWCO{j,2} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,2) = ctrData.numTrialsByConditionWCO(j,2)+n1;
                    ctrData.correctByConditionWCO(j,2) = ctrData.correctByConditionWCO(j,2)+x1;
                    ctrData.responseTimesByConditionWCO{j,2} = [ctrData.responseTimesByConditionWCO{j,2} makerow(currResponseTimes)];
                    ctrData.responseTimesForCorrectByConditionWCO{j,2} = [ctrData.responseTimesForCorrectByConditionWCO{j,2} makerow(currCorrectResponseTimes)];
                end
            end
        elseif ctrData.conditionNum(i) == 3
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,3} = [ctrData.trialNumsByCondition{j,3} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,3) = ctrData.numTrialsByCondition(j,3)+n1;
                ctrData.correctByCondition(j,3) = ctrData.correctByCondition(j,3)+x1;
                ctrData.responseTimesByCondition{j,3} = [ctrData.responseTimesByCondition{j,3} makerow(currResponseTimes)];
                ctrData.responseTimesForCorrectByCondition{j,3} = [ctrData.responseTimesForCorrectByCondition{j,3} makerow(currCorrectResponseTimes)];
                
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,3} = [ctrData.trialNumsByConditionWCO{j,3} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,3) = ctrData.numTrialsByConditionWCO(j,3)+n1;
                    ctrData.correctByConditionWCO(j,3) = ctrData.correctByConditionWCO(j,3)+x1;
                    ctrData.responseTimesByConditionWCO{j,3} = [ctrData.responseTimesByConditionWCO{j,3} makerow(currResponseTimes)];
                    ctrData.responseTimesForCorrectByConditionWCO{j,3} = [ctrData.responseTimesForCorrectByConditionWCO{j,3} makerow(currCorrectResponseTimes)];
                end
            end
        elseif ctrData.conditionNum(i) == 4
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,4} = [ctrData.trialNumsByCondition{j,4} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,4) = ctrData.numTrialsByCondition(j,4)+n1;
                ctrData.correctByCondition(j,4) = ctrData.correctByCondition(j,4)+x1;
                ctrData.responseTimesByCondition{j,4} = [ctrData.responseTimesByCondition{j,4} makerow(currResponseTimes)];
                ctrData.responseTimesForCorrectByCondition{j,4} = [ctrData.responseTimesForCorrectByCondition{j,4} makerow(currCorrectResponseTimes)];
                
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,4} = [ctrData.trialNumsByConditionWCO{j,4} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,4) = ctrData.numTrialsByConditionWCO(j,4)+n1;
                    ctrData.correctByConditionWCO(j,4) = ctrData.correctByConditionWCO(j,4)+x1;
                    ctrData.responseTimesByConditionWCO{j,4} = [ctrData.responseTimesByConditionWCO{j,4} makerow(currResponseTimes)];
                    ctrData.responseTimesForCorrectByConditionWCO{j,4} = [ctrData.responseTimesForCorrectByConditionWCO{j,4} makerow(currCorrectResponseTimes)];
                end
            end
        elseif ctrData.conditionNum(i) == 5
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,5} = [ctrData.trialNumsByCondition{j,5} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,5) = ctrData.numTrialsByCondition(j,5)+n1;
                ctrData.correctByCondition(j,5) = ctrData.correctByCondition(j,5)+x1;
                ctrData.responseTimesByCondition{j,5} = [ctrData.responseTimesByCondition{j,5} makerow(currResponseTimes)];
                ctrData.responseTimesForCorrectByCondition{j,5} = [ctrData.responseTimesForCorrectByCondition{j,5} makerow(currCorrectResponseTimes)];
                
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,5} = [ctrData.trialNumsByConditionWCO{j,5} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,5) = ctrData.numTrialsByConditionWCO(j,5)+n1;
                    ctrData.correctByConditionWCO(j,5) = ctrData.correctByConditionWCO(j,5)+x1;
                    ctrData.responseTimesByConditionWCO{j,5} = [ctrData.responseTimesByConditionWCO{j,5} makerow(currResponseTimes)];
                    ctrData.responseTimesForCorrectByConditionWCO{j,5} = [ctrData.responseTimesForCorrectByConditionWCO{j,5} makerow(currCorrectResponseTimes)];
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(ctrData.contrasts)
    [phat,pci] = binofit(ctrData.correctByCondition(j,:),ctrData.numTrialsByCondition(j,:));
    ctrData.performanceByCondition(j,1,:) = phat;
    ctrData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([ctrData.correctByConditionWCO(j,:)],[ctrData.numTrialsByConditionWCO(j,:)]);
    ctrData.performanceByConditionWCO(j,1,:) = phat;
    ctrData.performanceByConditionWCO(j,2:3,:) = pci';
end



if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::CONTRAST',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(ctrData.dates-min(ctrData.dates)+1,ctrData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'
                    conditionColor = {'b','r','b','r','k'};
                    for i = 1:size(ctrData.performanceByConditionWCO,3)
                        if isfield(plotDetails,'plotMeansOnly') && plotDetails.plotMeansOnly
                            means = ctrData.performanceByConditionWCO(:,1,i);
                            which = ~isnan(ctrData.performanceByConditionWCO(:,1,i));
                            plot(ctrData.contrasts(which),means(which),'color',conditionColor{i})
                        else
                            for j = 1:size(ctrData.performanceByConditionWCO,1)
                                if ~isnan(ctrData.performanceByConditionWCO(j,1,i))
                                    plot(ctrData.contrasts(j),ctrData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                                    plot([ctrData.contrasts(j) ctrData.contrasts(j)],[ctrData.performanceByConditionWCO(j,2,i) ctrData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                                end
                            end
                            ctrs = ctrData.contrasts
                            phats = ctrData.performanceByConditionWCO(:,1,i)
                            pcibot = ctrData.performanceByConditionWCO(:,2,i)
                            pcitop = ctrData.performanceByConditionWCO(:,3,i)
                        end
                    end
                    set(gca,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
                    xlabel('contrast','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByDay'
                    plot([0 max(ctrData.dates)-min(ctrData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(ctrData.dates)-min(ctrData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(ctrData.dates)
                        if ~isnan(ctrData.dayMetCutOffCriterion(i))
                            if ctrData.dayMetCutOffCriterion(i)
                                xloc = ctrData.dates(i)-min(ctrData.dates)+1;
                                plot(xloc,ctrData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],ctrData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = ctrData.dates(i)-min(ctrData.dates)+1;
                                plot(xloc,ctrData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],ctrData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = ctrData.dates(i)-min(ctrData.dates)+1;
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
            
            
        case {'givenFigure','makeFigure'}
            figName = sprintf('%s::OPTIMAL',mouseID);
            if strcmp(plotDetails.plotWhere,'makeFigure')
                f = figure('name',figName);
            else
                figure(plotDetails.figHan)
            end
            
            % trials by day
            ax1 = subplot(3,2,1); hold on;
            bar(ctrData.dates-min(ctrData.dates)+1,ctrData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performance by day
            ax2 = subplot(3,2,2); hold on;
            plot([0 max(ctrData.dates)-min(ctrData.dates)+1],[0.5 0.5],'k');
            plot([0 max(ctrData.dates)-min(ctrData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(ctrData.dates)
                if ~isnan(ctrData.dayMetCutOffCriterion(i))
                    if ctrData.dayMetCutOffCriterion(i)
                        xloc = ctrData.dates(i)-min(ctrData.dates)+1;
                        plot(xloc,ctrData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],ctrData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = ctrData.dates(i)-min(ctrData.dates)+1;
                        plot(xloc,ctrData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],ctrData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = ctrData.dates(i)-min(ctrData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax2,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performance by condition
            ax3 = subplot(3,2,3:4); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(ctrData.performanceByConditionWCO,3)
                for j = 1:size(ctrData.performanceByConditionWCO,1)
                    if ~isnan(ctrData.performanceByConditionWCO(j,1,i))
                        plot(ctrData.contrasts(j),ctrData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([ctrData.contrasts(j) ctrData.contrasts(j)],[ctrData.performanceByConditionWCO(j,2,i) ctrData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax3,'ylim',[0.2 1.1],'xlim',[-0.05 1.05],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('contrast','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
                        
            % response times
            ax4 = subplot(3,2,5); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(ctrData.responseTimesByConditionWCO,2)
                for j = 1:size(ctrData.responseTimesByConditionWCO,1)
                    if ~(isempty(ctrData.responseTimesByConditionWCO{j,i}))
                        m = mean(ctrData.responseTimesByConditionWCO{j,i});
                        sem = std(ctrData.responseTimesByConditionWCO{j,i})/sqrt(length(ctrData.responseTimesByConditionWCO{j,i}));
                        plot(ctrData.contrasts(j),m,'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([ctrData.contrasts(j) ctrData.contrasts(j)],[m-sem m+sem],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax4,'ylim',[0 3],'xlim',[-0.05 1.05],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0 1 2 3],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('contrast','FontName','Times New Roman','FontSize',12);
            ylabel('responseTime','FontName','Times New Roman','FontSize',12);
            
            % response times for correct
            ax5 = subplot(3,2,6); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(ctrData.responseTimesForCorrectByConditionWCO,2)
                for j = 1:size(ctrData.responseTimesForCorrectByConditionWCO,1)
                    if ~(isempty(ctrData.responseTimesForCorrectByConditionWCO{j,i}))
                        m = mean(ctrData.responseTimesForCorrectByConditionWCO{j,i});
                        sem = std(ctrData.responseTimesForCorrectByConditionWCO{j,i})/sqrt(length(ctrData.responseTimesForCorrectByConditionWCO{j,i}));
                        plot(ctrData.contrasts(j),m,'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([ctrData.contrasts(j) ctrData.contrasts(j)],[m-sem m+sem],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax5,'ylim',[0 3],'xlim',[-0.05 1.05],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0 1 2 3],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('contrast','FontName','Times New Roman','FontSize',12);
            ylabel('responseTimeForCorrect','FontName','Times New Roman','FontSize',12);
    end
end