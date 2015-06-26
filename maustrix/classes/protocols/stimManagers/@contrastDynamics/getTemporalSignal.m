
function [sig CI ind]=getTemporalSignal(sm,STA,STV,numSpikes,selection)
switch class(selection)
    case 'char'
        switch selection
            case 'bright'
                [ind]=find(STA==max(STA(:)));  %shortcut for a relavent region
            case 'dark'
                [ind]=find(STA==min(STA(:)));
            otherwise
                selection
                error('bad selection')
        end
        
    case 'double'
        temp=cumprod(size(STA));
        if iswholenumber(selection) && all(size(selection)==1) && selection<=temp(end)
            ind=selection;
        else
            error('bad selection as a double, which should be an index into STA')
        end
    otherwise
        error('bad class for selection')
        
end

try
    %if numSpikes==0 || all(isnan(STA(:)))
    %    ind=1; %to prevent downstream errors, just make one up  THIS DOES
    %    NOT FULLY WORK... need to be smarter... prob no spikes this trial
    %end
    if  numSpikes==0
        ind=1; %to prevent downstream errors, just make one up
    else
        ind=ind(1); %use the first one if there is a tie. (more common with low samples)
    end
catch
    keyboard
end

[X Y T]=ind2sub(size(STA),ind);
ind=[X Y T];
sig = STA(X,Y,:);
if nargout>1
    er95= sqrt(STV(X,Y,:)/numSpikes)*1.96; % b/c std error(=std/sqrt(N)) of mean * 1.96 = 95% confidence interval for gaussian, norminv(.975)
    CI=repmat(sig(:),1,2)+er95(:)*[-1 1];
end
end
