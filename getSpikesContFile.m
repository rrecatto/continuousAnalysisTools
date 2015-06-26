function [success] = getSpikesContFile(contFile, eventFile, devsFromMean)
% [ boolean ] = getSpikesContFile(filename) 
%   extracts spikes from cont file, then shows individual spikes found
%
%  PARAMETERS:
%     1. contFile = path of file to detect spikes in
%     2. devsFromMean = (optional with default 10) sets stdDev from mean to
%                       set as upper bound and lower bound of threshold. 
%
%   Author: Robert Recatto
%   Date: 6/22/15
%

% sets default devsFromMean to be 10, otherwise sets to user specified
% number
if nargin < 2
    devsFromMean = 10;
end

% 1. get continuous data using load_open... method
[data, timestamps, info] = load_open_ephys_data(contFile);

% TODO
% 2. get event data using load_open... method
[eventTimes eventID eventChannel] = openEvents(eventFile);

% 3. get mean/stdDev of data
mVal = mean(data);
stdDev = std(data);

% 4. set spikeDetectionParams using mean/stdDev
upperBound = mVal + (devsFromMean*stdDev);
lowerBound = mVal - (devsFromMean*stdDev); 

spikeDetectionParams.method = 'filteredThresh';
spikeDetectionParams.samplingFreq = 30000;
spikeDetectionParams.freqLowHi = [200 10000];
spikeDetectionParams.threshHoldVolts = [lowerBound upperBound];
spikeDetectionParams.waveformWindowMs= 1.5;
spikeDetectionParams.peakWindowMs= 0.6;
spikeDetectionParams.alignMethod = 'atPeak'; %atCrossing
spikeDetectionParams.peakAlignment = 'filtered'; % 'raw'
spikeDetectionParams.returnedSpikes = 'filtered'; % 'raw'
spikeDetectionParams.lockoutDurMs=0.1;  
spikeDetectionParams.thresholdMethod = 'raw';

