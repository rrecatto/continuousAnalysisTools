function [xx yy numFigs] = getGoodArrangement(nFigs,params)
if ~exist('params','var') || isempty(params)
    params.mode = 'default'
end
switch params.mode
    case 'default'
        xx=floor(sqrt(nFigs));
        yy=ceil(nFigs/xx);
        numFigs = 1;
    case 'maxAxesPerFig'
        if nFigs>params.maxAxesPerFig
        [xx yy] = getGoodArrangement(params.maxAxesPerFig);
        numFigs = ceil(nFigs/params.maxAxesPerFig);
        else
            params.mode = 'default';
           [xx yy] = getGoodArrangement(nFigs,params);
        numFigs = ceil(nFigs/params.maxAxesPerFig);
        end
    case 'onlyVertical'
        xx = nFigs;
        yy = 1;
        numFigs = 1;
    case 'onlyHorizontal'
        xx = 1;
        yy = nFigs;
        numFigs = 1;
    otherwise
        error('unknown method');
end
end