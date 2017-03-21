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

	// constructeur copie automatique car pas pointeur dans VagueMath

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
	void colorIJ(uchar4* ptrColor, int i, int j, float t)
	    {

	    float min = 1000.f;
	    float hueMin = -1000.f;
	    float brightnessMin = -1000.f;
	    float hcarre;
	    float dz;
	    float dist;

	    float2 sol;
	    sol.x = i;
	    sol.y = j;

	    Sphere sphere = ptrDevTabSphere[0];

	    for (int i = 0; i < nbSphere; i++)
		{
		sphere = ptrDevTabSphere[i];
		hcarre = sphere.hCarre(sol);

		if (sphere.isEnDessous(hcarre))
		    {
		    dz = sphere.dz(hcarre);
		    dist = sphere.distance(dz);

		    if (dist < min)
			{
			min = dist;
			hueMin = sphere.hue(t);
			brightnessMin = sphere.brightness(dz);
			}
		    }

		if (hueMin >= 0 && brightnessMin >= 0)
		    ColorTools::HSB_TO_RVB(hueMin, 1, brightnessMin, ptrColor);
		else
		    {
		    ptrColor->x = 0;
		    ptrColor->y = 0;
		    ptrColor->z = 0;
		    }
		}
	    ptrColor->w = 255;

	    }

	/*--------------------------------------*\
	|*		Attributs		*|
	 \*-------------------------------------*/

    private:
	// Tools
	int nbSphere;
	Sphere *ptrDevTabSphere;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
