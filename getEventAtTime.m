function [timeDifference mostRecentChannel edge] = getEventAtTime(time, eventChannel, eventID, eventTimes)
% [Int Int] = getEventAtTime(Int, List, List);
% Gets corresponding events at specific timestamps to correlate a potential
% spike with the event occuring at that time. 
%
%   PARAMETERS:
%      1. time: time at which spike or data occurs to check for correspondance
%      2. eventChannels: channels data from events file.
%      3. eventID: all on/off data from events file. 
%      4. eventTimes: timestamps corresponding to the eventData passed in. 
%
%    RETURN VALUES:
%      1. timeDifference = the time between most recent event and the
%      passed in spike time. 
%      2. mostRecentChannel = channel that most recent event occured in. 
%      3. edge = if channel was turned on of off. 1 for on 0 for off.
%      NOTE: (-1) returned for both if time passed in occurs before first
%            event.
%
%   Author: Robert Recatto
%   Date: 6/22/15
%


for i = [1:length(eventTimes)]
    if time >= eventTimes(i)
       if  i == 1 || i == 2 || i == 3 || i == 4
           timeDifference = -1;
           mostRecentChannel = -1;
       else %back 4 b/c of duplicate as well
           timeDifference = (time - eventTimes(i-4));
           mostRecentChannel = eventChannel(i-4);
           if eventID(i-4) == 1.0
               edge = 'ON';
           else
               edge = 'OFF';
           end
       end
    else %skip ahead 4 places because of duplicates problem
        i = i + 4;
    end
end


end

