function [graduate details] = checkCriterion(c,subject,trainingStep,trialRecords, compiledRecords)
% this criterion will graduate if we have done a certain number of trials in this trainingStep


thisStep=[trialRecords.trainingStepNum]==trialRecords(end).trainingStepNum;
trialsUsed=trialRecords(thisStep);
if ~isempty(compiledRecords)
    whichCompiledTrials = compiledRecords.compiledTrialRecords.step == trialRecords(end).trainingStepNum;
    compiledTrialNums = compiledRecords.compiledTrialRecords.trialNumber(whichCompiledTrials);
else
    compiledTrialNums = [];
end
trialsUsedTrialNums = [trialsUsed.trialNumber];
details=[];
graduate=0;

if length(union(trialsUsedTrialNums,compiledTrialNums)) >= c.numTrialsNeeded
    graduate = 1;
end

%play graduation tone
if graduate
    beep;
    pause(.2);
    beep;
    pause(.2);
    beep;
end