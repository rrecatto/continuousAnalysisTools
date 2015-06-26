function imageData = analyzeImagesContrastTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion)

if islogical(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
    plotDetails.forStudy = 'none';
end


im = filterBehaviorData(data,'tsName','GotoObject_VarC_nAFC_images');
imageData.trialNum = im.compiledTrialRecords.trialNumber;
imageData.correct = im.compiledTrialRecords.correct;
imageData.correction = im.compiledTrialRecords.correctionTrial;
imageData.responseTime = [im.compiledTrialRecords.responseTime];
% lets find the contrast. this is a little cumbersone but we can work
% through this

imForTrialsLR = [im.compiledDetails(1).records.leftIm;im.compiledDetails(1).records.rightIm];
imForTrials = nan(1,size(imForTrialsLR,2));
whichIsBlank = find(~cellfun(@isempty,strfind(im.compiledLUT,'blank')));
imForTrials = im.compiledLUT(sum(imForTrialsLR.*double(~ismember(imForTrialsLR,whichIsBlank))));
warning('making assumptions about the nature of the string');
[matches tokens] = regexp(imForTrials,'\w_C(\d+)','tokens','match');
contrasts = cellfun(@(x) x{1},matches);

imageData.contrast = cellfun(@str2double,contrasts);
imageData.contrasts = unique(imageData.contrast);
numContrasts = length(imageData.contrasts);

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
imageData.trialNumsByCondition = cell(numContrasts,5);
imageData.numTrialsByCondition = zeros(numContrasts,5);
imageData.correctByCondition = zeros(numContrasts,5);
imageData.performanceByCondition = nan(numContrasts,3,5);
imageData.responseTimesByCondition = cell(length(imageData.contrasts),5);
imageData.responseTimesForCorrectByCondition = cell(length(imageData.contrasts),5);

%performance by condition with trial number cutoff
imageData.trialNumsByConditionWCO = cell(numContrasts,5);
imageData.numTrialsByConditionWCO = zeros(numContrasts,5);
imageData.correctByConditionWCO = zeros(numContrasts,5);
imageData.performanceByConditionWCO = nan(numContrasts,3,5);
imageData.responseTimesByConditionWCO = cell(length(imageData.contrasts),5);
imageData.responseTimesForCorrectByConditionWCO = cell(length(imageData.contrasts),5);

for i = 1:length(imageData.dates)
    if ismember(imageData.dates(i),filters.imFilter)
        dateFilter = imageData.date==imageData.dates(i);
        correctThatDate = imageData.correct(dateFilter);
        correctionThatDate = imageData.correction(dateFilter);
        contrastThatDate = imageData.contrast(dateFilter);
        responseTimeThatDate = imageData.responseTime(dateFilter);
        
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate & responseTimeThatDate<5;
        correctThatDate = correctThatDate(whichGood);
        contrastThatDate = contrastThatDate(whichGood);
        responseTimeThatDate = responseTimeThatDate(whichGood);
        
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
            for j = 1:length(imageData.contrasts)
                whichCurrContrast = contrastThatDate==imageData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                imageData.trialNumsByCondition{j,1} = [imageData.trialNumsByCondition{j,1} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                imageData.numTrialsByCondition(j,1) = imageData.numTrialsByCondition(j,1)+n1;
                imageData.correctByCondition(j,1) = imageData.correctByCondition(j,1)+x1;
                imageData.responseTimesByCondition{j,1} = [imageData.responseTimesByCondition{j,1} makerow(currResponseTimes)];
                imageData.responseTimesForCorrectByCondition{j,1} = [imageData.responseTimesForCorrectByCondition{j,1} makerow(currCorrectResponseTimes)];

                if imageData.dayMetCutOffCriterion(i)
                    imageData.trialNumsByConditionWCO{j,1} = [imageData.trialNumsByCondition{j,1} makerow(imageData.trialNumByDate{i})];
                    imageData.numTrialsByConditionWCO(j,1) = imageData.numTrialsByConditionWCO(j,1)+n1;
                    imageData.correctByConditionWCO(j,1) = imageData.correctByConditionWCO(j,1)+x1;
                    imageData.responseTimesByConditionWCO{j,1} = [imageData.responseTimesByConditionWCO{j,1} makerow(currResponseTimes)];
                    imageData.responseTimesForCorrectByConditionWCO{j,1} = [imageData.responseTimesForCorrectByConditionWCO{j,1} makerow(currCorrectResponseTimes)];
                end
            end
        elseif imageData.conditionNum(i) == 2
            for j = 1:length(imageData.contrasts)
                whichCurrContrast = contrastThatDate==imageData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                imageData.trialNumsByCondition{j,2} = [imageData.trialNumsByCondition{j,2} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                imageData.numTrialsByCondition(j,2) = imageData.numTrialsByCondition(j,2)+n1;
                imageData.correctByCondition(j,2) = imageData.correctByCondition(j,2)+x1;
                imageData.responseTimesByCondition{j,2} = [imageData.responseTimesByCondition{j,2} makerow(currResponseTimes)];
                imageData.responseTimesForCorrectByCondition{j,2} = [imageData.responseTimesForCorrectByCondition{j,2} makerow(currCorrectResponseTimes)];

                if imageData.dayMetCutOffCriterion(i)
                    imageData.trialNumsByConditionWCO{j,2} = [imageData.trialNumsByCondition{j,2} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                    imageData.numTrialsByConditionWCO(j,2) = imageData.numTrialsByConditionWCO(j,2)+n1;
                    imageData.correctByConditionWCO(j,2) = imageData.correctByConditionWCO(j,2)+x1;
                    imageData.responseTimesByConditionWCO{j,2} = [imageData.responseTimesByConditionWCO{j,2} makerow(currResponseTimes)];
                    imageData.responseTimesForCorrectByConditionWCO{j,2} = [imageData.responseTimesForCorrectByConditionWCO{j,2} makerow(currCorrectResponseTimes)];
                end
            end
        elseif imageData.conditionNum(i) == 3
            for j = 1:length(imageData.contrasts)
                whichCurrContrast = contrastThatDate==imageData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                imageData.trialNumsByCondition{j,3} = [imageData.trialNumsByCondition{j,3} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                imageData.numTrialsByCondition(j,3) = imageData.numTrialsByCondition(j,3)+n1;
                imageData.correctByCondition(j,3) = imageData.correctByCondition(j,3)+x1;
                imageData.responseTimesByCondition{j,3} = [imageData.responseTimesByCondition{j,3} makerow(currResponseTimes)];
                imageData.responseTimesForCorrectByCondition{j,3} = [imageData.responseTimesForCorrectByCondition{j,3} makerow(currCorrectResponseTimes)];

                if imageData.dayMetCutOffCriterion(i)
                    imageData.trialNumsByConditionWCO{j,3} = [imageData.trialNumsByCondition{j,3} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                    imageData.numTrialsByConditionWCO(j,3) = imageData.numTrialsByConditionWCO(j,3)+n1;
                    imageData.correctByConditionWCO(j,3) = imageData.correctByConditionWCO(j,3)+x1;
                    imageData.responseTimesByConditionWCO{j,3} = [imageData.responseTimesByConditionWCO{j,3} makerow(currResponseTimes)];
                    imageData.responseTimesForCorrectByConditionWCO{j,3} = [imageData.responseTimesForCorrectByConditionWCO{j,3} makerow(currCorrectResponseTimes)];
                end
            end
        elseif imageData.conditionNum(i) == 4
            for j = 1:length(imageData.contrasts)
                whichCurrContrast = contrastThatDate==imageData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                imageData.trialNumsByCondition{j,4} = [imageData.trialNumsByCondition{j,4} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                imageData.numTrialsByCondition(j,4) = imageData.numTrialsByCondition(j,4)+n1;
                imageData.correctByCondition(j,4) = imageData.correctByCondition(j,4)+x1;
                imageData.responseTimesByCondition{j,4} = [imageData.responseTimesByCondition{j,4} makerow(currResponseTimes)];
                imageData.responseTimesForCorrectByCondition{j,4} = [imageData.responseTimesForCorrectByCondition{j,4} makerow(currCorrectResponseTimes)];

                if imageData.dayMetCutOffCriterion(i)
                    imageData.trialNumsByConditionWCO{j,4} = [imageData.trialNumsByCondition{j,4} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                    imageData.numTrialsByConditionWCO(j,4) = imageData.numTrialsByConditionWCO(j,4)+n1;
                    imageData.correctByConditionWCO(j,4) = imageData.correctByConditionWCO(j,4)+x1;
                    imageData.responseTimesByConditionWCO{j,4} = [imageData.responseTimesByConditionWCO{j,4} makerow(currResponseTimes)];
                    imageData.responseTimesForCorrectByConditionWCO{j,4} = [imageData.responseTimesForCorrectByConditionWCO{j,4} makerow(currCorrectResponseTimes)];
                end
            end
        elseif imageData.conditionNum(i) == 5
            for j = 1:length(imageData.contrasts)
                whichCurrContrast = contrastThatDate==imageData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                currResponseTimes = responseTimeThatDate(whichCurrContrast);
                currCorrectResponseTimes = currResponseTimes(logical(currContrastCorrect));
                
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                imageData.trialNumsByCondition{j,5} = [imageData.trialNumsByCondition{j,5} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                imageData.numTrialsByCondition(j,5) = imageData.numTrialsByCondition(j,5)+n1;
                imageData.correctByCondition(j,5) = imageData.correctByCondition(j,5)+x1;
                imageData.responseTimesByCondition{j,5} = [imageData.responseTimesByCondition{j,5} makerow(currResponseTimes)];
                imageData.responseTimesForCorrectByCondition{j,5} = [imageData.responseTimesForCorrectByCondition{j,5} makerow(currCorrectResponseTimes)];

                if imageData.dayMetCutOffCriterion(i)
                    imageData.trialNumsByConditionWCO{j,5} = [imageData.trialNumsByCondition{j,5} makerow(imageData.trialNumByDate{i}(whichCurrContrast))];
                    imageData.numTrialsByConditionWCO(j,5) = imageData.numTrialsByConditionWCO(j,5)+n1;
                    imageData.correctByConditionWCO(j,5) = imageData.correctByConditionWCO(j,5)+x1;
                    imageData.responseTimesByConditionWCO{j,5} = [imageData.responseTimesByConditionWCO{j,5} makerow(currResponseTimes)];
                    imageData.responseTimesForCorrectByConditionWCO{j,5} = [imageData.responseTimesForCorrectByConditionWCO{j,5} makerow(currCorrectResponseTimes)];
                end
            end
        else
            error('unknown condition');
        end
        
        
    end
end


for j = 1:length(imageData.contrasts)
    [phat,pci] = binofit(imageData.correctByCondition(j,:),imageData.numTrialsByCondition(j,:));
    imageData.performanceByCondition(j,1,:) = phat;
    imageData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([imageData.correctByConditionWCO(j,:)],[imageData.numTrialsByConditionWCO(j,:)]);
    imageData.performanceByConditionWCO(j,1,:) = phat;
    imageData.performanceByConditionWCO(j,2:3,:) = pci';
end




if plotDetails.plotOn
    switch plotDetails.plotWhere
        case 'givenAxes'
            axes(plotDetails.axHan); hold on;
            title(sprintf('%s::OPTIMAL',mouseID));
            switch plotDetails.requestedPlot
                case 'trialsByDay'
                    bar(imageData.dates-min(imageData.dates)+1,imageData.numTrialsByDate);
                    xlabel('num days','FontName','Times New Roman','FontSize',12);
                    ylabel('num trials','FontName','Times New Roman','FontSize',12);
                    
                case 'performanceByCondition'
                    conditionColor = {'b','r','b','r','k'};
                    for i = 1:size(imageData.performanceByConditionWCO,3)
                        if isfield(plotDetails,'plotMeansOnly') && plotDetails.plotMeansOnly
                            means = imageData.performanceByConditionWCO(:,1,i);
                            which = ~isnan(imageData.performanceByConditionWCO(:,1,i));
                            plot(imageData.contrasts(which),means(which),'color',conditionColor{i})
                        else
                            for j = 1:size(imageData.performanceByConditionWCO,1)
                                if ~isnan(imageData.performanceByConditionWCO(j,1,i))
                                    plot(imageData.contrasts(j)/100,imageData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                                    plot([imageData.contrasts(j)/100 imageData.contrasts(j)/100],[imageData.performanceByConditionWCO(j,2,i) imageData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
                                end
                            end
                            ctrs = imageData.contrasts
                            phats = imageData.performanceByConditionWCO(:,1,i)
                            pcibot = imageData.performanceByConditionWCO(:,2,i)
                            pcitop = imageData.performanceByConditionWCO(:,3,i)
                        end
                    end
                    set(gca,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
                    xlabel('contrast','FontName','Times New Roman','FontSize',12);
                    ylabel('performance','FontName','Times New Roman','FontSize',12);
                    
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
                    
                case 'responseTime'
                    keyboard
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