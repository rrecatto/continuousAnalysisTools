//
// KK clustering engine
//
#include "KK.h"
#include "KlustaKwik.h"
#include "KlustaSave.h"

using std::cout;
using std::endl;

// Sets storage for KK class.  Needs to have nDims and nPoints defined
void KK::AllocateArrays() {

	nDims2 = nDims*nDims;	

	FullStep = 1;		// avoid valgrind message about uninitialized if
    NoisePoint = 1;

	// Set sizes for arrays	
	Data.SetSize(nPoints * nDims);
	Weight.SetSize(MaxPossibleClusters);
	Mean.SetSize(MaxPossibleClusters*nDims);
	Cov.SetSize(MaxPossibleClusters*nDims2);

	LogP.SetSize(MaxPossibleClusters*nPoints);
		// initialize for valgrind 
	for (int c=0; c<MaxPossibleClusters; c++)
		for (int p=0; p<nPoints; p++)
			LogP[c*nPoints + p] = 0.0;

	Class.SetSize(nPoints);
	OldClass.SetSize(nPoints);
	Class2.SetSize(nPoints);
	BestClass.SetSize(nPoints);
	ClassAlive.SetSize(MaxPossibleClusters);
    AliveIndex.SetSize(MaxPossibleClusters);
}

// Allocates two vectors of Cholesky matrices, one per cluster for each
// vector.  Needed to be able to write out the best matrix upon exiting.
void KK::AlocateCholeskyVecs() {

		// (*kSv.pChol)[c] is the Cholesky matrix for cluster c
	kSv.pChol = new vector< Array<float> > (MaxPossibleClusters, nDims2);
	kSv.pBestChol = new vector< Array<float> > (MaxPossibleClusters, nDims2);

		// save space for BestAliveIndex 
	kSv.BestAliveIndex.reserve(MaxPossibleClusters);

}


// recompute index of alive clusters (including 0, the noise cluster)
// should be called after anything that changes ClassAlive
void KK::Reindex() {
    int c;

    AliveIndex[0] = 0;
    nClustersAlive=1;
    for(c=1;c<MaxPossibleClusters;c++) {
        if (ClassAlive[c]) {
            AliveIndex[nClustersAlive] = c;
            nClustersAlive++;
        }
    }
}

