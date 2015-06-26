function succ = ping(dataIP)
if IsWin
    pingStr = sprintf('ping -n 3 %s',dataIP);
    a = dos(pingStr);
    succ = ~a;
elseif IsOSX || IsLinux
    warning('not yet');
    succ = false;
end
end