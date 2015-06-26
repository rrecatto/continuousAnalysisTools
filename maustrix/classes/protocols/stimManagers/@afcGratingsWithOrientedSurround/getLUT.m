function [out s updateSM]=getLUT(s,bits)
if isempty(s.LUT) || s.LUTbits~=bits
    updateSM=true;
    s.LUTbits=bits;
    [a b] = getMACaddress;
    if ismember(b,{'7CD1C3E5176F',... balaji Macbook air
            '180373337162',...
            })
        s=fillLUT(s,'useThisMonitorsUncorrectedGamma');
    else
        s=fillLUT(s,'localCalibStore');
    end

else
    updateSM=false;
end
out=s.LUT;