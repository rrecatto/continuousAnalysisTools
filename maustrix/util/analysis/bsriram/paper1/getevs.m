% function [evs, evinfo] = getevs(filename)
%   input: 
%     file - an e file (generated by runenv3 from a bw .uff file)
%            containing event times as long integers
%   outputs:
%     evs - an array of event times 
%     evinfo - the number of events and the originating filename
%
%  comment: based on getevs.pro (RCR IDL code)
%
% PR 6/97

function [evs, evinfo] = getevs(filename)

if nargin<1,
 error('syntax: getevs(efile)');
end

fid = fopen(filename); % open the file
if fid>1 % file opened OK
   
   [evs, N] = fread(fid, inf, 'long');
   evinfo = sprintf('%d\t%s', N, filename);
else
   msg=sprintf('could not open file %s');
   error(msg)
end
