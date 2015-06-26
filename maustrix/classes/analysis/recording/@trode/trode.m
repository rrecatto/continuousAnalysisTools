classdef trode
    properties (GetAccess = public, SetAccess = private)
        trodeName
    end
    properties (Access = private)
        chans
    end
    methods
        %% constructor
        function s = trode(varargin)
            switch nargin
                case 0
                    % create a standard channel
                    s.trodeName = 'unknown';
                    s.chans = [];
                case 2 % sometimes called with a preconstructed trode object
                    % varargin{1} should have the trodeName. but it will be
                    % calculated later
                    if isa(varargin{2},'chan') % explicitly giving the chan objects 
                        s.chans = varargin{2};
                    elseif iscell(varargin{2}) && length(varargin{2})==3
                        chanIDs = varargin{2}{1};
                        electrodeType = varargin{2}{2};
                        samplingRate = varargin{2}{3};
                        % error check 
                        if isnumeric(chanIDs)
                            % okay
                            if length(electrodeType) == 1
                                electrodeType = repmat(electrodeType,size(chanIDs));
                            elseif length(electrodeType)==length(chanIDs)
                                %okay
                            else
                                error('trode:wrongInputNumber','either specify one electrodeType or specify them for every one of the chans');
                            end
                            % samplingRate
                            if length(samplingRate) == 1
                                samplingRate = repmat(samplingRate,size(chanIDs));
                            elseif length(samplingRate)==length(chanIDs)
                                %okay
                            else
                                error('trode:wrongInputNumber','either specify one samplingRate or specify them for every one of the chans');
                            end
                        else
                            error('trode:wrongInputType','chanIDs should be a numeric type');
                        end
                        % numChans
                        for i = 1:length(chanIDs)
                            s.chans(end+1) = chan(chanIDs(i),electrodeType{i},samplingRate(i));
                        end
                        % trodeName
                        if ~ischar(varargin{2}) || ~isempty(varargin{2}) 
                            error('trode:wrongInputType','trodeName should be a char type or empty');
                        end
                        if isempty(varargin{2}) ||  strcmp(varargin{2},'useStandardTrodeStr')
                            s.trodeName = createTrodeName(s);
                        else
                            s.trodeName = varargin{2};
                        end
                    end
            end %switch
        end %trode        
        %% createTrodeName
        function trodeName = createTrodeName(s)
            trodeName = mat2str(getChansInTrode(s));
            trodeName = regexprep(regexprep(regexprep(trodeName,' ','_'),'[',''),']','');
            trodeName = sprintf('trode_%s',trodeName);
        end        
        %% getChansInTrode
        function chans = getChansInTrode(s)
            chans = [s.chans(:).chanID];
        end
    end
end