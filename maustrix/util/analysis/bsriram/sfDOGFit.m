function [out fval flag] = sfDOGFit(in)
tic;
if ~exist('in','var')||isempty(in)
    temp = load('/home/balaji/sfData.mat');
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
        [rcInit rsInit etaInit AInit] = guessInitialValue(in.fs,in.f1,in.initialGuessMode,initialGuessParams);
        
        pInit = [rcInit rsInit etaInit AInit]';
        fs = in.fs;
        f1 = in.f1;
        dogErrorParams.errorMode = in.errorMode;
        dogErrorParams.model = in.model;
        if strcmp(dogErrorParams.errorMode,'SEMWeightedSumOfSquares')
            dogErrorParams.SEM = in.SEM;
        end
        
        switch in.searchAlgorithm
            case 'fminsearch'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6); % increase 'MaxFunEvals'
                out = fminsearch(@(p) dogError(p,fs,f1,dogErrorParams),pInit,opt);
                % exit check
                if in.doExitCheck && out(2)<out(1) % rs<rc
                    initCheckParams.rc = out(2);
                    initCheckParams.rs = out(1);
                    initCheckParams.eta = 1/out(3);
                    in2 = in; % get the original data but modify it to fit these purposes
                    in2.initialGuessMode = 'input';
                    in2.initialGuessParams = initCheckParams;
                    in2.doExitCheck = false;
                    out = sfDogFit(in2);
                end
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
    case {'fmincon-useSensitivity-withConstraints','fmincon-useSensitivity-balanced-withConstraints','fmincon-useSensitivity-subbalanced-withConstraints','fmincon-useSensitivity-suprabalanced-withConstraints'}
        initialGuessParams.constraints = in.constraints;
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
            case 'fmincon-useSensitivity-withConstraints'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [in.minRadRatio -1 0 0;0 0 -1 1];bineq = [0;0];% rc-rs<0; ks-kc<0
                %                 lb = [0 0 0 0]; ub = [inf inf inf inf];
                %                 lb = [0 5 0 0]; ub = [4 inf inf inf];
                lb = [in.constraints.rC_LB in.constraints.rS_LB 0 0]; ub = [in.constraints.rC_UB in.constraints.rS_UB inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,[],opt);
            case 'fmincon-useSensitivity-subbalanced-withConstraints'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [in.minRadRatio -1 0 0;0 0 -1 1];bineq = [0;0];% rc-rs<0; ks-kc<0
                %                 lb = [0 0 0 0]; ub = [inf inf inf inf];
                %                 lb = [0 5 0 0]; ub = [4 inf inf inf];
                lb = [in.constraints.rC_LB in.constraints.rS_LB 0 0]; ub = [in.constraints.rC_UB in.constraints.rS_UB inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,@(p) ETALessThan1(p),opt);
            case 'fmincon-useSensitivity-balanced-withConstraints'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [in.minRadRatio -1 0 0;0 0 -1 1];bineq = [0;0];% rc-rs<0; ks-kc<0
                %                 lb = [0 0 0 0]; ub = [inf inf inf inf];
                %                 lb = [0 5 0 0]; ub = [4 inf inf inf];
                lb = [in.constraints.rC_LB in.constraints.rS_LB 0 0]; ub = [in.constraints.rC_UB in.constraints.rS_UB inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,@(p) ETAEquals1(p),opt);
            case 'fmincon-useSensitivity-suprabalanced-withConstraints'
                opt = optimset([],'TolX',1e-9,'Display','notify','MaxFunEvals',10e6,'Algorithm','interior-point'); % increase 'MaxFunEvals'
                Aineq = [in.minRadRatio -1 0 0;0 0 -1 1];bineq = [0;0];% rc-rs<0; ks-kc<0
                %                 lb = [0 0 0 0]; ub = [inf inf inf inf];
                %                 lb = [0 5 0 0]; ub = [4 inf inf inf];
                lb = [in.constraints.rC_LB in.constraints.rS_LB 0 0]; ub = [in.constraints.rC_UB in.constraints.rS_UB inf inf];
                [out fval flag] = fmincon(@(p) dogError(p,fs,f1,dogErrorParams),pInit,Aineq,bineq,[],[],lb,ub,@(p) ETAGreaterThan1(p),opt);
            otherwise
                error('unknown method');
        end
        % fprintf('that took %2.2f seconds\n',toc);
