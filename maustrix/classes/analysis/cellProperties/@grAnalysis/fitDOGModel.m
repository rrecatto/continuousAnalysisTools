function s = fitDOGModel(s,constraints)
if ~exist('constraints','var')||isempty(constraints)
    rC_UB = Inf;
    rS_LB = 0;
    constraints.rC_UB = rC_UB;
    constraints.rS_LB = rS_LB;
end
% only fit for SFGratings
if ~strcmp(getType(s),'sfGratings')
    error('can only run this model on an SF gratings analysis');
end
% obtain the f1 and the fs
F1 = nanmean(s.f1,1);
F1SEM = s.f1SEM;
conversion = getDegPerPix(s); % degrees/pix
FS = 1./(conversion*(s.stimInfo.stimulusDetails.spatialFrequencies)); % cpd
% keyboard
minF1 = min(F1);
F1Shuff = getShuffleEstimate(s);
% algosToUse = {'fmincon-useSensitivity-balanced','fmincon-useSensitivity-suprabalanced','fmincon-useSensitivity-subbalanced'};
algosToUse = {'fmincon-useSensitivity-withConstraintOnSensitivity-bal','fmincon-useSensitivity-withConstraintOnSensitivity-sup',...
    'fmincon-useSensitivity-withConstraintOnSensitivity-sub'};
s.model.DOGFit.fitParams = {};
s.model.DOGFit.fitValues = {};

for currAlgoNum = 1:length(algosToUse)
    currFitOutput = struct;
    currFitOutput.rc = [];
    currFitOutput.rs = [];
    currFitOutput.eta = [];
    currFitOutput.a = [];
    currFitOutput.fval = [];
    currFitOutput.flag = [];
    currFitOutput.quality = [];

    in = struct;
    in.fs = FS;
    minFS = min(FS);
    maxFS = max(FS);
    constraints.rS_UB = 2/minFS;
    constraints.rC_LB = (1/(4*maxFS));
    in.f1 = F1-F1Shuff; % F1Shuff,minF1
    in.SEM = F1SEM;
    
    
    in.model = '1D-DOG-useSensitivity-analytic';
    in.initialGuessMode = 'preset-1-useSensitivity-useConstraints';%'preset-1-useSensitivity-useConstraints';%'preset-1-useSensitivity-withJitter'
    in.errorMode = 'sumOfSquares';
    in.doExitCheck = true;
    in.searchAlgorithm = algosToUse{currAlgoNum};
    in.constraints = constraints;
    in.minRadRatio = 1.5;
    in.constraintRatio = 2;
    numRepeats = 200;

    currFitParams.model = in.model;
    currFitParams.initialGuessMode = in.initialGuessMode;
    currFitParams.errorMode = in.errorMode;
    currFitParams.doExitCheck = in.doExitCheck;
    currFitParams.searchAlgorithm = in.searchAlgorithm;
    currFitParams.numRepeats = numRepeats;
    currFitParams.constraints = constraints;
    
    for j = 1:numRepeats
