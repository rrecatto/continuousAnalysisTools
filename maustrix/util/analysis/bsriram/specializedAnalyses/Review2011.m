%% COMMITTEE MEETING REVIEW 2011
dataPath = '\\132.239.158.169\datanetOutput';
%% Firing rates
% awake only
awakeUnits = {...
    {'375',1,[393 412]},...
    {'375',1,[477 495]},...
    {'375',1,[535 557]},...
    {'375',1,[590 606]},...
    {'375',1,[758 794]},...
    {'375',1,[874 878]},...
    {'375',1,[880 890]},...
    {'375',1,[1128 1157]},...
    {'375',1,[1163 1204]},...
    {'375',1,[1209 1236]},...
    {'375',1,[1281 1307]},...
    {'375',1,[1344 1348]},...
    {'375',1,[1350 1362]},...
    {'375',1,[1365 1399]}};
    
awkDurs = nan(1,length(awakeUnits));
awkRtes = nan(1,length(awakeUnits));

for i=1:length(awakeUnits)
    analysisDirForRange = sprintf('%d-%d',awakeUnits{i}{3}(1),awakeUnits{i}{3}(2));
    currRec = fullfile(dataPath,awakeUnits{i}{1},'analysis',analysisDirForRange,'spikeRecord.mat');
    temp = load(currRec);
    currSR = temp.spikeRecord;
    trodeName = createTrodeName(awakeUnits{i}{2});
    numSpikes = length(find(currSR.(trodeName).processedClusters));
    awkDurs(i) = sum(currSR.chunkDuration);
    awkRtes(i) = numSpikes/awkDurs(i);
end

dataPath = '\\132.239.158.158\physsbbkup\';

% anesth only
anesUnits = {...
    {'353',1,[3 90]},...
    {'353',1,[153 199]},...
    {'353',1,[200 296]},...
    {'354',1,[20 41]},...
    {'354',1,[53 90]},...
    };
    
anesDurs = nan(1,length(anesUnits));
anesRtes = nan(1,length(anesUnits));

for i=1:length(anesUnits)
    analysisDirForRange = sprintf('%d-%d',anesUnits{i}{3}(1),anesUnits{i}{3}(2));
    currRec = fullfile(dataPath,anesUnits{i}{1},'analysis',analysisDirForRange,'spikeRecord.mat');
    temp = load(currRec);
    currSR = temp.spikeRecord;
    trodeName = createTrodeName(anesUnits{i}{2});
    numSpikes = length(find(currSR.(trodeName).processedClusters));
    anesDurs(i) = sum(currSR.chunkDuration);
    anesRtes(i) = numSpikes/anesDurs(i);
end
%% plotting
f = figure;
ax = axes;
hold on;
maxSpikeNum = max([awkDurs.*awkRtes anesDurs.*anesRtes]);
maxScatterSize = 300;

for numAwk = 1:length(awkDurs)
    scatter(awkDurs(numAwk)/60,awkRtes(numAwk),awkDurs(numAwk)*awkRtes(numAwk)/maxSpikeNum*maxScatterSize,'b','filled');
end

for numAnes = 1:length(anesDurs)
    scatter(anesDurs(numAnes)/60,anesRtes(numAnes),anesDurs(numAnes)*anesRtes(numAnes)/maxSpikeNum*maxScatterSize,0.3*[1 1 1],'filled');
end

xlabel('mins recording','FontSize',20);
ylabel('firing rate (imp/s)','FontSize',20);
title('firing rate vs recording duration','FontSize',30);

maxDur = nearestFactor(max([awkDurs anesDurs]),20);
maxRte = nearestFactor(max([awkRtes anesRtes]),5);
set(ax,'XTick',0:20:maxDur,'YTick',0:5:maxRte,'FontSize',15);

%% Quality of recordings
dataPath = fullfile('~','Documents','datanetOutput');
spRecUnits = {...
    {'375',1,[1386 1392]},...
    {'375',1,[1350 1362]},...
    {'375',1,[766 769]}...
    };
