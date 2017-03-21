#include "RayTracing.h"


#include <iostream>
#include <assert.h>

#include "Device.h"
#include <assert.h>


using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void raytracing(uchar4* ptrTabPixels, uint w, uint h, float t, Sphere *ptrSphere, int nbSphere);

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

/*-------------------------*\
 |*	Constructeur	    *|
 \*-------------------------*/

RayTracing::RayTracing(const Grid &grid, uint w, uint h, float dt, int nbSphere) :
	Animable_I<uchar4>(grid, w, h, "Raytracing_Cuda")
    {

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
    raytracing<<<dg,db>>>(ptrDevPixels,w,h,t, ptrDevTabSphere, nbSphere);
    // le kernel est importer ci-dessus (ligne 19)

    Device::lastCudaError("raytracing rgba uchar4 (after kernel)"); // facultatif, for debug only, remove for release
    }

/**
 * Override
 * Call periodicly by the API
 */
void RayTracing::animationStep()
    {
    //t += dt;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
