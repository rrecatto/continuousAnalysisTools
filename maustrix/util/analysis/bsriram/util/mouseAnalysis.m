function out = mouseAnalysis(mouseID,dataLoc,saveLoc,split,data)
out = {};
if ~exist('dataLoc','var') ||isempty(dataLoc)
    dataLoc = 'C:\Users\ephys-data\Desktop\CompiledTrialRecords\';
end

if ~exist('saveLoc','var') ||isempty(saveLoc)
    saveLoc = 'C:\Users\ephys-data\Desktop\';
end

if ~exist('split','var') ||isempty(split)
    split = [];
end
% locate the analysis
if ~exist('data','var')
    d = dir(fullfile(dataLoc,sprintf('%s.compiledTrialRecords*',mouseID)));
    if length(d)>1
        error('too many');
    elseif length(d)<1
        error('too few');
    else
        % just right
        analysisName = d.name;
        data = load(fullfile(dataLoc,d.name));
    end
else
    % use the data from the inputs
end
allTrainingSteps = {'orOptimal','orSFSweep','orTFSweep','orCTRSweep','orORSweep'};

fOverall = figure;


% first filter with the split data to remove dates that are not requested
numdates= 0;
for i = 1:length(split)
    numdates = numdates+length(split{i});
end
alldates = cell(1,numdates);
numused = 0;
for i = 1:length(split)
    alldates(numused+1:numused+length(split{i})) = split{i};
    numused = numused+length(split{i});
end

% keep copy of data
dataOld = data;

data = filterBehaviorData(data,'date',alldates);

dataorOptimal = filterBehaviorData(data,'tsName','orOptimal'); numOpt = length(dataorOptimal.compiledTrialRecords.trialNumber);
dataCtrSweep = filterBehaviorData(data,'tsName','orCTRSweep'); numCtr = length(dataCtrSweep.compiledTrialRecords.trialNumber);
dataSFSweep = filterBehaviorData(data,'tsName','orSFSweep'); numSF = length(dataSFSweep.compiledTrialRecords.trialNumber);
dataTFSweep = filterBehaviorData(data,'tsName','orTFSweep'); numTF = length(dataTFSweep.compiledTrialRecords.trialNumber);
dataORSweep = filterBehaviorData(data,'tsName','orORSweep'); numOR = length(dataORSweep.compiledTrialRecords.trialNumber);

ax = subplot(2,1,1); hold on; % plot trials by day
dates = floor(data.compiledTrialRecords.date);
uniqdates = unique(dates);
dateseq = min(uniqdates):max(uniqdates);
trialsbydate = nan(size(dateseq));
for i = 1:length(dateseq)
    trialsbydate(i) = sum(dates==dateseq(i));
end
bar(dateseq,trialsbydate);
datelabels = cell(1,length(dateseq));
for i = 1:length(dateseq)
    if i == 1 || i==length(dateseq)
        datelabels{i} = datestr(dateseq(i),'dd-mmm');
    else
        datelabels{i} = '';
    end
end
set(ax,'xtick',dateseq,'xticklabel',datelabels,'xlim',[min(uniqdates)-1 max(uniqdates)+1]);xlabel('date');ylabel('numtrials'); title('trials by day');

ax = subplot(2,1,2); hold on;
bar([1:5],[numOpt numCtr numSF numTF numOR]);
set(ax,'xtick',[1:5],'xticklabel',{'opt','ctr','sf','tf','or'});xlabel('type');ylabel('numtrials'); title('trials by type');

