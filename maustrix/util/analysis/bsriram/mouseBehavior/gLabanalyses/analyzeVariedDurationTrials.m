function varDurData = analyzeVariedDurationTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

vardur = filterBehaviorData(data,'tsName','orDUR_LowDur_Sweep');%% orDUR_LowDur_Sweep,orDURSweep
varDurData.trialNum = [vardur.compiledTrialRecords.trialNumber];
varDurData.correct = [vardur.compiledTrialRecords.correct];
varDurData.correction = [vardur.compiledTrialRecords.correctionTrial];
varDurData.responseTime = [vardur.compiledTrialRecords.responseTime];
whichDetailFileNum = find(strcmp({vardur.compiledDetails.className},'afcGratings'));
varDurData.contrast = [vardur.compiledDetails(whichDetailFileNum).records.contrasts];
varDurData.maxDuration = [vardur.compiledDetails(whichDetailFileNum).records.maxDuration] /60; % assume 60Hz! may not be true - capture the ifi hereon in
varDurData.time = [vardur.compiledTrialRecords.date];
varDurData.date = floor(varDurData.time);
varDurData.dates = unique(varDurData.date);
varDurData.contrasts = unique(varDurData.contrast);
varDurData.maxDurations = unique(varDurData.maxDuration);

% performance on a day by day basis
varDurData.trialNumByDate = cell(1,length(varDurData.dates));
varDurData.numTrialsByDate = nan(1,length(varDurData.dates));
varDurData.performanceByDate = nan(3,length(varDurData.dates));
varDurData.colorByCondition = cell(1,length(varDurData.dates));
varDurData.conditionNum = nan(1,length(varDurData.dates));
varDurData.dayMetCutOffCriterion = nan(1,length(varDurData.dates));

%performance by condition
varDurData.trialNumsByCondition = cell(length(varDurData.maxDurations),length(varDurData.contrasts),5);
varDurData.numTrialsByCondition = zeros(length(varDurData.maxDurations),length(varDurData.contrasts),5);
varDurData.correctByCondition = zeros(length(varDurData.maxDurations),length(varDurData.contrasts),5);
varDurData.performanceByCondition = nan(length(varDurData.maxDurations),length(varDurData.contrasts),3,5);
varDurData.responseTimesByCondition = cell(length(varDurData.maxDurations),length(varDurData.contrasts),5);
varDurData.responseTimesForCorrectByCondition = cell(length(varDurData.maxDurations),length(varDurData.contrasts),5);

%performance by condition with trial number cutoff
varDurData.trialNumsByConditionWCO = cell(length(varDurData.maxDurations),length(varDurData.contrasts),5);
varDurData.numTrialsByConditionWCO = zeros(length(varDurData.maxDurations),length(varDurData.contrasts),5);
varDurData.correctByConditionWCO = zeros(length(varDurData.maxDurations),length(varDurData.contrasts),5);
varDurData.performanceByConditionWCO = nan(length(varDurData.maxDurations),length(varDurData.contrasts),3,5);
varDurData.responseTimesByConditionWCO = cell(length(varDurData.maxDurations),length(varDurData.contrasts),5);
varDurData.responseTimesForCorrectByConditionWCO = cell(length(varDurData.maxDurations),length(varDurData.contrasts),5);

