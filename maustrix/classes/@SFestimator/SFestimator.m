function SFe = SFestimator(varargin)
% SFestimator constructor
%
% SFe = SFestimator(dataSource,estimationMethod,dateRange)
%
% originally from phil. balaji concurs:
% always gets the most recent analysis result within SFestimator.dateRange
% phys setup will choose dateRange=[floor(now) Inf] to specify today
% dataSource = '\\132.239.158.179\datanet_storage'; Analysis storage location
%
% estimationMethod = {dataSource,method}
% typical example
% {'gratingsSF','highestF0'}
% {'gratingsSF','highestF1'}
% {'gratingsSF','highestCoh'}
% {'gratingsSF','2XOptimalSF'}
% {'gratingsSF','highestSigSF'}
% {'gratingsSF','highestF1SFGreaterThan',64(PPC)}
%
% if there is no SF estimate available in that range, error.
% %how can we do this more gracefully...? its a costly and plausible mistake...
%
% set gratings to accept SFestimator object instead of  pixPerCycs

% example test use:
% path='\\132.239.158.183\rlab_storage\pmeier\backup\devNeuralData_090310\'
% SFe=SFestimator(path,{'gratingsSF','highestF1'},[now-100 Inf]);

SFe.dataSource = [];
SFe.stimulusType = '';
SFe.estimationMethod = '';
SFe.params=[];
SFe.dateRange = [];
SFe.cache = [];

switch nargin
    case 0
        error('default object construction not allowed for SFestimator');
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'SFestimator'))
            SFe = varargin{1};
        else
            error('single argument must be a SFestimator object');
        end
    case 3
        if ~isempty(varargin{1}) && ischar(varargin{1}) && isdir(varargin{1})
            SFe.dataSource=varargin{1};
        else
            error('dataSource must be a valid directory path');
        end
        
        if iscell(varargin{2}) && ischar(varargin{2}{1})
            switch varargin{2}{1}
                case 'gratingsSF'
                    SFe.stimulusType = 'gratingsSF';
                    if ischar(varargin{2}{2}) && ismember(varargin{2}{2},{'highestF0','highestF1','highestCoh','2XOptimalSF','highestSigSF','highestF1SFGreaterThan'})
                        SFe.estimationMethod = varargin{2};
                    else
                        error('unknown method');
                    end
                otherwise
                    error('unknown stimulusType');
            end
        else
            error('estimationMethod must be a cell input')
        end
        
        if isnumeric(varargin{3})
            SFe.dateRange = varargin{3};
        end
        
        SFe=class(SFe,'SFestimator');
        
    otherwise
        error('unsupported number of input arguments');
end

end % end function