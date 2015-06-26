classdef wnEstimator
    properties(Access=private)
        dataPath
        type
        dataType
        params
        dataSources
        dateRange
        cache
    end
    properties(Constant = true)
        allowedTypes = {'gaussianFullField','binarySpatial'};
        allowedSources = {'latestSingleUnit','latestPhysAnalysis','inputSingleUnit'};
        testModeON = false;
    end
    
    methods
        function s = wnEstimator(dataPath,type,dataSources,params,dateRange)
            if ischar(dataPath)&&isdir(dataPath)
                s.dataPath = dataPath;
            else
                error('dataPath needs to be a valid directory path')
            end
            
            if ismember(type,s.allowedTypes)
                s.type = type;
            else
                error('type needs to be one of the allowed types');
            end
            
            if iscell(dataSources)&&all(ismember(dataSources,s.allowedSources))
                s.dataSources = dataSources;
            end
            
            if iscell(params)&&length(params)==length(dataSources)
                s.params = params;
            else
                error('params need to be a cell of length datasources');
            end
            
            if ~exist('dateRange','var')||isempty(dateRange)
                s.dateRange = [floor(now) Inf];
            elseif isnumeric(dateRange)
                s.dateRange = dateRange;
            else
                error('either dont specify dateRange or throw in a numeric value');
            end
        end
        
        % chooseValue
        function out = chooseValues(s,params)
            % which mode?
            [whichSource sourceParams]= getGoodSource(s,params);
            
            switch whichSource
                case {'latestSingleUnit','inputSingleUnit'}
                    sourceNumber = min(find(ismember(whichSource,s.dataSources)));
                    whichAnalysis = getAnalysis(sourceParams.sU,s.type);
                    out = chooseValues(whichAnalysis.analyses{end},s.params{sourceNumber}); % always choose the latest analysis of given type
                case 'latestPhysAnalysis'
                    error('not yet');
                case 'latestDynamicValue'
                    error('not yet');
                otherwise
                    error('unknown method');
            end
       end
        
        function [which sourceParams]= getGoodSource(s,params)
            % getGoodSource ideally checks which sources are available for
            % the estimator and chooses one which contains all the relevant
            % information and returns it in a format that is compatible with 
            % the rest of the analysis. Right now it just finds the single 
            % unit and sends it across
            
            done = false;i = 1;
            while ~done
                switch s.dataSources{i}
                    case 'latestSingleUnit'
                        which = 'latestSingleUnit';
                        % typically sUs are stored in dataSource,ratID,analysis,singleUnits
                        subject = params{i}.subjectID;
                        sU = singleUnit(subject,[]);
                        sU = changeDataPath(sU,s.dataPath); % where to look for the singleUnit
                        sU = getLatestSingleUnit(sU);
                        sourceParams.sU = sU;
                        if ~isCurrent(sU)
                            error('latest unit is not current');
                        end
                        done = true;
                    case 'inputSingleUnit'
                        which = 'inputSingleUnit';
                        sourceParams.sU = params{i}.sU;
                        done = true;
                    otherwise
                        error('unsupported dataSource');
                end
                if i<length(s.dataSources) && ~done
                    i = i+1;
                else
                    done = true;
                end
            end
        end
        
    end % end function
end