function filterParams = setFilterParamsForAnalysisMode(analysisMode, trialNum, chunkInd, analysisBoundaryFile)
switch analysisMode
    case {'overwriteAll','onlyDetectAndSort'}
        filterParams.filterMode = 'thisTrialAndChunkOnly';
        filterParams.trialNum = trialNum;
        filterParams.chunkID = chunkInd;
    case {'onlySort','onlySortNoInspect'}
        filterParams.filterMode = 'theseTrialsOnly';
        temp = load(analysisBoundaryFile,'boundaryRange','maskInfo');
        trialRange = temp.boundaryRange(1):temp.boundaryRange(3);
        if temp.maskInfo.maskON
            switch temp.maskInfo.maskType
                case 'trialMask'
                    trialRange(ismember(trialRange,temp.maskInfo.maskRange))=[];
                otherwise
                    error('unsupported mask type');
            end
        end
        filterParams.trialRange = trialRange;
    case {'onlyInspect'}
        filterParams.filterMode = 'everythingAvailable';
    otherwise
        error('unknown analysisMode');
end