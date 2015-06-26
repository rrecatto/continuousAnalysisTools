function out = getDetails(sm,stim,what)

switch what
    case 'sweptParameters'
        if stim.doCombos
            if isfield(stim,'spatialFrequencies')
                sweepnames={'spatialFrequencies','driftfrequencies','phases','contrasts','maxDuration','radii','annuli'};
            elseif isfield(stim,'pixPerCycs')
                sweepnames={'pixPerCycs','driftfrequencies','phases','contrasts','maxDuration','radii','annuli'};
            end
            which = [false false false false false false false];
            for i = 1:length(sweepnames)
                if length(stim.(sweepnames{i}){1})>1 || length(stim.(sweepnames{i}){2})>1
                    which(i) = true;
                end
            end
            out=sweepnames(which);
            
            warning('gonna assume same number of orientations for both ports? is that wise?')
            if length(stim.orientations{1})==1 % gonna be intelligent and consider changes by pi to be identical orientations (but they are opposite directions)
                % nothing there was no orientation sweep
            elseif length(stim.orientations{1})==2
                if diff(mod(stim.orientations{1},pi))<0.000001 && diff(mod(stim.orientations{2},pi))<0.000001%allowing for small changes during serialization
                    % they are the same
                else
                    out{end+1} = 'orientations';
                end
            else
                % then length >2 then automatically there is some sweep
                out{end+1} = 'orientations';
            end
        else
            error('unsupported');
        end
    otherwise
        error('unknown what');
end
end