% ok analyze one by one and split by type
if numOpt>300
    relevantData = dataorOptimal;
    fOpt = figure;
    axTr = subplot(2,2,1); hold on; % num trials
        xlabel('day'); ylabel('#trials/day');
    axOverall = subplot(2,2,2); hold on;
    axPerf = subplot(2,2,3:4);  hold on; % performance by day
    xlabel('day'); ylabel('%corr +/- CI');
    for i = 1:length(alldates)
        dataThatDate = filterBehaviorData(relevantData,'date',alldates{i});
        if ismember(alldates{i},split{1})
            c = 'g';
        elseif ismember(alldates{i},split{2})
            c = 'r';
        else
            c = [0.5 0.5 0.5];
        end
        axes(axTr);
        a = bar(datenum(alldates{i}),length(dataThatDate.compiledTrialRecords.trialNumber),c);
        
        % remove correct nans and corrections and plot % correct
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrectNANs');
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrections');
        [phatCurr pCICurr] = binofit(sum(dataThatDate.compiledTrialRecords.correct),length(dataThatDate.compiledTrialRecords.correct));
        plot(axPerf,datenum(alldates{i}),phatCurr,'color',c,'marker','d');
        plot(axPerf,[datenum(alldates{i}) datenum(alldates{i})],[pCICurr(1) pCICurr(2)],'color',c,'linewidth',3);
    end
    
    dataPBS = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{1}),'removeCorrectNANs'),'removeCorrections');
    dataCNO = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{2}),'removeCorrectNANs'),'removeCorrections');
    dataNone = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{3}),'removeCorrectNANs'),'removeCorrections');
    
    [phatPBS pCIPBS] = binofit(sum(dataPBS.compiledTrialRecords.correct),length(dataPBS.compiledTrialRecords.correct));
    [phatCNO pCICNO] = binofit(sum(dataCNO.compiledTrialRecords.correct),length(dataCNO.compiledTrialRecords.correct));
    [phatNone pCINone] = binofit(sum(dataNone.compiledTrialRecords.correct),length(dataNone.compiledTrialRecords.correct));
    
    plot(axOverall,1,phatPBS,'color','g','marker','d');plot(axOverall,[1 1],pCIPBS,'color','g','linewidth',3);
    plot(axOverall,2,phatCNO,'color','r','marker','d');plot(axOverall,[2 2],pCICNO,'color','r','linewidth',3);
    plot(axOverall,4,phatNone,'color',[0.5 0.5 0.5],'marker','d');plot(axOverall,[4 4],pCINone,'color',[0.5 0.5 0.5],'linewidth',3);
else
    % no analysis
end

