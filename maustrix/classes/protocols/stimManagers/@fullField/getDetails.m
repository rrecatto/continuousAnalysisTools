function out = getDetails(sm,stim,what)

switch what
    case 'sweptParameters'
        names={'frequencies','contrasts','durations','radii','annuli'};
        
        numValsPerParam = [length(stim.stimulusDetails.frequencies) length(stim.stimulusDetails.contrasts)...
            length(stim.stimulusDetails.durations) length(stim.stimulusDetails.radii) length(stim.stimulusDetails.annuli)];
        
        out=names(find(numValsPerParam>1));
    otherwise
        error('unknown what');
end
end