for i=1:length(spRecUnits)
    analysisDirForRange = sprintf('%d-%d',spRecUnits{i}{3}(1),spRecUnits{i}{3}(2));
    currRec = fullfile(dataPath,spRecUnits{i}{1},'analysis',analysisDirForRange,'spikeRecord.mat');
    temp = load(currRec);
    currSR = temp.spikeRecord;
    trodeName = createTrodeName(spRecUnits{i}{2});
    figure; ax = axes;
    titleStr = sprintf('Rat %s: trials %d -> %d',spRecUnits{i}{1},spRecUnits{i}{3}(1),spRecUnits{i}{3}(2));
    currSpikes = currSR.(createTrodeName(spRecUnits{i}{2})).spikeWaveforms;
    featureList = {'wavePC123'};
    currFeatures = calculateFeatures(currSpikes,featureList);
    currProcClus = currSR.(createTrodeName(spRecUnits{i}{2})).processedClusters;
    plot(currFeatures(currProcClus,1),currFeatures(currProcClus,2),'r.');hold on;
    plot(currFeatures(~currProcClus,1),currFeatures(~currProcClus,2),'b.');
    title(titleStr,'FontSize',20);
    set(ax,'XTick',[],'YTick',[]);
end

%% EYE
eyeRecordspath = 'C:\Users\ghosh\Desktop\eyeRecs';
neuralRecordsPath = '\\132.239.158.169\datanetOutput\375\neuralRecords';
trialRangeExpt = [44 44]; 
trialRangeCalib = [36 38]; 

eyeSigExpt = [];
timeExpt = [];
maxTime = 0;
for trialNum = trialRangeExpt(1):trialRangeExpt(end)
    dirStr=fullfile(eyeRecordspath,sprintf('eyeRecords_%d_*.mat',trialNum));
    d=dir(dirStr);
    timestamp = '';
    if length(d)==1
        % get the timestamp
        [matches tokens] = regexpi(d(1).name, 'eyeRecords_(\d+)_(.*)\.mat', 'match', 'tokens');
        if length(matches) ~= 1
            %         warning('not a neuralRecord file name');
        else
            timestamp = tokens{1}{2};
            eyeData=getEyeRecords(eyeRecordspath, trialNum,timestamp);
            [px py crx cry eyeTime]=getPxyCRxy(eyeData);
            currEyeSig=[crx-px cry-py];
            eyeSigExpt = [eyeSigExpt;currEyeSig];
            timeExpt = [timeExpt;eyeTime+maxTime];
            maxTime = max(timeExpt);
            
        end
    elseif length(d)>1
        disp('duplicates present. skipping trial');
    else
       disp('didnt find anything in d. skipping trial');
    end

end

eyeSigCalib = [];
timeCalib = [];
maxTime = 0;
for trialNum = trialRangeCalib(1):trialRangeCalib(end)
    dirStr=fullfile(eyeRecordspath,sprintf('eyeRecords_%d_*.mat',trialNum));
    d=dir(dirStr);
    timestamp = '';
    if length(d)==1
        neuralRecordFilename=d(1).name;
        % get the timestamp
        [matches tokens] = regexpi(d(1).name, 'eyeRecords_(\d+)_(.*)\.mat', 'match', 'tokens');
        if length(matches) ~= 1
            %         warning('not a neuralRecord file name');
        else
            timestamp = tokens{1}{2};
            eyeData=getEyeRecords(eyeRecordspath, trialNum,timestamp);
            [px py crx cry eyeTime]=getPxyCRxy(eyeData);
            currEyeSig=[crx-px cry-py];
            eyeSigCalib = [eyeSigCalib;currEyeSig];
            timeCalib = [timeCalib;eyeTime+maxTime];
            maxTime = max(timeCalib);
            
        end
    elseif length(d)>1
        disp('duplicates present. skipping trial');
    else
       disp('didnt find anything in d. skipping trial');
    end

end

%% plotting
% figure; hold on;
% plot(timeExpt,eyeSigExpt(:,1),'r');
figure;
xPosExpt = eyeSigExpt(:,1)-nanmean(eyeSigExpt(:,1));
yPosExpt = eyeSigExpt(:,2)-nanmean(eyeSigExpt(:,2));
which = xPosExpt>20;
xPosExpt(which) = [];
yPosExpt(which) = [];
timeExpt(which) = [];

