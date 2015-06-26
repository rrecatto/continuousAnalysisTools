function out = getLatestSingleUnit(s)
unitLocation = fullfile(s.dataPath,s.subject,'analysis','singleUnits');
% find the singleUnit object of interest.
d = dir(unitLocation);
d = d(~ismember({d.name},{'.','..'}));
[junk order] = sort([d.datenum]);
d = d(order);
temp = load(fullfile(unitLocation,d(end).name));
out = temp.currentUnit;
end