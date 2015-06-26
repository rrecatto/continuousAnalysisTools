%% only search
path = '\\132.239.158.169\datanetOutput';
search = true;
if search
    violations = struct;
    
    for rat = {'389','402','404','405','406','407','408'}
        fprintf('rat: %s\n',rat{1})
        fname = sprintf('Rat%s',rat{1});
        violations.(fname) = {};
        dirList = dir(fullfile(path,rat{1},'neuralRecords'));
        dirList = dirList(~[dirList.isdir]);
        for recNum = 1:length(dirList)
            fprintf('%d of %d\n',recNum,length(dirList));
            temp = load(fullfile(path,rat{1},'neuralRecords',dirList(recNum).name));
            numChunksActual = sum(cell2mat(strfind(fieldnames(temp),'chunk')));
            if isfield(temp,'numChunks')
                numChunksSaved = length(temp.numChunks);
                if numChunksActual ~= numChunksSaved
                    violations.(fname){end+1} = dirList(recNum).name;
                end
            end
            
        end
        save(fullfile(path,'violations.mat'),'violations')
    end
end
%% only correct
correct = false;
if correct
    temp = load(fullfile(path,'violations.mat'));
    violations = temp.violations;
    for rat = {'389','402','404','405','406','407','408'}
        ratName = sprintf('Rat%s',rat{1})
        for suspectRecord = violations.(ratName)
            temp = load(fullfile(path,rat{1},'neuralRecords',suspectRecord{1}));
            temp.numChunks = 1:sum(cell2mat(strfind(fieldnames(temp),'chunk')));
            save(fullfile(path,rat{1},'neuralRecords',suspectRecord{1}),'-struct','temp')
            
            
        end
    end
end