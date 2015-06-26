function optData = analyzeOptTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
    plotDetails.forStudy = 'none';
end

%% +/- 45 GRATINGS
opt = filterBehaviorData(data,'tsName','orOptimal_nAFC');
optData.trialNum = [opt.compiledTrialRecords.trialNumber ];
optData.correct = [opt.compiledTrialRecords.correct ];
optData.correction = [opt.compiledTrialRecords.correctionTrial ];
optData.responseTime = [opt.compiledTrialRecords.responseTime];
optData.correction(isnan(optData.correction)) = true;
optData.time = [opt.compiledTrialRecords.date ] ;
optData.date = floor(optData.time);
optData.dates = unique(optData.date);

% performance on a day by day basis
optData.trialNumByDate = cell(1,length(optData.dates));
optData.numTrialsByDate = nan(1,length(optData.dates));
optData.performanceByDate = nan(3,length(optData.dates));
optData.colorByCondition = cell(1,length(optData.dates));
optData.conditionNum = nan(1,length(optData.dates));
optData.dayMetCutOffCriterion = nan(1,length(optData.dates));

%performance by condition
optData.trialNumsByCondition = {[],[],[],[],[]};
optData.numTrialsByCondition = {0,0,0,0,0};
optData.correctByCondition = {0,0,0,0,0};
optData.performanceByCondition = nan(3,5);
optData.responseTimesByCondition = {[],[],[],[],[]};

%performance by condition with trial number cutoff
optData.trialNumsByConditionWCO = {[],[],[],[],[]};
optData.numTrialsByConditionWCO = {0,0,0,0,0};
optData.correctByConditionWCO = {0,0,0,0,0};
optData.performanceByConditionWCO = nan(3,5);
optData.responseTimesByConditionWCO = {[],[],[],[],[]};

