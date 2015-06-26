function out = getType(sm,stim)

sweptParameters = getDetails(sm,stim,'sweptParameters');
n= length(sweptParameters);
switch n
    case 1
        % sweep of a single datatype
        switch sweptParameters{1}
            case 'frequencies'
                out = 'tfFullField';
            case 'contrasts'
                out = 'cntrFullField';
            case 'radii'
                out = 'radiiGratings';
            case 'annuli'
                out = 'annuliGratings';
            otherwise
                out = 'undefinedGratings';
        end
    otherwise
        error('multiple sweeps are un supported');
end
end