function s=gratings(varargin)
% GRATINGS  class constructor.
% s = gratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,durations,radii,annuli,location,
%       waveform,normalizationMethod,mean,thresh,numRepeats,
%       maxWidth,maxHeight,scaleFactor,interTrialLuminance[,doCombos])
% Each of the following arguments is a 1xN vector, one element for each of N gratings
% pixPerCycs - specified as in orientedGabors
% driftfrequency - specified in cycles per second for now; the rate at which the grating moves across the screen
% orientations - in radians
% phases - starting phase of each grating frequency (in radians)
%
% contrasts - normalized (0 <= value <= 1) - Mx1 vector
%
% durations - up to MxN, specifying the duration (in seconds) of each pixPerCycs/contrast pair
%
% radii - the std dev of the enveloping gaussian, (by default in normalized units of the diagonal of the stim region) - can be of length N (N masks)
% annuli - the radius of annuli that are centered inside the grating (in same units as radii)
% location - a 2x1 vector, specifying x- and y-positions where the gratings should be centered; in normalized units as fraction of screen
%           OR: a RFestimator object that will get an estimated location when needed
% waveform - 'square', 'sine', or 'none'
% normalizationMethod - 'normalizeDiagonal' (default), 'normalizeHorizontal', 'normalizeVertical', or 'none'
% mean - must be between 0 and 1
% thresh - must be greater than 0; in normalized luminance units, the value below which the stim should not appear
% numRepeats - how many times to cycle through all combos
% doCombos - a flag that determines whether or not to take the factorialCombo of all parameters (default is true)
%   does the combinations in the following order:
%   pixPerCycs > driftfrequencies > orientations > contrasts > phases > durations
%   - if false, then takes unique selection of these parameters (they all have to be same length)
%   - in future, handle a cell array for this flag that customizes the
%   combo selection process.. if so, update analysis too
% Mar 3 2011 - include blank trials.

s.pixPerCycs = [];
s.driftfrequencies = [];
s.orientations = [];
s.phases = [];
s.contrasts = [];
s.durations = [];
s.numRepeats = [];

s.radii = [];
s.radiusType = 'gaussian';
s.annuli = [];
s.location = [];
s.waveform='square';
s.normalizationMethod='normalizeDiagonal';
s.mean = 0;
s.thresh = 0;
s.changeableAnnulusCenter=false;
s.changeableRadiusCenter=false;

s.LUT =[];
s.LUTbits=0;

s.doCombos=true;
s.ordering.method = 'ordered';
s.ordering.seed = [];
s.ordering.includeBlank = false;

s.LEDParams.active = false;
s.LEDParams.numLEDs = 0;
s.LEDParams.IlluminationModes = {};

