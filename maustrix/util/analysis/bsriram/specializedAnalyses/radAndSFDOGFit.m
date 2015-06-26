function [out fval flag] = radAndSFDOGFit(in)
tic;
if ~exist('in','var')||isempty(in)
    temp = load('/home/balaji/radData.mat');
    in.fs = temp.fs;
    in.f1 = temp.f1;
    in.actualParam = temp.actualParam;
    in.model = '1D-DOG';
    in.initialGuessMode = 'preset';
    in.errorMode = 'sumOfSquares';
    in.searchAlgorithm = 'fminsearch';
end
switch in.searchAlgorithm
    case {'fminsearch','fmincon','fmincon-balanced','fmincon-suprabalanced','fmincon-subbalanced','fmincon-notsubbalanced',...
            'fmincon-surroundMuchLargerThanCenter','fmincon-surroundMuchLargerThanCenter-notsubbalanced','fmincon-surroundMuchLargerThanCenter-subbalanced',...
            'fmincon-surroundMuchLargerThanCenter-balanced','fmincon-surroundMuchLargerThanCenter-suprabalanced','fmincon-penalizeSimilarRadii'}
        % make initial guess
        initialGuessParams = struct;
        if isfield(in,'initialGuessParams')
            initialGuessParams = in.initialGuessParams;
        end
        [rcInit rsInit kcInit ksInit] = guessInitialValue(in.rs,in.fs,in.rad_f1,in.initialGuessMode,initialGuessParams);
        
        pInit = [rcInit rsInit kcInit ksInit]';
        fs = in.fs;
        rs = in.rs;
        f1Rad = nanmean(in.rad_f1,1);
        
        sfs = in.sf;
        f1sf = nanmean(in.sf_f1,1);
        
        dogErrorParams.errorMode = in.errorMode;
        dogErrorParams.model = in.model;
        if strcmp(dogErrorParams.errorMode,'SEMWeightedSumOfSquares')
            dogErrorParams.SEM = in.SEM;
        end
        
        switch in.searchAlgorithm
            case 'fminsearch'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6); % increase 'MaxFunEvals'
                [out fval flag] = fminsearch(@(p) dogError(p,rs,fs,f1Rad,sfs,f1sf,dogErrorParams),pInit,opt);
                % exit check
