function out = nearestFactor(in,factor,mode)

if ~exist('factor','var')||isempty(factor)
    factor = 1;
elseif ~isposintscalar(factor)  
    error('factor should be a positive integer');
end

if ~exist('mode','var')||isempty(mode)
    mode = 'nearest';
end

switch mode
    case 'nearest'
        q = in/factor;
        if (ceil(q)-q)<(q-floor(q))
            out = ceil(q)*factor;
        else
            out = floor(q)*factor;
        end
    case 'higher'
        out = ceil(in/factor)*factor;
    case 'lower'
        put = floor(in/factor)*factor;
    otherwise
        mode
        error('unknown mode');
end