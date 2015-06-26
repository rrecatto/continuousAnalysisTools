function out = chooseValues(s,params)
switch params.requestedDetail
    case 'centerLocation'
        out = getCenter(s,{params.estimationMethod});
end
end

