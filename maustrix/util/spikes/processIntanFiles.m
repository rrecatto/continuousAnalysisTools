function processIntanFiles(subjectID, basePath, trialNumberRange)
INTANLoc = fullfile(basePath,subjectID,'neuralRecordsRaw')
neuralLoc = fullfile(basePath,subjectID,'neuralRecords')

for trialNum = trialNumberRange(1):trialNumberRange(2)
    searchFileName = sprintf('neuralRecords_%d-*.*',trialNum);
    d = dir(fullfile(INTANLoc,searchFileName));
    if length(d) == 0
        continue;
    end
     for i = 1:length(d)
         out  = readIntan(fullfile(INTANLoc,d(i).name));
         [~,fileBase,~] = fileparts(d(i).name);
         neuralRecordsName = fullfile(neuralLoc,[fileBase,'.mat']);
         if length(dir(neuralRecordsName))~=1
             error('neuralRecords is not saved. wtf');
         end
         temp = load(neuralRecordsName);

         neuralFilterParams = out.frequency_parameters;
         chunk1.neuralData = out.amplifier_data';
         chunk1.neuralDataTimes = [0 size(chunk1.neuralData,1)]/neuralFilterParams.amplifier_sample_rate;
         chunk1.digitalData = out.board_dig_in_data';
         chunk1.elapsedTime = diff(chunk1.neuralDataTimes);
         
         numChunks = 1;
         samplingRate = temp.samplingRate;
         stimFilename = temp.stimFilename;
         try
             electrodeDetails = temp.electrodeDetails;
         catch
             electrodeDetails = [];
         end
         
         channelConfiguration = cell(1,length(out.amplifier_channels));
         
         for j = 1:length(out.amplifier_channels)
             channelConfiguration{j} = out.amplifier_channels(j).custom_channel_name;
             if ~strfind(out.amplifier_channels(j).custom_channel_name,'phys')
                 % older status without 'phys' label
                 channelConfiguration{j} = sprintf('phys%d',j);
             end
         end
         
         digitalConfigration = cell(1,length(out.board_dig_in_channels));
         for j = 1:length(out.board_dig_in_channels)
             digitalConfigration{j} = out.board_dig_in_channels(j).custom_channel_name;
         end
         
         chunk1.channelConfiguration = channelConfiguration;
         chunk1.digitalConfigration = digitalConfigration;
         
         save(neuralRecordsName,'chunk1')
         save(neuralRecordsName,'neuralFilterParams','-append')
         save(neuralRecordsName,'numChunks','-append')
         save(neuralRecordsName,'samplingRate','-append')
         save(neuralRecordsName,'stimFilename','-append')
         save(neuralRecordsName,'electrodeDetails','-append')
         
     end
end
end