function paper1_figure1(db)
if ~exist('db','var')||isempty(db)
    db = neuronDB({'bsPaper1','latest'});
end
%% plot everything
whichID = 1:db.numNeurons; %[37];%5
whichID = 1:10;
params = [];
params.includeNIDs = whichID;
% params.excludeNIDs = [13 28 38 52 53 33 36 39 40 47];
params.deleteDupIDs = false;
rawAnalysis = db.plotByAnalysis({{'binarySpatial','spatioTemporalContext'},params});
% rawAnalysis = db.plotByAnalysis({{'binarySpatial','Temporal'},params});
%% plot funky
whichID = 1:db.numNeurons;%1:db.numNeurons;
params = [];
params.includeNIDs = 6%[13 28 38 52 53 33 36 40 47];
params.excludeNIDs = 39;
params.deleteDupIDs = true;
rawAnalysis = db.plotByAnalysis({{'binarySpatial','Temporal'},params});
%% fig 1a entire screen
whichID = 14;%1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.excludeNIDs = [13 52 53 40 47];
params.deleteDupIDs = false;
rawAnalysis = db.getFacts({{'binarySpatial','rawAnalysis'},params});
imON = rawAnalysis.results{1}.im_centre;
imOFF = rawAnalysis.results{1}.im_surround;
figure; ax = axes; hold on;
% for i = 1:size(imON,1)
%     for j = 1:size(imON,2)
%         rectangle('Position',[j-1,i-1,1 1],'FaceColor',[imON(i,j)/max(imON(:)) 0 imOFF(i,j)/max(imOFF(:))],'EdgeColor','none');
%     end
% end
nX = size(imON,1); nY = size(imON,2);
xi = linspace(1/nX,1-1/nX,nX);yi = linspace(1/nY,1-1/nY,nY);
[X Y] = meshgrid(yi,xi);
% on or off?
imFit = (imON-128);
if abs(min(imFit(:)))>abs(max(imFit(:)))
    fact = -1; %off
    colScale = -1/min(imFit(:));
else
    fact = 1; %on
    colScale = 1/max(imFit(:));
end

usingrect = true;
if usingrect
    for i = 1:size(imON,1)
        for j = 1:size(imON,2)
            valij = imON(i,j);
            if valij>128
                col = colScale*(valij-128)*[1 0 0];
            else
                col = colScale*(128-valij)*[0 0 1];
            end
            rectangle('Position',[1/nY*(j-1),1/nX*(i-1),1/nY,1/nX],'EdgeColor','k','FaceColor',col);
        end
    end
else
    imagesc(X(:),flipud(Y(:)),flipud(imON));colormap(blueToRed(128,minmax(imON(:)),true));
end
% ON/OFF?

ellipseLoc = autoGaussianSurfML(X,Y,imFit*fact);
hold on; 
el = ellipse(ellipseLoc.sigmax,ellipseLoc.sigmay,0,ellipseLoc.x0,ellipseLoc.y0,0.3*[0 1 0]);
set(el,'LineWidth',3);
el = ellipse(2*ellipseLoc.sigmax,2*ellipseLoc.sigmay,0,ellipseLoc.x0,ellipseLoc.y0,0.3*[0 1 0]);
set(el,'LineWidth',1);

plot(ellipseLoc.x0,ellipseLoc.y0,'color',0.3*[0 1 0],'Marker','+');

imOFF(i,j)/max(imOFF(:))

axis tight
%% fig 1b Context
whichID = 14;%1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = true;
figs = db.plotByAnalysis({{'binarySpatial','SpatioTemporalContext'},params});
%% fig 1c Temporal
whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
figs = db.plotByAnalysis({{'binarySpatial','Temporal'},params});

%% fig 1d x vs y scatter centres
rfCenters = getFacts(db,{'binarySpatial','rfCenter'});
figure;
axHan = axes; whitebg([0 0 0]);  hold on;
xCentres = nan(1,length(rfCenters.results));
yCentres = nan(1,length(rfCenters.results));

