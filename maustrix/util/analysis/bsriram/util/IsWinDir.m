function out = IsWinDir(in)

if ~exist('in','var')||isempty(in)||~ischar(in)
    error('need an in that is char')
end
out = true;
if any(strcmp(in(1),{'/','~'}))
    out = false;
end
end