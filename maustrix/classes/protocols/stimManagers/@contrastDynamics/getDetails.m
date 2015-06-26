function out = getDetails(sm,stim,what)
if isfield(stim,'stimulusDetails')
    stim = stim.stimulusDetails;
end
switch what
    case 'spatialDim'
        out=stim.spatialDim;
    case 'distType'
        out = stim.distribution.type;
    otherwise
        error('unknown what');
end
end