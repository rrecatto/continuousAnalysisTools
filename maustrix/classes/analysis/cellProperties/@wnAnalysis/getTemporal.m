function [outSTA outSTV outSEM] = getTemporal(s,pos)
if ~exist('pos','var')||isempty(pos)
    warning('assuming you are asking for the relevantIndex');
    pos = s.relevantIndex;
end
if any(pos)<=0 || ~all(iswholenumber(pos))
    error('position should be positive integers');
elseif length(pos)>3
    error('pos should correspond to one pixel and possibly a time point');
elseif pos(1)>size(s.STA,1) || pos(2)>size(s.STA,2)
    error('requested pixel should exist');
end
outSTA = squeeze(s.STA(pos(1),pos(2),:));
outSTV = squeeze(s.STV(pos(1),pos(2),:));
outSEM = outSTV/s.numSpikes*1.96;
end