whichOkay = (xPosExpt>-30)&(xPosExpt<60)&(yPosExpt>-40)&(yPosExpt<5);
xPosExpt(~whichOkay) = [];
yPosExpt(~whichOkay) = [];
lEyeSigExpt = length(xPosExpt); 
axExpt = axes;
[posCountsExpt binsExpt] = hist3([xPosExpt-mean(xPosExpt) yPosExpt-mean(yPosExpt)],[50 50]);
posProbExpt = posCountsExpt/lEyeSigExpt;
imagesc(posProbExpt);
% set(axExpt,'XTick',[1 50],'XTickLabel',{sprintf('%2.0f',binsExpt{1}(1)),sprintf('%2.0f',binsExpt{1}(end))},...
%     'YTick',[1 50],'YTickLabel',{sprintf('%2.0f',binsExpt{2}(1)),sprintf('%2.0f',binsExpt{2}(end))});
title('Sample eye signal. Rat 375, trialRange=[45:56]','FontSize',30);
xlabel('x Position','FontSize',30); ylabel('y Position','FontSize',30);
set(axExpt,'XTick',[],'YTick',[]);
set(axExpt,'FontSize',20);
xPosValsPerBin = (binsExpt{1}(end)-binsExpt{1}(1))/length(binsExpt{1});
xPosValsPerDeg = 1.6;
xPosDegPerBin = xPosValsPerBin/xPosValsPerDeg;
reqDeg = 1;
numBins = reqDeg/xPosDegPerBin;
hold on;plot([10 10+numBins], [10 10],'LineWidth',3,'Color','r');
colormap(gray)
% text(10+numBins/2,10,'\color{red}5^{\circ}','HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',20)
%% %Eye within some degree
% find bin with largest weight;
[indX indY] = ind2sub([50 50],find(posProbExpt==max(posProbExpt(:))));
reqDegs = [0 1 2 5 10 15];
totalWeightWithin = nan(size(reqDegs));
numBins = reqDegs/xPosDegPerBin;
for ind = 1:length(numBins)
    binSize = round(numBins(ind));
    totalWeightWithin(ind) = sum(sum(posProbExpt(indX-binSize:indX+binSize,indY-binSize:indY+binSize)));
end
figure; 
ax = axes;
plot(reqDegs,totalWeightWithin,'LineWidth',3);
set(ax,'XTick',[0 1 2 5 10 15],'YTick',[0.5 1],'fontSize',30) 
title('% eye position within');
xlabel('degrees','FontSize',30);
ylabel('fraction within','FontSize',30);
% scatter(xPosExpt,yPosExpt,'r','filled')
% 
% figure; hold on;
% plot(timeCalib,eyeSigCalib(:,1),'r');
% figure;
% xPosCalib = eyeSigCalib(:,1);
% yPosCalib = eyeSigCalib(:,2);
% lEyeSigCalib = length(xPosCalib); 
% axCalib = axes;
% [posCountsCalib binsCalib] = hist3(eyeSigCalib,[50 50]);
% posProbCalib = posCountsCalib/lEyeSigCalib;
% surf(posProbCalib);
% set(axCalib,'XTick',[1 50],'XTickLabel',{sprintf('%2.0f',binsCalib{1}(1)),sprintf('%2.0f',binsCalib{1}(end))},...
%     'YTick',[1 50],'YTickLabel',{sprintf('%2.0f',binsCalib{2}(1)),sprintf('%2.0f',binsCalib{2}(end))});
% title('Sample eye signal. Rat 375, trialRange=[36:38]','FontSize',30);
% xlabel('x Position'); ylabel('y Position');



