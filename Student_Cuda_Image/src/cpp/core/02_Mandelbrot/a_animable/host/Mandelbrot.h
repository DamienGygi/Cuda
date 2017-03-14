#pragma once

#include "cudaTools.h"
#include "MathTools.h"
#include "Animable_I_GPU.h"
#include "Variateur_GPU.h"
using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class Mandelbrot: public Animable_I<uchar4>
    {

	/*--------------------------------------*\
	 |*		Constructeur		*|
	 \*-------------------------------------*/

    public:

	Mandelbrot(const Grid& grid,uint w, uint h, float t, uint n, const DomaineMath& domaineMath);

	virtual ~Mandelbrot(void);

	/*--------------------------------------*\
	 |*		Methode			*|
	 \*-------------------------------------*/

	/*-------------------------*\
	|*   Override Animable_I   *|
	 \*------------------------*/

	/**
	 * Call periodicly by the api
	 */
	virtual void process(uchar4* ptrTabPixels, uint w, uint h, const DomaineMath &domaineMath);

	/**
	 * Call periodicly by the api
	 */
	virtual void animationStep();


    private:

	// Inputs
	uint n;
	float t;
	Variateur<float> variateurAnimation;
    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 /*----------------------------------------------------------------------*/
