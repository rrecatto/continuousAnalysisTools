function imageData = analyzeImagesTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
    plotDetails.forStudy = 'none';
end


im = filterBehaviorData(data,'tsName','nAFC_images');%1031 trials
imageData.trialNum = im.compiledTrialRecords.trialNumber;
imageData.correct = im.compiledTrialRecords.correct;
imageData.correction = im.compiledTrialRecords.correctionTrial;
imageData.correction(isnan(imageData.correction)) = true;
imageData.time = im.compiledTrialRecords.date;
imageData.date = floor(imageData.time);
imageData.dates = unique(imageData.date);

% performance on a day by day basis
imageData.trialNumByDate = cell(1,length(imageData.dates));
imageData.numTrialsByDate = nan(1,length(imageData.dates));
imageData.performanceByDate = nan(3,length(imageData.dates));
imageData.colorByCondition = cell(1,length(imageData.dates));
imageData.conditionNum = nan(1,length(imageData.dates));
imageData.dayMetCutOffCriterion = nan(1,length(imageData.dates));

%performance by condition
imageData.trialNumsByCondition = {[],[],[],[],[]};
imageData.numTrialsByCondition = {0,0,0,0,0};
imageData.correctByCondition = {0,0,0,0,0};
imageData.performanceByCondition = nan(3,5);

