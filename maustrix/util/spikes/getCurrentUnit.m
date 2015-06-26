function [out unitName] = getCurrentUnit(recordsPath,subjectID)
    singleUnitsPath = fullfile(recordsPath,subjectID,'analysis','singleUnits');
    d = dir(singleUnitsPath);
    d = d(~ismember({d.name},{'.','..'}));
    [junk order] = sort([d.datenum]);
    d = d(order);
    temp = load(fullfile(singleUnitsPath,d(end).name));
    out = temp.currentUnit;
    unitName = d(end).name;
end