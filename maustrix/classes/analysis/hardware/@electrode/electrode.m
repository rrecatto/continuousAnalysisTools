classdef electrode
    properties (GetAccess = public,SetAccess = private)
        electrodeType
    end
    properties (Access = private)
        electrodeDetails
    end
    methods
        %% constructor
        function s = electrode(electrodeType)
            s.electrodeType = electrodeType;
            switch s.electrodeType
                case 'NeuroNexus16Lin100um413um2'
                    s.electrodeDetails.leadConfiguration = 'linear';
                    s.electrodeDetails.relativeLocation = 'needs to be determined'; %um
                    s.electrodeDetails.chansAvailable = 1:16;
                    s.electrodeDetails.recordingArea = repmat(413,1,16); %um2
                    s.electrodeDetails.impedance = nan(size(s.electrodeDetails.recordingArea));
                case 'FHC-5M'
                    s.electrodeDetails.leadConfiguration = 'monopolar';
                    s.electrodeDetails.relativeLocation = 0; %um from the location quoted
                    s.electrodeDetails.chansAvailable = 1;
                    s.electrodeDetails.recordingArea = NaN;
                    s.electrodeDetails.impedance = 5; %MOhms
                case 'FHC-10M'
                    s.electrodeDetails.leadConfiguration = 'monopolar';
                    s.electrodeDetails.relativeLocation = 0; %um from the location quoted
                    s.electrodeDetails.chansAvailable = 1;
                    s.electrodeDetails.recordingArea = NaN;
                    s.electrodeDetails.impedance = 10; %MOhms
                case 'unknown'
                    s.electrodeDetails.leadConfiguration = 'unknown';
                    s.electrodeDetails.relativeLocation = 'unknown'; %um
                    s.electrodeDetails.chansAvailable = NaN;
                otherwise
                    error('electrode:unsupportedInputType','unsupported electrode');
            end
        end % electrode
        
        %% isValidChanForElectrode
        function tf = isvalidChanForElectrode(s,chanID)
            % error check on chanID
            if ~isnumeric(chanID) && numel(chanID)~=1 
                error('electrode:wrongInputType','chanID should be a single number');
            end
            if ismember(chanID,s.electrodeDetails.chansAvailable)
               tf = true;
            else
               tf = false;
            end
        end
    end %methods
end % classdef