% this returns the path to the directory above this directory
function ratrixPath=getRatrixPath()
% DO U SEE ME?
[pathstr, name, ext] = fileparts(mfilename('fullpath'));
    ratrixPath = fileparts(pathstr);
    ratrixPath = [ratrixPath filesep];