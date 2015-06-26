classdef sortingParam
    properties (GetAccess = public, SetAccess = private)
        type
        paramValues
    end
    
    methods
        function s = sortingParam(in)
            if ~isstruct(in) || ~isfield(in,'method')
                error('dont have the right input');
            end
            s.type = in.method; 
            switch  s.type
                case 'KlustaKwik'
                    s.paramValues.minClusters=in.minClusters;
                    s.paramValues.maxClusters=in.maxClusters;
                    s.paramValues.nStarts=in.nStarts; 
                    s.paramValues.splitEvery=in.splitEvery;
                    s.paramValues.maxPossibleClusters=in.maxPossibleClusters; 
                    s.paramValues.featureList = in.featureList;
                    s.paramValues.arrangeClustersBy = in.arrangeClustersBy; 
                    s.paramValues.postProcessing= in.postProcessing; 
                    s.paramValues.model = [];
                case 'oSort'
                    s.paramValues.doPostDetectionFiltering=in.doPostDetectionFiltering;
                    s.paramValues.peakAlignMethod=in.peakAlignMethod; 
                    s.paramValues.alignParam=in.alignParam; 
                    s.paramValues.distanceWeightMode=in.distanceWeightMode;
                    s.paramValues.minClusterSize=in.minClusterSize; 
                    s.paramValues.maxDistance=in.maxDistance; 
                    s.paramValues.envelopeSize=in.envelopeSize;
                case 'useSpikeModelFromPreviousAnalysis'
                otherwise
                    error('unsupported spikeSorting method');
            end
            
        end
        
        % ident function
        function tf = eq(a,b)
            if strcmp(a.method,b.method) && isequal(a.paramValues,b.paramValues)
                tf = true;
            else
                tf = false;
            end
        end
    end
end