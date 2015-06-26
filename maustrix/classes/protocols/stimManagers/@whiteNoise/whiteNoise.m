function s=whiteNoise(varargin)
% WHITENOISE  class constructor.

% s = whiteNoise(distribution,std,background,method,requestedStimLocation,stixelSize,searchSubspace,numFrames,
%       maxWidth,maxHeight,scaleFactor,interTrialLuminance)

s.distribution = [];
s.background = [];
s.method = [];
s.requestedStimLocation = [];
s.stixelSize = [];
s.searchSubspace = [];
s.numFrames = [];
s.duration = [];
s.frameDuration = [];
s.changeable = [];
s.spatialDim=[];
s.patternType=[];
s.LUT=[];
s.LUTbits=0;
s.randomizer = struct;

s.LEDParams.active = false;
s.LEDParams.numLEDs = 0;
s.LEDParams.IlluminationModes = {};

switch nargin
    case 0
        % if no input arguments, create a default object
        
        s = class(s,'whiteNoise',stimManager());
    case 1
        % if input is of this class type
        if (isa(varargin{1},'whiteNoise'))
            s = varargin{1};
        else
            error('Input argument is not a whiteNoise object')
        end
    case {12, 13}
        % create object using specified values
        
        if ischar(varargin{1}{1}) && ismember(varargin{1}{1},{'gaussian','binary'})
            s.distribution.type=varargin{1}{1};
        else
            varargin{1}{1}
            error('distribution must be ''gaussian'' or ''binary''')
        end
        
        switch s.distribution.type
            case 'gaussian'
                if length(varargin{1})>=3
                    % meanLuminance
                    if isscalar(varargin{1}{2})
                        s.distribution.meanLuminance = varargin{1}{2};
                    else
                        error('meanLuminance must be a scalar');
                    end
                    % std
                    if isnumeric(varargin{1}{3})
                        s.distribution.std = varargin{1}{3};
                    else
                        error('std must be a numeric vector');
                    end
                else
                    error('provide atleast three inputs for distribution');
                end
                if length(varargin{1})==5
                    % randomizer
                    if ischar(varargin{1}{4}) && ismember(varargin{1}{4},{'twister','seed','state'})
                        s.randomizer.method = varargin{1}{4};
                    end
                    % seeding
                    if isnumeric(varargin{1}{5}) || (ischar(varargin{1}{5})&&(strcmp(varargin{1}{5},'clock')))
                        s.randomizer.seed = varargin{1}{5};
                    end                        
                else
                    s.randomizer.method = 'state';
                    s.randomizer.seed = 'clock';
                end
            case 'binary'
                if length(varargin{1})==4
                    lowVal=varargin{1}{2};
                    if isscalar(lowVal)
                        s.distribution.lowVal= lowVal;
                    else
                        error('lowVal must be a scalar');
                    end
                    
                    hiVal=varargin{1}{3};
                    if isscalar(hiVal)
                        s.distribution.hiVal=hiVal;
                    else
                        error('hiVal must be a scalar');
                    end
                    
                    if lowVal>=hiVal
                        lowVal
                        hiVal
                        error('lowVal must be less than hiVal')
                    end
                    
                    probability=varargin{1}{4};
                    if isscalar(probability) && probability>=0 probability<=0
                        s.distribution.probability = probability;
                    else
                        probability
                        error('probability must be in the range 0 and 1 inclusive');
                    end
                else
                    error('binary must have 4 arguments: ditribution name, loVal, hiVal,probability of highVal')
                end
        end
        
        % background
        if isscalar(varargin{2})
            s.background = varargin{2};
        else
            error('background must be a scalar');
        end
        
        % method
        if ischar(varargin{3})
            s.method = varargin{3};
        else
            error('method must be a string');
        end
        
        %requestedStimLocation
        if isvector(varargin{4}) && length(varargin{4}) == 4
            s.requestedStimLocation = varargin{4};
        else
            error('requestedStimLocation must be a vector of length 4');
        end
        
        % stixelSize
        if isvector(varargin{5}) && length(varargin{5}) == 2
            s.stixelSize = varargin{5};
        else
            error('stixelSize must be a 2-element vector');
        end
        % searchSubspace
        if isnumeric(varargin{6})
            s.searchSubspace = varargin{6};
        else
            error('searchSubspace must be numeric');
        end
        % numFrames
        if isscalar(varargin{7})
            s.numFrames = varargin{7};
        elseif iscell(varargin{7})
            s.duration = varargin{7}{1};
            s.frameDuration = varargin{7}{2};
        else
            error('numFrames must be a scalar');
        end
        
        % changeable
        if islogical(varargin{8})
            s.changeable = varargin{8};
        else
            error('changeable must be a logicial');
        end
        
        %calculate spatialDim
        s.spatialDim=ceil([diff(s.requestedStimLocation([1 3])) diff(s.requestedStimLocation([2 4]))]./s.stixelSize);
        
        %group into pattern type, using spatial dim
        if all(s.spatialDim==1)
            s.patternType='temporal';
        elseif s.spatialDim(1)==1
            s.patternType='horizontalBar';
        elseif s.spatialDim(2)==1
            s.patternType='verticalBar';
        elseif all(s.spatialDim>1)
            s.patternType='grid';
        else
            s.spatialDim
            error('should never happen')
        end
        
        if nargin>12
            % LED state
            if isstruct(varargin{13})
                s.LEDParams = varargin{13};
            else
                error('LED state should be a structure');
            end
            if s.LEDParams.numLEDs>0
                % go through the Illumination Modes and check if they seem
                % reasonable
                cumulativeFraction = 0;
                s.LEDParams
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
        
        s = class(s,'whiteNoise',stimManager(varargin{9},varargin{10},varargin{11},varargin{12}));
    otherwise
        error('invalid number of input arguments');
end


