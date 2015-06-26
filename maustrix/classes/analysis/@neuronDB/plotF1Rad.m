function plotF1Rad(db,plotModelIfAvail,params)
if ~exist('plotModelIfAvail','var')||isempty(plotModelIfAvail)
    plotModelIfAvail = false;
end

if ~exist('params','var')||isempty(params)
    params = [];
    params.includeNIDs = 1:db.numNeurons;
    params.deleteDupIDs = false;
    params.subtractShuffleEstimate = true;
elseif isnumeric(params)
    temp = params;
    clear params
    params.includeNIDs = temp;
    params.deleteDupIDs = false;
    params.subtractShuffleEstimate = true;
end
[figs details]= db.plotByAnalysis({{'radiiGratings','f1'},params});
[nIDSF aIndSF subAIndSF] = selectIndexTool(db,'sfGratings');
keyboard
if plotModelIfAvail
    nID = details.nID;
    subAInd = details.subAInd;
    for i = 1:length(nID)
        figure(details.figForAn(i));axes(details.axForAn(i)); % find corresponding figure and axis
        
        s = db.data{nID(i)}.analyses{subAInd(i)};
        SFs = 1./(s.stimInfo.stimulusDetails.spatialFrequencies*getDegPerPix(s));
        rngSF = minmax(SFs);
        if ~isempty(s.model)
            modelSelectionParams.mode = 'supraBetterThanRestBy';
            modelSelectionParams.betterBy = 0.002;
            model = getPreferredModel(s.model.DOGFit,modelSelectionParams);
            stim.FS = logspace(log10(rngSF(1)),log10(rngSF(2)),100);
            stim.m = 0.5;
            stim.c = 1;
            out = rfModel(model.chosenRF,stim,model.model);
            f1Model = squeeze(out.f1);
            F1Shuffle = getShuffleEstimate(s);
            F1Shufflei = interp1(SFs,F1Shuffle,stim.FS);
            plot(log10(stim.FS),makerow(f1Model),'k','linewidth',3);
            modelRC = model;
            modelRC.chosenRF.KS = 0;
            modelRS = model;
            modelRS.chosenRF.KC = 0;
            outRC = rfModel(modelRC.chosenRF,stim,modelRC.model);
            outRS = rfModel(modelRS.chosenRF,stim,modelRS.model);
            plot(log10(stim.FS),makerow(squeeze(outRC.f1)),'r','linewidth',1);
            plot(log10(stim.FS),makerow(squeeze(outRS.f1)),'b','linewidth',1);
%             keyboard
%             plot(log10(stim.FS),makerow(f1Model)+min(F1Shufflei),'k','linewidth',3);
%             eta = calculateETA(model.chosenRF,model.model);
%             keyboard
            etaBal = calculateETA(s.model.DOGFit.fitValues{1}.chosenRF,s.model.DOGFit.fitParams{1}.model);
            etaSup = calculateETA(s.model.DOGFit.fitValues{2}.chosenRF,s.model.DOGFit.fitParams{2}.model);
            etaSub = calculateETA(s.model.DOGFit.fitValues{3}.chosenRF,s.model.DOGFit.fitParams{3}.model);
            str1 = {sprintf('rc=%2.2f',model.chosenRF.RC),sprintf('rs=%2.2f',model.chosenRF.RS)};
            str = {sprintf('etaBal=%2.2f',etaBal),sprintf('etaSup=%2.2f',etaSup),sprintf('etaSub=%2.2f',etaSub)};
            text(1,1,str,'units','normalized','horizontalalignment','right','verticalalignment','top');
            text(1,0.5,str1,'units','normalized','horizontalalignment','right','verticalalignment','top');
            
        end
    end
end
end

