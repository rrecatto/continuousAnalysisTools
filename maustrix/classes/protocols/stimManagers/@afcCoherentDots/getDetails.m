function out = getDetails(sm,stim,what)

switch what
    case 'sweptParameters'
        if stim.doCombos
            sweepnames={'numDots','dotCoherence','dotSpeed','dotDirection','dotSize','dotShape','maxDuration'};
            
            which = [false false false false false false false];
            for i = 1:length(sweepnames)
                if length(stim.(sweepnames{i}){1})>1 || length(stim.(sweepnames{i}){2})>1
                    which(i) = true;
                end
            end
            out1=sweepnames(which);
            
            if stim.bkgdNumDots{1}>0 || stim.bkgdNumDots{2}>0
                sweepnames={'bkgdNumDots','bkgdCoherence','bkgdSpeed','bkgdDirection','bkgdSize','bkgdShape'};
                which = [false false false false false false];
                for i = 1:length(sweepnames)
                    if length(stim.(sweepnames{i}){1})>1 || length(stim.(sweepnames{i}){2})>1
                        which(i) = true;
                    end
                end
                out2=sweepnames(which);
            else
                out2 = {};
            end
            
            out = {out1{:},out2{:}};
            
            if size(stim.dotColor{1},1)>1 || size(stim.dotColor{2},1)>1
                out{end+1} = 'dotColor';
            end
            
            if size(stim.bkgdDotColor{1},1)>1 || size(stim.bkgdDotColor{2},1)>1
                out{end+1} = 'bkgdDotColor';
            end
        else
            error('unsupported');
        end
    otherwise
        error('unknown what');
end
end