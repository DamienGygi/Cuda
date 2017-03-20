#pragma once

#include <math.h>
#include "MathTools.h"
#include "ColorTools_GPU.h"
using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class RayTracingMath
    {

	/*--------------------------------------*\
	|*		Constructor		*|
	 \*-------------------------------------*/

    public:
	__device__ RayTracingMath(Sphere* ptrDevTabSphere, uint nbSphere)
	    {
	    this->nbSphere = nbSphere;
	    this->ptrDevTabSphere = ptrDevTabSphere;
	    }


	__device__
	       virtual ~RayTracingMath()
	    {
	    // rien
	    }

	/*--------------------------------------*\
	|*		Methodes		*|
	 \*-------------------------------------*/

    public:

	__device__
	void colorIJ(uchar4* ptrColor, float i, float j, float t)
	    {

	    float2 sol;
	    sol.x = i;
	    sol.y = j;

	    ptrColor->x = 0;
	    ptrColor->y = 0;
	    ptrColor->z = 0;
	    ptrColor->w = 255;

	    float hCarre;

	    Sphere s = ptrDevTabSphere[0];

	    for (uint index = 0; index < nbSphere; index++)
		{
		s = ptrDevTabSphere[index];
		hCarre = s.hCarre(sol);
		if (s.isEnDessous(hCarre))
		    {
		    ColorTools::HSB_TO_RVB(s.hue(t), 1.f, s.brightness(s.dz(hCarre)), ptrColor);
		    break;
		    }
		}
	    }

	/*--------------------------------------*\
	|*		Attributs		*|
	 \*-------------------------------------*/

    private:
	// Tools
	uint nbSphere;
	Sphere* ptrDevTabSphere;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
