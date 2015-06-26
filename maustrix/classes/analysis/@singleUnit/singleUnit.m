classdef singleUnit < analysis
    properties (GetAccess = public, SetAccess = private)
        analyses
        isCurrentUnit
        
        % also assigned at the start of a call to single unit
        channels
        
        %vectors of length(analyses)
        monitor
        analysisType
        thresholdVoltage
        sortQuality
        eyeQuality
        analysisQuality
        rig
        ampState
        included
        comment
    end
    properties % calculated
        subjectDataPath
    end
    %properties (Constant = true)
    %    possibleProperties = {'FFSTA', 'STSTA', 'orGratings', 'sfGratings', 'tempGratings','cntrGratings'};  %sfPhaseRev,orPhaseRev
    %end
    methods
        %% constructor
        function s = singleUnit(varargin)
            if nargin<2
                error('atleast need to call analysis. need two inputs');
            end
            s = s@analysis(varargin{1},varargin{2});
            if nargin>2
                error('cannot make up more stuff in the constructor');
            end
            s.isCurrentUnit = true;
        end % singleUnit
        function s = addChannels(s,channels)
            if isnumeric(channels)
                s.channels = channels;
            else
                error('channels need to be numeric')
            end
        end
        function s = addMonitor(s,monitorType)
            s.monitor = monitor(monitorType);
        end
        function out = get.channels(s)
            if ~isempty(s.channels)
                out = s.channels;
            else
                out = 1; % base case when we have a single electrode;
            end
        end
        %% getters
        function out=get.subjectDataPath(s)
            if IsLinux
                out = fullfile(recordsPathLUT(s.dataPath,'Win2Lx'),s.subject);
            else
                out=fullfile(s.dataPath,s.subject);
            end
        end
        function tr = getAllTrials(s)
            tr = [];
            for an = 1:length(s.analyses)
                tr = union(tr,s.analyses{an}.trials);
            end
        end
        
        %% display
        function display(s)
            fprintf('\nsubject: %s\n',s.subject);
            fprintf('created on : %s\n',s.timeOfCreation);
            for i = 1:length(s.analyses)
                fprintf('\n\t [%d] %s. trials: [%s]',i,s.analyses{i}.getType,mat2str(s.analyses{i}.trials));
            end
            fprintf('\n\n');
        end % display
        
        %% CurrentUnitFunctions
        function s = makeUnitCurrent(s)
            s.isCurrentUnit = true;
        end
        function s = makeUnitNonCurrent(s)
            s.isCurrentUnit = false;
        end
        function out = isCurrent(s)
            out = s.isCurrentUnit;
        end
    end
end % classdef