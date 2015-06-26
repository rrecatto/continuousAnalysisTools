function out = getONOFF(sU,method)

switch method{1}
    case 'binarySpatial'
        relevantAnalysis = sU.getAnalysis(method{1});
        if isempty(relevantAnalysis.analyses)
            out = {'unknown'};
        else
            out = relevantAnalysis.analyses{1}.classify(method{2});
        end
    otherwise
        error('unknown method');
        
end
end