function out = mouse10(filters,plotOn,trialNumCutoff)
out = [];
if ~exist('plotOn','var')||isempty(plotOn)
    plotOn = true;
end
if ~exist('trialNumCutoff','var')||isempty(trialNumCutoff)
    trialNumCutoff = 50;
end

if ~exist('filters','var') || isempty(filters)
    % all data is allowed
    filters.fdFilter = 1:today;
    filters.imFilter = 1:today;
    filters.optFilter = 1:today;
    filters.ctrFilter = 1:today;
    filters.sfFilter = 1:today
end
mouseID = '10';
daysPBS = {
'10/3/2012',... sf
'10/5/2012',...
'10/8/2012',...
'10/10/2012',...
...
'10/19/2012',... or
'10/23/2012',...
'10/25/2012',...
'10/26/2012',...
...
'10/29/2012',... vc
'10/31/2012',...
'11/2/2012',...
'11/6/2012',...
'11/8/2012',...
'11/10/2012',...
...
};
daysCNO = {
'10/2/2012',... sf
'10/4/2012',...
'10/9/2012',...
'10/11/2012',...
...
'10/18/2012',... or
'10/22/2012',...
'10/24/2012',...
'10/27/2012',...
...
'10/30/2012',... vc
'11/1/2012',...
'11/3/2012',...
'11/5/2012',...
'11/7/2012',...
'11/9/2012',...
...
};

daysIntact = {};
daysLesion = {};

location1 = 'C:\Users\ephys-data\Desktop\Compiled\Box1\10.compiledTrialRecords.1-18499.mat'; % orOptimal_nAFC,orORSweep,orCTRSweep,orSFSweep

data1 = load(location1);

%% FREEDRINKS
% get the fd part
fd1 = filterBehaviorData(data1,'tsName','freeDrinks');

%% IMAGES
im = filterBehaviorData(data1,'tsName','nAFC_images');%2 trials OLD images is missing????
imageData.trialNum = im.compiledTrialRecords.trialNumber;
imageData.correct = im.compiledTrialRecords.correct;
imageData.correction = im.compiledTrialRecords.correctionTrial;
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

if plotOn
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
out.imageData = imageData;

%% +/- 45 GRATINGS
opt1 = filterBehaviorData(data1,'tsName','orOptimal_nAFC');%9282 trials
trialNumMax1 = data1.compiledTrialRecords.trialNumber(end);
optData.trialNum = [opt1.compiledTrialRecords.trialNumber];
optData.correct = [opt1.compiledTrialRecords.correct];
optData.correction = [opt1.compiledTrialRecords.correctionTrial];
optData.time = [opt1.compiledTrialRecords.date];
optData.responseTime = [opt1.compiledTrialRecords.responseTime];
optData.date = floor(optData.time);
optData.dates = unique(optData.date);

% performance on a day by day basis
optData.trialNumByDate = cell(1,length(optData.dates));
optData.numTrialsByDate = nan(1,length(optData.dates));
optData.performanceByDate = nan(3,length(optData.dates));
optData.responseTimeByDate = cell(1,length(optData.dates));
optData.colorByCondition = cell(1,length(optData.dates));
optData.conditionNum = nan(1,length(optData.dates));
optData.dayMetCutOffCriterion = nan(1,length(optData.dates));

%performance by condition
optData.trialNumsByCondition = {[],[],[],[],[]};
optData.numTrialsByCondition = {0,0,0,0,0};
optData.correctByCondition = {0,0,0,0,0};
optData.performanceByCondition = nan(3,5);

%performance by condition with trial number cutoff
optData.trialNumsByConditionWCO = {[],[],[],[],[]};
optData.numTrialsByConditionWCO = {0,0,0,0,0};
optData.correctByConditionWCO = {0,0,0,0,0};
optData.performanceByConditionWCO = nan(3,5);

