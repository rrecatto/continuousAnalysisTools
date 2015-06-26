function s=afcCoherentDots(varargin)
% AFCCOHERENTDOTS  class constructor.
% this class is specifically designed for behavior.
% s = afcCoherentDots(numDots,bkgdNumDots, dotCoherence,bkgdCoherence, dotSpeed,bkgdSpeed, dotDirection,bkgdDirection,...
%       dotColor,bkgdColor, dotSize,bkgdSize, dotShape,bkgdShape, renderMode, maxDuration,background...
%       maxWidth,maxHeight,scaleFactor,interTrialLuminance, doCombos, doPostDiscrim, LEDParams)
%   numDots - number of dots to draw
%   coherence - an array of numeric values >0 and <1
%   speed - an array of positive numbers in units of dotSize/second
%   direction - the direction the coheret dots move it. non coherent dots
%         will do some kind of jiggle in all directions
%   color - can be a single number< 1 (used as a gray scale value); a single row of 3/4 (RGB/RGBA) ; or many rows o4 the above number sets in which case randomly chosen 
%   dotSize - size in pixels of each dot (square)
%   dotShape - 'circle or 'rectangle'
%   renderMode - 'perspective' or 'flat'
%   maxDuration - length of the movie in seconds. particularly useful for
%          stimli with specific time.... 
%   screenZoom - scaleFactor argument passed to stimManager constructor
%   interTrialLuminance - (optional) defaults to 0
%   doCombos - whether to do combos or not...


eps = 0.0000001;
s.numDots = {100,100};                      % Number of dots to display
s.bkgdNumDots = {0,0};                      % task irrelevant dots
s.dotCoherence = {0.8, 0.8};                % Percent of dots to move in a specified direction
s.bkgdCoherence = {0.8, 0.8};               % percent of bkgs dots moving in the specified direction
s.dotSpeed = {1,1};                         % How fast do our little dots move (dotSize/sec)
s.bkgdSpeed = {0.1,0.1};                    % speed of bkgd dots
s.dotDirection = {[0],[pi]};                % 0 is to the right. pi is to the left
s.bkgdDirection = {[0],[pi]};               % 0 is to the right. pi is to the left
s.dotColor = {0,0};                         % can be a single number< 1 (used as a gray scale value); a single row of 3/4 (RGB/RGBA) ; or many rows o4 the above number sets in which case randomly chosen 
s.bkgdDotColor = {0,0};                     % can be a single number< 1 (used as a gray scale value); a single row of 3/4 (RGB/RGBA) ; or many rows o4 the above number sets in which case randomly chosen 
s.dotSize = {[9],[9]};                      % Width of dots in pixels
s.bkgdSize = {[3],[3]};                     % Width in pixels
s.dotShape = {{'circle'},{'circle'}};       % 'circle' or 'rectangle'
s.bkgdShape = {{'rectangle'},{'rectangle'}};% 'circle' or 'rectangle'
s.renderMode = {'flat'};                    % {'flat'} or {'perspective',[renderDistances]}
s.renderDistance = NaN;                     % is 1 for flat and is a range for perspective
s.maxDuration = {inf, inf};                 % in seconds (inf is until response)
s.background = 0;                           % black background

s.LUT =[];
s.LUTbits=0;

s.doCombos=true;
s.ordering.method = 'twister';
s.ordering.seed = [];
s.doPostDiscrim = false; 

s.LEDParams.active = false;
s.LEDParams.numLEDs = 0;
s.LEDParams.IlluminationModes = {};

