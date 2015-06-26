function out = getDetails(sm,stim,what)

switch what
    case 'sweptParameters'
        sweepnames={'spatialFrequencies','driftfrequencies','orientations','contrasts','phases','durations','radii','annuli'};
        
        numValsPerParam = [length(stim.stimulusDetails.spatialFrequencies) length(stim.stimulusDetails.driftfrequencies) length(stim.stimulusDetails.orientations)...
            length(stim.stimulusDetails.contrasts) length(stim.stimulusDetails.phases) length(stim.stimulusDetails.durations)...
            length(stim.stimulusDetails.radii) length(stim.stimulusDetails.annuli)];
        
        out=sweepnames(find(numValsPerParam>1));
    otherwise
        error('unknown what');
end
end