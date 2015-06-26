function s=ratePerDayCriterion(varargin)
% RATEPERDAYCRITERION  class constructor.  
% s=ratePerDayCriterion(trialsPerDay,consecutiveDays)

switch nargin
    case 0
        % if no input arguments, create a default object
        s.trialsPerDay=0;
        s.consecutiveDays=0;
        s = class(s,'ratePerDayCriterion',criterion());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'ratePerDayCriterion'))
            s = varargin{1};
        else
            error('Input argument is not a ratePerDayCriterion object')
        end
    case 2
        if varargin{1}>=0 && varargin{2}>=0
            s.trialsPerDay=varargin{1};
            s.consecutiveDays=varargin{2};
        else
            error('trialsPerDay and consecutiveDays must be >= 0')
        end
        s = class(s,'ratePerDayCriterion',criterion());
    otherwise
        error('Wrong number of input arguments')
end