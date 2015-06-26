function b=getBoxIDForStationID(r,sid)
    found=0;
    for i=1:length(r.boxes)
        assigns=r.assignments{getID(r.boxes{i})}{1};
        for j=1:size(assigns,1)
            if strcmp(getID(assigns{j,1}),sid) %changed from sid's being ints and checking w/==
                if found
                    error('found multiple references to station')
                else
                    found=1;
                    b=getID(r.boxes{i});
                end
            end
        end
    end
    
    if ~found
        sid
        error('no station with that id')
    end