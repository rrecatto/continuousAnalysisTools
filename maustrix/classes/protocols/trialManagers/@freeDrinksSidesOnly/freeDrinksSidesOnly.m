function t=freeDrinksSidesOnly(varargin)
% FREEDRINKSSIDESONLY  class constructor.
% t=freeDrinksSidesOnly(soundManager,freeDrinkLikelihood,allowRepeats,reinforcementManager, 
%   [eyeController],[frameDropCorner],[dropFrames],[displayMethod],[requestPorts],[saveDetailedFramedrops],
%	[delayManager],[responseWindowMs],[showText])

switch nargin
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'freeDrinksSidesOnly'))
            t = varargin{1};
        else
            error('Input argument is not a freeDrinksSidesOnly object')
        end
    otherwise
        % if no input arguments, create a default object after calling
        % freedrinks
        a = freeDrinks(varargin{:});
        t.derivedFrom = 'freeDrinks';
        t = class(t,'freeDrinksSidesOnly',a);
end