// Loads in Fet file.  Also allocates storage for other arrays
// Normalizes each feature into range [0,1] using min and max for each
// feature.
void KK::LoadData() {
	char fname[STRLEN];
	int p, i, j;
	int nFeatures; // not the same as nDims! we don't use all features.
	FILE *fp;
	int status;
	float val;
	int UseLen;
	float max, min;
	
	// open file
	sprintf(fname, "%s.fet.%d", FileBase, ElecNo);
	fp = fopen_safe(fname, "r");


	// count lines;
	enum { INLINE, FIRST_DELIM } scst = INLINE;
	
	nPoints = -1; // subtract 1 because first line is number of features
	char ch;
	char delim;
	do {
	  ch = fgetc(fp);
	  bool isDelim = (ch == '\n' || ch == '\r');
	  bool isEof = (ch == EOF);
	  switch (scst) {
	   case INLINE:
	    if (isDelim) {
	      scst = FIRST_DELIM;
	      delim = ch;
	    } else if (isEof) {
	      nPoints++;
	    }
	    break;
	   case FIRST_DELIM:
	    if (!isDelim || delim == ch) {
	      nPoints++;
	      scst = INLINE;
	    }
	    break;
	  }
	} while (ch != EOF);

	// rewind file
	fseek(fp, 0, SEEK_SET);
	
	// read in number of features
	fscanf(fp, "%d", &nFeatures);

	cout << "nFeatures=" << nFeatures << endl;

	// calculate number of dimensions
	// permitting use of keyword "all" for UseFeatures
	if (strcmp(UseFeatures, "all") == 0) {
		if (nFeatures >= STRLEN)
			Error("Too many features for UseFeatures");

		for (int i=0; i<nFeatures; i++) UseFeatures[i] = '1';

		UseFeatures[nFeatures] = '\0';
	}

	UseLen = strlen(UseFeatures);
	nDims=0;
	for(i=0; i<nFeatures; i++) {
		nDims += (i<UseLen && UseFeatures[i]=='1');
	}

		// Saving final model?

	if (fSaveModel) {
		kSv.FileBase = FileBase;
		kSv.nDims = nDims;

		fprintf(pModelFile, "%s %d\n", FileBase, kSv.nDims);
	}

	
	AllocateArrays();

	// keep after AllocateArrays, which sets nDims2
	AlocateCholeskyVecs();
	
	// load data
	for (p=0; p<nPoints; p++) {
		j=0;
		for(i=0; i<nFeatures; i++) {
			status = fscanf(fp, "%f", &val);
			if (status==EOF) Error("Error reading feature file");
			
			if (i<UseLen && UseFeatures[i]=='1') {
				Data[p*nDims + j] = val;
				j++;
			}
		}
	}
	if ((status = fscanf(fp, "%f", &val)) != EOF) {
		Error("Mismatch error reading feture file");
	}
	
	fclose(fp);
	
	// normalize data so that range is 0 to 1: This is useful in case of v. large inputs
	for(i=0; i<nDims; i++) {
		
		//calculate min and max
		min = HugeScore; max= -HugeScore;	// changed from =-
		for(p=0; p<nPoints; p++) {
			val = Data[p*nDims + i];
			if (val > max) max = val;
			if (val < min) min = val;
		}

			// Save min and max value for each feature
		if (fSaveModel) {
			kSv.dataMin.push_back(min);
			kSv.dataMax.push_back(max);

			fprintf(pModelFile, "%f %f%c", kSv.dataMin.back(), 
				kSv.dataMax.back(), 
				(i < nDims-1) ? ' ':'\n');

			if (Debug) {
				cout << "LoadData[" << i << "]:  min=" << min 
					<< ", kSv.dataMin.back()=" 
					<< kSv.dataMin.back()
					<< ";  max=" << max 
					<< ", kSv.dataMax.back()=" 
					<< kSv.dataMax.back()
					<< endl;
			}
		}

		
		// now normalize
		for(p=0; p<nPoints; p++) Data[p*nDims+i] = (Data[p*nDims+i] - min) / (max-min);
	}
		
	Output("Loaded %d data points of dimension %d.\n", nPoints, nDims);
}



// Penalty(nAlive) returns the complexity penalty for that many clusters
// bearing in mind that cluster 0 has no free params except p.
float KK::Penalty(int n) {
		int nParams;

        if(n==1) return 0;
		
		 nParams = (nDims*(nDims+1)/2 + nDims + 1)*(n-1); // each has cov, mean, &p

		// Use AIC
		//return nParams*2;
				
		// BIC is too harsh
		//return nParams*log(nPoints)/2;
 		
 		// return mixture of AIC and BIC
 		return (float)(1.0 - penaltyMix) * nParams * 2 + penaltyMix * (nParams * log(nPoints)/2);
}

