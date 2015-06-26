function out = createAnalysis(sm,c)
if parameters.checkCurrUnit
    d = dir(parameters.singleUnitPath);
    d = d(~ismember({d.name},{'.','..'}));
    [junk order] = sort([d.datenum]);
    d = d(order);
    temp = load(fullfile(parameters.singleUnitPath,d(end).name));
    currentUnit = temp.currentUnit;
    
    c = cumulativedata;
    c.stimInfo = stimInfo;
    
    switch sweptParameterThis{1}
        case 'pixPerCycs'
            sfAnalysis = sfGratings(parameters.subjectID,trialNumbers,c);
            currentUnit = addAnalysis(currentUnit,sfAnalysis);
        case 'driftfrequencies'
            tfAnalysis = tfGratings(parameters.subjectID,trialNumbers,c);
            currentUnit = addAnalysis(currentUnit,tfAnalysis);
        case 'orientations'
            orAnalysis = orGratings(parameters.subjectID,trialNumbers,c);
            currentUnit = addAnalysis(currentUnit,orAnalysis);
        case 'contrasts'
            cntrAnalysis = cntrGratings(parameters.subjectID,trialNumbers,c);
            currentUnit = addAnalysis(currentUnit,cntrAnalysis);
        case {'startPhases','durations','radii','annuli'};
            % do nothing
        otherwise
            error('unknown parameter');
    end
    save(fullfile(parameters.singleUnitPath,d(end).name),'currentUnit');
end