function s=fullField(varargin)
% FULLFIELD  class constructor.

% s = fullField(contrast,frequencies,durations,repetitions,maxWidth,maxHeight,scaleFactor,interTrialLuminance)
% modified balaji May 7 2011
% s = fullField(frequencies,contrasts,durations,radii,annuli,location,normalizationMethod,mean,thresh,numRepeats,
%       maxWidth,maxHeight,scaleFactor,interTrialLuminance[,doCombos]) 
% contrast - contrast of the single pixel (difference between high and low luminance endpoints) - in the 0.0-1.0 scale
% frequencies - an array of frequencies for switching from low to high luminance (black to white); in hz requested
% durations - seconds to spend in each frequency
% repetitions - number of times to cycle through all frequencies

s.contrasts=[];
s.frequencies=[];
s.durations=[];
s.radii = [];
s.radiusType = 'hardEdge';
s.numRepeats=[];

s.doCombos=true;
s.ordering.method = 'ordered';
s.ordering.seed = [];
s.ordering.includeBlank = false;

s.annuli = [];
s.location = [];
s.normalizationMethod='normalizeDiagonal';
s.mean = 0;
s.thresh = 0;
s.changeableAnnulusCenter=false;
s.changeableRadiusCenter=false;

s.LUT=[];
s.LUTbits=0;

s.LEDParams.active = false;
s.LEDParams.numLEDs = 0;
s.LEDParams.IlluminationModes = {};

switch nargin
    case 0
        % if no input arguments, create a default object
        s = class(s,'fullField',stimManager());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'fullField'))
            s = varargin{1};
        else
            error('Input argument is not a gratings object')
        end
    case {14 15 16 17 18}
        
        % create object using specified values
        % check for doCombos argument first (it decides other error checking)
        if nargin>14

            if islogical(varargin{15})
                s.doCombos=varargin{15};
                s.ordering.method = 'ordered';
                s.ordering.seed = [];
                s.ordering.includeBlank = false;
            elseif iscell(varargin{15}) && (length(varargin{15})==3)
                s.doCombos = varargin{15}{1}; if ~islogical(varargin{15}{1}), error('doCombos should be a logical'), end;
                s.ordering.method = varargin{15}{2}; if ~ismember(varargin{15}{2},{'twister','state','seed'}), error('unknown ordering method'), end;
                s.ordering.seed = varargin{15}{3}; if (~(ischar(varargin{15}{3})&&strcmp(varargin{15}{3},'clock'))&&(~isnumeric(varargin{15}{3}))), ...
                        error('seed should either be a number or set to ''clock'''), end;
                s.ordering.includeBlank = false;
            elseif iscell(varargin{15}) && (length(varargin{15})==4)
                s.doCombos = varargin{15}{1}; if ~islogical(varargin{15}{1}), error('doCombos should be a logical'), end;
                s.ordering.method = varargin{15}{2}; if ~ismember(varargin{15}{2},{'twister','state','seed'}), error('unknown ordering method'), end;
                s.ordering.seed = varargin{15}{3}; if (~(ischar(varargin{15}{3})&&strcmp(varargin{15}{3},'clock'))&&(~isnumeric(varargin{15}{3}))), ...
                        error('seed should either be a number or set to ''clock'''), end;
                s.ordering.includeBlank = varargin{15}{4}; if ~islogical(varargin{15}{4}), error('includeBlank should be a logical'), end;
            else
                error('unknown way to specify doCombos. its either just a logical or a cell length 3.');
            end
        end

        % frequencies
        if isvector(varargin{1}) && isnumeric(varargin{1}) && all(varargin{1})>0
            s.frequencies=varargin{1};
        else
            error('frequencies must all be > 0')
        end

        % contrasts
        if isvector(varargin{2}) && isnumeric(varargin{2})
            s.contrasts=varargin{2};
        else
            error('contrasts must be numbers');
        end
        
         % durations
        if isnumeric(varargin{3}) && all(all(varargin{3}>0))
            s.durations=varargin{3};
        else
            error('all durations must be >0');
        end
        
        % radii
        if isnumeric(varargin{4}) && all(varargin{4}>0) && all(~isinf(varargin{4}))
            s.radii=varargin{4};
        elseif iscell(varargin{4}) && (length(varargin{4})==2)
            s.radii = varargin{4}{1};
            s.radiusType = varargin{4}{2};
            if ~all(varargin{4}{1}>0) || ~any(strcmp(varargin{4}{2},{'gaussian','hardEdge'}))
                varargin{4}
                error('radii should be all non-negative, non-infinite and the radiusType should be ''gaussian'' or ''hardEdge''');
            end
        else
            error('radii must be >= 0 and <inf');
        end
        
        % annuli
        if isnumeric(varargin{5}) && all(varargin{5}>=0)
            s.annuli=varargin{5};
        else
            error('all annuli must be >= 0');
        end
        
        % numRepeats
        if isinteger(varargin{10}) || isinf(varargin{10}) || isNearInteger(varargin{10})
            s.numRepeats=varargin{10};
        end
        
        % check that if doCombos is false, then all parameters must be same length
        if ~s.doCombos
            paramLength = length(s.frequencies);
            if paramLength~=length(s.contrasts) || paramLength~=length(s.durations)...
                    || paramLength~=length(s.radii) || paramLength~=length(s.annuli)
                error('if doCombos is false, then all parameters (pixPerCycs, driftfrequencies, orientations, contrasts, phases, durations, radii, annuli) must be same length');
            end
        end           
        
        
        % location
        if isnumeric(varargin{6}) && all(varargin{6}>=0) && all(varargin{6}<=1)
            s.location=varargin{6};
        elseif isa(varargin{6},'RFestimator')
            s.location=varargin{6};
        elseif isa(varargin{6},'wnEstimator') && strcmp(getType(varargin{9}),'binarySpatial')
            s.location=varargin{6};            
        else
            error('all location must be >= 0 and <= 1, or location must be an RFestimator object or a wnEstimator object');
        end
        
        % normalizationMethod
        if ischar(varargin{7})
            if ismember(varargin{7},{'normalizeVertical', 'normalizeHorizontal', 'normalizeDiagonal' , 'none'})
                s.normalizationMethod=varargin{7};
            else
                error('normalizationMethod must be ''normalizeVertical'', ''normalizeHorizontal'', or ''normalizeDiagonal'', or ''none''')
            end
        end
        
        % mean
        if varargin{8} >= 0 && varargin{8}<=1
            s.mean=varargin{8};
        else
            error('0 <= mean <= 1')
        end
        
        % thres
        if varargin{9} >= 0
            s.thresh=varargin{9};
        else
            error('thresh must be >= 0')
        end
        
        if nargin>15
            if ismember(varargin{16},[0 1])
                s.changeableAnnulusCenter=logical(varargin{16});
            else
                error('gratingWithChangeableAnnulusCenter must be true / false')
            end
        end
        
        if nargin>16
            if ismember(varargin{17},[0 1])
                s.changeableRadiusCenter=logical(varargin{17});
            else
                error('gratingWithChangeableRadiusCenter must be true / false')
            end
        end
        
        if nargin>17
            % LED state
            if isstruct(varargin{18})
                s.LEDParams = varargin{18};
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
  
        s = class(s,'fullField',stimManager(varargin{11},varargin{12},varargin{13},varargin{14}));

    otherwise
        nargin
        error('Wrong number of input arguments')
end

        
        