// M-step: Calculate mean, cov, and weight for each living class
// also deletes any classes with less points than nDim
void KK::MStep() {
	int p, c, cc, i, j;
	Array<int> nClassMembers(MaxPossibleClusters);
	Array<float> Vec2Mean(nDims);
	
	// clear arrays
	for(c=0; c<MaxPossibleClusters; c++) {
		nClassMembers[c] = 0;
		for(i=0; i<nDims; i++) Mean[c*nDims + i] = 0;

			// leaves lower triangles uninitialized
		for(i=0; i<nDims; i++) for(j=i; j<nDims; j++) {
			Cov[c*nDims2 + i*nDims + j] = 0;
		}

			// For consistancy and valgrind, initialize the rest.
			// Might be removed for more speed.
		for(i=0; i<nDims; i++) for(j=0; j<i; j++) {
			Cov[c*nDims2 + i*nDims + j] = 0;
		}
	}
	
	// Accumulate total number of points in each class
	for (p=0; p<nPoints; p++) nClassMembers[Class[p]]++;

    // check for any dead classes
    for (cc=0; cc<nClustersAlive; cc++) {
        c = AliveIndex[cc];
		// bug fixed:  "&" replaced by "&&"
        if ((c>0) && (nClassMembers[c]<=nDims)) {
            ClassAlive[c]=0;
        	Output("Deleted class %d: not enough members\n", c);
        }
    }
    Reindex();
	

	// Normalize by total number of points to give class weight
	// Also check for dead classes
    for (cc=0; cc<nClustersAlive; cc++) {
        c = AliveIndex[cc];
        // add "noise point" to make sure Weight for noise cluster never gets to zero
        if(c==0) {
      		Weight[c] = ((float)nClassMembers[c]+NoisePoint) / (nPoints+NoisePoint);
        } else {
        	Weight[c] = ((float)nClassMembers[c]) / (nPoints+NoisePoint);
        }
	}
    Reindex();

	// Accumulate sums for mean caculation
	for (p=0; p<nPoints; p++) {
		c = Class[p];
		for(i=0; i<nDims; i++) {
			Mean[c*nDims + i] += Data[p*nDims + i];
		}
	}

	// and normalize
    for (cc=0; cc<nClustersAlive; cc++) {
        c = AliveIndex[cc];
		if (nClassMembers[c]==0) continue; // avoid divide by 0
		for (i=0; i<nDims; i++) Mean[c*nDims + i] /= nClassMembers[c];
	}
	
	// Accumulate sums for covariance calculation
	for (p=0; p<nPoints; p++) {
	
		c = Class[p];
		
		// calculate distance from mean
		for(i=0; i<nDims; i++) Vec2Mean[i] = Data[p*nDims + i] - Mean[c*nDims + i];
		
		for(i=0; i<nDims; i++) for(j=i; j<nDims; j++) {
			Cov[c*nDims2 + i*nDims + j] += Vec2Mean[i] * Vec2Mean[j];
		}
	}
	
	// and normalize
    for (cc=0; cc<nClustersAlive; cc++) {
        c = AliveIndex[cc];
		if (nClassMembers[c]<=1) continue; // avoid divide by 0		
		for(i=0; i<nDims; i++) for(j=i; j<nDims; j++) {
			Cov[c*nDims2 + i*nDims + j] /= (nClassMembers[c]-1);
		}
	}
	
	// That's it!

	// Diagnostics
	if (Debug) {
        for (int ccx=0; ccx<nClustersAlive; ccx++) {
            int cx = AliveIndex[ccx];
			Output("Class %d - Weight %.2g\n", cx, Weight[cx]);
			Output("Mean: ");
			MatPrint(stdout, Mean.m_Data + cx*nDims, 1, nDims);
			Output("\nCov:\n");
#ifndef VALGRIND
			MatPrint(stdout, Cov.m_Data + cx*nDims2, nDims, nDims);
			Output("\n");
#endif
		}
	}
}

