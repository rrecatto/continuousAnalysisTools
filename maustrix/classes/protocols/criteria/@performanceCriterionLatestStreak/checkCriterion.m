function [graduate details] = checkCriterion(c,subject,trainingStep,trialRecords, compiledRecords)

fieldNames = fields(trialRecords);

forcedRewards = 0;
stochastic = 0;
humanResponse = 0;

warnStatus = false;

trialsInTR = [trialRecords.trialNumber];
if ~isempty(compiledRecords)
    trialsFromCR = compiledRecords.compiledTrialRecords.trialNumber;
    trialsFromCRToBeIncluded = ~ismember(trialsFromCR,trialsInTR);
    allStepNums = [compiledRecords.compiledTrialRecords.step(trialsFromCRToBeIncluded) trialRecords.trainingStepNum];
else
    trialsFromCRToBeIncluded = [];
    allStepNums = [trialRecords.trainingStepNum];
end

td(length(trialRecords)).correct = nan;
for tnum = 1:length(trialRecords)
    if isfield(trialRecords(tnum),'trialDetails') && ~isempty(trialRecords(tnum).trialDetails) ...
            && ~isempty(trialRecords(tnum).trialDetails.correct)
        td(tnum).correct = trialRecords(tnum).trialDetails.correct;
    else
        td(tnum).correct = nan;
    end
end

if ~isempty(compiledRecords)
    allCorrects = [compiledRecords.compiledTrialRecords.correct(trialsFromCRToBeIncluded) td.correct];
else
    allCorrects = [td.correct];
end

if ismember({'containedForcedRewards'},fieldNames)
    ind = find(cellfun(@isempty,{trialRecords.containedForcedRewards}));
    if ~isempty(ind)
        warning('using pessimistic values for containedForcedRewards');
        for i=1:length(ind)
            trialRecords(ind(i)).containedForcedRewards = 1;
        end
    end
    forcedRewards = [trialRecords.containedForcedRewards]==1;
else 
    warnStatus = true;
end

if ~isempty(compiledRecords)
    allForcedRewards = [compiledRecords.compiledTrialRecords.containedForcedRewards(trialsFromCRToBeIncluded) forcedRewards];
else
    allForcedRewards = [forcedRewards];
end

if ismember({'didStochasticResponse'},fieldNames)
    ind = find(cellfun(@isempty,{trialRecords.didStochasticResponse}));
    if ~isempty(ind)
        warning('using pessimistic values for didStochasticResponse');
        for i=1:length(ind)
            trialRecords(ind(i)).didStochasticResponse = 1;
        end
    end
    stochastic = [trialRecords.didStochasticResponse];
else 
    warnStatus = true;
end

if ~isempty(compiledRecords)
    allStochastic = [compiledRecords.compiledTrialRecords.didStochasticResponse(trialsFromCRToBeIncluded) stochastic];
else
    allStochastic = [stochastic];
end

if ismember({'didHumanResponse'},fieldNames)
    ind = find(cellfun(@isempty,{trialRecords.didHumanResponse}));
    if ~isempty(ind)
        warning('using pessimistic values for didHumanResponse');
        for i=1:length(ind)
            trialRecords(ind(i)).didHumanResponse = 1;
        end
    end
    humanResponse = [trialRecords.didHumanResponse];
else 
    warnStatus = true;
end

if ~isempty(compiledRecords)
    allHumanResponse = [compiledRecords.compiledTrialRecords.didHumanResponse(trialsFromCRToBeIncluded) humanResponse];
else
    allHumanResponse = [humanResponse];
end

if warnStatus
    warning(['checkCriterion found trialRecords of the older format. some necessary fields are missing. ensure presence of ' ...
    '''containedForcedRewards'',''didStochasticResponse'' and ''didHumanResponse'' in trialRecords to remove this warning']);
end

trialsThisStep=allStepNums==allStepNums(end);
trialsThisStep(1:find([1 diff(trialsThisStep)]==1,1,'last')-1) = 0;

which= trialsThisStep & ~allStochastic & ~allHumanResponse & ~allForcedRewards;
which= trialsThisStep & ~allStochastic & ~allForcedRewards;

% modified to allow human responses to count towards graduation (performanceCriterion)
% which= trialsThisStep & ~stochastic & ~forcedRewards;

[graduate whichCriteria correct]=aboveThresholdPerformance(c.consecutiveTrials,c.pctCorrect,[],allCorrects(which));

%play graduation tone
if graduate
    beep;
    pause(.2);
    beep;
    pause(.2);
    beep;

    if (nargout > 1)
        details.date = now;
        details.criteria = c;
        details.graduatedFrom = stepNum;
        details.allowedGraduationTo = stepNum + 1;
        details.correct = correct;
        details.whichCriteria = whichCriteria;
    end
end