function out = filterBehaviorData(in,which,params)
switch which
    case 'date'
        if iscell(params) && all(cellfun(@ischar,params))
            datefilter = datenum(params);
        elseif ischar(params)
            datefilter = datenum(params);
        elseif isstruct(params)
            if isfield(params,'datenums')
                datefilter = params.datenums;
            elseif isfield(params,'datestrs')
                datefilter = datenum(params.datestrs);
            else
                which
                params
                error('not supported')
            end
        elseif isnumeric(params)
            % just send the datenums along
            datefilter = params;
        else
            error('not supported');
        end
        filterCompiledTrRec = ismember(floor(in.compiledTrialRecords.date),datefilter);
        fieldsCompiledTRs = fieldnames(in.compiledTrialRecords);
        for i = 1:length(fieldsCompiledTRs)
            out.compiledTrialRecords.(fieldsCompiledTRs{i}) = in.compiledTrialRecords.(fieldsCompiledTRs{i})(:,filterCompiledTrRec);
        end
        trialNumFilter = out.compiledTrialRecords.trialNumber;
        for i = 1:length(in.compiledDetails)
            filterCompiledTrDet = ismember(in.compiledDetails(i).trialNums,trialNumFilter);
            out.compiledDetails(i).className = in.compiledDetails(i).className;
            out.compiledDetails(i).trialNums = in.compiledDetails(i).trialNums(filterCompiledTrDet);
            if ~isempty(in.compiledDetails(i).records)
                detailRecsFields = fieldnames(in.compiledDetails(i).records);
                for j = 1:length(detailRecsFields)
                    out.compiledDetails(i).records.(detailRecsFields{j}) = in.compiledDetails(i).records.(detailRecsFields{j})(:,filterCompiledTrDet);
                end
            end
            filterBailedTrialNums = ismember(in.compiledDetails(i).bailedTrialNums,trialNumFilter);
            out.compiledDetails(i).bailedTrialNums = in.compiledDetails(i).bailedTrialNums(filterBailedTrialNums);
        end
        out.compiledLUT = in.compiledLUT;
    case 'tmClass'
        if iscell(params) && cellfun(@ischar,params) % use as is
            tmfilter = params;
        elseif isstruct(params)
            if isfield(params,'tmClass')
                tmfilter = params.tmClass;
            else
                which
                params
                error('not supported')
            end
        else
            error('not supported');
        end
        filterCompiledTrRec =  ismember(in.compiledLUT(in.compiledTrialRecords.trialManagerClass),tmfilter);
        fieldsCompiledTRs = fieldnames(in.compiledTrialRecords);
        for i = 1:length(fieldsCompiledTRs)
            out.compiledTrialRecords.(fieldsCompiledTRs{i}) = in.compiledTrialRecords.(fieldsCompiledTRs{i})(:,filterCompiledTrRec);
        end
        trialNumFilter = out.compiledTrialRecords.trialNumber;
        for i = 1:length(in.compiledDetails)
            filterCompiledTrDet = ismember(in.compiledDetails(i).trialNums,trialNumFilter);
            out.compiledDetails(i).className = in.compiledDetails(i).className;
            out.compiledDetails(i).trialNums = in.compiledDetails(i).trialNums(filterCompiledTrDet);
            detailRecsFields = fieldnames(in.compiledDetails(i).records);
            for j = 1:length(detailRecsFields)
                out.compiledDetails(i).records.(detailRecsFields{j}) = in.compiledDetails(i).records.(detailRecsFields{j})(:,filterCompiledTrDet);
            end
            filterBailedTrialNums = ismember(in.compiledDetails(i).bailedTrialNums,trialNumFilter);
            out.compiledDetails(i).bailedTrialNums = in.compiledDetails(i).bailedTrialNums(filterBailedTrialNums);
        end
        out.compiledLUT = in.compiledLUT;
    case 'smClass' 
        % it is possible that multiple instances of smClasses will be written  
        % in details. but i reject details which do not belong to the smClass 
        % by chencking if the details struct is empty or not at the end of the collection
        
        if iscell(params) && cellfun(@ischar,params) % use as is
            smfilter = params;
        elseif isstruct(params)
            if isfield(params,'smClass')
                smfilter = params.smClass;
            else
                which
                params
                error('not supported')
            end
        else
            error('not supported');
        end
        filterCompiledTrRec =  ismember(in.compiledLUT(in.compiledTrialRecords.stimManagerClass),smfilter);
        fieldsCompiledTRs = fieldnames(in.compiledTrialRecords);
        for i = 1:length(fieldsCompiledTRs)
            out.compiledTrialRecords.(fieldsCompiledTRs{i}) = in.compiledTrialRecords.(fieldsCompiledTRs{i})(:,filterCompiledTrRec);
        end
        trialNumFilter = out.compiledTrialRecords.trialNumber;
        toRemove = [];
        for i = 1:length(in.compiledDetails)
            filterCompiledTrDet = ismember(in.compiledDetails(i).trialNums,trialNumFilter);
            out.compiledDetails(i).className = in.compiledDetails(i).className;
            out.compiledDetails(i).trialNums = in.compiledDetails(i).trialNums(filterCompiledTrDet);
            detailRecsFields = fieldnames(in.compiledDetails(i).records);
            for j = 1:length(detailRecsFields)
                out.compiledDetails(i).records.(detailRecsFields{j}) = in.compiledDetails(i).records.(detailRecsFields{j})(:,filterCompiledTrDet);
            end
            filterBailedTrialNums = ismember(in.compiledDetails(i).bailedTrialNums,trialNumFilter);
            out.compiledDetails(i).bailedTrialNums = in.compiledDetails(i).bailedTrialNums(filterBailedTrialNums);
            if isempty(out.compiledDetails(i).trialNums)
                keyboard
                toRemove = [toRemove i];
            end
        end
        out.compiledDetails(toRemove) = [];
        out.compiledLUT = in.compiledLUT;
    case 'tsName'
        if ischar(params) % use as is
            tsfilter = params;
        elseif isstruct(params)
            if isfield(params,'tsName')
                tsfilter = params.tsName;
            else
                which
                params
                error('not supported')
            end
        else
            error('not supported');
        end
        filterCompiledTrRec =  ~cellfun(@isempty,strfind(in.compiledLUT(in.compiledTrialRecords.trainingStepName),tsfilter));
        fieldsCompiledTRs = fieldnames(in.compiledTrialRecords);
        for i = 1:length(fieldsCompiledTRs)
            out.compiledTrialRecords.(fieldsCompiledTRs{i}) = in.compiledTrialRecords.(fieldsCompiledTRs{i})(:,filterCompiledTrRec);
        end
        trialNumFilter = out.compiledTrialRecords.trialNumber;
        k = 0;
        for i = 1:length(in.compiledDetails)
            filterCompiledTrDet = ismember(in.compiledDetails(i).trialNums,trialNumFilter);
            if ~isempty(filterCompiledTrDet)
                k = k+1;
                out.compiledDetails(k).className = in.compiledDetails(i).className;
                out.compiledDetails(k).trialNums = in.compiledDetails(i).trialNums(filterCompiledTrDet);
                if ~isempty(in.compiledDetails(i).records) % some may have bailed.....
                    detailRecsFields = fieldnames(in.compiledDetails(i).records);
                    for j = 1:length(detailRecsFields)
                        out.compiledDetails(k).records.(detailRecsFields{j}) = in.compiledDetails(i).records.(detailRecsFields{j})(:,filterCompiledTrDet);
                    end
                end
                filterBailedTrialNums = ismember(in.compiledDetails(i).bailedTrialNums,trialNumFilter);
                out.compiledDetails(k).bailedTrialNums = in.compiledDetails(i).bailedTrialNums(filterBailedTrialNums);
            end
        end
        out.compiledLUT = in.compiledLUT;
    case 'removeCorrectNANs'
        filterCompiledTrRec =  ~isnan(in.compiledTrialRecords.correct);
        fieldsCompiledTRs = fieldnames(in.compiledTrialRecords);
        for i = 1:length(fieldsCompiledTRs)
            out.compiledTrialRecords.(fieldsCompiledTRs{i}) = in.compiledTrialRecords.(fieldsCompiledTRs{i})(:,filterCompiledTrRec);
        end
        trialNumFilter = out.compiledTrialRecords.trialNumber;
        for i = 1:length(in.compiledDetails)
            filterCompiledTrDet = ismember(in.compiledDetails(i).trialNums,trialNumFilter);
            out.compiledDetails(i).className = in.compiledDetails(i).className;
            out.compiledDetails(i).trialNums = in.compiledDetails(i).trialNums(filterCompiledTrDet);
            if ~isempty(in.compiledDetails(i).records)
                detailRecsFields = fieldnames(in.compiledDetails(i).records);
                for j = 1:length(detailRecsFields)
                    out.compiledDetails(i).records.(detailRecsFields{j}) = in.compiledDetails(i).records.(detailRecsFields{j})(:,filterCompiledTrDet);
                end
            end
        end
        out.compiledLUT = in.compiledLUT;
    case 'removeCorrections'
        % this is special because correction trial is set to nan sometime
        tN = in.compiledTrialRecords.trialNumber;
        actualCorr = nan(size(tN));
        
        for i = 1:length(in.compiledDetails)
            currTrialNums = in.compiledDetails(i).trialNums;
            [ismem,whereToFit] = ismember(currTrialNums,tN);
            if ~all(ismem)
                error('not possible!');
            end
            if ~isempty(in.compiledDetails(i).records)
                actualCorr(whereToFit) = in.compiledDetails(i).records.correctionTrial;
            end
        end
        
        % ok now we have what we wanted all together....
        in.compiledTrialRecords.correctionTrial = actualCorr;
        
        % filter out nans in actualCorr
        filterCorrNaNs = ~isnan(in.compiledTrialRecords.correctionTrial);
        fieldsCompiledTRs = fieldnames(in.compiledTrialRecords);
        for i = 1:length(fieldsCompiledTRs)
            out.compiledTrialRecords.(fieldsCompiledTRs{i}) = in.compiledTrialRecords.(fieldsCompiledTRs{i})(:,filterCorrNaNs);
        end
        trialNumFilter = out.compiledTrialRecords.trialNumber;
        for i = 1:length(in.compiledDetails)
            filterCompiledTrDet = ismember(in.compiledDetails(i).trialNums,trialNumFilter);
            out.compiledDetails(i).className = in.compiledDetails(i).className;
            out.compiledDetails(i).trialNums = in.compiledDetails(i).trialNums(filterCompiledTrDet);
            if ~isempty(in.compiledDetails(i).records)
                detailRecsFields = fieldnames(in.compiledDetails(i).records);
                for j = 1:length(detailRecsFields)
                    out.compiledDetails(i).records.(detailRecsFields{j}) = in.compiledDetails(i).records.(detailRecsFields{j})(:,filterCompiledTrDet);
                end
            end
        end
        out.compiledLUT = in.compiledLUT;
        
        in = out;
        out = struct;
        
        % now remove corrections
        filterCompiledTrRec = ~in.compiledTrialRecords.correctionTrial;
        fieldsCompiledTRs = fieldnames(in.compiledTrialRecords);
        for i = 1:length(fieldsCompiledTRs)
            out.compiledTrialRecords.(fieldsCompiledTRs{i}) = in.compiledTrialRecords.(fieldsCompiledTRs{i})(:,filterCompiledTrRec);
        end
        trialNumFilter = out.compiledTrialRecords.trialNumber;
        for i = 1:length(in.compiledDetails)
            filterCompiledTrDet = ismember(in.compiledDetails(i).trialNums,trialNumFilter);
            out.compiledDetails(i).className = in.compiledDetails(i).className;
            out.compiledDetails(i).trialNums = in.compiledDetails(i).trialNums(filterCompiledTrDet);
            if ~isempty(in.compiledDetails(i).records)
                detailRecsFields = fieldnames(in.compiledDetails(i).records);
                for j = 1:length(detailRecsFields)
                    out.compiledDetails(i).records.(detailRecsFields{j}) = in.compiledDetails(i).records.(detailRecsFields{j})(:,filterCompiledTrDet);
                end
            end
        end
        out.compiledLUT = in.compiledLUT;
    case 'removeTrialsLongerThan'
        
    otherwise
        error('unsupported filter');
end
end
