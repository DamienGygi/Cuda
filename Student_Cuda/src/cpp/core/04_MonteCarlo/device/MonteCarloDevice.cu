#include <curand_kernel.h>
#include <limits.h>
#include <Indice1D.h>
#include "reductionADD.h"

__global__ void setup_kernel_rand(curandState* tabDevGenerator, int deviceId);
__global__ void monteCarlo(curandState* tabDevGenerator, int nbFleches, float m,int* ptrDevNx);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/
static __device__ float f(float x);
static __device__ void reduceIntraThread(curandState* tabDevGenerator,int* tabSM, int nbFleches,int m);
/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__global__
void setup_kernel_rand(curandState* tabDevGenerator, int deviceId)
    {
// Customisation du generator:
// Proposition, au lecteur de faire mieux !
// Contrainte : Doit etre différent d'un GPU à l'autre
// Contrainte : Doit etre différent dun thread à lautre
    const int TID = Indice1D::tid();
    int deltaSeed = deviceId * INT_MAX / 10000;
    int deltaSequence = deviceId * 100;
    int deltaOffset = deviceId * 100;
    int seed = 1234 + deltaSeed;
    int sequenceNumber = TID + deltaSequence;
    int offset = deltaOffset;
    curand_init(seed, sequenceNumber, offset, &tabDevGenerator[TID]);
    }

__global__
void monteCarlo(curandState* tabDevGenerator, int nbFleches, float m,int* ptrDevNx)
    {
    extern __shared__ int tabSM[];
    reduceIntraThread(tabDevGenerator, tabSM, nbFleches,m);
    __syncthreads();
    reductionADD<int>(tabSM,ptrDevNx);
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/
__device__ void reduceIntraThread(curandState* tabDevGenerator,int* tabSM, int nbFleches,int m){
    const int TID = Indice1D::tid();
    const int TID_LOCAL = Indice1D::tidLocal();
    const int NB_THREAD = Indice1D::nbThread();
// Global Memory -> Register (optimization)
    curandState localGenerator = tabDevGenerator[TID];
    float xAlea;
    float yAlea;
    float y;
    int nx = 0;
    for (int i = 1; i <= nbFleches / NB_THREAD; i++)
	{
	xAlea = curand_uniform(&localGenerator); //Genere des nombres entre 0 et 1
	yAlea = curand_uniform(&localGenerator) * m;

	y = f(xAlea);
	if (y >= yAlea)
	    {
	    nx++;
	    }
	//work(xAlea, yAlea);
	}
//Register -> Global Memory
//Necessaire si on veut utiliser notre generator
// - dans dautre kernel
// - avec dautres nombres aleatoires !
    tabDevGenerator[TID] = localGenerator;
    tabSM[TID_LOCAL]=nx;
}

__device__ float f(float x)
    {
    return 4.0f / (1.0f + x * x);
    }

