% script all_evs_isi
% runs evs_isi on all e-files in directory
% 	generates figure showing ISID of the events
%	skips E files with fewer than 100 events
% PR 10/21/98
preisi=100; inisi=4;  % standard parameters

list=dir('*.e*');
for i=1:length(list),
    [evs, info]=getevs(list(i).name);
    if length(evs)<100, % don't analyze
        fprintf('Fewer than 100 events in %s (skipping)\n',list(i).name);
    else
    [burstfract(i) burstsize(i)] = get_burst_stats(evs/10, preisi, inisi);        
    end
end

