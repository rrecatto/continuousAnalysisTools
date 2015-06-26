Auto Gaussian Surface fit
---
2 routines to fit a 2D Gaussian to a surface:

zi = a*exp(-((xi-x0).^2/2/sigmax^2 + (yi-y0).^2/2/sigmay^2)) + b

The routines are automatic in the sense that they do not require the specification of starting guesses for the model parameters.

autoGaussianSurfML(xi,yi,zi) fits the model parameters through maximum likelihood(least-squares). It first evaluates the quality of the model at many possible values of the parameters then chooses the best set and refines it with lsqcurvefit.

autoGaussianSurfGS(xi,yi,zi) estimates the model parameters by specifying a Bayesian generative model for the data, then taking samples from the posterior ofthis model through Gibbs sampling. This method is insensitive to local minimain posterior and gives meaningful error bars (Bayesian confidence intervals)

mex slicesamplegauss.c to accelerate autoGaussianSurfGS.m (only tested on 64-bit Linux)

Author: Patrick Mineault
patrick DOT mineault AT gmail DOT com

History:
08-06-2011 - Included C file for Gibbs sampling version
           - Added some basic and not entirely reliable convergence checks for Gibbs sampling
18-05-2011 - Initial release
