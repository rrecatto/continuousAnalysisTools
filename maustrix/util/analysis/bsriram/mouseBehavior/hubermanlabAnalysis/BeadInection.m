function BeadInection
'orctrXsfSweep'
plotFigure2 = true;
if plotFigure2
    %% 26  performance by day
    clc;
    
    % plotting the training for a Opt for this mouse
    filters = 1:today;
    
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
    analysisFor.analyzeCtrSensitivity = true;
    
    compiledFilesDir = '\\ghosh-16-159-221.ucsd.edu\ghosh\Behavior\RocheProject\Compiled';
        
    out = analyzeMouse('213',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    out = analyzeMouse('216',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    out = analyzeMouse('220',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    out = analyzeMouse('221',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    out = analyzeMouse('225',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    out = analyzeMouse('226',filters,plotDetails,trialNumCutoff,analysisFor,[],compiledFilesDir);
    
end

end