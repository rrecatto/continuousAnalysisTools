//Inputs: x
//init_genrand(0);

#define MAXITERS (100)

char step_out = 1;

double logp, logup;

double* xl = mxMalloc(x_numel*sizeof(double));
double* xr = mxMalloc(x_numel*sizeof(double));
double* xp = mxMalloc(x_numel*sizeof(double));
double* w  = mxMalloc(x_numel*sizeof(double));

memcpy(xr,x,x_numel*sizeof(double));
memcpy(xl,x,x_numel*sizeof(double));
memcpy(xp,x,x_numel*sizeof(double));

for(int i = 0; i < x_numel; i++)
    w[i] = 10;

int k;

logp = thelogpdf(x);

double r;

for(int i = 0; i < nsamples; i++)
{
    logup = log(genrand_real3()) + logp;
    
    for(int j = 0; j < x_numel; j++)
    {
        xp[j] = x[j];
        
        r = genrand_real1();
        /*r = rand()/((double) RAND_MAX+1);*/
        xl[j] = x[j] - r*w[j];
        xr[j] = x[j] + (1-r)*w[j];

        if(step_out)
        {
            while(thelogpdf(xl) > logup)
                xl[j] -= w[j];
            while(thelogpdf(xr) > logup)
                xr[j] += w[j];
        }
        
        k = 0;
        while(1)
        {
            k++;
            xp[j] = genrand_real1()*(xr[j] - xl[j]) + xl[j];
            logp = thelogpdf(xp);
            
            
            
            if(logp > logup)
            {
                break;
            }
            else
            {
                if( xp[j] > x[j]) {
                    xr[j] = xp[j];
                } else if( xp[j] < x[j]) {
                    xl[j] = xp[j];
                } else {
                    mexErrMsgTxt("This is never supposed to happen");
                }
            }
            
            if(k > MAXITERS)
            {
                mexErrMsgTxt("Slice sampler did not converge after MAXITERS iterations");
            }
        }
        
        /*mexPrintf("%d\n",k);*/
        
        //Record
        x[j] = xp[j];xl[j] = x[j];xr[j] = x[j];
        samples[j+i*x_numel] = x[j];
    }
}

mxFree(xl);
mxFree(xr);
mxFree(xp);
mxFree(w);
mxFree(x);