for i = 1:length(optData.dates)
    if ismember(optData.dates(i),filters.optFilter)
        dateFilter = optData.date==optData.dates(i);
        correctThatDate = optData.correct(dateFilter);
        correctionThatDate = optData.correction(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
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
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{1} = [optData.trialNumsByCondition{1} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{1} = optData.numTrialsByCondition{1}+n;
                optData.correctByConditionWCO{1} = optData.correctByCondition{1}+x;
            end
        elseif optData.conditionNum(i) == 2
            optData.trialNumsByCondition{2} = [optData.trialNumsByCondition{2} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{2} = optData.numTrialsByCondition{2}+n;
            optData.correctByCondition{2} = optData.correctByCondition{2}+x;
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{2} = [optData.trialNumsByConditionWCO{2} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{2} = optData.numTrialsByConditionWCO{2}+n;
                optData.correctByConditionWCO{2} = optData.correctByConditionWCO{2}+x;
            end
        elseif optData.conditionNum(i) == 3
            optData.trialNumsByCondition{3} = [optData.trialNumsByCondition{3} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{3} = optData.numTrialsByCondition{3}+n;
            optData.correctByCondition{3} = optData.correctByCondition{3}+x;
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{3} = [optData.trialNumsByConditionWCO{3} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{3} = optData.numTrialsByConditionWCO{3}+n;
                optData.correctByConditionWCO{3} = optData.correctByConditionWCO{3}+x;
            end
        elseif optData.conditionNum(i) == 4
            optData.trialNumsByCondition{4} = [optData.trialNumsByCondition{4} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{4} = optData.numTrialsByCondition{4}+n;
            optData.correctByCondition{4} = optData.correctByCondition{4}+x;
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{4} = [optData.trialNumsByConditionWCO{4} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{4} = optData.numTrialsByConditionWCO{4}+n;
                optData.correctByConditionWCO{4} = optData.correctByConditionWCO{4}+x;
            end
        elseif optData.conditionNum(i) == 5
            optData.trialNumsByCondition{5} = [optData.trialNumsByCondition{5} makerow(optData.trialNumByDate{i})];
            optData.numTrialsByCondition{5} = optData.numTrialsByCondition{5}+n;
            optData.correctByCondition{5} = optData.correctByCondition{5}+x;
            if optData.dayMetCutOffCriterion(i)
                optData.trialNumsByConditionWCO{5} = [optData.trialNumsByConditionWCO{5} makerow(optData.trialNumByDate{i})];
                optData.numTrialsByConditionWCO{5} = optData.numTrialsByConditionWCO{5}+n;
                optData.correctByConditionWCO{5} = optData.correctByConditionWCO{5}+x;
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

if plotOn
    figName = sprintf('%s::OPTIMAL',mouseID);
    f = figure('name',figName,'position',[748    43   816   579]);
    ax1 = subplot(2,2,1); hold on;
    bar(optData.dates-min(optData.dates)+1,optData.numTrialsByDate);
    xlabel('num days','FontName','Times New Roman','FontSize',12);
    ylabel('num trials','FontName','Times New Roman','FontSize',12);
    
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
out.optData = optData;

%% CONTRAST DATA Exists in both sets
ctr1 = filterBehaviorData(data1,'tsName','orCTRSweep');%1x3453 trials 
ctrData.trialNum = [ctr1.compiledTrialRecords.trialNumber];
ctrData.correct = [ctr1.compiledTrialRecords.correct];
ctrData.correction = [ctr1.compiledTrialRecords.correctionTrial];
ctrData.contrast = [ctr1.compiledDetails(1).records.contrasts];
ctrData.time = [ctr1.compiledTrialRecords.date];
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

%performance by condition with trial number cutoff
ctrData.trialNumsByConditionWCO = cell(length(ctrData.contrasts),5);
ctrData.numTrialsByConditionWCO = zeros(length(ctrData.contrasts),5);
ctrData.correctByConditionWCO = zeros(length(ctrData.contrasts),5);
ctrData.performanceByConditionWCO = nan(length(ctrData.contrasts),3,5);

for i = 1:length(ctrData.dates)
    if ismember(ctrData.dates(i),filters.ctrFilter)
        dateFilter = ctrData.date==ctrData.dates(i);
        correctThatDate = ctrData.correct(dateFilter);
        correctionThatDate = ctrData.correction(dateFilter);
        contrastThatDate = ctrData.contrast(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        contrastThatDate = contrastThatDate(whichGood);
 
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
        
        if ismember(ctrData.dates(i),datenum(daysPBS))
            ctrData.colorByCondition{i} = 'b';
            ctrData.conditionNum(i) = 1;
        elseif ismember(ctrData.dates(i),datenum(daysCNO))
            ctrData.colorByCondition{i} = 'r';
            ctrData.conditionNum(i) = 2;
        elseif ismember(ctrData.dates(i),datenum(daysIntact))
            ctrData.colorByCondition{i} = 'b';
            ctrData.conditionNum(i) = 3;
        elseif ismember(ctrData.dates(i),datenum(daysLesion))
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
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,1} = [ctrData.trialNumsByCondition{j,1} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,1) = ctrData.numTrialsByCondition(j,1)+n1;
                ctrData.correctByCondition(j,1) = ctrData.correctByCondition(j,1)+x1;
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,1} = [ctrData.trialNumsByConditionWCO{j,1} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,1) = ctrData.numTrialsByConditionWCO(j,1)+n1;
                    ctrData.correctByConditionWCO(j,1) = ctrData.correctByConditionWCO(j,1)+x1;
                end
            end
        elseif ctrData.conditionNum(i) == 2
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,2} = [ctrData.trialNumsByCondition{j,2} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,2) = ctrData.numTrialsByCondition(j,2)+n1;
                ctrData.correctByCondition(j,2) = ctrData.correctByCondition(j,2)+x1;
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,2} = [ctrData.trialNumsByConditionWCO{j,2} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,2) = ctrData.numTrialsByConditionWCO(j,2)+n1;
                    ctrData.correctByConditionWCO(j,2) = ctrData.correctByConditionWCO(j,2)+x1;
                end
            end
        elseif ctrData.conditionNum(i) == 3
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,3} = [ctrData.trialNumsByCondition{j,3} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,3) = ctrData.numTrialsByCondition(j,3)+n1;
                ctrData.correctByCondition(j,3) = ctrData.correctByCondition(j,3)+x1;
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,3} = [ctrData.trialNumsByConditionWCO{j,3} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,3) = ctrData.numTrialsByConditionWCO(j,3)+n1;
                    ctrData.correctByConditionWCO(j,3) = ctrData.correctByConditionWCO(j,3)+x1;
                end
            end
        elseif ctrData.conditionNum(i) == 4
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,4} = [ctrData.trialNumsByCondition{j,4} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,4) = ctrData.numTrialsByCondition(j,4)+n1;
                ctrData.correctByCondition(j,4) = ctrData.correctByCondition(j,4)+x1;
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,4} = [ctrData.trialNumsByConditionWCO{j,4} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,4) = ctrData.numTrialsByConditionWCO(j,4)+n1;
                    ctrData.correctByConditionWCO(j,4) = ctrData.correctByConditionWCO(j,4)+x1;
                end
            end
        elseif ctrData.conditionNum(i) == 5
            for j = 1:length(ctrData.contrasts)
                whichCurrContrast = contrastThatDate==ctrData.contrasts(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                ctrData.trialNumsByCondition{j,5} = [ctrData.trialNumsByCondition{j,5} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                ctrData.numTrialsByCondition(j,5) = ctrData.numTrialsByCondition(j,5)+n1;
                ctrData.correctByCondition(j,5) = ctrData.correctByCondition(j,5)+x1;
                if ctrData.dayMetCutOffCriterion(i)
                    ctrData.trialNumsByConditionWCO{j,5} = [ctrData.trialNumsByConditionWCO{j,5} makerow(ctrData.trialNumByDate{i}(whichCurrContrast))];
                    ctrData.numTrialsByConditionWCO(j,5) = ctrData.numTrialsByConditionWCO(j,5)+n1;
                    ctrData.correctByConditionWCO(j,5) = ctrData.correctByConditionWCO(j,5)+x1;
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

if plotOn
    figName = sprintf('%s::VARIABLE CONTRAST',mouseID);
    f = figure('NAME',figName);
    ax1 = subplot(3,2,1); hold on;
    bar(ctrData.dates-min(ctrData.dates)+1,ctrData.numTrialsByDate);
    xlabel('num days','FontName','Times New Roman','FontSize',12);
    ylabel('num trials','FontName','Times New Roman','FontSize',12);
    
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
    
    
    ax3 = subplot(3,2,3:6); hold on;
    conditionColor = {'b','r','b','r','k'};
    for i = 1:size(ctrData.performanceByConditionWCO,3)
        for j = 1:size(ctrData.performanceByConditionWCO,1)
            if ~isnan(ctrData.performanceByConditionWCO(j,1,i))
                plot(ctrData.contrasts(j),ctrData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                plot([ctrData.contrasts(j) ctrData.contrasts(j)],[ctrData.performanceByConditionWCO(j,2,i) ctrData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
            end
        end
    end
    set(ax3,'ylim',[0.2 1.1],'xlim',[0 1],'xtick',[0 0.25 0.5 0.75 1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot([0 1],[0.5 0.5],'k-');plot([0 1],[0.7 0.7],'k--');
    xlabel('contrast','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end
out.ctrData = ctrData;

%% SPAT FREQ
spat = filterBehaviorData(data1,'tsName','orSFSweep');%1x1072 trials 
spatData.trialNum = [spat.compiledTrialRecords.trialNumber];
spatData.correct = [spat.compiledTrialRecords.correct];
spatData.correction = [spat.compiledTrialRecords.correctionTrial];
spatData.spatFreq = [spat.compiledDetails(1).records.pixPerCycs];
spatData.time = [spat.compiledTrialRecords.date];
spatData.date = floor(spatData.time);
spatData.dates = unique(spatData.date);
spatData.spatFreqs = unique(spatData.spatFreq);

% performance on a day by day basis
spatData.trialNumByDate = cell(1,length(spatData.dates));
spatData.numTrialsByDate = nan(1,length(spatData.dates));
spatData.performanceByDate = nan(3,length(spatData.dates));
spatData.colorByCondition = cell(1,length(spatData.dates));
spatData.conditionNum = nan(1,length(spatData.dates));
spatData.dayMetCutOffCriterion = nan(1,length(spatData.dates));

%performance by condition
spatData.trialNumsByCondition = cell(length(spatData.spatFreqs),5);
spatData.numTrialsByCondition = zeros(length(spatData.spatFreqs),5);
spatData.correctByCondition = zeros(length(spatData.spatFreqs),5);
spatData.performanceByCondition = nan(length(spatData.spatFreqs),3,5);

%performance by condition with trial number cutoff
spatData.trialNumsByConditionWCO = cell(length(spatData.spatFreqs),5);
spatData.numTrialsByConditionWCO = zeros(length(spatData.spatFreqs),5);
spatData.correctByConditionWCO = zeros(length(spatData.spatFreqs),5);
spatData.performanceByConditionWCO = nan(length(spatData.spatFreqs),3,5);

for i = 1:length(spatData.dates)
    if ismember(spatData.dates(i),filters.sfFilter)
        dateFilter = spatData.date==spatData.dates(i);
        correctThatDate = spatData.correct(dateFilter);
        correctionThatDate = spatData.correction(dateFilter);
        sfThatDate = spatData.spatFreq(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        sfThatDate = sfThatDate(whichGood);
 
        spatData.trialNumByDate{i} = spatData.trialNum(dateFilter);
        spatData.trialNumByDate{i} = spatData.trialNumByDate{i}(whichGood);
        spatData.numTrialsByDate(i) = length(spatData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        spatData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        spatData.performanceByDate(1,i) = phat;
        spatData.performanceByDate(2,i) = pci(1);
        spatData.performanceByDate(3,i) = pci(2);
        
        if ismember(spatData.dates(i),datenum(daysPBS))
            spatData.colorByCondition{i} = 'b';
            spatData.conditionNum(i) = 1;
        elseif ismember(spatData.dates(i),datenum(daysCNO))
            spatData.colorByCondition{i} = 'r';
            spatData.conditionNum(i) = 2;
        elseif ismember(spatData.dates(i),datenum(daysIntact))
            spatData.colorByCondition{i} = 'b';
            spatData.conditionNum(i) = 3;
        elseif ismember(spatData.dates(i),datenum(daysLesion))
            spatData.colorByCondition{i} = 'r';
            spatData.conditionNum(i) = 4;
        else
            spatData.colorByCondition{i} = 'k';
            spatData.conditionNum(i) = 5;
        end
                
        if spatData.conditionNum(i) == 1
            for j = 1:length(spatData.spatFreqs)
                whichCurrContrast = sfThatDate==spatData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatData.trialNumsByCondition{j,1} = [spatData.trialNumsByCondition{j,1} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                spatData.numTrialsByCondition(j,1) = spatData.numTrialsByCondition(j,1)+n1;
                spatData.correctByCondition(j,1) = spatData.correctByCondition(j,1)+x1;
                if spatData.dayMetCutOffCriterion(i)
                    spatData.trialNumsByConditionWCO{j,1} = [spatData.trialNumsByConditionWCO{j,1} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                    spatData.numTrialsByConditionWCO(j,1) = spatData.numTrialsByConditionWCO(j,1)+n1;
                    spatData.correctByConditionWCO(j,1) = spatData.correctByConditionWCO(j,1)+x1;
                end
            end
        elseif spatData.conditionNum(i) == 2
            for j = 1:length(spatData.spatFreqs)
                whichCurrContrast = sfThatDate==spatData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatData.trialNumsByCondition{j,2} = [spatData.trialNumsByCondition{j,2} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                spatData.numTrialsByCondition(j,2) = spatData.numTrialsByCondition(j,2)+n1;
                spatData.correctByCondition(j,2) = spatData.correctByCondition(j,2)+x1;
                if spatData.dayMetCutOffCriterion(i)
                    spatData.trialNumsByConditionWCO{j,2} = [spatData.trialNumsByConditionWCO{j,2} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                    spatData.numTrialsByConditionWCO(j,2) = spatData.numTrialsByConditionWCO(j,2)+n1;
                    spatData.correctByConditionWCO(j,2) = spatData.correctByConditionWCO(j,2)+x1;
                end
            end
        elseif spatData.conditionNum(i) == 3
            for j = 1:length(spatData.spatFreqs)
                whichCurrContrast = sfThatDate==spatData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatData.trialNumsByCondition{j,3} = [spatData.trialNumsByCondition{j,3} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                spatData.numTrialsByCondition(j,3) = spatData.numTrialsByCondition(j,3)+n1;
                spatData.correctByCondition(j,3) = spatData.correctByCondition(j,3)+x1;
                if spatData.dayMetCutOffCriterion(i)
                    spatData.trialNumsByConditionWCO{j,3} = [spatData.trialNumsByConditionWCO{j,3} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                    spatData.numTrialsByConditionWCO(j,3) = spatData.numTrialsByConditionWCO(j,3)+n1;
                    spatData.correctByConditionWCO(j,3) = spatData.correctByConditionWCO(j,3)+x1;
                end
            end
        elseif spatData.conditionNum(i) == 4
            for j = 1:length(spatData.spatFreqs)
                whichCurrContrast = sfThatDate==spatData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatData.trialNumsByCondition{j,4} = [spatData.trialNumsByCondition{j,4} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                spatData.numTrialsByCondition(j,4) = spatData.numTrialsByCondition(j,4)+n1;
                spatData.correctByCondition(j,4) = spatData.correctByCondition(j,4)+x1;
                if spatData.dayMetCutOffCriterion(i)
                    spatData.trialNumsByConditionWCO{j,4} = [spatData.trialNumsByConditionWCO{j,4} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                    spatData.numTrialsByConditionWCO(j,4) = spatData.numTrialsByConditionWCO(j,4)+n1;
                    spatData.correctByConditionWCO(j,4) = spatData.correctByConditionWCO(j,4)+x1;
                end
            end
        elseif spatData.conditionNum(i) == 5
            for j = 1:length(spatData.spatFreqs)
                whichCurrContrast = sfThatDate==spatData.spatFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                spatData.trialNumsByCondition{j,5} = [spatData.trialNumsByCondition{j,5} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                spatData.numTrialsByCondition(j,5) = spatData.numTrialsByCondition(j,5)+n1;
                spatData.correctByCondition(j,5) = spatData.correctByCondition(j,5)+x1;
                if spatData.dayMetCutOffCriterion(i)
                    spatData.trialNumsByConditionWCO{j,5} = [spatData.trialNumsByConditionWCO{j,5} makerow(spatData.trialNumByDate{i}(whichCurrContrast))];
                    spatData.numTrialsByConditionWCO(j,5) = spatData.numTrialsByConditionWCO(j,5)+n1;
                    spatData.correctByConditionWCO(j,5) = spatData.correctByConditionWCO(j,5)+x1;
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(spatData.spatFreqs)
    [phat,pci] = binofit(spatData.correctByCondition(j,:),spatData.numTrialsByCondition(j,:));
    spatData.performanceByCondition(j,1,:) = phat;
    spatData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([spatData.correctByConditionWCO(j,:)],[spatData.numTrialsByConditionWCO(j,:)]);
    spatData.performanceByConditionWCO(j,1,:) = phat;
    spatData.performanceByConditionWCO(j,2:3,:) = pci';
end

if plotOn
    figName = sprintf('%s::VARIABLE CONTRAST',mouseID);
    f = figure('NAME',figName);
    ax1 = subplot(3,2,1); hold on;
    bar(spatData.dates-min(spatData.dates)+1,spatData.numTrialsByDate);
    xlabel('num days','FontName','Times New Roman','FontSize',12);
    ylabel('num trials','FontName','Times New Roman','FontSize',12);
    
    ax2 = subplot(3,2,2); hold on;
    plot([0 max(spatData.dates)-min(spatData.dates)+1],[0.5 0.5],'k');
    plot([0 max(spatData.dates)-min(spatData.dates)+1],[0.7 0.7],'k--');
    for i = 1:length(spatData.dates)
        if ~isnan(spatData.dayMetCutOffCriterion(i))
            if spatData.dayMetCutOffCriterion(i)
                xloc = spatData.dates(i)-min(spatData.dates)+1;
                plot(xloc,spatData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                plot([xloc xloc],spatData.performanceByDate(2:3,i),'color','k','LineWidth',2);
            else
                xloc = spatData.dates(i)-min(spatData.dates)+1;
                plot(xloc,spatData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                plot([xloc xloc],spatData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
            end
        else
            xloc = spatData.dates(i)-min(spatData.dates)+1;
            plot(xloc,0.5,'Marker','x','color','k');
        end
    end
    set(ax2,'ylim',[0.2 1]); 
    xlabel('day num','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);
    
    
    ax3 = subplot(3,2,3:6); hold on;
    conditionColor = {'b','r','b','r','k'};
    for i = 1:size(spatData.performanceByConditionWCO,3)
        for j = 1:size(spatData.performanceByConditionWCO,1)
            if ~isnan(spatData.performanceByConditionWCO(j,1,i))
                xloc = 1/spatData.spatFreqs(j);
                plot(xloc,spatData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                plot([xloc xloc],[spatData.performanceByConditionWCO(j,2,i) spatData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
            end
        end
    end
    set(ax3,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('spat.freq.','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end
out.spatData = spatData;