if numCtr>300
    relevantData = dataCtrSweep;
    fCtr = figure;
    axTr = subplot(3,2,1); hold on; % num trials
        xlabel('day'); ylabel('#trials/day');
    axOverall = subplot(3,2,3:6); hold on;
    axPerf = subplot(3,2,2);  hold on; % performance by day
    xlabel('day'); ylabel('%corr +/- CI');
    for i = 1:length(alldates)
        dataThatDate = filterBehaviorData(relevantData,'date',alldates{i});
        if ismember(alldates{i},split{1})
            c = [0 1 0];
        elseif ismember(alldates{i},split{2})
            c = [1 0 0];
        else
            c = [0.5 0.5 0.5];
        end
        barh = bar(axTr,datenum(alldates{i}),length(dataThatDate.compiledTrialRecords.trialNumber));
        set(barh,'facecolor',c);
        % remove correct nans and corrections and plot % correct
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrectNANs');
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrections');
        [phatCurr pCICurr] = binofit(sum(dataThatDate.compiledTrialRecords.correct),length(dataThatDate.compiledTrialRecords.correct));
        if ~isnan(phatCurr)
            plot(axPerf,datenum(alldates{i}),phatCurr,'color',c,'marker','d','markerSize',5);
            plot(axPerf,[datenum(alldates{i}) datenum(alldates{i})],[pCICurr(1) pCICurr(2)],'color',c,'linewidth',3);
        end
    end
    
    dataPBS = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{1}),'removeCorrectNANs'),'removeCorrections');
    dataCNO = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{2}),'removeCorrectNANs'),'removeCorrections');
    dataNone = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{3}),'removeCorrectNANs'),'removeCorrections');
    
    % get the individual contrasts and split by contrast
    sweptParam = 'contrasts';
    sweptParamVals = relevantData.compiledDetails(1).records.(sweptParam);
    sweptParamValsPBS = dataPBS.compiledDetails(1).records.(sweptParam);
    sweptParamValsCNO = dataCNO.compiledDetails(1).records.(sweptParam);
    sweptParamValsNone = dataNone.compiledDetails(1).records.(sweptParam);
    
    
    uniqParamVals = unique(sweptParamVals);
    for i = 1:length(uniqParamVals)
        [phatPBS pCIPBS] = binofit(nansum(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i))),length(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i))));
        nPBS=length(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i)));
        [phatCNO pCICNO] = binofit(nansum(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i))),length(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i))));
        nCNO=length(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i)));
        [phatNone pCINone] = binofit(nansum(dataNone.compiledTrialRecords.correct(sweptParamValsNone==uniqParamVals(i))),length(dataNone.compiledTrialRecords.correct(sweptParamValsNone==uniqParamVals(i))));
        if ~isnan(phatPBS)
            plot(axOverall,uniqParamVals(i),phatPBS,'color','g','marker','d');plot(axOverall,[uniqParamVals(i) uniqParamVals(i)],pCIPBS,'color','g','linewidth',3);
        end
        if~isnan(phatCNO)
            plot(axOverall,uniqParamVals(i)+0.01,phatCNO,'color','r','marker','d');plot(axOverall,[uniqParamVals(i)+0.01 uniqParamVals(i)+0.01],pCICNO,'color','r','linewidth',3);
        end
        if ~isnan(phatPBS) && ~isnan(phatCNO)
            % check for agresti caffo
            pdiff = abs(phatPBS-phatCNO);
            za = 1.96;
            SE = sqrt((phatPBS*(1-phatPBS)/(nPBS+2))+(phatCNO*(1-phatCNO)/(nCNO+2)));
            if pdiff>za*SE %significant
                text(uniqParamVals(i)+0.05,(phatPBS+phatCNO)/2,'*');
            else
                % not significant....do nothing
            end
        end
        if ~isnan(phatNone)
            plot(axOverall,uniqParamVals(i)-0.01,phatNone,'color',[0.5 0.5 0.5],'marker','d');plot(axOverall,[uniqParamVals(i)-0.01 uniqParamVals(i)-0.01],pCINone,'color',[0.5 0.5 0.5],'linewidth',3);
        end
    end
else
    % no analysis
end

