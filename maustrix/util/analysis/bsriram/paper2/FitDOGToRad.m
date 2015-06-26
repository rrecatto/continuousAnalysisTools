selectionParams.includeNIDs = 1:db.numNeurons;
[aIndsRad nIDsRad subAIndsRad] = db.selectIndexTool('radiiGratings',selectionParams);
[aIndsSF nIDsSF subAIndsSF] = db.selectIndexTool('sfGratings',selectionParams);

for whichID = 1:db.numNeurons
    
        % does it have both analyses?
        if ~ismember(whichID,nIDsRad)||~ismember(whichID,nIDsSF)
            continue
        end
        % else its okay to go ahead
        % get SFAnalysisNum(s)
        sfAnalyses = subAIndsSF(ismember(nIDsSF,whichID));
        radAnalyses = subAIndsRad(ismember(nIDsRad,whichID));
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
        SFForFit = logspace(log10(minmaxSF(1)),log10(minmaxSF(2)),50);
        SF_F1 = sfAnalysis.f1;

        
        for radAnalysisNum = 1:length(radAnalyses)
            radAnalysis = db.data{whichID}.analyses{radAnalyses(radAnalysisNum)};
            in.rs = radAnalysis.getRadii;            
            in.rad_f1 = radAnalysis.f1;
            in.sf = SFs;
            in.sf_f1 = SF_F1;
            
            in.searchAlgorithm = 'fminsearch';
            in.fs = radAnalysis.getSFs;
            in.model = '1D-DOG';
            in.errorMode = 'sumOfSquares';
            in.initialGuessMode = 'preset-1';
            in.doExitCheck = false;
            [out fval flag] = radDOGFit(in);
            loc = '/home/balaji/';
            filename = sprintf('n%d_a%d.mat',whichID,radAnalysisNum);
            save(fullfile(loc,filename),'in','out','fval','flag')
            clc;
        end

end
