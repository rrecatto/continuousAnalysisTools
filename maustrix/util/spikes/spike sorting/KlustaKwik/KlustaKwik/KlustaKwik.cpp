// KlustaKwik.C
//
// Fast clustering using the CEM algorithm. 
// Author Ken Harris.
//
// 5/5/03:  Modifications to save the clustering models.  See
// export_model for format.
// Steve Gallant, Neural Arts, Boston.  
// Info:  sgallant@nauralarts.com, jkgoebel@neuralarts.com

#include "KlustaKwik.h"
#include "KK.h"
#include "KlustaSave.h"

using std::cout;
using std::endl;

// comment in for valgrind checks
// #define VALGRIND

const double PI=3.14159265358979323846;

char HelpString[] = "\
\
KlustaKwik\
\
Uses the CEM algorithm to do automatic clustering.\n\n\
";

// static initialization of globals
char FileBase[STRLEN] = "tetrode";
int ElecNo = 1;
int MinClusters = 2; // Min and MaxClusters includes cluster 1, the noise cluster
int MaxClusters = 10;
int MaxPossibleClusters = 100; // splitting can't make it exceed this
int nStarts = 1; // number of times to start count from each number of clusters
int RandomSeed = 1;
char Debug = 0;
int Verbose = 1;
char UseFeatures[STRLEN] = "11111111111100001";
int DistDump = 0;
float DistThresh = (float)log(1000); // Points with at least this much difference from 
			// the best do not get E-step recalculated - and that's most of them
int FullStepEvery = 10;		// But there is always a full estep this every this many iterations
float ChangedThresh = (float).05;	// Or if at least this fraction of points changed class last time
char Log = 1;
char Screen = 1;	// log output to screen
int MaxIter = 500; // max interations
char StartCluFile[STRLEN] = "";

float PenaltyMix = 0.0;	// amount of BIC to use as penalty, rather than AIC

// for saving model
int fSaveModel = 1;		// If TRUE, writes cluster info to .model file
FILE* pModelFile = NULL;

int SplitEvery=50; // allow cluster splitting every this many iterations
FILE* logfp = NULL;
FILE* Distfp = NULL;
KlustaSave kSv;

float HugeScore = (float)1e32;


void SetupParams(int argc, char **argv) {
	char fname[STRLEN];

	init_params(argc, argv);

	// PARAMETER DEFINITIONS GO HERE
	STRING_PARAM(FileBase);
	INT_PARAM(ElecNo);
	INT_PARAM(MinClusters);
	INT_PARAM(MaxClusters);
	INT_PARAM(MaxPossibleClusters);
    INT_PARAM(nStarts);
	INT_PARAM(RandomSeed);
	BOOLEAN_PARAM(Debug);
    INT_PARAM(Verbose);
	STRING_PARAM(UseFeatures);
    FLOAT_PARAM(PenaltyMix);
	INT_PARAM(DistDump);
	FLOAT_PARAM(DistThresh);
	INT_PARAM(FullStepEvery);
	FLOAT_PARAM(ChangedThresh);
	BOOLEAN_PARAM(Log);
	BOOLEAN_PARAM(Screen);
	INT_PARAM(MaxIter);
	STRING_PARAM(StartCluFile);
	INT_PARAM(fSaveModel);
	INT_PARAM(SplitEvery);
	// constrain PenaltyMix to between 0 and 1
	PenaltyMix = (float)PenaltyMix > 0.0 ? (PenaltyMix < 1.0 ? PenaltyMix : 1.0) : 0.0;

	if (argc<3) {
		fprintf(stderr, "Usage: KlustaKwik FileBase ElecNo [Arguments]\n\n");
		fprintf(stderr, "Default Parameters: \n");
		print_params(stderr);
		exit(1);
	}

	strcpy(FileBase, argv[1]);
	ElecNo = atoi(argv[2]);

	if (Screen) print_params(stdout);
	
	// open log file, if required
	if (Log) {
		sprintf(fname, "%s.klg.%d", FileBase, ElecNo);
		logfp = fopen_safe(fname, "w");
		print_params(logfp);
	}
}

// true if both floating values are close enough
bool same(const float v1, const float v2) {
	return (fabsf(v1 - v2) <= .0001);
}

// Print an error message and abort
void Error(char *fmt, ...) {
	va_list arg;
	
	va_start(arg, fmt);
	vfprintf(stderr, fmt, arg);
	va_end(arg);
	
	abort();
}

// Write to screen and log file
void Output(char *fmt, ...) {
	va_list arg;
	
	if (!Screen && !Log) return;
	va_start(arg, fmt);
	if (Screen) vprintf(fmt, arg);	
	if (Log) vfprintf(logfp, fmt, arg);
	va_end(arg);
}

/* integer random number between min and max*/
int irand(int min, int max)
{
	return (rand() % (max - min + 1) + min);
}