for i = 1:length(rfCenters.results)
    xCentres(i) = rfCenters.results{i}(1);
    yCentres(i) = rfCenters.results{i}(2);
    plot(xCentres(i),yCentres(i),'y+');
end
axis([0 1 0 1]);
figure; 
subplot(2,1,1);
hist(xCentres); axis([0 1 0 20]);
subplot(2,1,2);
hist(yCentres); axis([0 1 0 20])

%% fig 1e calculate hist sizes
params.includeNIDs = 1:db.numNeurons; 
params.excludeNIDs = [13 39 52 53 40 47];
rfSizes = getFacts(db,{{'binarySpatial','rfSize'},params});
xSizes = [];
ySizes = [];
xConvFactor = atan(52/30)*180/pi;%0.1 is 5.2 cm at 30 cm
yConvFactor = atan(33/30)*180/pi;%0.1 is 3.3 cm at 30 cm
for i = 1:length(rfSizes.results)
    xSizes(end+1) = rfSizes.results{i}(1)*xConvFactor;
    ySizes(end+1) = rfSizes.results{i}(2)*yConvFactor;
end

%% plot hist sizes
% figure; whitebg([1 1 1]);
whichOK = xSizes<15 & ySizes<15;
subplot(2,2,1); hist(xSizes,20);title('x(deg)')
subplot(2,2,2); hist(ySizes,20);title('y(deg)')
subplot(2,2,3); 
figure; scatter(xSizes(whichOK),ySizes(whichOK));
hold on; 
plot([0 15],[0 15],'k','LineWidth',2); 
axis([0 10 0 10]);axis square;
set(gca,'XTick',[0 10],'YTick',[0 10],'XTickLabel',{'0','10'},'YTickLabel',{'','10'})
title('x vs y','FontSize',14);
xlabel(sprintf('x%c',char(176)),'FontSize',14);
ylabel(sprintf('y%c',char(176)),'FontSize',14);
set(gca,'FontSize',14)
%subplot(2,2,1:2); 
figure;
[histSize xi] = hist(xSizes(whichOK),30);
kde = ksdensity(xSizes(whichOK),xi);
% hist(xSizes(whichOK),40);hold on;plot(xi,kde*sum(histSize),'g','LineWidth',2);
plotyy(xi,histSize,xi,kde,@bar,@line)
title(sprintf('x(in %c)',char(176)),'FontSize',14);

%% get the correlations
figure;ax = axes;
nSamples=10000;
corrCoeff=nan(1,nSamples);
numAnalyses =length(xSizes(whichOK));
xOK = xSizes(whichOK);
yOK = ySizes(whichOK);
for i = 1:nSamples
    xThisSample = xOK(randperm(numAnalyses));
    yThisSample = xOK(randperm(numAnalyses));
    coefThis = corrcoef(xThisSample,yThisSample);
    corrCoeff(i) = coefThis(1,2);
end
[n,x]=hist(corrCoeff,100);
actualCorr = corrcoef(xOK,yOK);
actualCorr = actualCorr(1,2);
hold on;
histfill = fill([x fliplr(x)],[n/nSamples zeros(1,length(n))],'b'); 
plot([actualCorr actualCorr],[0 .01],'r');

%% fig 1f hist speed
rfSpeed = getFacts(db,{'binarySpatial','timeToMaxDev'});
figure; whitebg([1 1 1]);
speeds = nan(1,length(rfSpeed.results));
for i = 1:length(speeds)
    speeds(i) = rfSpeed.results{i};
end
speeds(speeds>0|speeds<-200) = [];
hist(speeds,5);

