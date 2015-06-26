function [graduate, details] = checkCriterion(c,subject,trainingStep,trialRecords, compiledRecords)

%determine what type trialRecord are
recordType='compiledData'; %circularBuffer

thisStep=[trialRecords.trainingStepNum]==trialRecords(end).trainingStepNum;
trialsUsed=trialRecords(thisStep);

graduate=true;
if ~isempty(trialRecords)
    %get the correct vector
    switch recordType
        case 'largeData'
            dates = floor(datenum(cell2mat({trialsUsed.date}'))); % the actual dates of each trials
            
            graduate = graduate && length(unique(dates))>c.numDays;
            
        case 'compiledData'
            dates = unique(floor(datenum(cell2mat({trialsUsed.date}')))); % the actual dates of each trials
            if ~isempty(compiledRecords)
                whichCompiled = compiledRecords.compiledTrialRecords.step == trialRecords(end).trainingStepNum;
                datesCompiled = unique(floor(compiledRecords.compiledTrialRecords.date(whichCompiled)));
            else
                datesCompiled = [];
            end
            graduate = graduate && (length(union(dates,datesCompiled))>c.numDays);
        otherwise
            error('unknown trialRecords type')
    end

end


%play graduation tone

if graduate
    beep;
    pause(.2);
    beep;
    pause(.2);
    beep;
    pause(1);
    [junk stepNum]=getProtocolAndStep(subject);
    for i=1:stepNum+1
        beep;
        pause(.4);
    end
    if (nargout > 1)
        details.date = now;
        details.criteria = c;
        details.graduatedFrom = stepNum;
        details.allowedGraduationTo = stepNum + 1;
        details.numDays = c.numDays;
    end
end
end % end function