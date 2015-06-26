function orData = analyzeOrientationTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

or = filterBehaviorData(data,'tsName','orORSweep_nAFC');
orData.trialNum = [or.compiledTrialRecords.trialNumber];
orData.correct = [or.compiledTrialRecords.correct];
orData.correction = [or.compiledTrialRecords.correctionTrial];
orData.responseTime = [or.compiledTrialRecords.responseTime];
whichDetailFileNum = find(strcmp({or.compiledDetails.className},'afcGratings'));
orData.orientation = [or.compiledDetails(whichDetailFileNum).records.orientations];
orData.orientation = mod(abs(round(rad2deg(orData.orientation))),180);
orData.time = [or.compiledTrialRecords.date];
orData.date = floor(orData.time);
orData.dates = unique(orData.date);
orData.orientations = unique(orData.orientation);

% performance on a day by day basis
orData.trialNumByDate = cell(1,length(orData.dates));
orData.numTrialsByDate = nan(1,length(orData.dates));
orData.performanceByDate = nan(3,length(orData.dates));
orData.colorByCondition = cell(1,length(orData.dates));
orData.conditionNum = nan(1,length(orData.dates));
orData.dayMetCutOffCriterion = nan(1,length(orData.dates));

%performance by condition
orData.trialNumsByCondition = cell(length(orData.orientations),5);
orData.numTrialsByCondition = zeros(length(orData.orientations),5);
orData.correctByCondition = zeros(length(orData.orientations),5);
orData.performanceByCondition = nan(length(orData.orientations),3,5);
orData.responseTimesByCondition = cell(length(orData.orientations),5);
orData.responseTimesForCorrectByCondition = cell(length(orData.orientations),5);

%performance by condition with trial number cutoff
orData.trialNumsByConditionWCO = cell(length(orData.orientations),5);
orData.numTrialsByConditionWCO = zeros(length(orData.orientations),5);
orData.correctByConditionWCO = zeros(length(orData.orientations),5);
orData.performanceByConditionWCO = nan(length(orData.orientations),3,5);
orData.responseTimesByConditionWCO = cell(length(orData.orientations),5);
orData.responseTimesForCorrectByConditionWCO = cell(length(orData.orientations),5);

