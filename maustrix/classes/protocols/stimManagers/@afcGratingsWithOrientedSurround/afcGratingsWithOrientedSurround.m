function s=afcGratingsWithOrientedSurround(varargin)
% AFCGRATINGSWITHORIENTEDSURROUND  class constructor.
% 
% s = afcGratingsWithOrientedSurround({pixPerCycsCenter,pixPerCycsSurround},{driftfrequenciesCenter,driftfrequenciesSurround},{orientationsCenter,orientationsSurround},...
%       {phasesCenter,phasesSurround},{contrastsCenter,contrastsSurround},maxDuration,radii,location,
%       waveformCenter,normalizationMethod,mean,thresh,maxWidth,maxHeight,scaleFactor,interTrialLuminance)
% Each of the following arguments is a {[],[]} cell, each element is a
% vector of size N

% pixPerCycs -
% pix/Cycle {{centerLeft,centerRight},{surroundLeft,surroundRight}}
% driftfrequency - cyc/s {{centerLeft,centerRight},{surroundLeft,surroundRight}}
% orientations - in radians {{centerLeft,centerRight},{surroundLeft,surroundRight}}
% phases - in radians {{centerLeft,centerRight},{surroundLeft,surroundRight}}
% contrasts - [0,1] {{centerLeft,centerRight},{surroundLeft,surroundRight}}
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
s.pixPerCycsCenter = [];
s.pixPerCycsSurround = [];
s.driftfrequenciesCenter = [];
s.driftfrequenciesSurround = [];
s.orientationsCenter = [];
s.orientationsSurround = [];
s.phasesCenter = [];
s.phasesSurround = [];
s.contrastsCenter = [];
s.contrastsSurround = [];

s.maxDuration = [];

