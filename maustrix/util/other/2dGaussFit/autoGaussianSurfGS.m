function [results] = autoGaussianSurfGS(xi,yi,zi,gsparams)
    %function [results] = autoGaussianSurfGS(xi,yi,zi,gsparams)
    %
    %Estimate a surface zi = a*exp(-((xi-x0).^2/2/sigmax^2 + ...
    %                                (yi-y0).^2/2/sigmay^2)) + b
    %
    %On the assumption of Gaussian noise through Gibbs sampling, a Markov 
    %chain Monte Carlo method.
    %
    %In maximum likelihood (least-squares) estimation, one attempts to
    %find the single set of parameters that minimizes an error function
    %(the sum of squares). This can work poorly when there are multiple
    %local minima. For example imagine the error function as a function of
    %x0 has a W-like shape. hen maximum likelihood will choose either the 
    %left or the right minimum of the error function, while intuitively 
    %"the best value" of x is /between/ the two minima. These issues are 
    %avoided in a fully Bayesian treatment of the model estimation problem. 
    %
    %robustGaussianSurfGS first calls robustGaussianSurfML to obtain a good
    %starting point for the subsequent algorithm. Samples from the posterior 
    %probability of the model parameters are constructed through Gibbs
    %sampling. The function then returns a point estimate of the model
    %parameters (the sample mean), the median, and 95% confidence intervals for 
    %them. The actual samples from the posterior are also returned for convergence
    %monitoring.
    %
    %Example:
    %
    %[xi,yi] = meshgrid(-10:10,-20:20);
    %zi = exp(-(xi-3).^2-(yi+4).^2) + randn(size(xi));
    %results = autoGaussianSurfGS(xi,yi,zi)
    %errorbar(results.means.x0,results.means.x0-results.ci.x0(1),-results.means.x0+results.ci.x0(2))
    %
    %Technical details:
    %zi ~ N(wi,sigma)
    %wi <-  a*exp(-((xi-x0).^2/2*exp(-2*logsigmax) + (yi-y0).^2/2*exp(-2*logsigmay))) + b
    %x0 ~ Uniform(min(xi),max(xi))
    %y0 ~ Uniform(min(yi),max(yi))
    %logsigmax, logsigmay ~ N(0,sigmasize)
    %a,b ~ N(0,sigmaab)
    %1/sigma^2 ~ Gamma(alpha,beta)
    %
    %x0,y0,logsigmax,logsigmay -> slice sampled
    %a,b,sigma -> sampled analytically
    %
    %sigmasize,sigmaab,alpha,beta are set to values corresponding to vague
    %priors
    %
    %gsparams (optional) is a struct specifying the params of the Gibbs
    %sampler, by default:
    %
    %       gsparams.niters: 1100
    %       gsparams.burnin:  200
    %       gsparams.thin:      6
    %       gsparams.slicesamplingiters: 5
    
    sigmasize = 1e3;
    sigmaab   = std(zi(:))*1e3;
    alpha     = sqrt(std(zi(:)))*1e-3;
    beta      = sqrt(std(zi(:)))*1e3;
    
    %Parameters of GS
    if nargin < 4
        niters = 1100;
        burnin =  200;
        thin   =    6;
        slicesamplingiters = 5;
    else
        niters = gsparams.niters;
        burnin = gsparams.burnin;
        thin = gsparams.thin;
        slicesamplingiters = gsparams.slicesamplingiters;
    end
    
    r1 = autoGaussianSurfML(xi,yi,zi);
    xir = xi(1,1:end);
    yir = yi(1:end,1);
    xi = xi(:);
    yi = yi(:);
    
    %Estimate the noise power
    sigma = std(r1.G(:)-zi(:));
    a  = r1.a;
    b  = r1.b;
    x0 = r1.x0;
    y0 = r1.y0;
    logsigmax = log(r1.sigmax);
    logsigmay = log(r1.sigmay);
    
    results.hist = zeros(7,niters);
    
    rgx = [min(xi),max(xi)];
    rgy = [min(yi),max(yi)];
    
    iscompiled = exist('slicesamplegauss') == 3;

    if iscompiled
        %Set the seed of the M twister
        os = RandStream.getGlobalStream().State;
        slicesamplegauss(os);
    end
    
    for ii = 1:niters
        %Sample x0, y0, sigmax, sigmay through slice sampling
        %In practice the collapsed version worked faster
        %{
        ai = a*exp(-(yi-y0).^2/2*exp(-2*logsigmay) - (xi).^2/2*exp(-2*logsigmax));
        minxi = min(xi(:));maxxi = max(xi(:));
        rnd = slicesample(x0,slicesamplingiters,'logpdf',@(w) x0logpdf(w,zi(:),ai,xi,logsigmax,sigma,b,minxi,maxxi));
        x0 = rnd(end);
        
        ai = a*exp(-(xi-x0).^2/2*exp(-2*logsigmax) - (yi).^2/2*exp(-2*logsigmay));
        minxi = min(yi(:));maxxi = max(yi(:));
        rnd = slicesample(y0,slicesamplingiters,'logpdf',@(w) x0logpdf(w,zi(:),ai,yi,logsigmay,sigma,b,minxi,maxxi));
        y0 = rnd(end);
        
        ai = a*exp(-(yi-y0).^2/2*exp(-2*logsigmay));
        dxi = (xi-x0).^2;
        rnd = slicesample(logsigmax,slicesamplingiters,'logpdf',@(w) logsigmaxlogpdf(w,zi(:),ai,dxi,sigma,b,sigmasize));
        logsigmax = rnd(end);
        
        ai = a*exp(-(xi-x0).^2/2*exp(-2*logsigmax));
        dxi = (yi-y0).^2;
        rnd = slicesample(logsigmay,slicesamplingiters,'logpdf',@(w) logsigmaxlogpdf(w,zi(:),ai,dxi,sigma,b,sigmasize));
        logsigmay = rnd(end);
        %}

        if iscompiled
            rnd = slicesamplegauss([x0;y0;logsigmax;logsigmay],xir,yir,zi(:),a,b,rgx,rgy,sigma,sigmasize,slicesamplingiters)';
            %Advance seed
            A = rand(5000,1);
        else
            rnd = slicesample([x0;y0;logsigmax;logsigmay],slicesamplingiters,'logpdf',@(w) thelogpdf(w,xir,yir,zi(:),a,b,sigmasize,rgx,rgy,sigma));
        end
        
        %rnd = slicesamplegauss([x0,y0
        x0 = rnd(end,1);y0 = rnd(end,2);logsigmax = rnd(end,3);logsigmay = rnd(end,4);
        
        G = exp(-(xi-x0).^2/2*exp(-2*logsigmax) -(yi-y0).^2/2*exp(-2*logsigmay));
        r2 = sum((zi(:)-G*a-b).^2);
        
        %Sample sigma analytically
        sigma = 1/sqrt(gamrnd(alpha+1/2*length(xi),beta/(1+1/2*beta*r2)));
        
        %Sample a, b analytically
        X = [G,ones(length(G),1)];
        H = 1/sigma^2*(X'*X) + 1/sigmaab^2*eye(2);
        Hi = inv(H); %Only do this since there are just two variables involved
        L = chol(Hi,'lower');
        sampleab = (Hi)*(X'*zi(:))/sigma^2 + L*randn(2,1);
        a = sampleab(1);
        b = sampleab(2);
        
        results.hist(:,ii) = [a;b;x0;y0;logsigmax;logsigmay;sigma];
    end
    results.hist = results.hist(:,burnin+1:thin:end);
    samples = results.hist';
    
    %Split into first 5th and last 5th
    se = samples(1:floor(end/5),:);
    le = samples(ceil(end*4/5:end),:);
    
    %Dumb convergence check for nonstationarity
    results.converged = 1;
    if any(mean(se)+.5*std(se) < mean(le)-.5*std(le)) || ...
       any(mean(se)-.5*std(se) > mean(le)+.5*std(le))
        warning('agsgs:BadConvergence','Markov chain does not appear to have converged to its stationary distro; inspect results.hist manually');
        results.converged = 0;
    end
    
    %Second conv. check for long correlation times
    sc = bsxfun(@minus,samples,mean(samples));
    
    for ii = 1:7
        xc  = xcorr(sc(:,ii),50);
        %Shuffle
        xcs = xcorr(sc(randperm(size(sc,1)),ii),50);
        
        bl = std(xcs(31:50));
        
        if any(abs(xc(1:46)) > 3*bl)
            warning('agsgs:LongCorrTimes','Markov chain for parameter %d has long correlation times; inspect results.hist(%d,:) manually', ii,ii);
            results.converged = 0;
        end
    end
    
    samples(:,[5,6]) = exp(samples(:,[5,6]));
    ms = mean(samples);
    stds = std(samples);
    orderstats = quantile(samples,[0.05,.5,.95])';
    
    [results.means.a,results.means.b,results.means.x0,...
     results.means.y0,results.means.sigmax,results.means.sigmay,...
     results.means.sigma] = list(ms);

    [results.stds.a,results.stds.b,results.stds.x0,...
     results.stds.y0,results.stds.sigmax,results.stds.sigmay,...
     results.stds.sigma] = list(stds);
 
    [results.meds.a,results.meds.b,results.meds.x0,...
     results.meds.y0,results.meds.sigmax,results.meds.sigmay,...
     results.meds.sigma] = list(orderstats(:,2));
    A = mat2cell(orderstats(:,[1,3]),ones(7,1),2);
    [results.ci.a,results.ci.b,results.ci.x0,...
     results.ci.y0,results.ci.sigmax,results.ci.sigmay,...
     results.ci.sigma] = deal(A{:});
 
    results.G = results.means.a*exp(-(xi-results.means.x0).^2/2/results.means.sigmax^2 -(yi-results.means.y0).^2/2/results.means.sigmay^2) + ...
                results.means.b;
    results.G = reshape(results.G,size(zi));
end

%{
function [E] = x0logpdf(w,zi,ai,xi,logsigmax,sigma,b,minxi,maxxi)

    pi = ai.*exp(-(w^2-2*w*xi)/2*exp(-2*logsigmax));
    E = -.5/sigma^2*sum((zi - pi - b).^2);
end

function [E] = logsigmaxlogpdf(w,zi,ai,dxi,sigma,b,sigmasize)
    pi = ai.*exp(-dxi/2*exp(-2*w));
    E = -.5/sigma^2*sum((zi - pi - b).^2) - .5/sigmasize^2*sum(w^2);
end
%}
function [E] = thelogpdf(w,xir,yir,zi,a,b,sigmasize,rgx,rgy,sigma)
    if w(1) < rgx(1) || w(1) > rgx(2) || w(2) < rgy(1) || w(2) > rgy(2)
        E = -Inf;
        return;
    end
    pi = a*exp(-(yir-w(2)).^2/2*exp(-2*w(4)))*exp(-(xir-w(1)).^2/2*exp(-2*w(3)) );
    E = -.5/sigma^2*sum((zi - b - pi(:)).^2) - .5/sigmasize^2*sum(w(3:4).^2);
end

function varargout = list(x)
% return matrix elements as separate output arguments
% example: [a1,a2,a3,a4] = list(1:4)
varargout = num2cell(x);
end
