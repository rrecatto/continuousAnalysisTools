function t=changeDetectorTM(varargin)
% CHANGEDETECTORTM  class constructor.
% t=changeDetectorTM(soundManager,percentCatchTrials,rewardManager,
%         [eyeController],[frameDropCorner],[dropFrames],[displayMethod],[requestPorts],[saveDetailedFramedrops],
%		  [delayManager],[responseWindowMs],[showText])

switch nargin
    case 0
        % if no input arguments, create a default object
        a=trialManager();
        t.percentCatchTrials=0;
        t = class(t,'changeDetectorTM',a);
        
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'changeDetectorTM'))
            t = varargin{1};
        else
            error('Input argument is not a changeDetectorTM object')
        end
    case {3 4 5 6 7 8 9 10 11 12}

        % percentCorrectionTrials
        if varargin{2}>=0 && varargin{2}<=1
            t.percentCatchTrials=varargin{2};
        else
            error('1 >= percentCatchTrials >= 0')
        end
        
        d=sprintf(['n changeDetectorTM' ...
            '\n\t\t\tpercentCatchTrials:\t%g'], ...
            t.percentCatchTrials);
        
        for i=4:12
            if i <= nargin
                args{i}=varargin{i};
            else
                args{i}=[];
            end
        end
        
        % requestPorts
        if isempty(args{8})
            args{8}='center'; % ONLY changeDetectorTM requestPorts should be 'center'
        elseif ~strcmp(args{8},'center')
            requestPort=args{8};
            error('changeDetectorTM requires a center requestPort');
        end

        a=trialManager(varargin{1},varargin{3},args{4},d,args{5},args{6},args{7},args{8},args{9},args{10},args{11},args{12});

        t = class(t,'changeDetectorTM',a);
        
    otherwise
        nargin
        error('Wrong number of input arguments')
end