% use this script only if you know what you are doing....always keep a
% backup

% adding correctionTrial to the base compiledTrialRecords first to .19
location = 'C:\Users\Visual Stim\Desktop\ratrixData.19\PermanentTrialRecordStore';
mouseID = {'2','3','9','10','11','19','20','21','22','23','25','27','29','999','demo1'};
clc;
for i = 1:length(mouseID)
    % get dir listing
    d = dir(fullfile(location,mouseID{i}));
    d = d(~ismember({d.name},{'.','..'}));
    % go over the files one by one and add the missing details if relevant
    for j = 1:length(d)
        temp = load(fullfile(location,mouseID{i},d(j).name));
        for k = 1:length(temp.trialRecords)
            sm = afcGratings;
            if isfield(temp.trialRecords(k).stimDetails,'correctionTrial')
                temp.trialRecords(k).correctionTrial= temp.trialRecords(k).stimDetails.correctionTrial;
%                 keyboard
            else
                fprintf('mouse: %s- trialNum: %d...no correctionTrial\n',mouseID{i},temp.trialRecords(k).trialNumber)
            end
        end
        % now save trialrecords
        trialRecords = temp.trialRecords;
        sessionLUT = temp.sessionLUT;
        fieldsInLUT = temp.fieldsInLUT;
        save(fullfile(location,mouseID{i},d(j).name),'trialRecords','sessionLUT','fieldsInLUT');
        fprintf('m %d of %d; rec %d of %d\n',i,length(mouseID),j,length(d));
    end
end

% then compile detailedrecords for the same
compileDetailedRecords([],{'2','3','9','10','11','19','20','21','22','23','25','27','29','999','demo1'},...
    true,'C:\Users\Visual Stim\Desktop\ratrixData.19\PermanentTrialRecordStore',...
    'C:\Users\Visual Stim\Desktop\ratrixData.19\CompiledTrialRecords')
%%
% adding correctionTrial to the base compiledTrialRecords then to .20
location = 'C:\Users\Visual Stim\Desktop\ratrixData.20\PermanentTrialRecordStore';
mouseID = {'6','11','12','13','14','16','17','18','19','24','25','26','28','30','999','demo1'};
clc;
for i = 1:length(mouseID)
    % get dir listing
    d = dir(fullfile(location,mouseID{i}));
    d = d(~ismember({d.name},{'.','..'}));
    % go over the files one by one and add the missing details if relevant
    for j = 1:length(d)
        temp = load(fullfile(location,mouseID{i},d(j).name));
        for k = 1:length(temp.trialRecords)
            sm = afcGratings;
            if isfield(temp.trialRecords(k).stimDetails,'correctionTrial')
                temp.trialRecords(k).correctionTrial= temp.trialRecords(k).stimDetails.correctionTrial;
%                 keyboard
            else
                fprintf('mouse: %s- trialNum: %d...no correctionTrial\n',mouseID{i},temp.trialRecords(k).trialNumber)
            end
        end
        % now save trialrecords
        trialRecords = temp.trialRecords;
        sessionLUT = temp.sessionLUT;
        fieldsInLUT = temp.fieldsInLUT;
        save(fullfile(location,mouseID{i},d(j).name),'trialRecords','sessionLUT','fieldsInLUT');
        fprintf('m %d of %d; rec %d of %d\n',i,length(mouseID),j,length(d));
    end
end

compileDetailedRecords([],{'6','11','12','13','14','16','17','18','19','24','25','26','28','30','999','demo1'},...
    true,'C:\Users\Visual Stim\Desktop\ratrixData.20\PermanentTrialRecordStore',...
    'C:\Users\Visual Stim\Desktop\ratrixData.20\CompiledTrialRecords')

