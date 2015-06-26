function a = updateQuality(a)
if isempty(a.model)
    return;
end
for i = 1:length(a.model.DOGFit.fitValues)
    currModelSet = a.model.DOGFit.fitValues{i};
    currModelSet.quality = [];
    for j = 1:length(currModelSet.rc)
        rf.RC = currModelSet.rc(j);
        rf.RS = currModelSet.rs(j);
        rf.KC = currModelSet.kc(j);
        rf.KS = currModelSet.ks(j);
        
        rf.thetaMin = -10;
        rf.thetaMax = 10;
        rf.dTheta = 0.1;
        
        stim.FS = getSFs(a);
        stim.m = 0.5;
        stim.c = 1;
        
        modelOut = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
        modelF1 = squeeze(modelOut.f1);
        corrtemp = corrcoef(modelF1,nanmean(a.f1,1));
        currModelSet.quality(j) = corrtemp(2);
    end
    a.model.DOGFit.fitValues{i} = currModelSet;
end
end