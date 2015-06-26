function t=soundManager(varargin)
% SOUNDMANAGER  class constructor.
% t = soundManager({soundClips})
% typical soundClips: {correctSound,keepGoingSound,trySomethingElseSound,wrongSound}

t.clips={};
t.player=[];
t.boundaries=[];

switch nargin
    case 0
        % if no input arguments, create a default object
    case 1
        if (isa(varargin{1},'soundManager')) % if single argument of this class type, return it
            t = varargin{1};
            return
        elseif isVectorOfType(varargin{1},'soundClip') % create object using specified values
            t.clips=varargin{1};
        else
            error('must pass in a vector of soundClips')
        end
    otherwise
        error('Wrong number of input arguments')
end
t.playing=[];
t.looping=false;
t.clipDurs=zeros(1,length(t.clips));
t = class(t,'soundManager');