%% call reAnalysis using a fraction of the spikes.
tic
timeAnalysis = [];
whichID = 1;
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
[aInd nID subAInd]=selectIndexTool(db,'binarySpatial',params);
saveLoc = 'C:\Documents and Settings\Owner\My Documents\Dropbox';
for i =1:length(nID)
    tic;
    p.spikeFractions = [0.5 0.6 0.7 0.8 0.9 0.95];
    p.numRepeats = [100 100 100 100 100 100];
    out{i} = db.data{nID(i)}.analyses{subAInd(i)}.estimateErrorOnRF(p);
    currCellName = sprintf('n%d_a%d.mat',nID(i),subAInd(i));
    currCell = out{i};
    save(fullfile(saveLoc,currCellName),'currCell');
    timeAnalysis(end+1) = toc;
end
toc
%% reload analyses
saveLoc = 'C:\Documents and Settings\Owner\My Documents\Dropbox\wnResamplingAnalyses';
d = dir(saveLoc);
d = d(~ismember({d.name},{'.','..'}));

whichID = 1:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.excludeNIDs = [13 39 52 53 40 47];
params.deleteDupIDs = false;
[aInd nID subAInd]=selectIndexTool(db,'binarySpatial',params);

out = {};
for i = 1:length(nID)
    analysisName = sprintf('n%d_a%d.mat',nID(i),subAInd(i));
    if ~ismember({d.name},analysisName)
        disp('\n did not find the required file...\n');
        keyboard
        out{i}  = struct;
        continue;
    else
        temp = load(fullfile(saveLoc,analysisName));
%         keyboard
        out{i} = temp.currCell;
    end
end
%% just plotting
xConvFactor = atan(52/30)*180/pi;%0.1 is 5.2 cm at 30 cm
screen_size = get(0, 'ScreenSize');
whichGOOD = false(1,length(out)); % <10%
whichOK = false(1,length(out)); %>10 <25%
whichBAD = false(1,length(out));%>25%

for i = 1:length(out)
    figure(ceil(i/30));
    set(gcf, 'Position', [0 0 screen_size(3) screen_size(4)]);
    drawnow;
    pause(0.01);
    if mod(i,30)
        subplot(5,6,mod(i,30));
    else
        subplot(5,6,30);
    end
    title(sprintf('n%d_a%d',nID(i),subAInd(i)));
    if length(out{i}) ~=6
        text(0.5,0.5,'empty');
        continue;
    end
    nSpikes =[out{i}.numSpikes];
    rXs = [out{i}.rX];
    plot(nSpikes,rXs*xConvFactor,'b.');
    pFit = polyfit(nSpikes,xConvFactor*rXs,1); % 1 degree fit
    rMinSpikes = polyval(pFit,min(nSpikes));
    rMaxSpikes = polyVal(pFit,max(nSpikes));
    hold on;
    percentChange = (rMaxSpikes-rMinSpikes)/min(rMinSpikes,rMaxSpikes)*100;
    limx = xlim; limy = ylim;
    percentChange
%     keyboard
    
    
    if abs(percentChange) <10
        whichGOOD(i) = true;
        text(limx(2),limy(2),sprintf('%2.2f',percentChange),'HorizontalAlignment','right','VerticalAlignment','top');
        plot([min(nSpikes) max(nSpikes)],[rMinSpikes rMaxSpikes],'g','LineWidth',2);
    elseif abs(percentChange) <25
        whichOK(i) = true;
        text(limx(2),limy(2),sprintf('%2.2f',percentChange),'HorizontalAlignment','right','VerticalAlignment','top');
        plot([min(nSpikes) max(nSpikes)],[rMinSpikes rMaxSpikes],'y','LineWidth',2);
    else
        whichBAD(i) = true;
        text(limx(2),limy(2),sprintf('%2.2f',percentChange),'HorizontalAlignment','right','VerticalAlignment','top');
        plot([min(nSpikes) max(nSpikes)],[rMinSpikes rMaxSpikes],'r','LineWidth',2);
    end
end

