//
// KK.h
//
// KlustaKwik clustering engine
//
#pragma once
#include "Array.h"

class KK {
public:
	// FUNCTIONS
	void AllocateArrays();
	void AlocateCholeskyVecs();	// allocate space to save best Cholesky 
					// matrices
	void SaveBestMeans();		// save cluster centers for later output
	void LoadData();
	float Penalty(int n);
	float ComputeScore();
	void MStep();
	void EStep();
	void CStep();
	void ConsiderDeletion();
    void LoadClu(char *StartCluFile);
    int TrySplits();
	float CEM(char *CluFile = (char*)0L, int recurse = 1);
    void Reindex();
public:
	// VARIABLES
	int nDims,  // nDims is the number of features, as specified by the 
		    // '1' entries in UseFeatures
	    nDims2; // nDims2 is nDims squared
	int nStartingClusters; // total # starting clusters, including clu 0, the noise cluster.
	int nClustersAlive;	// nClustersAlive is total number with points in, 
    				// excluding noise cluster
	int nPoints;
	int NoisePoint;	// number of fake points always in noise cluster to ensure 
    			// noise weight>0.  Default is 1.
	int FullStep; // Indicates that the next E-step should be a full step (no time saving)
	float penaltyMix;		// amount of BIC to use for penalty, must be between 0 and 1
	Array<float> Data; // Data[p*nDims + d] = Input data for poitn p, dimension d
	Array<float> Weight; // Weight[c] = Class weight for class c
	Array<float> Mean; // Mean[c*nDims + d] = cluster mean for cluster c in dimension d
	Array<float> Cov; // Cov[c*nDims*nDims + i*nDims + j] = Covariance for cluster C, entry i,j
					// NB covariances are stored in upper triangle (j>=i)
	Array<float> LogP; // LogP[p*MaxClusters + c] = minus log likelihood for point p in cluster c
	Array<int> Class; // Class[p] = best cluster for point p
	Array<int> OldClass; // Class[p] = previous cluster for point p
	Array<int> Class2; // Class[p] = second best cluster for point p
	Array<int> BestClass; // BestClass = best classification yet achieved
	Array<int> ClassAlive; // contains 1 if the class is still alive - otherwise 0
    Array<int> AliveIndex; // a list of the alive classes to iterate over

};
