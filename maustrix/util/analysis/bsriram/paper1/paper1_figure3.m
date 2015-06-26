function paper1_figure3(db)
if ~exist('db','var')||isempty(db)
    db = neuronDB('bsPaper1');
end
%% fig 3a entire screen contrast

whichID = 1:db.numNeurons;
% whichID = [5];
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = true;
figs = db.plotByAnalysis({{'cntrGrating','f1'},params});
%% fig 3a get Data contrast
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.excludeNIDs = [13 26 50];
params.deleteDupIDs = true;
cntrVals = db.getFacts({{'cntrGrating',{'f1'}},params});
figure; axes; hold on;
f1s = nan(length(cntrVals.results),length(cntrVals.results{1}{1}{2}));
f1Norm = nan(length(cntrVals.results),length(cntrVals.results{1}{1}{2}));
contrasts = f1s;
for i = 1:length(cntrVals.results)
    contrasts(i,:) = cntrVals.results{i}{1}{1};
    f1s(i,:) = cntrVals.results{i}{1}{2};
%     if (any(isnan(f1s(i,:))))
%         keyboard
%     end
    f1Norm(i,:) = f1s(i,:)/max(f1s(i,:));
end

for i = 1:length(cntrVals.results)
    plot(contrasts(i,:),f1Norm(i,:),'color',0.8*[1 1 1],'LineWidth',1);    
end
f1Mean = nanmean(f1Norm);
f1Std = nanstd(f1Norm);
n = length(find(~isnan(f1Norm)));
plot(contrasts(1,:),f1Mean,'color',[1 0 0],'LineWidth',3);
plot(contrasts(1,:),f1Mean+f1Std/sqrt(n),'color',[1 0 0],'LineWidth',2,'LineStyle','--');
plot(contrasts(1,:),f1Mean-f1Std/sqrt(n),'color',[1 0 0],'LineWidth',2,'LineStyle','--');
