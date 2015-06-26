#include "randmt.c"
#include <sys/types.h>
#include <time.h>

double *x;
double *xi, *yi, *zi;
double a,b,sigmasize;
double *rgx, *rgy;
double sigma;
mwSize zi_numel;
double nsamples;
mwSize xi_length, yi_length;

double thelogpdf(const double *w)
{
    double E;
    if(w[0] < rgx[0] || w[0] > rgx[1] || w[1] < rgy[0] || w[1] > rgy[1])
    {
        E = -DBL_MAX;
        return E;
    }
    E = 0;
    double pi;
    double c = -.5/pow(sigma,2);
    double tx = exp(-2.0*w[2])/2;
    double ty = exp(-2.0*w[3])/2;
    
    double xs;
    double *ys = mxMalloc(sizeof(double)*yi_length);
    
    for(int i = 0; i < yi_length; i++)
        ys[i] = a*exp(- (yi[i]-w[1])*(yi[i]-w[1])*ty);

    int id;
    for(int j = 0; j < xi_length; j++)
    {
        xs = exp(- (xi[j]-w[0])*(xi[j]-w[0])*tx);
        for(int i = 0; i < yi_length; i++)
        {
            pi = xs*ys[i] + b;
            id = i+j*yi_length;
            E += (zi[id] - pi)*(zi[id] - pi);
        }
    }
    
    E *= c;
    E -= .5/pow(sigmasize,2)*(w[2]*w[2] + w[3]*w[3]);
    mxFree(ys);
    return E;
}
