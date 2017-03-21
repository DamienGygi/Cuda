#include "RayTracingProvider.h"

#include "RayTracing.h"

#include "MathTools.h"
#include "Grid.h"



/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

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

/**
 * Override
 */
Animable_I<uchar4>* RayTracingProvider::createAnimable()
    {
    // Animation;
    float dt = 2 * PI / 1000;

    int nbSphere = 10;

    // Dimension
    int dw = 16 * 60;
    int dh = 16 * 60;

    // Grid Cuda
    int mp = Device::getMPCount();
    int coreMP = Device::getCoreCountMP();

    dim3 dg = dim3(96,1,1);
    dim3 db = dim3(512,1,1);

    Grid grid(dg,db);

    return new RayTracing(grid,dw, dh, dt, nbSphere);

    }

/**
 * Override
 */
Image_I* RayTracingProvider::createImageGL(void)
    {
    ColorRGB_01 colorTexte(0, 1, 0); // Green
    return new ImageAnimable_RGBA_uchar4(createAnimable(), colorTexte);
    }



/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
