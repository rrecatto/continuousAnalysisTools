    %$ basic analysis
    clc;

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
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Pam-review\Compiled';
    end
    
    out = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
    %% time to threshold for or
    
    fighan = figure;
    set(fighan, 'DefaultTextFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontSize', 12); % [pt]
    set(fighan, 'DefaultAxesFontName', 'Times New Roman');
    set(fighan, 'DefaultTextFontName', 'Times New Roman');
    set(fighan, 'Position',[1 45 1920 969]);
    
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
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Pam-review\Compiled';
    end
    
    % 22,23,25,26,48,40,47,53,56,59,37,38,45,50
    
    % 22
    filters = 1:today;
    out = {};
    plotDetails.axHan = subplot(5,6,1); out{1} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,2); out{2} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,3); out{3} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,4); out{4} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,5); out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,6); out{6} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,7); out{7} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,8); out{8} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,9); out{9} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,10); out{10} = analyzeMouse('60',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,11); out{11} = analyzeMouse('61',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,12); out{12} = analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,13); out{13} = analyzeMouse('64',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,14); out{14} = analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,15); out{15} = analyzeMouse('66',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,16); out{16} = analyzeMouse('67',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,17); out{17} = analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,18); out{18} = analyzeMouse('86',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,19); out{19} = analyzeMouse('200',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,20); out{20} = analyzeMouse('201',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,21); out{21} = analyzeMouse('202',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,22); out{22} = analyzeMouse('204',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,23); out{23} = analyzeMouse('209',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,24); out{24} = analyzeMouse('210',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,25); out{25} = analyzeMouse('211',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,26); out{26} = analyzeMouse('212',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,27); out{27} = analyzeMouse('213',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,28); out{28} = analyzeMouse('215',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,29); out{29} = analyzeMouse('216',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,30); out{30} = analyzeMouse('222',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);


        
    %% actual plotting for or
    outFilter = logical([1 1 1 1 0 1 1 1 1 1 1 1 1 1]);
    filteredOut = out(outFilter);
    filteredOut = out;
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
    plot(2.75,[mTTT-2*semTTT mTTT+2*semTTT],'k')
    plot([2.75 2.75],[mTTT-2*semTTT mTTT+2*semTTT],'k')
    ylabel('trials to thresh.')
    set(gca,'xlim',[0 3],'ylim',[0 7000],'xticklabel',[],'ytick',[2000 4000 6000],'yticklabel',[2 4 6])
    
    
    subplot(2,1,2)
    hold on;
    mDTT = mean(daysToThresh);
    stdDTT = std(daysToThresh);
    semDTT = stdDTT/sqrt(n);
    plot(2.25,daysToThresh,'ko')
    plot(2.75,mDTT,'kd')
    plot([2.75 2.75],[mDTT-2*semDTT mDTT+2*semDTT],'k')
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
    analysisFor.analyzeQuatRadContrast = false;
    analysisFor.analyzeImagesContrast = false;
    
    if ismac
        compiledFilesDir = '/Volumes/BAS-DATA1/BehaviorBkup/Box3/Compiled';
    elseif IsWin
        compiledFilesDir = '\\ghosh-nas.ucsd.edu\ghosh\Behavior\Pam-review\Compiled';
    end
    
    filters = 1:today;
    out = {};
    plotDetails.axHan = subplot(5,6,1); out{1} = analyzeMouse('26',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,2); out{2} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,3); out{3} = analyzeMouse('45',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,4); out{4} = analyzeMouse('47',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,5); out{5} = analyzeMouse('48',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,6); out{6} = analyzeMouse('50',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,7); out{7} = analyzeMouse('53',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,8); out{8} = analyzeMouse('56',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,9); out{9} = analyzeMouse('59',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,10); out{10} = analyzeMouse('60',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,11); out{11} = analyzeMouse('61',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,12); out{12} = analyzeMouse('63',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,13); out{13} = analyzeMouse('64',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,14); out{14} = analyzeMouse('65',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,15); out{15} = analyzeMouse('66',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,16); out{16} = analyzeMouse('67',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,17); out{17} = analyzeMouse('69',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,18); out{18} = analyzeMouse('86',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,19); out{19} = analyzeMouse('200',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,20); out{20} = analyzeMouse('201',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,21); out{21} = analyzeMouse('202',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,22); out{22} = analyzeMouse('204',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,23); out{23} = analyzeMouse('209',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,24); out{24} = analyzeMouse('210',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,25); out{25} = analyzeMouse('211',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,26); out{26} = analyzeMouse('212',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,27); out{27} = analyzeMouse('213',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,28); out{28} = analyzeMouse('215',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,29); out{29} = analyzeMouse('216',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    plotDetails.axHan = subplot(5,6,30); out{30} = analyzeMouse('222',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
        
    %% actual plotting for images
    
    filteredOut = out;
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
    plot(0.75,[mTTT-2*semTTT mTTT+2*semTTT],'k')
    plot([0.75 0.75],[mTTT-2*semTTT mTTT+2*semTTT],'k')
    ylabel('trials to thresh.')
    set(gca,'xlim',[0 3],'ylim',[0 7000],'xticklabel',[],'ytick',[2000 4000 6000],'yticklabel',[2 4 6])
    
    
    subplot(2,1,2)
    hold on;
    mDTT = mean(daysToThresh);
    stdDTT = std(daysToThresh);
    semDTT = stdDTT/sqrt(n);
    plot(0.25,daysToThresh,'ko')
    plot(0.75,mDTT,'kd')
    plot([0.75 0.75],[mDTT-2*semDTT mDTT+2*semDTT],'k')
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
    filters = 1:datenum('Jan-15-2013');plotDetails.axHan = axHan; out{6} = analyzeMouse('40',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
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
  