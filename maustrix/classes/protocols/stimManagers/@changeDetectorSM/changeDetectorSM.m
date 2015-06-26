function s=changeDetectorSM(varargin)
% CHANGEDETECTORSM  class constructor.
% s = changeDetectorSM(stim1,stim2,durationToFlip,durationAfterFlip,maxWidth,maxHeight,scaleFactor,interTrialLuminance)
% changeDetectorSM stim is a combo stim that makes use of 2 separate stimuli.
% It includes the discrimStim from stim1 and the discrimStim from stim2 as
% the basis for the discrimination step.
%
% Responses during the first stim epoch is punished
% 

s.stim1 = [];
s.stim2 = [];
s.durationToFlip = []; % Secs
s.durationAfterFlip = []; % Secs

s.LUT = [];
s.LUTbits = [];

switch nargin
    case 0
        % if no input arguments, create a default object
        s = class(s,'changeDetectorSM',stimManager());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'changeDetectorSM'))
            s = varargin{1};
        else
            error('Input argument is not a changeDetectorSM object')
        end
    case {8}
        stim1 = varargin{1};
        stim2 = varargin{2};
        durationToFlip = varargin{3};
        durationAfterFlip = varargin{4};
        maxWidth = varargin{5};
        maxHeight = varargin{6};
        scaleFactor = varargin{7};
        interTrialLuminance = varargin{8};
        
        % error check
        if isa(stim1,'stimManager')
            s.stim1 = stim1;
        else
            class(stim1)
            error('changeDetectorSM:wrongStimType','stim1 is of the wrong type');
        end
        
        if isa(stim2,'stimManager')
            s.stim2 = stim2;
        else
            class(stim2)
            error('changeDetectorSM:wrongStimType','stim2 is of the wrong type');
        end
        
        if isnumeric(durationToFlip)&&length(durationToFlip)==1
            s.durationToFlip.type = 'delta';
            s.durationToFlip.params = durationToFlip;
        elseif isstruct(durationToFlip)
            durationToFlip = validateDuration(durationToFlip);
            s.durationToFlip = durationToFlip;
        else
            error('changeDetectorSM:wrongDurationType','durationToFlip should be a scalar or should a struct of appropriate type');
        end
        
        if isnumeric(durationAfterFlip)&&length(durationAfterFlip)==1
            s.durationAfterFlip.type = 'delta';
            s.durationAfterFlip.params = durationAfterFlip;
        elseif isstruct(durationAfterFlip)
            durationAfterFlip = validateDuration(durationAfterFlip);
            s.durationAfterFlip = durationAfterFlip;
        else
            error('changeDetectorSM:wrongDurationType','durationAfterFlip should be a scalar or should a struct of appropriate type');
        end
        
        s = class(s,'changeDetectorSM',stimManager(maxWidth,maxHeight,scaleFactor,interTrialLuminance));

    otherwise
        nargin
        error('Wrong number of input arguments')
end
end

function out = validateDuration(in)
if ~isstruct(in)
    class(in)
    error('assumes an struct input');
end
if ~isfield(in,'type') || ~ischar(in.type)
    error('''in'' must contain a character type');
end
if ~isfield(in,'params')
    error('''in'' needs a params');
end

out = [];

switch in.type
    case 'delta'
        out.type = 'delta';
        if ~isnumeric(in.params)&&length(in.params)==1
            error('delta distribution assumes a scalar param')
        end
        out.params = in.params;
        
    case 'uniform'
        out.type = 'uniform';
        if isvector(in.params) && isnumeric(in.params) && length(in.params)==2
            out.params.range = sort(in.params);
        else
            error('uniform distribution assumes numeric vector of size 2');
        end
        
    case 'discrete-uniform'
        out.type = 'discrete-uniform';
        if isvector(in.params.range) && isnumeric(in.params.range) && length(in.params.range)==2
            out.params.range = sort(in.params.range);
        else
            error('discrete-uniform distribution assumes numeric vector of size 2');
        end
        if iswholenumber(in.params.n)
            out.params.n = in.params.n;
        else
            error('discrete-uniform distribution assumes whole number divisions');
        end
        
    case 'exponential'
        out.type = 'exponential';
        if isnumeric(in.params.lambda)&&length(in.params.lambda)==1
            out.params.lambda = in.params.lambda;
        else
            error('lambda needs to be a scalar');
        end
        
        if isfield(in.params,'minDuration')
            if isnumeric(in.params.minDuration)&&length(in.params.minDuration)==1 
                out.params.minDuration = in.params.minDuration;
            else
                error('minDuration needs to be a scalar');
            end
        else
            out.params.minDuration = 0;
        end
        
    case 'gaussian'
        out.type = 'gaussian';
        if isnumeric(in.params.m) && length(in.params.m)==1 && in.params.m>0
            out.params.m = in.params.m;
        else
            error('mean needs to be a scalar >0');
        end
        
        if isnumeric(in.params.sd) && length(in.params.sd)==1 && in.params.sd>0
            out.params.sd = in.params.sd;
        else
            error('sd needs to be a scalar >0');
        end
        
        if isfield(in.params,'cutoffDuration') % only allow flip durations >cutoffDuration
            if isnumeric(in.params.cutoffDuration) && length(in.params.cutoffDuration)==1 && in.params.cutoffDuration>0
                out.params.cutoffDuration = in.params.cutoffDuration;
            else
                error('cutoffDuration needs to be a scalar >0');
            end
        else
            out.params.cutoffDuration = 0; % forcing it here
        end
        
    otherwise
        error('unsupported distribution type');
end

end
