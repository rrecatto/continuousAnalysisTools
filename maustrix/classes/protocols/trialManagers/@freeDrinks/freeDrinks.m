function t=freeDrinks(varargin)
% FREEDRINKS  class constructor.
% t=freeDrinks(soundManager,freeDrinkLikelihood,allowRepeats,reinforcementManager, 
%   [eyeController],[frameDropCorner],[dropFrames],[displayMethod],[requestPorts],[saveDetailedFramedrops],
%	[delayManager],[responseWindowMs],[showText])

switch nargin
    case 0
        % if no input arguments, create a default object

        t.freeDrinkLikelihood=0;
        t.allowRepeats=false;
        a=trialManager();
        t = class(t,'freeDrinks',a);
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'freeDrinks'))
            t = varargin{1};
        else
            error('Input argument is not a freeDrinks object')
        end
    case {4 5 6 7 8 9 10 11 12 13}

        % freeDrinkLikelihood
        if varargin{2}>=0
            t.freeDrinkLikelihood=varargin{2};
        else
            error('freeDrinkLikelihood must be >= 0')
        end
        % allowRepeats
        if islogical(varargin{3})
            t.allowRepeats=varargin{3};
        else
            error('allowRepeats must be logical');
        end

        d=sprintf('free drinks\n\t\t\tfreeDrinkLikelihood: %g',t.freeDrinkLikelihood);

        
        for i=5:13
            if i <= nargin
                args{i}=varargin{i};
            else
                args{i}=[];
            end
        end
        
        % requestPorts
        if isempty(args{9})
            args{9}='none'; % default freeDrinks requestPorts should be 'none'
        end

        a=trialManager(varargin{1},varargin{4},args{5},d,args{6},args{7},args{8},args{9},args{10},args{11},args{12},args{13});
        
        t = class(t,'freeDrinks',a);
    otherwise
        error('Wrong number of input arguments')
end