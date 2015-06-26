function COSYNE2011_plotWhiteNoise

%% % whiteNoise analysis
time2MaxDevFF = db.getFacts({'gaussianFullField','timeToMaxDev'});
params.excludeNIDs = [2 12 14 15 17 18 19 27 30 34 37 46 48 49];

[aindFF,nidFF,subaindFF] = db.selectIndexTool('gaussianFullField');
anesthFF = [];
for i = 1:length(aindFF)
    anesthFF(i) = db.data{nidFF(i)}.analyses{subaindFF(i)}.getAnesthesia;
end
anesthFF(isnan(anesthFF))=2;
time2MaxDevFF = cell2mat(time2MaxDevFF);
badsFF = ismember(nidFF,params.excludeNIDs);
anesthFF = anesthFF(~badsFF);
time2MaxDevFF = time2MaxDevFF(~badsFF);
aindFF = aindFF(~badsFF);
nidFF = nidFF(~badsFF);
subaindFF = subaindFF(~badsFF);

time2MaxDevSpat = db.getFacts({'binarySpatial','timeToMaxDev'});
[aindSpat,nidSpat,subaindSpat] = db.selectIndexTool('binarySpatial');
anesthSpat = [];
for i = 1:length(aindSpat)
    anesthSpat(i) = db.data{nidSpat(i)}.analyses{subaindSpat(i)}.getAnesthesia;
end
anesthSpat(isnan(anesthSpat))=2;
time2MaxDevSpat = cell2mat(time2MaxDevSpat);
badsSpat = ismember(nidSpat,params.excludeNIDs);
anesthSpat = anesthSpat(~badsSpat);
time2MaxDevSpat = time2MaxDevSpat(~badsSpat);
aindSpat = aindSpat(~badsSpat);
nidSpat = nidSpat(~badsSpat);
subaindSpat = subaindSpat(~badsSpat);


time2MaxDev = [time2MaxDevFF time2MaxDevSpat];
anesth = [anesthFF anesthSpat];
aind = [aindFF aindSpat];
nid = [nidFF nidSpat];
subaind = [subaindFF subaindSpat];


figure; axes;hold on;
plot([0 0],[-1.1 2.1],'color',brighten([0.1 0.1 0.1],0.9))
whichAwake = anesth==0;
awkTimes = time2MaxDev(whichAwake);
anesTimes = time2MaxDev(~whichAwake);

% hereon everythign is per analysis
badAnesTimes = anesTimes>0 | anesTimes<-150;
badAwkTimes = awkTimes>0 | awkTimes<-150;

mAwk = mean(awkTimes(~badAwkTimes));
sAwk = std(awkTimes(~badAwkTimes))/sqrt(length(awkTimes(~badAwkTimes)));
mAnes = mean(anesTimes(~badAnesTimes));
sAnes = std(anesTimes(~badAnesTimes))/sqrt(length(anesTimes(~badAnesTimes)));


% now plot the STAs on there.
% whichAwake?
awkCloseToMean = find(abs(awkTimes-mAwk)<abs(0.1*mAwk),1);
anesCloseToMean = find(abs(anesTimes-mAnes)<abs(0.1*mAnes),1);

% find corresponding nid,subaind
whichAwkToPlot = find((time2MaxDev==awkTimes(awkCloseToMean))&(~anesth),1);
whichAnesToPlot = find((time2MaxDev==anesTimes(anesCloseToMean))&(anesth),1);

nidAwk = nid(whichAwkToPlot);
nidAnes = nid(whichAnesToPlot);


subaindAwk = subaind(whichAwkToPlot);
subaindAnes = subaind(whichAnesToPlot);
nidAwk
nidAnes
[staAwk stvAwk semAwk] = db.data{nidAwk}.analyses{subaindAwk}.getTemporal;
[staAnes stvAnes semAnes] = db.data{nidAnes}.analyses{subaindAnes}.getTemporal;
tAwk = db.data{nidAwk}.analyses{subaindAwk}.getTimeWindow;
tAnes = db.data{nidAnes}.analyses{subaindAnes}.getTimeWindow;
tAwk = linspace(-tAwk(1),tAwk(2),length(staAwk));
tAnes = linspace(-tAnes(1),tAnes(2),length(staAnes));

% plot the traces first beyond 1 and below 0;
factorAwk = minmax([staAwk+semAwk;staAwk-semAwk]);
staAwkNorm = (staAwk)/(factorAwk(2)-factorAwk(1));
semAwkNorm = (semAwk)/(factorAwk(2)-factorAwk(1));
minAwk = min(staAwkNorm-semAwkNorm);

factorAnes = minmax([staAnes+semAnes;staAnes-semAnes]);
staAnesNorm = (staAnes)/(factorAnes(2)-factorAnes(1));
semAnesNorm = (semAnes)/(factorAnes(2)-factorAnes(1));
maxAnes = max(staAnesNorm+semAnesNorm);
plot([-300 50],[1.55 1.55],'color',brighten([0.1 0.1 0.1],0.9))
f1 = fill([tAwk tAwk(end:-1:1)]',[staAwkNorm+semAwkNorm-minAwk+1; flipud(staAwkNorm-semAwkNorm-minAwk+1)],brighten([0.1 0.1 0.8],0.8))
set(f1,'EdgeAlpha',0);
plot(tAwk,staAwkNorm-minAwk+1,'b','LineWidth',2);

plot([-300 50],[-0.6 -0.6 ],'color',brighten([0.1 0.1 0.1],0.9))
f2 = fill([tAnes tAnes(end:-1:1)]',[staAnesNorm+semAnesNorm-maxAnes; flipud(staAnesNorm-semAnesNorm-maxAnes)],brighten([0.8 0.1 0.1],0.8))
set(f2,'EdgeAlpha',0);
plot(tAnes,staAnesNorm-maxAnes,'r','LineWidth',2);

f3 = fill([mAwk-sAwk mAwk-sAwk mAwk+sAwk mAwk+sAwk],[0.625 0.875 0.875 0.625]',brighten([0.1 0.1 0.8],0.7));
set(f3,'EdgeAlpha',0);
plot(mAwk,0.75,'kd','MarkerSize',10,'MarkerFace','k');


f4 = fill([mAnes-sAnes mAnes-sAnes mAnes+sAnes mAnes+sAnes],[0.125 0.375 0.375 0.125]',brighten([0.8 0.1 0.1],0.7));
set(f4,'EdgeAlpha',0);

plot(mAnes,0.25,'kd','MarkerSize',10,'MarkerFace','k');
plot(awkTimes(~badAwkTimes),0.75+0.05*(rand(size(awkTimes(~badAwkTimes)))-0.5),'b.');
plot(anesTimes(~badAnesTimes),0.25+0.05*(rand(size(anesTimes(~badAnesTimes)))-0.5),'r.');


% for i = 1:length(time2MaxDev)
%     if anesth(i)
%         plot(0.75,time2MaxDev(i),'r.');
%     else
%         plot(0.25,time2MaxDev(i),'b.');
%     end
% end
axis([-300 50 -1.1 2.1]);
set(gca,'YTick',[0.25 0.75],'YTickLabel',{},'XTick',[-300 mAnes mAwk 0],'XTickLabel',{'-300',sprintf('%2.1f',mAnes),sprintf('%2.1f',mAwk),'spike!'})

% now plot the STAs on there.
% whichAwake?