FILE *fopen_safe(char *fname, char *mode) {
	FILE *fp;
	
	fp = fopen(fname, mode);
	if (!fp) {
		fprintf(stderr, "Could not open file %s\n", fname);
		abort();
	}
	
	return fp;
}

// Print a matrix
void MatPrint(FILE *fp, float *Mat, int nRows, int nCols) {
	int i, j;
	
	for (i=0; i<nRows; i++) {
		for (j=0; j<nCols; j++) {
			fprintf(fp, "%.5g ", Mat[i*nCols + j]);
		}
		fprintf(fp, "\n");
	}
}





// Finish writing the model to file to save it.

///////////////////////////////////////////////////////////////
// Format
//
// line 1: root string for files (eg., "test"), number of dimensions (=nDims)
// line 2: feature 1 min and max values, feature 2 min and max values, ...
// 		(2 * nDims values)
// line 3: number of dimensions, number of clusters, and id tag for this model.
// line 4: cluster number (0) and weight for this cluster
// line 5: cluster 0 center (nDims values)
// line 6: cluster 0 Cholesky matrix row 1 (nDims values)
// line 7: cluster 0 Cholesky matrix row 2 (nDims values)
// ...
// line 5+nDims:  cluster 0 Cholesky matrix row nDims (nDims values)
// lines 4 - 5+nDims: corresponding lines for cluster 1
// ...
// corresponding lines for cluster nDims
///////////////////////////////////////////////////////////////

void export_model(FILE *fp) {
	int cc, c, i, j;

		// write the number of dimensions, number of clusters,
		// and id tags for this model
	fprintf(fp, "%d %d %d\n", kSv.nDimsBest, kSv.nBestClustersAlive,
			kSv.cEStepCallsSave);

	for (cc=0; cc<kSv.nBestClustersAlive; cc++) {

			// these arrays are stored contiguously
		fprintf(fp, "%d %f\n", cc, kSv.BestWeight[cc]);

		for (i=0; i<kSv.nDimsBest; i++) {
			fprintf(fp, "%f%c", 
				kSv.BestMean.m_Data[cc*kSv.nDimsBest + i],
				(i<kSv.nDimsBest-1)?' ':'\n'
			);
		}

			// and these arrays have gaps
		c = kSv.BestAliveIndex[cc];

		for (i=0; i<kSv.nDimsBest; i++) for (j=0; j<kSv.nDimsBest; j++) {

				// Lower triangular matrices; avoid
				// uninitialization messages from valgrind.

				// Also, fix up best Cholesky matrix.
			if (j>i) { 
				((*kSv.pBestChol)[c])[i*kSv.nDimsBest + j] = 0.0; 

			} else if (c==0) {
					// noise cluster:  use identity matrix
				((*kSv.pBestChol)[c])[i*kSv.nDimsBest + j] = 
					(float) i==j;
			} 

			fprintf(fp, "%f%c", 
				((*kSv.pBestChol)[c])[i*kSv.nDimsBest + j],
				(j<kSv.nDimsBest-1)?' ':'\n'
			);
		}
	}
}


// write output to .clu file - with 1 added to cluster numbers, and empties removed.
// Also, keep track of the best Cholesky matrices.
void SaveOutput(const Array<int> &OutputClass) {
	int p, c;
	char fname[STRLEN];
	FILE *fp;
	int MaxClass = 0;
	Array<int> cClustMembs(MaxPossibleClusters);
	Array<int> NewLabel(MaxPossibleClusters);

	// find non-empty clusters
	for(c=0;c<MaxPossibleClusters;c++) NewLabel[c] = cClustMembs[c] = 0;
		// count cluster members
	for(p=0; p<OutputClass.size(); p++) ++cClustMembs[OutputClass[p]];
	
	// make new cluster labels so we don't have empty ones
    NewLabel[0] = 1;
	MaxClass = 1;
	for(c=1;c<MaxPossibleClusters;c++) {
		if (cClustMembs[c] > 0) {
			MaxClass++;
			NewLabel[c] = MaxClass;
		}
	}
	
	// print file
	sprintf(fname, "%s.clu.%d", FileBase, ElecNo);
	fp = fopen_safe(fname, "w");
	
	fprintf(fp, "%d\n", MaxClass);

	for (p=0; p<OutputClass.size(); p++) fprintf(fp, "%d\n", NewLabel[OutputClass[p]]);
	
	fclose(fp);

	if (Debug) {
		cout << "SaveOutput:  cluster counts =";
		for (int i=0; i<MaxClass; i++)
			cout << cClustMembs[i] << " ";
		cout << endl;
	}
}

