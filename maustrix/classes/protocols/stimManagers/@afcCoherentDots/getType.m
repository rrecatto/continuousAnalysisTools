function out = getType(sm,stim)
sweptParameters = getDetails(sm,stim,'sweptParameters');
n= length(sweptParameters);
switch n
    case 0
        out = 'afcGratings_noSweep';
    case 1
        % sweep of a single datatype
        switch sweptParameters{1}
            case 'numDots'
                out = 'afcCoherentDots_numDots';
            case 'bkgdNumDots'
                out = 'afcCoherentDots_bkgdNumDots';
            case 'dotCoherence'
                out = 'afcCoherentDots_dotCoherence';
            case 'bkgdCoherence'
                out = 'afcCoherentDots_bkgdCoherence';
            case 'dotSpeed'
                out = 'afcCoherentDots_dotSpeed';
            case 'bkgdSpeed'
                out = 'afcCoherentDots_bkgdSpeed';
            case 'dotDirection'
                out = 'afcCoherentDots_dotDirection';
            case 'bkgdDirection'
                out = 'afcCoherentDots_bkgdDirection';
            case 'dotColor'
                out = 'afcCoherentDots_dotColor';
            case 'bkgdDotColor'
                out = 'afcCoherentDots_bkgdDotColor';
            case 'dotSize'
                out = 'afcCoherentDots_dotSize';
            case 'bkgdSize'
                out = 'afcCoherentDots_bkgdSize';
            case 'dotShape'
                out = 'afcCoherentDots_dotShape';
            case 'bkgdShape'
                out = 'afcCoherentDots_bkgdShape';
            case 'maxDuration'
                out = 'afcCoherentDots_maxDuration';
            otherwise
                out = 'undefinedGratings';
        end
    case 2        
        error('if you want to get this working, you are gonna have to create a name for it. look at the previous line for a format');
    case 3
        error('if you want to get this working, you are gonna have to create a name for it. look at the previous line for a format');    
    case 4
        error('if you want to get this working, you are gonna have to create a name for it. look at the previous line for a format');    
    otherwise
        error('unsupported type. if you want this make a name for it');
end
end