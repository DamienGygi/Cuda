#include "RayTracing.h"


#include <iostream>
#include <assert.h>

#include "Device.h"
#include <assert.h>

#include "length_cm.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void raytracingGM(uchar4* ptrTabPixels, uint w, uint h, float t, Sphere *ptrSphere, int nbSphere);
extern __global__ void raytracingCM(uchar4* TAB_CM, uint w, uint h, float t, Sphere *ptrSphere, int nbSphere);
extern __host__ void upLoadGPUCM(Sphere* tabValue);
/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/*-------------------------*\raytracingcm
 |*	Constructeur	    *|
 \*-------------------------*/

RayTracing::RayTracing(const Grid &grid, uint w, uint h, float dt, int nbSphere) :
	Animable_I<uchar4>(grid, w, h, "Raytracing_Cuda")
    {
    assert(nbSphere==LENGTH_CM);
    // time
    this->t = 0;
    this->dt = dt;
    this->nbSphere = nbSphere;

    SphereCreator sphereCreator = SphereCreator(nbSphere, w, h,100);
    Sphere* ptrTabSphere = sphereCreator.getTabSphere();

    //MemoryManagement
    this->sizeOctetSpheres = nbSphere * sizeof(Sphere);
    Device::malloc(&ptrDevTabSphere, sizeOctetSpheres);
    Device::memclear(ptrDevTabSphere, sizeOctetSpheres);
    Device::memcpyHToD(ptrDevTabSphere, ptrTabSphere, sizeOctetSpheres);

    upLoadGPUCM(ptrTabSphere);
    }

RayTracing::~RayTracing()
    {
    Device::free(ptrDevTabSphere);
    }

/*-------------------------*\
 |*	Methode		    *|
 \*-------------------------*/

/**
 * Override
 * Call periodicly by the API
 *
 * Note : domaineMath pas use car pas zoomable
 */
void RayTracing::process(uchar4* ptrDevPixels, uint w, uint h, const DomaineMath& domaineMath)
    {
    Device::lastCudaError("raytracing rgba uchar4 (before kernel)"); // facultatif, for debug only, remove for release

    // TODO lancer le kernel avec <<<dg,db>>>
    //raytracingGM<<<dg,db>>>(ptrDevPixels,w,h,t, ptrDevTabSphere, nbSphere);
    raytracingCM<<<dg,db>>>(ptrDevPixels,w,h,t, ptrDevTabSphere, nbSphere);

    // le kernel est importer ci-dessus (ligne 19)

    Device::lastCudaError("raytracing rgba uchar4 (after kernel)"); // facultatif, for debug only, remove for release
    }

/**
 * Override
 * Call periodicly by the API
 */
void RayTracing::animationStep()
    {
    t += dt;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
