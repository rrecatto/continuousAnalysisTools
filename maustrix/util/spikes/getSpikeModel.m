function [spikeModel modelExists] = getSpikeModel(spikeRecord,spikeSortingParams)
if ~exist('spikeRecord','var')||isempty(spikeRecord)
    error('spikeRecord not well defined')
end
if ~exist('spikeSortingParams','var')||isempty(spikeSortingParams)
    error('spikeSortingParams not well defined')
end

spikeModel = [];
modelExists = false;
% find the trodes in spikeRecord
trodesInRecord = fieldnames(spikeRecord);
trodesInRecord = trodesInRecord(~cellfun(@isempty,regexp(trodesInRecord,'^trode')));
for trodeNum = 1:length(trodesInRecord)
    if isfield(spikeRecord.(trodesInRecord{trodeNum}),'spikeModel') && ~isempty(spikeRecord.(trodesInRecord{trodeNum}).spikeModel)
        modelExists(trodeNum) = true;
        spikeModel.(trodesInRecord{trodeNum}) = spikeRecord.(trodesInRecord{trodeNum}).spikeModel;
    else
        modelExists(trodeNum) = false;
    end
end

if ~all(modelExists)
    if isfield(spikeSortingParams,'method') && strcmp(spikeSortingParams.method,'useSpikeModelFromPreviousAnalysis')
        spikeModel = [];
        modelExists = false;
        boundaryRangeStr = sprintf('%d-%d',spikeSortingParams.modelBoundaryRange(1),spikeSortingParams.modelBoundaryRange(2));
        prevSpikeRecordPath = fullfile(spikeSortingParams.path,spikeSortingParams.subjectID,'analysis',boundaryRangeStr,'spikeRecord.mat')
        temp = stochasticLoad(prevSpikeRecordPath,'spikeRecord');
        prevSpikeRecord = temp.spikeRecord;
        % find all the field names with trode in them
        trodesInRecord = fieldnames(prevSpikeRecord);
        trodesInRecord = trodesInRecord(~cellfun(@isempty,regexp(trodesInRecord,'^trode')));
        for trodeNum = 1:length(trodesInRecord)
            if ~isfield(prevSpikeRecord.(trodesInRecord{trodeNum}),'spikeModel')
                spikeModel = [];
                return;
            else
                spikeModel.(trodesInRecord{trodeNum}) = prevSpikeRecord.(trodesInRecord{trodeNum}).spikeModel;
            end
        end
        modelExists = true;
    end
end     
% % analysisPath will have a file named spikeModel.mat
% spikeModelFile = fullfile(analysisPath,'spikeModel.mat');
% if exist(spikeModelFile,'file')
%     temp = stochasticLoad(spikeModelFile,'spikeModel');
%     spikeModel = temp.spikeModel;
%     modelExists = true;
% end
end
