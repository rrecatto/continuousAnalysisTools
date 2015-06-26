function out = getType(sm,stim)

nDim = getDetails(sm,stim,'spatialDim');
distType = getDetails(sm,stim,'distType');
switch prod(nDim)
    case 1
        out=[distType 'FullField'];
    otherwise
        out=[distType 'Spatial'];
end
end