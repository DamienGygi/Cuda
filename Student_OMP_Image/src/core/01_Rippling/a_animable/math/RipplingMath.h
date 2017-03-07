#pragma once

#include <math.h>
#include "MathTools.h"

#include "ColorTools_CPU.h"
using namespace cpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class RipplingMath
    {
	/*--------------------------------------*\
	|*		Constructeur		*|
	 \*-------------------------------------*/

    public:

	RipplingMath(uint w)
	    {
	    this->dim2 = w / 2;
	    }

	// constructeur copie: pas besoin car pas attribut ptr

	virtual ~RipplingMath(void)
	    {
	    // rien
	    }

	/*--------------------------------------*\
	|*		Methode			*|
	 \*-------------------------------------*/

    public:

	void colorIJ(uchar4* ptrColorIJ, int i, int j, float t)
	    {
	    uchar levelGris;

	    f(j, i, t, &levelGris);

	    ptrColorIJ->x = levelGris;
	    ptrColorIJ->y = levelGris;
	    ptrColorIJ->z = levelGris;

	    ptrColorIJ->w = 255; //opaque
	    }

    private:

	void f(int i, int j, float t, uchar* ptrlevelGris)
	    {
	    // TODO cf fonction math pdf
	    // use focntion dij ci-dessous
	    float result;
	    dij(i, j, &result);
	    result = result / 10;
	    float num = cosf(result - t / 7);
	    float den = result + 1;

	    *ptrlevelGris = 128 + (127 * (num / den));
	    }

	void dij(int i, int j, float* ptrResult)
	    {
	    //TODO cf fonction math pdf
	    float fi = i - dim2;
	    float fj = j - dim2;
	    *ptrResult = sqrtf((fi * fi) + (fj * fj));
	    }

	/*--------------------------------------*\
	|*		Attribut			*|
	 \*-------------------------------------*/

    private:

	// Tools
	double dim2;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
