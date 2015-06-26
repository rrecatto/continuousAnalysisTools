classdef filteredThreshold < spikeDetectionParam
    
    properties
        freqLowHi = [200 10000]
        thresholdVolts
        waveformWindowMs = 1.5
        peakWindowMs = 0.6
        alignMethod = 'atPeak'
        peakAlignment = 'filtered'
        returnedSpikes = 'filtered'
        lockoutDurMs = 0.1
        thresholdMethod = 'raw'
    end
    
    methods 
        function out = filteredThreshold(varargin) 
            % filteredthreshold(obj)
            % filteredThreshold('paramName',thrV)
            
            if ischar(varargin{1})
                paramName = varargin{1};
            else
                paramName = 'standard';
            end
            out = out@spikeDetectionParam(paramName);
            
            switch nargin
                case 1
                    if isa(varargin{1},'filteredThreshold')
                        out = varargin{1};
                    end
                case 2
                    out.thresholdVolts = varargin{2};
                case 3
                    out.thresholdVolts = varargin{2};
                    p = varargin{3};
                    out.freqLowHi = p.freqLowHi;
                    out.waveformWindowMs = p.waveformWindowMs;
                    out.peakWindowMs = p.peakWindowMs;
                    out.alignMethod = p.alignMethod;
                    out.peakAlignment = p.peakAlignment;
                    out.returnedSpikes = p.returnedSpikes;
                    out.lockoutDurMs = p.lockoutDurMs;
                    out.thresholdMethod = p.thresholdMethod;
            end
        end
    end
    
end

