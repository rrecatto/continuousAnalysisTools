function out = mouse17(filters,plotOn,trialNumCutoff)
out = [];
if ~exist('plotOn','var')||isempty(plotOn)
    plotOn = true;
end
if ~exist('trialNumCutoff','var')||isempty(trialNumCutoff)
    trialNumCutoff = 25;
end

if ~exist('filters','var') || isempty(filters)
    % all data is allowed
    filters.fdFilter = 1:today;
    filters.imFilter = 1:today;
    filters.optFilter = 1:today;
    filters.ctrFilter = 1:today;
    filters.sfFilter = 1:today;
end
mouseID = '17';
daysPBS = {
'8/17/2012',...
'8/20/2012',...
'8/22/2012',...
'8/27/2012',...
'8/29/2012',...
'8/31/2012',...
'9/4/2012',... vc
'9/5/2012',... vc
'9/6/2012',... vc
'9/10/2012',... vc
'9/11/2012',... vc
'9/12/2012',... vc
'9/13/2012',... vc
'9/14/2012',... vc
'9/17/2012',...
'9/19/2012',...
'9/21/2012',...
'9/24/2012',...
'9/26/2012',...
'9/28/2012',...
'10/1/2012',...
'10/3/2012',...
'10/5/2012',...
'10/8/2012',...
'10/10/2012',...
'10/12/2012',...
'10/15/2012',...
'10/16/2012',...
'10/17/2012',...
'10/23/2012',...
'10/25/2012',...
'10/26/2012',...
'10/29/2012',...
'10/31/2012',...
'11/2/2012',...
'11/6/2012',...
'11/8/2012',...
'11/10/2012',...
'11/12/2012',...
'11/14/2012',...
'11/16/2012',...
'11/19/2012',...
'11/21/2012',...
'11/23/2012',...
'11/26/2012',...
...
};
daysCNO = {
'8/21/2012',... vc
'8/23/2012',... vc
'8/24/2012',... vc
'8/28/2012',... vc
'8/30/2012',... vc
'9/5/2012',... vc
'9/7/2012',... vc
'9/18/2012',...
'9/20/2012',...
'9/25/2012',...
'9/27/2012',...
'10/2/2012',...
'10/4/2012',...
'10/9/2012',...
'10/11/2012',...
'10/18/2012',...
'10/19/2012',...
'10/22/2012',...
'10/24/2012',...
'10/27/2012',...
'10/30/2012',...
'11/1/2012',...
'11/3/2012',...
'11/5/2012',...
'11/7/2012',...
'11/9/2012',...
'11/13/2012',...
'11/15/2012',...
'11/17/2012',...
'11/20/2012',...
'11/22/2012',...
...
};

daysIntact = {};
daysLesion = {};

location1 = 'C:\Users\ephys-data\Desktop\Compiled\Box2\17.compiledTrialRecords.1-17267.mat'; % everything else
location2 = 'C:\Users\ephys-data\Desktop\Compiled\Box3\17.compiledTrialRecords.1-7862.mat'; % half/quat/eights Rad and surr cntr sweep

data1 = load(location1);
data2 = load(location2);

%% IMAGES
if false
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
end
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
                xloc = log10(1/rad2deg(atan(44.7/1024*spatData.spatFreqs(j)/12)));
