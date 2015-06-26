function plot2fig(s,handle,requested)
if ischar(requested) && strcmp(requested,'default')
    requested = {};
    for i = 1:length(s.analyses)
        requested{i} = {s.analysisType{i},'default'};
    end
else
    warning('currently assuming you know what you want to ask');
end

if ~ishandle(handle)||~strcmp(get(handle,'Type'),'figure')
    error('plot2fig takes in a figure handle');
end
figure(handle); % go to that figure

N = length(s.analyses);
[XX YY] = getGoodArrangement(N);
for i = 1:length(s.analyses)
    axHan = subplot(XX,YY,i);
    s.analyses{i}.plot(axHan,requested{i}{2});
end

end