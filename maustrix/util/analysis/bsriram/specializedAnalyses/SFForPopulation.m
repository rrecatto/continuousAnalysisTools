whichIDFullyAcceptedNew = [1 3 4 5 6 9 14 16 17 23 30 31 32 33 43 45 46 48 49 57];
whichIDPartAcceptedNew = [7 11 12 19 22 26 27 29 34 35 36 37 41 42 51 56 58 61];
whichIDFullyAcceptedOld = [8 9 12 13 15 16 17]+63;
whichIDPartAcceptedOld = [2 10]+63;
goods = 26;
oks = 22;

whichIDFull = [whichIDFullyAcceptedNew whichIDFullyAcceptedOld];
whichIDPart = [whichIDPartAcceptedNew whichIDPartAcceptedOld];

selectionParams = [];
selectionParams.includeNIDs = [whichIDFull whichIDPart];
selectionParams.deleteDupIDs = false;

% selectionParams.includeNIDs = 1:db.numNeurons;
[aIndsSF nIDsSF subAIndsSF] = db.selectIndexTool('sfGratings',selectionParams);
clc;
out.nID = [];
out.subAInd = [];
out.SFs = {};
out.SFForInterp = {};
out.F1s = {};
out.minmaxSFs = {};
for whichID = 1:db.numNeurons
    % else its okay to go ahead
    % get SFAnalysisNum(s)
    if any(ismember(nIDsSF,whichID))
        sfAnalyses = subAIndsSF(ismember(nIDsSF,whichID));
        radSFs = nan(size(sfAnalyses));
        for anNum = 1:length(sfAnalyses)
            radSFs(anNum) = db.data{whichID}.analyses{sfAnalyses(anNum)}.stimInfo.stimulusDetails.radii;
        end
        sfAnalysisNum = sfAnalyses(radSFs>0.25);
        sfAnalysisNum = sfAnalysisNum(1); %in case there are multiple
        
        sfAnalysis = db.data{whichID}.analyses{sfAnalysisNum};
        convFactor = getDegPerPix(sfAnalysis);
        SFs = 1./(convFactor*(sfAnalysis.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
        minmaxSF = minmax(SFs);
        SFForInterp = logspace(log10(minmaxSF(1)),log10(minmaxSF(2)),50);
        SF_F1 = nanmean(sfAnalysis.f1,1);
        
        out.nID(end+1) = whichID;
        out.subAInd(end+1) = sfAnalysisNum;
        out.SFs{end+1} = SFs;
        out.minmaxSFs{end+1} = minmaxSF;
        out.F1s{end+1} = SF_F1;
    end
end

    SFForInterp = logspace(log10(out.minmaxSFs{1}(1)),log10(out.minmaxSFs{1}(2)),50);
    for i = 1:length(out.SFs)
        out.F1interp{i} = interp1(log10(out.SFs{i}),out.F1s{i},log10(SFForInterp));
        out.F1interpNorm{i} = (out.F1interp{i}-min(out.F1interp{i}))/diff(minmax(out.F1interp{i}));
    end
    
    figure;
    hold on;
    for i = 1:length(out.SFs)
        plot(log10(SFForInterp),out.F1interpNorm{i},'color',0.5*[1 1 1]);
    end
    F1InterpNorm = [];
    for i = 1:length(out.SFs)
        F1InterpNorm(i,:) = out.F1interpNorm{i};
    end
    
    plot(log10(SFForInterp),nanmean(F1InterpNorm,1),'color','k','linewidth',3);