if numSF>300
    relevantData = dataSFSweep;
    fSF = figure;
    axTr = subplot(3,2,1); hold on; % num trials
        xlabel('day'); ylabel('#trials/day');
    axOverall = subplot(3,2,3:6); hold on;
    axPerf = subplot(3,2,2);  hold on; % performance by day
    xlabel('day'); ylabel('%corr +/- CI');
    for i = 1:length(alldates)
        dataThatDate = filterBehaviorData(relevantData,'date',alldates{i});
        if ismember(alldates{i},split{1})
            c = [0 1 0];
        elseif ismember(alldates{i},split{2})
            c = [1 0 0];
        else
            c = [0.5 0.5 0.5];
        end
        barh = bar(axTr,datenum(alldates{i}),length(dataThatDate.compiledTrialRecords.trialNumber));
        set(barh,'facecolor',c);
        % remove correct nans and corrections and plot % correct
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrectNANs');
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrections');
        [phatCurr pCICurr] = binofit(sum(dataThatDate.compiledTrialRecords.correct),length(dataThatDate.compiledTrialRecords.correct));
        if ~isnan(phatCurr)
            plot(axPerf,datenum(alldates{i}),phatCurr,'color',c,'marker','d','markerSize',5);
            plot(axPerf,[datenum(alldates{i}) datenum(alldates{i})],[pCICurr(1) pCICurr(2)],'color',c,'linewidth',3);
        end
    end
    
    dataPBS = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{1}),'removeCorrectNANs'),'removeCorrections');
    dataCNO = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{2}),'removeCorrectNANs'),'removeCorrections');
    dataNone = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{3}),'removeCorrectNANs'),'removeCorrections');
    
    % get the individual contrasts and split by contrast
    sweptParam = 'pixPerCycs';
    sweptParamVals = relevantData.compiledDetails(1).records.(sweptParam);
    sweptParamValsPBS = dataPBS.compiledDetails(1).records.(sweptParam);
    sweptParamValsCNO = dataCNO.compiledDetails(1).records.(sweptParam);
    sweptParamValsNone = dataNone.compiledDetails(1).records.(sweptParam);
    
    
    uniqParamVals = unique(sweptParamVals);
    for i = 1:length(uniqParamVals)
        [phatPBS pCIPBS] = binofit(nansum(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i))),length(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i))));
        nPBS=length(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i)));
        [phatCNO pCICNO] = binofit(nansum(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i))),length(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i))));
        nCNO=length(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i)));
        [phatNone pCINone] = binofit(nansum(dataNone.compiledTrialRecords.correct(sweptParamValsNone==uniqParamVals(i))),length(dataNone.compiledTrialRecords.correct(sweptParamValsNone==uniqParamVals(i))));
        if ~isnan(phatPBS)
            plot(axOverall,uniqParamVals(i),phatPBS,'color','g','marker','d');plot(axOverall,[uniqParamVals(i) uniqParamVals(i)],pCIPBS,'color','g','linewidth',3);
        end
        if~isnan(phatCNO)
            plot(axOverall,uniqParamVals(i)+0.01,phatCNO,'color','r','marker','d');plot(axOverall,[uniqParamVals(i)+0.01 uniqParamVals(i)+0.01],pCICNO,'color','r','linewidth',3);
        end
        if ~isnan(phatPBS) && ~isnan(phatCNO)
            % check for agresti caffo
            pdiff = abs(phatPBS-phatCNO);
            za = 1.96;
            SE = sqrt((phatPBS*(1-phatPBS)/(nPBS+2))+(phatCNO*(1-phatCNO)/(nCNO+2)));
            if pdiff>za*SE %significant
                text(uniqParamVals(i)+0.05,(phatPBS+phatCNO)/2,'*');
            else
                % not significant....do nothing
            end
        end
        if ~isnan(phatNone)
            plot(axOverall,uniqParamVals(i)-0.01,phatNone,'color',[0.5 0.5 0.5],'marker','d');plot(axOverall,[uniqParamVals(i)-0.01 uniqParamVals(i)-0.01],pCINone,'color',[0.5 0.5 0.5],'linewidth',3);
        end
    end
else
    % no analysis
end

