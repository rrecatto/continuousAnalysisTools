function out = fitHyperbolicRatio(in)
% The hyperbolic function uses three parameters: pMax, c50, n. The fitted
% function looks like so:
% 
% 2*(pHat - 0.5) = pMax*c^n/(c^n+c50^n)

c = in.cntr; pHat = in.pHat; pHat = (pHat-0.5)*2;
pMax_0 = 1; n_0 = 1; c50_0 = 0.1;

x_0 = [pMax_0 n_0 c50_0];

opt = optimset([],'TolX',1e-12,'Display','final-detailed','MaxFunEvals',10e6,'MaxIter',400,'TolFun',1e-15,'TypicalX',[0.5,2,0.1]); % increase 'MaxFunEvals'
params = struct;

% bound constraints for each component
lb = [0 0 0];
ub = [1 100 1];
Aineq = [-1 0 0;1 0 0;0 0 -1;0 0 1];
bineq = [0;1;0;1];
% x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options)
% model = fmincon (@(x) HyperbolicError(x,c,pHat,params),x_0,Aineq,bineq,[],[],[],[],[],opt);
try
[model, resnorm, residual, exitflag] = lsqnonlin(@(x) LSQFitFn(x,c,pHat,params),x_0,lb,ub,opt);
catch
    keyboard
end
out.pMax = model(1);
out.n = model(2);
out.c50 = model(3);

out.data.c = c;
out.data.pHat = pHat/2+0.5;

out.fittedModel.c = 0:0.01:1;
pModel = model(1)*((out.fittedModel.c).^model(2))./((model(3)^model(2))+((out.fittedModel.c).^model(2)));
out.fittedModel.pModel = pModel/2+0.5;

out.resnorm = resnorm;
out.residual = residual;
out.exitflag = exitflag;
temp = xcorr(out.data.pHat,out.fittedModel.pModel);
out.quality = temp(2);
plotOn = false;
if plotOn
    figure; axes;
    plot(out.data.c,out.data.pHat,'kd','markerfacecolor','k');
    hold on
    plot(out.fittedModel.c,out.fittedModel.pModel,'k--','linewidth',2);    
end

end

function er = HyperbolicError(x,c,pHat,params)
% params is not being used but may be later
pMax = x(1);
n = x(2);
c50 = x(3);

pModel = pMax*(c.^n)./((c50^n)+(c.^n));

er = sum((pModel-pHat).^2)/sum(pHat.^2);
end

function fn = LSQFitFn(x,c,pHat,params)
pMax = x(1);
n = x(2);
c50 = x(3);

fn = pMax*(c.^n)./((c50^n)+(c.^n))-pHat;
end