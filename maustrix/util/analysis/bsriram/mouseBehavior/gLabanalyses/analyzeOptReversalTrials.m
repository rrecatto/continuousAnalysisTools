function optRevData = analyzeOptReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
    plotDetails.forStudy = 'none';
end

%% +/- 45 GRATINGS REVERSAL
optRev = filterBehaviorData(data,'tsName','orOptimal_Reversal_nAFC');
optRevData.trialNum = [optRev.compiledTrialRecords.trialNumber ];
optRevData.correct = [optRev.compiledTrialRecords.correct ];
optRevData.correction = [optRev.compiledTrialRecords.correctionTrial ];
optRevData.correction(isnan(optRevData.correction)) = true;
optRevData.time = [optRev.compiledTrialRecords.date ] ;
optRevData.date = floor(optRevData.time);
optRevData.dates = unique(optRevData.date);

% performance on a day by day basis
optRevData.trialNumByDate = cell(1,length(optRevData.dates));
optRevData.numTrialsByDate = nan(1,length(optRevData.dates));
optRevData.performanceByDate = nan(3,length(optRevData.dates));
optRevData.colorByCondition = cell(1,length(optRevData.dates));
optRevData.conditionNum = nan(1,length(optRevData.dates));
optRevData.dayMetCutOffCriterion = nan(1,length(optRevData.dates));

%performance by condition
optRevData.trialNumsByCondition = {[],[],[],[],[]};
optRevData.numTrialsByCondition = {0,0,0,0,0};
optRevData.correctByCondition = {0,0,0,0,0};
optRevData.performanceByCondition = nan(3,5);

%performance by condition with trial number cutoff
optRevData.trialNumsByConditionWCO = {[],[],[],[],[]};
optRevData.numTrialsByConditionWCO = {0,0,0,0,0};
optRevData.correctByConditionWCO = {0,0,0,0,0};
optRevData.performanceByConditionWCO = nan(3,5);

