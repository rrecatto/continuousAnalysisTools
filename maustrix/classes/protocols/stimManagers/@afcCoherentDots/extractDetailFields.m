function [out newLUT]=extractDetailFields(sm,basicRecords,trialRecords,LUTparams)
newLUT=LUTparams.compiledLUT;

try
    stimDetails=[trialRecords.stimDetails];
    [out.correctionTrial, newLUT] = extractFieldAndEnsure(stimDetails,{'correctionTrial'},'scalar',newLUT);
    [out.pctCorrectionTrials, newLUT] = extractFieldAndEnsure(stimDetails,{'pctCorrectionTrials'},'scalar',newLUT);
    [out.doCombos, newLUT] = extractFieldAndEnsure(stimDetails,{'doCombos'},'scalar',newLUT);
    
    [out.numDots, newLUT] = extractFieldAndEnsure(stimDetails,{'numDots'},'scalar',newLUT);
    [out.bkgdNumDots, newLUT] = extractFieldAndEnsure(stimDetails,{'bkgdNumDots'},'scalar',newLUT);
    
    [out.dotCoherence, newLUT] = extractFieldAndEnsure(stimDetails,{'dotCoherence'},'scalar',newLUT);
    [out.bkgdCoherence, newLUT] = extractFieldAndEnsure(stimDetails,{'bkgdCoherence'},'scalar',newLUT);
    
    [out.dotSpeed, newLUT] = extractFieldAndEnsure(stimDetails,{'dotSpeed'},'scalar',newLUT);
    [out.bkgdSpeed, newLUT] = extractFieldAndEnsure(stimDetails,{'bkgdSpeed'},'scalar',newLUT);
    
    [out.dotDirection, newLUT] = extractFieldAndEnsure(stimDetails,{'dotDirection'},'scalar',newLUT);
    [out.bkgdDirection, newLUT] = extractFieldAndEnsure(stimDetails,{'bkgdDirection'},'scalar',newLUT);
    
    [out.dotColor, newLUT] = extractFieldAndEnsure(stimDetails,{'dotColor'},'equalLengthVects',newLUT);
    [out.bkgdDotColor, newLUT] = extractFieldAndEnsure(stimDetails,{'bkgdDotColor'},'equalLengthVects',newLUT);
    
    [out.dotSize, newLUT] = extractFieldAndEnsure(stimDetails,{'dotSize'},'scalar',newLUT);
    [out.bkgdSize, newLUT] = extractFieldAndEnsure(stimDetails,{'bkgdSize'},'scalar',newLUT);
    
    [out.dotShape, newLUT] = extractFieldAndEnsure(stimDetails,{'dotShape'},'scalarLUT',newLUT);
    [out.bkgdShape, newLUT] = extractFieldAndEnsure(stimDetails,{'bkgdShape'},'scalarLUT',newLUT);
    
    [out.maxDuration, newLUT] = extractFieldAndEnsure(stimDetails,{'maxDuration'},'scalar',newLUT);
    [out.background, newLUT] = extractFieldAndEnsure(stimDetails,{'background'},'scalar',newLUT);
    
    [out.height, newLUT] = extractFieldAndEnsure(stimDetails,{'height'},'scalar',newLUT);
    [out.width, newLUT] = extractFieldAndEnsure(stimDetails,{'width'},'scalar',newLUT);
    
    [out.seedVal, newLUT] = extractFieldAndEnsure(stimDetails,{'seedVal'},'scalar',newLUT);
    
    [out.rngMethod, newLUT] = extractFieldAndEnsure(stimDetails,{'rngMethod'},'scalarLUT',newLUT);
    
    [out.renderMode, newLUT] = extractFieldAndEnsure(stimDetails,{'renderMode'},'scalarLUT',newLUT);
    
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