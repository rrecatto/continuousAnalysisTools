function V1LesionPaperFigures

plotFigure1 = true;
todayDate = datenum('9/13/2013');
if plotFigure1
    %$ basic analysis
    clc;
    disp('Figure1a is a schematic');
    
    % plotting the training for a Opt for this mouse
    mouseID = '26';
    filters = 735150:735180;
    
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
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    
    out = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    %% time to threshold for or
    
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.requestedPlot = 'learningProcessOnlyAverage';
    
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
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    
    % 22,23,25,26,48,40,47,53,56,59,37,38,45,50
    
    % 22
    filters = 1:today;
    out = {};
    plotDetails.axHan = subplot(3,5,1); out{1} = analyzeMouse('22',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,2); out{2} = analyzeMouse('23',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,3); out{3} = analyzeMouse('25',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,4); out{4} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,5); out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,6); out{6} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,7); out{7} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,8); out{8} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,9); out{9} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,10); out{10} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,11); out{11} = analyzeMouse('37',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,12); out{12} = analyzeMouse('38',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,13); out{13} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,14); out{14} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
        
    %% actual plotting for or
    outFilter = logical([1 1 1 1 0 1 1 1 1 1 1 1 1 1]);
    filteredOut = out(outFilter);
    filteredOut = [filteredOut{:}];
    filteredOut = [filteredOut.optData];
    trialsToThresh = [filteredOut.trialsToThreshold];
    daysToThresh = [filteredOut.dayNumAtThreshold];
    % 
    
    figToBeSaved = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    subplot(2,1,1); hold on
    n=length(trialsToThresh);
    mTTT = mean(trialsToThresh);
    semTTT = std(trialsToThresh)/sqrt(n);
    plot(2.25,[trialsToThresh],'ko')
    plot(2.75,mTTT,'kd')
    plot(2.75,[mTTT-semTTT mTTT+semTTT],'k')
    plot([2.75 2.75],[mTTT-semTTT mTTT+semTTT],'k')
    ylabel('trials to thresh.')
    set(gca,'xlim',[0 3],'ylim',[0 7000],'xticklabel',[],'ytick',[2000 4000 6000],'yticklabel',[2 4 6])
    
    
    subplot(2,1,2)
    hold on;
    mDTT = mean(daysToThresh);
    stdDTT = std(daysToThresh);
    semDTT = stdDTT/sqrt(n);
    plot(2.25,daysToThresh,'ko')
    plot(2.75,mDTT,'kd')
    plot([2.75 2.75],[mDTT-semDTT mDTT+semDTT],'k')
    set(gca,'xlim',[0 3],'ylim',[0 70],'xticklabel',[],'ytick',[20 40 60],'yticklabel',[20 40 60]);
    ylabel('days to thresh.')
        
    %% time to threshold for object
    figure
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.requestedPlot = 'learningProcessOnlyAverage';
    
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
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    
    filters = 1:today;
    out = {};
    plotDetails.axHan = subplot(3,5,1); out{1} = analyzeMouse('22',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,2); out{2} = analyzeMouse('23',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,3); out{3} = analyzeMouse('25',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,4); out{4} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,5); out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,6); out{6} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,7); out{7} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,8); out{8} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,9); out{9} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,10); out{10} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,11); out{11} = analyzeMouse('37',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,12); out{12} = analyzeMouse('38',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,13); out{13} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(3,5,14); out{14} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
        
    %% actual plotting for images
    
    outFilter = logical([0 0 0 1 1 1 1 1 1 1 1 1 1 1]);
    filteredOut = out(outFilter);
    filteredOut = [filteredOut{:}];
    filteredOut = [filteredOut.imageData];
    trialsToThresh = [filteredOut.trialsToThreshold];
    daysToThresh = [filteredOut.dayNumAtThreshold];
    
    
    figure(figToBeSaved);
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    subplot(2,1,1); hold on
    n=length(trialsToThresh);
    mTTT = mean(trialsToThresh);
    semTTT = std(trialsToThresh)/sqrt(n);
    plot(0.25,[trialsToThresh],'ko')
    plot(0.75,mTTT,'kd')
    plot(0.75,[mTTT-semTTT mTTT+semTTT],'k')
    plot([0.75 0.75],[mTTT-semTTT mTTT+semTTT],'k')
    ylabel('trials to thresh.')
    set(gca,'xlim',[0 3],'ylim',[0 7000],'xticklabel',[],'ytick',[2000 4000 6000],'yticklabel',[2 4 6])
    
    
    subplot(2,1,2)
    hold on;
    mDTT = mean(daysToThresh);
    stdDTT = std(daysToThresh);
    semDTT = stdDTT/sqrt(n);
    plot(0.25,daysToThresh,'ko')
    plot(0.75,mDTT,'kd')
    plot([0.75 0.75],[mDTT-semDTT mDTT+semDTT],'k')
    set(gca,'xlim',[0 3],'ylim',[0 70],'xticklabel',[],'ytick',[20 40 60],'yticklabel',[20 40 60]);
    ylabel('days to thresh.')
    
    %% plot contrast
    figure
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.requestedPlot = 'performanceByCondition';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false;
    analysisFor.analyzeContrast = true;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor. analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    analysisFor.analyzeCtrSensitivity = false;
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    
    filters = 1:todayDate;
    out = {};
    filters = 1:datenum('Jan-15-2013');plotDetails.axHan = subplot(3,5,1); out{1} = analyzeMouse('22',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     plotDetails.axHan = subplot(3,5,2); out{2} = analyzeMouse('23',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jan-15-2013');plotDetails.axHan = subplot(3,5,3); out{3} = analyzeMouse('25',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Apr-19-2013');plotDetails.axHan = subplot(3,5,4); out{4} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Apr-19-2013'); plotDetails.axHan = subplot(3,5,5); out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jan-15-2013');plotDetails.axHan = subplot(3,5,6); out{6} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     plotDetails.axHan = subplot(3,5,7); out{7} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('May-15-2013');plotDetails.axHan = subplot(3,5,8); out{8} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('May-17-2013');plotDetails.axHan = subplot(3,5,9); out{9} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     filters = 1:datenum('May-17-2013');plotDetails.axHan = subplot(3,5,10); out{10} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jun-25-2013');plotDetails.axHan = subplot(3,5,11); out{11} = analyzeMouse('37',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jun-25-2013');plotDetails.axHan = subplot(3,5,12); out{12} = analyzeMouse('38',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jul-1-2013');plotDetails.axHan = subplot(3,5,13); out{13} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jul-1-2013');plotDetails.axHan = subplot(3,5,14); out{14} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    %% lets replot that on the same graph
    fighan = figure
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.requestedPlot = 'performanceByCondition';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false;
    analysisFor.analyzeContrast = true;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    axHan = axes;
    out = {};
    plotDetails.plotMeansOnly = true;
    filters = 1:datenum('Jan-15-2013');plotDetails.axHan = axHan; out{1} = analyzeMouse('22',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     plotDetails.axHan = subplot(3,5,2); out{2} = analyzeMouse('23',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jan-15-2013');plotDetails.axHan = axHan; out{3} = analyzeMouse('25',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Apr-19-2013');plotDetails.axHan = axHan; out{4} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Apr-19-2013'); plotDetails.axHan = axHan; out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Apr-15-2013');plotDetails.axHan = axHan; out{6} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     plotDetails.axHan = subplot(3,5,7); out{7} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('May-15-2013');plotDetails.axHan = axHan; out{8} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('May-17-2013');plotDetails.axHan = axHan; out{9} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     filters = 1:datenum('May-17-2013');plotDetails.axHan = axHan; out{10} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jun-25-2013');plotDetails.axHan = axHan; out{11} = analyzeMouse('37',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jun-25-2013');plotDetails.axHan = axHan; out{12} = analyzeMouse('38',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jul-1-2013');plotDetails.axHan = axHan; out{13} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:datenum('Jul-1-2013');plotDetails.axHan = axHan; out{14} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    plotDetails.plotMeansOnly = false;
    compiledFilesDirs = {compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,...
        compiledFilesDir,compiledFilesDir,compiledFilesDir};
    filters = 1:todayDate;plotDetails.axHan = axHan; outTotal = analyzeMouse({'22','25','26','48','40','53','56','37','38','45','50'},filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDirs);
    
    %% fits for individual animals
    i = 14
    in.cntr = out{i}.ctrData.contrasts;
    in.pHat = out{i}.ctrData.performanceByConditionWCO(:,1,5)';
    whichGood = ~isnan(in.pHat);
    
    in.cntr = in.cntr(whichGood)
    in.pHat = in.pHat(whichGood);
    
    fit = fitHyperbolicRatio(in);
    fit
    
    %% best fit
    in.cntr = outTotal.ctrData.contrasts;
    in.pHat = outTotal.ctrData.performanceByConditionWCO(:,1,5)';
    fit = fitHyperbolicRatio(in);
    plot(gca,fit.fittedModel.c,fit.fittedModel.pModel,'b','linewidth',3);
    PBSBestC50 = fit.c50;
    

    %% and now orientation
    
    %% lets replot that on the same graph
    fighan = figure
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.requestedPlot = 'performanceByCondition';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false;
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = true;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    axHan = axes;
    out = {};
    plotDetails.plotMeansOnly = true;
%     filters = 1:datenum('Jan-15-2013');plotDetails.axHan = axHan; out{1} = analyzeMouse('22',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{2} = analyzeMouse('23',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{3} = analyzeMouse('25',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeRevOrientation = true;analysisFor.analyzeOrientation = false;filters = 1:todayDate;plotDetails.axHan = axHan; out{4} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeRevOrientation = false;analysisFor.analyzeOrientation = true;filters = 1:todayDate; plotDetails.axHan = axHan; out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{6} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{7} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{8} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{9} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{10} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{11} = analyzeMouse('37',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{12} = analyzeMouse('38',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{13} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{14} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    plotDetails.plotMeansOnly = false;
    compiledFilesDirs = {compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,...
        compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir};
    filters = 1:todayDate;plotDetails.axHan = axHan; outTotal = analyzeMouse({'23','25','26','48','40','47','53','56','59','37','38','45','50'},filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDirs);
  
    %% best fit
    in.cntr = outTotal.orData.orientations;
    in.pHat = outTotal.orData.performanceByConditionWCO(:,1,5)';
    whichGood = ~isnan(in.pHat);
    
    in.cntr = in.cntr(whichGood);
    in.pHat = in.pHat(whichGood);
    in.cntr = in.cntr/45;
    
    in.cntr = in.cntr([1 3 5 7 10 11 12]);
    in.pHat = in.pHat([1 3 5 7 10 11 12]);
    
    fit = fitHyperbolicRatio(in);
    plot(fit.fittedModel.c*45,fit.fittedModel.pModel,'b','linewidth',3);
    PBSBestC50 = fit.c50;
    
    %% spatialfrequency
   %% lets replot that on the same graph
    fighan = figure
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.requestedPlot = 'performanceByCondition';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false;
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = true;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = false;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    analysisFor.analyzeCtrSensitivity = false;
    
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    axHan = axes;
    out = {};
    plotDetails.plotMeansOnly = true;
    filters = 1:datenum('Jan-15-2013');plotDetails.axHan = axHan; out{1} = analyzeMouse('22',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{2} = analyzeMouse('23',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{3} = analyzeMouse('25',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeRevSpatFreq = true;analysisFor.analyzeSpatFreq = false;filters = 1:todayDate;plotDetails.axHan = axHan; out{4} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeRevSpatFreq = false;analysisFor.analyzeSpatFreq = true;filters = 1:todayDate; plotDetails.axHan = axHan; out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{6} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{7} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{8} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{9} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{10} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{11} = analyzeMouse('37',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{12} = analyzeMouse('38',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{13} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:todayDate;plotDetails.axHan = axHan; out{14} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    plotDetails.plotMeansOnly = false;
    compiledFilesDirs = {compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,...
        compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir};
    filters = 1:todayDate;plotDetails.axHan = axHan; outTotal = analyzeMouse({'23','25','26','48','40','47','53','56','59','37','38','45','50'},filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDirs);
    %%
    in.fs = outTotal.spatData.spatFreqs;
    in.f1 = outTotal.spatData.performanceByConditionWCO(:,1,5);
    in.f1 = (in.f1-0.5)*2;
    in.model = '1D-DOG-useSensitivity-analytic';
    in.initialGuessMode = 'preset-1-useSensitivity-withJitter';
    in.errorMode = 'sumOfSquares';
    in.searchAlgorithm = 'fmincon-useSensitivity-subbalanced';
    in.constraints.rS_LB = 5;
    in.constraints.rC_UB = 10;
    
    [out fval flag] = sfDOGFit(in);
    out
    
    
    stim.FS = logspace(log10(0.033964721821571),log10(0.989580616499599),100);
    stim.m = 0.5;
    stim.c = 1;
    rfMod.RC = out(1);
    rfMod.RS = out(2);
    rfMod.KC = out(3);
    rfMod.KS = out(4);
    f = figure; ax = axes; hold on;
    outMod = rfModel(rfMod,stim,'1D-DOG-useSensitivity-analytic');
    plot(outMod.FS,0.5+squeeze(outMod.f1)/2,'k','linewidth',2)


     %% temporal frequency
   %% lets replot that on the same graph
    fighan = figure
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.requestedPlot = 'performanceByCondition';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false;
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = false;
    analysisFor.analyzeOrientation = false;
    analysisFor.analyzeRevOrientation = false;
    analysisFor.analyzeTempFreq = true;
    analysisFor.analyzeRevTempFreq = false;
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    analysisFor.analyzeCtrSensitivity = false;
    
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    axHan = axes;
    out = {};
    plotDetails.plotMeansOnly = true;
    filters = 1:datenum('Jan-15-2013');plotDetails.axHan = axHan; out{1} = analyzeMouse('22',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{2} = analyzeMouse('23',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{3} = analyzeMouse('25',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeRevTempFreq = true;analysisFor.analyzeTempFreq = false;filters = 1:today;plotDetails.axHan = axHan; out{4} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeRevTempFreq = false;analysisFor.analyzeTempFreq = true;filters = 1:today; plotDetails.axHan = axHan; out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{6} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{7} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{8} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{9} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{10} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{11} = analyzeMouse('37',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{12} = analyzeMouse('38',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{13} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    filters = 1:today;plotDetails.axHan = axHan; out{14} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    plotDetails.plotMeansOnly = false;
    compiledFilesDirs = {compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,...
        compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir,compiledFilesDir};
    filters = 1:today;plotDetails.axHan = axHan; outTotal = analyzeMouse({'22','48','40','47','53','56','59','37','38','45','50'},filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDirs);
 
end

plotFigure2 = false;
if plotFigure2
    %% 26  performance by day
    clc;
    disp('Figure1a is a schematic');
    
    % plotting the training for a Opt for this mouse
    mouseID = '26';
    filters = 1:todayDate;
    
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.axHan = axes;
    plotDetails.requestedPlot = 'performanceByDay';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;% true, false
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = true; % true, false
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
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    
    out = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    %% lets look and find te lesionm dates
    
    clc;
    disp('Figure1a is a schematic');
    
    % plotting the training for a Opt for this mouse
    filters = 1:todayDate;
    
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = true;
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
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    out = {};
    numDaysBefore = 10;
    mouseID = '22'; filters = datenum('Jan-20-2013')-5:todayDate;out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '23'; filters = datenum('Jan-14-2013')-5:todayDate;out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '25'; filters = datenum('Jan-14-2013')-5:todayDate;out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = true;
    mouseID = '26'; filters = datenum('Apr-22-2013')-5:todayDate;out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeOpt = true;
    analysisFor.analyzeRevOpt = false;
    mouseID = '48'; filters = datenum('Apr-22-2013')-5:todayDate;out{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '40'; filters = datenum('May-15-2013')-5:todayDate;out{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '47'; filters = datenum('May-15-2013')-5:todayDate;out{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '53'; filters = datenum('May-15-2013')-5:todayDate;out{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '56'; filters = datenum('May-12-2013')-5:todayDate;out{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '59'; filters = datenum('May-17-2013')-5:todayDate;out{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '37'; filters = datenum('Jun-25-2013')-5:todayDate;out{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '38'; filters = datenum('Jun-25-2013')-5:todayDate;out{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '45'; filters = datenum('Jul-1-2013')-5:todayDate;out{13} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '50'; filters = datenum('Jul-1-2013')-5:todayDate;out{14} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    
    %% lesion before and after
    
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
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    out = {};
    beforePerf = nan(14,1);
    nBefore = nan(14,1);
    afterPerf = nan(14,1);
    nAfter = nan(14,1);
    beforeLCI = nan(14,1);
    beforeHCI = nan(14,1);
    afterLCI = nan(14,1);
    afterHCI = nan(14,1);
    
    mouseID = '22'; filters = datenum('Jan-20-2013')-5:datenum('Jan-20-2013');out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '23'; filters = datenum('Jan-14-2013')-5:datenum('Jan-14-2013');out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '25'; filters = datenum('Jan-14-2013')-5:datenum('Jan-14-2013');out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = true;
    mouseID = '26'; filters = datenum('Apr-22-2013')-5:datenum('Apr-22-2013');out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeOpt = true;
    analysisFor.analyzeRevOpt = false;
    mouseID = '48'; filters = datenum('Apr-22-2013')-5:datenum('Apr-22-2013');out{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '40'; filters = datenum('May-15-2013')-5:datenum('May-15-2013');out{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '47'; filters = datenum('May-15-2013')-5:datenum('May-15-2013');out{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '53'; filters = datenum('May-15-2013')-5:datenum('May-15-2013');out{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '56'; filters = datenum('May-12-2013')-5:datenum('May-12-2013');out{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '59'; filters = datenum('May-17-2013')-5:datenum('May-17-2013');out{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '37'; filters = datenum('Jun-25-2013')-5:datenum('Jun-25-2013');out{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '38'; filters = datenum('Jun-25-2013')-5:datenum('Jun-25-2013');out{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '45'; filters = datenum('Jul-1-2013')-5:datenum('Jul-1-2013');out{13} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '50'; filters = datenum('Jul-1-2013')-5:datenum('Jul-1-2013');out{14} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    for i = [1:3 5:14]
        beforePerf(i) = out{i}.optData.performanceByConditionWCO(1,5);
        beforeLCI(i) = out{i}.optData.performanceByConditionWCO(2,5);
        beforeHCI(i) = out{i}.optData.performanceByConditionWCO(3,5);
        nBefore(i) = out{i}.optData.numTrialsByConditionWCO{5};
    end
    beforePerf(4) = out{4}.optReversalData.performanceByConditionWCO(1,5);
    beforeLCI(4) = out{4}.optReversalData.performanceByConditionWCO(2,5);
    beforeHCI(4) = out{4}.optReversalData.performanceByConditionWCO(3,5);
    nBefore(4) = out{4}.optReversalData.numTrialsByConditionWCO{5};
    
    
    mouseID = '22'; filters = datenum('Jan-20-2013'):todayDate;out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '23'; filters = datenum('Jan-14-2013'):todayDate;out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '25'; filters = datenum('Jan-14-2013'):todayDate;out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = true;
    mouseID = '26'; filters = datenum('Apr-22-2013'):todayDate;out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeOpt = true;
    analysisFor.analyzeRevOpt = false;
    mouseID = '48'; filters = datenum('Apr-22-2013'):todayDate;out{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '40'; filters = datenum('May-15-2013'):todayDate;out{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '47'; filters = datenum('May-15-2013'):todayDate;out{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '53'; filters = datenum('May-15-2013'):todayDate;out{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '56'; filters = datenum('May-12-2013'):todayDate;out{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '59'; filters = datenum('May-17-2013'):todayDate;out{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '37'; filters = datenum('Jun-25-2013'):todayDate;out{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '38'; filters = datenum('Jun-25-2013'):todayDate;out{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '45'; filters = datenum('Jul-1-2013'):todayDate;out{13} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '50'; filters = datenum('Jul-1-2013'):todayDate;out{14} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    for i = [1:3 5:14]
        afterPerf(i) = out{i}.optData.performanceByConditionWCO(1,5);
        afterLCI(i) = out{i}.optData.performanceByConditionWCO(2,5);
        afterHCI(i) = out{i}.optData.performanceByConditionWCO(3,5);
        nAfter(i) = out{i}.optData.numTrialsByConditionWCO{5};
    end
    afterPerf(4) = out{4}.optReversalData.performanceByConditionWCO(1,5);
    afterLCI(4) = out{4}.optReversalData.performanceByConditionWCO(2,5);
    afterHCI(4) = out{4}.optReversalData.performanceByConditionWCO(3,5);
    nAfter(4) = out{4}.optReversalData.numTrialsByConditionWCO{5};
    
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
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    axhan = subplot(1,2,1); hold on;
    for i = 1:length(beforePerf)
        if significanceOpt.IsSignificant(i)
            if significanceOpt.dP>0
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
     %% lesioning image data
    
    clc;
    
    % plotting the training for a Opt for this mouse
    filters = 1:todayDate;
    
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = true;
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
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    out = {};
    numDaysBefore = 10;
    mouseID = '22'; filters = datenum('Jan-20-2013')-100:todayDate;out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '23'; filters = datenum('Jan-14-2013')-50:todayDate;out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     mouseID = '25'; filters = datenum('Jan-14-2013')-50:todayDate;out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '26'; filters = datenum('Apr-22-2013')-15:todayDate;out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '48'; filters = datenum('Apr-22-2013')-15:todayDate;out{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '40'; filters = datenum('May-15-2013')-15:todayDate;out{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '47'; filters = datenum('May-15-2013')-15:todayDate;out{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '53'; filters = datenum('May-15-2013')-35:todayDate;out{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '56'; filters = datenum('May-12-2013')-15:todayDate;out{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '59'; filters = datenum('May-17-2013')-20:todayDate;out{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '37'; filters = datenum('Jun-25-2013')-15:todayDate;out{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '38'; filters = datenum('Jun-25-2013')-15:todayDate;out{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '45'; filters = datenum('Jul-1-2013')-15:todayDate;out{13} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '50'; filters = datenum('Jul-1-2013')-15:todayDate;out{14} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    %% lesion before and after images
    
    clc;
        
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = true;
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
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    out = {};
    beforePerf = nan(14,1);
    nBefore = nan(14,1);
    afterPerf = nan(14,1);
    nAfter = nan(14,1);
    beforeLCI = nan(14,1);
    beforeHCI = nan(14,1);
    afterLCI = nan(14,1);
    afterHCI = nan(14,1);
    
    mouseID = '22'; filters = datenum('Jan-20-2013')-100:datenum('Jan-20-2013');out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '23'; filters = datenum('Jan-14-2013')-50:datenum('Jan-14-2013');out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     mouseID = '25'; filters = datenum('Jan-14-2013')-50:datenum('Jan-14-2013');out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '26'; filters = datenum('Apr-22-2013')-15:datenum('Apr-22-2013');out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '48'; filters = datenum('Apr-22-2013')-15:datenum('Apr-22-2013');out{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '40'; filters = datenum('May-15-2013')-15:datenum('May-15-2013');out{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '47'; filters = datenum('May-15-2013')-15:datenum('May-15-2013');out{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '53'; filters = datenum('May-15-2013')-35:datenum('May-15-2013');out{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '56'; filters = datenum('May-12-2013')-15:datenum('May-12-2013');out{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '59'; filters = datenum('May-17-2013')-20:datenum('May-17-2013');out{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '37'; filters = datenum('Jun-25-2013')-15:datenum('Jun-25-2013');out{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '38'; filters = datenum('Jun-25-2013')-15:datenum('Jun-25-2013');out{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '45'; filters = datenum('Jul-1-2013')-15:datenum('Jul-1-2013');out{13} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '50'; filters = datenum('Jul-1-2013')-15:datenum('Jul-1-2013');out{14} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    for i = [1:2 4:14]
        beforePerf(i) = out{i}.imageData.performanceByConditionWCO(1,5);
        beforeLCI(i) = out{i}.imageData.performanceByConditionWCO(2,5);
        beforeHCI(i) = out{i}.imageData.performanceByConditionWCO(3,5);
        nBefore(i) = out{i}.imageData.numTrialsByConditionWCO{5};
    end
    
    out = {};
    mouseID = '22'; filters = datenum('Jan-20-2013'):todayDate;out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '23'; filters = datenum('Jan-14-2013'):todayDate;out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
%     mouseID = '25'; filters = datenum('Jan-14-2013'):todayDate;out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '26'; filters = datenum('Apr-22-2013'):todayDate;out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '48'; filters = datenum('Apr-22-2013'):todayDate;out{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '40'; filters = datenum('May-15-2013'):todayDate;out{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '47'; filters = datenum('May-15-2013'):todayDate;out{7} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '53'; filters = datenum('May-15-2013'):todayDate;out{8} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '56'; filters = datenum('May-12-2013'):todayDate;out{9} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '59'; filters = datenum('May-17-2013'):todayDate;out{10} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '37'; filters = datenum('Jun-25-2013'):todayDate;out{11} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '38'; filters = datenum('Jun-25-2013'):todayDate;out{12} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '45'; filters = datenum('Jul-1-2013'):todayDate;out{13} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '50'; filters = datenum('Jul-1-2013'):todayDate;out{14} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    for i = [1:2 4:14]
        afterPerf(i) = out{i}.imageData.performanceByConditionWCO(1,5);
        afterLCI(i) = out{i}.imageData.performanceByConditionWCO(2,5);
        afterHCI(i) = out{i}.imageData.performanceByConditionWCO(3,5);
        nAfter(i) = out{i}.imageData.numTrialsByConditionWCO{5};
    end
    significanceIm = IsSignificant(beforePerf,nBefore,afterPerf,nAfter);
    
    dP = 100*significanceIm.dP;
    edges = -50:10:50;
    histnSig = histc(dP(significanceIm.IsSignificant),edges);
    b = bar(edges,histnSig);set(b,'facecolor','b');
    hold on
    histnNotSig = histc(dP(~significanceIm.IsSignificant),edges);
    b = bar(edges,histnNotSig);set(b,'facecolor','k');
    plot(nanmean(dP),6,'kx')
    
    
    figure(fighanForPerfChecking);
    axhan = subplot(1,2,2); hold on;
    for i = 1:length(beforePerf)
        if significanceIm.IsSignificant(i)
            if significanceIm.dP(i)>0
                col = [1 0 0];
            else
                col = [0 0 1];
            end
        else
            col = 0.5*[1 1 1];
        end
        plot([0.25 0.75],[beforePerf(i) afterPerf(i)],'color',col,'linewidth',2);
    end
    axis([0.2 0.8 0.4 1]);
    plot([0.2 0.8],[0.5 0.5],'k--');
    set(gca,'xtick',[0.25 0.75],'xticklabel',{'before','after'},'ytick',[0.5 1]);
    %%
    LesionDetails = {
        '22',   'Jan-15-2013',  'Mech';
        '23',   'Jan-15-2013',  'Mech';
        '25',   'Jan-15-2013',  'Mech';
        '26',   'Apr-19-2013',  'IBO';
        '48',   'Apr-19-2013',  'IBO';
        '40',   'May-15-2013',  'IBO';
        '47',   'May-15-2013',  'IBO';
        '53',   'May-15-2013',  'IBO';
        '56',   'May-17-2013',  'Mech';
        '59',   'May-17-2013',  'Mech';
        '37',   'Jun-25-2013',  'Mech';
        '38',   'Jun-25-2013',  'Mech';
        '45',   'Jul-1-2013',   'IBO';
        '50',   'Jul-1-2013',   'IBO'};
    
    %% spatial frequency details
    
    clc;
        
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    
    
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'givenAxes';
    plotDetails.requestedPlot = 'performanceByCondition';
    
    trialNumCutoff = 25;
    
    analysisFor.analyzeImages = false;% true, false
    analysisFor.analyzeOpt = false;
    analysisFor.analyzeRevOpt = false; % true, false
    analysisFor.analyzeContrast = false;
    analysisFor.analyzeRevContrast = false;
    analysisFor.analyzeSpatFreq = true;
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
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\V1Lesion\Compiled';
    end
    out1 = {};
    beforePerf = nan(14,1);
    nBefore = nan(14,1);
    afterPerf = nan(14,1);
    nAfter = nan(14,1);
    beforeLCI = nan(14,1);
    beforeHCI = nan(14,1);
    afterLCI = nan(14,1);
    afterHCI = nan(14,1);
    
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = true;
    plotDetails.axHan =subplot(3,3,1);mouseID = '26'; filters = 1:datenum('Apr-22-2013');out1{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeSpatFreq = true;
    analysisFor.analyzeRevSpatFreq = false;
    plotDetails.axHan =subplot(3,3,2);mouseID = '48'; filters = 1:datenum('Apr-22-2013');out1{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan =subplot(3,3,3);mouseID = '40'; filters = 1:datenum('May-15-2013');out1{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan =subplot(3,3,4);mouseID = '47'; filters = 1:datenum('May-15-2013');out1{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan =subplot(3,3,7);mouseID = '45'; filters = 1:datenum('Jul-1-2013');out1{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan =subplot(3,3,8);mouseID = '50'; filters = 1:datenum('Jul-1-2013');out1{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    figure;
    out2 = {};
    analysisFor.analyzeSpatFreq = false;
    analysisFor.analyzeRevSpatFreq = true;
    plotDetails.axHan =subplot(3,3,1);mouseID = '26'; filters = datenum('Apr-22-2013'):todayDate;out2{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    analysisFor.analyzeSpatFreq = true;
    analysisFor.analyzeRevSpatFreq = false;
    plotDetails.axHan =subplot(3,3,2);mouseID = '48'; filters = datenum('Apr-22-2013'):todayDate;out2{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan =subplot(3,3,3);mouseID = '40'; filters = datenum('May-15-2013'):todayDate;out2{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan =subplot(3,3,4);mouseID = '47'; filters = datenum('May-15-2013'):todayDate;out2{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan =subplot(3,3,7);mouseID = '45'; filters = datenum('Jul-1-2013'):todayDate;out2{5} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan =subplot(3,3,8);mouseID = '50'; filters = datenum('Jul-1-2013'):todayDate;out2{6} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    minSF = 0.0339647218215715;
    maxSF = 0.494944172780733;
    sfRange = logspace(log10(minSF),log10(maxSF),100);
    
    perfsBefore = nan(6,100);
    perfsBefore(1,:) = interp1(out1{1}.spatRevData.spatFreqs,out1{1}.spatRevData.performanceByConditionWCO(:,1,5),sfRange);
    perfsBefore(2,:) = interp1(out1{2}.spatData.spatFreqs,out1{2}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    perfsBefore(3,:) = interp1(out1{3}.spatData.spatFreqs,out1{3}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    perfsBefore(4,:) = interp1(out1{4}.spatData.spatFreqs,out1{4}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    perfsBefore(5,:) = interp1(out1{5}.spatData.spatFreqs,out1{5}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    perfsBefore(6,:) = interp1(out1{6}.spatData.spatFreqs,out1{6}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    
    perfsAfter = nan(6,100);
    perfsAfter(1,:) = interp1(out2{1}.spatRevData.spatFreqs,out2{1}.spatRevData.performanceByConditionWCO(:,1,5),sfRange);
    perfsAfter(2,:) = interp1(out2{2}.spatData.spatFreqs,out2{2}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    perfsAfter(3,:) = interp1(out2{3}.spatData.spatFreqs,out2{3}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    perfsAfter(4,:) = interp1(out2{4}.spatData.spatFreqs,out2{4}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    perfsAfter(5,:) = interp1(out2{5}.spatData.spatFreqs,out2{5}.spatData.performanceByConditionWCO(:,1,5),sfRange);
    perfsAfter(6,:) = interp1(out2{6}.spatData.spatFreqs,out2{6}.spatData.performanceByConditionWCO(:,1,5),sfRange);

    figure;
    subplot(2,1,1);
    semilogx(sfRange,mean(perfsBefore),'k','linewidth',3); hold on;
    semilogx(sfRange,[mean(perfsBefore)-std(perfsBefore)/sqrt(6)],'k--','linewidth',2);
    semilogx(sfRange,[mean(perfsBefore)+std(perfsBefore)/sqrt(6)],'k--','linewidth',2);
    
    semilogx(sfRange,mean(perfsAfter),'b','linewidth',3); hold on;
    semilogx(sfRange,[mean(perfsAfter)-std(perfsAfter)/sqrt(6)],'b--','linewidth',2);
    semilogx(sfRange,[mean(perfsAfter)+std(perfsAfter)/sqrt(6)],'b--','linewidth',2);
    
    
    perfsRatio = (perfsBefore)./(perfsAfter);
    subplot(2,1,2);
    semilogx(sfRange,mean(perfsRatio),'k','linewidth',3); hold on;
    semilogx(sfRange,[mean(perfsRatio)-std(perfsRatio)/sqrt(6)],'k--','linewidth',2);
    semilogx(sfRange,[mean(perfsRatio)+std(perfsRatio)/sqrt(6)],'k--','linewidth',2);
end
%%
plotFigure5 = true;
if plotFigure5
    
    % plotting the training for a Opt for this mouse
    filters = 1:today;
    
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
    out = {};
    beforePerf = nan(4,1);
    nBefore = nan(4,1);
    afterPerf = nan(4,1);
    nAfter = nan(4,1);
    beforeLCI = nan(4,1);
    beforeHCI = nan(4,1);
    afterLCI = nan(4,1);
    afterHCI = nan(4,1);
    
    mouseID = '95'; filters = datenum('Jan-1-2014'):datenum('Feb-23-2014');out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '98'; filters = datenum('Dec-5-2013'):datenum('Feb-23-2014');out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '205'; filters = datenum('Jan-1-2014'):datenum('Feb-23-2014');out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '209'; filters = datenum('Dec-10-2013'):datenum('Feb-23-2014');out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    for i = 1:4
        beforePerf(i) = out{i}.optData.performanceByConditionWCO(1,5);
        beforeLCI(i) = out{i}.optData.performanceByConditionWCO(2,5);
        beforeHCI(i) = out{i}.optData.performanceByConditionWCO(3,5);
        nBefore(i) = out{i}.optData.numTrialsByConditionWCO{5};
    end
    beforePerf(1) = 0.78
    
    
    mouseID = '95'; filters = datenum('Feb-23-2014'):today;out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '98'; filters = datenum('Feb-23-2014'):today;out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '205'; filters = datenum('Feb-23-2014'):today;out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '209'; filters = datenum('Feb-23-2014'):today;out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);

    for i = 1:4
        afterPerf(i) = out{i}.optData.performanceByConditionWCO(1,5);
        afterLCI(i) = out{i}.optData.performanceByConditionWCO(2,5);
        afterHCI(i) = out{i}.optData.performanceByConditionWCO(3,5);
        nAfter(i) = out{i}.optData.numTrialsByConditionWCO{5};
    end
    afterPerf
    
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
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    axhan = subplot(1,2,1); hold on;
    for i = 1:length(beforePerf)
        if significanceOpt.IsSignificant(i)
            if significanceOpt.dP>0
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
%%
plotFigure5b = true;
if plotFigure5b
    
    % plotting the training for a Opt for this mouse
    filters = 1:today;
    
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
    analysisFor.analyzeCtrSensitivity = false;
    
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\SCLesion\Compiled';
    end
    
    out = {};
    beforePerf = nan(4,1);
    nBefore = nan(4,1);
    afterPerf = nan(4,1);
    nAfter = nan(4,1);
    beforeLCI = nan(4,1);
    beforeHCI = nan(4,1);
    afterLCI = nan(4,1);
    afterHCI = nan(4,1);
    
    mouseID = '95'; filters = datenum('Jan-1-2014'):datenum('Feb-23-2014');out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '98'; filters = datenum('Jan-25-2014'):datenum('Feb-23-2014');out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '205'; filters = datenum('Feb-15-2014'):datenum('27-Feb-2014');out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);% datenum('Feb-23-2014')
    mouseID = '209'; filters = datenum('Dec-10-2013'):datenum('Feb-23-2014');out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    for i = 1:4
        beforePerf(i) = out{i}.imageData.performanceByConditionWCO(1,5);
        beforeLCI(i) = out{i}.imageData.performanceByConditionWCO(2,5);
        beforeHCI(i) = out{i}.imageData.performanceByConditionWCO(3,5);
        nBefore(i) = out{i}.imageData.numTrialsByConditionWCO{5};
    end
    beforePerf
    
    
    mouseID = '95'; filters = datenum('Feb-23-2014'):today;out{1} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '98'; filters = datenum('Feb-23-2014'):today;out{2} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '205'; filters = datenum('27-Feb-2014'):today;out{3} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    mouseID = '209'; filters = datenum('Feb-23-2014'):today;out{4} = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);

    for i = 1:4
        afterPerf(i) = out{i}.imageData.performanceByConditionWCO(1,5);
        afterLCI(i) = out{i}.imageData.performanceByConditionWCO(2,5);
        afterHCI(i) = out{i}.imageData.performanceByConditionWCO(3,5);
        nAfter(i) = out{i}.imageData.numTrialsByConditionWCO{5};
    end
    afterPerf
    
    significanceOpt = IsSignificant(beforePerf,nBefore,afterPerf,nAfter);
    
    dP = 100*significanceOpt.dP;
    edges = -50:10:50;
    histnSig = histc(dP(significanceOpt.IsSignificant),edges);
    b = bar(edges,histnSig);set(b,'facecolor','b');
    hold on
    histnNotSig = histc(dP(~significanceOpt.IsSignificant),edges);
    b = bar(edges,histnNotSig);set(b,'facecolor','k');
    plot(nanmean(dP),6,'kx')
    
    figure(fighan);
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    axhan = subplot(1,2,2); hold on;
    for i = 1:length(beforePerf)
        if significanceOpt.IsSignificant(i)
            if significanceOpt.dP>0
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

end