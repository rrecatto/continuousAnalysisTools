function [out s updateSM]=getLUT(s,bits);
if isempty(s.LUT) || s.LUTbits~=bits
    updateSM=true;
    s.LUTbits=bits;
%     s=fillLUT(s,'useThisMonitorsUncorrectedGamma');
    %s=fillLUT(s,'2009Trinitron255GrayBoxInterpBkgnd.5');
    %s=fillLUT(s,'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5'); % March 2011 ViewSonic
%     s=fillLUT(s,'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5'); % May 2011 Westinghouse
    [a b] = getMACaddress;
    if ismember(b,{'7CD1C3E5176F'})...,... balaji Macbook air
            
        s=fillLUT(s,'useThisMonitorsUncorrectedGamma');
    else
        s=fillLUT(s,'localCalibStore');
    end
    
else
    updateSM=false;
end
out=s.LUT;