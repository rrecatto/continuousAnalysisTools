function [out newLUT]=extractDetailFields(sm,basicRecords,trialRecords,LUTparams)
newLUT=LUTparams.compiledLUT;

try
%     stimDetails=[trialRecords.stimDetails];
    stimDetails(length(trialRecords)).correctionTrial = NaN;
    for i = 1:length(trialRecords)
        if isstruct(trialRecords(i).stimDetails)
            stimDetails(i).pctCorrectionTrials = trialRecords(i).stimDetails.pctCorrectionTrials;
            stimDetails(i).correctionTrial = trialRecords(i).stimDetails.correctionTrial;
            stimDetails(i).afcGratingType = trialRecords(i).stimDetails.afcGratingType;
            stimDetails(i).doCombos = trialRecords(i).stimDetails.doCombos;
            stimDetails(i).pixPerCycsCenter = trialRecords(i).stimDetails.pixPerCycsCenter;
            stimDetails(i).driftfrequenciesCenter = trialRecords(i).stimDetails.driftfrequenciesCenter;
            stimDetails(i).orientationsCenter = trialRecords(i).stimDetails.orientationsCenter;
            stimDetails(i).phasesCenter = trialRecords(i).stimDetails.phasesCenter;
            stimDetails(i).contrastsCenter = trialRecords(i).stimDetails.contrastsCenter;
            stimDetails(i).radiiCenter = trialRecords(i).stimDetails.radiiCenter;
            stimDetails(i).pixPerCycsSurround = trialRecords(i).stimDetails.pixPerCycsSurround;
            stimDetails(i).driftfrequenciesSurround = trialRecords(i).stimDetails.driftfrequenciesSurround;
            stimDetails(i).orientationsSurround = trialRecords(i).stimDetails.orientationsSurround;
            stimDetails(i).phasesSurround = trialRecords(i).stimDetails.phasesSurround;
            stimDetails(i).contrastsSurround = trialRecords(i).stimDetails.contrastsSurround;
            stimDetails(i).radiiSurround = trialRecords(i).stimDetails.radiiSurround;
            stimDetails(i).maxDuration = trialRecords(i).stimDetails.maxDuration;
            stimDetails(i).waveform = trialRecords(i).stimDetails.waveform;
            stimDetails(i).centerSize = trialRecords(i).stimDetails.centerSize;
            stimDetails(i).surroundMask = trialRecords(i).stimDetails.surroundMask;
            stimDetails(i).stimManagerClass = trialRecords(i).stimDetails.stimManagerClass;
            stimDetails(i).trialManagerClass = trialRecords(i).stimDetails.trialManagerClass;
            stimDetails(i).scaleFactor = trialRecords(i).stimDetails.scaleFactor;
            
        else
            stimDetails(i).pctCorrectionTrials = nan;
            stimDetails(i).correctionTrial = nan;
            stimDetails(i).afcGratingType = 'n/a';
            stimDetails(i).doCombos = nan;
            stimDetails(i).pixPerCycsCenter = nan;
            stimDetails(i).driftfrequenciesCenter = nan;
            stimDetails(i).orientationsCenter = nan;
            stimDetails(i).phasesCenter = nan;
            stimDetails(i).contrastsCenter = nan;
            stimDetails(i).radiiCenter = nan;
            stimDetails(i).pixPerCycsSurround = nan;
            stimDetails(i).driftfrequenciesSurround = nan;
            stimDetails(i).orientationsSurround = nan;
            stimDetails(i).phasesSurround = nan;
            stimDetails(i).contrastsSurround = nan;
            stimDetails(i).radiiSurround = nan;
            stimDetails(i).maxDuration = nan;
            stimDetails(i).waveform = 'n/a';
            stimDetails(i).centerSize = nan;
            stimDetails(i).surroundMask = nan;
            stimDetails(i).stimManagerClass = 'n/a';
            stimDetails(i).trialManagerClass = 'n/a';
            stimDetails(i).scaleFactor = nan;
            
        end
    end
    [out.correctionTrial newLUT] = extractFieldAndEnsure(stimDetails,{'correctionTrial'},'scalar',newLUT);
    [out.pctCorrectionTrials newLUT] = extractFieldAndEnsure(stimDetails,{'pctCorrectionTrials'},'scalar',newLUT);
    [out.doCombos newLUT] = extractFieldAndEnsure(stimDetails,{'doCombos'},'scalar',newLUT);
    
    [out.pixPerCycsCenter newLUT] = extractFieldAndEnsure(stimDetails,{'pixPerCycsCenter'},'scalar',newLUT);
    [out.driftfrequenciesCenter newLUT] = extractFieldAndEnsure(stimDetails,{'driftfrequenciesCenter'},'scalar',newLUT);
    [out.orientationsCenter newLUT] = extractFieldAndEnsure(stimDetails,{'orientationsCenter'},'scalar',newLUT);
    [out.phasesCenter newLUT] = extractFieldAndEnsure(stimDetails,{'phasesCenter'},'scalar',newLUT);
    [out.contrastsCenter newLUT] = extractFieldAndEnsure(stimDetails,{'contrastsCenter'},'scalar',newLUT);
    [out.radiiCenter newLUT] = extractFieldAndEnsure(stimDetails,{'radiiCenter'},'scalar',newLUT);
    
    [out.pixPerCycsSurround newLUT] = extractFieldAndEnsure(stimDetails,{'pixPerCycsSurround'},'scalar',newLUT);
    [out.driftfrequenciesSurround newLUT] = extractFieldAndEnsure(stimDetails,{'driftfrequenciesSurround'},'scalar',newLUT);
    [out.orientationsSurround newLUT] = extractFieldAndEnsure(stimDetails,{'orientationsSurround'},'scalar',newLUT);
    [out.phasesSurround newLUT] = extractFieldAndEnsure(stimDetails,{'phasesSurround'},'scalar',newLUT);
    [out.contrastsSurround newLUT] = extractFieldAndEnsure(stimDetails,{'contrastsSurround'},'scalar',newLUT);
    [out.radiiSurround newLUT] = extractFieldAndEnsure(stimDetails,{'radiiSurround'},'scalar',newLUT);
    
    
    [out.maxDuration newLUT] = extractFieldAndEnsure(stimDetails,{'maxDuration'},'scalar',newLUT);    
    [out.afcGratingType newLUT] = extractFieldAndEnsure(stimDetails,{'afcGratingType'},'scalarLUT',newLUT);

catch ex
    out=handleExtractDetailFieldsException(sm,ex,trialRecords);
    verifyAllFieldsNCols(out,length(trialRecords));
    return
end

verifyAllFieldsNCols(out,length(trialRecords));
end