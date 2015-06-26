function s=coherentDots(varargin)
% COHERENTDOTS  class constructor.
% s=coherentDots(screen_width,screen_height,num_dots,coherence,speed,contrast,
%   dot_size,movie_duration,screen_zoom,maxWidth,maxHeight,pctCorrectionTrials,[replayMode,interTrialLuminance])
%   screen_width - width of sourceRect (determines size of texture to make)
%   screen_height - height of sourceRect (determines size of texture to make)
%   num_dots - number of dots to draw
%   coherence - either a single coherence value, or a cell with 2-element array
%       specifying a range of coherence values from which to draw randomly
%       every trial {[loVal hiVal], 'selectWithin'}, or a cell {[values], 'selectFrom'}
%   speed - either a single speed value, or a 2-element array specifying a 
%       range to randomly draw from every trial {[loVal hiVal], 'selectWithin'}, 
%       or a cell {[values], 'selectFrom'}
%   contrast - either a single contrast value, or a 2-element array 
%       specifying a range to randomly draw from every trial {[loVal hiVal], 'selectWithin'}, 
%       or a cell {[values], 'selectFrom'}
%   dot_size - size in pixels of each dot (square) """ similar to
%       coherence """
%   movie_duration - length of the movie in seconds """ similar to
%       coherence """
%   screen_zoom - scaleFactor argument passed to stimManager constructor
%   interTrialLuminance - (optional) defaults to 0
%   

eps = 0.0000001;
s.screen_width = 100;         % for matrix
s.screen_height = 100;        % for matrix
s.num_dots = 100;             % Number of dots to display
s.coherence = .8;             % Percent of dots to move in a specified direction
s.speed = 1;                  % How fast do our little dots move
s.contrast = 1;               % contrast of the dots
s.dot_size = 9;              % Width of dots in pixels
s.movie_duration = 2;         % in seconds
s.pctCorrectionTrials=.5;
s.replayMode='loop';

s.LUT=[];
s.LUTbits=0;

screen_zoom = [6 6];

s.LEDParams.active = false;
s.LEDParams.numLEDs = 0;
s.LEDParams.IlluminationModes = {};


switch nargin
case 0 
% if no input arguments, create a default object

s = class(s,'coherentDots',stimManager());

case 1
% if single argument of this class type, return it
    if (isa(varargin{1},'coherentDots'))
        s = varargin{1}; 
    else
        error('Input argument is not an coherentDots object')
    end
