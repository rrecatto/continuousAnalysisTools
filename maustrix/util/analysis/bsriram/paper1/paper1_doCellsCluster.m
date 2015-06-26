function paper1_doCellsCluster(db)
if ~exist('db','var')||isempty(db)
    db = neuronDB('bsPaper1');
end

%% rfSizes from wnAnalysis
params.excludeNIDs = 39;
rfSizes = getFacts(db,{{'binarySpatial','rfSize'},params});
xSizes = [];
ySizes = [];

xConvFactor = atan(52/30)*180/pi;%0.1 is 5.2 cm at 30 cm
yConvFactor = atan(33/30)*180/pi;%0.1 is 3.3 cm at 30 cm
for i = 1:length(rfSizes.results)
    xSizes(end+1) = rfSizes.results{i}(1)*xConvFactor;
    ySizes(end+1) = rfSizes.results{i}(2)*yConvFactor;
end
%% getWNRFData
rfData = getFacts(db,{{'binarySpatial','rawAnalysis'},params});
save('c:\Documents and Settings\Owner\My Documents\Dropbox\wnData','rfData');
%% get sfData
sfData = getFacts(db,{'sfGratings',{'f1','all'}});
save('c:\Documents and Settings\Owner\My Documents\Dropbox\sfData','sfData');
%% sfTuning maxVals looking at curtailed space
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = true;
% peakF1 = getFacts(db,{{'sfGratings',{'f1','maxValueAndLoc'}},params});
params.maxValAndLocForAllLessThan = 512;
peakF1 = getFacts(db,{{'sfGratings',{'f1','maxValAndLocForAllLessThan'}},params});

peakF1s = nan(1,length(peakF1.results));
valForPeak = nan(size(peakF1s));
for i = 1:length(peakF1.results)
    peakF1s(i) = peakF1.results{i}{1}{2};
    valForPeak(i) = peakF1.results{i}{1}{1};
end
xPix = 1920;
monitorWidth = 571.5; monitorHeight = 480;
distToMonitor = 300;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

%% compare the Two by nID
rfWN = nan(1,db.numNeurons);
rfSF = nan(1,db.numNeurons);

for i = 1:db.numNeurons
    % first find the sizes in wnAnalysis
    
    whichRFWN = rfSizes.nID==i;
    fprintf('neuron %d: ',i);
    if ~any(whichRFWN)
        fprintf('nan');
        unitDiaWN = nan;
    elseif length(find(whichRFWN))>1
        xThatSU=xSizes(whichRFWN);
        for j = 1:length(find(whichRFWN))
            fprintf('%2.2f deg;',xThatSU(j));
        end
        
        unitDiaWN = nanmean(xThatSU);
    else
        unitDiaWN = xSizes(whichRFWN);
        fprintf('%2.2f deg;',unitDiaWN);
    end
    fprintf('\n');
    rfWN(i) = unitDiaWN;
    
    % now the sfSize
    whichRFSF = peakF1.nID==i;
    if ~any(whichRFSF)
        unitDiaSF = nan;    
    elseif length(find(whichRFSF))>1
%         fprintf('neuron %d: ',i);
        for j = 1:length(find(whichRFSF))
%             fprintf('2.2f',valForPeak(j));
        end
%         fprintf('\n');
        unitDiaSF = nanmean(valForPeak(whichRFSF));
    else
        unitDiaSF = valForPeak(whichRFSF);
    end
    rfSF(i) = unitDiaSF;
end
figure; whitebg([1 1 1]);
plot(2*rfWN,rfSF*degPerPix/2,'bo','MarkerSize',7);
hold on; axis equal; axis([0 35 0 35]);
set(gca,'FontSize',20);
title('truncated Fs >0.05');
plot([0 35], [0 35],'k','LineWidth',2);

%% sfTuning maxVals looking at all space
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = true;
peakF1 = getFacts(db,{{'sfGratings',{'f1','maxValueAndLoc'}},params});
% params.maxValAndLocForAllLessThan = 512;
% peakF1 = getFacts(db,{{'sfGratings',{'f1','maxValAndLocForAllLessThan'}},params});

peakF1s = nan(1,length(peakF1.results));
valForPeak = nan(size(peakF1s));
for i = 1:length(peakF1.results)
    peakF1s(i) = peakF1.results{i}{1}{2};
    valForPeak(i) = peakF1.results{i}{1}{1};
end
xPix = 1920;
monitorWidth = 571.5; monitorHeight = 480;
distToMonitor = 300;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

%% compare the Two by nID
rfWN = nan(1,db.numNeurons);
rfSF = nan(1,db.numNeurons);

for i = 1:db.numNeurons
    % first find the sizes in wnAnalysis
    
    whichRFWN = rfSizes.nID==i;
    fprintf('neuron %d: ',i);
    if ~any(whichRFWN)
        fprintf('nan');
        unitDiaWN = nan;
    elseif length(find(whichRFWN))>1
        xThatSU=xSizes(whichRFWN);
        for j = 1:length(find(whichRFWN))
            fprintf('%2.2f deg;',xThatSU(j));
        end
        
        unitDiaWN = nanmean(xThatSU);
    else
        unitDiaWN = xSizes(whichRFWN);
        fprintf('%2.2f deg;',unitDiaWN);
    end
    fprintf('\n');
    rfWN(i) = unitDiaWN;
    
    % now the sfSize
    whichRFSF = peakF1.nID==i;
    if ~any(whichRFSF)
        unitDiaSF = nan;    
    elseif length(find(whichRFSF))>1
%         fprintf('neuron %d: ',i);
        for j = 1:length(find(whichRFSF))
%             fprintf('2.2f',valForPeak(j));
        end
%         fprintf('\n');
        unitDiaSF = nanmean(valForPeak(whichRFSF));
    else
        unitDiaSF = valForPeak(whichRFSF);
    end
    rfSF(i) = unitDiaSF;
end
figure; whitebg([1 1 1]);
plot(2*rfWN,rfSF*degPerPix/2,'bo','MarkerSize',7,'MarkerFaceColor','b');
hold on; axis equal; axis([0 35 0 35]);
set(gca,'FontSize',20);
title('entire Fs')
plot([0 35], [0 35],'k','LineWidth',2);

%% actually look at the rfs and the sfs
whichOK = ~isnan(rfWN)&~isnan(rfSF)&rfWN<10;
figure;whitebg([1 1 1])
hist(rfWN(whichOK),20); title('hist of rf sizes using wn')
group1 = find(rfWN>0&rfWN<3);
group2 = find(rfWN>=3&rfWN<5);
group3 = find(rfWN>=5&rfWN<10);
fprintf('intersect 1&2: %d\n',intersect(group1,group2));
fprintf('intersect 2&3: %d\n',intersect(group2,group3));
fprintf('intersect 1&3: %d\n',intersect(group1,group3));

params.includeNIDs = group1;
params.deleteDupIDs = false;
db.plotByAnalysis({{'binarySpatial','spatialModulation'},params});
db.plotByAnalysis({{'sfGratings','f1'},params});

params.includeNIDs = group2;
params.deleteDupIDs = false;
db.plotByAnalysis({{'binarySpatial','spatialModulation'},params});
db.plotByAnalysis({{'sfGratings','f1'},params});

params.includeNIDs = group3;
params.deleteDupIDs = false;
db.plotByAnalysis({{'binarySpatial','spatialModulation'},params});
db.plotByAnalysis({{'sfGratings','f1'},params});


end
