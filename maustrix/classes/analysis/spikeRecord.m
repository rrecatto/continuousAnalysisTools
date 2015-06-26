classdef spikeRecord < analysis
    properties (Access = private)
        trodes
        spikeDetectionParams
        spikeSortingParams
        
        spikes
        trials
        spikeTimings
    end
    
    methods
        %% constructor
        function s = spikeRecord(varargin)
            if length(varargin)~=1
                error('spikeRecord:wrongInputNumber','minimal requirements to construct a spikeRecord object not met');
            end
            if iscell(varargin{1}) && length(varargin{1})==2
                subjectID = varargin{1}{1};
                trialNumber = varargin{1}{2};
            else
                error('spikeRecord:wrongInputType','need subject and trialNumber info');
            end
            s = s@analysis(subjectID,trialNumber);
            switch nargin
                case 1
                    s = spikeRecord.empty(0,0);
                case 4
                    
                    if ~isempty(s)
                        error('spikeRecord:wrongInputType','cannot construct on a non-empty spikeRecord');
                    end
                    if ~isa(varargin{2},'trode') || ~isa(varargin{3},'spikeDetectionParam') || ~isa(varargin(4),'spikeSortingParam')
                        error('spikeRecord:wrongInputType','the input objects are the wrong type');
                    end
                    s.trodes = varargin{2};
                    s.spikeDetectionParams = varargin{3};
                    s.spikeSortingParams = varargin{4};
                    numTrodes = length(s.trodes);
                    numSpikeDetectionParams = length(s.spikeDetectionParams);
                    numSpikeSortingParams = length(s.spikeSortingParams);
                    switch numSpikeDetectionParams          
                        case 1
                            s.spikeDetectionParams = repmat(s.spikeDetectionParams,size(s.trodes));
                        case numTrodes
                            % okay
                        otherwise
                            error('spikeRecord:wrongInputNumber','spikeDetectionParams are wrong');
                    end
                    
                    switch numSpikeSortingParams          
                        case 1
                            s.spikeSortingParams = repmat(s.spikeSortingParams,size(s.trodes));
                        case numTrodes
                            % okay
                        otherwise
                            error('spikeRecord:wrongInputNumber','spikeDetectionParams are wrong');
                    end
                otherwise
                    error('spikeRecord:wrongInputNumber','not the right number of inputs')
            end
        end %spikeRecord
    end %methods
end %classdef