for i = 1:length(varDurData.dates)
    if ismember(varDurData.dates(i),filters.ctrFilter)
        dateFilter = varDurData.date==varDurData.dates(i);
        correctThatDate = varDurData.correct(dateFilter);
        correctionThatDate = varDurData.correction(dateFilter);
        contrastThatDate = varDurData.contrast(dateFilter);
        durationThatDate = varDurData.maxDuration(dateFilter);
        responseTimeThatDate = varDurData.responseTime(dateFilter);

        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate & responseTimeThatDate<5;
        correctThatDate = correctThatDate(whichGood);
        contrastThatDate = contrastThatDate(whichGood);
        durationThatDate = durationThatDate(whichGood);
        responseTimeThatDate = responseTimeThatDate(whichGood);
        
        varDurData.trialNumByDate{i} = varDurData.trialNum(dateFilter);
        varDurData.trialNumByDate{i} = varDurData.trialNumByDate{i}(whichGood);
        varDurData.numTrialsByDate(i) = length(varDurData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        varDurData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        varDurData.performanceByDate(1,i) = phat;
        varDurData.performanceByDate(2,i) = pci(1);
        varDurData.performanceByDate(3,i) = pci(2);
        
        if ismember(varDurData.dates(i),daysPBS)
            varDurData.colorByCondition{i} = 'b';
            varDurData.conditionNum(i) = 1;
        elseif ismember(varDurData.dates(i),daysCNO)
            varDurData.colorByCondition{i} = 'r';
            varDurData.conditionNum(i) = 2;
        elseif ismember(varDurData.dates(i),daysIntact)
            varDurData.colorByCondition{i} = 'b';
            varDurData.conditionNum(i) = 3;
        elseif ismember(varDurData.dates(i),daysLesion)
            varDurData.colorByCondition{i} = 'r';
            varDurData.conditionNum(i) = 4;
        else
            varDurData.colorByCondition{i} = 'k';
            varDurData.conditionNum(i) = 5;
        end
        
        for k = 1:length(varDurData.maxDurations)
            for j = 1:length(varDurData.contrasts)
                whichCurrDurationAndContrast = contrastThatDate==varDurData.contrasts(j) & durationThatDate==varDurData.maxDurations(k);
                currDurationAndContrastCorrect = correctThatDate(whichCurrDurationAndContrast);
                currResponseTimes = responseTimeThatDate(whichCurrDurationAndContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currDurationAndContrastCorrect));
                x1 = sum(currDurationAndContrastCorrect);
                n1 = length(currDurationAndContrastCorrect);
                varDurData.trialNumsByCondition{k,j,varDurData.conditionNum(i)} = [varDurData.trialNumsByCondition{k,j,varDurData.conditionNum(i)} makerow(varDurData.trialNumByDate{i}(whichCurrDurationAndContrast))];
                varDurData.numTrialsByCondition(k,j,varDurData.conditionNum(i)) = varDurData.numTrialsByCondition(k,j,varDurData.conditionNum(i))+n1;
                varDurData.correctByCondition(k,j,varDurData.conditionNum(i)) = varDurData.correctByCondition(k,j,varDurData.conditionNum(i))+x1;
                varDurData.responseTimesByCondition{k,j,varDurData.conditionNum(i)} = [varDurData.responseTimesByCondition{k,j,varDurData.conditionNum(i)} makerow(currResponseTimes)];
                varDurData.responseTimesForCorrectByCondition{k,j,varDurData.conditionNum(i)} = [varDurData.responseTimesForCorrectByCondition{k,j,varDurData.conditionNum(i)} makerow(currCorrectResponseTimes)];
                
                if varDurData.dayMetCutOffCriterion(i)
                    varDurData.trialNumsByConditionWCO{k,j,varDurData.conditionNum(i)} = [varDurData.trialNumsByConditionWCO{k,j,varDurData.conditionNum(i)} makerow(varDurData.trialNumByDate{i}(whichCurrDurationAndContrast))];
                    varDurData.numTrialsByConditionWCO(k,j,varDurData.conditionNum(i)) = varDurData.numTrialsByConditionWCO(k,j,varDurData.conditionNum(i))+n1;
                    varDurData.correctByConditionWCO(k,j,varDurData.conditionNum(i)) = varDurData.correctByConditionWCO(k,j,varDurData.conditionNum(i))+x1;
                    varDurData.responseTimesByConditionWCO{k,j,varDurData.conditionNum(i)} = [varDurData.responseTimesByConditionWCO{k,j,varDurData.conditionNum(i)} makerow(currResponseTimes)];
                    varDurData.responseTimesForCorrectByConditionWCO{k,j,varDurData.conditionNum(i)} = [varDurData.responseTimesForCorrectByConditionWCO{k,j,varDurData.conditionNum(i)} makerow(currCorrectResponseTimes)];
                end
            end
        end
        
    end
end

for k = 1:length(varDurData.maxDurations)
    for j = 1:length(varDurData.contrasts)
        [phat,pci] = binofit(varDurData.correctByCondition(k,j,:),varDurData.numTrialsByCondition(k,j,:));
        varDurData.performanceByCondition(k,j,1,:) = phat;
        varDurData.performanceByCondition(k,j,2:3,:) = pci';
        
        [phat,pci] = binofit([varDurData.correctByConditionWCO(k,j,:)],[varDurData.numTrialsByConditionWCO(k,j,:)]);
        varDurData.performanceByConditionWCO(k,j,1,:) = phat;
        varDurData.performanceByConditionWCO(k,j,2:3,:) = pci';
    end
