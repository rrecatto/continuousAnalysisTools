classdef spikeDetectionParam
    
    properties (GetAccess=public, SetAccess=private)
        paramName = 'standard';
    end
    
    methods
        function out = spikeDetectionParam(paramName)
            out.paramName = paramName;
        end
        
    end
end