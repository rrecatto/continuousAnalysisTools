function [out s updateSM]=getLUT(s,bits)
if isempty(s.LUT) || s.LUTbits~=bits
    updateSM=true;
    s.LUTbits=bits;
%     s=fillLUT(s,'useThisMonitorsUncorrectedGamma');
    % s=fillLUT(s,'linearizedDefault',[0 1],false);
%     s=fillLUT(s,'hardwiredLinear',[0 1],false);
    [a b] = getMACaddress;
    if ismember(b,{'7CD1C3E5176F',... balaji Macbook air
            })
        s=fillLUT(s,'useThisMonitorsUncorrectedGamma');
    else
        s=fillLUT(s,'localCalibStore');
    end
else
    updateSM=false;
end
out=s.LUT;