end


if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::CONTRAST',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(varDurData.dates-min(varDurData.dates)+1,varDurData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'
                    conditionColor = {'b','r','b','r','g'};
                    % now performance is a 4D vector (durationsXcontrastsX[phat pcilow pcihi]Xcondition)
                    % separate by condition
                    for i = 1:size(varDurData.performanceByConditionWCO,4)
                        % now separate by contrast
                        for k = 1:size(varDurData.performanceByConditionWCO,2)
                            if isfield(plotDetails,'plotMeansOnly') && plotDetails.plotMeansOnly
                                means = varDurData.performanceByConditionWCO(:,k,1,i);
                                which = ~isnan(varDurData.performanceByConditionWCO(:,k,1,i));
                                
                                if ~isempty(varDurData.maxDurations(which))
                                    h = plot(log10(varDurData.maxDurations(which)),means(which),'color',conditionColor{i},'linewidth',3*varDurData.contrasts(k)+0.88);
                                    try
                                        brightVal = log10(varDurData.contrasts(k)/0.5);
                                        brightVal = min(brightVal,0.99);
                                        brightVal = max(brightVal,-0.99);
                                        brighten(gca,brightVal)
                                    catch
                                        brighten(h,-0.99); % for when contrast is 0
                                    end
                                    
                                end
                                
                            else
                                for j = 1:size(varDurData.performanceByConditionWCO,1)
                                    if ~isnan(varDurData.performanceByConditionWCO(j,k,1,i))
                                        h1 = plot(log10(varDurData.maxDurations(j)),varDurData.performanceByConditionWCO(j,k,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                                        h2 = plot([log10(varDurData.maxDurations(j)) log10(varDurData.maxDurations(j))],[varDurData.performanceByConditionWCO(j,k,2,i) varDurData.performanceByConditionWCO(j,k,3,i)],'color',conditionColor{i},'linewidth',5);
                                        try
                                            brightVal = log(varDurData.contrasts(k)/0.5);
                                            brightVal = min(brightVal,0.99);
                                            brightVal = max(brightVal,-0.99);
                                            brighten(h1,brightVal);
                                            brighten(h2,brightVal)
                                        catch
                                            brighten(h1,-0.99); % for when contrast is 0
                                            brighten(h2,-0.99);
                                        end
%                                         keyboard
                                    end
                                end
                            end
                        end
                    end
                    xlabels = cell(1,length(varDurData.maxDurations));
                    for i = 1:length(varDurData.maxDurations)
                        xlabels{i} = sprintf('%2.2f',varDurData.maxDurations(i));
                    end
                    set(gca,'ylim',[0.2 1.1],...
                        'xlim',[log10(min(varDurData.maxDurations))-0.05 log10(max(varDurData.maxDurations))+0.05],...
                        'xtick',log10([0.0166666666666667 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2 0.3 0.4 0.5]),...'xticklabel',xlabels,...
                        'ytick',[0.2 0.5 1],...
                        'FontName','Times New Roman',...
                        'FontSize',12);
                    plot([log10(min(varDurData.maxDurations))-0.05 log10(max(varDurData.maxDurations))+0.05],[0.5 0.5],'k-');
                    plot([log10(min(varDurData.maxDurations))-0.05 log10(max(varDurData.maxDurations))+0.05],[0.7 0.7],'k--');
                    xlabel('maxDurations','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByDay'
                    plot([0 max(varDurData.dates)-min(varDurData.dates)+1],[0.5 0.5],'k');
                    plot([0 max(varDurData.dates)-min(varDurData.dates)+1],[0.7 0.7],'k--');
                    for i = 1:length(varDurData.dates)
                        if ~isnan(varDurData.dayMetCutOffCriterion(i))
                            if varDurData.dayMetCutOffCriterion(i)
                                xloc = varDurData.dates(i)-min(varDurData.dates)+1;
                                plot(xloc,varDurData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                                plot([xloc xloc],varDurData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                            else
                                xloc = varDurData.dates(i)-min(varDurData.dates)+1;
                                plot(xloc,varDurData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                                plot([xloc xloc],varDurData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                            end
                        else
                            xloc = varDurData.dates(i)-min(varDurData.dates)+1;
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
            bar(varDurData.dates-min(varDurData.dates)+1,varDurData.numTrialsByDate);
            xlabel('num days','FontName','Times New Roman','FontSize',12);
            ylabel('num trials','FontName','Times New Roman','FontSize',12);
            
            % performance by day
            ax2 = subplot(3,2,2); hold on;
            plot([0 max(varDurData.dates)-min(varDurData.dates)+1],[0.5 0.5],'k');
            plot([0 max(varDurData.dates)-min(varDurData.dates)+1],[0.7 0.7],'k--');
            for i = 1:length(varDurData.dates)
                if ~isnan(varDurData.dayMetCutOffCriterion(i))
                    if varDurData.dayMetCutOffCriterion(i)
                        xloc = varDurData.dates(i)-min(varDurData.dates)+1;
                        plot(xloc,varDurData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                        plot([xloc xloc],varDurData.performanceByDate(2:3,i),'color','k','LineWidth',2);
                    else
                        xloc = varDurData.dates(i)-min(varDurData.dates)+1;
                        plot(xloc,varDurData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                        plot([xloc xloc],varDurData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
                    end
                else
                    xloc = varDurData.dates(i)-min(varDurData.dates)+1;
                    plot(xloc,0.5,'Marker','x','color','k');
                end
            end
            set(ax2,'ylim',[0.2 1]);
            xlabel('day num','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
            
            % performance by condition
            ax3 = subplot(3,2,3:4); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(varDurData.performanceByConditionWCO,3)
                for j = 1:size(varDurData.performanceByConditionWCO,1)
                    if ~isnan(varDurData.performanceByConditionWCO(j,1,i))
                        plot(varDurData.contrasts(j),varDurData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([varDurData.contrasts(j) varDurData.contrasts(j)],[varDurData.performanceByConditionWCO(j,2,i) varDurData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax3,'ylim',[0.2 1.1],'xlim',[-0.05 1.05],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('contrast','FontName','Times New Roman','FontSize',12);
            ylabel('performance','FontName','Times New Roman','FontSize',12);
                        
            % response times
            ax4 = subplot(3,2,5); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(varDurData.responseTimesByConditionWCO,2)
                for j = 1:size(varDurData.responseTimesByConditionWCO,1)
                    if ~(isempty(varDurData.responseTimesByConditionWCO{j,i}))
                        m = mean(varDurData.responseTimesByConditionWCO{j,i});
                        sem = std(varDurData.responseTimesByConditionWCO{j,i})/sqrt(length(varDurData.responseTimesByConditionWCO{j,i}));
                        plot(varDurData.contrasts(j),m,'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([varDurData.contrasts(j) varDurData.contrasts(j)],[m-sem m+sem],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax4,'ylim',[0 3],'xlim',[-0.05 1.05],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0 1 2 3],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('contrast','FontName','Times New Roman','FontSize',12);
            ylabel('responseTime','FontName','Times New Roman','FontSize',12);
            
            % response times for correct
            ax5 = subplot(3,2,6); hold on;
            conditionColor = {'b','r','b','r','k'};
            for i = 1:size(varDurData.responseTimesForCorrectByConditionWCO,2)
                for j = 1:size(varDurData.responseTimesForCorrectByConditionWCO,1)
                    if ~(isempty(varDurData.responseTimesForCorrectByConditionWCO{j,i}))
                        m = mean(varDurData.responseTimesForCorrectByConditionWCO{j,i});
                        sem = std(varDurData.responseTimesForCorrectByConditionWCO{j,i})/sqrt(length(varDurData.responseTimesForCorrectByConditionWCO{j,i}));
                        plot(varDurData.contrasts(j),m,'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                        plot([varDurData.contrasts(j) varDurData.contrasts(j)],[m-sem m+sem],'color',conditionColor{i},'linewidth',5);
                    end
                end
            end
            set(ax5,'ylim',[0 3],'xlim',[-0.05 1.05],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0 1 2 3],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
            xlabel('contrast','FontName','Times New Roman','FontSize',12);
            ylabel('responseTimeForCorrect','FontName','Times New Roman','FontSize',12);
    end
end