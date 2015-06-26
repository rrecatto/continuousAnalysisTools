function out=getTrainingStepNamesForSubject(r,subj)
out = getTrainingStepNames(r.subjects{strcmp(getSubjectIDs(r),subj)});
end