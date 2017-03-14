#include "Indice2D.h"
#include "cudaTools.h"
#include "Device.h"

#include "MandelbrotMath.h"

#include "IndiceTools_GPU.h"
#include "DomaineMath_GPU.h"

using namespace gpu;
using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/
__global__ void mandelbrot(uchar4* ptrDevPixels, uint w, uint h,float t,uint n, DomaineMath domaineMath);
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
 |*		Public			*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * Override (code entrainement cuda)
 */
__global__ void mandelbrot(uchar4* ptrDevPixels, uint w, uint h,float t,uint n, DomaineMath domaineMath)
    {
    MandelbrotMath mandelbrotMath(n); // ici pour preparer cuda

    const int WH = w * h;

    const int NB_THREAD = Indice2D::nbThread();
    const int TID = Indice2D::tid();

    int i;
    int j;
    double x;
    double y;

    int s = TID;
    while (s < WH)
	{
	IndiceTools::toIJ(s, w, &i, &j); // s[0,W*H[ --> i[0,H[ j[0,W[
	domaineMath.toXY(i, j, &x, &y);
	mandelbrotMath.colorXY(&ptrDevPixels[s], x, y, t);
	s += NB_THREAD;
	}

    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

