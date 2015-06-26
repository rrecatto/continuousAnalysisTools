function plot(s,varargin)
switch nargin
    case 1
        handle = figure;
        requested = 'default';
    case 2
        handle = varargin{1};
        requested = 'default';
    case 3
        handle = varargin{1};
        requested = varargin{2};
    otherwise
        error('unsupported call to plot');
end
if strcmp(get(handle,'Type'),'figure')
    plot2fig(s,handle,requested);
elseif strcmp(get(handle,'Type'),'axes')
    plot2ax(s,handle,requested);
else
    get(handle,'Type')
    error('unsupported handle type');
end
end
