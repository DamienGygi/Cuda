#pragma once

#include "cudaTools.h"
#include <curand_kernel.h>
#include "Grid.h"
class MonteCarlo
{
public:
	MonteCarlo(int nbFleches,int m,const Grid& grid);
	virtual ~MonteCarlo(void);

	void process();
	float getPi();
	int getCountFleches();

private:
	// Inputs
	int nbFleches;
	int m;

	// Output
	float pi;
	int piTest;
	curandState* ptrDevGenerator=NULL;
	// Tools
	dim3 dg;
	dim3 db;
	size_t sizeOctetSM;
	size_t sizeOctetPi;
	int* ptrDevNx;
};
