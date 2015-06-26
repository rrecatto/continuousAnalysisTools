function spatFreqData = analyzeSpatFreqReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

spat = filterBehaviorData(data,'tsName','orSFSweep_Reversal_nAFC');
spatFreqData.trialNum = [spat.compiledTrialRecords.trialNumber];
spatFreqData.correct = [spat.compiledTrialRecords.correct];
spatFreqData.correction = [spat.compiledTrialRecords.correctionTrial];
whichDetailFileNum = find(strcmp({spat.compiledDetails.className},'afcGratings'));
spatFreqData.spatFreq = 1./rad2deg(atan(0.00110243055*[spat.compiledDetails(whichDetailFileNum).records.pixPerCycs]));
spatFreqData.time = [spat.compiledTrialRecords.date];
spatFreqData.date = floor(spatFreqData.time);
spatFreqData.dates = unique(spatFreqData.date);
spatFreqData.spatFreqs = unique(spatFreqData.spatFreq);

% performance on a day by day basis
spatFreqData.trialNumByDate = cell(1,length(spatFreqData.dates));
spatFreqData.numTrialsByDate = nan(1,length(spatFreqData.dates));
spatFreqData.performanceByDate = nan(3,length(spatFreqData.dates));
spatFreqData.colorByCondition = cell(1,length(spatFreqData.dates));
spatFreqData.conditionNum = nan(1,length(spatFreqData.dates));
spatFreqData.dayMetCutOffCriterion = nan(1,length(spatFreqData.dates));

%performance by condition
spatFreqData.trialNumsByCondition = cell(length(spatFreqData.spatFreqs),5);
spatFreqData.numTrialsByCondition = zeros(length(spatFreqData.spatFreqs),5);
spatFreqData.correctByCondition = zeros(length(spatFreqData.spatFreqs),5);
spatFreqData.performanceByCondition = nan(length(spatFreqData.spatFreqs),3,5);

%performance by condition with trial number cutoff
spatFreqData.trialNumsByConditionWCO = cell(length(spatFreqData.spatFreqs),5);
spatFreqData.numTrialsByConditionWCO = zeros(length(spatFreqData.spatFreqs),5);
spatFreqData.correctByConditionWCO = zeros(length(spatFreqData.spatFreqs),5);
spatFreqData.performanceByConditionWCO = nan(length(spatFreqData.spatFreqs),3,5);