s.radiiCenter = [];
s.radiiSurround = [];
s.radiusType = 'gaussian';
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
        s = class(s,'afcGratingsWithOrientedSurround',stimManager());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'afcGratingsWithOrientedSurround'))
            s = varargin{1};
        else
            error('Input argument is not a gratings object')
        end
    case {17 18 19 20}
        % create object using specified values
        pixPerCycs = varargin{1};
        driftfrequencies = varargin{2};
        orientations = varargin{3};
        phases = varargin{4};
        contrasts = varargin{5};
        
        maxDuration = varargin{6};
        radii = varargin{7};
        radiusType = varargin{8};
        location = varargin{9};
        waveform = varargin{10};
        normalizationMethod = varargin{11};
        mean = varargin{12};
        thresh = varargin{13};
        maxWidth = varargin{14};
        maxHeight = varargin{15};
        scaleFactor = varargin{16};
        interTrialLuminance = varargin{17};
        doCombos = varargin{18};
        doPostDiscrim = false;
        if(nargin==19)
            doPostDiscrim=varargin{19};
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
                iscell(pixPerCycs{1}) && iscell(pixPerCycs{2}) && length(pixPerCycs{1}) == 2 && length(pixPerCycs{2}) == 2 && ...
                isnumeric(pixPerCycs{1}{1}) && all(pixPerCycs{1}{1}>0) && isnumeric(pixPerCycs{1}{2}) && all(pixPerCycs{1}{2}>0) && ...
                isnumeric(pixPerCycs{2}{1}) && all(pixPerCycs{2}{1}>0) && isnumeric(pixPerCycs{2}{2}) && all(pixPerCycs{2}{2}>0)
            s.pixPerCycsCenter = pixPerCycs{1};
            s.pixPerCycsSurround = pixPerCycs{2};
            L11 = length(pixPerCycs{1}{1});
            L12 = length(pixPerCycs{1}{2});
            L21 = length(pixPerCycs{2}{1});
            L22 = length(pixPerCycs{2}{2});
            if ~doCombos && (L11~=L21 ||L12~=L22)
                error('cannot not doCombos and not have the same number of center and surround lengths');
            end
        else
            pixPerCycs
            error('pixPerCycs not in the right format');
        end
        
        % driftfrequencies
        if iscell(driftfrequencies) && length(driftfrequencies)==2 && ...
                iscell(driftfrequencies{1}) && iscell(driftfrequencies{2}) && length(driftfrequencies{1}) == 2 && length(driftfrequencies{2}) == 2 && ...
                isnumeric(driftfrequencies{1}{1}) && all(driftfrequencies{1}{1}>=0) && isnumeric(driftfrequencies{1}{2}) && all(driftfrequencies{1}{2}>=0) && ...
                isnumeric(driftfrequencies{2}{1}) && all(driftfrequencies{2}{1}>=0) && isnumeric(driftfrequencies{2}{2}) && all(driftfrequencies{2}{2}>=0)
            s.driftfrequenciesCenter = driftfrequencies{1};
            s.driftfrequenciesSurround = driftfrequencies{2};
            if ~doCombos && length(driftfrequencies{1}{1})~=L11 && length(driftfrequencies{1}{2})~=L12 && length(driftfrequencies{2}{1})~=L21 && length(driftfrequencies{2}{2})~=L22
                error('the lengths don''t match. ')
            end
        else
            driftfrequencies
            error('driftfrequencies not in the right format');
        end
        
        % orientations
        if iscell(orientations) && length(orientations)==2 && ...
                iscell(orientations{1}) && iscell(orientations{2}) && length(orientations{1}) == 2 && length(orientations{2}) == 2 && ...
                isnumeric(orientations{1}{1}) && isnumeric(orientations{1}{2}) && ...
                isnumeric(orientations{2}{1}) && isnumeric(orientations{2}{2})
            s.orientationsCenter = orientations{1};
            s.orientationsSurround = orientations{2};
            if ~doCombos && length(orientations{1}{1})~=L11 && length(orientations{1}{2})~=L12 && length(orientations{2}{1})~=L21 && length(orientations{2}{2})~=L22
                error('the lengths don''t match. ')
            end
        else
            orientations
            error('orientations not in the right format');
        end
        
        % phases
        if iscell(phases) && length(phases)==2 && ...
                iscell(phases{1}) && iscell(phases{2}) && length(phases{1}) == 2 && length(phases{2}) == 2 && ...
                isnumeric(phases{1}{1}) && isnumeric(phases{1}{2}) && ...
                isnumeric(phases{2}{1}) && isnumeric(phases{2}{2})
            s.phasesCenter = phases{1};
            s.phasesSurround = phases{2};
            if ~doCombos && length(phases{1}{1})~=L11 && length(phases{1}{2})~=L12 && length(phases{2}{1})~=L21 && length(phases{2}{2})~=L22
                error('the lengths don''t match. ')
            end
        else
            phases
            error('phases not in the right format');
        end
        
        % contrasts
        if iscell(contrasts) && length(contrasts)==2 && ...
                iscell(contrasts{1}) && iscell(contrasts{2}) && length(contrasts{1}) == 2 && length(contrasts{2}) == 2 && ...
                isnumeric(contrasts{1}{1}) && all(contrasts{1}{1}>=0) && isnumeric(contrasts{1}{2}) && all(contrasts{1}{2}>=0) && ...
                isnumeric(contrasts{2}{1}) && all(contrasts{2}{1}>=0) && isnumeric(contrasts{2}{2}) && all(contrasts{2}{2}>=0)
            s.contrastsCenter = contrasts{1};
            s.contrastsSurround = contrasts{2};
            if ~doCombos && length(contrasts{1}{1})~=L11 && length(contrasts{1}{2})~=L12 && length(contrasts{2}{1})~=L21 && length(contrasts{2}{2})~=L22
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
            if ~doCombos && length(maxDuration{1})~=L11 && length(maxDuration{2})~=L22
                error('the lengths don''t match. ')
            end
        else
            maxDuration
            error('maxDuration not in the right format');
        end
        
        % radii
        if iscell(radii) && length(radii)==2 && ...
                iscell(radii{1}) && iscell(radii{2}) && length(radii{1}) == 2 && length(radii{2}) == 2 && ...
                isnumeric(radii{1}{1}) && all(radii{1}{1}>=0) && isnumeric(radii{1}{2}) && all(radii{1}{2}>=0) && ...
                isnumeric(radii{2}{1}) && all(radii{2}{1}>=0) && isnumeric(radii{2}{2}) && all(radii{2}{2}>=0)
            s.radiiCenter = radii{1};
            s.radiiSurround = radii{2};
            if ~doCombos && length(radii{1}{1})~=L11 && length(radii{1}{2})~=L12 && length(radii{2}{1})~=L21 && length(radii{2}{2})~=L22
                error('the lengths don''t match. ')
            elseif doCombos && (max(radii{1}{1})>min(radii{2}{1}) ||max(radii{1}{2})>min(radii{2}{2}))
                error('cannot choose a combo with center radii larger than surround if doCombos is true');
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
        
        if nargin>19
            % LED state
            if isstruct(varargin{20})
                s.LEDParams = varargin{20};
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
        
        s = class(s,'afcGratingsWithOrientedSurround',stimManager(maxWidth,maxHeight,scaleFactor,interTrialLuminance));
    otherwise
        nargin
        error('Wrong number of input arguments')
end