#include "MandelbrotProvider.h"
#include "Mandelbrot.h"

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

/*--------------------------------------*\
 |*		Surcharge		*|
 \*-------------------------------------*/

/**
 * Override
 */
Animable_I<uchar4>* MandelbrotProvider::createAnimable(void)
    {
    //DomaineMath domaineMath = DomaineMath(0, 0, 2 * PI, 2 * PI);
    DomaineMath domaineMath = DomaineMath(-2.1, -1.3, 0.8, 1.3);

    // Animation;
    //float dt = 2 * PI / 800;
    float dt = 0.0f;
    int n = 100;

    // Dimension
    int dw = 16 * 80;
    int dh = 16 * 60;
    // Grid Cuda
    int mp = Device::getMPCount();
    int coreMP = Device::getCoreCountMP();

    dim3 dg = dim3(mp, 2, 1);
    dim3 db = dim3(coreMP, 2, 1);

    Grid grid(dg, db);
    return new Mandelbrot(grid,dw, dh, dt, n, domaineMath);
    }

/**
 * Override
 */
Image_I* MandelbrotProvider::createImageGL(void)
    {
    ColorRGB_01 colorTexte(0, 0, 0); // black
    return new ImageAnimable_RGBA_uchar4(createAnimable(), colorTexte);
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
