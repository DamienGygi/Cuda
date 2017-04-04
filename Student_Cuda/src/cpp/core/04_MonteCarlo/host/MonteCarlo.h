#pragma once

#include "cudaTools.h"
#include <curand_kernel.h>

class MonteCarlo
{
public:
	MonteCarlo(int nbFleches,int m, dim3 dg,dim3 db);
	virtual ~MonteCarlo(void);

	void process();
	float getPi();

private:
	// Inputs
	int nbFleches;
	int m;

	// Output
	float pi;
	curandState* tabDevGenerator;
	// Tools
	dim3 dg;
	dim3 db;
	size_t sizeOctetSM;
	size_t sizeOctetPi;
	int* ptrDevNx;
};