%                 if in.doExitCheck && out(2)<out(1) % rs<rc
%                     initCheckParams.rc = out(2);
%                     initCheckParams.rs = out(1);
%                     initCheckParams.eta = 1/out(3);
%                     in2 = in; % get the original data but modify it to fit these purposes
%                     in2.initialGuessMode = 'input';
%                     in2.initialGuessParams = initCheckParams;
%                     in2.doExitCheck = false;
%                     out = sfDogFit(in2);
%                 end
            case 'fmincon'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0];bineq = [0];
                lb = [0 0 0 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-balanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0];bineq = [0];
                Aeq = [0 0 1 0];beq = [1];
                lb = [0 0 0 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,Aeq,beq,lb,ub,[],opt);
            case 'fmincon-suprabalanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0;0 0 -1 0];bineq = [0;-1];
                lb = [0 0 0 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-subbalanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0;0 0 1 0];bineq = [0;1];
                lb = [0 0 0 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-notsubbalanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0];bineq = [0];
                lb = [0 0 1 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-surroundMuchLargerThanCenter'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1.1 -1 0 0];bineq = [0];% rs>1.1rc
                lb = [0 0 0 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-surroundMuchLargerThanCenter-notsubbalanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1.1 -1 0 0];bineq = [0];% rs>1.1rc
                lb = [0 0 1 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-surroundMuchLargerThanCenter-subbalanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1.5 -1 0 0;0 0 1 0];bineq = [0;1];% rs>1.1rc
                lb = [0 0 0 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-surroundMuchLargerThanCenter-balanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1.5 -1 0 0];bineq = [0];% rs>1.1rc
                Aeq = [0 0 1 0];beq = [1];
                lb = [0 0 0 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,Aeq,beq,lb,ub,[],opt);
            case 'fmincon-surroundMuchLargerThanCenter-suprabalanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1.5 -1 0 0;0 0 -1 0];bineq = [0;-1];% rs>1.1rc
                lb = [0 0 0 0]; ub = [30 60 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-penalizeSimilarRadii'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0];bineq = [0];% rs>1.1rc
                lb = [0 0 0 0]; ub = [10 30 inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            otherwise
                error('unknown method');
        end
    case {'fmincon-useSensitivity','fmincon-useSensitivity-balanced','fmincon-useSensitivity-subbalanced','fmincon-useSensitivity-suprabalanced'}
        initialGuessParams = struct;
        [rcInit rsInit kcInit ksInit] = guessInitialValue(in.fs,in.f1,in.initialGuessMode,initialGuessParams);
        pInit = [rcInit rsInit kcInit ksInit]';
        fs = in.fs;
        f1 = in.f1;
        dogErrorParams.errorMode = in.errorMode;
        dogErrorParams.model = in.model;
        if strcmp(dogErrorParams.errorMode,'SEMWeightedSumOfSquares')
            dogErrorParams.SEM = in.SEM;
        end
        switch in.searchAlgorithm
            case 'fmincon-useSensitivity'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0;0 0 -1 1];bineq = [0;0];% rc-rs<0; ks-kc<0
%                 lb = [0 0 0 0]; ub = [inf inf inf inf];
%                 lb = [0 5 0 0]; ub = [4 inf inf inf];
                lb = [0 in.constraints.rS_LB 0 0]; ub = [in.constraints.rC_UB inf inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-useSensitivity-subbalanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0;0 0 -1 1];bineq = [0;0];% rc-rs<0; ks-kc<0
%                 lb = [0 0 0 0]; ub = [inf inf inf inf];
%                 lb = [0 5 0 0]; ub = [4 inf inf inf];
                lb = [0 in.constraints.rS_LB 0 0]; ub = [in.constraints.rC_UB inf inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,@(p) ETALessThan1(p),opt);
            case 'fmincon-useSensitivity-balanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0;0 0 -1 1];bineq = [0;0];% rc-rs<0; ks-kc<0
%                 lb = [0 0 0 0]; ub = [inf inf inf inf];
%                 lb = [0 5 0 0]; ub = [4 inf inf inf];
                lb = [0 in.constraints.rS_LB 0 0]; ub = [in.constraints.rC_UB inf inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,@(p) ETAEquals1(p),opt);
            case 'fmincon-useSensitivity-suprabalanced'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [1 -1 0 0;0 0 -1 1];bineq = [0;0];% rc-rs<0; ks-kc<0
%                 lb = [0 0 0 0]; ub = [inf inf inf inf];
%                 lb = [0 5 0 0]; ub = [4 inf inf inf];
                lb = [0 in.constraints.rS_LB 0 0]; ub = [in.constraints.rC_UB inf inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,@(p) ETAGreaterThan1(p),opt);
            otherwise
                error('unknown method');
        end
    otherwise
        error('unknown method');
end
% fprintf('that took %2.2f seconds\n',toc);
end

function [c,ceq] = ETALessThan1(p)
ceq = [];
c = [p(4)*p(2)*p(2)/(p(3)*p(1)*p(1))-1];
end

function [c,ceq] = ETAEquals1(p)
ceq = [p(4)*p(2)*p(2)/(p(3)*p(1)*p(1))-1];
c = [];
end

function [c,ceq] = ETAGreaterThan1(p)
ceq = [];
c = [1-p(4)*p(2)*p(2)/(p(3)*p(1)*p(1))];
end


function [rc rs kc ks] = guessInitialValue(rs,fs,f1,mode,params)
if ~exist('params','var') || isempty(params)
    params = struct;
end
switch mode
    case 'preset-1'
        rc = 0.5;rs = 2;eta = 1.5; kc = 1; ks = 1/16;
        
        rf.RC = rc;rf.RS = rs;rf.ETA = eta;rf.KC = kc;rf.KS = ks; rf.thetaMin = -50;rf.thetaMax = 50;rf.dTheta = 0.1;
        
        stim.FS = fs;stim.m = 0.5;stim.c = 1;stim.maskRs = rs;
        
        temp = radGratings(rf,stim,'1D-DOG');
        A = max(f1(:))/max(temp.f1(:));
        kc = A*kc;
        ks = A*ks;
    case 'preset-1-withJitter'
        rc = 0.5*(1+0.1*randn);rs = 2*(1+0.1*randn);eta = 1.5*(1+0.1*randn);a = 1*(1+0.1*randn);
        
        rf.RC = rc;rf.RS = rs;rf.ETA = eta;rf.A = a;rf.thetaMin = -10;rf.thetaMax = 10;rf.dTheta = 0.1;
        
        stim.FS = fs;stim.m = 0.5;stim.c = 1;
        
        temp = rfModel(rf,stim,'1D-DOG');
        A = max(f1)/max(temp.f1);
end
end

function er = dogError(p,rs,fs,f1Rad,sfs,f1sf,params)
if ~exist('params','var')||isempty(params)
    params.errorMode = 'sumOfSquares';
end
switch params.model
    case '1D-DOG'
        rf.RC = p(1);
        rf.RS = p(2);
        rf.KC = p(3);
        rf.KS = p(4);
        
        rf.dTheta = 0.1;
        rf.thetaMin = -60;
        rf.thetaMax = 60;
        
        
        stim.FS = fs;
        stim.m = 0.5; stim.c = 1;stim.maskRs = rs;
        mode = '1D-DOG';
        
        f1RadFitOut = radGratings(rf,stim,mode);
        f1RadFit = squeeze(f1RadFitOut.f1);
        
        stim.FS = sfs;
        mode = '1D-DOG-useSensitivity';
        f1SFFitOut = rfModel(rf,stim,mode);
        f1SFFit = squeeze(f1SFFitOut.f1);
    otherwise
        error('unsupported model');
end

test = false;
if test && rand<0.1
    clf
    plot(fs,f1,'b',fs,squeeze(f1Fit),'r');
    drawnow
    pause(0.1);
end
switch params.errorMode
    case 'sumOfSquares'
        f1RadFit = makerow(f1RadFit);
        f1SFFit = makerow(f1SFFit);
        f1Fit = [f1RadFit f1SFFit];
        f1Rad = makerow(f1Rad);
        f1sf = makerow(f1sf);
        f1 = [f1Rad f1sf];
        er = sum((f1Fit-f1).^2)/sum(f1.^2);
    otherwise
        error('unknown mode');
end
        
end
