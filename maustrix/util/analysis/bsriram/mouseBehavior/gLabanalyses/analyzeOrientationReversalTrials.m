function orRevData = analyzeOrientationReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

orRev = filterBehaviorData(data,'tsName','orORSweep_Reversal_nAFC');
orRevData.trialNum = [orRev.compiledTrialRecords.trialNumber];
orRevData.correct = [orRev.compiledTrialRecords.correct];
orRevData.correction = [orRev.compiledTrialRecords.correctionTrial];
whichDetailFileNum = find(strcmp({orRev.compiledDetails.className},'afcGratings'));
orRevData.orientation = [orRev.compiledDetails(whichDetailFileNum).records.orientations];
orRevData.orientation = mod(abs(round(rad2deg(orRevData.orientation))),180);
orRevData.time = [orRev.compiledTrialRecords.date];
orRevData.date = floor(orRevData.time);
orRevData.dates = unique(orRevData.date);
orRevData.orientations = unique(orRevData.orientation);

% performance on a day by day basis
orRevData.trialNumByDate = cell(1,length(orRevData.dates));
orRevData.numTrialsByDate = nan(1,length(orRevData.dates));
orRevData.performanceByDate = nan(3,length(orRevData.dates));
orRevData.colorByCondition = cell(1,length(orRevData.dates));
orRevData.conditionNum = nan(1,length(orRevData.dates));
orRevData.dayMetCutOffCriterion = nan(1,length(orRevData.dates));

%performance by condition
orRevData.trialNumsByCondition = cell(length(orRevData.orientations),5);
orRevData.numTrialsByCondition = zeros(length(orRevData.orientations),5);
orRevData.correctByCondition = zeros(length(orRevData.orientations),5);
orRevData.performanceByCondition = nan(length(orRevData.orientations),3,5);

%performance by condition with trial number cutoff
orRevData.trialNumsByConditionWCO = cell(length(orRevData.orientations),5);
orRevData.numTrialsByConditionWCO = zeros(length(orRevData.orientations),5);
orRevData.correctByConditionWCO = zeros(length(orRevData.orientations),5);
orRevData.performanceByConditionWCO = nan(length(orRevData.orientations),3,5);

