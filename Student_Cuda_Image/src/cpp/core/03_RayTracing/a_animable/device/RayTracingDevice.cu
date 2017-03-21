#include "Indice2D.h"
#include "cudaTools.h"
#include "Device.h"
#include "IndiceTools_GPU.h"
#include "DomaineMath_GPU.h"
#include "Sphere.h"
#include "RayTracingMath.h"


using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__global__ void raytracing(uchar4* ptrDevPixels, uint w, uint h, float t, Sphere* ptrDevTabSphere, uint nbSphere);
/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

__global__ void raytracing(uchar4* ptrDevPixels, uint w, uint h, float t, Sphere* ptrDevTabSphere, uint nbSphere)
    {
    RayTracingMath rayTracing = RayTracingMath(ptrDevTabSphere, nbSphere);

    const int TID = Indice2D::tid();
    const int NB_THREAD = Indice2D::nbThread();
    const int WH = w * h;

    int s = TID;
    int i;
    int j;
    while (s < WH)
	{
	IndiceTools::toIJ(s, w, &i, &j);
	rayTracing.colorIJ(&ptrDevPixels[s], i,j, t);
	s += NB_THREAD;
	}

    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

