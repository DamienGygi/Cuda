#include "Indice2D.h"
#include "Indice1D.h"
#include "cudaTools.h"

#include <stdio.h>


/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/


/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__global__ void histogramme(int* ptrTabPixelsGM, uint nbPixels, int* ptrGM);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

__device__ void reductionIntraThread(int* TAB_SM, int* ptrTabPixelsGM, uint nbPixels);

__device__ void reductionInterBlock(int* TAB_SM, int* ptrGM);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/


/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/
__global__ void histogramme(int* ptrTabPixelsGM, uint nbPixels, int* ptrGM)
    {
    extern __shared__ int TAB_SM[];
    reductionIntraThread(TAB_SM, ptrTabPixelsGM, nbPixels);
    __syncthreads();
    reductionInterBlock(TAB_SM, ptrGM);
    }


/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/


__device__ void reductionIntraThread(int* TAB_SM, int* ptrTabPixelsGM, uint nbPixels)
    {
    const int NB_THREAD=Indice2D::nbThread();
    const int TID=Indice2D::tid();
    const int TIDLocal = Indice1D::tidLocal();

    int s = TID;

    while(s<nbPixels)
	{
	int value = ptrTabPixelsGM[s];
	int* adresse = &TAB_SM[value];
	atomicAdd(adresse, 1);
	s += NB_THREAD;
	}
    }

__device__ void reductionInterBlock(int* TAB_SM, int* ptrGM)
    {
	if (Indice2D::tidLocal() == 0)
	    {
	    for (int i = 0; i < 256; i++)
		{
		    ptrGM[i] = TAB_SM[i];
		}
	    }

    }
/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
