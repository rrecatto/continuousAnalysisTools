function saveChunk(src,ai_parameters)
fprintf('\nSaving Chunk..');

neuralDataTimes = src.NeuralDataTimes;
neuralData = src.NeuralData(:,1:src.NumDataPointsWritten);
elapsedTime = diff(src.NeuralDataTimes);

src.NeuralData(:,1:src.NumDataPointsWritten) = nan; 
src.NeuralDataTimes = [nan nan];


fprintf('collected %d samples\n',src.NumDataPointsWritten);
src.NumDataPointsWritten = 0;
chunkCount = src.ChunkNum;
evalStr=sprintf('chunk%d.neuralData = neuralData; chunk%d.neuralDataTimes = neuralDataTimes',chunkCount,chunkCount);
eval(evalStr);
fprintf('Saving to file %s  - ',src.NeuralRecordsName);
tic;
if exist(src.NeuralRecordsName,'file')
    evalStr=sprintf('save %s chunk%d -append', src.NeuralRecordsName, chunkCount);
else
    evalStr=sprintf('save %s chunk%d', src.NeuralRecordsName, chunkCount);
end
eval(evalStr);

if src.ChunkNum==1
    save(src.NeuralRecordsName,'ai_parameters','-append')
end

saveDur=toc;
fprintf('that save took %4.2f sec\n',saveDur);

src.ChunkNum = src.ChunkNum+1;
src.ChunkWritten = true;
end