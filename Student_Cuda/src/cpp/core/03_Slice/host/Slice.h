#pragma once

#include "cudaTools.h"

class Slice
{
public:
	Slice(int nbSlice, dim3 dg,dim3 db);
	virtual ~Slice(void);

	void process();
	float getPi();

private:
	// Inputs
	int nbSlice;

	// Output
	float pi;

	// Tools
	dim3 dg;
	dim3 db;
	size_t sizeOctetSM;
	size_t sizeOctetPi;
	float* ptrDevPi;
};
