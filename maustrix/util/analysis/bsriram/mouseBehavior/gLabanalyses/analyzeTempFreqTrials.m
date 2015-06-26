function tempFreqData = analyzeTempFreqTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

tempfreq = filterBehaviorData(data,'tsName','orTFSweep_nAFC');
tempFreqData.trialNum = [tempfreq.compiledTrialRecords.trialNumber];
tempFreqData.correct = [tempfreq.compiledTrialRecords.correct];
tempFreqData.correction = [tempfreq.compiledTrialRecords.correctionTrial];
whichDetailFileNum = find(strcmp({tempfreq.compiledDetails.className},'afcGratings'));
tempFreqData.tempfreq = [tempfreq.compiledDetails(whichDetailFileNum).records.driftfrequencies];
tempFreqData.time = [tempfreq.compiledTrialRecords.date];
tempFreqData.date = floor(tempFreqData.time);
tempFreqData.dates = unique(tempFreqData.date);
tempFreqData.tempfreqs = unique(tempFreqData.tempfreq);

% performance on a day by day basis
tempFreqData.trialNumByDate = cell(1,length(tempFreqData.dates));
tempFreqData.numTrialsByDate = nan(1,length(tempFreqData.dates));
tempFreqData.performanceByDate = nan(3,length(tempFreqData.dates));
tempFreqData.colorByCondition = cell(1,length(tempFreqData.dates));
tempFreqData.conditionNum = nan(1,length(tempFreqData.dates));
tempFreqData.dayMetCutOffCriterion = nan(1,length(tempFreqData.dates));

%performance by condition
tempFreqData.trialNumsByCondition = cell(length(tempFreqData.tempfreq),5);
tempFreqData.numTrialsByCondition = zeros(length(tempFreqData.tempfreq),5);
tempFreqData.correctByCondition = zeros(length(tempFreqData.tempfreq),5);
tempFreqData.performanceByCondition = nan(length(tempFreqData.tempfreq),3,5);

%performance by condition with trial number cutoff
tempFreqData.trialNumsByConditionWCO = cell(length(tempFreqData.tempfreq),5);
tempFreqData.numTrialsByConditionWCO = zeros(length(tempFreqData.tempfreq),5);
tempFreqData.correctByConditionWCO = zeros(length(tempFreqData.tempfreq),5);
tempFreqData.performanceByConditionWCO = nan(length(tempFreqData.tempfreq),3,5);

