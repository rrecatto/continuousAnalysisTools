#include <iostream>
#include <stdlib.h>
#include "param.h"
#include "Array.h"
#include <fstream>
#include <math.h>
#include <time.h>
#include <stdarg.h>
#include <vector>
#include <stdexcept>

void export_model(FILE *fp);	// Finish writing model to save it

void SetupParams(int argc, char **argv);
void Error(char *fmt, ...);
void Output(char *fmt, ...);
int irand(int min, int max);
FILE *fopen_safe(char *fname, char *mode);
void MatPrint(FILE *fp, float *Mat, int nRows, int nCols);
int Cholesky(float *m_In, float *m_Out, int D);
void TriSolve(float *M, float *x, float *Out, int D);
// void main(int argc, char **argv);

void SaveOutput(const Array<int> &OutputClass);

// PARAMETERS
extern char FileBase[];
extern int ElecNo;
extern int MinClusters; // Min and MaxClusters includes cluster 1, the noise cluster
extern int MaxClusters;
extern int MaxPossibleClusters; // splitting can't make it exceed this
extern int nStarts; // number of times to start count from each number of clusters
extern int RandomSeed;
extern char Debug;
extern int Verbose;
extern char UseFeatures[];
extern int DistDump;
extern float DistThresh; // Points with at least this much difference from 
			// the best do not get E-step recalculated - and that's most of them
extern int FullStepEvery;		// But there is always a full estep this every this many iterations
extern float ChangedThresh;	// Or if at least this fraction of points changed class last time
extern char Log;
extern char Screen;	// log output to screen
extern int MaxIter; // max interations
extern char StartCluFile[];

extern float PenaltyMix;	// amount of BIC to use as penalty, rather than AIC

// for saving model
class KlustaSave;	// forward declaration
extern KlustaSave kSv;	                // group info for describing best cluster
extern int fSaveModel;		// If TRUE, writes cluster info to .model file
extern FILE *pModelFile;		// Output file if fSaveModel

extern int SplitEvery; // allow cluster splitting every this many iterations

// GLOBAL VARIABLES
extern FILE *logfp, *Distfp;
extern float HugeScore;

extern const double PI;
