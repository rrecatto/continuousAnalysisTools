function out = collateData(compiledFilesDir,mouseID,localSaveID)
out = load(findCompiledRecordsForSubject(compiledFilesDir{1},mouseID{1}));
maxLUTNum = length(out.compiledLUT);
maxTrialNum = max(out.compiledTrialRecords.trialNumber);
for i = 2:length(mouseID)
    tempCurr = load(findCompiledRecordsForSubject(compiledFilesDir{i},mouseID{i}));
    
    % update the compiledTrialRecords
    out.compiledTrialRecords.trialNumber = [out.compiledTrialRecords.trialNumber tempCurr.compiledTrialRecords.trialNumber + maxTrialNum];
    out.compiledTrialRecords.sessionNumber = [out.compiledTrialRecords.sessionNumber tempCurr.compiledTrialRecords.sessionNumber];
    out.compiledTrialRecords.date = [out.compiledTrialRecords.date tempCurr.compiledTrialRecords.date];
    out.compiledTrialRecords.soundOn = [out.compiledTrialRecords.soundOn tempCurr.compiledTrialRecords.soundOn];
    out.compiledTrialRecords.physicalLocation = [out.compiledTrialRecords.physicalLocation tempCurr.compiledTrialRecords.physicalLocation];
    out.compiledTrialRecords.numPorts = [out.compiledTrialRecords.numPorts tempCurr.compiledTrialRecords.numPorts];
    out.compiledTrialRecords.step = [out.compiledTrialRecords.step tempCurr.compiledTrialRecords.step];
    out.compiledTrialRecords.trainingStepName = [out.compiledTrialRecords.trainingStepName tempCurr.compiledTrialRecords.trainingStepName + maxLUTNum];
    out.compiledTrialRecords.protocolName = [out.compiledTrialRecords.protocolName tempCurr.compiledTrialRecords.protocolName + maxLUTNum];
    out.compiledTrialRecords.numStepsInProtocol = [out.compiledTrialRecords.numStepsInProtocol tempCurr.compiledTrialRecords.numStepsInProtocol];
    out.compiledTrialRecords.manualVersion = [out.compiledTrialRecords.manualVersion tempCurr.compiledTrialRecords.manualVersion];
    out.compiledTrialRecords.autoVersion = [out.compiledTrialRecords.autoVersion tempCurr.compiledTrialRecords.autoVersion];
    out.compiledTrialRecords.protocolDate = [out.compiledTrialRecords.protocolDate tempCurr.compiledTrialRecords.protocolDate];
    out.compiledTrialRecords.correct = [out.compiledTrialRecords.correct tempCurr.compiledTrialRecords.correct];
    out.compiledTrialRecords.trialManagerClass = [out.compiledTrialRecords.trialManagerClass tempCurr.compiledTrialRecords.trialManagerClass+maxLUTNum];
    out.compiledTrialRecords.stimManagerClass = [out.compiledTrialRecords.stimManagerClass tempCurr.compiledTrialRecords.stimManagerClass+maxLUTNum];
    out.compiledTrialRecords.schedulerClass = [out.compiledTrialRecords.schedulerClass tempCurr.compiledTrialRecords.schedulerClass+maxLUTNum];
    out.compiledTrialRecords.criterionClass = [out.compiledTrialRecords.criterionClass tempCurr.compiledTrialRecords.criterionClass+maxLUTNum];
    out.compiledTrialRecords.reinforcementManagerClass = [out.compiledTrialRecords.reinforcementManagerClass tempCurr.compiledTrialRecords.reinforcementManagerClass+maxLUTNum];
    out.compiledTrialRecords.targetPorts = [out.compiledTrialRecords.targetPorts tempCurr.compiledTrialRecords.targetPorts];
    out.compiledTrialRecords.distractorPorts = [out.compiledTrialRecords.distractorPorts tempCurr.compiledTrialRecords.distractorPorts];
    out.compiledTrialRecords.result = [out.compiledTrialRecords.result tempCurr.compiledTrialRecords.result];
    out.compiledTrialRecords.containedAPause = [out.compiledTrialRecords.containedAPause tempCurr.compiledTrialRecords.containedAPause];
    out.compiledTrialRecords.containedManualPokes = [out.compiledTrialRecords.containedManualPokes tempCurr.compiledTrialRecords.containedManualPokes];
    out.compiledTrialRecords.didHumanResponse = [out.compiledTrialRecords.didHumanResponse tempCurr.compiledTrialRecords.didHumanResponse];
    out.compiledTrialRecords.containedForcedRewards = [out.compiledTrialRecords.containedForcedRewards tempCurr.compiledTrialRecords.containedForcedRewards];
    out.compiledTrialRecords.didStochasticResponse = [out.compiledTrialRecords.didStochasticResponse tempCurr.compiledTrialRecords.didStochasticResponse];
    out.compiledTrialRecords.correctionTrial = [out.compiledTrialRecords.correctionTrial tempCurr.compiledTrialRecords.correctionTrial];
    out.compiledTrialRecords.numRequests = [out.compiledTrialRecords.numRequests tempCurr.compiledTrialRecords.numRequests];
    out.compiledTrialRecords.firstIRI = [out.compiledTrialRecords.firstIRI tempCurr.compiledTrialRecords.firstIRI];
    out.compiledTrialRecords.responseTime = [out.compiledTrialRecords.responseTime tempCurr.compiledTrialRecords.responseTime];
    out.compiledTrialRecords.actualRewardDuration = [out.compiledTrialRecords.actualRewardDuration tempCurr.compiledTrialRecords.actualRewardDuration];
    out.compiledTrialRecords.proposedRewardDuration = [out.compiledTrialRecords.proposedRewardDuration tempCurr.compiledTrialRecords.proposedRewardDuration];
    out.compiledTrialRecords.proposedPenaltyDuration = [out.compiledTrialRecords.proposedPenaltyDuration tempCurr.compiledTrialRecords.proposedPenaltyDuration];
    out.compiledTrialRecords.response = [out.compiledTrialRecords.response tempCurr.compiledTrialRecords.response];
    
    % update the compiledLUT
    out.compiledLUT = {(out.compiledLUT{:}),(tempCurr.compiledLUT{:})};
    
    % update compiledDetails
    classNames = {out.compiledDetails.className};
    for j = 1:length(tempCurr.compiledDetails)
        % curr class name
        currClassName = tempCurr.compiledDetails(j).className;
        whichInOlder = find(ismember(classNames,currClassName));
        if ~isempty(whichInOlder)
            switch currClassName
                case 'orientedGabors'
                case 'images'
                    out.compiledDetails(whichInOlder).records.correctionTrial = [out.compiledDetails(whichInOlder).records.correctionTrial tempCurr.compiledDetails(j).records.correctionTrial];
                    out.compiledDetails(whichInOlder).records.pctCorrectionTrials = [out.compiledDetails(whichInOlder).records.pctCorrectionTrials tempCurr.compiledDetails(j).records.pctCorrectionTrials];
                    out.compiledDetails(whichInOlder).records.leftIm = [out.compiledDetails(whichInOlder).records.leftIm tempCurr.compiledDetails(j).records.leftIm+maxLUTNum];
                    out.compiledDetails(whichInOlder).records.rightIm = [out.compiledDetails(whichInOlder).records.rightIm tempCurr.compiledDetails(j).records.rightIm+maxLUTNum];
                    out.compiledDetails(whichInOlder).records.suffices = [out.compiledDetails(whichInOlder).records.suffices tempCurr.compiledDetails(j).records.suffices];
                case 'afcGratings'
                    tempCurr.compiledDetails(j).records.afcGratingType = tempCurr.compiledDetails(j).records.afcGratingType+maxLUTNum;
                    
                    out.compiledDetails(whichInOlder).records.correctionTrial      = [out.compiledDetails(whichInOlder).records.correctionTrial       tempCurr.compiledDetails(j).records.correctionTrial     ];
                    out.compiledDetails(whichInOlder).records.pctCorrectionTrials  = [out.compiledDetails(whichInOlder).records.pctCorrectionTrials   tempCurr.compiledDetails(j).records.pctCorrectionTrials ];
                    out.compiledDetails(whichInOlder).records.doCombos             = [out.compiledDetails(whichInOlder).records.doCombos              tempCurr.compiledDetails(j).records.doCombos            ];
                    out.compiledDetails(whichInOlder).records.pixPerCycs           = [out.compiledDetails(whichInOlder).records.pixPerCycs            tempCurr.compiledDetails(j).records.pixPerCycs          ];
                    out.compiledDetails(whichInOlder).records.driftfrequencies     = [out.compiledDetails(whichInOlder).records.driftfrequencies      tempCurr.compiledDetails(j).records.driftfrequencies    ];
                    out.compiledDetails(whichInOlder).records.orientations         = [out.compiledDetails(whichInOlder).records.orientations          tempCurr.compiledDetails(j).records.orientations        ];
                    out.compiledDetails(whichInOlder).records.phases               = [out.compiledDetails(whichInOlder).records.phases                tempCurr.compiledDetails(j).records.phases              ];
                    out.compiledDetails(whichInOlder).records.contrasts            = [out.compiledDetails(whichInOlder).records.contrasts             tempCurr.compiledDetails(j).records.contrasts           ];
                    out.compiledDetails(whichInOlder).records.maxDuration          = [out.compiledDetails(whichInOlder).records.maxDuration           tempCurr.compiledDetails(j).records.maxDuration         ];
                    out.compiledDetails(whichInOlder).records.radii                = [out.compiledDetails(whichInOlder).records.radii                 tempCurr.compiledDetails(j).records.radii               ];
                    out.compiledDetails(whichInOlder).records.annuli               = [out.compiledDetails(whichInOlder).records.annuli                tempCurr.compiledDetails(j).records.annuli              ];
                    out.compiledDetails(whichInOlder).records.afcGratingType       = [out.compiledDetails(whichInOlder).records.afcGratingType        tempCurr.compiledDetails(j).records.afcGratingType      ];
                case 'afcGratingsWithOrientedSurround'
                    tempCurr.compiledDetails(j).records.afcGratingType = tempCurr.compiledDetails(j).records.afcGratingType+maxLUTNum;
                    
                    out.compiledDetails(whichInOlder).records.correctionTrial               = [out.compiledDetails(whichInOlder).records.correctionTrial                tempCurr.compiledDetails(j).records.correctionTrial         ];
                    out.compiledDetails(whichInOlder).records.pctCorrectionTrials           = [out.compiledDetails(whichInOlder).records.pctCorrectionTrials            tempCurr.compiledDetails(j).records.pctCorrectionTrials     ];
                    out.compiledDetails(whichInOlder).records.doCombos                      = [out.compiledDetails(whichInOlder).records.doCombos                       tempCurr.compiledDetails(j).records.doCombos                ];
                    out.compiledDetails(whichInOlder).records.pixPerCycsCenter              = [out.compiledDetails(whichInOlder).records.pixPerCycsCenter               tempCurr.compiledDetails(j).records.pixPerCycsCenter        ];
                    out.compiledDetails(whichInOlder).records.driftfrequenciesCenter        = [out.compiledDetails(whichInOlder).records.driftfrequenciesCenter         tempCurr.compiledDetails(j).records.driftfrequenciesCenter  ];
                    out.compiledDetails(whichInOlder).records.orientationsCenter            = [out.compiledDetails(whichInOlder).records.orientationsCenter             tempCurr.compiledDetails(j).records.orientationsCenter      ];
                    out.compiledDetails(whichInOlder).records.phasesCenter                  = [out.compiledDetails(whichInOlder).records.phasesCenter                   tempCurr.compiledDetails(j).records.phasesCenter            ];
                    out.compiledDetails(whichInOlder).records.contrastsCenter               = [out.compiledDetails(whichInOlder).records.contrastsCenter                tempCurr.compiledDetails(j).records.contrastsCenter         ];
                    out.compiledDetails(whichInOlder).records.radiiCenter                   = [out.compiledDetails(whichInOlder).records.radiiCenter                    tempCurr.compiledDetails(j).records.radiiCenter             ];
                    out.compiledDetails(whichInOlder).records.pixPerCycsSurround            = [out.compiledDetails(whichInOlder).records.pixPerCycsSurround             tempCurr.compiledDetails(j).records.pixPerCycsSurround      ];
                    out.compiledDetails(whichInOlder).records.driftfrequenciesSurround      = [out.compiledDetails(whichInOlder).records.driftfrequenciesSurround       tempCurr.compiledDetails(j).records.driftfrequenciesSurround];
                    out.compiledDetails(whichInOlder).records.orientationsSurround          = [out.compiledDetails(whichInOlder).records.orientationsSurround           tempCurr.compiledDetails(j).records.orientationsSurround    ];
                    out.compiledDetails(whichInOlder).records.phasesSurround                = [out.compiledDetails(whichInOlder).records.phasesSurround                 tempCurr.compiledDetails(j).records.phasesSurround          ];
                    out.compiledDetails(whichInOlder).records.contrastsSurround             = [out.compiledDetails(whichInOlder).records.contrastsSurround              tempCurr.compiledDetails(j).records.contrastsSurround       ];
                    out.compiledDetails(whichInOlder).records.radiiSurround                 = [out.compiledDetails(whichInOlder).records.radiiSurround                  tempCurr.compiledDetails(j).records.radiiSurround           ];
                    out.compiledDetails(whichInOlder).records.maxDuration                   = [out.compiledDetails(whichInOlder).records.maxDuration                    tempCurr.compiledDetails(j).records.maxDuration             ];
                    out.compiledDetails(whichInOlder).records.afcGratingType                = [out.compiledDetails(whichInOlder).records.afcGratingType                 tempCurr.compiledDetails(j).records.afcGratingType          ];
                otherwise
                    currClassName
                    error('dont knowhow to deal with this class');
            end
            out.compiledDetails(whichInOlder).trialNums = [out.compiledDetails(whichInOlder).trialNums tempCurr.compiledDetails(j).trialNums+maxTrialNum];
            out.compiledDetails(whichInOlder).bailedTrialNums = [out.compiledDetails(whichInOlder).bailedTrialNums tempCurr.compiledDetails(j).bailedTrialNums+maxTrialNum];
        else
            switch currClassName
                case 'orientedGabors'
                case 'images'
                case 'afcGratings'
                    tempCurr.compiledDetails(j).records.afcGratingType = tempCurr.compiledDetails(j).records.afcGratingType+maxLUTNum;
                case 'afcGratingsWithOrientedSurround'
                    tempCurr.compiledDetails(j).records.afcGratingType = tempCurr.compiledDetails(j).records.afcGratingType+maxLUTNum;
                otherwise
                    currClassName
                    error('dont knowhow to deal with this class');
            end
            out.compiledDetails(end+1) = tempCurr.compiledDetails(j);
        end
    end
    
    % update the running tallys now
    maxLUTNum = length(out.compiledLUT);
    maxTrialNum = max(out.compiledTrialRecords.trialNumber);
end
if nargin==3
    saveLoc = fullfile(localSaveID{1},sprintf('%s.compiledTrialRecords.1-%d.mat',localSaveID{2},length(out.compiledTrialRecords.trialNumber)))
    compiledTrialRecords = out.compiledTrialRecords;
    compiledDetails = out.compiledDetails;
    compiledLUT = out.compiledLUT;
    save(saveLoc,'compiledTrialRecords','compiledDetails','compiledLUT');
    keyboard
    clear compiledTrialRecords
    clear compiledDetails
    clear compiledLUT
end
end