if numTF>300
    relevantData = dataTFSweep;
    fTF = figure;
    axTr = subplot(3,2,1); hold on; % num trials
        xlabel('day'); ylabel('#trials/day');
    axOverall = subplot(3,2,3:6); hold on;
    axPerf = subplot(3,2,2);  hold on; % performance by day
    xlabel('day'); ylabel('%corr +/- CI');
    for i = 1:length(alldates)
        dataThatDate = filterBehaviorData(relevantData,'date',alldates{i});
        if ismember(alldates{i},split{1})
            c = [0 1 0];
        elseif ismember(alldates{i},split{2})
            c = [1 0 0];
        else
            c = [0.5 0.5 0.5];
        end
        barh = bar(axTr,datenum(alldates{i}),length(dataThatDate.compiledTrialRecords.trialNumber));
        set(barh,'facecolor',c);
        % remove correct nans and corrections and plot % correct
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrectNANs');
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrections');
        [phatCurr pCICurr] = binofit(sum(dataThatDate.compiledTrialRecords.correct),length(dataThatDate.compiledTrialRecords.correct));
        if ~isnan(phatCurr)
            plot(axPerf,datenum(alldates{i}),phatCurr,'color',c,'marker','d','markerSize',5);
            plot(axPerf,[datenum(alldates{i}) datenum(alldates{i})],[pCICurr(1) pCICurr(2)],'color',c,'linewidth',3);
        end
    end
    
    dataPBS = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{1}),'removeCorrectNANs'),'removeCorrections');
    dataCNO = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{2}),'removeCorrectNANs'),'removeCorrections');
    dataNone = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{3}),'removeCorrectNANs'),'removeCorrections');
    
    % get the individual contrasts and split by contrast
    sweptParam = 'driftfrequencies';
    sweptParamVals = relevantData.compiledDetails(1).records.(sweptParam);
    sweptParamValsPBS = dataPBS.compiledDetails(1).records.(sweptParam);
    sweptParamValsCNO = dataCNO.compiledDetails(1).records.(sweptParam);
    sweptParamValsNone = dataNone.compiledDetails(1).records.(sweptParam);
    
    
    uniqParamVals = unique(sweptParamVals);
    for i = 1:length(uniqParamVals)
        [phatPBS pCIPBS] = binofit(nansum(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i))),length(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i))));
        nPBS=length(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i)));
        [phatCNO pCICNO] = binofit(nansum(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i))),length(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i))));
        nCNO=length(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i)));
        [phatNone pCINone] = binofit(nansum(dataNone.compiledTrialRecords.correct(sweptParamValsNone==uniqParamVals(i))),length(dataNone.compiledTrialRecords.correct(sweptParamValsNone==uniqParamVals(i))));
        if ~isnan(phatPBS)
            plot(axOverall,uniqParamVals(i),phatPBS,'color','g','marker','d');plot(axOverall,[uniqParamVals(i) uniqParamVals(i)],pCIPBS,'color','g','linewidth',3);
        end
        if~isnan(phatCNO)
            plot(axOverall,uniqParamVals(i)+0.01,phatCNO,'color','r','marker','d');plot(axOverall,[uniqParamVals(i)+0.01 uniqParamVals(i)+0.01],pCICNO,'color','r','linewidth',3);
        end
        if ~isnan(phatPBS) && ~isnan(phatCNO)
            % check for agresti caffo
            pdiff = abs(phatPBS-phatCNO);
            za = 1.96;
            SE = sqrt((phatPBS*(1-phatPBS)/(nPBS+2))+(phatCNO*(1-phatCNO)/(nCNO+2)));
            if pdiff>za*SE %significant
                text(uniqParamVals(i)+0.05,(phatPBS+phatCNO)/2,'*');
            else
                % not significant....do nothing
            end
        end
        if ~isnan(phatNone)
            plot(axOverall,uniqParamVals(i)-0.01,phatNone,'color',[0.5 0.5 0.5],'marker','d');plot(axOverall,[uniqParamVals(i)-0.01 uniqParamVals(i)-0.01],pCINone,'color',[0.5 0.5 0.5],'linewidth',3);
        end
    end
else
    % no analysis
end

