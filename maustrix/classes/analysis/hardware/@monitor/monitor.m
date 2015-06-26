classdef monitor
    properties (GetAccess = public,SetAccess = private)
        monitorName
        monitorType
    end
    properties (Access = private)
        width
        height
        xPix
        yPix
    end
    methods
        %% constructor
        function s = monitor(name)
            s.monitorName = name;
            switch s.monitorName
                case 'WestinghouseL2410NM'
                    s.monitorType= 'LCD';
                    s.width = 520; %mm
                    s.height = 325; %mm
                    s.xPix = 1920;
                    s.yPix = 1200;
                case 'ViewSonicPF790-VCDTS21611'
                    s.monitorType= 'CRT';
                    s.width = 405; %mm
                    s.height = 310; %mm
                    s.xPix = 1600;
                    s.yPix = 1200;
                otherwise
                    error('monitor:unsupportedInputType','unsupported monitor');
            end
        end % electrode
        
        function out = getDims(s,which)
            if ~exist('which','var')||isempty(which)
                which = 1:2;
            elseif any(which>2|which<1)
                error('only length and width are available');
            end
            out = [s.width s.height];
            out = out(which);
        end
        
        function out = getPixs(s,which)
            if ~exist('which','var')||isempty(which)
                which = 1:2;
            elseif any(which>2|which<1)
                error('only length and width are available');
            end
            out = [s.xPix s.yPix];
            out = out(which);
        end
        
    end %methods
end % classdef