%         fprintf('repeat %d of %d:',j,numRepeats);
        [out fval flag] = sfDOGFit(in); % usually gives wrong answer
        
        currFitOutput.rc(j) = out(1);
        currFitOutput.rs(j) = out(2);
        currFitOutput.kc(j) = out(3);
        currFitOutput.ks(j) = out(4);
        currFitOutput.fval(j) = fval;
        currFitOutput.flag(j) = flag;
        
        rfCurr = struct;
        rfCurr.RC = currFitOutput.rc(j);
        rfCurr.RS = currFitOutput.rs(j);
        rfCurr.KC = currFitOutput.kc(j);
        rfCurr.KS = currFitOutput.ks(j);
        rfCurr.thetaMin = -10;
        rfCurr.thetaMax = 10;
        rfCurr.dTheta = 0.1;
        
        stimCurr.FS = in.fs;
        stimCurr.m = 0.5;
        stimCurr.c = 1;
        
        modelOutCurr = rfModel(rfCurr,stimCurr,'1D-DOG-useSensitivity-analytic');
        modelF1Curr = squeeze(modelOutCurr.f1);
        corrtempCurr = corrcoef(modelF1Curr,in.f1);
        currFitOutput.quality(j) = corrtempCurr(2);
        
    end
    [junk which] = min([currFitOutput.fval]);
    
    rf = struct;
    rf.RC = currFitOutput.rc(which);
    rf.RS = currFitOutput.rs(which);
    rf.KC = currFitOutput.kc(which);
    rf.KS = currFitOutput.ks(which);
    rf.fval = currFitOutput.fval(which);
    rf.flag = currFitOutput.flag(which);
    
    currFitOutput.chosenRF = rf;
    
    stim.FS = in.fs;%in.fs;%logspace(log10(min(in.fs)),log10(max(in.fs)),100)
    stim.m = 0.5;
    stim.c = 1;
    
    rf.thetaMin = -10;
    rf.thetaMax = 10;
    rf.dTheta = 0.1;
    
    modelOut = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
    modelF1 = squeeze(modelOut.f1);
    
    recheck = false; %false;
    if recheck
        
        whichSFRSLimit = find(diff(fliplr(modelF1))<0,1,'first');
        interpSFs = fliplr(stim.FS);
        RSLimSF = interpSFs(whichSFRSLimit);
        
        % RSLimSF is the lower bound for 1/2*RS
        constraints.rS_LB = 1/(4*RSLimSF); % but giving some leeway just in case
        in.constraints = constraints;
        currFitParams.constraints = constraints;
        
        % now do the whole rigamarole with the new constraints
        for j = 1:numRepeats
%         fprintf('repeat %d of %d:',j,numRepeats);
        [out fval flag] = sfDOGFit(in); % usually gives wrong answer
        
        currFitOutput.rc(j) = out(1);
        currFitOutput.rs(j) = out(2);
        currFitOutput.kc(j) = out(3);
        currFitOutput.ks(j) = out(4);
        currFitOutput.fval(j) = fval;
        currFitOutput.flag(j) = flag;
        
        rfCurr = struct;
        rfCurr.RC = currFitOutput.rc(j);
        rfCurr.RS = currFitOutput.rs(j);
        rfCurr.KC = currFitOutput.kc(j);
        rfCurr.KS = currFitOutput.ks(j);
        rfCurr.thetaMin = -10;
        rfCurr.thetaMax = 10;
        rfCurr.dTheta = 0.1;
        
        stimCurr.FS = in.fs;
        stimCurr.m = 0.5;
        stimCurr.c = 1;
        
        modelOutCurr = rfModel(rfCurr,stimCurr,'1D-DOG-useSensitivity-analytic');
        modelF1Curr = squeeze(modelOutCurr.f1);
        corrtempCurr = corrcoef(modelF1Curr,in.f1);
        currFitOutput.quality(j) = corrtempCurr(2);
        
        end
        [junk which] = min([currFitOutput.fval]);
        
        rf = struct;
        rf.RC = currFitOutput.rc(which);
        rf.RS = currFitOutput.rs(which);
        rf.KC = currFitOutput.kc(which);
        rf.KS = currFitOutput.ks(which);
        rf.fval = currFitOutput.fval(which);
        rf.flag = currFitOutput.flag(which);
        
        currFitOutput.chosenRF = rf;
        
        stim.FS = in.fs;
        stim.m = 0.5;
        stim.c = 1;
        
        rf.thetaMin = -10;
        rf.thetaMax = 10;
        rf.dTheta = 0.1;
        
        modelOut = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
        modelF1 = squeeze(modelOut.f1);        
    end
    
    corrtemp = corrcoef(modelF1,in.f1);
    currFitOutput.chosenRF.quality = corrtemp(2);
    
    s.model.DOGFit.fitParams{currAlgoNum} = currFitParams;
    s.model.DOGFit.fitValues{currAlgoNum} = currFitOutput;
end


end