function decacheGratingsStimulusDetails(location,whichMice,since)
if ~exist('location','var') || isempty(location)
    error('must provide location');
end
if ~exist('whichMice','var')||isempty(whichMice)
    whichMice = dir(location);
    whichMice = {whichMice.name};
    whichMice = whichMice(~ismember(whichMice,{'.','..','.DS_Store'}));
end
if ~exist('since','var')||isempty(since)
    since = 1;
elseif ~isnumeric(since) || since<0
    error('since should be a number greater than equal to 0!!');
end

for miceNum = 1:length(whichMice)
    currMouse = whichMice{miceNum};
    currMouse
    if isdir(fullfile(location,currMouse))
        files = dir(fullfile(location,currMouse));
        files = files([files.datenum]>since);
        files = {files.name};
        files = files(~ismember(files,{'.','..'}));
        for j = 1:length(files)
            clear fieldsInLUT sessionLUT trialRecords
            load(fullfile(location,currMouse,files{j}));
            for k = 1:length(trialRecords)
                if isfield(trialRecords(k).stimDetails,'masks')
                    trialRecords(k).stimDetails.masks = [];
                end
                if isfield(trialRecords(k).stimDetails,'centerMask')
                    trialRecords(k).stimDetails.centerMask = [];
                end
                if isfield(trialRecords(k).stimDetails,'surroundMask')
                    trialRecords(k).stimDetails.surroundMask = [];
                end
            end
            % now save it!
            save(fullfile(location,currMouse,files{j}),'fieldsInLUT','sessionLUT','trialRecords')
        end
    else
        disp('not doing anything')
    end
end