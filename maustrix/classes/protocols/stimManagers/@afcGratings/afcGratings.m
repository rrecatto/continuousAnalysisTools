function s=afcGratings(varargin)
% AFCGRATINGS  class constructor.
% this class is specifically designed for behavior. It does not incorporate
% many of the features usually present in GRATINGS like the ability to
% show multiple types of gratings in the same trial.
% s = afcGratings(pixPerCycs,driftfrequencies,orientations,phases,contrasts,maxDuration,radii,annuli,location,
%       waveform,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance)
% Each of the following arguments is a {[],[]} cell, each element is a
% vector of size N

% pixPerCycs - pix/Cycle
% driftfrequency - cyc/s
% orientations - in radians
% phases - in radians
% contrasts - [0,1]
% maxDuration - in seconds (can only be one number)
% radii - normalized diagonal units
% annuli - normalized diagonal units
% location - belongs to [0,1]
%           OR: a RFestimator object that will get an estimated location when needed
% waveform - 'square', 'sine', or 'none'
% normalizationMethod - 'normalizeDiagonal', 'normalizeHorizontal', 'normalizeVertical', or 'none'
% mean - 0<=m<=1
% thresh - >0
% doCombos
s.pixPerCycs = [];
s.driftfrequencies = [];
s.orientations = [];
s.phases = [];
s.contrasts = [];
s.maxDuration = [];

s.radii = [];
s.radiusType = 'gaussian';
s.annuli = [];
s.location = [];
s.waveform='square'; 
s.normalizationMethod='normalizeDiagonal';
s.mean = 0;
s.thresh = 0;
s.doCombos = false;

s.LUT =[];
s.LUTbits=0;

s.doCombos=true;
s.doPostDiscrim = false; 

s.LEDParams.active = false;
s.LEDParams.numLEDs = 0;
s.LEDParams.IlluminationModes = {};

