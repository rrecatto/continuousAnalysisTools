function out=getTrainingStepNames(p)
    out = {};
    for i = 1:length(p.trainingSteps)
        out{i} = getStepName(p.trainingSteps{i});
    end