%performance by condition with trial number cutoff
imageData.trialNumsByConditionWCO = {[],[],[],[],[]};
imageData.numTrialsByConditionWCO = {0,0,0,0,0};
imageData.correctByConditionWCO = {0,0,0,0,0};
imageData.performanceByConditionWCO = nan(3,5);
for i = 1:length(imageData.dates)
    if ismember(imageData.dates(i),filters.imFilter)
        dateFilter = imageData.date==imageData.dates(i);
        correctThatDate = imageData.correct(dateFilter);
        correctionThatDate = imageData.correction(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        imageData.trialNumByDate{i} = imageData.trialNum(dateFilter);
        imageData.trialNumByDate{i} = imageData.trialNumByDate{i}(whichGood);
        imageData.numTrialsByDate(i) = length(imageData.trialNumByDate{i});
        x = sum(correctThatDate);
        n = length(correctThatDate);
        imageData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        imageData.performanceByDate(1,i) = phat;
        imageData.performanceByDate(2,i) = pci(1);
        imageData.performanceByDate(3,i) = pci(2);
        
        if ismember(imageData.dates(i),datenum(daysPBS))
            imageData.colorByCondition{i} = 'b';
            imageData.conditionNum(i) = 1;
        elseif ismember(imageData.dates(i),datenum(daysCNO))
            imageData.colorByCondition{i} = 'r';
            imageData.conditionNum(i) = 2;
        elseif ismember(imageData.dates(i),datenum(daysIntact))
            imageData.colorByCondition{i} = 'b';
            imageData.conditionNum(i) = 3;
        elseif ismember(imageData.dates(i),datenum(daysLesion))
            imageData.colorByCondition{i} = 'r';
            imageData.conditionNum(i) = 4;
        else
            imageData.colorByCondition{i} = 'k';
            imageData.conditionNum(i) = 5;
        end
        
        if imageData.conditionNum(i) == 1
            imageData.trialNumsByCondition{1} = [imageData.trialNumsByCondition{1} makerow(imageData.trialNumByDate{i})];
            imageData.numTrialsByCondition{1} = imageData.numTrialsByCondition{1}+n;
            imageData.correctByCondition{1} = imageData.correctByCondition{1}+x;
            if imageData.dayMetCutOffCriterion(i)
                imageData.trialNumsByConditionWCO{1} = [imageData.trialNumsByCondition{1} makerow(imageData.trialNumByDate{i})];
                imageData.numTrialsByConditionWCO{1} = imageData.numTrialsByCondition{1}+n;
                imageData.correctByConditionWCO{1} = imageData.correctByCondition{1}+x;
            end
        elseif imageData.conditionNum(i) == 2
            imageData.trialNumsByCondition{2} = [imageData.trialNumsByCondition{2} makerow(imageData.trialNumByDate{i})];
            imageData.numTrialsByCondition{2} = imageData.numTrialsByCondition{2}+n;
            imageData.correctByCondition{2} = imageData.correctByCondition{2}+x;
            if imageData.dayMetCutOffCriterion(i)
                imageData.trialNumsByConditionWCO{2} = [imageData.trialNumsByConditionWCO{2} makerow(imageData.trialNumByDate{i})];
                imageData.numTrialsByConditionWCO{2} = imageData.numTrialsByConditionWCO{2}+n;
                imageData.correctByConditionWCO{2} = imageData.correctByConditionWCO{2}+x;
            end
        elseif imageData.conditionNum(i) == 3
            imageData.trialNumsByCondition{3} = [imageData.trialNumsByCondition{3} makerow(imageData.trialNumByDate{i})];
            imageData.numTrialsByCondition{3} = imageData.numTrialsByCondition{3}+n;
            imageData.correctByCondition{3} = imageData.correctByCondition{3}+x;
            if imageData.dayMetCutOffCriterion(i)
                imageData.trialNumsByConditionWCO{3} = [imageData.trialNumsByConditionWCO{3} makerow(imageData.trialNumByDate{i})];
                imageData.numTrialsByConditionWCO{3} = imageData.numTrialsByConditionWCO{3}+n;
                imageData.correctByConditionWCO{3} = imageData.correctByConditionWCO{3}+x;
            end
        elseif imageData.conditionNum(i) == 4
            imageData.trialNumsByCondition{4} = [imageData.trialNumsByCondition{4} makerow(imageData.trialNumByDate{i})];
            imageData.numTrialsByCondition{4} = imageData.numTrialsByCondition{4}+n;
            imageData.correctByCondition{4} = imageData.correctByCondition{4}+x;
            if imageData.dayMetCutOffCriterion(i)
                imageData.trialNumsByConditionWCO{4} = [imageData.trialNumsByConditionWCO{4} makerow(imageData.trialNumByDate{i})];
                imageData.numTrialsByConditionWCO{4} = imageData.numTrialsByConditionWCO{4}+n;
                imageData.correctByConditionWCO{4} = imageData.correctByConditionWCO{4}+x;
            end
        elseif imageData.conditionNum(i) == 5
            imageData.trialNumsByCondition{5} = [imageData.trialNumsByCondition{5} makerow(imageData.trialNumByDate{i})];
            imageData.numTrialsByCondition{5} = imageData.numTrialsByCondition{5}+n;
            imageData.correctByCondition{5} = imageData.correctByCondition{5}+x;
            if imageData.dayMetCutOffCriterion(i)
                imageData.trialNumsByConditionWCO{5} = [imageData.trialNumsByConditionWCO{5} makerow(imageData.trialNumByDate{i})];
                imageData.numTrialsByConditionWCO{5} = imageData.numTrialsByConditionWCO{5}+n;
                imageData.correctByConditionWCO{5} = imageData.correctByConditionWCO{5}+x;
            end
        else
            error('unknown condition');
        end
        
        
    end
end

% now calculate the % correct
[phat,pci] = binofit([imageData.correctByCondition{:}],[imageData.numTrialsByCondition{:}]);
imageData.performanceByCondition(1,:) = phat;
imageData.performanceByCondition(2:3,:) = pci';

[phat,pci] = binofit([imageData.correctByConditionWCO{:}],[imageData.numTrialsByConditionWCO{:}]);
imageData.performanceByConditionWCO(1,:) = phat;
imageData.performanceByConditionWCO(2:3,:) = pci';

if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::OPTIMAL',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                case 'performanceByCondition'
                case 'performanceByDay'
                    plot([0 max(imageData.dates)-min(floor(data.compiledTrialRecords.date))+1],[0.5 0.5],'k');
                    plot([0 max(imageData.dates)-min(floor(data.compiledTrialRecords.date))+1],[0.7 0.7],'k--');
                    for i = 1:length(imageData.dates)
                        if ~isnan(imageData.dayMetCutOffCriterion(i))
                            if imageData.dayMetCutOffCriterion(i)
                                xloc = imageData.dates(i)-min(floor(data.compiledTrialRecords.date))+1;
                                plot(xloc,imageData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],imageData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = imageData.dates(i)-min(floor(data.compiledTrialRecords.date))+1;
                                plot(xloc,imageData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],imageData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = imageData.dates(i)-min(floor(data.compiledTrialRecords.date))+1;
                            plot(xloc,0.5,'Marker','x','color','k');
                        end
                    end
                    set(gca,'ylim',[0.2 1]);
                    xlabel('day num','FontName','Times New Roman','FontSize',12)
                    ylabel('performance','FontName','Times New Roman','FontSize',12)
                case 'learningProcessOnlyAverage'
                    disp('this assumes you have done the legwork to filter data appropriately. If not, the issue is on your head');
                    hold on;
                    
                    corrects = imageData.correct;
                    whichToRemove = isnan(corrects) | ~ismember(imageData.date,filters.imFilter);
                    corrects(whichToRemove) = [];
                    dates = imageData.date;
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
                    thresholdTrial = find(abs(filter(ones(1,100)/100,1,pointsAboveThreshold)-1)<1e-6,1,'first');
                    plot(thresholdTrial,threshold,'rx');
                    imageData.trialsToThreshold = thresholdTrial;
                    
                    % days
                    uniqDates = unique(dates);
                    imageData.dayNumAtThreshold = find(uniqDates==dates(thresholdTrial),1,'first');
                    
                    
                otherwise
                    error('wtf!');
            end
        case {'givenFigure','makeFigure'}
            figName = sprintf('%s::IMAGES',mouseID);
            f = figure('name',figName);
            ax1 = subplot(2,2,1); hold on;
            bar(imageData.dates-min(imageData.dates)+1,imageData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            ax2 = subplot(2,2,2); hold on;
            if ~isnan(imageData.performanceByConditionWCO(1,1)),plot(1,imageData.performanceByConditionWCO(1,1),'bd','MarkerFaceColor','b'),...
                    plot([1 1],imageData.performanceByConditionWCO(2:3,1),'LineWidth',2,'color','b'), else plot(1,0.5,'bx'), end
            if ~isnan(imageData.performanceByConditionWCO(1,2)),plot(2,imageData.performanceByConditionWCO(1,2),'rd','MarkerFaceColor','r'),...
                    plot([2 2],imageData.performanceByConditionWCO(2:3,2),'LineWidth',2,'color','r'), else plot(2,0.5,'rx'), end
            if ~isnan(imageData.performanceByConditionWCO(1,3)),plot(3,imageData.performanceByConditionWCO(1,3),'bd','MarkerFaceColor','b'),...
                    plot([3 3],imageData.performanceByConditionWCO(2:3,3),'LineWidth',2,'color','b'), else plot(3,0.5,'bx'), end
            if ~isnan(imageData.performanceByConditionWCO(1,4)),plot(4,imageData.performanceByConditionWCO(1,4),'rd','MarkerFaceColor','r'),...
                    plot([4 4],imageData.performanceByConditionWCO(2:3,4),'LineWidth',2,'color','r'), else plot(4,0.5,'rx'), end
            if ~isnan(imageData.performanceByConditionWCO(1,5)),plot(5,imageData.performanceByConditionWCO(1,5),'kd','MarkerFaceColor','k'),...
                    plot([5 5],imageData.performanceByConditionWCO(2:3,5),'LineWidth',2,'color','k'), else plot(5,0.5,'kx'), end
            plot([0.1 5.9],[0.5 0.5],'k-');
            plot([0.1 5.9],[0.7 0.7],'k--');
            set(gca,'xlim',[0 6],'ylim',[0.2 1],'xtick',[1 2 3 4 5],'xticklabel',{'PBS','CNO','Intact','Lesion','Other'});
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            ax3 = subplot(2,2,3:4); hold on;
            plot([0 max(imageData.dates)-min(imageData.dates)+1],[0.5 0.5],'k');
            plot([0 max(imageData.dates)-min(imageData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(imageData.dates)
                if ~isnan(imageData.dayMetCutOffCriterion(i))
                    if imageData.dayMetCutOffCriterion(i)
                        xloc = imageData.dates(i)-min(imageData.dates)+1;
                        plot(xloc,imageData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],imageData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = imageData.dates(i)-min(imageData.dates)+1;
                        plot(xloc,imageData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],imageData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = imageData.dates(i)-min(imageData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax3,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
    end
end