%% SPATIAL FREQUENCY
% dataPath = '\\132.239.158.169\datanetOutput';
dataPath = '/home/balaji/Documents/work/datanetOutput';
sfRecUnits = {...
    {'375',1,[402 405]},...
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
%     {'375',1,[766 769]},...
%     {'375',1,[1200 1201]},...
%     {'375',1,[1379]},...
%     {'375',1,[1384],[]},...
    {'375',1,[1394 1395],[]},...
    {'375',1,[1397],[]}...
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
    plot((conversion*cVals),cA.pow(cOrder),'LineWidth',5);
    for i = 1:length(cVals)
        plot([conversion*cVals(i) conversion*cVals(i)] ,[cA.pow(cOrder(i))+cA.powSEM(cOrder(i)) cA.pow(cOrder(i))-cA.powSEM(cOrder(i))],'LineWidth',2,'LineStyle','--')
    end
    
    set(ax,'FontSize',20)
    xlabel('Aperture radius (deg)','FontSize',20);
    ylabel('f1(imp/s)','FontSize',20)
    title('Unit 1. 100% contrast','FontSize',20);

    % now plot the sf curve
    if ~isempty(areaTuning{unitNum}{4})
        conversion = 73/1024;
        Position = [0.5 0.45 0.4 0.4];
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
        plot((conversion*cVals),cA.pow(cOrder),'LineWidth',5);
        for i = 1:length(cVals)
            plot([conversion*cVals(i) conversion*cVals(i)] ,[cA.pow(cOrder(i))+cA.powSEM(cOrder(i)) cA.pow(cOrder(i))-cA.powSEM(cOrder(i))],'LineWidth',2,'LineStyle','--')
        end
        set(axSF,'FontSize',10,'YTick',max(cA.pow),'YTickLabel',sprintf('%2.0f',max(cA.pow)));

        xlabel('dpc','FontSize',20);
        ylabel('f1','FontSize',20)
        title('SF Tuning','FontSize',20);
    end
end

%% AREA SUMMATION
dataPath = '\\132.239.158.169\datanetOutput';
areaTuning = {...
    {'375',1,[1379],[1368]},...
    {'375',1,[1384],[]},...
%     {'375',1,[1394 1395],[]},...
%     {'375',1,[1397],[]}...
};

% plotting
f = figure;
ax = axes; hold on;
for unitNum = 1:length(areaTuning)
    
    conversion = 73/2;
    if length(areaTuning{unitNum}{3})>1
        analysisSubFolder = sprintf('%d-%d',areaTuning{unitNum}{3}(1),areaTuning{unitNum}{3}(2));
    else
        analysisSubFolder = sprintf('%d',areaTuning{unitNum}{3}(1));
    end
    analysisFile = fullfile(dataPath,areaTuning{unitNum}{1},'analysis',analysisSubFolder,'physAnalysis.mat');
    temp = load(analysisFile);
    cA = temp.physAnalysis{1}{1}.(createTrodeName(areaTuning{unitNum}{2}));
    [cVals cOrder] = sort(cA.stimInfo.vals);
    if unitNum==length(areaTuning)
        plot((conversion*cVals),cA.pow(cOrder),'LineWidth',5);
    else
        plot((conversion*cVals),cA.pow(cOrder),'LineWidth',3,'color',0.5*[1 1 1]);
    end
    if unitNum==length(areaTuning)
        for i = 1:length(cVals)
            plot([conversion*cVals(i) conversion*cVals(i)] ,[cA.pow(cOrder(i))+cA.powSEM(cOrder(i)) cA.pow(cOrder(i))-cA.powSEM(cOrder(i))],'LineWidth',2,'LineStyle','--')
        end
    end
    
    set(ax,'FontSize',20)
    xlabel('Aperture radius (deg)','FontSize',20);
    ylabel('f1(imp/s)','FontSize',20)
    title('Unit 3. 75% contrast; 37^{\circ} grating','FontSize',20);

%     % now plot the sf curve
%     if ~isempty(areaTuning{unitNum}{4})
%         conversion = 73/1024;
%         Position = [0.5 0.20 0.3 0.3];
%         axSF = axes('Position',Position); hold on;
%         if length(areaTuning{unitNum}{4})>1
%             analysisSubFolder = sprintf('%d-%d',areaTuning{unitNum}{4}(1),areaTuning{unitNum}{4}(2));
%         else
%             analysisSubFolder = sprintf('%d',areaTuning{unitNum}{4}(1));
%         end
%         analysisFile = fullfile(dataPath,areaTuning{unitNum}{1},'analysis',analysisSubFolder,'physAnalysis.mat');
%         temp = load(analysisFile);
%         cA = temp.physAnalysis{1}{1}.(createTrodeName(areaTuning{unitNum}{2}));
%         [cVals cOrder] = sort(cA.stimInfo.vals);
%         plot((conversion*cVals),cA.pow(cOrder),'LineWidth',5);
%         for i = 1:length(cVals)
%             plot([conversion*cVals(i) conversion*cVals(i)] ,[cA.pow(cOrder(i))+cA.powSEM(cOrder(i)) cA.pow(cOrder(i))-cA.powSEM(cOrder(i))],'LineWidth',2,'LineStyle','--')
%         end
%         set(axSF,'FontSize',10,'YTick',max(cA.pow),'YTickLabel',sprintf('%2.0f',max(cA.pow)));
% 
%         xlabel('dpc','FontSize',20);
%         ylabel('f1','FontSize',20)
%         title('SF Tuning','FontSize',20);
%     end
end

