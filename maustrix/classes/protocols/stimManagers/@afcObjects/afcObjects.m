function s = afcObjects(varargin)

% AFCOBJECTS  class constructor.
% 
% s = afcObjects(shapes,sizes,orientations,contrasts,locations,maxDuration,normalizationMethod,backgroundLuminance,invertedContrast,mask,drawMode,params,'other inputs to stim Manager')
% Each of the following arguments is a {[],[]} cell, each element is a
% vector of size N

% shapes -{{'triangle','square','pentagon','hexagon','octagon','circle'},{'triangle','square','pentagon','hexagon','octagon','circle'}}
% sizes - horizontal fraction
% orientations - in radians
% contrasts - [0,1] (michelson contrast)
% maxDuration - in seconds (can only be one number)
% locations - belongs to [0,1]
%           OR: a RFestimator object that will get an estimated location when needed
%           OR: a location distribution object
% normalizationMethod - 'equalizeLuminanceByChangingContrast','equalizeLuminanceByChangingSize', or 'none'
% backgroundLuminance - [0<backgroundLuminance<1]
% thresh - >0
% doCombos

s.shape = [];
s.objSize = [];
s.orientation = [];
s.contrast = [];
s.maxDuration = Inf;
s.location = [];
s.normalizationMethod = 'none';
s.backgroundLuminance = [];
s.invertedContrast = [];
s.mask = [];
s.drawMode = 'cache'; % or 'expert'
s.objectType = 'blocked'; % or 'edged'
s.params = [];
s.thresh = 0;

s.image = []; % used for expert mode

s.LUT =[];
s.LUTbits=0;

s.doCombos=true;
s.doPostDiscrim = false;
switch nargin
    case 0
        % if no input arguments, create a default object
        s = class(s,'afcObjects',stimManager());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'afcObjects'))
            s = varargin{1};
        else
            error('Input argument is not a gratings object')
        end
    case 19
        % create object using specified values
        shape = varargin{1};
        objSize = varargin{2};
        orientation = varargin{3};
        contrast = varargin{4};
        maxDuration = varargin{5};
        location = varargin{6};
        normalizationMethod = varargin{7};
        backgroundLuminance = varargin{8};
        invertedContrast = varargin{9};
        drawMode = varargin{10};
        objectType = varargin{11};
        mask = varargin{12};
        thresh = varargin{13};
        maxWidth = varargin{14};
        maxHeight = varargin{15};
        scaleFactor = varargin{16};
        interTrialLuminance = varargin{17};
        doCombos = varargin{18};
        doPostDiscrim=varargin{19};
        
        
        % doCombos
        if islogical(doCombos)
            s.doCombos = doCombos;
        else
            doCombos
            error('doCombos not in the right format');
        end
        
        % shape
        allowedShapes = {'triangle','square','pentagon','hexagon','octagon','circle'};
        if iscell(shape) && length(shape)==2 && ...
                iscell(shape{1}) && all(ismember(shape{1},allowedShapes)) && iscell(shape{2}) && all(ismember(shape{2},allowedShapes))
            s.shape = shape;
            L1 = length(shape{1});
            L2 = length(shape{2});
        else
            shape
            error('shape not in the right format');
        end
        
        % size
        if iscell(objSize) && length(objSize)==2 && ...
                isnumeric(objSize{1}) && ...
                isnumeric(objSize{2})
            s.objSize = objSize;
            if ~doCombos && length(objSize{1})~=L1 && length(objSize{2})~=L2
                error('the lengths don''t match. ')
            end
        elseif iscell(objSize) && length(objSize) == 2 & ...
                iscell(objSize{1}) && all(cellfun(@isstruct,objSize{1})) && ...
                iscell(objSize{2}) && all(cellfun(@isstruct,objSize{2}))
            s.size = objSize;
        else
            objSize
            error('objSize not in the right format');
        end
        
        % orientation
        if iscell(orientation) && length(orientation)==2 && ...
                isnumeric(orientation{1}) && all(~isinf(orientation{1})) && isnumeric(orientation{2}) &&  all(~isinf(orientation{2}))
            s.orientation = orientation;
            if ~doCombos && length(orientation{1})~=L1 && length(orientation{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            orientation
            error('orientation not in the right format');
        end
        
        % contrast
        if iscell(contrast) && length(contrast)==2 && ...
                isnumeric(contrast{1}) && all(contrast{1}>=0) && all(contrast{1}<=1) && isnumeric(contrast{2}) && all(contrast{2}>=0) && all(contrast{2}<=1)
            s.contrast = contrast;
            if ~doCombos && length(contrast{1})~=L1 && length(contrast{2})~=L2
                error('the lengths don''t match. ')
            end
        else
            contrast
            error('contrast not in the right format');
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

        % location
        if iscell(location) && length(location)==2 && ...
                isnumeric(location{1}) && all(all((location{1}>=0))) && size(location{1},2)==2 && ...
                isnumeric(location{2}) && all(all((location{2}>=0))) && size(location{2},2)==2                
            s.location = location;
            if ~doCombos && length(location{1})~=L1 && length(location{2})~=L2
                error('the lengths don''t match. ')
            end
        elseif iscell(location) && length(location) == 2 && ...
                isa(location,'locationObj') && isa(location,'locationObj')
            s.location = location;
        else
            location
            error('location not in the right format');
        end
        
        % normalizationMethod
        if ischar(normalizationMethod) && ismember(normalizationMethod,{'equalizeLuminance' , 'none'})
            s.normalizationMethod = normalizationMethod;
        else
            normalizationMethod
            error('normalizationMethod not the right format');
        end
        
        % backgroundLuminance
        if iscell(backgroundLuminance) && length(backgroundLuminance)==2 && ...
                isnumeric(backgroundLuminance{1}) && all(backgroundLuminance{1}>=0) && all(backgroundLuminance{1}<=1) && ...
                isnumeric(backgroundLuminance{2}) && all(backgroundLuminance{2}>=0) && all(backgroundLuminance{2}<=1)
            s.backgroundLuminance = backgroundLuminance;
        else
            backgroundLuminance
            error('backgroundLuminance not the right format');
        end
        
        % invertedContrast
        if iscell(invertedContrast) && length(invertedContrast)==2 && ...
                islogical(invertedContrast{1}) && islogical(invertedContrast{2})
            s.invertedContrast = invertedContrast;
        else
            invertedContrast
            error('invertedContrast not the right format');
        end
        
        % mask
        if iscell(mask) && length(mask)==2
            s.mask = mask;
        else
            mask
            error('mask not the right format');
        end
        
        % drawMode
        if iscell(drawMode) && length(drawMode)==2
            s.drawMode = drawMode;
        else
            drawMode
            error('drawMode not the right format');
        end
        
        % objectType
        if iscell(objectType) && length(objectType)==2
            s.objectType = objectType;
        else
            objectType
            error('objectType not the right format');
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
        s = class(s,'afcObjects',stimManager(maxWidth,maxHeight,scaleFactor,interTrialLuminance));
    otherwise
        nargin
        error('Wrong number of input arguments')
end

