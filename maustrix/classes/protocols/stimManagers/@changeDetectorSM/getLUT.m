function [out s updateSM]=getLUT(s,bits)
if isempty(s.LUT) || s.LUTbits~=bits
    updateSM=true;
    s.LUTbits=bits;
%     s=fillLUT(s,'useThisMonitorsUncorrectedGamma');
    s=fillLUT(s,'localCalibStore');

else
    updateSM=false;
end
out=s.LUT;