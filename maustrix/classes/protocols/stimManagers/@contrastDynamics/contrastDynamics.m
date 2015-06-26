function s=contrastDynamics(varargin)
% CONTRASTDYNAMICS  class constructor.

% s = contrastDynamics(background,stimSpec,LEDParams,maxWidth,maxHeight,scaleFactor,interTrialLuminance)

s.background = 0.5;
s.LUT=[];
s.LUTbits=0;

s.blankOn = false;
s.blankDuration = 0;

s.LEDParams.active = false;
s.LEDParams.fraction = 0;
s.LEDParams.fractionMode = 'byTrial';
s.LEDParams.LEDStimMode = 'continuous';
s.LEDParams.LEDStimModeParams = [];

s.stimSpec.type = 'sequential';
s.stimSpec.pattern = 'grating';
s.stimSpec.orientation = 0;
s.stimSpec.contrastSpace = {1,100,'logspace'};
s.stimSpec.radiusSpace = {0.2, 0.2, 'logspace'};
s.stimSpec.location = [0.5 0.5];
s.stimSpec.numStimuli = 100;
s.stimSpec.numFramesPerStim = 1;

% other ways to input stimspec
% s.stimSpec.type = 'sequential';
% s.stimSpec.pattern = 'grating';
% s.stimSpec.orientation = 0;
% s.stimSpec.contrasts = 0;
% s.stimSpec.radii = 0.2;
% s.stimSpec.numStimuli = 100;

% s.stimSpec.type = 'random';
% s.stimSpec.pattern = 'grating';
% s.stimSpec.orientation = 0;
% s.stimSpec.contrasts = logspace(log10(1),log10(100),10);
% s.stimSpec.radii = 0.2;
% s.stimSpec.numStimuli = 100;
% s.stimSpec.randomizer = 'twister'
% 
% 
% s.stimSpec.type = 'sequential';
% s.stimSpec.pattern = 'naturalNoise';
% s.stimSpec.orientation = 0;
% s.stimSpec.contrasts = logspace(log10(1),log10(100),10);
% s.stimSpec.radii = 0.2;
% s.stimSpec.numStimuli = 100;



switch nargin
    case 0
        % if no input arguments, create a default object
        
        s = class(s,'contrastDynamics',stimManager());
    case 1
        % if input is of this class type
        if (isa(varargin{1},'contrastDynamics'))
            s = varargin{1};
        else
            error('Input argument is not a whiteNoiseBubble object')
        end
    case 7
        % background
        if isscalar(varargin{1})
            s.background = varargin{1};
        elseif iscell(varargin{1})
            s.background = varargin{1}{1};
            s.blankOn = true;
            s.blankDuration = varargin{1}{2};
        else
            error('background must be a scalar or a cell with a blanking duration');
        end
        
        stimSpec = varargin{2};
        if ~isstruct(stimSpec)
            stimSpec;
            error('stimSpec needs to be a struct');
        end
        % some error checks for stiomspec
        if ~isempty(stimSpec)
            s.stimSpec = stimSpec;
        end
        
        LEDParams = varargin{3};
        if ~isempty(LEDParams)
            s.LEDParams = LEDParams
        end
        
        s = class(s,'contrastDynamics',stimManager(varargin{4},varargin{5},varargin{6},varargin{7}));
    otherwise
        error('invalid number of input arguments');
end