switch nargin
    case 0
        % if no input arguments, create a default object
        s = class(s,'afcCoherentDots',stimManager());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'afcCoherentDots'))
            s = varargin{1};
        else
            error('Input argument is not a gratings object')
        end
    case {22 23 24}
        % create object using specified values
        numDots = varargin{1};
        bkgdNumDots = varargin{2};
        dotCoherence = varargin{3};
        bkgdCoherence = varargin{4};
        dotSpeed = varargin{5};
        bkgdSpeed = varargin{6};
        dotDirection = varargin{7};
        bkgdDirection = varargin{8};
        dotColor = varargin{9};
        bkgdDotColor = varargin{10};
        dotSize = varargin{11};
        bkgdSize = varargin{12};
        dotShape = varargin{13};
        bkgdShape = varargin{14};
        renderMode = varargin{15};
        maxDuration = varargin{16};
        background = varargin{17};
        maxWidth = varargin{18};
        maxHeight = varargin{19};
        scaleFactor = varargin{20};
        interTrialLuminance = varargin{21};
        doCombos = varargin{22};
        
        if(nargin==23)
            doPostDiscrim=varargin{23};
        else
            doPostDiscrim = false;
        end
        
        if (nargin==24)
            LEDParams = varargin{24};
        else
            LEDParams = [];
        end
        
        % doCombos
        if islogical(doCombos)
            s.doCombos = doCombos;
        elseif iscell(doCombos) && islogical(doCombos{1}) && iscell(doCombos{2}) && ...
                ischar(doCombos{2}{1}) && ismember(doCombos{2}{1}, {'default','twister'})
            s.doCombos = doCombos{1};
            s.ordering.method = doCombos{2}{1};
            if length(doCombos{2})==2
                if isnumeric(doCombos{2}{2})
                    s.ordering.seed = doCombos{2}{2};
                else
                    error('seed should be numeric');
                end
            end
        else
            doCombos
            error('doCombos not in the right format');
        end
        
        % numDots
        if iscell(numDots) && length(numDots)==2 && ...
                isnumeric(numDots{1}) && all(numDots{1}>=0) && isnumeric(numDots{2}) && all(numDots{2}>=0)
            s.numDots = numDots;
            L1 = length(numDots{1});
            L2 = length(numDots{2});
        else
            numDots
            error('numDots not in the right format');
        end
                       
        % bkgdNumDots
        if iscell(bkgdNumDots) && length(bkgdNumDots)==2 && ...
                isnumeric(bkgdNumDots{1}) && all(bkgdNumDots{1}>=0) && isnumeric(bkgdNumDots{2}) && all(bkgdNumDots{2}>=0)
            s.bkgdNumDots = bkgdNumDots;
            if ~doCombos && length(bkgdNumDots{1})~=L1 && length(bkgdNumDots{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            bkgdNumDots
            error('bkgdNumDots not in the right format');
        end
        
        % dotCoherence
        if iscell(dotCoherence) && length(dotCoherence)==2 && ...
                isnumeric(dotCoherence{1}) && all(dotCoherence{1}>=0) && all(dotCoherence{1}<=1) && ...
                isnumeric(dotCoherence{2}) && all(dotCoherence{2}>=0) && all(dotCoherence{2}<=1) 
            s.dotCoherence = dotCoherence;
            if ~doCombos && length(dotCoherence{1})~=L1 && length(dotCoherence{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            dotCoherence
            error('dotCoherence not in the right format');
        end
        
        % bkgdCoherence
        if iscell(bkgdCoherence) && length(bkgdCoherence)==2 && ...
                isnumeric(bkgdCoherence{1}) && all(bkgdCoherence{1}>=0) && all(bkgdCoherence{1}<=1) && ...
                isnumeric(bkgdCoherence{2}) && all(bkgdCoherence{2}>=0) && all(bkgdCoherence{2}<=1) 
            s.bkgdCoherence = bkgdCoherence;
            if ~doCombos && length(bkgdCoherence{1})~=L1 && length(bkgdCoherence{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            bkgdCoherence
            error('bkgdCoherence not in the right format');
        end
        
        % dotSpeed
        if iscell(dotSpeed) && length(dotSpeed)==2 && ...
                isnumeric(dotSpeed{1}) && all(dotSpeed{1}>=0) && ...
                isnumeric(dotSpeed{2}) && all(dotSpeed{2}>=0)
            s.dotSpeed = dotSpeed;
            if ~doCombos && length(dotSpeed{1})~=L1 && length(dotSpeed{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            dotSpeed
            error('dotSpeed not in the right format');
        end
        
        % bkgdSpeed
        if iscell(bkgdSpeed) && length(bkgdSpeed)==2 && ...
                isnumeric(bkgdSpeed{1}) && all(bkgdSpeed{1}>=0) && ...
                isnumeric(bkgdSpeed{2}) && all(bkgdSpeed{2}>=0)
            s.bkgdSpeed = bkgdSpeed;
            if ~doCombos && length(bkgdSpeed{1})~=L1 && length(bkgdSpeed{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            bkgdSpeed
            error('bkgdSpeed not in the right format');
        end
        
        % dotDirection
        if iscell(dotDirection) && length(dotDirection)==2 && ...
                isnumeric(dotDirection{1}) && ...
                isnumeric(dotDirection{2})
            s.dotDirection = dotDirection;
            if ~doCombos && length(dotDirection{1})~=L1 && length(dotDirection{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            dotDirection
            error('dotDirection not in the right format');
        end
        
        % bkgdDirection
        if iscell(bkgdDirection) && length(bkgdDirection)==2 && ...
                isnumeric(bkgdDirection{1}) &&  ...
                isnumeric(bkgdDirection{2})
            s.bkgdDirection = bkgdDirection;
            if ~doCombos && length(bkgdDirection{1})~=L1 && length(bkgdDirection{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            bkgdDirection
            error('bkgdDirection not in the right format');
        end
        
        % dotColor
        if iscell(dotColor) && length(dotColor)==2 && ...
                isnumeric(dotColor{1}) &&  length(size(dotColor{1}))<=2 && ... % a 2-D array
                all(all(dotColor{1}>=0)) && all(all(dotColor{1}<=1)) && ... % of the right values
                ismember(size(dotColor{1},2),[1,3,4]) && ...  % and the right size (a column of gray values, a column of RGB values or a column of RGBA values)
                isnumeric(dotColor{2}) &&  length(size(dotColor{2}))<=2 && ... % a 2-D array
                all(all(dotColor{2}>=0)) && all(all(dotColor{2}<=1)) && ... % of the right values
                ismember(size(dotColor{2},2),[1,3,4]) % and the right size (a column of gray values, a column of RGB values or a column of RGBA values)
            s.dotColor = dotColor;
            if ~doCombos && size(dotColor{1},1)~=L1 && size(dotColor{2},1)~=L2
                error('the lengths don''t match. ')
            end
        else
            dotColor
            error('dotColor not in the right format');
        end
        
        % bkgdDotColor
        if iscell(bkgdDotColor) && length(bkgdDotColor)==2 && ...
                isnumeric(bkgdDotColor{1}) &&  length(size(bkgdDotColor{1}))<=2 && ... % a 2-D array
                all(all(bkgdDotColor{1}>=0)) && all(all(bkgdDotColor{1}<=1)) && ... % of the right values
                ismember(size(bkgdDotColor{1},2),[1,3,4]) && ...  % and the right size (a column of gray values, a column of RGB values or a column of RGBA values)
                isnumeric(bkgdDotColor{2}) &&  length(size(bkgdDotColor{2}))<=2 && ... % a 2-D array
                all(all(bkgdDotColor{2}>=0)) && all(all(bkgdDotColor{2}<=1)) && ... % of the right values
                ismember(size(bkgdDotColor{2},2),[1,3,4])  % and the right size (a column of gray values, a column of RGB values or a column of RGBA values)
            s.bkgdDotColor = bkgdDotColor;
            if ~doCombos && size(bkgdDotColor{1},1)~=L1 && size(bkgdDotColor{2},1)~=L2
                error('the lengths don''t match. ')
            end
        else
            bkgdDotColor
            error('bkgdDotColor not in the right format');
        end
        
        
        % dotSize
        if iscell(dotSize) && length(dotSize)==2 && ...
                isnumeric(dotSize{1}) && all(dotSize{1}>0) && ...
                isnumeric(dotSize{2}) && all(dotSize{2}>0)
            s.dotSize = dotSize;
            if ~doCombos && length(dotSize{1})~=L1 && length(dotSize{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            dotSize
            error('dotSize not in the right format');
        end
        
        % bkgdSize
        if iscell(bkgdSize) && length(bkgdSize)==2 && ...
                isnumeric(bkgdSize{1}) && all(bkgdSize{1}>0) && ...
                isnumeric(bkgdSize{2}) && all(bkgdSize{2}>0)
            s.bkgdSize = bkgdSize;
            if ~doCombos && length(bkgdSize{1})~=L1 && length(bkgdSize{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            bkgdSize
            error('bkgdSize not in the right format');
        end
        
        
        % dotShape
        if iscell(dotShape) && length(dotShape)==2 && ...
                iscell(dotShape{1}) && all(ismember(dotShape{1}, {'circle','square'})) && ...
                iscell(dotShape{2}) && all(ismember(dotShape{2}, {'circle','square'}))
            s.dotShape = dotShape;
            if ~doCombos && length(dotShape{1})~=L1 && length(dotShape{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            dotShape
            error('dotShape not in the right format');
        end
        
        % bkgdShape
        if iscell(bkgdShape) && length(bkgdShape)==2 && ...
                iscell(bkgdShape{1}) && all(ismember(bkgdShape{1}, {'circle','square'})) && ...
                iscell(bkgdShape{2}) && all(ismember(bkgdShape{2}, {'circle','square'}))
            s.bkgdShape = bkgdShape;
            if ~doCombos && length(bkgdShape{1})~=L1 && length(bkgdShape{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            bkgdShape
            error('bkgdShape not in the right format');
        end
        
        % renderMode
        if iscell(renderMode) && ischar(renderMode{1}) && ismember(renderMode{1},{'flat','perspective'})
            s.renderMode = renderMode{1};
            switch renderMode{1}
                case 'flat'
                    s.renderDistance = NaN;
                case 'perspective'
                    if length(renderMode)==2 && isnumeric(renderMode{2}) && length(renderMode{2})==2 && all(renderMode{2}>0)
                        s.renderDistance = renderMode{2};
                    else
                        renderMode
                        error('for ''perspective'', renderMode{2} should be a 2 numeric positive number');
                    end
            end
        else
            renderMode
            error('renderMode not in the right format');
        end
        
        % maxDuration
        if iscell(maxDuration) && length(maxDuration)==2 && ...
                isnumeric(maxDuration{1}) && all(maxDuration{1}>0) && ...
                isnumeric(maxDuration{2}) && all(maxDuration{2}>0)
            s.maxDuration = maxDuration;
            if ~doCombos && length(maxDuration{1})~=L1 && length(maxDuration{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            maxDuration
            error('maxDuration not in the right format');
        end
        
        % background
        if isnumeric(background)
            s.background = background;
        else
            background
            error('background not in the right format');
        end
        
        % doPostDiscrim
        if doPostDiscrim
            % make sure that maxDuration is set to finite values
            if any(isinf(maxDuration{1})) || any(isinf(maxDuration{2}))
                error('cannot have post-discrim phase and infnite discrim phase. reconsider');
            end
            s.doPostDiscrim = true;
        else
            s.doPostDiscrim = false;
        end
        
        if nargin==24
            % LED state
            if isstruct(LEDParams)
                s.LEDParams = LEDParams;
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
        
        
        s = class(s,'afcCoherentDots',stimManager(maxWidth,maxHeight,scaleFactor,interTrialLuminance));
    otherwise
        nargin
        error('Wrong number of input arguments')
end



