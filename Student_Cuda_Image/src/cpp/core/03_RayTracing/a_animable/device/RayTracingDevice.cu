#include "Indice2D.h"
#include "cudaTools.h"
#include "Device.h"

#include "IndiceTools_GPU.h"
#include "DomaineMath_GPU.h"

#include "Sphere.h"
#include "RayTracingMath.h"
#include "length_cm.h"

using namespace gpu;

// Attention : 	Choix du nom est impotant!
//		VagueDevice.cu et non Vague.cu
// 		Dans ce dernier cas, probl?me de linkage, car le nom du .cu est le meme que le nom d'un .cpp (host)
//		On a donc ajouter Device (ou n'importequoi) pour que les noms soient diff?rents!

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/
__constant__ Sphere TAB_CM[LENGTH_CM];
/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/
__host__ void uploadGPUCM(Sphere* tabValue);

__global__ void raytracingGM(uchar4* ptrDevPixels, uint w, uint h, float t, Sphere* ptrDevSphere, int nbSphere);
__global__ void raytracingCM(uchar4* ptrDevPixel, uint w, uint h, float t, Sphere* ptrDevSphere, int nbSphere);
__global__ void raytracingSM(uchar4* ptrDevPixel, uint w, uint h, float t, Sphere* ptrDevSphere, int nbSphere);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/
static __device__ void work(uchar4* ptrDevPixels, uint w, uint h, float t, Sphere* ptrDevSphere, int nbSphere);
static __device__ void copyToSM(Sphere* ptrDevSphere, Sphere* tab_SM);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__host__ void uploadGPUCM(Sphere* tabValue)
    {
    size_t size = LENGTH_CM * sizeof(Sphere);
    int offset = 0;
    cudaMemcpyToSymbol(TAB_CM, tabValue, size, offset, cudaMemcpyHostToDevice);
    }

__global__ void raytracingGM(uchar4* ptrDevPixels, uint w, uint h, float t, Sphere* ptrDevSphere, int nbSphere)
    {
    work(ptrDevPixels, w, h, t, ptrDevSphere, nbSphere);

    }
__global__ void raytracingCM(uchar4* ptrDevPixel, uint w, uint h, float t, Sphere* ptrDevSphere, int nbSphere)
    {
    work(ptrDevPixel, w, h, t, ptrDevSphere, nbSphere);
    }
__global__ void raytracingSM(uchar4* ptrDevPixel, uint w, uint h, float t, Sphere* ptrDevSphere, int nbSphere)
    {
    extern __shared__ Sphere tab_SM[];
    copyToSM(ptrDevSphere,tab_SM);

    __syncthreads();
    work(ptrDevPixel, w, h, t, tab_SM, nbSphere);
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/
__device__ void work(uchar4* ptrDevPixels, uint w, uint h, float t, Sphere* ptrDevSphere, int nbSphere)
    {
    RayTracingMath rayTracing = RayTracingMath(ptrDevSphere, nbSphere);

    const int TID = Indice2D::tid();
    const int NB_THREAD = Indice2D::nbThread();
    const int WH = w * h;

    int s = TID;
    int i;
    int j;
    while (s < WH)
	{
	IndiceTools::toIJ(s, w, &i, &j);
	rayTracing.colorIJ(&ptrDevPixels[s], i, j, t);
	s += NB_THREAD;
	}

    }

__device__ void copyToSM(Sphere* ptrDevSphere,Sphere* tab_SM)
    {
	const int TID_LOCAL = Indice2D::tidLocal();
    	const int NB_THREAD_LOCAL = Indice2D::nbThreadLocal();
    	int s = TID_LOCAL;
    	while (s<LENGTH_CM)
    	{
    		tab_SM[s]=ptrDevSphere[s];
    		s += NB_THREAD_LOCAL;
    	}
    }
/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
