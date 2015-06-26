function sU = replaceAnalysis(sU,aInd,a)
if ~ident(sU.analyses{aInd},a)
    error('cannot change analyses unless they are of the same type');
end
sU.analyses{aInd} = a;
end