end
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


function [rc rs eta A] = guessInitialValue(fs,f1,mode,params)
if ~exist('params','var') || isempty(params)
    params = struct;
end
switch mode
    case 'preset-1-useSensitivity-fromConstraints'
        rc = params.constraints.rC_LB;
        rs = params.constraints.rS_UB;
        eta = 10^(rand-0.5); A = 10*rand;
    case 'preset-1'
        rc = 0.5;rs = 2;eta = 1.5;a = 1;
        
        rf.RC = rc;rf.RS = rs;rf.ETA = eta;rf.A = a;rf.thetaMin = -10;rf.thetaMax = 10;rf.dTheta = 0.1;
        
        stim.FS = fs;stim.m = 0.5;stim.c = 1;
        
        temp = rfModel(rf,stim,'1D-DOG');
        A = max(f1)/max(temp.f1);
    case 'preset-2'
        rc = 0.5;rs = 2;eta = 0.5;a = 1;
        
        rf.RC = rc;rf.RS = rs;rf.ETA = eta;rf.A = a;rf.thetaMin = -10;rf.thetaMax = 10;rf.dTheta = 0.1;
        
        stim.FS = fs;stim.m = 0.5;stim.c = 1;
        
        temp = rfModel(rf,stim,'1D-DOG');
        A = max(f1)/max(temp.f1);
    case 'preset-1-withJitter'
        rc = 0.5*(1+0.1*randn);rs = 2*(1+0.1*randn);eta = 1.5*(1+0.1*randn);a = 1*(1+0.1*randn);
        
        rf.RC = rc;rf.RS = rs;rf.ETA = eta;rf.A = a;rf.thetaMin = -10;rf.thetaMax = 10;rf.dTheta = 0.1;
        
        stim.FS = fs;stim.m = 0.5;stim.c = 1;
        
        temp = rfModel(rf,stim,'1D-DOG');
        A = max(f1)/max(temp.f1);
    case 'preset-2-withJitter'
        rc = 0.5*(1+0.1*randn);rs = 2*(1+0.1*randn);eta = 0.5*(1+0.1*randn);a = 1*(1+0.1*randn);
        
        rf.RC = rc;rf.RS = rs;rf.ETA = eta;rf.A = a;rf.thetaMin = -10;rf.thetaMax = 10;rf.dTheta = 0.1;
        
        stim.FS = fs;stim.m = 0.5;stim.c = 1;
        
        temp = rfModel(rf,stim,'1D-DOG');
        A = max(f1)/max(temp.f1);
    case 'intelligentGuessETA0-1'
        rc = 0.5;rs = 2;a = 1;
        
        rf.RC = rc;rf.RS = rs;rf.A = a;rf.thetaMin = -10;rf.thetaMax = 10;rf.dTheta = 0.1;
        
        stim.FS = fs;stim.m = 0.5;stim.c = 1;
        
        rf.ETA = 0.5;
        temp1 = rfModel(rf,stim,'1D-DOG'); % make initial guesses
        A1 = max(f1)/max(temp1.f1);
        p1 = [rc,rs,0.5,A1];er1 = dogError(p1,fs,f1);
        rf.A = A1;
        t1 = rfModel(rf,stim,'1D-DOG');
        
        rf.ETA = 1.5;
        temp2 = rfModel(rf,stim,'1D-DOG'); % make initial guesses
        A2 = max(f1)/max(temp2.f1);
        p2 = [rc,rs,0.5,A2];er2 = dogError(p2,fs,f1);
        rf.A = A2;
        t2 = rfModel(rf,stim,'1D-DOG');
        
        switch er1>=er2
            case true
                eta = 1.5;
                A = A2;
            case false
                eta = 0.5;
                A = A1;
        end
    case 'crazyAssAlgorithm'
        fs = in.fs;
        f1 = in.f1;
        f1 = f1(fs>0.01);
        fs = fs(fs>0.01);
        df1 = diff(f1);
        df1_shift = [df1(2:end) df1(end)];
        which = find(df1.*df1_shift<0);
        
        switch length(which)
            case 0
                isempty(which)
                which = ceil(length(fs)/2);
                which1 = which;
                which2 = whch;
            case 1
                which1 = which;
                which2 = which;
            otherwise
                which1 = which(1);
                which2 = which(2);
        end
        eta = 2;A = 1;
        rc = 1/(2*fs(which1));
        rs = 1/(2*fs(which2));
    case 'input'
        % use params
        rc = params.rc;rs = params.rs;eta = params.eta;
        if isfield('A',params)
            A = params.A;
            return;
        end
        a = 1;
        rf.RC = rc;rf.RS = rs;rf.A = a;rf.thetaMin = -10;rf.thetaMax = 10;rf.dTheta = 0.1;rf.ETA = eta;
        stim.FS = fs;stim.m = 0.5;stim.c = 1;
        temp = rfModel(rf,stim,'1D-DOG');
        A = max(f1)/max(squeeze(temp.f1));
    case 'preset-1-useSensitivity'
        rc = 3; rs = 6; eta = 10; A = 1;
    case 'preset-1-useSensitivity-withJitter'
        
        rc = 10*rand; rs = 20*rand; eta = 10^(rand-0.5); A = 10*rand;