%                 xloc = 1/spatData.spatFreqs(j);
                plot(xloc,spatData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                plot([xloc xloc],[spatData.performanceByConditionWCO(j,2,i) spatData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
            end
        end
    end
    xticks = log10([0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.2]);
    xticklabs = {'0.01','','','','','','','','','0.1','0.2'};
    set(ax3,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',[log10(0.0075) log10(0.25)],'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('spat.freq.','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end
out.spatData = spatData;

%% TEMP FREQ
temp = filterBehaviorData(data1,'tsName','orTFSweep_nAFC');%1x1072 trials 
tempData.trialNum = [temp.compiledTrialRecords.trialNumber];
tempData.correct = [temp.compiledTrialRecords.correct];
tempData.correction = [temp.compiledTrialRecords.correctionTrial];
tempData.tempFreq = [temp.compiledDetails(1).records.driftfrequencies];
whichZero = tempData.tempFreq==0;
tempData.tempFreq(whichZero) = 0.1;
tempData.time = [temp.compiledTrialRecords.date];
tempData.date = floor(tempData.time);
tempData.dates = unique(tempData.date);
tempData.tempFreqs = unique(tempData.tempFreq);

% performance on a day by day basis
tempData.trialNumByDate = cell(1,length(tempData.dates));
tempData.numTrialsByDate = nan(1,length(tempData.dates));
tempData.performanceByDate = nan(3,length(tempData.dates));
tempData.colorByCondition = cell(1,length(tempData.dates));
tempData.conditionNum = nan(1,length(tempData.dates));
tempData.dayMetCutOffCriterion = nan(1,length(tempData.dates));

%performance by condition
tempData.trialNumsByCondition = cell(length(tempData.tempFreq),5);
tempData.numTrialsByCondition = zeros(length(tempData.tempFreqs),5);
tempData.correctByCondition = zeros(length(tempData.tempFreqs),5);
tempData.performanceByCondition = nan(length(tempData.tempFreqs),3,5);

%performance by condition with trial number cutoff
tempData.trialNumsByConditionWCO = cell(length(tempData.tempFreqs),5);
tempData.numTrialsByConditionWCO = zeros(length(tempData.tempFreqs),5);
tempData.correctByConditionWCO = zeros(length(tempData.tempFreqs),5);
tempData.performanceByConditionWCO = nan(length(tempData.tempFreqs),3,5);

for i = 1:length(tempData.dates)
    if ismember(tempData.dates(i),filters.tfFilter)
        dateFilter = tempData.date==tempData.dates(i);
        correctThatDate = tempData.correct(dateFilter);
        correctionThatDate = tempData.correction(dateFilter);
        tfThatDate = tempData.tempFreq(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        tfThatDate = tfThatDate(whichGood);
 
        tempData.trialNumByDate{i} = tempData.trialNum(dateFilter);
        tempData.trialNumByDate{i} = tempData.trialNumByDate{i}(whichGood);
        tempData.numTrialsByDate(i) = length(tempData.trialNumByDate{i});

        x = sum(correctThatDate);
        n = length(correctThatDate);
        tempData.dayMetCutOffCriterion(i) = n>=trialNumCutoff;
        [phat,pci] = binofit(x,n);
        tempData.performanceByDate(1,i) = phat;
        tempData.performanceByDate(2,i) = pci(1);
        tempData.performanceByDate(3,i) = pci(2);
        
        if ismember(tempData.dates(i),datenum(daysPBS))
            tempData.colorByCondition{i} = 'b';
            tempData.conditionNum(i) = 1;
        elseif ismember(tempData.dates(i),datenum(daysCNO))
            tempData.colorByCondition{i} = 'r';
            tempData.conditionNum(i) = 2;
        elseif ismember(tempData.dates(i),datenum(daysIntact))
            tempData.colorByCondition{i} = 'b';
            tempData.conditionNum(i) = 3;
        elseif ismember(tempData.dates(i),datenum(daysLesion))
            tempData.colorByCondition{i} = 'r';
            tempData.conditionNum(i) = 4;
        else
            tempData.colorByCondition{i} = 'k';
            tempData.conditionNum(i) = 5;
        end
                
        if tempData.conditionNum(i) == 1
            for j = 1:length(tempData.tempFreqs)
                whichCurrContrast = tfThatDate==tempData.tempFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempData.trialNumsByCondition{j,1} = [tempData.trialNumsByCondition{j,1} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                tempData.numTrialsByCondition(j,1) = tempData.numTrialsByCondition(j,1)+n1;
                tempData.correctByCondition(j,1) = tempData.correctByCondition(j,1)+x1;
                if tempData.dayMetCutOffCriterion(i)
                    tempData.trialNumsByConditionWCO{j,1} = [tempData.trialNumsByConditionWCO{j,1} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                    tempData.numTrialsByConditionWCO(j,1) = tempData.numTrialsByConditionWCO(j,1)+n1;
                    tempData.correctByConditionWCO(j,1) = tempData.correctByConditionWCO(j,1)+x1;
                end
            end
        elseif tempData.conditionNum(i) == 2
            for j = 1:length(tempData.tempFreqs)
                whichCurrContrast = tfThatDate==tempData.tempFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempData.trialNumsByCondition{j,2} = [tempData.trialNumsByCondition{j,2} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                tempData.numTrialsByCondition(j,2) = tempData.numTrialsByCondition(j,2)+n1;
                tempData.correctByCondition(j,2) = tempData.correctByCondition(j,2)+x1;
                if tempData.dayMetCutOffCriterion(i)
                    tempData.trialNumsByConditionWCO{j,2} = [tempData.trialNumsByConditionWCO{j,2} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                    tempData.numTrialsByConditionWCO(j,2) = tempData.numTrialsByConditionWCO(j,2)+n1;
                    tempData.correctByConditionWCO(j,2) = tempData.correctByConditionWCO(j,2)+x1;
                end
            end
        elseif tempData.conditionNum(i) == 3
            for j = 1:length(tempData.tempFreqs)
                whichCurrContrast = tfThatDate==tempData.tempFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempData.trialNumsByCondition{j,3} = [tempData.trialNumsByCondition{j,3} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                tempData.numTrialsByCondition(j,3) = tempData.numTrialsByCondition(j,3)+n1;
                tempData.correctByCondition(j,3) = tempData.correctByCondition(j,3)+x1;
                if tempData.dayMetCutOffCriterion(i)
                    tempData.trialNumsByConditionWCO{j,3} = [tempData.trialNumsByConditionWCO{j,3} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                    tempData.numTrialsByConditionWCO(j,3) = tempData.numTrialsByConditionWCO(j,3)+n1;
                    tempData.correctByConditionWCO(j,3) = tempData.correctByConditionWCO(j,3)+x1;
                end
            end
        elseif tempData.conditionNum(i) == 4
            for j = 1:length(tempData.tempFreqs)
                whichCurrContrast = tfThatDate==tempData.tempFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempData.trialNumsByCondition{j,4} = [tempData.trialNumsByCondition{j,4} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                tempData.numTrialsByCondition(j,4) = tempData.numTrialsByCondition(j,4)+n1;
                tempData.correctByCondition(j,4) = tempData.correctByCondition(j,4)+x1;
                if tempData.dayMetCutOffCriterion(i)
                    tempData.trialNumsByConditionWCO{j,4} = [tempData.trialNumsByConditionWCO{j,4} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                    tempData.numTrialsByConditionWCO(j,4) = tempData.numTrialsByConditionWCO(j,4)+n1;
                    tempData.correctByConditionWCO(j,4) = tempData.correctByConditionWCO(j,4)+x1;
                end
            end
        elseif tempData.conditionNum(i) == 5
            for j = 1:length(tempData.tempFreqs)
                whichCurrContrast = tfThatDate==tempData.tempFreqs(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                tempData.trialNumsByCondition{j,5} = [tempData.trialNumsByCondition{j,5} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                tempData.numTrialsByCondition(j,5) = tempData.numTrialsByCondition(j,5)+n1;
                tempData.correctByCondition(j,5) = tempData.correctByCondition(j,5)+x1;
                if tempData.dayMetCutOffCriterion(i)
                    tempData.trialNumsByConditionWCO{j,5} = [tempData.trialNumsByConditionWCO{j,5} makerow(tempData.trialNumByDate{i}(whichCurrContrast))];
                    tempData.numTrialsByConditionWCO(j,5) = tempData.numTrialsByConditionWCO(j,5)+n1;
                    tempData.correctByConditionWCO(j,5) = tempData.correctByConditionWCO(j,5)+x1;
                end
            end
        else
            error('unknown condition');
        end
        
    end
end


for j = 1:length(tempData.tempFreqs)
    [phat,pci] = binofit(tempData.correctByCondition(j,:),tempData.numTrialsByCondition(j,:));
    tempData.performanceByCondition(j,1,:) = phat;
    tempData.performanceByCondition(j,2:3,:) = pci';
    
    [phat,pci] = binofit([tempData.correctByConditionWCO(j,:)],[tempData.numTrialsByConditionWCO(j,:)]);
    tempData.performanceByConditionWCO(j,1,:) = phat;
    tempData.performanceByConditionWCO(j,2:3,:) = pci';
end

if plotOn
    figName = sprintf('%s::VARIABLE CONTRAST',mouseID);
    f = figure('NAME',figName);
    ax1 = subplot(3,2,1); hold on;
    bar(tempData.dates-min(tempData.dates)+1,tempData.numTrialsByDate);
    xlabel('num days','FontName','Times New Roman','FontSize',12);
    ylabel('num trials','FontName','Times New Roman','FontSize',12);
    
    ax2 = subplot(3,2,2); hold on;
    plot([0 max(tempData.dates)-min(tempData.dates)+1],[0.5 0.5],'k');
    plot([0 max(tempData.dates)-min(tempData.dates)+1],[0.7 0.7],'k--');
    for i = 1:length(tempData.dates)
        if ~isnan(tempData.dayMetCutOffCriterion(i))
            if tempData.dayMetCutOffCriterion(i)
                xloc = tempData.dates(i)-min(tempData.dates)+1;
                plot(xloc,tempData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor','k','MarkerFaceColor','k');
                plot([xloc xloc],tempData.performanceByDate(2:3,i),'color','k','LineWidth',2);
            else
                xloc = tempData.dates(i)-min(tempData.dates)+1;
                plot(xloc,tempData.performanceByDate(1,i),'Marker','d','MarkerEdgeColor',0.75*[1 1 1],'MarkerFaceColor',0.75*[1 1 1]);
                plot([xloc xloc],tempData.performanceByDate(2:3,i),'color',0.75*[1 1 1],'LineWidth',2);
            end
        else
            xloc = tempData.dates(i)-min(tempData.dates)+1;
            plot(xloc,0.5,'Marker','x','color','k');
        end
    end
    set(ax2,'ylim',[0.2 1]); 
    xlabel('day num','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);
    
    
    ax3 = subplot(3,2,3:6); hold on;
    conditionColor = {'b','r','b','r','k'};
    for i = 1:size(tempData.performanceByConditionWCO,3)
        for j = 1:size(tempData.performanceByConditionWCO,1)
            if ~isnan(tempData.performanceByConditionWCO(j,1,i))
                xloc = log2(tempData.tempFreqs(j));
                plot(xloc,tempData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                plot([xloc xloc],[tempData.performanceByConditionWCO(j,2,i) tempData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
            end
        end
    end
    xticks = log2([0.0625 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10 20]);
    xticklabs = {'','0','','','','','','','','','1','','','','','','','','','10',''};
    set(ax3,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',log2([0.0625 32]),'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('temp.freq.','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end
out.tempData = tempData;

%% OR FREQ
or1 = filterBehaviorData(data1,'tsName','orORSweep_nAFC');%1x1072 trials 
orData.trialNum = [or1.compiledTrialRecords.trialNumber];
orData.correct = [or1.compiledTrialRecords.correct];
orData.correction = [or1.compiledTrialRecords.correctionTrial];
orData.orientation = [or1.compiledDetails(1).records.orientations];
orData.orientation = mod(round(rad2deg(abs(orData.orientation))),180);
orData.time = [or1.compiledTrialRecords.date];
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

%performance by condition with trial number cutoff
orData.trialNumsByConditionWCO = cell(length(orData.orientations),5);
orData.numTrialsByConditionWCO = zeros(length(orData.orientations),5);
orData.correctByConditionWCO = zeros(length(orData.orientations),5);
orData.performanceByConditionWCO = nan(length(orData.orientations),3,5);

for i = 1:length(orData.dates)
    if ismember(orData.dates(i),filters.orFilter)
        dateFilter = orData.date==orData.dates(i);
        correctThatDate = orData.correct(dateFilter);
        correctionThatDate = orData.correction(dateFilter);
        orThatDate = orData.orientation(dateFilter);
        % filter out the nans
        whichGood = ~isnan(correctThatDate) & ~correctionThatDate;
        correctThatDate = correctThatDate(whichGood);
        orThatDate = orThatDate(whichGood);
 
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
        
        if ismember(orData.dates(i),datenum(daysPBS))
            orData.colorByCondition{i} = 'b';
            orData.conditionNum(i) = 1;
        elseif ismember(orData.dates(i),datenum(daysCNO))
            orData.colorByCondition{i} = 'r';
            orData.conditionNum(i) = 2;
        elseif ismember(orData.dates(i),datenum(daysIntact))
            orData.colorByCondition{i} = 'b';
            orData.conditionNum(i) = 3;
        elseif ismember(orData.dates(i),datenum(daysLesion))
            orData.colorByCondition{i} = 'r';
            orData.conditionNum(i) = 4;
        else
            orData.colorByCondition{i} = 'k';
            orData.conditionNum(i) = 5;
        end
                
        if orData.conditionNum(i) == 1
            for j = 1:length(orData.orientations)
                whichCurrContrast = orThatDate==orData.orientations(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                orData.trialNumsByCondition{j,1} = [orData.trialNumsByCondition{j,1} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                orData.numTrialsByCondition(j,1) = orData.numTrialsByCondition(j,1)+n1;
                orData.correctByCondition(j,1) = orData.correctByCondition(j,1)+x1;
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,1} = [orData.trialNumsByConditionWCO{j,1} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                    orData.numTrialsByConditionWCO(j,1) = orData.numTrialsByConditionWCO(j,1)+n1;
                    orData.correctByConditionWCO(j,1) = orData.correctByConditionWCO(j,1)+x1;
                end
            end
        elseif orData.conditionNum(i) == 2
            for j = 1:length(orData.orientations)
                whichCurrContrast = orThatDate==orData.orientations(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                orData.trialNumsByCondition{j,2} = [orData.trialNumsByCondition{j,2} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                orData.numTrialsByCondition(j,2) = orData.numTrialsByCondition(j,2)+n1;
                orData.correctByCondition(j,2) = orData.correctByCondition(j,2)+x1;
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,2} = [orData.trialNumsByConditionWCO{j,2} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                    orData.numTrialsByConditionWCO(j,2) = orData.numTrialsByConditionWCO(j,2)+n1;
                    orData.correctByConditionWCO(j,2) = orData.correctByConditionWCO(j,2)+x1;
                end
            end
        elseif orData.conditionNum(i) == 3
            for j = 1:length(orData.orientations)
                whichCurrContrast = orThatDate==orData.orientations(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                orData.trialNumsByCondition{j,3} = [orData.trialNumsByCondition{j,3} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                orData.numTrialsByCondition(j,3) = orData.numTrialsByCondition(j,3)+n1;
                orData.correctByCondition(j,3) = orData.correctByCondition(j,3)+x1;
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,3} = [orData.trialNumsByConditionWCO{j,3} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                    orData.numTrialsByConditionWCO(j,3) = orData.numTrialsByConditionWCO(j,3)+n1;
                    orData.correctByConditionWCO(j,3) = orData.correctByConditionWCO(j,3)+x1;
                end
            end
        elseif orData.conditionNum(i) == 4
            for j = 1:length(orData.orientations)
                whichCurrContrast = orThatDate==orData.orientations(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                orData.trialNumsByCondition{j,4} = [orData.trialNumsByCondition{j,4} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                orData.numTrialsByCondition(j,4) = orData.numTrialsByCondition(j,4)+n1;
                orData.correctByCondition(j,4) = orData.correctByCondition(j,4)+x1;
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,4} = [orData.trialNumsByConditionWCO{j,4} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                    orData.numTrialsByConditionWCO(j,4) = orData.numTrialsByConditionWCO(j,4)+n1;
                    orData.correctByConditionWCO(j,4) = orData.correctByConditionWCO(j,4)+x1;
                end
            end
        elseif orData.conditionNum(i) == 5
            for j = 1:length(orData.orientations)
                whichCurrContrast = orThatDate==orData.orientations(j);
                currContrastCorrect = correctThatDate(whichCurrContrast);
                x1 = sum(currContrastCorrect);
                n1 = length(currContrastCorrect);
                orData.trialNumsByCondition{j,5} = [orData.trialNumsByCondition{j,5} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                orData.numTrialsByCondition(j,5) = orData.numTrialsByCondition(j,5)+n1;
                orData.correctByCondition(j,5) = orData.correctByCondition(j,5)+x1;
                if orData.dayMetCutOffCriterion(i)
                    orData.trialNumsByConditionWCO{j,5} = [orData.trialNumsByConditionWCO{j,5} makerow(orData.trialNumByDate{i}(whichCurrContrast))];
                    orData.numTrialsByConditionWCO(j,5) = orData.numTrialsByConditionWCO(j,5)+n1;
                    orData.correctByConditionWCO(j,5) = orData.correctByConditionWCO(j,5)+x1;
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

if plotOn
    figName = sprintf('%s::VARIABLE CONTRAST',mouseID);
    f = figure('NAME',figName);
    ax1 = subplot(3,2,1); hold on;
    bar(orData.dates-min(orData.dates)+1,orData.numTrialsByDate);
    xlabel('num days','FontName','Times New Roman','FontSize',12);
    ylabel('num trials','FontName','Times New Roman','FontSize',12);
    
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
    
    
    ax3 = subplot(3,2,3:6); hold on;
    conditionColor = {'b','r','b','r','k'};
    for i = 1:size(orData.performanceByConditionWCO,3)
        for j = 1:size(orData.performanceByConditionWCO,1)
            if ~isnan(orData.performanceByConditionWCO(j,1,i))
                xloc = orData.orientations(j);
                plot(xloc,orData.performanceByConditionWCO(j,1,i),'Marker','d','MarkerSize',10,'MarkerFaceColor',conditionColor{i},'MarkerEdgeColor','none');
                plot([xloc xloc],[orData.performanceByConditionWCO(j,2,i) orData.performanceByConditionWCO(j,3,i)],'color',conditionColor{i},'linewidth',5);
            end
        end
    end
    xticks = [0 5 15 25 35 45];
    xticklabs = {'0','','15','','35','45'};
    set(ax3,'ylim',[0.2 1.1],'ytick',[0.2 0.5 1],'FontName','Times New Roman','FontSize',12,'xlim',[-5 50],'xtick',xticks,'xticklabel',xticklabs);plot(get(gca,'xlim'),[0.5 0.5],'k-');plot(get(gca,'xlim'),[0.7 0.7],'k--');
    xlabel('orientation','FontName','Times New Roman','FontSize',12);
    ylabel('performance','FontName','Times New Roman','FontSize',12);       
end
out.orData = orData;