for i = 1:length(spatFreqData.dates)
    if ismember(spatFreqData.dates(i),filters.sfFilter)
        dateFilter = spatFreqData.date==spatFreqData.dates(i);
        correctThatDate = spatFreqData.correct(dateFilter);
        correctionThatDate = spatFreqData.correction(dateFilter);
        spatFreqThatDate = spatFreqData.spatFreq(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        spatFreqThatDate = spatFreqThatDate(whichGood);
 
        spatFreqData.trialNumByDate{i} = spatFreqData.trialNum(dateFilter);
        spatFreqData.trialNumByDate{i} = spatFreqData.trialNumByDate{i}(whichGood);
        spatFreqData.numTrialsByDate(i) = length(spatFreqData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        spatFreqData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        spatFreqData.performanceByDate(1,i) = phat;
        spatFreqData.performanceByDate(2,i) = pci(1);
        spatFreqData.performanceByDate(3,i) = pci(2);
        
        if ismember(spatFreqData.dates(i),daysPBS)
            spatFreqData.colorByCondition{i} = 'b';
            spatFreqData.conditionNum(i) = 1;
        elseif ismember(spatFreqData.dates(i),daysCNO)
            spatFreqData.colorByCondition{i} = 'r';
            spatFreqData.conditionNum(i) = 2;
        elseif ismember(spatFreqData.dates(i),daysIntact)
            spatFreqData.colorByCondition{i} = 'b';
            spatFreqData.conditionNum(i) = 3;
        elseif ismember(spatFreqData.dates(i),daysLesion)
            spatFreqData.colorByCondition{i} = 'r';
            spatFreqData.conditionNum(i) = 4;
        else
            spatFreqData.colorByCondition{i} = 'k';
            spatFreqData.conditionNum(i) = 5;
        end
                
        if spatFreqData.conditionNum(i) == 1
            for j = 1:length(spatFreqData.spatFreqs)
                whichCurrSpatFreq = spatFreqThatDate==spatFreqData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrSpatFreq);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatFreqData.trialNumsByCondition{j,1} = [spatFreqData.trialNumsByCondition{j,1} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                spatFreqData.numTrialsByCondition(j,1) = spatFreqData.numTrialsByCondition(j,1)+n1;
                spatFreqData.correctByCondition(j,1) = spatFreqData.correctByCondition(j,1)+x1;
                if spatFreqData.dayMetCutOffCriterion(i)
                    spatFreqData.trialNumsByConditionWCO{j,1} = [spatFreqData.trialNumsByConditionWCO{j,1} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                    spatFreqData.numTrialsByConditionWCO(j,1) = spatFreqData.numTrialsByConditionWCO(j,1)+n1;
                    spatFreqData.correctByConditionWCO(j,1) = spatFreqData.correctByConditionWCO(j,1)+x1;
                end
            end
        elseif spatFreqData.conditionNum(i) == 2
            for j = 1:length(spatFreqData.spatFreqs)
                whichCurrSpatFreq = spatFreqThatDate==spatFreqData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrSpatFreq);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatFreqData.trialNumsByCondition{j,2} = [spatFreqData.trialNumsByCondition{j,2} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                spatFreqData.numTrialsByCondition(j,2) = spatFreqData.numTrialsByCondition(j,2)+n1;
                spatFreqData.correctByCondition(j,2) = spatFreqData.correctByCondition(j,2)+x1;
                if spatFreqData.dayMetCutOffCriterion(i)
                    spatFreqData.trialNumsByConditionWCO{j,2} = [spatFreqData.trialNumsByConditionWCO{j,2} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                    spatFreqData.numTrialsByConditionWCO(j,2) = spatFreqData.numTrialsByConditionWCO(j,2)+n1;
                    spatFreqData.correctByConditionWCO(j,2) = spatFreqData.correctByConditionWCO(j,2)+x1;
                end
            end
        elseif spatFreqData.conditionNum(i) == 3
            for j = 1:length(spatFreqData.spatFreqs)
                whichCurrSpatFreq = spatFreqThatDate==spatFreqData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrSpatFreq);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatFreqData.trialNumsByCondition{j,3} = [spatFreqData.trialNumsByCondition{j,3} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                spatFreqData.numTrialsByCondition(j,3) = spatFreqData.numTrialsByCondition(j,3)+n1;
                spatFreqData.correctByCondition(j,3) = spatFreqData.correctByCondition(j,3)+x1;
                if spatFreqData.dayMetCutOffCriterion(i)
                    spatFreqData.trialNumsByConditionWCO{j,3} = [spatFreqData.trialNumsByConditionWCO{j,3} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                    spatFreqData.numTrialsByConditionWCO(j,3) = spatFreqData.numTrialsByConditionWCO(j,3)+n1;
                    spatFreqData.correctByConditionWCO(j,3) = spatFreqData.correctByConditionWCO(j,3)+x1;
                end
            end
        elseif spatFreqData.conditionNum(i) == 4
            for j = 1:length(spatFreqData.spatFreqs)
                whichCurrSpatFreq = spatFreqThatDate==spatFreqData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrSpatFreq);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatFreqData.trialNumsByCondition{j,4} = [spatFreqData.trialNumsByCondition{j,4} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                spatFreqData.numTrialsByCondition(j,4) = spatFreqData.numTrialsByCondition(j,4)+n1;
                spatFreqData.correctByCondition(j,4) = spatFreqData.correctByCondition(j,4)+x1;
                if spatFreqData.dayMetCutOffCriterion(i)
                    spatFreqData.trialNumsByConditionWCO{j,4} = [spatFreqData.trialNumsByConditionWCO{j,4} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                    spatFreqData.numTrialsByConditionWCO(j,4) = spatFreqData.numTrialsByConditionWCO(j,4)+n1;
                    spatFreqData.correctByConditionWCO(j,4) = spatFreqData.correctByConditionWCO(j,4)+x1;
                end
            end
        elseif spatFreqData.conditionNum(i) == 5
            for j = 1:length(spatFreqData.spatFreqs)
                whichCurrSpatFreq = spatFreqThatDate==spatFreqData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrSpatFreq);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatFreqData.trialNumsByCondition{j,5} = [spatFreqData.trialNumsByCondition{j,5} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                spatFreqData.numTrialsByCondition(j,5) = spatFreqData.numTrialsByCondition(j,5)+n1;
                spatFreqData.correctByCondition(j,5) = spatFreqData.correctByCondition(j,5)+x1;
                if spatFreqData.dayMetCutOffCriterion(i)
                    spatFreqData.trialNumsByConditionWCO{j,5} = [spatFreqData.trialNumsByConditionWCO{j,5} makerow(spatFreqData.trialNumByDate{i}(whichCurrSpatFreq))];
                    spatFreqData.numTrialsByConditionWCO(j,5) = spatFreqData.numTrialsByConditionWCO(j,5)+n1;
                    spatFreqData.correctByConditionWCO(j,5) = spatFreqData.correctByConditionWCO(j,5)+x1;
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(spatFreqData.spatFreqs)
    [phat,pci] = binofit(spatFreqData.correctByCondition(j,:),spatFreqData.numTrialsByCondition(j,:));
    spatFreqData.performanceByCondition(j,1,:) = phat;
    spatFreqData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([spatFreqData.correctByConditionWCO(j,:)],[spatFreqData.numTrialsByConditionWCO(j,:)]);
    spatFreqData.performanceByConditionWCO(j,1,:) = phat;
    spatFreqData.performanceByConditionWCO(j,2:3,:) = pci';
end



if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::CONTRAST',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(spatFreqData.dates-min(spatFreqData.dates)+1,spatFreqData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'
                    conditionColor = {'b','r','b','r','k'};
                    for i = 1:size(spatFreqData.performanceByConditionWCO,3)
                        if isfield(plotDetails,'plotMeansOnly') && plotDetails.plotMeansOnly
                            means = spatFreqData.performanceByConditionWCO(:,1,i);
                            which = ~isnan(spatFreqData.performanceByConditionWCO(:,1,i));
                            plot(spatFreqData.spatFreqs(which),means(which),'color',conditionColor{i})
                        else
                            for k = 1:size(spatFreqData.performanceByConditionWCO,3)
                                for j = 1:size(spatFreqData.performanceByConditionWCO,1)
                                    if ~isnan(spatFreqData.performanceByConditionWCO(j,1,k))
                                        plot(spatFreqData.spatFreqs(j),spatFreqData.performanceByConditionWCO(j,1,k),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{k},'MarkerEdgeColor','none');
                                        plot([spatFreqData.spatFreqs(j) spatFreqData.spatFreqs(j)],[spatFreqData.performanceByConditionWCO(j,2,k) spatFreqData.performanceByConditionWCO(j,3,k)],'color',conditionColor{k},'linewidth',5);
                                    end
                                end
                            end
                        end
                    end
                    
                    set(gca,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
                    xlabel('spatFreq','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByDay'
                    plot([0 max(spatFreqData.dates)-min(spatFreqData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(spatFreqData.dates)-min(spatFreqData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(spatFreqData.dates)
                        if ~isnan(spatFreqData.dayMetCutOffCriterion(i))
                            if spatFreqData.dayMetCutOffCriterion(i)
                                xloc = spatFreqData.dates(i)-min(spatFreqData.dates)+1;
                                plot(xloc,spatFreqData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],spatFreqData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = spatFreqData.dates(i)-min(spatFreqData.dates)+1;
                                plot(xloc,spatFreqData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],spatFreqData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = spatFreqData.dates(i)-min(spatFreqData.dates)+1;
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
            bar(spatFreqData.dates-min(spatFreqData.dates)+1,spatFreqData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performance by day
            ax2 = subplot(3,2,2); hold on;
            plot([0 max(spatFreqData.dates)-min(spatFreqData.dates)+1],[0.5 0.5],'k');
            plot([0 max(spatFreqData.dates)-min(spatFreqData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(spatFreqData.dates)
                if ~isnan(spatFreqData.dayMetCutOffCriterion(i))
                    if spatFreqData.dayMetCutOffCriterion(i)
                        xloc = spatFreqData.dates(i)-min(spatFreqData.dates)+1;
                        plot(xloc,spatFreqData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],spatFreqData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = spatFreqData.dates(i)-min(spatFreqData.dates)+1;
                        plot(xloc,spatFreqData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],spatFreqData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = spatFreqData.dates(i)-min(spatFreqData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax2,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performance by condition
            ax3 = subplot(3,2,3:6); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(spatFreqData.performanceByConditionWCO,3)
                for j = 1:size(spatFreqData.performanceByConditionWCO,1)
                    if ~isnan(spatFreqData.performanceByConditionWCO(j,1,i))
                        plot(spatFreqData.spatFreqs(j),spatFreqData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([spatFreqData.spatFreqs(j) spatFreqData.spatFreqs(j)],[spatFreqData.performanceByConditionWCO(j,2,i) spatFreqData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax3,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('spatFreq','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
    end
end