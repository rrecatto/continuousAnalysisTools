% use this script only if you know what you are doing....always keep a
% backup

% adding 
% location = 'C:\Users\Visual Stim\Desktop\ratrixData.19\PermanentTrialRecordStore';
location = 'C:\Users\Visual Stim\Desktop\ratrixData.20\PermanentTrialRecordStore';
% location= 'C:\Documents and Settings\rlab\Desktop\maustrix\ratrixData\PermanentTrialRecordStore';
% mouseID = {'2','3','9','10','11','19','20','21','22','23','25','27','999','demo1'};
mouseID = {'6','11','12','13','14','16','17','18','19','24','25','26','999','demo1'};
clc;
for i = 1:length(mouseID)
    % get dir listing
    d = dir(fullfile(location,mouseID{i}));
    d = d(~ismember({d.name},{'.','..'}));
    % go over the files one by one and add the missing details if relevant
    for j = 1:length(d)
        temp = load(fullfile(location,mouseID{i},d(j).name));
        for k = 1:length(temp.trialRecords)
            if strcmp(temp.sessionLUT(temp.trialRecords(k).stimManagerClass),'afcGratings')
                sm = afcGratings;
                temp.trialRecords(k).stimDetails.afcGratingType = getType(sm,temp.trialRecords(k).stimDetails.possibleStims);
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
