classdef chan
    properties (Constant = true)
        maxAllowableSamplingRateDeviation = 10^-7;
    end
    properties (GetAccess = public, SetAccess = private)
        chanID
    end
    properties (Access = private)
        electrodeType
        samplingRate
    end
    properties (Dependent = true)
        maxFilterFreqHz
    end
    properties (Transient = true)
        neuralData
        neuralDataTimes
    end
    
    methods
        %% constructor
        function s = chan(varargin)
            switch nargin
                case 0
                    % create a default channel
                    s.chanID = NaN;
                    s.samplingRate = NaN;
                    s.electrodeType = electrode('unknown');
                case 2
                    if isnumeric(varargin{1}) && numel(varargin{1})==1
                        s.chanID = varargin{1};
                    else
                        error('chan:wrongInputType','chanID should be a single number');
                    end
                    % error check if the chanID exists in the electrode
                    s.electrodeType = electrode(varargin{2});
                    if ~isvalidChanForElectrode(s.electrodeType,s.chanID);
                        error('chan:wrongInputValue','given chanID:%d does not exist for electrodeType:%s',s.chanID,varargin{2});
                    end
                    % we still dont know the samplingRate of the channel.
                    % That will come later.
                case 3
                    if isnumeric(varargin{1}) && numel(varargin{1})==1
                        s.chanID = varargin{1};
                    else
                        error('chan:wrongInputType','chanID should be a single number');
                    end
                    % error check if the chanID exists in the electrode
                    s.electrodeType = electrode(varargin{2});
                    if ~isvalidChanForElectrode(s.electrodeType,s.chanID);
                        error('chan:wrongInputValue','given chanID:%d does not exist for electrodeType:%s',s.chanID,varargin{2});
                    end
                    if isnumeric(varargin{3}) && numel(varargin{3})==1 && varargin{3}>0
                        s.samplingRate = varargin{3};
                    end
                otherwise
                    error('chan:wrongInputType','need to input {chanID, electrodeType,samplingRate}');
            end
        end
        
        %% get.maxFilterFreqHz
        function maxFilterFreqHz = get.maxFilterFreqHz(s)
            if isempty(s.samplingRate)
                error('chan:incompleteRecordError','samplingRate is not set for the object');
            end
            maxFilterFreqHz = s.samplingRate/2;
        end
        
        %% loadNeuralData
        function s = loadNeuralData(s,data,dataTimes)
            if ~isnumeric(data)
                error('chan:wrongInputType','neuralData should be numeric type');
            end
            s.neuralData = data;
            switch length(dataTimes)
                case 2
                    s.neuralDataTimes = linspace(dataTimes(1),dataTimes(2),length(data));
                case length(data)
                    s.neuralDataTimes = dataTimes;
                otherwise
                    error('chan:wrongInputNumber','wrong number of elements in dataTimes. expected %d or %d but found %d',2,length(data),length(datatimes));
            end
            if ~samplingRateOK(s)
                error('chan:qualityCheckFailed','calculated and expected samplingRates deviate too much');
            end
        end
        %% checkSamplingRate
        function tf = samplingRateOK(s)
            if isempty(s.neuralData) || ~isequal(length(s.neuralData),length(s.neuralDataTimes))
                error('chan:incompleteRecordError','cannot calculate actual sampling rate');
            end
            if any((abs((unique(diff(s.neuralDataTimes))-(1/s.samplingRate)))/(1/s.samplingRate))>s.maxAllowableSamplingRateDeviation);
                tf = false;
            else
                tf = true;
            end
        end
    end % methods
end %classdef
        
        