for i = 1:length(orRevData.dates)
    if ismember(orRevData.dates(i),filters.orFilter)
        dateFilter = orRevData.date==orRevData.dates(i);
        correctThatDate = orRevData.correct(dateFilter);
        correctionThatDate = orRevData.correction(dateFilter);
        orsThatDate = orRevData.orientation(dateFilter);
        % filter out the nans
        correctionThatDate(isnan(correctionThatDate)) = true;
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        orsThatDate = orsThatDate(whichGood);
 
        orRevData.trialNumByDate{i} = orRevData.trialNum(dateFilter);
        orRevData.trialNumByDate{i} = orRevData.trialNumByDate{i}(whichGood);
        orRevData.numTrialsByDate(i) = length(orRevData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        orRevData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        orRevData.performanceByDate(1,i) = phat;
        orRevData.performanceByDate(2,i) = pci(1);
        orRevData.performanceByDate(3,i) = pci(2);
        
        if ismember(orRevData.dates(i),daysPBS)
            orRevData.colorByCondition{i} = 'b';
            orRevData.conditionNum(i) = 1;
        elseif ismember(orRevData.dates(i),daysCNO)
            orRevData.colorByCondition{i} = 'r';
            orRevData.conditionNum(i) = 2;
        elseif ismember(orRevData.dates(i),daysIntact)
            orRevData.colorByCondition{i} = 'b';
            orRevData.conditionNum(i) = 3;
        elseif ismember(orRevData.dates(i),daysLesion)
            orRevData.colorByCondition{i} = 'r';
            orRevData.conditionNum(i) = 4;
        else
            orRevData.colorByCondition{i} = 'k';
            orRevData.conditionNum(i) = 5;
        end
                
        if orRevData.conditionNum(i) == 1
            for j = 1:length(orRevData.orientations)
                whichCurrOrientation = orsThatDate==orRevData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orRevData.trialNumsByCondition{j,1} = [orRevData.trialNumsByCondition{j,1} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                orRevData.numTrialsByCondition(j,1) = orRevData.numTrialsByCondition(j,1)+n1;
                orRevData.correctByCondition(j,1) = orRevData.correctByCondition(j,1)+x1;
                if orRevData.dayMetCutOffCriterion(i)
                    orRevData.trialNumsByConditionWCO{j,1} = [orRevData.trialNumsByConditionWCO{j,1} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                    orRevData.numTrialsByConditionWCO(j,1) = orRevData.numTrialsByConditionWCO(j,1)+n1;
                    orRevData.correctByConditionWCO(j,1) = orRevData.correctByConditionWCO(j,1)+x1;
                end
            end
        elseif orRevData.conditionNum(i) == 2
            for j = 1:length(orRevData.orientations)
                whichCurrOrientation = orsThatDate==orRevData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orRevData.trialNumsByCondition{j,2} = [orRevData.trialNumsByCondition{j,2} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                orRevData.numTrialsByCondition(j,2) = orRevData.numTrialsByCondition(j,2)+n1;
                orRevData.correctByCondition(j,2) = orRevData.correctByCondition(j,2)+x1;
                if orRevData.dayMetCutOffCriterion(i)
                    orRevData.trialNumsByConditionWCO{j,2} = [orRevData.trialNumsByConditionWCO{j,2} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                    orRevData.numTrialsByConditionWCO(j,2) = orRevData.numTrialsByConditionWCO(j,2)+n1;
                    orRevData.correctByConditionWCO(j,2) = orRevData.correctByConditionWCO(j,2)+x1;
                end
            end
        elseif orRevData.conditionNum(i) == 3
            for j = 1:length(orRevData.orientations)
                whichCurrOrientation = orsThatDate==orRevData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orRevData.trialNumsByCondition{j,3} = [orRevData.trialNumsByCondition{j,3} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                orRevData.numTrialsByCondition(j,3) = orRevData.numTrialsByCondition(j,3)+n1;
                orRevData.correctByCondition(j,3) = orRevData.correctByCondition(j,3)+x1;
                if orRevData.dayMetCutOffCriterion(i)
                    orRevData.trialNumsByConditionWCO{j,3} = [orRevData.trialNumsByConditionWCO{j,3} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                    orRevData.numTrialsByConditionWCO(j,3) = orRevData.numTrialsByConditionWCO(j,3)+n1;
                    orRevData.correctByConditionWCO(j,3) = orRevData.correctByConditionWCO(j,3)+x1;
                end
            end
        elseif orRevData.conditionNum(i) == 4
            for j = 1:length(orRevData.orientations)
                whichCurrOrientation = orsThatDate==orRevData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orRevData.trialNumsByCondition{j,4} = [orRevData.trialNumsByCondition{j,4} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                orRevData.numTrialsByCondition(j,4) = orRevData.numTrialsByCondition(j,4)+n1;
                orRevData.correctByCondition(j,4) = orRevData.correctByCondition(j,4)+x1;
                if orRevData.dayMetCutOffCriterion(i)
                    orRevData.trialNumsByConditionWCO{j,4} = [orRevData.trialNumsByConditionWCO{j,4} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                    orRevData.numTrialsByConditionWCO(j,4) = orRevData.numTrialsByConditionWCO(j,4)+n1;
                    orRevData.correctByConditionWCO(j,4) = orRevData.correctByConditionWCO(j,4)+x1;
                end
            end
        elseif orRevData.conditionNum(i) == 5
            for j = 1:length(orRevData.orientations)
                whichCurrOrientation = orsThatDate==orRevData.orientations(j);
                currOrientationCorrect = correctThatDate(whichCurrOrientation);
                x1 = sum(currOrientationCorrect);
                n1 = length(currOrientationCorrect);
                orRevData.trialNumsByCondition{j,5} = [orRevData.trialNumsByCondition{j,5} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                orRevData.numTrialsByCondition(j,5) = orRevData.numTrialsByCondition(j,5)+n1;
                orRevData.correctByCondition(j,5) = orRevData.correctByCondition(j,5)+x1;
                if orRevData.dayMetCutOffCriterion(i)
                    orRevData.trialNumsByConditionWCO{j,5} = [orRevData.trialNumsByConditionWCO{j,5} makerow(orRevData.trialNumByDate{i}(whichCurrOrientation))];
                    orRevData.numTrialsByConditionWCO(j,5) = orRevData.numTrialsByConditionWCO(j,5)+n1;
                    orRevData.correctByConditionWCO(j,5) = orRevData.correctByConditionWCO(j,5)+x1;
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(orRevData.orientations)
    [phat,pci] = binofit(orRevData.correctByCondition(j,:),orRevData.numTrialsByCondition(j,:));
    orRevData.performanceByCondition(j,1,:) = phat;
    orRevData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([orRevData.correctByConditionWCO(j,:)],[orRevData.numTrialsByConditionWCO(j,:)]);
    orRevData.performanceByConditionWCO(j,1,:) = phat;
    orRevData.performanceByConditionWCO(j,2:3,:) = pci';
end



if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::ORIENTATION',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(orRevData.dates-min(orRevData.dates)+1,orRevData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'
                    conditionColor = {'b','r','b','r','k'};
                    for i = 1:size(orRevData.performanceByConditionWCO,3)
                        if isfield(plotDetails,'plotMeansOnly') && plotDetails.plotMeansOnly
                            means = orRevData.performanceByConditionWCO(:,1,i);
                            which = ~isnan(orRevData.performanceByConditionWCO(:,1,i));
                            plot(orRevData.orientations(which),means(which),'color',conditionColor{i})
                        else
                            for j = 1:size(orRevData.performanceByConditionWCO,1)
                                if ~isnan(orRevData.performanceByConditionWCO(j,1,i))
                                    plot(orRevData.orientations(j),orRevData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                                    plot([orRevData.orientations(j) orRevData.orientations(j)],[orRevData.performanceByConditionWCO(j,2,i) orRevData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                                end
                            end
                        end
                    end
                    set(gca,'ylim',[0.2 1.1],'xlim',[0 45],'xtick',[0 5,10,15,20,45],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
                    xlabel('orientation','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByDay'
                    plot([0 max(orRevData.dates)-min(orRevData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(orRevData.dates)-min(orRevData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(orRevData.dates)
                        if ~isnan(orRevData.dayMetCutOffCriterion(i))
                            if orRevData.dayMetCutOffCriterion(i)
                                xloc = orRevData.dates(i)-min(orRevData.dates)+1;
                                plot(xloc,orRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],orRevData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = orRevData.dates(i)-min(orRevData.dates)+1;
                                plot(xloc,orRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],orRevData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = orRevData.dates(i)-min(orRevData.dates)+1;
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
            bar(orRevData.dates-min(orRevData.dates)+1,orRevData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performance by day
            ax2 = subplot(3,2,2); hold on;
            plot([0 max(orRevData.dates)-min(orRevData.dates)+1],[0.5 0.5],'k');
            plot([0 max(orRevData.dates)-min(orRevData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(orRevData.dates)
                if ~isnan(orRevData.dayMetCutOffCriterion(i))
                    if orRevData.dayMetCutOffCriterion(i)
                        xloc = orRevData.dates(i)-min(orRevData.dates)+1;
                        plot(xloc,orRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],orRevData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = orRevData.dates(i)-min(orRevData.dates)+1;
                        plot(xloc,orRevData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],orRevData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = orRevData.dates(i)-min(orRevData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax2,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performance by condition
            ax3 = subplot(3,2,3:6); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(orRevData.performanceByConditionWCO,3)
                for j = 1:size(orRevData.performanceByConditionWCO,1)
                    if ~isnan(orRevData.performanceByConditionWCO(j,1,i))
                        plot(orRevData.orientations(j),orRevData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([orRevData.orientations(j) orRevData.orientations(j)],[orRevData.performanceByConditionWCO(j,2,i) orRevData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax3,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('orientation','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
    end
end