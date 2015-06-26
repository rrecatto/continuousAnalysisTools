classdef rig
    properties (GetAccess = public,SetAccess = private)
        rigName
    end
    properties (Access = private)
        or % angle from perpendicular
        h % height from center of monitor
        d % distance to monitor
    end
    methods
        %% constructor
        function s = rig(name,rigState)
            s.rigName = name;
            switch rigState.calcMethod
                case 'default'
                    switch rigState.monitor
                        case 'WestinghouseL2410NM'
                            s.or = 0;
                            s.h = -70;
                            s.d = 300;
                        case 'ViewSonicPF790-VCDTS21611'
                            s.or = 0;
                            s.h = 0;
                            s.d = 200;
                    end
            end
        end % rig
        
        function out = getDistanceToMonitor(s)
            out = s.d;
        end
    end %methods
end % classdef