function s = addUniqueStepNamesToScratchPad(s)

[B I J]=unique(s.analysisType);
for i=1:length(s.analyses)
    i
    moreThanOnce=sum(J(i)==J)>1;
    if moreThanOnce
        instance=i;  % garaunteed to be unique, but a little sloppy
        % doing this instead of making a counter for each type
        
        stepName=[s.analysisType{i} num2str(instance)];
        stepNames{i}=stepName; % do we need this history?
        theseTrials=s.analyses{i}.trials;
        for j=1:length(theseTrials)
            trialFilter={'trialRange',minmax(theseTrials(j))};
            [physRecords success filePaths]=getPhysRecords(s.subjectDataPath,trialFilter,{'stim'},'anything');
            if j==1
                pth=fileparts(filePaths.scratchPad)
                mkdir(pth)
            end
            if 0% if we wanted to let multiple variable be there
                save(filePaths.scratchPad,'stepName','-APPEND'); % UNTESTED
            else  %what we do now
                %overwrite
                save(filePaths.scratchPad,'stepName');
                disp(sprintf('successfuly wrote: %s /t %s',filePaths.scratchPad,stepName))
            end
        end
    else
        stepNames{i}=s.analysisType{i};  % do we need this history?
    end
end
end