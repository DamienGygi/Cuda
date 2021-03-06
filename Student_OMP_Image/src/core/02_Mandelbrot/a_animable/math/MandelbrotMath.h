#pragma once

#include <math.h>
#include "MathTools.h"

#include "Calibreur_CPU.h"
#include "ColorTools_CPU.h"
using namespace cpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class MandelbrotMath
    {

	/*--------------------------------------*\
	|*		Constructor		*|
	 \*-------------------------------------*/

    public:
	MandelbrotMath(uint n) :
		calibreur(Interval<float>(0.0, n), Interval<float>(0.0, 1.0))
	    {
	    this->n = n;
	    }

	// constructeur copie automatique car pas pointeur dans
	//	DamierMath
	// 	calibreur
	// 	IntervalF

	virtual ~MandelbrotMath()
	    {
	    // rien
	    }

	/*--------------------------------------*\
	|*		Methodes		*|
	 \*-------------------------------------*/

    public:

	void colorXY(uchar4* ptrColor, float x, float y, float t)
	    {
		float k = getK(x, y);
		if(k >= this->n){
		    ptrColor->x = 0;
		    ptrColor->y = 0;
		    ptrColor->z = 0;
		}else{
		    float hue = k;
	//		float hue = (1.0 / this->n) * k;
		    calibreur.calibrer(hue);
		    ColorTools::HSB_TO_RVB(hue, ptrColor);
		}
		ptrColor->w = 255;
	    }

    private:

	bool isDivergent(float a,float b)
	    {
		float cond =a*a+b*b;
		if(cond>4.0){
		    return true;
		}
		else
		{
		    return false;
		}
	    }

	int getK(float x, float y){
		float a =0;
		float b =0;
		float acopy;

		int k=0;
		while (k<=this->n){
		    if (isDivergent(a, b)){
			return k;
		    }
		    acopy=a;
		    a=a*a-b*b+x;
		    b=2*acopy*b+y;
		    k++;
		}
		return k;
	}
	/*--------------------------------------*\
	|*		Attributs		*|
	 \*-------------------------------------*/

    private:

	// Input
	uint n;

	// Tools
	Calibreur<float> calibreur;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
