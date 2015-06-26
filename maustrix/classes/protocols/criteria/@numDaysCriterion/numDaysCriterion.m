function s=numDaysCriterion(varargin)
% NUMDAYSCRITERION  class constructor.  
% s=numDaysCriterion(numDays)

switch nargin
    case 0
        % if no input arguments, create a default object
        s.numDays=0;
        s = class(s,'numDaysCriterion',criterion());
    case 1
        % if single argument of this class type, return it
        if (isa(varargin{1},'numDaysCriterion'))
            s = varargin{1};
        elseif varargin{1}>=0
            s.numDays = varargin{1};
            s = class(s,'numDaysCriterion',criterion());
        else
            error('Input argument is not a numDays object or a numeric data type')
        end
    otherwise
        error('Wrong number of input arguments')
end