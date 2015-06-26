function out = getType(sm,stim)
sweptParameters = getDetails(sm,stim,'sweptParameters');
n= length(sweptParameters);
switch n
    case 0
        out = 'afcGratings_noSweep';
    case 1
        % sweep of a single datatype
        switch sweptParameters{1}
            case {'pixPerCycs','spatialFrequencies'}
                out = 'afcGratings_sfSweep';
            case 'driftfrequencies'
                out = 'afcGratings_tfSweep';
            case 'orientations'
                out = 'afcGratings_orSweep';
            case 'phases'
                out = 'afcGratings_phaseSweep';
            case 'contrasts'
                out = 'afcGratings_cntrSweep';
            case 'maxDuration'
                out = 'afcGratings_durnSweep';
            case 'radii'
                out = 'afcGratings_radSweep';
            case 'annuli'
                out = 'afcGratings_annSweep';                
            otherwise
                out = 'undefinedGratings';
        end
    case 2        
        if all(ismember(sweptParameters,{'contrasts','radii'}))
            out = 'afcGratings_cntrXradSweep';
        elseif all(ismember(sweptParameters,{'contrasts','pixPerCycs'}))
            out = 'afcGratings_cntrXsfSweep';
        elseif all(ismember(sweptParameters,{'phases','maxDuration'}))
            out = 'afcGratings_durationSweep_Stat';
        elseif all(ismember(sweptParameters,{'phases','contrasts'}))
            out = 'afcGratings_contrastSweep_Stat';
        elseif all(ismember(sweptParameters,{'phases','pixPerCycs'}))
            out = 'afcGratings_sfSweep_Stat';
        elseif all(ismember(sweptParameters,{'phases','orientations'}))
            out = 'afcGratings_orSweep_Stat';
        elseif all(ismember(sweptParameters,{'maxDuration','phases'}))
            out = 'afcGratings_durSweep_Stat';
        elseif all(ismember(sweptParameters,{'contrasts','maxDuration'}))
            out = 'afcGratings_cntrXdurSweep_Stat';
        else
            sweptParameters
            error('if you want to get this working, you are gonna have to create a name for it. look at the previous line for a format');
        end
    case 3
        if all(ismember(sweptParameters,{'contrasts','pixPerCycs','driftFrequencies'}))
            out = 'afcGratings_cntrXsfXtfSweep';
        elseif all(ismember(sweptParameters,{'contrasts','pixPerCycs','phases'}))
            out = 'afcGratings_cntrXsfStationary';
        elseif all(ismember(sweptParameters,{'maxDuration','phases','contrasts'}))
            out = 'afcGratings_cntrXdurSweep_Stat';
        else
            sweptParameters
            error('if you want to get this working, you are gonna have to create a name for it. look at the previous line for a format');
        end
    case 4
        if all(ismember(sweptParameters,{'contrasts','pixPerCycs','driftfrequencies','orientations'}))
            out = 'afcGratings_cntrXsfXtfXorSweep';
        else
            sweptParameters
            error('if you want to get this working, you are gonna have to create a name for it. look at the previous line for a format');
        end
    otherwise
        error('unsupported type. if you want this make a name for it');
end
end