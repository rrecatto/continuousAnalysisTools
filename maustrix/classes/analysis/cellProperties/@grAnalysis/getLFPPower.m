function out = getLFPPower(s,params)
% strategy is to load the neural records, split it into appropriate
% rep/type and then calculate the power spectrum using chronux

dataPath = recordsPathLUT(s.dataPath,'Win2Lx');
analysisPath = fullfile(dataPath,s.subject,'analysis');
neuralRecPath = fullfile(dataPath,s.subject,'neuralRecords');
LFPRecPath = fullfile(dataPath,s.subject,'LFPRecords');
if ~isdir(LFPRecPath)
    mkdir(LFPRecPath)
end
trials = s.trials;
whichRecs = {};
for i = 1:length(trials)
    d = dir(fullfile(neuralRecPath,sprintf('neuralRecords_%d-*.mat',trials(i))));
    if length(d)~=1
        keyboard
    else
        whichRecs{end+1} = d.name;
    end
end

[sp fr] = getSpikes(s);

% now get the neuralrecs and concateneate them
for i = 1:length(trials)
    filename = fullfile(neuralRecPath,whichRecs{i});
    temp = load(filename);
    % find numChunks
    numChunks = length(find(~cellfun(@isempty,strfind(fieldnames(temp),'chunk'))));
    neuralRec = [];
    % collect neuralData
    for j = 1:numChunks
        chunkName = sprintf('chunk%d',j);
        neuralRec = [neuralRec;temp.(chunkName).neuralData(:,3)];
    end
    
end

end