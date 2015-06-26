% use this script only if you know what you are doing....always keep a
% backup

location= 'C:\Documents and Settings\rlab\Desktop\maustrix\ratrixData\PermanentTrialRecordStore';
mouseID = {'3','9','10','11','19','20','21','22','23','demo1'};

for i = 1:length(mouseID)
    % get dir listing
    d = dir(fullfile(location,mouseID{i}));
    d = d(~ismember({d.name},{'.','..'}));
    % go over the files one by one and add the missing details if relevant
    for j = 1:length(d)
        temp = load(fullfile(location,mouseID{i},d(j).name));
        for k = 1:length(temp.trialRecords)
            if strcmp(temp.sessionLUT(temp.trialRecords(k).stimManagerClass),'afcGratings')
                temp.trialRecords(k).stimDetails.doCombos = temp.trialRecords(k).stimDetails.chosenStim.doCombos;
                temp.trialRecords(k).stimDetails.pixPerCycs = temp.trialRecords(k).stimDetails.chosenStim.pixPerCycs;
                temp.trialRecords(k).stimDetails.driftfrequencies = temp.trialRecords(k).stimDetails.chosenStim.driftfrequencies;
                temp.trialRecords(k).stimDetails.orientations = temp.trialRecords(k).stimDetails.chosenStim.orientations;
                temp.trialRecords(k).stimDetails.phases = temp.trialRecords(k).stimDetails.chosenStim.phases;
                temp.trialRecords(k).stimDetails.contrasts = temp.trialRecords(k).stimDetails.chosenStim.contrasts;
                temp.trialRecords(k).stimDetails.maxDuration = temp.trialRecords(k).stimDetails.chosenStim.maxDuration;
                temp.trialRecords(k).stimDetails.radii = temp.trialRecords(k).stimDetails.chosenStim.radii;
                temp.trialRecords(k).stimDetails.annuli = temp.trialRecords(k).stimDetails.chosenStim.annuli;
            end
            
        end
        % now save trialrecords
        trialRecords = temp.trialRecords;
        sessionLUT = temp.sessionLUT;
        fieldsInLUT = temp.fieldsInLUT;
        save(fullfile(location,mouseID{i},d(j).name),'trialRecords','sessionLUT','fieldsInLUT');
    end
    fprintf('done mouse %s\n',mouseID{i});
end
