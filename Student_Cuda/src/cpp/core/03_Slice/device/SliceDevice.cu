#include "Indice2D.h"
#include "cudaTools.h"
#include "reductionADD.h"
#include <stdio.h>

__global__ void slice(float *ptrDevPi, int nbSlice);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static __device__ void reduceIntraThread(float* tabSM, int nbSlice);
static __device__ float area(int x, int nbSlice);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__global__ void slice(float* ptrDevPi, int nbSlice)
{
	extern __shared__ float tabSM[];
	reduceIntraThread(tabSM, nbSlice);  /* Bloc Orange */
	__syncthreads(); /* Synchronisation des Threads*/
	reductionADD<float>(tabSM,ptrDevPi); /* Bloc bleu + bloc vert */
}

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

__device__
void reduceIntraThread(float *tabSM, int nbSlice)
{
	/* Shared Memory */
	float sumThread = 0.0f;

	//const int TID_LOCAL = threadIdx.x;
	//const int TID = threadIdx.x+(blockIdx.x*blockDim.x);
	//const int NB_THREAD = blockDim.x*gridDim.x;
	const int TID_LOCAL = Indice1D::tidLocal();
	const int TID = Indice1D::tid();
	const int NB_THREAD = Indice1D::nbThread();
	int s = TID;
	while (s < nbSlice)
	{
		sumThread += area(s, nbSlice);
		s += NB_THREAD;
	}
	tabSM[TID_LOCAL] = sumThread;
	//tabSM[TID_LOCAL] = 1;
	//tabSM[TID_LOCAL] = TID;

}

__device__ float f(float x)
{
	return 4.0f / (1.0f + x * x);
}

__device__ float area(int s, int nbSlice)
{
	return f(s / (float) nbSlice);
	//return (float)s;
}
