classdef frameRecord < analysis
    %% properties
    properties (Constant = true,Access = private)
        threshold = -2.0; % threshold = max(min(amp / (r*samplingRate), 4), 0.05); % restricted to be 0.05<=threshold<=4
        r = 1/20000; % time in seconds for pulse to go from peak to valley on one edge
        amp = 4; % conservative amplitude of pulse peak
    end
    properties (Access = private)
        frameIndices = [];
        frameTimes = [];
        chunkIDForFrames = [];
        samplingRate = [];
        ifi = [];
        correctionCriterion = [];
        correctedFrameTimes = [];
        correctedFrameIndices = [];
        stimInds = [];
        chunkIDForCorrectedFrames = [];
    end
    properties (Dependent = true, Access = private)
        passedQualityTest
        frameLengths
        correctedFrameLengths
    end
    properties (Transient = true, Access = private)
        pulseData = []
        pulseDataTimes = [];        
        qualityCriterion = [];
    end
    %% methods
    methods
        %% constructor
        function s = frameRecord(varargin)
            if nargin >=2
                subject = varargin{1};
                trialNumber = varargin{2};
            else
                subject = 'unknown';
                trialNumber = nan;
            end
            s = s@analysis(subject,trialNumber); % call the analysis class constructor
            switch nargin
                case 2
                    s.samplingRate = 40000;
                    s.ifi = 100;
                    s.correctionCriterion.dropBound = 1.5;
                    s.correctionCriterion.warnBound = 0.1;
                    s.correctionCriterion.errorBound = 0.6;
                    
                case 4
                    s.samplingRate = varargin{3};
                    s.ifi = varargin{4};
                    s.correctionCriterion.dropBound = 1.5;
                    s.correctionCriterion.warnBound = 0.1;
                    s.correctionCriterion.errorBound = 0.6;
                case 5
                    s.samplingRate = varargin{3};
                    s.ifi = varargin{4};
                    s.correctionCriterion = varargin{5};                    
            end
        end
                
        %% setPulseData
        function s = setPulseData(s,pulseInfo)
            s.pulseDataTimes = pulseInfo(:,1);
            s.pulseData = pulseInfo(:,2);            
        end
        
        %% calculateFrames
        function [frameIndices frameTimes correctedFrameIndices correctedFrameTimes stimInds] = calculateFrames(s)
            if isempty(s.pulseData)
                error('frameRecord:incompleteRecord','provide non empty pulseData to calculate frames');
            end
            
            diff_vector = diff(s.pulseData);            
            pulses = find(diff_vector < s.threshold); % this is only the left edge of each pulse
            if isempty(pulses)
                return;
            end
            
            % 10/30/08 - need to postprocess pulses (to weed out cases where the pulse is split among multiple samples)
            % only take the last sample of the pulse (set threshold to be low then)
            runs = diff(pulses);
            if pulses(end)==size(s.pulseData,1)
                runs(end+1) = -1; % automatically include the pulse if it happens on last sample
            end
            whichNonDoublePulse=find(runs~=1);
            
            pulses = pulses([whichNonDoublePulse; length(pulses)]);
            
            if length(pulses)<=1
                %code fails if not at least 2 pulses found for start and stop.
                %will this mean that the end of the last pulse is never found?
                %thus always miss last from of trial?... maybe.
                %though its likely this may only happen if there is one frame on the
                %last chunk, which is common for white noise...
                %considered but rejected: %pulses = [pulses; lastPulse];  %02/02/10
                return;
            end
            
            frameIndices(:,1) = pulses(1:end-1);
            frameIndices(:,2) = pulses(2:end)-1;
            frameTimes(:,1) = s.pulseDataTimes(frameIndices(:,1));
            frameTimes(:,2) = s.pulseDataTimes(frameIndices(:,2));
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            correctedFrameTimes=frameTimes;
            correctedFrameIndices=frameIndices; % default values are same as uncorrected; correct only those values that need it
            stimInds=(1:size(frameIndices,1))';
            
            whichDrop=find(diff(frameIndices,[],2)'/s.samplingRate>s.correctionCriterion.dropBound*s.ifi);
            correctedFrameTimes(whichDrop,2)=frameTimes(whichDrop,1)+s.ifi-(1/s.samplingRate); % the corrected end time (estimated using ifi), need to remove one sample's worth of time
            addedFrameIndices=[];
            addedStimInds=[];
            
            for i=whichDrop %are more than ifi, then must be missed frame
                if mod(i,100)==0
                    fprintf('doing frame: %d/%d, %2.2g%%',i, length(frameTimes),100*i/length(frameTimes));
                    pause(0.01);
                end
 
                %choose indices in pulse data garunteed to have the end frame, but MUCH shorter than the whole thing
                lowerBound=max(1,floor((frameTimes(i,1)-s.pulseDataTimes(1))*s.samplingRate-1));                                 % subtract one and floor for padding, no smaller than 1
                upperBound=min(length(s.pulseDataTimes),ceil((frameTimes(min(i+1,end),1)-s.pulseDataTimes(1))*s.samplingRate+1));  % add one and ceil for padding, no larger than max ind
                [m relInd]=min(abs(s.pulseDataTimes(lowerBound:upperBound)-correctedFrameTimes(i,2)));
                correctedFrameIndices(i,2)=lowerBound+relInd-1;
                % now add frame inds and times for removed section
                addStart = correctedFrameIndices(i,2)+1;
                addEnd = frameIndices(i,2);
                addNum = round(((addEnd-addStart)/s.samplingRate)/s.ifi);
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
            addedFrameTimes=s.pulseDataTimes(addedFrameIndices);
            if all(size(addedFrameTimes)==[2 1])
                %warning('only one sample..needs a transpose');
                addedFrameTimes=addedFrameTimes';
            end
            correctedFrameTimes=sort([correctedFrameTimes;addedFrameTimes]);
            stimInds=sort([stimInds;addedStimInds]);
        end            
    end
            
end