for i = 1:length(orData.dates)
    if ismember(orData.dates(i),filters.orFilter)
        dateFilter = orData.date==orData.dates(i);
        correctThatDate = orData.correct(dateFilter);
        correctionThatDate = orData.correction(dateFilter);
        orsThatDate = orData.orientation(dateFilter);
        responseTimeThatDate = orData.responseTime(dateFilter);

        % filter out the nans
        correctionThatDate(isnan(correctionThatDate)) = false;
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate & responseTimeThatDate<5;
        correctThatDate = correctThatDate(whichGood);
        orsThatDate = orsThatDate(whichGood);
        responseTimeThatDate = responseTimeThatDate(whichGood);
        
        orData.trialNumByDate{i} = orData.trialNum(dateFilter);
        orData.trialNumByDate{i} = orData.trialNumByDate{i}(whichGood);
        orData.numTrialsByDate(i) = length(orData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        orData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        orData.performanceByDate(1,i) = phat;
        orData.performanceByDate(2,i) = pci(1);
        orData.performanceByDate(3,i) = pci(2);
        
        if ismember(orData.dates(i),daysPBS)
            orData.colorByCondition{i} = 'b';
            orData.conditionNum(i) = 1;
        elseif ismember(orData.dates(i),daysCNO)
            orData.colorByCondition{i} = 'r';
            orData.conditionNum(i) = 2;
        elseif ismember(orData.dates(i),daysIntact)
            orData.colorByCondition{i} = 'b';
            orData.conditionNum(i) = 3;
        elseif ismember(orData.dates(i),daysLesion)
            orData.colorByCondition{i} = 'r';
            orData.conditionNum(i) = 4;
        else
            orData.colorByCondition{i} = 'k';
            orData.conditionNum(i) = 5;
        end
                
        if orData.conditionNum(i) == 1
            for j = 1:length(orData.orientations)
                whichCurrOrientation = orsThatDate==orData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                currResponseTimes = responseTimeThatDate(whichCurrOrientation);
                currCorrectResponseTimes = currResponseTimes(logical(currOrientationCorrect));
                
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orData.trialNumsByCondition{j,1} = [orData.trialNumsByCondition{j,1} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                orData.numTrialsByCondition(j,1) = orData.numTrialsByCondition(j,1)+n1;
                orData.correctByCondition(j,1) = orData.correctByCondition(j,1)+x1;
                orData.responseTimesByCondition{j,1} = [orData.responseTimesByCondition{j,1} makerow(currResponseTimes)];
                orData.responseTimesForCorrectByCondition{j,1} = [orData.responseTimesForCorrectByCondition{j,1} makerow(currCorrectResponseTimes)];
                
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,1} = [orData.trialNumsByConditionWCO{j,1} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                    orData.numTrialsByConditionWCO(j,1) = orData.numTrialsByConditionWCO(j,1)+n1;
                    orData.correctByConditionWCO(j,1) = orData.correctByConditionWCO(j,1)+x1;
                    orData.responseTimesByConditionWCO{j,1} = [orData.responseTimesByConditionWCO{j,1} makerow(currResponseTimes)];
                    orData.responseTimesForCorrectByConditionWCO{j,1} = [orData.responseTimesForCorrectByConditionWCO{j,1} makerow(currCorrectResponseTimes)];
                end
            end
        elseif orData.conditionNum(i) == 2
            for j = 1:length(orData.orientations)
                whichCurrOrientation = orsThatDate==orData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                currResponseTimes = responseTimeThatDate(whichCurrOrientation);
                currCorrectResponseTimes = currResponseTimes(logical(currOrientationCorrect));
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orData.trialNumsByCondition{j,2} = [orData.trialNumsByCondition{j,2} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                orData.numTrialsByCondition(j,2) = orData.numTrialsByCondition(j,2)+n1;
                orData.correctByCondition(j,2) = orData.correctByCondition(j,2)+x1;
                orData.responseTimesByCondition{j,2} = [orData.responseTimesByCondition{j,2} makerow(currResponseTimes)];
                orData.responseTimesForCorrectByCondition{j,2} = [orData.responseTimesForCorrectByCondition{j,2} makerow(currCorrectResponseTimes)];
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,2} = [orData.trialNumsByConditionWCO{j,2} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                    orData.numTrialsByConditionWCO(j,2) = orData.numTrialsByConditionWCO(j,2)+n1;
                    orData.correctByConditionWCO(j,2) = orData.correctByConditionWCO(j,2)+x1;
                    orData.responseTimesByConditionWCO{j,2} = [orData.responseTimesByConditionWCO{j,2} makerow(currResponseTimes)];
                    orData.responseTimesForCorrectByConditionWCO{j,2} = [orData.responseTimesForCorrectByConditionWCO{j,2} makerow(currCorrectResponseTimes)];
                end
            end
        elseif orData.conditionNum(i) == 3
            for j = 1:length(orData.orientations)
                whichCurrOrientation = orsThatDate==orData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                currResponseTimes = responseTimeThatDate(whichCurrOrientation);
                currCorrectResponseTimes = currResponseTimes(logical(currOrientationCorrect));
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orData.trialNumsByCondition{j,3} = [orData.trialNumsByCondition{j,3} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                orData.numTrialsByCondition(j,3) = orData.numTrialsByCondition(j,3)+n1;
                orData.correctByCondition(j,3) = orData.correctByCondition(j,3)+x1;
                orData.responseTimesByCondition{j,3} = [orData.responseTimesByCondition{j,3} makerow(currResponseTimes)];
                orData.responseTimesForCorrectByCondition{j,3} = [orData.responseTimesForCorrectByCondition{j,3} makerow(currCorrectResponseTimes)];
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,3} = [orData.trialNumsByConditionWCO{j,3} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                    orData.numTrialsByConditionWCO(j,3) = orData.numTrialsByConditionWCO(j,3)+n1;
                    orData.correctByConditionWCO(j,3) = orData.correctByConditionWCO(j,3)+x1;
                    orData.responseTimesByConditionWCO{j,3} = [orData.responseTimesByConditionWCO{j,3} makerow(currResponseTimes)];
                    orData.responseTimesForCorrectByConditionWCO{j,3} = [orData.responseTimesForCorrectByConditionWCO{j,3} makerow(currCorrectResponseTimes)];
                end
            end
        elseif orData.conditionNum(i) == 4
            for j = 1:length(orData.orientations)
                whichCurrOrientation = orsThatDate==orData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                currResponseTimes = responseTimeThatDate(whichCurrOrientation);
                currCorrectResponseTimes = currResponseTimes(logical(currOrientationCorrect));
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orData.trialNumsByCondition{j,4} = [orData.trialNumsByCondition{j,4} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                orData.numTrialsByCondition(j,4) = orData.numTrialsByCondition(j,4)+n1;
                orData.correctByCondition(j,4) = orData.correctByCondition(j,4)+x1;
                orData.responseTimesByCondition{j,4} = [orData.responseTimesByCondition{j,4} makerow(currResponseTimes)];
                orData.responseTimesForCorrectByCondition{j,4} = [orData.responseTimesForCorrectByCondition{j,4} makerow(currCorrectResponseTimes)];
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,4} = [orData.trialNumsByConditionWCO{j,4} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                    orData.numTrialsByConditionWCO(j,4) = orData.numTrialsByConditionWCO(j,4)+n1;
                    orData.correctByConditionWCO(j,4) = orData.correctByConditionWCO(j,4)+x1;
                    orData.responseTimesByConditionWCO{j,4} = [orData.responseTimesByConditionWCO{j,4} makerow(currResponseTimes)];
                    orData.responseTimesForCorrectByConditionWCO{j,4} = [orData.responseTimesForCorrectByConditionWCO{j,4} makerow(currCorrectResponseTimes)];
                end
            end
        elseif orData.conditionNum(i) == 5
            for j = 1:length(orData.orientations)
                whichCurrOrientation = orsThatDate==orData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                currResponseTimes = responseTimeThatDate(whichCurrOrientation);
                currCorrectResponseTimes = currResponseTimes(logical(currOrientationCorrect));
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orData.trialNumsByCondition{j,5} = [orData.trialNumsByCondition{j,5} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                orData.numTrialsByCondition(j,5) = orData.numTrialsByCondition(j,5)+n1;
                orData.correctByCondition(j,5) = orData.correctByCondition(j,5)+x1;
                orData.responseTimesByCondition{j,5} = [orData.responseTimesByCondition{j,5} makerow(currResponseTimes)];
                orData.responseTimesForCorrectByCondition{j,5} = [orData.responseTimesForCorrectByCondition{j,5} makerow(currCorrectResponseTimes)];
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,5} = [orData.trialNumsByConditionWCO{j,5} makerow(orData.trialNumByDate{i}(whichCurrOrientation))];
                    orData.numTrialsByConditionWCO(j,5) = orData.numTrialsByConditionWCO(j,5)+n1;
                    orData.correctByConditionWCO(j,5) = orData.correctByConditionWCO(j,5)+x1;
                    orData.responseTimesByConditionWCO{j,5} = [orData.responseTimesByConditionWCO{j,5} makerow(currResponseTimes)];
                    orData.responseTimesForCorrectByConditionWCO{j,5} = [orData.responseTimesForCorrectByConditionWCO{j,5} makerow(currCorrectResponseTimes)];
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(orData.orientations)
    [phat,pci] = binofit(orData.correctByCondition(j,:),orData.numTrialsByCondition(j,:));
    orData.performanceByCondition(j,1,:) = phat;
    orData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([orData.correctByConditionWCO(j,:)],[orData.numTrialsByConditionWCO(j,:)]);
    orData.performanceByConditionWCO(j,1,:) = phat;
    orData.performanceByConditionWCO(j,2:3,:) = pci';
end



if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::ORIENTATION',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(orData.dates-min(orData.dates)+1,orData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'
                    conditionColor = {'b','r','b','r','k'};
                    for i = 1:size(orData.performanceByConditionWCO,3)
                        if isfield(plotDetails,'plotMeansOnly') && plotDetails.plotMeansOnly
                            means = orData.performanceByConditionWCO(:,1,i);
                            which = ~isnan(orData.performanceByConditionWCO(:,1,i));
                            plot(orData.orientations(which),means(which),'color',conditionColor{i})
                        else
                            for j = 1:size(orData.performanceByConditionWCO,1)
                                if ~isnan(orData.performanceByConditionWCO(j,1,i))
                                    plot(orData.orientations(j),orData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                                    plot([orData.orientations(j) orData.orientations(j)],[orData.performanceByConditionWCO(j,2,i) orData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                                end
                            end
                        end
                    end
                    set(gca,'ylim',[0.2 1.1],'xlim',[0 45],'xtick',[0 5,10,15,20,45],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
                    xlabel('orientation','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByDay'
                    plot([0 max(orData.dates)-min(orData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(orData.dates)-min(orData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(orData.dates)
                        if ~isnan(orData.dayMetCutOffCriterion(i))
                            if orData.dayMetCutOffCriterion(i)
                                xloc = orData.dates(i)-min(orData.dates)+1;
                                plot(xloc,orData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],orData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = orData.dates(i)-min(orData.dates)+1;
                                plot(xloc,orData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],orData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = orData.dates(i)-min(orData.dates)+1;
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
            figName = sprintf('%s::ORIENTATION',mouseID);
            if strcmp(plotDetails.plotWhere,'makeFigure')
                f = figure('name',figName);
            else
                figure(plotDetails.figHan)
            end
            
            % trials by day
            ax1 = subplot(3,2,1); hold on;
            bar(orData.dates-min(orData.dates)+1,orData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performance by day
            ax2 = subplot(3,2,2); hold on;
            plot([0 max(orData.dates)-min(orData.dates)+1],[0.5 0.5],'k');
            plot([0 max(orData.dates)-min(orData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(orData.dates)
                if ~isnan(orData.dayMetCutOffCriterion(i))
                    if orData.dayMetCutOffCriterion(i)
                        xloc = orData.dates(i)-min(orData.dates)+1;
                        plot(xloc,orData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],orData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = orData.dates(i)-min(orData.dates)+1;
                        plot(xloc,orData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],orData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = orData.dates(i)-min(orData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax2,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performance by condition
            ax3 = subplot(3,2,3:4); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(orData.performanceByConditionWCO,3)
                for j = 1:size(orData.performanceByConditionWCO,1)
                    if ~isnan(orData.performanceByConditionWCO(j,1,i))
                        plot(orData.orientations(j),orData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([orData.orientations(j) orData.orientations(j)],[orData.performanceByConditionWCO(j,2,i) orData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax3,'ylim',[0.2 1.1],'xlim',[-5 50],'xtick',[0 15 30 45],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('orientation','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % response times
            ax4 = subplot(3,2,5); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(orData.responseTimesByConditionWCO,2)
                for j = 1:size(orData.responseTimesByConditionWCO,1)
                    if ~(isempty(orData.responseTimesByConditionWCO{j,i}))
                        m = mean(orData.responseTimesByConditionWCO{j,i});
                        sem = std(orData.responseTimesByConditionWCO{j,i})/sqrt(length(orData.responseTimesByConditionWCO{j,i}));
                        plot(orData.orientations(j),m,'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([orData.orientations(j) orData.orientations(j)],[m-sem m+sem],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax4,'ylim',[0 3],'xlim',[-5 50],'xtick',[0 15 30 45],'ytick',[0 1 2 3],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('orientation','FontName','Times New Roman','FontSize',12);
            ylabel('responseTime','FontName','Times New Roman','FontSize',12);
            
            % response times for correct
            ax5 = subplot(3,2,6); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(orData.responseTimesForCorrectByConditionWCO,2)
                for j = 1:size(orData.responseTimesForCorrectByConditionWCO,1)
                    if ~(isempty(orData.responseTimesForCorrectByConditionWCO{j,i}))
                        m = mean(orData.responseTimesForCorrectByConditionWCO{j,i});
                        sem = std(orData.responseTimesForCorrectByConditionWCO{j,i})/sqrt(length(orData.responseTimesForCorrectByConditionWCO{j,i}));
                        plot(orData.orientations(j),m,'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([orData.orientations(j) orData.orientations(j)],[m-sem m+sem],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax5,'ylim',[0 3],'xlim',[-5 50],'xtick',[0 15 30 45],'ytick',[0 1 2 3],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('orientation','FontName','Times New Roman','FontSize',12);
            ylabel('responseTimeForCorrect','FontName','Times New Roman','FontSize',12);
    end
end