switch nargin
    case 0
        % if no input arguments, create a default object
        s = class(s,'gratings',stimManager());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'gratings'))
            s = varargin{1};
        else
            error('Input argument is not a gratings object')
        end
    case {18 19 20 21 22}
        
        % create object using specified values
        % check for doCombos argument first (it decides other error checking)
        if nargin>18

            if islogical(varargin{19})
                s.doCombos=varargin{19};
                s.ordering.method = 'ordered';
                s.ordering.seed = [];
                s.ordering.includeBlank = false;
            elseif iscell(varargin{19}) && (length(varargin{19})==3)
                s.doCombos = varargin{19}{1}; if ~islogical(varargin{19}{1}), error('doCombos should be a logical'), end;
                s.ordering.method = varargin{19}{2}; if ~ismember(varargin{19}{2},{'twister','state','seed'}), error('unknown ordering method'), end;
                s.ordering.seed = varargin{19}{3}; if (~(ischar(varargin{19}{3})&&strcmp(varargin{19}{3},'clock'))&&(~isnumeric(varargin{19}{3}))), ...
                        error('seed should either be a number or set to ''clock'''), end;
                s.ordering.includeBlank = false;
            elseif iscell(varargin{19}) && (length(varargin{19})==4)
                s.doCombos = varargin{19}{1}; if ~islogical(varargin{19}{1}), error('doCombos should be a logical'), end;
                s.ordering.method = varargin{19}{2}; if ~ismember(varargin{19}{2},{'twister','state','seed'}), error('unknown ordering method'), end;
                s.ordering.seed = varargin{19}{3}; if (~(ischar(varargin{19}{3})&&strcmp(varargin{19}{3},'clock'))&&(~isnumeric(varargin{19}{3}))), ...
                        error('seed should either be a number or set to ''clock'''), end;
                s.ordering.includeBlank = varargin{19}{4}; if ~islogical(varargin{19}{4}), error('includeBlank should be a logical'), end;
            else
                error('unknown way to specify doCombos. its either just a logical or a cell length 3.');
            end
        end
        % pixPerCycs
        if isvector(varargin{1}) && isnumeric(varargin{1})
            s.pixPerCycs=varargin{1};
        elseif isa(varargin{1},'SFestimator');
            s.pixPerCycs = varargin{1};
        else
            error('pixPerCycs must be numbers OR an SFEstimator Object');
        end
        % driftfrequency
        if isvector(varargin{2}) && isnumeric(varargin{2}) && all(varargin{2})>0
            s.driftfrequencies=varargin{2};
        else
            error('driftfrequencies must all be > 0')
        end
        % orientations
        if isvector(varargin{3}) && isnumeric(varargin{3})
            s.orientations=varargin{3};
        else
            error('orientations must be numbers')
        end
        % phases
        if isvector(varargin{4}) && isnumeric(varargin{4})
            s.phases=varargin{4};
        else
            error('phases must be numbers');
        end
        % contrasts
        if isvector(varargin{5}) && isnumeric(varargin{5}) && all(varargin{5}>=0 & varargin{5}<=1)
            s.contrasts=varargin{5};
        else
            error('contrasts must be numbers between 0 and 1');
        end
         % durations
        if isnumeric(varargin{6}) && all(all(varargin{6}>0))
            s.durations=varargin{6};
        else
            error('all durations must be >0');
        end
        % radii
        if isnumeric(varargin{7}) && all(varargin{7}>0) && all(~isinf(varargin{7}))
            s.radii=varargin{7};
        elseif iscell(varargin{7}) && (length(varargin{7})==2)
            s.radii = varargin{7}{1};
            s.radiusType = varargin{7}{2};
            if ~all(varargin{7}{1}>0) || ~any(strcmp(varargin{7}{2},{'gaussian','hardEdge'}))
                error('radii should be all non-negative, non-infinite and the radiusType should be ''gaussian'' or ''hardEdge''');
            end
        else
            error('radii must be >= 0');
        end
        % annuli
        if isnumeric(varargin{8}) && all(varargin{8}>=0)
            s.annuli=varargin{8};
        else
            error('all annuli must be >= 0');
        end
        % numRepeats
        if isinteger(varargin{14}) || isinf(varargin{14}) || isNearInteger(varargin{14})
            s.numRepeats=varargin{14};
        end
        
        % check that if doCombos is false, then all parameters must be same length
        if ~s.doCombos
            paramLength = length(s.pixPerCycs);
            if paramLength~=length(s.driftfrequencies) || paramLength~=length(s.orientations) || paramLength~=length(s.contrasts) ...
                    || paramLength~=length(s.phases) || paramLength~=length(s.durations) || paramLength~=length(s.radii) ...
                    || paramLength~=length(s.annuli)
                error('if doCombos is false, then all parameters (pixPerCycs, driftfrequencies, orientations, contrasts, phases, durations, radii, annuli) must be same length');
            end
        end           
        
        
        % location
        if isnumeric(varargin{9}) && all(varargin{9}>=0) && all(varargin{9}<=1)
            s.location=varargin{9};
        elseif isa(varargin{9},'RFestimator')
            s.location=varargin{9};
        elseif isa(varargin{9},'wnEstimator')
            s.location=varargin{9};
        else
            error('all location must be >= 0 and <= 1, or location must be an RFestimator object');
        end
        % waveform
        if ischar(varargin{10})
            if ismember(varargin{10},{'sine', 'square', 'none','catcam530a','haterenImage1000'})
                s.waveform=varargin{10};
            else
                error('waveform must be ''sine'', ''square'', ''catcam530a'', or ''none''')
            end
        end
        % normalizationMethod
        if ischar(varargin{11})
            if ismember(varargin{11},{'normalizeVertical', 'normalizeHorizontal', 'normalizeDiagonal' , 'none'})
                s.normalizationMethod=varargin{11};
            else
                error('normalizationMethod must be ''normalizeVertical'', ''normalizeHorizontal'', or ''normalizeDiagonal'', or ''none''')
            end
        end
        % mean
        if varargin{12} >= 0 && varargin{12}<=1
            s.mean=varargin{12};
        else
            error('0 <= mean <= 1')
        end
        % thres
        if varargin{13} >= 0
            s.thresh=varargin{13};
        else
            error('thresh must be >= 0')
        end
        
        if nargin>19
            if ismember(varargin{20},[0 1])
                s.changeableAnnulusCenter=logical(varargin{20});
            else
                error('gratingWithChangeableAnnulusCenter must be true / false')
            end
        end
        
        if nargin>20
            if ismember(varargin{21},[0 1])
                s.changeableRadiusCenter=logical(varargin{21});
            else
                error('gratingWithChangeableRadiusCenter must be true / false')
            end
        end
        
        if nargin>21
            % LED state
            if isstruct(varargin{22})
                s.LEDParams = varargin{22};
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
        
        % both changeableRadiusCentre and changeabkeAnnulusCentre cannot be
        % true at the same time
        if s.changeableAnnulusCenter && s.changeableRadiusCenter
            error('cannot set changeableAnnulusCentre and changeableRadusCentre to true at the same time');
        end
        
        s = class(s,'gratings',stimManager(varargin{15},varargin{16},varargin{17},varargin{18}));

    otherwise
        nargin
        error('Wrong number of input arguments')
end



