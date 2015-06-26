function [compiledRecords]=getCompiledRecordsForSubjectID(r,sID)

disp(sprintf('loading compiled records for %s (from ratrix)',sID))

[dataPath junk] = fileparts(getStandAlonePath(r));
subjCompiledStorePath = fullfile(dataPath,'CompiledTrialRecords');
subjSearchStr = sprintf('%s.*.mat',sID);
d = dir(fullfile(subjCompiledStorePath,subjSearchStr));
if length(d)>1
    error('multiiple compiled records. clean up before use');
elseif isempty(d)
    compiledRecords = [];
else
    compiledRecords = load(fullfile(subjCompiledStorePath,d.name));
end