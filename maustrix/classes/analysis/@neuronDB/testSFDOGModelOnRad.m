function out = testSFDOGModelOnRad(db)
out = {};
selectionParams.includeNIDs = 1:db.numNeurons;
[aIndsRad nIDsRad subAIndsRad] = db.selectIndexTool('radiiGratings',selectionParams);
[aIndsSF nIDsSF subAIndsSF] = db.selectIndexTool('sfGratings',selectionParams);
numAxesInFig = 0;
f = figure;
figList = [];
for whichID = 61:db.numNeurons
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
    sfAnalysisNum = sfAnalyses(radSFs>=0.5);sfAnalysisNum = sfAnalysisNum(1); %in case there are multiple
    
    % get model
    sfAnalysis = db.data{whichID}.analyses{sfAnalysisNum};
    fitDetails = sfAnalysis.model.DOGFit;
    convFactor = getDegPerPix(sfAnalysis);
    vals = 1./(convFactor*(sfAnalysis.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
    minmaxSF = minmax(vals);
    SFForFit = logspace(log10(minmaxSF(1)),log10(minmaxSF(2)),50);
    quals = [];
    whichBal= fitDetails.fitValues{1}.chosenRF;
    quals(end+1) = whichBal.quality;
    whichSupra = fitDetails.fitValues{2}.chosenRF;
    quals(end+1) = whichSupra.quality;
    whichSub = fitDetails.fitValues{3}.chosenRF;
    quals(end+1) = whichSub.quality;
    %     keyboard
    
    
    
    for radAnalysisNum = 1:length(radAnalyses)
        %         disp('hi');
        
        if numAxesInFig==1
            figList(end+1)= f;
            f = figure;
            numAxesInFig = 0;
        else
            figure(f);
        end
        
        radAnalysis = db.data{whichID}.analyses{radAnalyses(radAnalysisNum)};
        numAxesInFig = numAxesInFig+1;
        axRad = subplot(1,1,numAxesInFig);
        f1PlotParams.subtractShuffleEstimate = true;
        radAnalysis.plot2ax(axRad,{'f1',f1PlotParams}); hold on;
        
        f1Shuffled = radAnalysis.getShuffleEstimate;
        radii = getRadii(radAnalysis);
        stim.m = 0.5;stim.c = radAnalysis.stimInfo.stimulusDetails.contrasts;
        %         keyboard
        convFactor = getDegPerPix(radAnalysis);vals = 1./(convFactor*(radAnalysis.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
        stim.FS = vals;stim.maskRs = linspace(min(radii),max(radii),100);
        f1Shuffledi = interp1(radii,f1Shuffled,stim.maskRs);
        
        etaParams.mode = 'supraBetterThanRestBy'
        etaParams.betterBy= 0.02;
        prefModel = getPreferredModel(fitDetails,etaParams);
        prefETA = calculateETA(prefModel.chosenRF,'1D-DOG-useSensitivity-analytic');
        % balanced
        chosenRF = whichBal;
        rf = chosenRF;
        %         rf.thetaMin = min([-30,-3*rf.RS]);
        %         rf.thetaMax = max([+30,+3*rf.RS]);
        rf.thetaMin = -30;
        rf.thetaMax = 30;
        rf.dTheta = 0.01;
        if isfield(rf,'ETA'),rmfield(rf,'ETA'),end;
        %         keyboard
        outRad = radGratings(rf,stim,'1D-DOG');
        plot(stim.maskRs,makerow(outRad.f1),'k','linewidth',3)
        
        % supra
        chosenRF = whichSupra;
        rf = chosenRF;
        rf.thetaMin = -30;
        rf.thetaMax = 30;
        rf.dTheta = 0.01;
        if isfield(rf,'ETA'),rmfield(rf,'ETA'),end;
        outRad = radGratings(rf,stim,'1D-DOG');
        plot(stim.maskRs,makerow(outRad.f1),'b','linewidth',3)
        
        % balanced
        chosenRF = whichSub;
        rf = chosenRF;
        rf.thetaMin = -30;
        rf.thetaMax = 30;
        rf.dTheta = 0.01;
        if isfield(rf,'ETA'),rmfield(rf,'ETA'),end;
        outRad = radGratings(rf,stim,'1D-DOG');
        plot(stim.maskRs,makerow(outRad.f1),'r','linewidth',3)
        
        str1 = sprintf('eta = %2.2f', prefETA);
        str2 = sprintf('rc = %2.2f',prefModel.chosenRF.RC);
        str3 = getONOFF(db.data{whichID},{'wnAnalysis','ONOFFMaxDev'});
        
        text(1,1,{str1,str2,str3},'units','normalized','horizontalalignment','right','verticalalignment','top');
    end
end
out{end+1} = figList;
end
