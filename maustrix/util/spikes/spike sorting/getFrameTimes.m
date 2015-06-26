function [frameIndices, frameTimes, frameLengths, correctedFrameIndices, correctedFrameTimes, correctedFrameLengths, stimInds, ...
    passedQualityTest] = ...
    getFrameTimes(pulseData, pulseDataTimes, sampleRate, dropBound, warningBound, errorBound, ifi,dropsAcceptableFirstNFrames)

% calculate pulses and frameTimes based on pulseData
% frameIndices - the exact sample index for each pulse
% frameTimes - the time value retrieved from the index of a corresponding pulse (not unique!)
% each frame = three pulses (between the single pulses, ignore double pulses)
frameIndices=[];
frameTimes=[];
frameLengths=[];
correctedFrameIndices=[];
correctedFrameTimes=[];
correctedFrameLengths=[];
stimInds=[];
passedQualityTest = true; % changed to false temp - to not do analysis until we get better data (10.29.08)

% parameters for threshold
% r = 1/20000; % time in seconds for pulse to go from peak to valley on one edge
% amp = 4; % conservative amplitude of pulse peak
% threshold = max(min(amp / (r*sampleRate), 4), 0.05); % restricted to be 0.05<=threshold<=4
% 10/30/08 - decided to make the threshold fixed at 1.0 (even at sampling rate of 125kHz, TTL pulses still only take one sample)
% sometimes (randomly) due to aliasing will fall in between two samples
% threshold = -2.0; % falling is the first edge of the downward pulse

% need to fix threshold testing - if sampling rate too high, then the spike gets split among samples
% if we check for low enough threshold, each spike gets multiple counted, if too high threshold, misses these split spikes
% need to check low threshold, but throw out consecutive crosses of threshold (only keep last one as end of spike)
diff_vector = diff(pulseData); % first derivative
% find all pulses (places where the diff is > threshold)
% pulses = find(diff_vector < threshold); % this is only the left edge of each pulse
pulsesPositive = diff_vector>0;
pulsesNegative = diff_vector<0;
if isempty(pulsesPositive)
    % 5/19/09 - if there are no frame pulses in this chunk, how do we know the frames?
    passedQualityTest=false;
    return;
end

% cases when the last trial did not see full completion of frames
if sum(pulsesPositive)~=sum(pulsesNegative)
    passedQualityTest=false;
    return;
end

frameIndices(:,1) = find(pulsesPositive);
frameIndices(:,2) = find(pulsesNegative);
frameTimes(:,1) = pulseDataTimes(frameIndices(:,1));
frameTimes(:,2) = pulseDataTimes(frameIndices(:,2));

% ==================================
correctedFrameTimes=frameTimes;
correctedFrameIndices=frameIndices; % default values are same as uncorrected; correct only those values that need it
stimInds=[1:size(frameIndices,1)]';

