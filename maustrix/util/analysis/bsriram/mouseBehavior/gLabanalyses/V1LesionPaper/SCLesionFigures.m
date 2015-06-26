function SCLesionFigures

plotFigure1 = true;
todayDate = datenum('9/13/2013');
if plotFigure1
    %$ basic analysis
    clc;
    disp('Figure1a is a schematic');
    
    % plotting the training for a Opt for this mouse
    mouseID = '98';
    filters = 1:today;
    
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.axHan = axes;
    plotDetails.requestedPlot = 'learningProcess';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;
    analysisFor.analyzeOpt = true;
    analysisFor.analyzeRevOpt = false;
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\SCLesion\Compiled';
    end
    
    out = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    out.optData.dates
  


end

%%

plotFigure2 = true;
if plotFigure2
    clc;
    disp('Figure1a is a schematic');
    
    % plotting the training for a Opt for this mouse
    filters = 1:todayDate;
    
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = false;
    plotDetails.plotWhere = 'makeFigure';
    plotDetails.axHan = axes;
    plotDetails.requestedPlot = 'performanceByDay';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;% true, false
    analysisFor.analyzeOpt = true;
    analysisFor.analyzeRevOpt = false; % true, false
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\SCLesion\Compiled';
    end
    outBefore = {};
    numDaysBefore = 10;
    mouseID = '200'; filters = 735500:735508;outBefore{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '201'; filters = 735480:735486;outBefore{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '202'; filters = 735473:735486;outBefore{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '205'; filters = 735619:735626;outBefore{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '209'; filters = 735577:735582;outBefore{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '210'; filters = 735481:735486;outBefore{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '211'; filters = 735476:735486;outBefore{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '60'; filters = 735392:735399;outBefore{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '61'; filters = 735448:735455;outBefore{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '65'; filters = 735392:735399;outBefore{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '66'; filters = 735633:735640;outBefore{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '98'; filters = 735569:735574;outBefore{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    

    outAfter = {};
    numDaysBefore = 10;
    mouseID = '200'; filters = 735700:today;outAfter{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '201'; filters = 735700:today;outAfter{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '202'; filters = 735700:today;outAfter{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '205'; filters = 735663:today;outAfter{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '209'; filters = 735663:today;outAfter{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '210'; filters = 735728:today;outAfter{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '211'; filters = 735717:today;outAfter{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '60'; filters = 735633:735640;outAfter{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '61'; filters = 735726:735733;outAfter{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '65'; filters = 735717:735733;outAfter{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '66'; filters = 735728:735735;outAfter{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '98'; filters = 735670:735678;outAfter{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    

    
% lesion 
% 200: pre - 735500:735508 post - 735700:today
% 201: pre - 735480:735486 post - 735700:today
% 202: pre - 735473:735486 post - 735700:today
% 205: pre - 735619:735626 post - 735663:today
% 209: pre - 735577:735582 post - 735663:today
% 210: pre - 735481:735486 post - 735728:today
% 211: pre - 735476:735486 post - 735717:today
% 60: pre - 735392:735399 post - 735633:735640
% 61: pre - 735448:735455 post - 735726:735733
% 65: pre - 735392:735399 post - 735717:735733
% 66: pre - 735633:735640 post - 735728:735735
% 98: pre - 735569:735574 post - 735670:735678

    beforePerf = nan(12,1);
    nBefore = nan(12,1);
    afterPerf = nan(12,1);
    nAfter = nan(12,1);
    beforeLCI = nan(12,1);
    beforeHCI = nan(12,1);
    afterLCI = nan(12,1);
    afterHCI = nan(12,1);

    for i = 1:12
        beforePerf(i) = outBefore{i}.optData.performanceByConditionWCO(1,5);
        beforeLCI(i) = outBefore{i}.optData.performanceByConditionWCO(2,5);
        beforeHCI(i) = outBefore{i}.optData.performanceByConditionWCO(3,5);
        nBefore(i) = outBefore{i}.optData.numTrialsByConditionWCO{5};
        
        afterPerf(i) = outAfter{i}.optData.performanceByConditionWCO(1,5);
        afterLCI(i) = outAfter{i}.optData.performanceByConditionWCO(2,5);
        afterHCI(i) = outAfter{i}.optData.performanceByConditionWCO(3,5);
        nAfter(i) = outAfter{i}.optData.numTrialsByConditionWCO{5};
    end

    significanceOpt = IsSignificant(beforePerf,nBefore,afterPerf,nAfter);
    
    dP = 100*significanceOpt.dP;
    edges = -50:10:50;
    histnSig = histc(dP(significanceOpt.IsSignificant),edges);
    b = bar(edges,histnSig);set(b,'facecolor','b');
    hold on
    histnNotSig = histc(dP(~significanceOpt.IsSignificant),edges);
    b = bar(edges,histnNotSig);set(b,'facecolor','k');
    plot(nanmean(dP),6,'kx')
    
    fighanForPerfChecking = figure;
    set(fighanForPerfChecking, 'DefaultTextFontSize', 12); % [pt]
    set(fighanForPerfChecking, 'DefaultAxesFontSize', 12); % [pt]
    set(fighanForPerfChecking, 'DefaultAxesFontName', 'Times New Roman');
    set(fighanForPerfChecking, 'DefaultTextFontName', 'Times New Roman');
    axhan = subplot(1,2,1); hold on;
    for i = 1:length(beforePerf)
        if significanceOpt.IsSignificant(i)
            if significanceOpt.dP(i)>0
                col = [0 0 1];
            else
                col = [1 0 0];
            end
        else
            col = 0.5*[1 1 1];
        end
        plot([0.25 0.75],[beforePerf(i) afterPerf(i)],'color',col,'linewidth',2);
    end
    axis([0.2 0.8 0.4 1]);
    plot([0.2 0.8],[0.5 0.5],'k--');
    set(gca,'xtick',[0.25 0.75],'xticklabel',{'before','after'},'ytick',[0.5 1]);
end

%% lets get details for the images
plotFigure3 = true;
todayDate = datenum('9/13/2013');
if plotFigure3

    % plotting the training for a Opt for this mouse
    mouseID = '98';
    filters = 1:today;
    f = figure;
    plotDetails.plotOn = false;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.axHan = axes;
    plotDetails.requestedPlot = 'learningProcess';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = true;
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false;
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\SCLesion\Compiled';
    end
    
    out = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    out.imageData.dates
  


end
%%
plotFigure4 = true;
if plotFigure4
    clc;
    disp('Figure1a is a schematic');
    
    % plotting the training for a Opt for this mouse
    filters = 1:todayDate;
    
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = false;
    plotDetails.plotWhere = 'makeFigure';
    plotDetails.axHan = axes;
    plotDetails.requestedPlot = 'performanceByDay';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = true;% true, false
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false; % true, false
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\SCLesion\Compiled';
    end
    outBefore = {};
    numDaysBefore = 10;
    mouseID = '200'; filters = 735569:735574;outBefore{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '201'; filters = 735569:735574;outBefore{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '202'; filters = 735675:735691;outBefore{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '205'; filters = 735445:735447;outBefore{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '209'; filters = 735481:735486;outBefore{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '210'; filters = 735453:735455;outBefore{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '211'; filters = 735573:735575;outBefore{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '60'; filters = 735384:735389;outBefore{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '61'; filters = 735482:735486;outBefore{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '65'; filters = 735384:735389;outBefore{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '66'; filters = 735389:735392;outBefore{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '98'; filters = 735465:735472;outBefore{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    

    outAfter = {};
    numDaysBefore = 10;
    mouseID = '200'; filters = 735704:735714;outAfter{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '201'; filters = 735704:735714;outAfter{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '202'; filters = 735704:735714;outAfter{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '205'; filters = 735657:735662;outAfter{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '209'; filters = 735657:735662;outAfter{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '210'; filters = 735712:735714;outAfter{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '211'; filters = 735712:735714;outAfter{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '60'; filters = 735621:735623;outAfter{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '61'; filters = 735711:735714;outAfter{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '65'; filters = 735711:735714;outAfter{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '66'; filters = 735711:735714;outAfter{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '98'; filters = 735665:735669;outAfter{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    

    
% lesion 735700
% 200: pre - 735569:735574 post - 735704:735714
% 201: pre - 735569:735574 post - 735704:735714
% 202: pre - 735675:735691 post - 735704:735714
% 205: pre - 735445:735447 post - 735657:735662
% 209: pre - 735481:735486 post - 735657:735662
% 210: pre - 735453:735455 post - 735712:735714
% 211: pre - 735573:735575 post - 735712:735714
% 60: pre - 735384:735389 post - 735621:735623
% 61: pre - 735482:735486 post - 735711:735714
% 65: pre - 735384:735389 post - 735711:735714
% 66: pre - 735389:735392 post - 735711:735714
% 98: pre - 735465:735472 post - 735665:735669

    beforePerf = nan(12,1);
    nBefore = nan(12,1);
    afterPerf = nan(12,1);
    nAfter = nan(12,1);
    beforeLCI = nan(12,1);
    beforeHCI = nan(12,1);
    afterLCI = nan(12,1);
    afterHCI = nan(12,1);

    for i = 1:12
        beforePerf(i) = outBefore{i}.imageData.performanceByConditionWCO(1,5);
        beforeLCI(i) = outBefore{i}.imageData.performanceByConditionWCO(2,5);
        beforeHCI(i) = outBefore{i}.imageData.performanceByConditionWCO(3,5);
        nBefore(i) = outBefore{i}.imageData.numTrialsByConditionWCO{5};
        
        afterPerf(i) = outAfter{i}.imageData.performanceByConditionWCO(1,5);
        afterLCI(i) = outAfter{i}.imageData.performanceByConditionWCO(2,5);
        afterHCI(i) = outAfter{i}.imageData.performanceByConditionWCO(3,5);
        nAfter(i) = outAfter{i}.imageData.numTrialsByConditionWCO{5};
    end

    significanceOpt = IsSignificant(beforePerf,nBefore,afterPerf,nAfter);
    
    dP = 100*significanceOpt.dP;
    edges = -50:10:50;
    histnSig = histc(dP(significanceOpt.IsSignificant),edges);
    b = bar(edges,histnSig);set(b,'facecolor','b');
    hold on
    histnNotSig = histc(dP(~significanceOpt.IsSignificant),edges);
    b = bar(edges,histnNotSig);set(b,'facecolor','k');
    plot(nanmean(dP),6,'kx')
    
    fighanForPerfChecking = figure;
    set(fighanForPerfChecking, 'DefaultTextFontSize', 12); % [pt]
    set(fighanForPerfChecking, 'DefaultAxesFontSize', 12); % [pt]
    set(fighanForPerfChecking, 'DefaultAxesFontName', 'Times New Roman');
    set(fighanForPerfChecking, 'DefaultTextFontName', 'Times New Roman');
    axhan = subplot(1,2,1); hold on;
    for i = 1:length(beforePerf)
        if significanceOpt.IsSignificant(i)
            if significanceOpt.dP(i)>0
                col = [0 0 1];
            else
                col = [1 0 0];
            end
        else
            col = 0.5*[1 1 1];
        end
        plot([0.25 0.75],[beforePerf(i) afterPerf(i)],'color',col,'linewidth',2);
    end
    axis([0.2 0.8 0.4 1]);
    plot([0.2 0.8],[0.5 0.5],'k--');
    set(gca,'xtick',[0.25 0.75],'xticklabel',{'before','after'},'ytick',[0.5 1]);
end

plot6 = true;
if plot6
    respTimesBefore = [];
    respTimesAfter = [];
    
    for i = 1:12
        respTimesBefore(end+1) = nanmean(outBefore{i}.optData.responseTimesByConditionWCO{5});
        respTimesAfter(end+1) = nanmean(outAfter{i}.optData.responseTimesByConditionWCO{5});
    end
end
 end