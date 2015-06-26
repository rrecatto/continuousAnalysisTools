function t=freeDrinksCenterOnly(varargin)
% FREEDRINKSCENTERONLY  class constructor.
% t=freeDrinksCenterOnly(soundManager,freeDrinkLikelihood,allowRepeats,reinforcementManager, 
%   [eyeController],[frameDropCorner],[dropFrames],[displayMethod],[requestPorts],[saveDetailedFramedrops],
%	[delayManager],[responseWindowMs],[showText])

switch nargin
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'freeDrinksCenterOnly'))
            t = varargin{1};
        else
            error('Input argument is not a freeDrinksCenterOnly object')
        end
    otherwise
        % if no input arguments, create a default object after calling
        % freedrinks
        a = freeDrinks(varargin{:});
        t.derivedFrom = 'freeDrinks';
        t = class(t,'freeDrinksCenterOnly',a);
end