if numOR>300
    relevantData = dataORSweep;
    fOR = figure;
    axTr = subplot(3,2,1); hold on; % num trials 
    xlabel('day'); ylabel('#trials/day');
    axOverall = subplot(3,2,3:6); hold on;
    axPerf = subplot(3,2,2);  hold on; % performance by day
    xlabel('day'); ylabel('%corr +/- CI');
    for i = 1:length(alldates)
        dataThatDate = filterBehaviorData(relevantData,'date',alldates{i});
        if ismember(alldates{i},split{1})
            c = [0 1 0];
        elseif ismember(alldates{i},split{2})
            c = [1 0 0];
        else
            c = [0.5 0.5 0.5];
        end
        barh = bar(axTr,datenum(alldates{i}),length(dataThatDate.compiledTrialRecords.trialNumber));
        set(barh,'facecolor',c);
        % remove correct nans and corrections and plot % correct
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrectNANs');
        dataThatDate = filterBehaviorData(dataThatDate,'removeCorrections');
        [phatCurr pCICurr] = binofit(sum(dataThatDate.compiledTrialRecords.correct),length(dataThatDate.compiledTrialRecords.correct));
        if ~isnan(phatCurr)
            plot(axPerf,datenum(alldates{i}),phatCurr,'color',c,'marker','d','markerSize',5);
            plot(axPerf,[datenum(alldates{i}) datenum(alldates{i})],[pCICurr(1) pCICurr(2)],'color',c,'linewidth',3);
        end
    end
    
    dataPBS = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{1}),'removeCorrectNANs'),'removeCorrections');
    dataCNO = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{2}),'removeCorrectNANs'),'removeCorrections');
    dataNone = filterBehaviorData(filterBehaviorData(filterBehaviorData(relevantData,'date',split{3}),'removeCorrectNANs'),'removeCorrections');
    
    % get the individual contrasts and split by contrast
    sweptParam = 'orientations';
    sweptParamVals = relevantData.compiledDetails(1).records.(sweptParam);
    sweptParamValsPBS = dataPBS.compiledDetails(1).records.(sweptParam);
    sweptParamValsCNO = dataCNO.compiledDetails(1).records.(sweptParam);
    sweptParamValsNone = dataNone.compiledDetails(1).records.(sweptParam);
    
    % orientations is a little different. We are going to assume that the
    % relevant dimension is the angle form the vertical on either
    % direction.
    
    sweptParamValsPBS = abs(sweptParamValsPBS);sweptParamValsPBS = mod(sweptParamValsPBS,pi);
    sweptParamValsCNO = abs(sweptParamValsCNO);sweptParamValsCNO = mod(sweptParamValsCNO,pi);
    sweptParamValsNone = abs(sweptParamValsNone);sweptParamValsNone = mod(sweptParamValsNone,pi);
    
    
    uniqParamVals = unique(sweptParamVals);
    for i = 1:length(uniqParamVals)
        [phatPBS pCIPBS] = binofit(nansum(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i))),length(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i))));
        nPBS=length(dataPBS.compiledTrialRecords.correct(sweptParamValsPBS==uniqParamVals(i)));
        [phatCNO pCICNO] = binofit(nansum(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i))),length(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i))));
        nCNO=length(dataCNO.compiledTrialRecords.correct(sweptParamValsCNO==uniqParamVals(i)));
        [phatNone pCINone] = binofit(nansum(dataNone.compiledTrialRecords.correct(sweptParamValsNone==uniqParamVals(i))),length(dataNone.compiledTrialRecords.correct(sweptParamValsNone==uniqParamVals(i))));
        if ~isnan(phatPBS)
            plot(axOverall,uniqParamVals(i)*180/pi,phatPBS,'color','g','marker','d');
            plot(axOverall,[uniqParamVals(i)*180/pi uniqParamVals(i)*180/pi],pCIPBS,'color','g','linewidth',3);
        end
        if~isnan(phatCNO)
            plot(axOverall,(uniqParamVals(i)+0.01)*180/pi,phatCNO,'color','r','marker','d');
            plot(axOverall,[(uniqParamVals(i)+0.01)*180/pi (uniqParamVals(i)+0.01)*180/pi],pCICNO,'color','r','linewidth',3);
        end
        if ~isnan(phatPBS) && ~isnan(phatCNO)
            % check for agresti caffo
            pdiff = abs(phatPBS-phatCNO);
            za = 1.96;
            SE = sqrt((phatPBS*(1-phatPBS)/(nPBS+2))+(phatCNO*(1-phatCNO)/(nCNO+2)));
            if pdiff>za*SE %significant
                text(uniqParamVals(i)+0.05,(phatPBS+phatCNO)/2,'*');
            else
                % not significant....do nothing
            end
        end
        if ~isnan(phatNone)
            plot(axOverall,(uniqParamVals(i)-0.01)*180/pi,phatNone,'color',[0.5 0.5 0.5],'marker','d');
            plot(axOverall,[(uniqParamVals(i)-0.01)*180/pi (uniqParamVals(i)-0.01)*180/pi],pCINone,'color',[0.5 0.5 0.5],'linewidth',3);
        end
    end
    xlabel('deviation from the vertical(degrees)');ylabel('pCorrect +/- CI');
else
    % no analysis
end

end