// E-step.  Calculate Log Probs for each point to belong to each living class
// will delete a class if covariance matrix is singular
// also counts number of living classes
void KK::EStep() {
	int p, c, cc, i;
	static int cEStepCalls =0;	// counts calls to EStep for use as an id for
				// chol mat and means
	int nSkipped;
	float LogRootDet; // log of square root of covariance determinant
	float Mahal; // Mahalanobis distance of point from cluster center
	Array<float> Vec2Mean(nDims); // stores data point minus class mean
	Array<float> Root(nDims); // stores result of Chol*Root = Vec
    float *OptPtrLogP;		// pointer for setting LogP more efficiently
    int *OptPtrClass = Class.m_Data;
    int *OptPtrOldClass = OldClass.m_Data;

    bool Xdeb = false;		// special debug toggle
    bool Ydeb = false;		// special debug toggle
	
	kSv.cEStepCallsLast = ++cEStepCalls;	// tag for model for this iter
	nSkipped = 0;
	
	// start with cluster 0 - uniform distribution over space 
	// because we have normalized all dims to 0...1, density will be 1.
	for (p=0; p<nPoints; p++) LogP[p*MaxPossibleClusters + 0] = (float)-log(Weight[0]);
	
    for (cc=1; cc<nClustersAlive; cc++) {
        c = AliveIndex[cc];

		// calculate cholesky decomposition for class c
		if (Cholesky(Cov.m_Data+c*nDims2, (*kSv.pChol)[c].m_Data, nDims)) {
			// If Cholesky returns 1, it means the matrix is not positive definite.
			// So kill the class.
			Output("Deleting class %d: covariance matrix is	singular\n", c);
			ClassAlive[c] = 0;
			continue;
		}			

		Xdeb = false;	// or:  Debug;

		// LogRootDet is given by log of product of diagonal elements
		LogRootDet = 0;
		for(i=0; i<nDims; i++) LogRootDet += log(((*kSv.pChol)[c])[i*nDims + i]);

		for (p=0; p<nPoints; p++) {

			// // special debugging
		    Ydeb = (Xdeb && (p==0) );	


		    if (Ydeb) {
			    cout << "### Ydeb set for point " << p << endl;
			    cout << "Data: " << Data[p*nDims] 
				    << " " << Data[p*nDims+1] 
				    << ", Mean = " ;
				    MatPrint(stdout, Mean.m_Data + c*nDims, 
					1, nDims);
			    cout << "Mean[c*nDims]=" << Mean[c*nDims] 
				    << ", Mean[c*nDims+1]=" << Mean[c*nDims+1] 
				    << endl;
		    }


		    // optimize for speed ...
		    OptPtrLogP = LogP.m_Data + (p*MaxPossibleClusters);


			// to save time -- only recalculate if the last one was close
			if (
				!FullStep
//              Class[p] == OldClass[p]
//				&& LogP[p*MaxPossibleClusters+c] - LogP[p*MaxPossibleClusters+Class[p]] > DistThresh
                && OptPtrClass[p] == OptPtrOldClass[p]
				&& OptPtrLogP[c] - OptPtrLogP[OptPtrClass[p]] > DistThresh				
			) {
				if (Ydeb) {
					cout << "skip for point " << p << ":  "
					<< "OptPtrClass[p]=" << OptPtrClass[p] 
					<< ", OptPtrLogP[c]=" << OptPtrLogP[c] 
					<< ", OptPtrLogP[OptPtrClass[p]]=" 
					<<  OptPtrLogP[OptPtrClass[p]]
					<< endl;
				}
				nSkipped++;
				continue;
			}
			
			// Compute Mahalanobis distance
			Mahal = 0;
			
			// calculate data minus class mean
			for(i=0; i<nDims; i++) Vec2Mean[i] = Data[p*nDims + i] - Mean[c*nDims + i];
			if (Ydeb) 
				cout << "Cluster[" << c << "]:  Vec2mean= " 
					<< Vec2Mean[0] << " " 
					<< Vec2Mean[1] << "\n";

			
			// calculate Root vector - by Chol*Root = Vec2Mean
			TriSolve((*kSv.pChol)[c].m_Data, Vec2Mean.m_Data, Root.m_Data, nDims);
		
			if (Ydeb) 
				cout << "   Root= " 
					<< Root[0] << " " 
					<< Root[1] << "\n";

			// add half of Root vector squared to log p
			for(i=0; i<nDims; i++) Mahal += Root[i]*Root[i];
			

			// Score is given by Mahal/2 + log RootDet - log weight
//			LogP[p*MaxPossibleClusters + c] = Mahal/2
			OptPtrLogP[c] = Mahal/2
					+ LogRootDet
					- log(Weight[c]) 
					+ log(2*PI)*nDims/2;
		
			if (Ydeb) 
				cout << "   Mahal= " << Mahal 
				<< ", LogRootDet=" << LogRootDet 
				<< ", (-log(Weight[c])) =" << (-log(Weight[c]))
				<< ", log(2*PI)*nDims/2 =" << (log(2*PI)*nDims/2)
				<< ", OptPtrLogP[c]=" << OptPtrLogP[c]
				<< "\n";

			
			if (Debug) {
				if (p==0) {
					Output("Cholesky\n");
					MatPrint(stdout, (*kSv.pChol)[c].m_Data, nDims, nDims);
					Output("root vector:\n");
					MatPrint(stdout, Root.m_Data, 1, nDims);
					Output("First point's score = %.3g + %.3g - %.3g = %.3g\n", Mahal/2, LogRootDet
					, log(Weight[c]), LogP[p*MaxPossibleClusters + c]);
				}
			}

		}	// for (cc=1; cc<nClustersAlive

	}	// for (cc=1; cc<nClustersAlive

    		// new Cholesky matrices

//	Output("Skipped %d ", nSkipped);

}

