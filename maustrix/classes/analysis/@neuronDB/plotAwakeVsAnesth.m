function plotAwakeVsAnesth(db,which,params)
%which = {'sfGratings',{'F1'},vals,mode};
if ~exist('params','var')
    params = struct;
end

figHan = figure;
axHan = axes; hold on;
if ismember('excludeNIDs',fieldnames(params))
    selectionParams.excludeNIDs = params.excludeNIDs;
    
else
    selectionParams = struct;
end
[aInd nID subAInd]=selectIndexTool(db,which{1},selectionParams);
facts=db.getFlatFacts({'analysisType'});
anesthVals = [];
awakeVals = [];
which = which(2:end);
for i = 1:length(nID)
    % get the requested values
    results = getFacts(db.data{nID(i)}.analyses{subAInd(i)},which);
    if ~isempty(results)
        if length(results)>1 || length(results{1}{1})>2
            error('currently supports comparison of one feature at two values');
        end
        anesth = getAnesthesia(db.data{nID(i)}.analyses{subAInd(i)});
        dims = results{1}{1};
        vals = results{1}{2};
        if anesth==0
            awakeVals(end+1,:) = vals;
            
        else
            anesthVals(end+1,:) = vals;
        end
    end
end
plot(anesthVals(:,1),anesthVals(:,2),'r.','MarkerSize',5);
plot(awakeVals(:,1),awakeVals(:,2),'b.','MarkerSize',5);
mAnesth = nanmean(anesthVals,1);
mAwake = nanmean(awakeVals,1);
plot(mAnesth(1),mAnesth(2),'rd','MarkerSize',10);
plot(mAwake(1),mAwake(2),'bd','MarkerSize',10);

sAnesth = nanstd(anesthVals,[],1)/sqrt(size(anesthVals,1));
sAwake = nanstd(awakeVals,[],1)/sqrt(size(awakeVals,1));
plot([mAnesth(1)-sAnesth(1) mAnesth(1)+sAnesth(1)],[mAnesth(2) mAnesth(2)],'r','LineWidth',2);
plot([mAnesth(1) mAnesth(1)],[mAnesth(2)-sAnesth(2) mAnesth(2)+sAnesth(2)],'r','LineWidth',2);

plot([mAwake(1)-sAwake(1) mAwake(1)+sAwake(1)],[mAwake(2) mAwake(2)],'b','LineWidth',2);
plot([mAwake(1) mAwake(1)],[mAwake(2)-sAwake(2) mAwake(2)+sAwake(2)],'b','LineWidth',2);
rng = max(max([awakeVals;anesthVals]));
plot([0 rng],[0,rng],'k','LineWidth',2);
title(which{1}{1});
xlabel(sprintf('%2.0f',which{2}(1)));
ylabel(sprintf('%2.0f',which{2}(2)));

%% extra plotting
if isfield(params,'testingMode') && params.testingMode
    if false
        for i = 1:length(nID)
            fExtra = figure;
            db.data{nID(i)}.analyses{subAInd(i)}.plot2fig(fExtra,'default');
            titleStr = sprintf('n%d a%d',nID(i),subAInd(i));
            title(titleStr);
        end
    end
    if true
        figure; hold on
        anesRatios = anesthVals(:,1)./anesthVals(:,2);
        mAnesRs = nanmean(anesRatios);
        semAnesRs = nanstd(anesRatios)/sqrt(length(anesRatios));
        awakeRatios = awakeVals(:,1)./awakeVals(:,2);
        mAwakeRs = nanmean(awakeRatios);
        semAwakeRs = nanstd(awakeRatios)/sqrt(length(awakeRatios));
        plot([0.25*ones(size(anesthVals,1))],anesRatios,'b.');
        plot([0.75*ones(size(awakeVals,1))],awakeRatios,'r.');
        plot(0.25,mAnesRs,'bd');
        plot([0.25 0.25],[mAnesRs+semAnesRs mAnesRs-semAnesRs],'b')
        plot(0.75,mAwakeRs,'rd');
        plot([0.75 0.75],[mAwakeRs+semAwakeRs mAwakeRs-semAwakeRs],'r')
        
        axis([0 1 minmax([anesRatios;awakeRatios])]);
    end
    
end

end