whichDrop=find(diff(frameIndices')/sampleRate>dropBound*ifi);
correctedFrameTimes(whichDrop,2)=frameTimes(whichDrop,1)+ifi-(1/sampleRate); % the corrected end time (estimated using ifi), need to remove one sample's worth of time
addedFrameIndices=[];
addedFrameTimes=[];
addedStimInds=[];
% %vectorized runs out of memory, using a bound method in a for loop of only the dropped frames
% can the bound method be vectorized?
%    x=repmat(pulseDataTimes,1,length(whichDrop))-repmat(correctedFrameTimes(whichDrop,2)',length(pulseDataTimes),1);
%    [a correctedFrameIndices(whichDrop,2)]=min(abs(x));

% correct times and pulses
for i=whichDrop %are more than ifi, then must be missed frame
    if mod(i,100)==0
        disp(sprintf('doing frame: %d/%d, %2.2g%%',i, length(frameTimes),100*i/length(frameTimes)))
        pause(0.01)
    end
    %[m correctedFrameIndices(i,2)]=min(abs(pulseDataTimes-correctedFrameTimes(i,2))); %SLOW! -pmm
    
    %choose indices in pulse data garunteed to have the end frame, but MUCH shorter than the whole thing
    lowerBound=max(1,floor((frameTimes(i,1)-pulseDataTimes(1))*sampleRate-1));                                 % subtract one and floor for padding, no smaller than 1
    upperBound=min(length(pulseDataTimes),ceil((frameTimes(min(i+1,end),1)-pulseDataTimes(1))*sampleRate+1));  % add one and ceil for padding, no larger than max ind
    [m relInd]=min(abs(pulseDataTimes(lowerBound:upperBound)-correctedFrameTimes(i,2)));
    correctedFrameIndices(i,2)=lowerBound+relInd-1;
    % now add frame inds and times for removed section
    addStart = correctedFrameIndices(i,2)+1;
    addEnd = frameIndices(i,2);
    addNum = round(((addEnd-addStart)/sampleRate)/ifi);
    % now linspace from start to end, and those are the start and stop inds, and then use corresponding frameTimes
    addVec=linspace(addStart,addEnd,addNum+1);
    toAdd=[];
    try
        toAdd(:,1)=ceil(addVec(1:end-1));
    catch ex
        warning('whats this?')
        keyboard
    end
    toAdd(:,2)=floor(addVec(2:end));
    addedFrameIndices=[addedFrameIndices;toAdd];
    addedStimInds=[addedStimInds;ones(size(toAdd,1),1)*i];
end

% ==================================
% currently, if frameIndices = [1 1000] for 4 flips (1 real, 3 dropped), then correctedIndices goes to [1 250]
% we want to change it so that correctedIndices = [1 250; 251 500; 501 750; 751 1000]
correctedFrameIndices=sort([correctedFrameIndices;addedFrameIndices]);
addedFrameTimes=pulseDataTimes(addedFrameIndices);
if all(size(addedFrameTimes)==[2 1])
    %warning('only one sample..needs a transpose'); 
    addedFrameTimes=addedFrameTimes';
end
correctedFrameTimes=sort([correctedFrameTimes;addedFrameTimes]);
stimInds=sort([stimInds;addedStimInds]);

% error checking
% frameLengths = diff(frameIndices(:,1),1);
frameLengths = frameIndices(:,2)-frameIndices(:,1)+1;
correctedFrameLengths = correctedFrameIndices(:,2)-correctedFrameIndices(:,1)+1;
% due to aliasing, up to three values are acceptable
if length(unique(frameLengths)) > 3
    
    ifiMS=[1000*unique(frameLengths)./sampleRate]'
    warning('found more than 3 unique frame lengths - miscalculation of frame start/stop indices');
    mn = mean(frameLengths);
     if any(frameLengths < (1-errorBound)*mn)
         error('check your assumptions about frame start/stop calculation - found frameLength too small; failing quality test');
         passedQualityTest = false;
      elseif any(frameLengths < (1-warningBound)*mn)
         warning('found frame lengths outside the warningBound (too small)');
     elseif any(frameLengths > (1+warningBound)*mn)
        droppedFrames = find(frameLengths > (1+warningBound)*mn);
        totalNumberOfDroppedFrames = length(droppedFrames)
        fractionOfDroppedFrames = totalNumberOfDroppedFrames / length(frameLengths)
        warning('found dropped frames');
        failedErrorTest=frameLengths > (1+errorBound)*mn;
        if any(failedErrorTest(1+dropsAcceptableFirstNFrames:end))
            passedQualityTest = false;
            warning('found frame lengths outside the errorBound (too long) - failing quality test');
        end
     end
end

%
% refreshRate = 60; % frames per second
% samplingRate = 10000; % samples per second
% numSamplesPerFrame = ceil((1/refreshRate) * samplingRate); % samples per frame
% frameTimes = zeros(floor(size(neuralDataTimes, 1) / numSamplesPerFrame), 2);
% % for now, we don't know how to handle the time between frames?
% frameTimes(:,1) = neuralDataTimes(1:numSamplesPerFrame:end-numSamplesPerFrame); % start times
% frameTimes(:,2) = neuralDataTimes(numSamplesPerFrame:numSamplesPerFrame:end); % stop times
%%% add something to make sure that the frame start/stop times are in troughs, not peaks
end % end function