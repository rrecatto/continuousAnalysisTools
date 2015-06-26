function eta = calculateETA(rf,mode)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model of RF (either 1D or 2D)
% rf = nC-S where:
% C : Center
% S : Surround
% weight(C) = weight(S) = 1
% n : relative weight of center to surround
% 
% exp(-x^2/r^2) -> pi*r^2 weight


if ~exist('rf','var')&&~ismember(mode,{'default'})
    error('must specify rf');
end

switch mode
    case 'default'
        error('not yet...');
    case '1D-DOG'
        error('not yet...');
    case '1D-DOG-analytic'
        error('not yet...');
    case '2D-DOG-conv'
        error('not yet...');
    case '2D-DOG-loop'
        error('not yet...');
    case '2D-DOG'
        error('not yet...');
    case '1D-DOG-useSensitivity-analytic'
        eta = (rf.KS*rf.RS*rf.RS)/(rf.KC*rf.RC*rf.RC); 
    case '1D-DOG-useSensitivity'
        eta = (rf.KS*rf.RS*rf.RS)/(rf.KC*rf.RC*rf.RC); 
    otherwise
        error('unsupported mode');
end
end

