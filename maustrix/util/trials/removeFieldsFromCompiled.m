%this m-file is made for manual execuation
%it will remove all feilds in the compiled directory with the field name specified


%%

warning('will remove fields and might ruin data! only run if you are sure you want to remove this feild from all rats!')
disp('press 5 buttons to continue, cntl-c to cancel')
for i=1:5   
    pause
    disp(num2str(i))
end

%%

rackNum=1;
compiledRecordsDirectory=getCompiledDirForRack(rackNum);
d=dir(fullfile(compiledRecordsDirectory, '*.compiledTrialRecords.*.mat'))


%% set fields

%whats going:
removeFields={'devPix'};

%what you start with before you remove.
previousFields={...
    'trialNumber',...
    'date',...
    'response',...
    'correct',...
    'step',...
    'correctionTrial',...
    'maxCorrectForceSwitch',...
    'responseTime',...
    'actualRewardDuration',...
    'manualVersion',...
    'autoVersion',...
    'didStochasticResponse',...
    'containedForcedRewards',...
    'didHumanResponse',...
    'correctResponseIsLeft',...
    'targetContrast',...
    'targetOrientation',...
    'flankerContrast',...
    'flankerOrientation',...
    'deviation',...
    'devPix',...
    'targetPhase',...
    'flankerPhase',...
    'currentShapedValue',...
    'pixPerCycs',...
    'redLUT',...
    'stdGaussMask'};

%%
for i=1:length(d)
    disp(d(i).name)
    dots=strfind(d(i).name,'.');
    name=d(i).name(1:dots(1)-1);
    disp(sprintf('doing rat: %s',name ))
    [out num er]=sscanf(d(i).name,[name '.compiledTrialRecords.%d-%d.mat'],2);
    compiledRange=out(1:2);
    compiledTrialRecords=loadCompiledTrialRecords(fullfile(compiledRecordsDirectory,d(i).name),compiledRange,previousFields);

    compiledTrialRecords=rmfield(compiledTrialRecords,removeFields);
    lo=min([compiledTrialRecords.trialNumber]);
    hi=max([compiledTrialRecords.trialNumber]);
    
    doIt=1;
    if doIt
        save(fullfile(compiledRecordsDirectory,[name '.compiledTrialRecords.' num2str(lo) '-' num2str(hi) '.mat']),'compiledTrialRecords')
    end
end