for i = 1:length(tempFreqData.dates)
%     warning('need to select mainly for spat. freq.');
%     keyboard
    if ismember(tempFreqData.dates(i),filters.ctrFilter)
        dateFilter = tempFreqData.date==tempFreqData.dates(i);
        correctThatDate = tempFreqData.correct(dateFilter);
        correctionThatDate = tempFreqData.correction(dateFilter);
        tempfreqThatDate = tempFreqData.tempfreq(dateFilter);
        % filter out the nans
        correctionThatDate(isnan(correctionThatDate)) = true; 
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        tempfreqThatDate = tempfreqThatDate(whichGood);
 
        tempFreqData.trialNumByDate{i} = tempFreqData.trialNum(dateFilter);
        tempFreqData.trialNumByDate{i} = tempFreqData.trialNumByDate{i}(whichGood);
        tempFreqData.numTrialsByDate(i) = length(tempFreqData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        tempFreqData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        tempFreqData.performanceByDate(1,i) = phat;
        tempFreqData.performanceByDate(2,i) = pci(1);
        tempFreqData.performanceByDate(3,i) = pci(2);
        
        if ismember(tempFreqData.dates(i),daysPBS)
            tempFreqData.colorByCondition{i} = 'b';
            tempFreqData.conditionNum(i) = 1;
        elseif ismember(tempFreqData.dates(i),daysCNO)
            tempFreqData.colorByCondition{i} = 'r';
            tempFreqData.conditionNum(i) = 2;
        elseif ismember(tempFreqData.dates(i),daysIntact)
            tempFreqData.colorByCondition{i} = 'b';
            tempFreqData.conditionNum(i) = 3;
        elseif ismember(tempFreqData.dates(i),daysLesion)
            tempFreqData.colorByCondition{i} = 'r';
            tempFreqData.conditionNum(i) = 4;
        else
            tempFreqData.colorByCondition{i} = 'k';
            tempFreqData.conditionNum(i) = 5;
        end
                
        if tempFreqData.conditionNum(i) == 1
            for j = 1:length(tempFreqData.tempfreqs)
                whichCurrContrast = tempfreqThatDate==tempFreqData.tempfreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempFreqData.trialNumsByCondition{j,1} = [tempFreqData.trialNumsByCondition{j,1} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                tempFreqData.numTrialsByCondition(j,1) = tempFreqData.numTrialsByCondition(j,1)+n1;
                tempFreqData.correctByCondition(j,1) = tempFreqData.correctByCondition(j,1)+x1;
                if tempFreqData.dayMetCutOffCriterion(i)
                    tempFreqData.trialNumsByConditionWCO{j,1} = [tempFreqData.trialNumsByConditionWCO{j,1} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                    tempFreqData.numTrialsByConditionWCO(j,1) = tempFreqData.numTrialsByConditionWCO(j,1)+n1;
                    tempFreqData.correctByConditionWCO(j,1) = tempFreqData.correctByConditionWCO(j,1)+x1;
                end
            end
        elseif tempFreqData.conditionNum(i) == 2
            for j = 1:length(tempFreqData.tempfreqs)
                whichCurrContrast = tempfreqThatDate==tempFreqData.tempfreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempFreqData.trialNumsByCondition{j,2} = [tempFreqData.trialNumsByCondition{j,2} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                tempFreqData.numTrialsByCondition(j,2) = tempFreqData.numTrialsByCondition(j,2)+n1;
                tempFreqData.correctByCondition(j,2) = tempFreqData.correctByCondition(j,2)+x1;
                if tempFreqData.dayMetCutOffCriterion(i)
                    tempFreqData.trialNumsByConditionWCO{j,2} = [tempFreqData.trialNumsByConditionWCO{j,2} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                    tempFreqData.numTrialsByConditionWCO(j,2) = tempFreqData.numTrialsByConditionWCO(j,2)+n1;
                    tempFreqData.correctByConditionWCO(j,2) = tempFreqData.correctByConditionWCO(j,2)+x1;
                end
            end
        elseif tempFreqData.conditionNum(i) == 3
            for j = 1:length(tempFreqData.tempfreqs)
                whichCurrContrast = tempfreqThatDate==tempFreqData.tempfreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempFreqData.trialNumsByCondition{j,3} = [tempFreqData.trialNumsByCondition{j,3} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                tempFreqData.numTrialsByCondition(j,3) = tempFreqData.numTrialsByCondition(j,3)+n1;
                tempFreqData.correctByCondition(j,3) = tempFreqData.correctByCondition(j,3)+x1;
                if tempFreqData.dayMetCutOffCriterion(i)
                    tempFreqData.trialNumsByConditionWCO{j,3} = [tempFreqData.trialNumsByConditionWCO{j,3} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                    tempFreqData.numTrialsByConditionWCO(j,3) = tempFreqData.numTrialsByConditionWCO(j,3)+n1;
                    tempFreqData.correctByConditionWCO(j,3) = tempFreqData.correctByConditionWCO(j,3)+x1;
                end
            end
        elseif tempFreqData.conditionNum(i) == 4
            for j = 1:length(tempFreqData.tempfreqs)
                whichCurrContrast = tempfreqThatDate==tempFreqData.tempfreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempFreqData.trialNumsByCondition{j,4} = [tempFreqData.trialNumsByCondition{j,4} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                tempFreqData.numTrialsByCondition(j,4) = tempFreqData.numTrialsByCondition(j,4)+n1;
                tempFreqData.correctByCondition(j,4) = tempFreqData.correctByCondition(j,4)+x1;
                if tempFreqData.dayMetCutOffCriterion(i)
                    tempFreqData.trialNumsByConditionWCO{j,4} = [tempFreqData.trialNumsByConditionWCO{j,4} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                    tempFreqData.numTrialsByConditionWCO(j,4) = tempFreqData.numTrialsByConditionWCO(j,4)+n1;
                    tempFreqData.correctByConditionWCO(j,4) = tempFreqData.correctByConditionWCO(j,4)+x1;
                end
            end
        elseif tempFreqData.conditionNum(i) == 5
            for j = 1:length(tempFreqData.tempfreqs)
                whichCurrContrast = tempfreqThatDate==tempFreqData.tempfreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempFreqData.trialNumsByCondition{j,5} = [tempFreqData.trialNumsByCondition{j,5} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                tempFreqData.numTrialsByCondition(j,5) = tempFreqData.numTrialsByCondition(j,5)+n1;
                tempFreqData.correctByCondition(j,5) = tempFreqData.correctByCondition(j,5)+x1;
                if tempFreqData.dayMetCutOffCriterion(i)
                    tempFreqData.trialNumsByConditionWCO{j,5} = [tempFreqData.trialNumsByConditionWCO{j,5} makerow(tempFreqData.trialNumByDate{i}(whichCurrContrast))];
                    tempFreqData.numTrialsByConditionWCO(j,5) = tempFreqData.numTrialsByConditionWCO(j,5)+n1;
                    tempFreqData.correctByConditionWCO(j,5) = tempFreqData.correctByConditionWCO(j,5)+x1;
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(tempFreqData.tempfreqs)
    [phat,pci] = binofit(tempFreqData.correctByCondition(j,:),tempFreqData.numTrialsByCondition(j,:));
    tempFreqData.performanceByCondition(j,1,:) = phat;
    tempFreqData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([tempFreqData.correctByConditionWCO(j,:)],[tempFreqData.numTrialsByConditionWCO(j,:)]);
    tempFreqData.performanceByConditionWCO(j,1,:) = phat;
    tempFreqData.performanceByConditionWCO(j,2:3,:) = pci';
end



if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::CONTRAST',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(tempFreqData.dates-min(tempFreqData.dates)+1,tempFreqData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'                   
                    conditionColor = {'b','r','b','r','k'};
                    for i = 1:size(tempFreqData.performanceByConditionWCO,3)
                        if isfield(plotDetails,'plotMeansOnly') && plotDetails.plotMeansOnly
                            means = tempFreqData.performanceByConditionWCO(:,1,i);
                            which = ~isnan(tempFreqData.performanceByConditionWCO(:,1,i));
                            plot(tempFreqData.tempfreqs(which),means(which),'color',conditionColor{i})
                        else
                            for k = 1:size(tempFreqData.performanceByConditionWCO,3)
                                for j = 1:size(tempFreqData.performanceByConditionWCO,1)
                                    if ~isnan(tempFreqData.performanceByConditionWCO(j,1,k))
                                        plot(tempFreqData.tempfreqs(j),tempFreqData.performanceByConditionWCO(j,1,k),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{k},'MarkerEdgeColor','none');
                                        plot([tempFreqData.tempfreqs(j) tempFreqData.tempfreqs(j)],[tempFreqData.performanceByConditionWCO(j,2,k) tempFreqData.performanceByConditionWCO(j,3,k)],'color',conditionColor{k},'linewidth',5);
                                    end
                                end
                            end
                        end
                    end
                    
                    set(gca,'ylim',[0.2 1.1],'xlim',[-1 20],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
                    xlabel('spatFreq','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
                    
                case 'performanceByDay'
                    plot([0 max(tempFreqData.dates)-min(tempFreqData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(tempFreqData.dates)-min(tempFreqData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(tempFreqData.dates)
                        if ~isnan(tempFreqData.dayMetCutOffCriterion(i))
                            if tempFreqData.dayMetCutOffCriterion(i)
                                xloc = tempFreqData.dates(i)-min(tempFreqData.dates)+1;
                                plot(xloc,tempFreqData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],tempFreqData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = tempFreqData.dates(i)-min(tempFreqData.dates)+1;
                                plot(xloc,tempFreqData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],tempFreqData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = tempFreqData.dates(i)-min(tempFreqData.dates)+1;
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
            bar(tempFreqData.dates-min(tempFreqData.dates)+1,tempFreqData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performance by day
            ax2 = subplot(3,2,2); hold on;
            plot([0 max(tempFreqData.dates)-min(tempFreqData.dates)+1],[0.5 0.5],'k');
            plot([0 max(tempFreqData.dates)-min(tempFreqData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(tempFreqData.dates)
                if ~isnan(tempFreqData.dayMetCutOffCriterion(i))
                    if tempFreqData.dayMetCutOffCriterion(i)
                        xloc = tempFreqData.dates(i)-min(tempFreqData.dates)+1;
                        plot(xloc,tempFreqData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],tempFreqData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = tempFreqData.dates(i)-min(tempFreqData.dates)+1;
                        plot(xloc,tempFreqData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],tempFreqData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = tempFreqData.dates(i)-min(tempFreqData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax2,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performance by condition
            ax3 = subplot(3,2,3:6); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(tempFreqData.performanceByConditionWCO,3)
                for j = 1:size(tempFreqData.performanceByConditionWCO,1)
                    if ~isnan(tempFreqData.performanceByConditionWCO(j,1,i))
                        plot(tempFreqData.tempfreqs(j),tempFreqData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([tempFreqData.tempfreqs(j) tempFreqData.tempfreqs(j)],[tempFreqData.performanceByConditionWCO(j,2,i) tempFreqData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax3,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('tempfreq','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
    end
end