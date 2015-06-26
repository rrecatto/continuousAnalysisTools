%% ED MEETING Jan 31 2011
dataPath = '~/Documents/datanetOutput';

%% SPATIAL FREQUENCY
dataPath = '\\132.239.158.169\datanetOutput';
sfRecUnits = {...
    {'389',1,[78 79]},...
    {'375',1,[493 495]},...
    {'375',1,[552 553]},...
    {'375',1,[763 764]},...
    {'375',1,[1182]},...
};

conversion = 73/1024; %(degrees/pix)

% plotting
f = figure;
ax = axes; hold on;
for unitNum = 1:length(sfRecUnits)
    if length(sfRecUnits{unitNum}{3})>1
        analysisSubFolder = sprintf('%d-%d',sfRecUnits{unitNum}{3}(1),sfRecUnits{unitNum}{3}(2));
    else
        analysisSubFolder = sprintf('%d',sfRecUnits{unitNum}{3}(1));
    end
    analysisFile = fullfile(dataPath,sfRecUnits{unitNum}{1},'analysis',analysisSubFolder,'physAnalysis.mat');
    temp = load(analysisFile);
    cA = temp.physAnalysis{1}{1}.(createTrodeName(sfRecUnits{unitNum}{2}));
    [cVals cOrder] = sort(cA.stimInfo.vals);
    plot(1./(conversion*cVals),cA.pow(cOrder),'LineWidth',5);
end

xlabel('spatial frequency (cpd)','FontSize',20);
ylabel('f1(imp/s)','FontSize',20)
title('Spatial Frequency Tuning','FontSize',20);


%% AREA SUMMATION
dataPath = '/home/balaji/Documents/work/datanetOutput';

areaTuning = {...
    {'375',1,[1686 1687],[1671 1673],'unit1'},...
    {'375',1,[1688 1689],[1671 1673],'unit1'},...
%     {'389',1,[62 63],[],'unit2'},...
%     {'389',1,[96],[82 84],'unit3'},...
%     {'389',1,[97 98],[82 84],'unit3'}...
};


% plotting

for unitNum = 1:length(areaTuning)
    conversion = 73/2;
    f = figure;
    ax = axes; hold on;

    if length(areaTuning{unitNum}{3})>1
        analysisSubFolder = sprintf('%d-%d',areaTuning{unitNum}{3}(1),areaTuning{unitNum}{3}(2));
    else
        analysisSubFolder = sprintf('%d',areaTuning{unitNum}{3}(1));
    end
    analysisFile = fullfile(dataPath,areaTuning{unitNum}{1},'analysis',analysisSubFolder,'physAnalysis.mat');
    temp = load(analysisFile);
    cA = temp.physAnalysis{1}{1}.(createTrodeName(areaTuning{unitNum}{2}));
    [cVals cOrder] = sort(cA.stimInfo.vals);
%     plot((conversion*cVals),cA.pow(cOrder),'LineWidth',5);
    rate = sum(cA.rate,2);
    plot((conversion*cVals),rate(cOrder),'LineWidth',5);
%     for i = 1:length(cVals)
% %         plot([conversion*cVals(i) conversion*cVals(i)] ,[cA.pow(cOrder(i))+cA.powSEM(cOrder(i)) cA.pow(cOrder(i))-cA.powSEM(cOrder(i))],'LineWidth',2,'LineStyle','--')
% 
%         plot([conversion*cVals(i) conversion*cVals(i)] ,[cA.rate(cOrder(i))+cA.rateSEM(cOrder(i)) cA.rate(cOrder(i))-cA.rateSEM(cOrder(i))],'LineWidth',2,'LineStyle','--')
%     end
    dpc = unique(cA.stimInfo.pixPerCycs*conversion/512);
    cntr = unique(cA.stimInfo.contrasts*100);
    unitName = areaTuning{unitNum}{5};
    titleStr=sprintf('%s; dpc=%2.2f%c  ; C=%2.2f',unitName,dpc,char(176),cntr);
    set(ax,'FontSize',20)
    xlabel('Aperture radius (deg)','FontSize',20);
    ylabel('f0(imp/s)','FontSize',20)
    title(titleStr,'FontSize',20);

    % now plot the sf curve
    if ~isempty(areaTuning{unitNum}{4})
        conversion = 73/1024;
        Position = [0.7 0.15 0.2 0.2];
        axSF = axes('Position',Position); hold on;
        if length(areaTuning{unitNum}{4})>1
            analysisSubFolder = sprintf('%d-%d',areaTuning{unitNum}{4}(1),areaTuning{unitNum}{4}(2));
        else
            analysisSubFolder = sprintf('%d',areaTuning{unitNum}{4}(1));
        end
        analysisFile = fullfile(dataPath,areaTuning{unitNum}{1},'analysis',analysisSubFolder,'physAnalysis.mat');
        temp = load(analysisFile);
        cA = temp.physAnalysis{1}{1}.(createTrodeName(areaTuning{unitNum}{2}));
        [cVals cOrder] = sort(cA.stimInfo.vals);
%         plot((conversion*cVals),cA.pow(cOrder),'LineWidth',5);
        rate = sum(cA.rate,2);
        plot((conversion*cVals),rate(cOrder),'LineWidth',5);

%         for i = 1:length(cVals)
% %             plot([conversion*cVals(i) conversion*cVals(i)] ,[cA.pow(cOrder(i))+cA.powSEM(cOrder(i)) cA.pow(cOrder(i))-cA.powSEM(cOrder(i))],'LineWidth',2,'LineStyle','--')
%             plot([conversion*cVals(i) conversion*cVals(i)] ,[cA.rate(cOrder(i))+cA.rateSEM(cOrder(i)) cA.rate(cOrder(i))-cA.rateSEM(cOrder(i))],'LineWidth',2,'LineStyle','--')
% 
%         end
        set(axSF,'FontSize',10,'YTick',max(rate),'YTickLabel',sprintf('%2.0f',max(rate)));

        xlabel('dpc','FontSize',20);
        ylabel('f0','FontSize',20)
        title('SF Tuning','FontSize',20);
    end
end