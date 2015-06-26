function out = sampleDistribution(s,which)

switch which
    case 'durationToFlip'
        relevant = s.durationToFlip;
    case 'durationAfterFlip'
        relevant = s.durationAfterFlip;
    otherwise
        error('notsupported')
end
out = [];

switch relevant.type
    case 'delta'
        out = relevant.params;
    case 'uniform'
        out = relevant.params.range(1)+diff(relevant.params.range)*rand;
    case 'discrete-uniform'
        possibles = linspace(relevant.params.range(1),relevant.params.range(2),relevant.params.n);
        which = randparm(relevant.params.n);
        which = which(1);
        out = possibles(which);
    case 'exponential'
        error('not yet');
    case 'gaussian'
        error('not yet');
end
end