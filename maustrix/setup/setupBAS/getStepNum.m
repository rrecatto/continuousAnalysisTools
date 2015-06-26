function stepNum = getStepNum(subID)
switch subID
    case {'267','268', '269', '270'} % Airpuff expt
        stepNum = 1;
    case {'181','182','187','188'} % Transference Experiment
        stepNum = 3;
    case {'159','161','180','186'} % Airpuff with experience
        stepNum = 1;
    otherwise
        error('do not recognize rat for protocol')
end
end