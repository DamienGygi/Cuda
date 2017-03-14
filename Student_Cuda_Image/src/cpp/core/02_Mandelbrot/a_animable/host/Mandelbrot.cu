#include <iostream>
#include <assert.h>

#include "Device.h"

#include "Mandelbrot.h"
#include "MandelbrotMath.h"

#include "IndiceTools_GPU.h"
#include "DomaineMath_GPU.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/
extern __global__ void mandelbrot(uchar4* ptrDevPixels, uint w, uint h, float dt, uint n, const DomaineMath domaineMath);

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

Mandelbrot::Mandelbrot(const Grid& grid, uint w, uint h, float dt, uint n, const DomaineMath &domaineMath) :
	Animable_I<uchar4>(grid, w, h, "Mandelbrot_Cuda", domaineMath)
    {
    // Input
    this->n = n;

    // Tools
    this->t = 0;					// protected dans super classe Animable

    }

Mandelbrot::~Mandelbrot(void)
    {
    // rien
    }

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/**
 * Override
 */
void Mandelbrot::animationStep()
    {
    this->t += t;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * Override (code naturel omp)
 */
void Mandelbrot::process(uchar4* ptrDevPixels, uint w, uint h, const DomaineMath& domaineMath)
    {
    Device::lastCudaError("rippling rgba uchar4 (before kernel)"); // facultatif, for debug only, remove for release
    mandelbrot<<<dg,db>>>(ptrDevPixels,w,h,t,n,domaineMath);
    // le kernel est importer ci-dessus (ligne 19)

    Device::lastCudaError("rippling rgba uchar4 (after kernel)"); // facultatif, for debug only, remove for release
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