for i = 1:length(optRevData.dates)
    if ismember(optRevData.dates(i),filters.optFilter)
        dateFilter = optRevData.date==optRevData.dates(i);
        correctThatDate = optRevData.correct(dateFilter);
        correctionThatDate = optRevData.correction(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        optRevData.trialNumByDate{i} = optRevData.trialNum(dateFilter);
        optRevData.trialNumByDate{i} = optRevData.trialNumByDate{i}(whichGood);
        optRevData.numTrialsByDate(i) = length(optRevData.trialNumByDate{i});
        x = sum(correctThatDate);
        n = length(correctThatDate);
        optRevData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        optRevData.performanceByDate(1,i) = phat;
        optRevData.performanceByDate(2,i) = pci(1);
        optRevData.performanceByDate(3,i) = pci(2);
        
        if ismember(optRevData.dates(i),datenum(daysPBS))
            optRevData.colorByCondition{i} = 'b';
            optRevData.conditionNum(i) = 1;
        elseif ismember(optRevData.dates(i),datenum(daysCNO))
            optRevData.colorByCondition{i} = 'r';
            optRevData.conditionNum(i) = 2;
        elseif ismember(optRevData.dates(i),datenum(daysIntact))
            optRevData.colorByCondition{i} = 'b';
            optRevData.conditionNum(i) = 3;
        elseif ismember(optRevData.dates(i),datenum(daysLesion))
            optRevData.colorByCondition{i} = 'r';
            optRevData.conditionNum(i) = 4;
        else
            optRevData.colorByCondition{i} = 'k';
            optRevData.conditionNum(i) = 5;
        end
        
        if optRevData.conditionNum(i) == 1
            optRevData.trialNumsByCondition{1} = [optRevData.trialNumsByCondition{1} makerow(optRevData.trialNumByDate{i})];
            optRevData.numTrialsByCondition{1} = optRevData.numTrialsByCondition{1}+n;
            optRevData.correctByCondition{1} = optRevData.correctByCondition{1}+x;
            if optRevData.dayMetCutOffCriterion(i)
                optRevData.trialNumsByConditionWCO{1} = [optRevData.trialNumsByCondition{1} makerow(optRevData.trialNumByDate{i})];
                optRevData.numTrialsByConditionWCO{1} = optRevData.numTrialsByCondition{1}+n;
                optRevData.correctByConditionWCO{1} = optRevData.correctByCondition{1}+x;
            end
        elseif optRevData.conditionNum(i) == 2
            optRevData.trialNumsByCondition{2} = [optRevData.trialNumsByCondition{2} makerow(optRevData.trialNumByDate{i})];
            optRevData.numTrialsByCondition{2} = optRevData.numTrialsByCondition{2}+n;
            optRevData.correctByCondition{2} = optRevData.correctByCondition{2}+x;
            if optRevData.dayMetCutOffCriterion(i)
                optRevData.trialNumsByConditionWCO{2} = [optRevData.trialNumsByConditionWCO{2} makerow(optRevData.trialNumByDate{i})];
                optRevData.numTrialsByConditionWCO{2} = optRevData.numTrialsByConditionWCO{2}+n;
                optRevData.correctByConditionWCO{2} = optRevData.correctByConditionWCO{2}+x;
            end
        elseif optRevData.conditionNum(i) == 3
            optRevData.trialNumsByCondition{3} = [optRevData.trialNumsByCondition{3} makerow(optRevData.trialNumByDate{i})];
            optRevData.numTrialsByCondition{3} = optRevData.numTrialsByCondition{3}+n;
            optRevData.correctByCondition{3} = optRevData.correctByCondition{3}+x;
            if optRevData.dayMetCutOffCriterion(i)
                optRevData.trialNumsByConditionWCO{3} = [optRevData.trialNumsByConditionWCO{3} makerow(optRevData.trialNumByDate{i})];
                optRevData.numTrialsByConditionWCO{3} = optRevData.numTrialsByConditionWCO{3}+n;
                optRevData.correctByConditionWCO{3} = optRevData.correctByConditionWCO{3}+x;
            end
        elseif optRevData.conditionNum(i) == 4
            optRevData.trialNumsByCondition{4} = [optRevData.trialNumsByCondition{4} makerow(optRevData.trialNumByDate{i})];
            optRevData.numTrialsByCondition{4} = optRevData.numTrialsByCondition{4}+n;
            optRevData.correctByCondition{4} = optRevData.correctByCondition{4}+x;
            if optRevData.dayMetCutOffCriterion(i)
                optRevData.trialNumsByConditionWCO{4} = [optRevData.trialNumsByConditionWCO{4} makerow(optRevData.trialNumByDate{i})];
                optRevData.numTrialsByConditionWCO{4} = optRevData.numTrialsByConditionWCO{4}+n;
                optRevData.correctByConditionWCO{4} = optRevData.correctByConditionWCO{4}+x;
            end
        elseif optRevData.conditionNum(i) == 5
            optRevData.trialNumsByCondition{5} = [optRevData.trialNumsByCondition{5} makerow(optRevData.trialNumByDate{i})];
            optRevData.numTrialsByCondition{5} = optRevData.numTrialsByCondition{5}+n;
            optRevData.correctByCondition{5} = optRevData.correctByCondition{5}+x;
            if optRevData.dayMetCutOffCriterion(i)
                optRevData.trialNumsByConditionWCO{5} = [optRevData.trialNumsByConditionWCO{5} makerow(optRevData.trialNumByDate{i})];
                optRevData.numTrialsByConditionWCO{5} = optRevData.numTrialsByConditionWCO{5}+n;
                optRevData.correctByConditionWCO{5} = optRevData.correctByConditionWCO{5}+x;
            end
        else
            error('unknown condition');
        end
        
        
    end
end
[phat,pci] = binofit([optRevData.correctByCondition{:}],[optRevData.numTrialsByCondition{:}]);
optRevData.performanceByCondition(1,:) = phat;
optRevData.performanceByCondition(2:3,:) = pci';

[phat,pci] = binofit([optRevData.correctByConditionWCO{:}],[optRevData.numTrialsByConditionWCO{:}]);
optRevData.performanceByConditionWCO(1,:) = phat;
optRevData.performanceByConditionWCO(2:3,:) = pci';

if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::OPTIMAL',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(optRevData.dates-min(optRevData.dates)+1,optRevData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
                case 'performanceByCondition'
                    switch plotDetails.forStudy
                        case 'Lesion'
                            plot([0.25 0.75],[optRevData.performanceByConditionWCO(1,3),optRevData.performanceByConditionWCO(1,4)],'k');
                            if ~isnan(optRevData.performanceByConditionWCO(1,3)),plot(0.25,optRevData.performanceByConditionWCO(1,3),'bd','MarkerFaceColor','b'),...
                                    plot([0.25 0.25],optRevData.performanceByConditionWCO(2:3,3),'LineWidth',2,'color','b'), else plot(3,0.5,'bx'), end
                            if ~isnan(optRevData.performanceByConditionWCO(1,4)),plot(0.75,optRevData.performanceByConditionWCO(1,4),'rd','MarkerFaceColor','r'),...
                                    plot([0.75 0.75],optRevData.performanceByConditionWCO(2:3,4),'LineWidth',2,'color','r'), else plot(4,0.5,'rx'), end
                            Y1 = optRevData.performanceByConditionWCO(1,3)*optRevData.numTrialsByConditionWCO{1,3};
                            n1 = optRevData.numTrialsByConditionWCO{1,3};
                            Y2 = optRevData.performanceByConditionWCO(1,4)*optRevData.numTrialsByConditionWCO{1,4};
                            n2 = optRevData.numTrialsByConditionWCO{1,4};
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
                            if ~isnan(optRevData.performanceByConditionWCO(1,1)),plot(1,optRevData.performanceByConditionWCO(1,1),'bd','MarkerFaceColor','b'),...
                                    plot([1 1],optRevData.performanceByConditionWCO(2:3,1),'LineWidth',2,'color','b'), else plot(1,0.5,'bx'), end
                            if ~isnan(optRevData.performanceByConditionWCO(1,2)),plot(2,optRevData.performanceByConditionWCO(1,2),'rd','MarkerFaceColor','r'),...
                                    plot([2 2],optRevData.performanceByConditionWCO(2:3,2),'LineWidth',2,'color','r'), else plot(2,0.5,'rx'), end
                            if ~isnan(optRevData.performanceByConditionWCO(1,3)),plot(3,optRevData.performanceByConditionWCO(1,3),'bd','MarkerFaceColor','b'),...
                                    plot([3 3],optRevData.performanceByConditionWCO(2:3,3),'LineWidth',2,'color','b'), else plot(3,0.5,'bx'), end
                            if ~isnan(optRevData.performanceByConditionWCO(1,4)),plot(4,optRevData.performanceByConditionWCO(1,4),'rd','MarkerFaceColor','r'),...
                                    plot([4 4],optRevData.performanceByConditionWCO(2:3,4),'LineWidth',2,'color','r'), else plot(4,0.5,'rx'), end
                            if ~isnan(optRevData.performanceByConditionWCO(1,5)),plot(5,optRevData.performanceByConditionWCO(1,5),'kd','MarkerFaceColor','k'),...
                                    plot([5 5],optRevData.performanceByConditionWCO(2:3,5),'LineWidth',2,'color','k'), else plot(5,0.5,'kx'), end
                            plot([0.1 5.9],[0.5 0.5],'k-');
                            plot([0.1 5.9],[0.7 0.7],'k--');
                            set(gca,'xlim',[0 6],'ylim',[0.2 1],'xtick',[1 2 3 4 5],'xticklabel',{'PBS','CNO','Intact','Lesion','Other'},'FontName','Times New Roman','FontSize',12);
                            ylabel('performance','FontName','Times New Roman','FontSize',12);
                    end
                case 'performanceByDay'
                    plot([0 max(optRevData.dates)-min(floor(data.compiledTrialRecords.date))+1],[0.5 0.5],'k');
                    plot([0 max(optRevData.dates)-min(floor(data.compiledTrialRecords.date))+1],[0.7 0.7],'k--');
                    for i = 1:length(optRevData.dates)
                        if ~isnan(optRevData.dayMetCutOffCriterion(i))
                            if optRevData.dayMetCutOffCriterion(i)
                                xloc = optRevData.dates(i)-min(floor(data.compiledTrialRecords.date))+1;
                                plot(xloc,optRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],optRevData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = optRevData.dates(i)-min(floor(data.compiledTrialRecords.date))+1;
                                plot(xloc,optRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],optRevData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = optRevData.dates(i)-min(floor(data.compiledTrialRecords.date))+1;
                            plot(xloc,0.5,'Marker','x','color','k');
                        end
                    end
                    set(gca,'ylim',[0.2 1]);
                    xlabel('day num','FontName','Times New Roman','FontSize',12)
                    ylabel('performance','FontName','Times New Roman','FontSize',12)
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
            bar(optRevData.dates-min(optRevData.dates)+1,optRevData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performanceBycondition
            ax2 = subplot(2,2,2); hold on;
            if ~isnan(optRevData.performanceByConditionWCO(1,1)),plot(1,optRevData.performanceByConditionWCO(1,1),'bd','MarkerFaceColor','b'),...
                    plot([1 1],optRevData.performanceByConditionWCO(2:3,1),'LineWidth',2,'color','b'), else plot(1,0.5,'bx'), end
            if ~isnan(optRevData.performanceByConditionWCO(1,2)),plot(2,optRevData.performanceByConditionWCO(1,2),'rd','MarkerFaceColor','r'),...
                    plot([2 2],optRevData.performanceByConditionWCO(2:3,2),'LineWidth',2,'color','r'), else plot(2,0.5,'rx'), end
            if ~isnan(optRevData.performanceByConditionWCO(1,3)),plot(3,optRevData.performanceByConditionWCO(1,3),'bd','MarkerFaceColor','b'),...
                    plot([3 3],optRevData.performanceByConditionWCO(2:3,3),'LineWidth',2,'color','b'), else plot(3,0.5,'bx'), end
            if ~isnan(optRevData.performanceByConditionWCO(1,4)),plot(4,optRevData.performanceByConditionWCO(1,4),'rd','MarkerFaceColor','r'),...
                    plot([4 4],optRevData.performanceByConditionWCO(2:3,4),'LineWidth',2,'color','r'), else plot(4,0.5,'rx'), end
            if ~isnan(optRevData.performanceByConditionWCO(1,5)),plot(5,optRevData.performanceByConditionWCO(1,5),'kd','MarkerFaceColor','k'),...
                    plot([5 5],optRevData.performanceByConditionWCO(2:3,5),'LineWidth',2,'color','k'), else plot(5,0.5,'kx'), end
            plot([0.1 5.9],[0.5 0.5],'k-');
            plot([0.1 5.9],[0.7 0.7],'k--');
            set(gca,'xlim',[0 6],'ylim',[0.2 1],'xtick',[1 2 3 4 5],'xticklabel',{'PBS','CNO','Intact','Lesion','Other'},'FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performanceByDay
            ax3 = subplot(2,2,3:4); hold on;
            plot([0 max(optRevData.dates)-min(optRevData.dates)+1],[0.5 0.5],'k');
            plot([0 max(optRevData.dates)-min(optRevData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(optRevData.dates)
                if ~isnan(optRevData.dayMetCutOffCriterion(i))
                    if optRevData.dayMetCutOffCriterion(i)
                        xloc = optRevData.dates(i)-min(optRevData.dates)+1;
                        plot(xloc,optRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],optRevData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = optRevData.dates(i)-min(optRevData.dates)+1;
                        plot(xloc,optRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],optRevData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = optRevData.dates(i)-min(optRevData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax3,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12)
            ylabel('performance','FontName','Times New Roman','FontSize',12)
    end
end