end
end

function er = dogError(p,fs,f1,params)
if ~exist('params','var')||isempty(params)
    params.errorMode = 'sumOfSquares';
end
switch params.model
    case '1D-DOG'
        rf.RC = p(1);
        rf.RS = p(2);
        rf.ETA = p(3);
        rf.A = p(4);
        
        rf.dTheta = 0.1;
        rf.thetaMin = -10;
        rf.thetaMax = 10;
        
        
        stim.FS = fs;
        stim.m = 0.5; stim.c = 1;
        mode = '1D-DOG';
        
        f1FitOut = rfModel(rf,stim,mode);
        f1Fit = squeeze(f1FitOut.f1);
    case '1D-DOG-analytic'
        rc = p(1);
        rs = p(2);
        eta = p(3);
        a = p(4);
        
        f1Fit = abs(a*(eta*exp(-(pi*rc*fs).^2)-exp(-(pi*rs*fs).^2)));
    case '1D-DOG-useSensitivity-analytic'
        rc = p(1);
        rs = p(2);
        kc = p(3);
        ks = p(4);
        f1Fit = abs((kc*pi*rc^2*exp(-(pi*rc*fs).^2))-(ks*pi*rs^2*exp(-(pi*rs*fs).^2)));
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
        er = sum((makerow(f1Fit)-makerow(f1)).^2)/sum(f1.^2);
    case 'SEMWeightedSumOfSquares'
        normImportance = (f1./params.SEM)/(sum(f1./params.SEM));
        er = sum(((makerow(f1Fit)-makerow(f1)).^2).*makerow(normImportance))/sum(f1.^2);
    case 'penalizeEqualKs-KC'
        er = abs(1/(p(3)-p(4)))*sum((makerow(f1Fit)-makerow(f1)).^2)/sum(f1.^2);
    case 'penalize-(Ks-Kc)-(rs-rc)-rc-Kc-summed'
        %         keyboard
        er = abs(1/p(3))+abs(1/(p(1))) + abs(1/(p(2)-p(1))) + abs(1/(p(3)-p(4))) + sum((makerow(f1Fit)-makerow(f1)).^2)/sum(f1.^2);
    case 'penalize-(Ks-Kc)-(rs-rc)-rc-Kc-product'
        er = abs(1/p(3))*abs(1/(p(1)))*abs(1/(p(2)-p(1)))*abs(1/(p(3)-p(4)))*sum((makerow(f1Fit)-makerow(f1)).^2)/sum(f1.^2);
    otherwise
        error('unknown mode');
end

end
