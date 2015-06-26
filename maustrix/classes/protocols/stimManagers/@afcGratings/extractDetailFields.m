function [out newLUT]=extractDetailFields(sm,basicRecords,trialRecords,LUTparams)
newLUT=LUTparams.compiledLUT;

try
    stimDetails=[trialRecords.stimDetails];
    [out.correctionTrial newLUT] = extractFieldAndEnsure(stimDetails,{'correctionTrial'},'scalar',newLUT);
    [out.pctCorrectionTrials newLUT] = extractFieldAndEnsure(stimDetails,{'pctCorrectionTrials'},'scalar',newLUT);
    [out.doCombos newLUT] = extractFieldAndEnsure(stimDetails,{'doCombos'},'scalar',newLUT);
    [out.pixPerCycs newLUT] = extractFieldAndEnsure(stimDetails,{'pixPerCycs'},'scalar',newLUT);
    [out.driftfrequencies newLUT] = extractFieldAndEnsure(stimDetails,{'driftfrequencies'},'scalar',newLUT);
    [out.orientations newLUT] = extractFieldAndEnsure(stimDetails,{'orientations'},'scalar',newLUT);
    [out.phases newLUT] = extractFieldAndEnsure(stimDetails,{'phases'},'scalar',newLUT);
    [out.contrasts newLUT] = extractFieldAndEnsure(stimDetails,{'contrasts'},'scalar',newLUT);
    [out.maxDuration newLUT] = extractFieldAndEnsure(stimDetails,{'maxDuration'},'scalar',newLUT);
    [out.radii newLUT] = extractFieldAndEnsure(stimDetails,{'radii'},'scalar',newLUT);
    [out.annuli newLUT] = extractFieldAndEnsure(stimDetails,{'annuli'},'scalar',newLUT);
    [out.afcGratingType newLUT] = extractFieldAndEnsure(stimDetails,{'afcGratingType'},'scalarLUT',newLUT);
    
catch ex
    if ismember(ex.identifier,{'MATLAB:UnableToConvert'})
        stimDetails(length(trialRecords)).correctionTrial = NaN;
        for i = 1:length(trialRecords)
            if isstruct(trialRecords(i).stimDetails)
                stimDetails(i).pctCorrectionTrials = trialRecords(i).stimDetails.pctCorrectionTrials;
                stimDetails(i).correctionTrial = trialRecords(i).stimDetails.correctionTrial;
                stimDetails(i).afcGratingType = trialRecords(i).stimDetails.afcGratingType;
                stimDetails(i).doCombos = trialRecords(i).stimDetails.doCombos;
                stimDetails(i).pixPerCycs = trialRecords(i).stimDetails.pixPerCycs;
                stimDetails(i).driftfrequencies = trialRecords(i).stimDetails.driftfrequencies;
                stimDetails(i).orientations = trialRecords(i).stimDetails.orientations;
                stimDetails(i).phases = trialRecords(i).stimDetails.phases;
                stimDetails(i).contrasts = trialRecords(i).stimDetails.contrasts;
                stimDetails(i).radii = trialRecords(i).stimDetails.radii;
                stimDetails(i).maxDuration = trialRecords(i).stimDetails.maxDuration;         
            else
                stimDetails(i).pctCorrectionTrials = nan;
                stimDetails(i).correctionTrial = nan;
                stimDetails(i).afcGratingType = 'n/a';
                stimDetails(i).doCombos = nan;
                stimDetails(i).pixPerCycs = nan;
                stimDetails(i).driftfrequencies = nan;
                stimDetails(i).orientations = nan;
                stimDetails(i).phases = nan;
                stimDetails(i).contrasts = nan;
                stimDetails(i).radii = nan;
                stimDetails(i).maxDuration = nan;
            end
        end
        [out.correctionTrial newLUT] = extractFieldAndEnsure(stimDetails,{'correctionTrial'},'scalar',newLUT);
        [out.pctCorrectionTrials newLUT] = extractFieldAndEnsure(stimDetails,{'pctCorrectionTrials'},'scalar',newLUT);
        [out.doCombos newLUT] = extractFieldAndEnsure(stimDetails,{'doCombos'},'scalar',newLUT);
        
        [out.pixPerCycsCenter newLUT] = extractFieldAndEnsure(stimDetails,{'pixPerCycs'},'scalar',newLUT);
        [out.driftfrequenciesCenter newLUT] = extractFieldAndEnsure(stimDetails,{'driftfrequencies'},'scalar',newLUT);
        [out.orientationsCenter newLUT] = extractFieldAndEnsure(stimDetails,{'orientations'},'scalar',newLUT);
        [out.phasesCenter newLUT] = extractFieldAndEnsure(stimDetails,{'phases'},'scalar',newLUT);
        [out.contrastsCenter newLUT] = extractFieldAndEnsure(stimDetails,{'contrasts'},'scalar',newLUT);
        [out.radiiCenter newLUT] = extractFieldAndEnsure(stimDetails,{'radii'},'scalar',newLUT);
      
        [out.maxDuration newLUT] = extractFieldAndEnsure(stimDetails,{'maxDuration'},'scalar',newLUT);
        [out.afcGratingType newLUT] = extractFieldAndEnsure(stimDetails,{'afcGratingType'},'scalarLUT',newLUT);
    else
        out=handleExtractDetailFieldsException(sm,ex,trialRecords);
        verifyAllFieldsNCols(out,length(trialRecords));
        return
    end
end

verifyAllFieldsNCols(out,length(trialRecords));
end