switch nargin
    case 0
        % if no input arguments, create a default object
        s = class(s,'afcGratings',stimManager());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'afcGratings'))
            s = varargin{1};
        else
            error('Input argument is not a gratings object')
        end
    case {18 19 20 21}
        % create object using specified values
        pixPerCycs = varargin{1};
        driftfrequencies = varargin{2};
        orientations = varargin{3};
        phases = varargin{4};
        contrasts = varargin{5};
        maxDuration = varargin{6};
        radii = varargin{7};
        radiusType = varargin{8};
        annuli = varargin{9};
        location = varargin{10};
        waveform = varargin{11};
        normalizationMethod = varargin{12};
        mean = varargin{13};
        thresh = varargin{14};
        maxWidth = varargin{15};
        maxHeight = varargin{16};
        scaleFactor = varargin{17};
        interTrialLuminance = varargin{18};
        doCombos = varargin{19};
        
        if(nargin==20)
            doPostDiscrim=varargin{20};
        end
        
        if (nargin==21)
            LEDParams = varargin{21};
        end
        
        % pixPerCycs
        if islogical(doCombos)
            s.doCombos = doCombos;
        else
            doCombos
            error('doCombos not in the right format');
        end
        
        % pixPerCycs
        if iscell(pixPerCycs) && length(pixPerCycs)==2 && ...
                isnumeric(pixPerCycs{1}) && all(pixPerCycs{1}>0) && isnumeric(pixPerCycs{2}) && all(pixPerCycs{2}>0)
            s.pixPerCycs = pixPerCycs;
            L1 = length(pixPerCycs{1});
            L2 = length(pixPerCycs{2});
        else
            pixPerCycs
            error('pixPerCycs not in the right format');
        end
        
        % driftfrequencies
        if iscell(driftfrequencies) && length(driftfrequencies)==2 && ...
                isnumeric(driftfrequencies{1}) && all(driftfrequencies{1}>=0) && isnumeric(driftfrequencies{2}) && all(driftfrequencies{2}>=0)
            s.driftfrequencies = driftfrequencies;
            if ~doCombos && length(driftfrequencies{1})~=L1 && length(driftfrequencies{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            driftfrequencies
            error('driftfrequencies not in the right format');
        end
        
        % orientations
        if iscell(orientations) && length(orientations)==2 && ...
                isnumeric(orientations{1}) && all(~isinf(orientations{1})) && isnumeric(orientations{2}) &&  all(~isinf(orientations{2}))
            s.orientations = orientations;
            if ~doCombos && length(orientations{1})~=L1 && length(orientations{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            orientations
            error('orientations not in the right format');
        end
        
        % phases
        if iscell(phases) && length(phases)==2 && ...
                isnumeric(phases{1}) && all(~isinf(phases{1})) && isnumeric(phases{2}) && all(~isinf(phases{2}))
            s.phases = phases;
            if ~doCombos && length(phases{1})~=L1 && length(phases{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            phases
            error('phases not in the right format');
        end
        
        % contrasts
        if iscell(contrasts) && length(contrasts)==2 && ...
                isnumeric(contrasts{1}) && all(contrasts{1}>=0) && all(contrasts{1}<=1) && isnumeric(contrasts{2}) && all(contrasts{2}>=0) && all(contrasts{2}<=1)
            s.contrasts = contrasts;
            if ~doCombos && length(contrasts{1})~=L1 && length(contrasts{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            contrasts
            error('contrasts not in the right format');
        end
        
        % maxDuration
        if iscell(maxDuration) && length(maxDuration)==2 && ...
                isnumeric(maxDuration{1}) && all(maxDuration{1}>0) && isnumeric(maxDuration{2}) && all(maxDuration{2}>0)
            s.maxDuration = maxDuration;
            if ~doCombos && length(maxDuration{1})~=L1 && length(maxDuration{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            maxDuration
            error('maxDuration not in the right format');
        end
        
        % radii
        if iscell(radii) && length(radii)==2 && ...
                isnumeric(radii{1}) && all(radii{1}>=0) && isnumeric(radii{2}) && all(radii{2}>=0)
            s.radii = radii;
            if ~doCombos && length(radii{1})~=L1 && length(radii{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            radii
            error('radii not in the right format');
        end
        
        
        % radiusType
        if ischar(radiusType) && ismember(radiusType,{'gaussian','hardEdge'})
            s.radiusType = radiusType;
        else
            radiusType
            error('radiusType not in the right format');
        end
        
        
        % annuli
        if iscell(annuli) && length(annuli)==2 && ...
                isnumeric(annuli{1}) && all(annuli{1}>=0) && isnumeric(annuli{2}) && all(annuli{2}>=0)
            s.annuli = annuli;
            if ~doCombos && length(annuli{1})~=L1 && length(annuli{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            annuli
            error('annuli not in the right format');
        end
        
        % location
        if iscell(location) && length(location)==2 && ...
                isnumeric(location{1}) && all(location{1}>=0) && size(location{1},2)==2 && ...
                isnumeric(location{2}) && all(location{2}>=0) && size(location{2},2)==2                
            s.location = location;
            if ~doCombos && length(location{1})~=L1 && length(location{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            location
            error('location not in the right format');
        end
        
        % waveform
        if ischar(waveform) && ismember(waveform,{'sine','square'})
            s.waveform = waveform;
        else
            waveform
            error('waveform not the right format');
        end
        
        % normalizationMethod
        if ischar(normalizationMethod) && ismember(normalizationMethod,{'normalizeVertical', 'normalizeHorizontal', 'normalizeDiagonal' , 'none'})
            s.normalizationMethod = normalizationMethod;
        else
            normalizationMethod
            error('normalizationMethod not the right format');
        end
        
        % mean
        if mean>=0 && mean<=1
            s.mean = mean;
        else
            mean
            error('mean not the right format');
        end
        
        % thresh
        if thresh>=0
            s.thresh = thresh;
        else
            thresh
            error('thresh not the right format');
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
        
        if nargin==21
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
        
        
        s = class(s,'afcGratings',stimManager(maxWidth,maxHeight,scaleFactor,interTrialLuminance));
    otherwise
        nargin
        error('Wrong number of input arguments')
end



