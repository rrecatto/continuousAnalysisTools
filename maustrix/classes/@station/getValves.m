function valves =getValves(s)
if strcmp(s.responseMethod,'parallelPort')
    
    status=fastDec2Bin(lptread(s.valvePins.decAddr));
    
    valves=status(s.valvePins.bitLocs)=='1'; %need to set parity in station, assumes normally closed valves
    valves(s.valvePins.invs)=~valves(s.valvePins.invs);
else
    if ~ismac
        warning('can''t read ports without parallel port')
    end
    valves=false(1,s.numPorts);%*s.valvePins.bitLocs;
end