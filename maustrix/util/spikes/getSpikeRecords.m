function spikeRecord = getSpikeRecords(analysisPath,parameters)
spikeRecordFile = fullfile(analysisPath,'spikeRecord.mat');
switch parameters.analysisMode
    case {'overwriteAll','onlyAnalyze','onlyDetectAndSort','onlyDetect','onlyInspect','onlyInspectInteractive'}
        if exist(spikeRecordFile,'file')
            temp = stochasticLoad(spikeRecordFile,{'spikeRecord'});
            spikeRecord = temp.spikeRecord;
        else
            spikeRecord = [];
        end
    case {'onlySort','onlySortNoInspect'}
        % actually needs to flush all previous sorting data from
        % spikeRecord. done ****balaji 14 july 2010
        % should be intelligent about doing this only for the first trial
        % in the boundary range. done balaji july 16 2010
        if (parameters.boundaryRange(1)==parameters.trialNum)
            if exist(spikeRecordFile,'file')
                temp = stochasticLoad(spikeRecordFile,{'spikeRecord'});
                spikeRecord = temp.spikeRecord;
                trodesInRecord = fieldnames(spikeRecord);
                trodesInRecord = trodesInRecord(~cellfun(@isempty,regexp(trodesInRecord,'^trode')));
                fieldsToRemove = {'assignedClusters','rankedClusters','processedClusters',...
                    'trialNumForSortedSpikes','chunkIDForSortedSpikes','spikeModel'};
                for currTrode = trodesInRecord'
                    for whichFieldToRemove = fieldsToRemove
                        if isfield(spikeRecord.(currTrode{:}),whichFieldToRemove{:})
                            spikeRecord.(currTrode{:}) = rmfield(spikeRecord.(currTrode{:}),whichFieldToRemove{:});
                        end
                    end
                end
            else
                error('cannot onlySort without a spikeRecord File !!');
            end
        else
            if exist(spikeRecordFile,'file')
                temp = stochasticLoad(spikeRecordFile,{'spikeRecord'});
                spikeRecord = temp.spikeRecord;
            end
        end
    otherwise
        error('unsupported analysisMode');
end
end