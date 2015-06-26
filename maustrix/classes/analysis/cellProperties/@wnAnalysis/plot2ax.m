function plot2ax(s,handle,requested)

%             if length(requested)>1
%                 error('cannot request multiple plots in axis');
%             end
if ~ishandle(handle)||~strcmp(get(handle,'Type'),'axes')
    error('plot2ax takes in a axes handle');
end

if length(requested{1}==1) % how to send in the params
    params=[];
    requested = requested{1};
else
    params = requested{2};
    requested = requested{1};
end
if ischar(requested) && strcmp(requested,'default')
    requested = 'Temporal'
end
% see if isempty. if yes just put in no analysis do
% physiologyAnalysis.plot
if isempty(s)
    textPlot(s,'empty analysis',handle);
    return
end

switch upper(requested)
    case {'SPATIALMODULATION'}
        plotSpatialModulation(s,handle,params)
    case {'SPATIOTEMPORALCONTEXT'}
        plotSpatioTemporalContext(s,handle,params)
    case {'TEMPORAL'}
        plotTemporal(s,handle,params)
    case {'CALCULATEDFEATURES'}
        plotCalculatedFeatures(s,handle,params)
    case {'SPATIALMOVIEFRAMES'}
        error('cannot use plot2ax. need plot2fig for each unit')
        plotSpatialMovieFrames(s,handle,params)
    otherwise
        fprintf('\n%s\n%s\n%s\n%s\n%s\n','allowed types:','1.) SpatialModulation','2.) SpatioTemporalContext','3.) Temporal','4.) CalculatedFeatures')
        fprintf('\n%s : %s\n','requested',requested);
        error('unknown plot type');
end

end