// Choose best class for each point (and second best) out of those living
void KK::CStep() {
	int p, c, cc, TopClass, SecondClass;
	float ThisScore, BestScore, SecondScore;
	
	for (p=0; p<nPoints; p++) {
		OldClass[p] = Class[p];
		BestScore = HugeScore;
		SecondScore = HugeScore;
		TopClass = SecondClass = 0;

		for (cc=0; cc<nClustersAlive; cc++) {
			c = AliveIndex[cc];
			ThisScore = LogP[p*MaxPossibleClusters + c];
			if (ThisScore < BestScore) {
				SecondClass = TopClass;
				TopClass = c;
				SecondScore = BestScore;
				BestScore = ThisScore;
			}
			else if (ThisScore < SecondScore) {
				SecondClass = c;
				SecondScore = ThisScore;
			}
		}
		Class[p] = TopClass;
		Class2[p] = SecondClass;
	}
}

// Sometimes deleting a cluster will improve the score, when you take into accout
// the BIC. This function sees if this is the case.  It will not delete more than
// one cluster at a time.
void KK::ConsiderDeletion() {

	int c, p, CandidateClass;
	float Loss, DeltaPen;
	Array<float> DeletionLoss(MaxPossibleClusters); // the increase in log P by deleting the cluster
	
	for(c=0; c<MaxPossibleClusters; c++) {
		if (ClassAlive[c]) DeletionLoss[c] = 0;
		else DeletionLoss[c] = HugeScore; // don't delete classes that are already there
	}
	
	// compute losses by deleting clusters
	for(p=0; p<nPoints; p++) {
		DeletionLoss[Class[p]] += LogP[p*MaxPossibleClusters + Class2[p]] - LogP[p*MaxPossibleClusters + Class[p]];
	}	
	
	// find class with least to lose
	Loss = HugeScore;
	for(c=1; c<MaxPossibleClusters; c++) {
		if (DeletionLoss[c]<Loss) {
			Loss = DeletionLoss[c];
			CandidateClass = c;
		}
	}
	
	// what is the change in penalty?
	DeltaPen = Penalty(nClustersAlive) - Penalty(nClustersAlive-1);
	
	//Output("cand Class %d would lose %f gain is %f\n", CandidateClass, Loss, DeltaPen);
	// is it worth it?
	if (Loss<DeltaPen) {
		Output("Deleting Class %d. Lose %f but Gain %f\n", CandidateClass, Loss, DeltaPen);		
		// set it to dead
		ClassAlive[CandidateClass] = 0;
		
		// re-allocate all of its points
		for(p=0;p<nPoints; p++) if(Class[p]==CandidateClass) Class[p] = Class2[p];
	}
    Reindex();
}
		

// LoadClu(CluFile)
void KK::LoadClu(char *CluFile) {
    FILE *fp;
    int p, c, val;
    int status;


    fp = fopen_safe(CluFile, "r");
    status = fscanf(fp, "%d", &nStartingClusters);
    nClustersAlive = nStartingClusters;// -1;
    for(c=0; c<MaxPossibleClusters; c++) ClassAlive[c]=(c<nStartingClusters);

    for(p=0; p<nPoints; p++) {
        status = fscanf(fp, "%d", &val);
		if (status==EOF) Error("Error reading cluster file");
        Class[p] = val-1;
    }
}