for i = 1:length(optData.dates)
    if ismember(optData.dates(i),filters.optFilter)
        dateFilter = optData.date==optData.dates(i);
        correctThatDate = optData.correct(dateFilter);
        correctionThatDate = optData.correction(dateFilter);
        responseTimeThatDate = optData.responseTime(dateFilter);

        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate & responseTimeThatDate<5;
        correctThatDate = correctThatDate(whichGood);
        responseTimeThatDate = responseTimeThatDate(whichGood);
        
        optData.trialNumByDate{i} = optData.trialNum(dateFilter);
        optData.trialNumByDate{i} = optData.trialNumByDate{i}(whichGood);
        optData.numTrialsByDate(i) = length(optData.trialNumByDate{i});
        x = sum(correctThatDate);
        n = length(correctThatDate);
        optData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        optData.performanceByDate(1,i) = phat;
        optData.performanceByDate(2,i) = pci(1);
        optData.performanceByDate(3,i) = pci(2);
        
        if ismember(optData.dates(i),datenum(daysPBS))
            optData.colorByCondition{i} = 'b';
            optData.conditionNum(i) = 1;
        elseif ismember(optData.dates(i),datenum(daysCNO))
            optData.colorByCondition{i} = 'r';
            optData.conditionNum(i) = 2;
        elseif ismember(optData.dates(i),datenum(daysIntact))
            optData.colorByCondition{i} = 'b';
            optData.conditionNum(i) = 3;
        elseif ismember(optData.dates(i),datenum(daysLesion))
            optData.colorByCondition{i} = 'r';
            optData.conditionNum(i) = 4;
        else
            optData.colorByCondition{i} = 'k';
            optData.conditionNum(i) = 5;
        end
        
        if optData.conditionNum(i) == 1
            optData.trialNumsByCondition{1} = [optData.trialNumsByCondition{1} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{1} = optData.numTrialsByCondition{1}+n;
            optData.correctByCondition{1} = optData.correctByCondition{1}+x;
            optData.responseTimesByCondition{1} = [optData.responseTimesByCondition{1} makerow(responseTimeThatDate)];
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{1} = [optData.trialNumsByCondition{1} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{1} = optData.numTrialsByCondition{1}+n;
                optData.correctByConditionWCO{1} = optData.correctByCondition{1}+x;
                optData.responseTimesByConditionWCO{1} = [optData.responseTimesByConditionWCO{1} makerow(responseTimeThatDate)];
            end
        elseif optData.conditionNum(i) == 2
            optData.trialNumsByCondition{2} = [optData.trialNumsByCondition{2} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{2} = optData.numTrialsByCondition{2}+n;
            optData.correctByCondition{2} = optData.correctByCondition{2}+x;
            optData.responseTimesByCondition{2} = [optData.responseTimesByCondition{2} makerow(responseTimeThatDate)];
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{2} = [optData.trialNumsByConditionWCO{2} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{2} = optData.numTrialsByConditionWCO{2}+n;
                optData.correctByConditionWCO{2} = optData.correctByConditionWCO{2}+x;
                optData.responseTimesByConditionWCO{2} = [optData.responseTimesByConditionWCO{2} makerow(responseTimeThatDate)];
            end
        elseif optData.conditionNum(i) == 3
            optData.trialNumsByCondition{3} = [optData.trialNumsByCondition{3} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{3} = optData.numTrialsByCondition{3}+n;
            optData.correctByCondition{3} = optData.correctByCondition{3}+x;
            optData.responseTimesByCondition{3} = [optData.responseTimesByCondition{3} makerow(responseTimeThatDate)];
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{3} = [optData.trialNumsByConditionWCO{3} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{3} = optData.numTrialsByConditionWCO{3}+n;
                optData.correctByConditionWCO{3} = optData.correctByConditionWCO{3}+x;
                optData.responseTimesByConditionWCO{3} = [optData.responseTimesByConditionWCO{3} makerow(responseTimeThatDate)];
            end
        elseif optData.conditionNum(i) == 4
            optData.trialNumsByCondition{4} = [optData.trialNumsByCondition{4} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{4} = optData.numTrialsByCondition{4}+n;
            optData.correctByCondition{4} = optData.correctByCondition{4}+x;
            optData.responseTimesByCondition{4} = [optData.responseTimesByCondition{4} makerow(responseTimeThatDate)];
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{4} = [optData.trialNumsByConditionWCO{4} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{4} = optData.numTrialsByConditionWCO{4}+n;
                optData.correctByConditionWCO{4} = optData.correctByConditionWCO{4}+x;
                optData.responseTimesByConditionWCO{4} = [optData.responseTimesByConditionWCO{4} makerow(responseTimeThatDate)];
            end
        elseif optData.conditionNum(i) == 5
            optData.trialNumsByCondition{5} = [optData.trialNumsByCondition{5} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{5} = optData.numTrialsByCondition{5}+n;
            optData.correctByCondition{5} = optData.correctByCondition{5}+x;
            optData.responseTimesByCondition{5} = [optData.responseTimesByCondition{5} makerow(responseTimeThatDate)];
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{5} = [optData.trialNumsByConditionWCO{5} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{5} = optData.numTrialsByConditionWCO{5}+n;
                optData.correctByConditionWCO{5} = optData.correctByConditionWCO{5}+x;
                optData.responseTimesByConditionWCO{5} = [optData.responseTimesByConditionWCO{5} makerow(responseTimeThatDate)];
            end
        else
            error('unknown condition');
        end
        
        
    end
end
[phat,pci] = binofit([optData.correctByCondition{:}],[optData.numTrialsByCondition{:}]);
optData.performanceByCondition(1,:) = phat;
optData.performanceByCondition(2:3,:) = pci';

[phat,pci] = binofit([optData.correctByConditionWCO{:}],[optData.numTrialsByConditionWCO{:}]);
optData.performanceByConditionWCO(1,:) = phat;
optData.performanceByConditionWCO(2:3,:) = pci';

if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::OPTIMAL',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(optData.dates-min(optData.dates)+1,optData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                case 'performanceByCondition'
                    switch plotDetails.forStudy
                        case 'Lesion'
                            plot([0.25 0.75],[optData.performanceByConditionWCO(1,3),optData.performanceByConditionWCO(1,4)],'k');
                            if ~isnan(optData.performanceByConditionWCO(1,3)),plot(0.25,optData.performanceByConditionWCO(1,3),'bd','MarkerFaceColor','b'),...
                                    plot([0.25 0.25],optData.performanceByConditionWCO(2:3,3),'LineWidth',2,'color','b'), else plot(3,0.5,'bx'), end
                            if ~isnan(optData.performanceByConditionWCO(1,4)),plot(0.75,optData.performanceByConditionWCO(1,4),'rd','MarkerFaceColor','r'),...
                                    plot([0.75 0.75],optData.performanceByConditionWCO(2:3,4),'LineWidth',2,'color','r'), else plot(4,0.5,'rx'), end
                            Y1 = optData.performanceByConditionWCO(1,3)*optData.numTrialsByConditionWCO{1,3};
                            n1 = optData.numTrialsByConditionWCO{1,3};
                            Y2 = optData.performanceByConditionWCO(1,4)*optData.numTrialsByConditionWCO{1,4};
                            n2 = optData.numTrialsByConditionWCO{1,4};
                            p1 = (Y1+1)/(n1+2);
                            p2 = (Y2+1)/(n2+2);
                            pDiff = p1-p2;
                            Za = 1.96;
                            CI_PDiff = Za*sqrt((p1*(1-p1)/(n1+2))+(p2*(1-p2)/(n2+2)));
                            if abs(pDiff)>CI_PDiff && plotDetails.plotSignificance
                                % significant!!
                                plot(0.5,[((Y1/n1)+(Y2/n2))/2+0.05],'*');
                            end
                            plot([0.1 0.9],[0.5 0.5],'k-');
                            set(gca,'xlim',[0 1],'ylim',[0.2 1],'xtick',[0.25 0.75],'xticklabel',{'Intact','Lesion'},'FontName','Times New Roman','FontSize',12);
                            ylabel('performance','FontName','Times New Roman','FontSize',12);
                        otherwise
                            if ~isnan(optData.performanceByConditionWCO(1,1)),plot(1,optData.performanceByConditionWCO(1,1),'bd','MarkerFaceColor','b'),...
                                    plot([1 1],optData.performanceByConditionWCO(2:3,1),'LineWidth',2,'color','b'), else plot(1,0.5,'bx'), end
                            if ~isnan(optData.performanceByConditionWCO(1,2)),plot(2,optData.performanceByConditionWCO(1,2),'rd','MarkerFaceColor','r'),...
                                    plot([2 2],optData.performanceByConditionWCO(2:3,2),'LineWidth',2,'color','r'), else plot(2,0.5,'rx'), end
                            if ~isnan(optData.performanceByConditionWCO(1,3)),plot(3,optData.performanceByConditionWCO(1,3),'bd','MarkerFaceColor','b'),...
                                    plot([3 3],optData.performanceByConditionWCO(2:3,3),'LineWidth',2,'color','b'), else plot(3,0.5,'bx'), end
                            if ~isnan(optData.performanceByConditionWCO(1,4)),plot(4,optData.performanceByConditionWCO(1,4),'rd','MarkerFaceColor','r'),...
                                    plot([4 4],optData.performanceByConditionWCO(2:3,4),'LineWidth',2,'color','r'), else plot(4,0.5,'rx'), end
                            if ~isnan(optData.performanceByConditionWCO(1,5)),plot(5,optData.performanceByConditionWCO(1,5),'kd','MarkerFaceColor','k'),...
                                    plot([5 5],optData.performanceByConditionWCO(2:3,5),'LineWidth',2,'color','k'), else plot(5,0.5,'kx'), end
                            plot([0.1 5.9],[0.5 0.5],'k-');
                            plot([0.1 5.9],[0.7 0.7],'k--');
                            set(gca,'xlim',[0 6],'ylim',[0.2 1],'xtick',[1 2 3 4 5],'xticklabel',{'PBS','CNO','Intact','Lesion','Other'},'FontName','Times New Roman','FontSize',12);
                            ylabel('performance','FontName','Times New Roman','FontSize',12);
                    end
                case 'performanceByDay'
                    plot([0 max(optData.dates)-min(optData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(optData.dates)-min(optData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(optData.dates)
                        if ~isnan(optData.dayMetCutOffCriterion(i))
                            if optData.dayMetCutOffCriterion(i)
                                xloc = optData.dates(i)-min(optData.dates)+1;
                                plot(xloc,optData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],optData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = optData.dates(i)-min(optData.dates)+1;
                                plot(xloc,optData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],optData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = optData.dates(i)-min(optData.dates)+1;
                            plot(xloc,0.5,'Marker','x','color','k');
                        end
                    end
                    set(gca,'ylim',[0.2 1]);
                    xlabel('day num','FontName','Times New Roman','FontSize',12)
                    ylabel('performance','FontName','Times New Roman','FontSize',12)
                case 'learningProcess'
                    disp('this assumes you have done the legwork to filter data appropriately. If not, the issue is on your head');
                    hold on;
                    corrects = optData.correct;
                    whichToRemove = isnan(corrects) | ~ismember(optData.date,filters.optFilter);
                    corrects(whichToRemove) = [];
                    dates = optData.date;
                    dates(whichToRemove) = [];
                    runningAverage = nan(size(corrects));
                    pHats = runningAverage;
                    pCITop = pHats;
                    pCIBot = pHats;
                    for trNum = 1:length(corrects)
                        if trNum<100
                            relevant = corrects(1:trNum);
                            L = trNum;
                            p = sum(relevant);
                            [pHat pCI] = binofit(p,L);
                            pHats(trNum) = pHat;
                            pCITop(trNum) = pCI(2);
                            pCIBot(trNum) = pCI(1);
                        else
                            relevant = corrects(trNum-99:trNum);
                            L = 100;
                            p = sum(relevant);
                            [pHat pCI] = binofit(p,L);
                            pHats(trNum) = pHat;
                            pCITop(trNum) = pCI(2);
                            pCIBot(trNum) = pCI(1);
                        end
                        if rand<0.1
                            if corrects(trNum)
                                plot(trNum,0.3+0.01*randn,'g.');
                            else
                                plot(trNum,0.3+0.01*randn,'r.')
                            end
                        end
                    end
                    plot(50:length(corrects),pHats(50:end),'k','linewidth',1);hold on;
                    fh = fill([50:length(corrects) fliplr(50:length(corrects))],[pCITop(50:end) fliplr(pCIBot(50:end))],'k'); set(fh,'edgealpha',0,'faceAlpha',0.1);
                    plot([0,length(corrects)],[0.5 0.5],'k--');
                    set(gca,'xlim',[0,length(corrects)],'ylim',[0.2 1]);
                    
                    threshold = 0.8;
                    pointsAboveThreshold = pCITop>threshold;
                    thresholdTrial = find(abs(filter(ones(1,50)/50,1,pointsAboveThreshold)-1)<1e-6,1,'first');
                    plot(thresholdTrial,threshold,'rx');
                    optData.trialsToThreshold = thresholdTrial;
                    
                    % days
                    dateChanges = find(diff([dates dates(end)]));
                    for dayNum = 1:length(dateChanges)
                        plot([dateChanges(dayNum) dateChanges(dayNum)],[0.2 1],'color',0.9*[1 1 1],'LineStyle','--');
                    end
                    uniqDates = unique(dates);
                    optData.dayNumAtThreshold = find(uniqDates==dates(thresholdTrial),1,'first');
                case 'learningProcessOnlyAverage'
                    disp('this assumes you have done the legwork to filter data appropriately. If not, the issue is on your head');
                    hold on;
                    corrects = optData.correct;
                    whichToRemove = isnan(corrects) | ~ismember(optData.date,filters.optFilter);
                    corrects(whichToRemove) = [];
                    dates = optData.date;
                    dates(whichToRemove) = [];
                    runningAverage = nan(size(corrects));
                    pHats = runningAverage;
                    pCITop = pHats;
                    pCIBot = pHats;
                    for trNum = 1:length(corrects)
                        if trNum<100
                            relevant = corrects(1:trNum);
                            L = trNum;
                            p = sum(relevant);
                            [pHat pCI] = binofit(p,L);
                            pHats(trNum) = pHat;
                            pCITop(trNum) = pCI(2);
                            pCIBot(trNum) = pCI(1);
                        else
                            relevant = corrects(trNum-99:trNum);
                            L = 100;
                            p = sum(relevant);
                            [pHat pCI] = binofit(p,L);
                            pHats(trNum) = pHat;
                            pCITop(trNum) = pCI(2);
                            pCIBot(trNum) = pCI(1);
                        end
                    end
                    plot(50:length(corrects),pHats(50:end),'color',[0.75 0.75 0.75],'linewidth',1);hold on;
                    plot([0,length(corrects)],[0.5 0.5],'k--');
                    currXLim = get(gca,'xlim');
                    set(gca,'xlim',[0,max(currXLim(2),length(corrects))],'ylim',[0.2 1]);
                    
                    threshold = 0.8;
                    pointsAboveThreshold = pCITop>threshold;
                    thresholdTrial = find(abs(filter(ones(1,50)/50,1,pointsAboveThreshold)-1)<1e-6,1,'first');
                    plot(thresholdTrial,threshold,'rx');
                    optData.trialsToThreshold = thresholdTrial;
                    
                    % days
                    uniqDates = unique(dates);
                    optData.dayNumAtThreshold = find(uniqDates==dates(thresholdTrial),1,'first');
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
            
            % trialsByDay
            ax1 = subplot(2,2,1); hold on;
            bar(optData.dates-min(optData.dates)+1,optData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performanceBycondition
            ax2 = subplot(2,2,2); hold on;
            if ~isnan(optData.performanceByConditionWCO(1,1)),plot(1,optData.performanceByConditionWCO(1,1),'bd','MarkerFaceColor','b'),...
                    plot([1 1],optData.performanceByConditionWCO(2:3,1),'LineWidth',2,'color','b'), else plot(1,0.5,'bx'), end
            if ~isnan(optData.performanceByConditionWCO(1,2)),plot(2,optData.performanceByConditionWCO(1,2),'rd','MarkerFaceColor','r'),...
                    plot([2 2],optData.performanceByConditionWCO(2:3,2),'LineWidth',2,'color','r'), else plot(2,0.5,'rx'), end
            if ~isnan(optData.performanceByConditionWCO(1,3)),plot(3,optData.performanceByConditionWCO(1,3),'bd','MarkerFaceColor','b'),...
                    plot([3 3],optData.performanceByConditionWCO(2:3,3),'LineWidth',2,'color','b'), else plot(3,0.5,'bx'), end
            if ~isnan(optData.performanceByConditionWCO(1,4)),plot(4,optData.performanceByConditionWCO(1,4),'rd','MarkerFaceColor','r'),...
                    plot([4 4],optData.performanceByConditionWCO(2:3,4),'LineWidth',2,'color','r'), else plot(4,0.5,'rx'), end
            if ~isnan(optData.performanceByConditionWCO(1,5)),plot(5,optData.performanceByConditionWCO(1,5),'kd','MarkerFaceColor','k'),...
                    plot([5 5],optData.performanceByConditionWCO(2:3,5),'LineWidth',2,'color','k'), else plot(5,0.5,'kx'), end
            plot([0.1 5.9],[0.5 0.5],'k-');
            plot([0.1 5.9],[0.7 0.7],'k--');
            set(gca,'xlim',[0 6],'ylim',[0.2 1],'xtick',[1 2 3 4 5],'xticklabel',{'PBS','CNO','Intact','Lesion','Other'},'FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performanceByDay
            ax3 = subplot(2,2,3:4); hold on;
            plot([0 max(optData.dates)-min(optData.dates)+1],[0.5 0.5],'k');
            plot([0 max(optData.dates)-min(optData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(optData.dates)
                if ~isnan(optData.dayMetCutOffCriterion(i))
                    if optData.dayMetCutOffCriterion(i)
                        xloc = optData.dates(i)-min(optData.dates)+1;
                        plot(xloc,optData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],optData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = optData.dates(i)-min(optData.dates)+1;
                        plot(xloc,optData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],optData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = optData.dates(i)-min(optData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax3,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12)
            ylabel('performance','FontName','Times New Roman','FontSize',12)
    end
end