case {12 13 14 15}
    % screen_width
    if (floor(varargin{1}) - varargin{1} < eps)
        s.screen_width = varargin{1};
    else
        varargin{1}
        error('screen_width must be an integer')
    end
    
    % screen_height
    if (floor(varargin{2}) - varargin{2} < eps)
        s.screen_height = varargin{2};
    else
        error('screen_height must be an integer')
    end
    
    % num_dots
    if (floor(varargin{3}) - varargin{3} < eps)
        s.num_dots = varargin{3};
    else
        error('num_dots must be an integer')
    end
    
    % coherence
    if (isfloat(varargin{4}))
        s.coherence = 1;
        if (length(varargin{4}) == 1)
            if (varargin{4} >= 0 && varargin{4} <= 1)
                s.coherence = varargin{4};
            else
                error('Coherence must be between 0 and 1')
            end
        elseif (length(varargin{4}) == 2)
            if (varargin{4}(1) >= 0 && varargin{4}(1) <= 1 && varargin{4}(2) >= 0 && varargin{4}(2) <= 1 && (varargin{4}(2) - varargin{4}(1) > 0))
                s.coherence=varargin{4};
            else
                error('Coherence must be between 0 and 1, with max > min')
            end
        else
            error ('Coherence must be either a 1x2 or 1x1 set of floats')
        end
    elseif iscell(varargin{4})
        if strcmp(varargin{4}{2},'selectWithin') && (length(varargin{4}{1})==2) && (all(varargin{4}{1}>=0)) && (all(varargin{4}{1}<=1))
            s.coherence = varargin{4};
        elseif strcmp(varargin{4}{2},'selectFrom') && all(isnumeric(varargin{4}{1})) && (all(varargin{4}{1}>=0)) && (all(varargin{4}{1}<=1))
            s.coherence = varargin{4};
        else
            error('if you pass a cell, it should be of the type selectWithin or selectFrom');
        end
    else
        error('Coherence level must be a 1x1 or 1x2 array between 0 and 1 or a cell of the appropriate type')
    end
    
    % speed
    if (isfloat(varargin{5})) && (isscalar(varargin{5}) || length(varargin{5})==2)
        if (length(varargin{5})==2) && ~(varargin{5}(1)<=varargin{5}(2))
            error('range of speed must be [min max]');
        end
        s.speed = varargin{5};
    elseif iscell(varargin{5})
        if strcmp(varargin{5}{2},'selectWithin') && (length(varargin{5}{1})==2) && (all(varargin{5}{1}>=0))
            s.speed = varargin{5};
        elseif strcmp(varargin{5}{2},'selectFrom') && all(isnumeric(varargin{5}{1})) && (all(varargin{5}{1}>=0))
            s.speed = varargin{5};
        else
            error('if you pass a cell, it should be of the type selectWithin or selectFrom');
        end
    else
        error('speed (pixels/frame) must be a double or a 2-element array specifying a range or a cell of the appropriate type')
    end
    
    % contrast
    if (length(varargin{6})==1 || length(varargin{6})==2) && all(isnumeric(varargin{6})) && ...
            all(varargin{6} >=0) && all(varargin{6} <=1)
        if length(varargin{6})==2 && ~(varargin{6}(1)<=varargin{6}(2))
            error('range of contrast must be [min max]');
        end
        s.contrast = varargin{6};
    elseif iscell(varargin{6})
        if strcmp(varargin{6}{2},'selectWithin') && (length(varargin{6}{1})==2) && (all(varargin{6}{1}>=0)) && (all(varargin{6}{1}<=1))
            s.contrast = varargin{6};
        elseif strcmp(varargin{6}{2},'selectFrom') && all(isnumeric(varargin{6}{1})) && (all(varargin{6}{1}>=0)) && (all(varargin{6}{1}<=1))
            s.contrast = varargin{6};
        else
            error('if you pass a cell, it should be of the type selectWithin or selectFrom');
        end
    else
        error('contrast must be >=0 and <=1 and be a single number or a 2-element array specifying a range or a cell of the appropriate type');
    end
    
    % dot_size
    if length(varargin{7})==1 && (floor(varargin{7}) - varargin{7} < eps)
        s.dot_size = varargin{7};
    elseif length(varargin{7})==2 && all(floor(varargin{7}) - varargin{7} < eps) && varargin{7}(1)<=varargin{7}(2)
        s.dot_size = varargin{7};
    elseif iscell(varargin{7})
        if strcmp(varargin{7}{2},'selectWithin') && (length(varargin{7}{1})==2) && (all(varargin{7}{1}>=0))
            s.dot_size = varargin{7};
        elseif strcmp(varargin{7}{2},'selectFrom') && all(isnumeric(varargin{7}{1})) && (all(varargin{7}{1}>=0))
            s.dot_size = varargin{7};
        else
            error('if you pass a cell, it should be of the type selectWithin or selectFrom');
        end
    else
        error('dot_size must be an integer or a 2-element array specifying a valid range')
    end
    
    % movie_duration
    if (floor(varargin{8}) - varargin{8} < eps)
        s.movie_duration = varargin{8};
    elseif length(varargin{8})==2 && all(floor(varargin{8}) - varargin{8} < eps) && varargin{8}(1)<=varargin{8}(2)
        s.movie_duration = varargin{8};
    elseif iscell(varargin{8})
        if strcmp(varargin{8}{2},'selectWithin') && (length(varargin{8}{1})==2) && (all(varargin{8}{1}>=0))
            s.movie_duration = varargin{8};
        elseif strcmp(varargin{8}{2},'selectFrom') && all(isnumeric(varargin{8}{1})) && (all(varargin{8}{1}>=0))
            s.movie_duration = varargin{8};
        else
            error('if you pass a cell, it should be of the type selectWithin or selectFrom');
        end
    else
        error('movie_duration must be an integer or a 2-element array specifying a valid range or a cell of the appropriate type')
    end
    
    % screen_zoom
    if (length(varargin{9}) == 2 && isnumeric(varargin{9}))
        screen_zoom = varargin{9};
    else
        error('screen_zoom must be a 1x2 array with integer values')
    end
    
    % pctCorrectionTrials
    if isscalar(varargin{12}) && varargin{12}<=1 && varargin{12}>=0
        s.pctCorrectionTrials=varargin{12};
    else
        error('pctCorrectionTrials must be a scalar between 0 and 1');
    end
    
    for i=13:15
        if i <= nargin
            args{i}=varargin{i};
        else
            args{i}=[];
        end
    end
    
    % replayMode
    if ~isempty(args{13})
        if ischar(args{13}) && (strcmp(args{13},'loop') || strcmp(args{13},'once'))
            s.replayMode=args{13};
        else
            error('replay mode must be ''loop'' or ''once''');
        end
    else
        s.replayMode='loop';
    end
    
    
    if nargin>14
        % LED state
            if isstruct(varargin{15})
                s.LEDParams = varargin{15};
            else
                error('LED state should be a structure');
            end
            if s.LEDParams.numLEDs>0
                % go through the Illumination Modes and check if they seem
                % reasonable
                cumulativeFraction = 0;
                if s.LEDParams.active && isempty(s.LEDParams.IlluminationModes)
                    error('need to provide atleast one illumination mode if LEDs is to be active');
                end
                for i = 1:length(s.LEDParams.IlluminationModes)
                    if any(s.LEDParams.IlluminationModes{i}.whichLED)>s.LEDParams.numLEDs
                        error('asking for an LED that is greater than numLEDs')
                    else
                        if length(s.LEDParams.IlluminationModes{i}.whichLED)~= length(s.LEDParams.IlluminationModes{i}.intensity) || ...
                                any(s.LEDParams.IlluminationModes{i}.intensity>1) || any(s.LEDParams.IlluminationModes{i}.intensity<0)
                            error('specify a single intensity for each of the LEDs and these intensities hould lie between 0 and 1');
                        else
                            cumulativeFraction = [cumulativeFraction cumulativeFraction(end)+s.LEDParams.IlluminationModes{i}.fraction];
                        end
                    end
                end
                
                if abs(cumulativeFraction(end)-1)>eps
                    error('the cumulative fraction should sum to 1');
                else
                    s.LEDParams.cumulativeFraction = cumulativeFraction;
                end
            end
    end
    
    
    % maxWidth, maxHeight, scale factor, intertrial luminance
    if isempty(args{14})
        s = class(s,'coherentDots',stimManager(varargin{10},varargin{11},screen_zoom,uint8(0)));   
    else
        % check intertrial luminance
        if args{14} >=0 && args{14} <= 1
            s = class(s,'coherentDots',stimManager(varargin{10},varargin{11},screen_zoom,uint8(args{14}*intmax('uint8'))));
        else
            error('interTrialLuminance must be <=1 and >=0 - will be converted to a uint8 0-255');
        end
    end
        

        
otherwise
    nargin
    error('Wrong number of input arguments')
end