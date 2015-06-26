function out = findCompiledRecordsForSubject(at,subject)
subjectFileNameMatch = fullfile(at,sprintf('%s.compiledTrialRecords.*.mat',subject));
d = dir(subjectFileNameMatch);
out = '';
if length(d)~=1
    length(d)
    error('too many or too few records found');
else
    out = fullfile(at,d.name);
end