%% plot fractions goods, OKs and bads
nGood = length(find(whichGOOD));
nBad = length(find(whichBAD));
nOK = length(find(whichOK));
pie([nGood,nBad,nOK]);

%% plotting the histogram of sizes of receptive fields
goods = out(whichGOOD);
oks = out(whichOK);
bads = out(whichBAD);

goodRxs = nan(1,length(goods));
for i = 1:length(goods)
    goodRxs(i) = xConvFactor*mean(goods{i}(1).rX);
end
okRxs = nan(1,length(oks));
for i = 1:length(oks)
    okRxs(i) = xConvFactor*mean(oks{i}(1).rX);
end
badRxs = nan(1,length(bads));
for i = 1:length(bads)
    badRxs(i) = xConvFactor*mean(bads{i}(1).rX);
end

rngRxs = minmax([goodRxs okRxs badRxs]);
edges = linspace(0,20,20);
% edges = linspace(rngRxs(1),rngRxs(2),20)
hGood = histc(goodRxs,edges);
hOk = histc(okRxs,edges);
hBad = histc(badRxs,edges);
hNotBad = histc([goodRxs okRxs],edges);
% barSize = bar(edges,[hGood;hOk;hBad]','stacked');
barSize = bar(edges,hNotBad,'stacked');
set(barSize,'LineStyle','none')

%% plotting and saving as svg
for j = 1:length(out)
    currCellName = sprintf('n%d_a%d.svg',nID(j),subAInd(j));
    currCell = out{j};    
    figNum = figure;
    x = [currCell.fraction];
    subplot(2,2,1),hold on;
    yVal =nan(size(x));
    ySD = yVal;
    for i = 1:length(yVal)
        yVal(i) = nanmean(currCell(i).cenX);
        ySD(i) = nanstd(currCell(i).cenX);
    end
    plot(x,yVal,'bs','MarkerSize',5,'MarkerFaceColor','b');
    plot(x,yVal,'b','LineWidth',3);
    for i = 1:length(yVal)
        plot([x(i) x(i)],[yVal(i)-ySD(i) yVal(i)+ySD(i)],'b','LineWidth',2);
    end
    xlim([0.45 1]);
    yLims = ylim;
    actualYVal = yVal(end);
    yMaxDev = (yLims(2)-actualYVal)/actualYVal*100;
    yMinDev = (yLims(1)-actualYVal)/actualYVal*100;
    set(gca,'XTick',[0.5 0.6 0.7 0.8 0.9 0.95],'XTickLabel',[0.5 0.6 0.7 0.8 0.9 0.95]);
    yTickLabels = {sprintf('%2.1f',yMinDev),'0',sprintf('%2.1f',yMaxDev)};
    set(gca,'YTick',[yLims(1) actualYVal yLims(2)],'YTickLabel',yTickLabels);
    ylim(yLims)
    title('cenX')
    xlabel('% spikes');ylabel('% change')
    
    subplot(2,2,2),hold on;
    yVal =nan(size(x));
    ySD = yVal;
    for i = 1:length(yVal)
        yVal(i) = nanmean(currCell(i).cenY);
        ySD(i) = nanstd(currCell(i).cenY);
    end
    plot(x,yVal,'bs','MarkerSize',5,'MarkerFaceColor','b');
    plot(x,yVal,'b','LineWidth',3);
    for i = 1:length(yVal)
        plot([x(i) x(i)],[yVal(i)-ySD(i) yVal(i)+ySD(i)],'b','LineWidth',2);
    end
    xlim([0.45 1]);
    yLims = ylim;
    actualYVal = yVal(end);
    yMaxDev = (yLims(2)-actualYVal)/actualYVal*100;
    yMinDev = (yLims(1)-actualYVal)/actualYVal*100;
    set(gca,'XTick',[0.5 0.6 0.7 0.8 0.9 0.95],'XTickLabel',[0.5 0.6 0.7 0.8 0.9 0.95]);
    yTickLabels = {sprintf('%2.1f',yMinDev),'0',sprintf('%2.1f',yMaxDev)};
    set(gca,'YTick',[yLims(1) actualYVal yLims(2)],'YTickLabel',yTickLabels);
    ylim(yLims)
    xlabel('% spikes');ylabel('% change')
    title('cenY')
    
    subplot(2,2,3),hold on;
    yVal =nan(size(x));
    ySD = yVal;
    for i = 1:length(yVal)
        yVal(i) = nanmean(currCell(i).rX);
        ySD(i) = nanstd(currCell(i).rX);
    end
    plot(x,yVal,'bs','MarkerSize',5,'MarkerFaceColor','b');
    plot(x,yVal,'b','LineWidth',3);
    for i = 1:length(yVal)
        plot([x(i) x(i)],[yVal(i)-ySD(i) yVal(i)+ySD(i)],'b','LineWidth',2);
    end
    xlim([0.45 1]);
    yLims = ylim;
    actualYVal = yVal(end);
    yMaxDev = (yLims(2)-actualYVal)/actualYVal*100;
    yMinDev = (yLims(1)-actualYVal)/actualYVal*100;
    set(gca,'XTick',[0.5 0.6 0.7 0.8 0.9 0.95],'XTickLabel',[0.5 0.6 0.7 0.8 0.9 0.95]);
    yTickLabels = {sprintf('%2.1f',yMinDev),'0',sprintf('%2.1f',yMaxDev)};
    set(gca,'YTick',[yLims(1) actualYVal yLims(2)],'YTickLabel',yTickLabels);
    ylim(yLims)
    xlabel('% spikes');ylabel('% change');title('rX')
    
    subplot(2,2,4),hold on;
    yVal =nan(size(x));
    ySD = yVal;
    for i = 1:length(yVal)
        yVal(i) = nanmean(currCell(i).rY);
        ySD(i) = nanstd(currCell(i).rY);
    end
    plot(x,yVal,'bs','MarkerSize',5,'MarkerFaceColor','b');
    plot(x,yVal,'b','LineWidth',3);
    for i = 1:length(yVal)
        plot([x(i) x(i)],[yVal(i)-ySD(i) yVal(i)+ySD(i)],'b','LineWidth',2);
    end
    xlim([0.45 1]);
    yLims = ylim;
    actualYVal = yVal(end);
    yMaxDev = (yLims(2)-actualYVal)/actualYVal*100;
    yMinDev = (yLims(1)-actualYVal)/actualYVal*100;
    set(gca,'XTick',[0.5 0.6 0.7 0.8 0.9 0.95],'XTickLabel',[0.5 0.6 0.7 0.8 0.9 0.95]);
    yTickLabels = {sprintf('%2.1f',yMinDev),'0',sprintf('%2.1f',yMaxDev)};
    set(gca,'YTick',[yLims(1) actualYVal yLims(2)],'YTickLabel',yTickLabels);
    ylim(yLims)
    xlabel('% spikes');ylabel('% change');title('rY');
    plot2svg(currCellName,figNum);
    close(figNum);
end
%% plot statistics separately
saveLoc = '/home/balaji/bsriram-wkstn-Public/subSampleData';
saveLoc1 = '/home/balaji/Desktop'
d = dir(saveLoc);
d = d(~ismember({d.name},{'.','..'})); % remove the useless stuff
for i = 1:length(d)
    figNum = figure;
    disp(i);
    clear('currCell');
    load(fullfile(saveLoc,d(i).name)); % becomes currCell
%     who
%     keyboard
    fractions = [currCell.fraction];
    numSpikes = nan(length(fractions),currCell(1).numRepeats); % assuming same number of repeats in each case
    rX = numSpikes;
    rY = numSpikes;
    cenX = numSpikes;
    cenY = numSpikes;
    for j = 1:length(currCell)
        numSpikes(j,:) =currCell(j).numSpikes;
        rX(j,:) =currCell(j).rX;
        rY(j,:) =currCell(j).rY;
        cenX(j,:) = currCell(j).cenX;
        cenY(j,:) = currCell(j).cenY;
    end
    subplot(2,2,1);hist(numSpikes(:),100);title('hist(numSpikes)')
    subplot(2,2,2);scatter(numSpikes(:),rX(:),'b.');hold on;scatter(numSpikes(:),rY(:),'r.');title('numSpikes vs. rX/rY'); %title('numSpikes vs. \color{blue}rX\color{black}/\color{red}rY');
    subplot(2,2,3);scatter(numSpikes(:),cenX(:),'b.');hold on;scatter(numSpikes(:),cenY(:),'r.');title('numSpikes vs. cenX/cenY'); %title('numSpikes vs. \color{blue}cenX\color{black}/\color{red}cenY');
    subplot(2,2,4);scatter(rX(:),cenX(:),'b.');hold on;scatter(rY(:),cenY(:),'r.');title('rX vs cenX and rY vs cenY'); %title('\color{blue}rX vs cenX \color{black}; \color{red}rY vs CenY')
    
    filename = regexp(d(i).name,'.mat','split');
    filename = [filename{1} '.svg'];
    plot2svg(fullfile(saveLoc1,filename),figNum);
    close(figNum);
end


%% TemporalKernelAtHighPrecision
params.includeNIDs = 1:db.numNeurons;
params.excludeNIDs = [];
params.deleteDupIDs = false;
[aInd nID subAInd] = db.selectIndexTool('all',params);
facts=db.getFlatFacts({'analysisType'});
which = ismember(facts.analysisType,{'binarySpatial'});%& (nID>39)';
nID = nID(which); aInd = aInd(which); subAInd = subAInd(which);
out(length(nID)).sta = [];
out(length(nID)).stv = [];
out(length(nID)).numSpikes = [];
% something is failing

actualNIDs =...
    [1 1 2 3 3 4 5 6 6 7 ...
    7 8 9 10 11 11 12 13 14 14 ...
    15 16 17 18 18 19 21 22 23 26 ...
    27 28 29 29 30 31 32 32 33 34 ...
    35 36 36 37 38 39 39 40 41 42 ...
    42 43 43 45 46 47 48 49 50 51 ...
    52 53 54 55 56 57 57 58 58 59 ...
    59 60 61 62 63 63];
for i = 1:length(nID)
    n = nID(i)
    a = subAInd(i)
    p.mode = 'center'
    p.precisionInMS = 1;
    p.channels = 1;
    [out(i).sta out(i).stv out(i).numSpikes] = db.data{nID(i)}.analyses{subAInd(i)}.getTemporalKernelAtHighPrecision(p);
end
%%
timesON = [];timesOFF = [];
times = [];
mode = 'maxDev';
mode = 'firstDeviation';
allSeparate = figure;
statFig1 = figure;
statFig2 = figure;
for i = 1:length(out)
    if isnan(out(i).sta)
        continue;
    end
    sta = out(i).sta-127.5;
    t = linspace(-300,50,length(out(i).sta));
    staimp = sta(t<0);
    timp = t(t<0);
    switch mode
        case 'maxDev'
            if abs(max(staimp))>abs(min(staimp))
                color = 'r';
                plotNum = 1;
                timesON(end+1) = t(min(find(staimp==max(staimp))));
                times(end+1) = timesON(end);
            else
                color = 'b';
                plotNum = 2;
                timesOFF(end+1) = t(staimp(find(sta==min(staimp))));
                times(end+1) = timesOFF(end);
            end
        case 'firstDeviation'
            stdsta = std(staimp);

            
            whichPositive = find(staimp>stdsta);
            whichNegative = find(staimp<-stdsta);
%             if max(whichPositive)>max(whichNegative)
%                 color = 'r';
%                 plotNum = 1;
%                 timesON(end+1) = timp(min(find(staimp==max(staimp))));
%                 figure(allSeparate);
%                 subplot(8,10,i)
%                 plot(timp,staimp,'r',minmax(timp),[stdsta stdsta],'k',minmax(timp),[-stdsta -stdsta],'k');hold on;
%                 plot(timesON(end),max(staimp),'kd');
%                 axis tight
%             else
%                 color = 'b';
%                 plotNum = 2;
%                 timesOFF(end+1) = timp(min(find(staimp==min(staimp))));
%                 figure(allSeparate);
%                 subplot(8,10,i)
%                 plot(timp,staimp,'b',minmax(timp),[stdsta stdsta],'k',minmax(timp),[-stdsta -stdsta],'k');hold on;
%                 plot(timesON(end),min(staimp),'kd');
%                 axis tight
%             end            
            figure(allSeparate);
            subplot(4,6,i);
            plot(timp,staimp,'b'); hold on;plot(timp(whichPositive),staimp(whichPositive),'r.');plot(timp(whichNegative),staimp(whichNegative),'g*')
            axis tight
            if ~isempty(timp(whichPositive)) && ~isempty(timp(whichNegative))
                if max(timp(whichPositive))>max(timp(whichNegative))
                    text(0.5,0.5,'+','units','normalized');
                    timesON(end+1) = timp(min(find(staimp==max(staimp))));
                    plotNum = 1;
                    color = 'r';
                    times(end+1) = timesON(end);
                else
                    text(0.5,0.5,'-','units','normalized');
                    timesOFF(end+1) = timp(min(find(staimp==min(staimp))));
                    plotNum = 2;
                    color = 'b';
                    times(end+1) = timesOFF(end);
                end
            elseif ~isempty(timp(whichPositive)) && isempty(timp(whichNegative))
                timesON(end+1) = timp(min(find(staimp==max(staimp))));
                plotNum = 1;
                    color = 'r';
                    times(end+1) = timesON(end);
            else
                timesOFF(end+1) = timp(min(find(staimp==min(staimp))));
                plotNum = 2;
                    color = 'b';
                    times(end+1) = timesOFF(end);
            end
    end
    figure(statFig1)
    subplot(2,1,plotNum); hold on;
    plot(t,out(i).sta,'color',color);
end

figure(statFig2);
edges = linspace(-150,-25,20);
nON = histc(timesON,edges);
nOFF = histc(timesOFF,edges);
subplot(2,1,1),bar(edges,nON);
hold on;
timesON = timesON(timesON>-150 & timesON<-25);
plot(mean(timesON), 18,'bd','MarkerSize',10,'MarkerFaceColor','b');
plot([mean(timesON)-std(timesON) mean(timesON)+std(timesON)], [18 18],'b','LineWidth',2);
subplot(2,1,2),bar(edges,nOFF);
hold on;
timesOFF = timesOFF(timesOFF>-150 & timesOFF<-25);

plot(mean(timesOFF), 14,'bd','MarkerSize',10,'MarkerFaceColor','b');
plot([mean(timesOFF)-std(timesOFF) mean(timesOFF)+std(timesOFF)], [14 14],'b','LineWidth',2);

% %% correlation
% Ls = [];
% Ss = [];
% for i = 1:max(rLatency.nID)
%     if ismember(i,rfSizes.nID)&& ismember(i,rLatency.nID)
%         whichS = ismember(rfSizes.nID,i);
%         whichL = ismember(rLatency.nID,i);
%         Ls(end+1) = 
% end

%% plot movie frames
whichID = 1:db.numNeurons; %[37];%5
whichID = 41:db.numNeurons;
params = [];
params.includeNIDs = whichID;
params.excludeNIDs = [13 28 38 52 53 33 36 39 40 47];
params.deleteDupIDs = true;
params.sfFitCS = true;
temp = load('C:\Documents and Settings\Owner\My Documents\Dropbox\sfFitting\currBestFitAll.mat');
params.sfFit = temp.bestFitAll;

params.distToMonitor = 300;
params.monitorWidth = 571.5;
xPix = 1920;
mmPerPix = params.monitorWidth/xPix;
params.degPerPix = rad2deg(atan(1/params.distToMonitor))*mmPerPix;


figNums = db.plotByAnalysis({{'binarySpatial','spatialMovieFrames'},params});

saveLoc = 'C:\Documents and Settings\Owner\Desktop\sequence';
for i = 1:length(figNums)
    figure(figNums(i));
    print(gcf,'-dtiff',fullfile(saveLoc,sprintf('%d.tif',i)));
end

%% plot all spatial stas
whichID = 1:db.numNeurons;
% whichID = [5];
params = [];
params.includeNIDs = whichID;
params.deleteDupIDs = false;
[aInd nID subAInd]=selectIndexTool(db,'binarySpatial',params);
% detailOnWNNew = ...
% [1 1 1 1 0 0 0 1 1 inf 0 0 inf 0 0 0 0 1 0 inf 1 0 0 inf inf 1 1 inf 1 ...
% 1 1 1 1 1 0 0 0 1 inf inf 1 1 0 inf 1 0 inf 1 1 1 1 inf inf inf 0 0 1 0 ...
% 1 1 0 0 0];
% detailOnWNOld = [0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0 0 0 0 inf];
% 
% detailLatencyNew = ...
% [83 83 100 83 100 83 100 83 83 inf 100 83 inf 83 67 83 83 83 100 inf 83 83 83 inf inf 100 83 inf 83 83 83 83 83 83 83 ...
% 100 83 117 inf inf 67 83 83 inf 83 100 inf 100 83 83 100 inf inf 83 83 83 83 100 133 83 117 83 133] ;
% 
% detailLatencyOld = [50 50 67 50 50 33 33 183 83 54 82 45 92 inf 45 45 45 inf 83 inf];

for i = 1:length(nID)
    figHan = figure('units','normalized','outerposition',[0 0 1 1]);
    figName = sprintf('n%d_a%d.png',nID(i),subAInd(i));

    axSpatTempContext = axes('position',[0.05,0.05,0.4,0.4]);
    db.data{nID(i)}.analyses{subAInd(i)}.plotSpatioTemporalContext(axSpatTempContext);
    
    axSpatModulation = axes('position',[0.05,0.55,0.4,0.4]);
    db.data{nID(i)}.analyses{subAInd(i)}.plotSpatialModulation(axSpatModulation);
    
    axTemporal = axes('position',[0.55,0.55,0.4,0.4]);
    db.data{nID(i)}.analyses{subAInd(i)}.plotTemporal(axTemporal);
    
    axSpikes = axes('position',[0.55,0.05,0.2,0.4]);
    paramsSpikes.color = 'k';
    db.data{nID(i)}.analyses{subAInd(i)}.plotSpikes(axSpikes,paramsSpikes);
    
    axISI = axes('position',[0.8,0.05,0.15,0.2]);
    paramsSpikes.color = 'k';
    db.data{nID(i)}.analyses{subAInd(i)}.plotISI(axISI,paramsSpikes);
    
    axDetails = axes('position',[0.8,0.3,0.15,0.2]);
    textNID = sprintf('n:%d',nID(i));
    textSubAInd = sprintf('a:%d',subAInd(i));
    text(0.5,0.5,{textNID,textSubAInd},'horizontalalignment','center','verticalalignment','middle');
    set(gca,'xtick',[],'ytick',[]);
    axis off;
    
    
    saveLoc = 'C:\Documents and Settings\Owner\Desktop\validation';
    print(figHan,fullfile(saveLoc,figName),'-dpng','-r300');
%     plot2svg(fullfile(saveLoc,figName),han);
%     pause(1)
    close(figHan);
    pause(1);
end
disp('done!')