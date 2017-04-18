#pragma once

#include "cudaTools.h"
#include <curand_kernel.h>
#include "Grid.h"
class MonteCarloMultiGPU
{
public:
	MonteCarloMultiGPU(int nbFleches,int m,const Grid& grid);
	virtual ~MonteCarloMultiGPU(void);

	void process();
	float getPi();

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
	Grid grid;

	size_t sizeOctetSM;
	size_t sizeOctetPi;
	int* ptrDevNx;
};
