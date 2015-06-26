function [compiledRecords]=getCompiledRecordsForSubject(r,subject)

sID = getID(subject);
[compiledRecords]=getCompiledRecordsForSubjectID(r,sID)