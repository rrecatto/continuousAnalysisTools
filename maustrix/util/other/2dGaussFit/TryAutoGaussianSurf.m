%Fit a Gaussian surface to data

[xi,yi] = meshgrid(-10:10,-20:20);
zi = exp(-(xi-3).^2/2/2^2-(yi+4).^2/2/3^2) + .4*randn(size(xi));
results = autoGaussianSurfML(xi,yi,zi);

subplot(1,3,1);imagesc(xi(:),yi(:),zi);
subplot(1,3,2);imagesc(xi(:),yi(:),results.G);

results0 = results;

%%
%Now estimate with a Gibbs sampler for better robustness/meaningful error

tic;results = autoGaussianSurfGS(xi,yi,zi);toc;
subplot(1,3,1);imagesc(xi(:),yi(:),zi);
subplot(1,3,2);imagesc(xi(:),yi(:),results.G);
A = [results.means.x0,results.means.x0-results.ci.x0(1),-results.means.x0+results.ci.x0(2);...
     results.means.y0,results.means.y0-results.ci.y0(1),-results.means.y0+results.ci.y0(2);...
     results.means.sigmax,results.means.sigmax-results.ci.sigmax(1),-results.means.sigmax+results.ci.sigmax(2);...
     results.means.sigmay,results.means.sigmay-results.ci.sigmay(1),-results.means.sigmay+results.ci.sigmay(2)];
subplot(1,3,3); 
errorbar((1:4)',A(:,1),A(:,2),A(:,3));
set(gca,'XTick',1:4);
set(gca,'XTickLabel',{'x0','y0','sigmax','sigmay'});
title('95% Bayesian confidence intervals for params');

%The results should be very similar b/w the ML and GS methods
%The real advantage of the GS method is the error bars.
[results0.x0 results.means.x0]
[results0.y0 results.means.y0]
[results0.sigmax results.means.sigmax]
[results0.sigmay results.means.sigmay]

%%
%If you have a mex compiler setup, you can accelerate the Gibbs sampler by
%mexing slicesamplegauss.c (only needs to be done once)
%Only tested on 64-bit Linux

%Note that the only thing this changes is increase the speed of the Gibbs 
%sampler. If it doesn't work for you can still use the pure .m code version
mex slicesamplegauss.c

%%

tic;results = autoGaussianSurfGS(xi,yi,zi);toc;
%several times faster here
