clc
% whichID = 1:db.numNeurons;
% params = [];
% params.includeNIDs = whichID;
% params.deleteDupIDs = false;
% 
% allF1 = getFacts(db,{{'sfGratings',{{'f1','f1SEM'},'all'}},params});



allF1.results = {};
allF1.nID = ID;
allF1.aInd = [];
allF1.subAInd = [];


temp.allF1 = allF1;
distToMonitor = 200;
monitorWidth = 405;
xPix = 1024;
mmPerPix = monitorWidth/xPix;
degPerPix = rad2deg(atan(1/distToMonitor))*mmPerPix;

algosToUse = {'fmincon-surroundMuchLargerThanCenter-subbalanced','fmincon-surroundMuchLargerThanCenter-balanced','fmincon-surroundMuchLargerThanCenter-suprabalanced'};
% algosToUse = {'fmincon-penalizeSimilarRadii'};
algosToUse = {'fmincon-useSensitivity'};
algosToUse = {'fmincon-useSensitivity-balanced','fmincon-useSensitivity-suprabalanced','fmincon-useSensitivity','fmincon-useSensitivity-subbalanced'};

fitOutput = struct;
for currAlgoNum = 1:length(algosToUse)
    currFitOutput = struct;
    currFitOutput.rc = [];
    currFitOutput.rs = [];
    currFitOutput.eta = [];
    currFitOutput.a = [];
    currFitOutput.fval = [];
    currFitOutput.flag = [];
    
    
    for i = 1:length(temp.allF1.results)
        exampleFs = 1./(temp.allF1.results{i}{1}{1}*degPerPix);
        exampleF1 = temp.allF1.results{i}{1}{2};
        exampleF1SEM = temp.allF1.results{i}{2}{2};
        sub = min(exampleF1);
        
        %     plot(exampleFs,exampleF1);
        in = struct;
        in.fs = exampleFs;
        in.f1 = exampleF1-sub;
        in.SEM = exampleF1SEM;
        in.model = '1D-DOG-useSensitivity-analytic';
        in.initialGuessMode = 'preset-1-useSensitivity-withJitter';
%         in.errorMode = 'penalize-(Ks-Kc)-(rs-rc)-rc-Kc-product';%'sumOfSquares','SEMWeightedSumOfSquares'
        in.errorMode = 'sumOfSquares';
        in.doExitCheck = true;
        in.searchAlgorithm = algosToUse{currAlgoNum};
        %'fmincon','fminsearch','fmincon-balanced','fmincon-suprabalanced','fmincon-subbalanced','fmincon-notsubbalanced','fmincon-surroundMuchLargerThanCenter'
        % 'fmincon-surroundMuchLargerThanCenter-subbalanced','fmincon-surroundMuchLargerThanCenter-balanced','fmincon-surroundMuchLargerThanCenter-suprabalanced'
        numRepeats = 100;
        for j = 1:numRepeats
            fprintf('%d of %d,%d:',i,length(temp.allF1.results),j);
            [out fval flag] = sfDOGFit(in);
            
            currFitOutput(i).rc(j) = out(1);
            currFitOutput(i).rs(j) = out(2);
            currFitOutput(i).kc(j) = out(3);
            currFitOutput(i).ks(j) = out(4);
            currFitOutput(i).fval(j) = fval;
            currFitOutput(i).flag(j) = flag;            
        end
        [junk which] = min([currFitOutput(i).fval]);
        rf = struct;
        rf.RC = currFitOutput(i).rc(which);
        rf.RS = currFitOutput(i).rs(which);
        rf.KC = currFitOutput(i).kc(which);
        rf.KS = currFitOutput(i).ks(which);
        rf.fval = currFitOutput(i).fval(which);
        rf.flag = currFitOutput(i).flag(which);
        
        currFitOutput(i).chosenRF = rf;
        
        stim.FS = in.fs;        
        stim.m = 0.5;
        stim.c = 1;

        rf.thetaMin = -10;
        rf.thetaMax = 10;
        rf.dTheta = 0.1;
        
        modelOut = rfModel(rf,stim,'1D-DOG-useSensitivity-analytic');
        modelF1 = squeeze(modelOut.f1);
        corrtemp = corrcoef(modelF1,in.f1);
        currFitOutput(i).chosenRF.quality = corrtemp(2);
    end
    fitOutput(currAlgoNum).algoName = algosToUse{currAlgoNum};
    fitOutput(currAlgoNum).fit = currFitOutput;
end