% adds path of detectSpikes... method
addpath('maustrix\util\spikes\');

% 5. get spikes using detectSpikes... method
[spikes spikeWaveforms spikeTimestamps]= detectSpikesFromNeuralData(data, timestamps, spikeDetectionParams);

% for debugging
%x = [1:46];
%y = spikeWaveforms(:,x);
%plot(x,y);

% start activity, use infinite loop because not sure how to make activities
% in matlab.
prompt = 'b for previous spike, n for next spike, c to plot against continuous file (toggle-able), x for exit: ';
currSpike = 1;
numSpikes = length(spikes);
cVal = 0;

%get event data
currTime = spikeTimestamps(currSpike);
[timeDifference mostRecentChannel edge] = getEventAtTime(currTime, eventChannel, eventID, eventTimes);
if (timeDifference == -1)
    eventTitle = 'Spike Occurs BEFORE First Event';
else
    eventTitle = ['Channel ', num2str(mostRecentChannel), ' Turns ', edge, ' ', num2str(timeDifference), ' Seconds Before Spike'];
end

%plot first spike
plot([1:46], spikeWaveforms(currSpike,:), linspace(1,46,460), mVal, '--g', linspace(1,46,460), upperBound, '--r', linspace(1,46,460), lowerBound, '--r');
t = title(['Spike Number ', num2str(currSpike), ' of ', num2str(numSpikes)]);
xl = xlabel(eventTitle);
set(t, 'FontSize', 20);
set(xl, 'FontSize', 16);


while 0 < 100
            
    %ask for user input
    x = input(prompt, 's');
    
    %if user specifies next spike
    if x == 'n'
        if currSpike == numSpikes
            disp(sprintf(['\nERROR: no more spikes, currently displaying last spike\n']))
        end
        if currSpike < numSpikes
            currSpike = currSpike + 1; %increment
            
            %get event data
            currTime = spikeTimestamps(currSpike);
            [timeDifference mostRecentChannel edge] = getEventAtTime(currTime, eventChannel, eventID, eventTimes);
            if (timeDifference == -1)
                eventTitle = 'Spike Occurs BEFORE First Event';
            else
                eventTitle = ['Channel ', num2str(mostRecentChannel), ' Turns ', edge, ' ', num2str(timeDifference), ' Seconds Before Spike'];
            end
            
            %plot all data
            plot([1:46], spikeWaveforms(currSpike,:), linspace(1,46,460), mVal, '--g', linspace(1,46,460), upperBound, '--r', linspace(1,46,460), lowerBound, '--r');
            t = title(['Spike Number ', num2str(currSpike), ' of ', num2str(numSpikes)]);
            xl = xlabel(eventTitle);
            set(t, 'FontSize', 20);
            set(xl, 'FontSize', 16);
        end
    end
    
    %if user specifies prev spike
    if x == 'b'
        if currSpike == 1
            disp(sprintf(['\nERROR: currently displaying first spike, press n to go to next spike\n']))
        end
        if currSpike > 1
            currSpike = currSpike - 1;
            
            %get event data
            currTime = spikeTimestamps(currSpike);
            [timeDifference mostRecentChannel edge] = getEventAtTime(currTime, eventChannel, eventID, eventTimes);
            if (timeDifference == -1)
                eventTitle = 'Spike Occurs BEFORE First Event';
            else
                eventTitle = ['Channel ', num2str(mostRecentChannel), ' Turns ', edge, ' ', num2str(timeDifference), ' Seconds Before Spike'];
            end

            %plot all data
            plot([1:46], spikeWaveforms(currSpike,:), linspace(1,46,460), mVal, '--g', linspace(1,46,460), upperBound, '--r', linspace(1,46,460), lowerBound, '--r');
            t = title(['Spike Number ', num2str(currSpike), ' of ', num2str(numSpikes)]);
            xl = xlabel(eventTitle);
            set(t, 'FontSize', 20);
            set(xl, 'FontSize', 16);
        end
    end
    
    %c for plot on continuous (toggle-able)
    if x == 'c'
        time = spikeTimestamps(currSpike);
        ind = find(timestamps == time);
        %turn off this functionality
        if cVal == 1
            %get event data
            currTime = spikeTimestamps(currSpike);
            [timeDifference mostRecentChannel edge] = getEventAtTime(currTime, eventChannel, eventID, eventTimes);
            if (timeDifference == -1)
                eventTitle = 'Spike Occurs BEFORE First Event';
            else
                eventTitle = ['Channel ', num2str(mostRecentChannel), ' Turns ', edge, ' ', num2str(timeDifference), ' Seconds Before Spike'];
            end

            %plot data
            plot([1:46], spikeWaveforms(currSpike,:), linspace(1,46,460), mVal, '--g', linspace(1,46,460), upperBound, '--r', linspace(1,46,460), lowerBound, '--r');
            t = title(['Spike Number ', num2str(currSpike), ' of ', num2str(numSpikes)]);
            xl = xlabel(eventTitle);
            set(t, 'FontSize', 20);
            set(xl, 'FontSize', 16);

            %set to "off"
            cVal = 0;
        else %turn on
            %get event data
            currTime = spikeTimestamps(currSpike);
            [timeDifference mostRecentChannel edge] = getEventAtTime(currTime, eventChannel, eventID, eventTimes);
            if (timeDifference == -1)
                eventTitle = 'Spike Occurs BEFORE First Event';
            else
                eventTitle = ['Channel ', num2str(mostRecentChannel), ' Turns ', edge, ' ', num2str(timeDifference), ' Seconds Before Spike'];
            end
            
            %plot data
            plot([-23:23], data((ind-23):(ind+23)), linspace(-23,23,460), mVal, '--g', linspace(-23,23,460), upperBound, '--r', linspace(-23,23,460), lowerBound, '--r');
            t = title(['Spike ', num2str(currSpike), ' of ', num2str(numSpikes), ' on Continuous File']);
            xl = xlabel(eventTitle);
            set(t, 'FontSize', 20);
            set(xl, 'FontSize', 16);
            
            %set back to "on"
            cVal = 1;
        end
    end
    
    %exit program
    if (x == 'x'|| x == 'X' || x == 'q' || x == 'Q')
        break
    end
end


end

