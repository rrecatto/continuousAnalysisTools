function plot2fig(s,handle,requested)

if ischar(requested) && strcmp(requested,'default')
    requested = {'SpatialModulation','SpatioTemporalContext','Temporal','CalculatedFeatures'};
    if strcmp(getType(s), 'gaussianFullField')
        requested = {'Temporal'};
    end
end
numAxes = length(requested(:));
[rows cols]= getGoodArrangement(numAxes);

if ~ishandle(handle)||~strcmp(get(handle,'Type'),'figure')
    error('plot2fig takes in a figure handle');
end
figure(handle);
if strcmp(upper(requested{1}),'SPATIALMOVIEFRAMES')
    if length(requested)==2
        params = requested{2};
    elseif length(requested)==1
        params  =struct;
    else
        error('cannot ask for other things when asking for spatialmovieframes');
    end
    useSeparateFig = true;
else
    useSeparateFig = false;
end
if useSeparateFig && strcmp(upper(requested{1}),'SPATIALMOVIEFRAMES')
    plotSpatialMovieFrames(s,handle,params)
else
    for i = 1:length(requested)
        axHan = subplot(rows,cols,i);
        plot2ax(s,axHan,requested(i));
    end
end

textHan = axes('Position',[0.5 0 0.5 0.05]);
descriptiveText = sprintf('Rat:%s trials:%d-%d',s.subject,min(s.trials),max(s.trials));
text('Position',[1,0.5],'String',descriptiveText,'HorizontalAlignment','Right','VerticalAlignment','Middle');
set(gca,'XTick',[],'YTick',[]);
end
