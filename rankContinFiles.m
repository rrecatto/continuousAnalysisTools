function [rankings] = rankContinFiles(continFolder)
% [list] = rankContinFiles(folder)
%   Takes a folder of contin files and uses very quick version of spike
%   detection to determine which continuous files are more likely to
%   produce best/most spikes.
%
%  PARAMETERS:
%    1. continFolder = folder containing all contin files to rank
%
%  RETURN VALUES:
%    2. rankings = list of ints ex: [5,3,7,1...] where index
%    represents ranking of continuous file and rankings[index] = channel
%    of that file.
%    i.e. in this examples, channel 5 is best, 3 is second, etc...
%
%   Author: Robert Recatto
%   Date: 6/22/15
%

% NOTE: assumes file titles in default format return by OpenEphys i.e
%       (processerID_CHx.continuous) where x is the channel number. And
%       that files are in order of their channel number!
% ALSO: Uses random to not favor any type of spike time difference 
%       correlations. 

% 1. Cycle through each continuous file in folder

% TEST DATA
% rankContinReturn spikes found:
%  [ 214   162   154   150   164   178   191 ]
% rankings:
%  [ 1     7     6     5     2     3     4 ]
%
% load_open_ephys_data/spike detect spikes found:
%  [ 778   147   128   113   143  178   348 ]
% rankings:
%  [ 1     7     6     2     5     3     4 ]
%
% HOWEVER: note that since algorithm runs using random numbers, rankings of
%          channel 2 and channel 5 flip flop pretty frequently for this
%          particular data set. 

fPath = [continFolder,'\*.continuous'];
files = dir(fPath);
spikesFound = zeros(1, length(files));
currChannel = 1;
for file = files'
    [data, timestamps, info] = load_open_ephys_data([continFolder,'\',file.name]);
    
    %2. gets mean and stdDev for upper/lower bounds
    mVal = mean(data);
    stdDev = std(data);
    i = 1;
    
    while i < length(data)
        if ((data(i) >= (mVal + 10*stdDev)) || (data(i) < (mVal - 10*stdDev)))
            
            %3. stores number of spikes found in array
            spikesFound(currChannel) = spikesFound(currChannel) + 1;
            
            %skip forward random amount of time .001s<t<1.001s
            r = rand;
            i = ceil(i + 30 + 30000*r);
        else                            
            i = i + 1;
        end 
    end
    currChannel = currChannel + 1;
end

% 4. construct rankings array using number of spikes found. 
rankings = zeros(1, currChannel-1);
disp(['Spikes Found: ']);
disp(spikesFound);
for rank = [1:currChannel-1]
    [m index] = max(spikesFound);
    rankings(rank) = index;
    spikesFound(index) = -1;
end

end

