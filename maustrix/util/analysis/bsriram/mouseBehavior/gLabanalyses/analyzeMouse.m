function out = analyzeMouse(mouseID,filters,plotDetails,trialNumCutoff,analysisFor,splits,compiledFilesDir)
out = [];
if ~exist('plotDetails','var')||isempty(plotDetails)
    plotDetails.plotOn = true;
    plotDetails.plotWhere = 'makeFigure';
end

if ~exist('trialNumCutoff','var')||isempty(trialNumCutoff)
    trialNumCutoff = 25;
end

if ~exist('filters','var') || isempty(filters)
    % all data is allowed
    filters.fdFilter = 1:today;
    filters.imFilter = 1:today;
    filters.optFilter = 1:today;
    filters.optRevFilter = 1:today;
    filters.ctrFilter = 1:today;
    filters.ctrRevFilter = 1:today;
    filters.sfFilter = 1:today;
    filters.sfRevFilter = 1:today;
    filters.orFilter = 1:today;
    filters.orRevFilters = 1:today;
    filters.tfFilter = 1:today;
    filters.tfRevFilter = 1:today;
    filters.ctrQuatRadFilter = 1:today;
    filters.ctrImages = 1:today;
    filters.ctrSensitivity = 1:today;
    filters.varDur = 1:today;
elseif isnumeric(filters)
    temp = filters;
    filters.fdFilter = temp;
    filters.imFilter = temp;
    filters.optFilter = temp;
    filters.optRevFilter = temp;
    filters.ctrFilter = temp;
    filters.ctrRevFilter = temp;
    filters.sfFilter = temp;
    filters.sfRevFilter = temp;
    filters.orFilter = temp;
    filters.orRevFilters = temp;
    filters.tfFilter = temp;
    filters.tfRevFilter = temp;
    filters.ctrQuatRadFilter = temp;
    filters.ctrImages = temp;
    filters.ctrSensitivity = temp;
    filters.varDur = temp;
    clear temp
end

if ~exist('analysisFor','var')||isempty(analysisFor)
    analyzeImages = true;
    analyzeOpt = true;
    analyzeRevOpt = true;
    analyzeContrast = true;
    analyzeRevContrast = true;
    analyzeSpatFreq = true;
    analyzeRevSpatFreq = true;
    analyzeOrientation = true;
    analyzeRevOrientation = true;
    analyzeTempFreq = true;
    analyzeRevTempFreq = true;
    analyzeQuatRadContrast = true;
    analyzeImagesContrast = true;
    analyzeCtrSensitivity = true;
    analyzeVariedDurations = true;
else
    analyzeImages = analysisFor.analyzeImages;
    analyzeOpt = analysisFor.analyzeOpt;
    analyzeRevOpt = analysisFor.analyzeRevOpt;
    analyzeContrast = analysisFor.analyzeContrast;
    analyzeRevContrast = analysisFor.analyzeRevContrast;
    analyzeSpatFreq = analysisFor.analyzeSpatFreq;
    analyzeRevSpatFreq = analysisFor.analyzeRevSpatFreq;
    analyzeOrientation = analysisFor.analyzeOrientation;
    analyzeRevOrientation = analysisFor.analyzeRevOrientation;
    analyzeTempFreq = analysisFor.analyzeTempFreq;
    analyzeRevTempFreq = analysisFor.analyzeRevTempFreq;
    analyzeQuatRadContrast = analysisFor.analyzeQuatRadContrast;
    analyzeImagesContrast = analysisFor.analyzeImagesContrast;
    analyzeCtrSensitivity = analysisFor.analyzeCtrSensitivity;
    analyzeVariedDurations = analysisFor.analyzeVariedDurations;
end

if ~exist('splits','var')||isempty(splits)
    daysPBS = [];
    daysCNO = [];
    daysIntact = [];
    daysLesion = [];
else
    daysPBS = splits.daysPBS;
    daysCNO = splits.daysCNO;
    daysIntact = splits.daysIntact;
    daysLesion = splits.daysLesion;    
end

if iscell(mouseID) && length(mouseID)>1
    data = collateData(compiledFilesDir,mouseID);
    temp = sprintf('%s',mouseID{1});
    for i = 2:length(mouseID)
        temp = sprintf('%s-%s',temp,mouseID{i});
    end
    mouseID = 'ALL MICE';
else
    data = load(findCompiledRecordsForSubject(compiledFilesDir,mouseID));
end

%% IMAGES
if analyzeImages
    out.imageData = analyzeImagesTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end
%% +/- 45 GRATINGS
if analyzeOpt
    out.optData = analyzeOptTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% REVERSAL +/- 45 GRATINGS
if analyzeRevOpt
    out.optReversalData = analyzeOptReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% CONTRAST
if analyzeContrast
    out.ctrData = analyzeContrastTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end
%% REVERSAL CONTRAST
if analyzeRevContrast
    out.ctrRevData = analyzeContrastReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% SPAT.FREQ.
if analyzeSpatFreq
    out.spatData = analyzeSpatFreqTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% REV. SPAT. FREQ.
if analyzeRevSpatFreq
    out.spatRevData = analyzeSpatFreqReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% ORIENTATION
if analyzeOrientation
    out.orData = analyzeOrientationTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% REVERSAL ORIENTATION
if analyzeRevOrientation
    out.orRevData = analyzeOrientationReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% TEMP FREQ
if analyzeTempFreq
    out.tfData = analyzeTempFreqTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% REVERSAL TEMP FREQ
if analyzeRevTempFreq
    out.tfRevData = analyzeTempFreqReversalTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% QUAT. RAD. CONTRAST
if analyzeQuatRadContrast
    out.ctrQuatRadData = analyzeQuatRadContrastTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% IMAGES CONTRAST
if analyzeImagesContrast
    out.ctrImageData = analyzeImagesContrastTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% CONTRAST SENSITIVITY
if analyzeCtrSensitivity
    out.ctrSensitivityData = analyzeCtrSensitivityTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end

%% VARIED DURATIONS
if analyzeVariedDurations
    out.varDurData = analyzeVariedDurationTrials(mouseID,data,filters,plotDetails,trialNumCutoff,daysPBS,daysCNO,daysIntact,daysLesion);
end
end

