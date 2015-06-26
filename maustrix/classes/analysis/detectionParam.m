classdef detectionParam
    properties (GetAccess = public, SetAccess = private)
        type
        paramValues
    end
    
    methods
        function s = detectionParam(in)
            if ~isstruct(in) || ~isfield(in,'method')
                error('dont have the right input');
            end
            s.type = in.method;            
            switch s.type
                case 'filteredThresh'
                    s.paramValues.freqLowHi = in.freqLowHi;
                    s.paramValues.threshHoldVolts = in.threshHoldVolts;
                    s.paramValues.waveformWindowMs= in.waveformWindowMs;
                    s.paramValues.peakWindowMs= in.peakWindowMs;
                    s.paramValues.alignMethod = in.alignMethod; 
                    s.paramValues.peakAlignment = in.peakAlignment; 
                    s.paramValues.returnedSpikes = in.returnedSpikes; 
                    s.paramValues.lockoutDurMs= in.lockoutDurMs;
                    s.paramValues.bottomTopCrossingRate = [];
                case 'oSort'
                    s.paramValues.nrNoiseTraces=in.nrNoiseTraces;   
                    s.paramValues.peakAlignMethod=in.peakAlignMethod;  % 1-> find peak, 2->none, 3->peak of power signal (broken), 4->peak of MTEO signal.
                    s.paramValues.alignMethod=in.alignMethod;  %only used if peakAlignMethod is 1=peak; if so (1: peak is max, 2: peak is min, 3: mixed)
                    s.paramValues.prewhiten = in.prewhiten;  %will error if true, and less than 400,000 samples ~10 secs / trial; need to understand whittening with Linear Predictor Coefficients to lax requirements (help lpc)
                    s.paramValues.detectionMethod=in.detectionMethod; % 1 -> from power signal, 2 threshold positive, 3 threshold negative, 4 threshold abs, 5 wavelet
                    s.paramValues.kernelSize=in.kernelSize;
                    %         spikeDetectionParams.detectionMethod=5
                    %         spikeDetectionParams.scaleRanges = [0.5 1.0];
                    %         spikeDetectionParams.waveletName = 'haar';
                otherwise
                    error('unsupported spikeDetection method');
            end
            s.paramValues.ISIviolationMS=in.ISIviolationMS; % just for human reports
            s.paramValues.sampleLFP = in.sampleLFP; %true;%false
            s.paramValues.LFPSamplingRateHz = in.LFPSamplingRateHz;            
        end
        
        % ident function
        function tf = eq(a,b)
            if strcmp(a.method,b.method) && isequal(a.paramValues,b.paramValues)
                tf = true;
            else
                tf = false;
            end
        end
        
        % getters and setters
        function out = get.type(s)
            out = s.type;
        end
    end
end