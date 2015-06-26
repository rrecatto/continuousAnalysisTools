function ip=getIPAddress
ip='';
try
     address = java.net.InetAddress.getLocalHost;
     ip = char(address.getHostAddress);
catch ex
    % java not working probably
    warning('This works only for ucsd.edu IP addresses');
    if IsWin
        [junk, b]=dos('ipconfig');
    elseif IsOSX || IsLinux
        [junk, b]=system('ifconfig');
    end
    [junk, tokens] = regexpi(b, '(132.239.\d{2,3}.\d{2,3})', 'match', 'tokens'); % was 158
    if ~isempty(tokens) && length(tokens) == 1
        ip = tokens{1}{1};
    else
        error('failed to retrieve exact IP address for this machine');
    end
end