// for each cluster, try to split it in two.  if that improves the score, do it.
// returns 1 if split was successful
int KK::TrySplits() {
    int i, c, cc, c2, p, p2, d, DidSplit = 0;
    float Score, NewScore, UnsplitScore, SplitScore;
    int UnusedCluster;
    KK K2; // second KK structure for sub-clustering
    KK K3; // third one for comparison

    if(nClustersAlive>=MaxPossibleClusters-1) {
        Output("Won't try splitting - already at maximum number of clusters\n");
        return 0;
    }

    // set up K3
    K3.nDims = nDims; K3.nPoints = nPoints;
    K3.AllocateArrays();
    K3.penaltyMix = PenaltyMix;
    for(i=0; i<nDims*nPoints; i++) K3.Data[i] = Data[i];

    Score = ComputeScore();

    // loop thu clusters, trying to split
    for (cc=1; cc<nClustersAlive; cc++) {
        c = AliveIndex[cc];

        // set up K2 strucutre to contain points of this cluster only

        // count number of points and allocate memory
        K2.nPoints = 0;
        for(p=0; p<nPoints; p++) if(Class[p]==c) K2.nPoints++;
        if(K2.nPoints==0) continue;
        K2.nDims = nDims;
        K2.AllocateArrays();	// also sets nDims2
        K2.penaltyMix = PenaltyMix;
        K2.NoisePoint = 0;

        // put data into K2
        p2=0;
        for(p=0; p<nPoints; p++) if(Class[p]==c) {
            for(d=0; d<nDims; d++) K2.Data[p2*nDims + d] = Data[p*nDims + d];
            p2++;
        }

        // find an unused cluster
        UnusedCluster = -1;
        for(c2=1; c2<MaxPossibleClusters; c2++) {
             if (!ClassAlive[c2]) {
                 UnusedCluster = c2;
                 break;
             }
        }
        if (UnusedCluster==-1) {
            Output("No free clusters, abandoning split");
            return DidSplit;
        }

        // do it
        if (Verbose>=1) Output("Trying to split cluster %d (%d points) \n", c, K2.nPoints);
        K2.nStartingClusters=2; // (2 = 1 clusters + 1 unused noise cluster)
        UnsplitScore = K2.CEM(NULL, 0);
        K2.nStartingClusters=3; // (3 = 2 clusters + 1 unused noise cluster)
        SplitScore = K2.CEM(NULL, 0);

        if(SplitScore<UnsplitScore) {
            // will splitting improve the score in the whole data set?

            // assign clusters to K3
            for(c2=0; c2<MaxPossibleClusters; c2++) K3.ClassAlive[c2]=0;
            p2 = 0;
            for(p=0; p<nPoints; p++) {
                if(Class[p]==c) {
                    if(K2.Class[p2]==1) K3.Class[p] = c;
                    else if(K2.Class[p2]==2) K3.Class[p] = UnusedCluster;
                    else Error("split should only produce 2 clusters");
                    p2++;
                } else K3.Class[p] = Class[p];
                K3.ClassAlive[K3.Class[p]] = 1;
            }
            K3.Reindex();

            // compute scores
            K3.MStep();
            K3.EStep();
            NewScore = K3.ComputeScore();
            Output("Splitting cluster %d changes total score from %f to %f\n", c, Score, NewScore);

            if (NewScore<Score) {
                DidSplit = 1;
                Output("So it's getting split into cluster %d.\n", UnusedCluster);
                // so put clusters from K3 back into main KK struct (K1)
                for(c2=0; c2<MaxPossibleClusters; c2++) ClassAlive[c2] = K3.ClassAlive[c2];
                for(p=0; p<nPoints; p++) Class[p] = K3.Class[p];
            } else {
                Output("So it's not getting split.\n");
            }
        }
    }
    return DidSplit;
}

