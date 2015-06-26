function LFPRecord = updateLFPRecord(currentLFPRecord,LFPRecord)
% All LFPRecord will have the following structure
%       LFPRecord.
%                    
% ********************* trode specific *********************
%                    (trodeStr).  n=1,2,3,....
%                               data
%                               dataTimes
% one or more of the above may be present or absent at any point during the
% update and exactly what is updated depends on updateMode

if ~exist('currentLFPRecord','var')||isempty(currentLFPRecord)
    error('need currentLFPRecord');
end

if ~exist('LFPRecord','var')
    error('need LFPRecord');
end
trodesInCurrent = fieldnames(currentLFPRecord);
trodesInCurrent = trodesInCurrent(~cellfun(@isempty,regexp(trodesInCurrent,'^trode')));
for currentTrode = trodesInCurrent' % loop through all the trode fields
    if ~isfield(LFPRecord,currentTrode{:}) % the analysis was never run for the trode
        LFPRecord.(currentTrode{:}) = currentLFPRecord.(currentTrode{:});
    else % prev analysis exists. check if the trodeChans are identical
        LFPRecord.(currentTrode{:}).data = [LFPRecord.(currentTrode{:}).data; currentLFPRecord.(currentTrode{:}).data];
        LFPRecord.(currentTrode{:}).dataTimes = minmax([LFPRecord.(currentTrode{:}).dataTimes currentLFPRecord.(currentTrode{:}).dataTimes]);
        % this should be fine because LFP data times are only for a single
        % trial where there is no lag due to inter trial interval.
    end
end
end