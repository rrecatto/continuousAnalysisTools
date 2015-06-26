function [out s updateSM]=getLUT(s,bits)
if isempty(s.LUT) || s.LUTbits~=bits
    updateSM=true;
    s.LUTbits=bits;
    %s=fillLUT(s,'useThisMonitorsUncorrectedGamma');  %TEMP - don't commit
    %s=fillLUT(s,'tempLinearRedundantCode');
    %s=fillLUT(s,'2009Trinitron255GrayBoxInterpBkgnd.5');
    %s=fillLUT(s,'ViewSonicPF790-VCDTS21611_Mar2011_255RGBBoxInterpBkgnd.5'); % March 2011 ViewSonic
%     s=fillLUT(s,'WestinghouseL2410NM_May2011_255RGBBoxInterpBkgnd.5'); % May 2011 Westinghouse
    s=fillLUT(s,'localCalibStore');
else
    updateSM=false;
end
out=s.LUT;