// Cholesky Decomposition
// In provides upper triangle of input matrix (In[i*D + j] >0 if j>=i);
// which is the top half of a symmetric matrix
// Out provides lower triange of output matrix (Out[i*D + j] >0 if j<=i);
// such that Out' * Out = In.
// D is number of dimensions
//
// returns 0 if OK, returns 1 if matrix is not positive definite
int Cholesky(float *m_In, float *m_Out, int D) {
	int i, j, k;
	float sum;
	
	// go from float * inputs to Array<float>'s
	// probably unnecessary if I knew C++ better
	Array<float> In(m_In, D*D);
	Array<float> Out(D*D);
	
	// empty output array
	for (i=0; i<D*D; i++) Out[i] = 0;
	
	// main bit
	for (i=0; i<D; i++) {
		for (j=i; j<D; j++) {	// j>=i
			sum = In[i*D + j];

			for (k=i-1; k>=0; k--) sum -= Out[i*D + k] * Out[j*D + k]; // i,j >= k
			if (i==j) {
				if (sum <=0) return(1); // Cholesky decomposition has failed
				Out[i*D + i] = (float)sqrt(sum);
			}
			else {
				Out[j*D + i] = sum/Out[i*D + i];
			}
		}
	}
	
	// copy output to output array - it sucks i know
	for(i=0; i<D*D; i++) m_Out[i] = Out[i];
	
	return 0; // for sucess
}

// Solve a set of linear equations M*Out = x.
				// comment below changed to "<=" from ">="
// Where M is lower triangular (M[i*D + j] >0 if j<=i);
// D is number of dimensions
void TriSolve(float *M, float *x, float *Out, int D) {
	int i, j;
	float sum;
	
	for(i=0; i<D; i++) {
		sum = x[i];
		for (j=i-1; j>=0; j--) sum -= M[i*D + j] * Out[j]; // j<i
		
//		for (pM=M + i*D + i-1, pOut = Out + i-1; pOut>=Out; pM--, pOut--) sum -= *pM * *pOut;
		Out[i] = sum / M[i*D + i];
	}
}



int main(int argc, char **argv) {
	float Score;
	float BestScore = HugeScore;
	int p, i;
	char fname[STRLEN];	// for fSaveModel 

	kSv.BestScoreSave = BestScore;

try {	// catch out of range subscripts and other goodies

	SetupParams(argc, argv);
        clock_t Clock0;
	KK K1; // main KK class, for all data
 	K1.penaltyMix = PenaltyMix;

        Clock0 = clock(); // start timer

		// If fSaveModel then open file to receive model

	if (fSaveModel) {
		sprintf(fname, "%s.model.%d", FileBase, ElecNo);
		pModelFile = fopen_safe(fname, "w");
	}
	

	K1.LoadData(); // load .fet file; also sets nDims through call to 
			// AllocateArrays
	
	kSv.BestWeight.SetSize(MaxPossibleClusters);	// for saving 
	kSv.BestMean.SetSize(MaxPossibleClusters*K1.nDims);	// for saving 

	// Seed random number generator
	srand(RandomSeed);
	
	// open distance dump file if required
	if (DistDump) Distfp = fopen("DISTDUMP", "w");	

    // start with provided file, if required
    if (*StartCluFile) {
        Output("Starting from cluster file %s\n", StartCluFile);
        BestScore = K1.CEM(StartCluFile);
		kSv.BestScoreSave = BestScore;
		Output("%d->%d Clusters: Score %f\n\n", K1.nStartingClusters,
				 K1.nClustersAlive, BestScore);
		for(p=0; p<K1.nPoints; p++) {
			K1.BestClass[p] = K1.Class[p];
		}
		SaveOutput(K1.BestClass);

		K1.SaveBestMeans();
	}


	// loop through numbers of clusters ...
	for(K1.nStartingClusters=MinClusters; K1.nStartingClusters<=MaxClusters; 
		  K1.nStartingClusters++) {
	  for(i=0; i<nStarts; i++) {
		// do CEM iteration
        Output("Starting from %d clusters...\n", K1.nStartingClusters);
		Score = K1.CEM();
		
		Output("%d->%d Clusters: Score %f, best is %f\n", K1.nStartingClusters, K1.nClustersAlive, Score, BestScore);
		
		if (Score < BestScore) {
			Output("THE BEST YET!\n");
			// New best classification found
			BestScore = Score;

			if (BestScore < kSv.BestScoreSave) {
				cout << "BestScoreSave updated from " 
					<< kSv.BestScoreSave << " to " 
					<< BestScore << endl;

				kSv.BestScoreSave = BestScore;
			}

			for(p=0; p<K1.nPoints; p++) K1.BestClass[p] = K1.Class[p];

			SaveOutput(K1.BestClass);

		}
		Output("\n");
	  }
	}
	
	// Ken agrees not needed, but harmless  
	SaveOutput(K1.BestClass);

	if (fSaveModel) export_model(pModelFile);
	
	Output("That took %f seconds.\n", (clock()-Clock0)/(float) CLOCKS_PER_SEC);
	
	if (DistDump) fclose(Distfp);

	if (fSaveModel) fclose(pModelFile);

}  // try
catch (...) {
	cerr << "unknown exception thrown\n" ;
}
	
	return 0;
}