// ComputeScore() - computes total score.  Requires M, E, and C steps to have been run
float KK::ComputeScore() {
    int p;

    float Score = Penalty(nClustersAlive);
    for(p=0; p<nPoints; p++) {
        Score += LogP[p*MaxPossibleClusters + Class[p]];
		// Output("point %d: cumulative score %f\n", p, Score);
    }
	
	if (Debug) {
		int c, cc;
		float tScore;
		for(cc=0; cc<nClustersAlive; cc++) {
			c = AliveIndex[cc];
			tScore = 0;
				// possible bug:  "int" added to next statement
			for(int p=0; p<nPoints; p++) if(Class[p]==c) tScore += LogP[p*MaxPossibleClusters + Class[p]];
			Output("class %d has subscore %f\n", c, tScore);
		}
	}

    return Score;
}
// CEM(StartFile) - Does a whole CEM algorithm from a random start
// optional start file loads this cluster file to start iteration
// if Recurse is 0, it will not try and split.
float KK::CEM(char *CluFile, int Recurse)  {
	int p, c;
	int nChanged;
	int Iter;
	Array<int> OldClass(nPoints);
	float Score =0.0, OldScore;	// initialize for valgrind
	int LastStepFull; // stores whether the last step was a full one
    int DidSplit;

    if (CluFile && *CluFile) LoadClu(CluFile);
	else {
        // initialize data to random
        if (nStartingClusters>1)
    	    for(p=0; p<nPoints; p++) Class[p] = irand(1, nStartingClusters-1);
        else
            for(p=0; p<nPoints; p++) Class[p] = 0;
    }
	
	// set all clases to alive
	for(c=0; c<MaxPossibleClusters; c++) ClassAlive[c] = (c<nStartingClusters);	
    Reindex();
	
	// main loop
	Iter = 0;
	FullStep = 1;
	do {
		// Store old classifications
		for(p=0; p<nPoints; p++) OldClass[p] = Class[p];
		
		// M-step - calculate class weights, means, and covariance matrices for each class
		MStep();
				
		// E-step - calculate scores for each point to belong to each class
		EStep();

		// dump distances if required
		
		if (DistDump) MatPrint(Distfp, LogP.m_Data, DistDump, MaxPossibleClusters);
		
		// C-step - choose best class for each 
		CStep(); 
		
		// Would deleting any classes improve things?
		if(Recurse) ConsiderDeletion();
		
		// Calculate number changed
		nChanged = 0;
		for(p=0; p<nPoints; p++) nChanged += (OldClass[p] != Class[p]);
		
		// Calculate score
		OldScore = Score;
		Score = ComputeScore();
		
			// save cluster centers for later output, but
			// only if not just horsing around with testing
			// splits.
		if (Recurse && (Score < kSv.BestScoreSave)) {
			SaveBestMeans();
				// this might be better than the score
				// returned at the end of the iteration
			kSv.BestScoreSave = Score;
		}
	
		if(Verbose>=1) {
            if(Recurse==0) Output("\t");
            Output("Iteration %d%c: %d clusters Score %.7g nChanged %d tag %d\n",
		    Iter, FullStep ? 'F' : 'Q', nClustersAlive, Score, nChanged,
		    kSv.cEStepCallsLast);
        }
		
		Iter++;

		if (Debug) {
			// for(p=0;p<nPoints;p++) BestClass[p] = Class[p]; //
				// SaveOutput(BestClass);  
			Output("Press return");
				// getchar();
		}
		
		// Next step a full step?
		LastStepFull = FullStep;
		FullStep = (
						nChanged>ChangedThresh*nPoints 
						|| nChanged == 0 
						|| Iter%FullStepEvery==0 
					//	|| Score > OldScore Doesn't help!  
					//	Score decreases are not because of quick steps!
					) ;
		if (Iter>MaxIter) {
			Output("Maximum iterations exceeded\n");
			break;
		}		

        // try splitting
		// fix:  first "&&" changed from "&"
        if (Recurse && SplitEvery>0 && (Iter%SplitEvery==SplitEvery-1 || (nChanged==0 && LastStepFull))) {
            DidSplit = TrySplits();
        } else DidSplit = 0;

	} while (nChanged > 0 || !LastStepFull || DidSplit);

	if (DistDump) fprintf(Distfp, "\n");

	return Score;
}

// Copy number of clusters, best means, and number of clusters for later output

void KK::SaveBestMeans() {	// save cluster centers for later output
	int c, cc, i;

	kSv.cEStepCallsSave = kSv.cEStepCallsLast;
	kSv.nDimsBest = nDims;
	kSv.nBestClustersAlive = nClustersAlive;	

	if (kSv.BestWeight.size() < Weight.size()) {
		kSv.BestWeight.SetSize(Weight.size());
	}

	if (kSv.BestMean.size() < Mean.size()) {
		kSv.BestMean.SetSize(Mean.size());
	}
	
	for (cc=0; cc<nClustersAlive; cc++) {
		c = AliveIndex[cc];

			// save for writing of Cholesky, which has gaps
		kSv.BestAliveIndex[cc] = c;

			// save without gaps:  cc, not c
		kSv.BestWeight[cc] = Weight[c];
		for (i=0; i<nDims; i++) {
				// save without gaps:  cc, not c
			kSv.BestMean[cc*nDims + i] = Mean[c*nDims + i] ;
		}

		if (Debug) {
			if (c==0) Output("Mean (at SaveBestMeans):\n");
			MatPrint(stdout, Mean.m_Data + c*nDims, 1, nDims);
			Output("... best:  ");
			MatPrint(stdout, kSv.BestMean.m_Data + cc*nDims, 1, nDims);
		}
	}
		
	// Save best Chol matrix.
	// Don't bother with cluster 0.
	for (int cc=1; cc<kSv.nBestClustersAlive; cc++) {
		c = kSv.BestAliveIndex[cc];

		for (int i=0; i<kSv.nDimsBest; i++) 
		   for (int j=0; j<=i; j++) {

			((*kSv.pBestChol)[c])[i*kSv.nDimsBest + j] = 
			    ((*kSv.pChol)[c])[i*kSv.nDimsBest + j];
		}
	}
	
}
