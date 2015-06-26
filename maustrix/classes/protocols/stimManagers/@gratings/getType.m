function out = getType(sm,stim)

sweptParameters = getDetails(sm,stim,'sweptParameters');
n= length(sweptParameters);
switch n
    case 1
        % sweep of a single datatype
        switch sweptParameters{1}
            case 'spatialFrequencies'
                out = 'sfGratings';
            case 'driftfrequencies'
                out = 'tfGrating';
            case 'orientations'
                out = 'orGratings';
            case 'contrasts'
                out = 'cntrGrating';
            case 'radii'
                out = 'radiiGratings';
            case 'annuli'
                out = 'annuliGratings';
            otherwise
                out = 'undefinedGratings';
        end
    case 2        
        if any(ismember(sweptParameters,'contrasts')) && ...
                        any(ismember(sweptParameters,'radii'))
                    out = 'cntr-radGratings';
        else
            warning('only special analysis included');
            out = 'unsupported';
        end
    otherwise
        error('multiple sweeps are un supported');
end
end