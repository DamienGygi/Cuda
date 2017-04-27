#pragma once

#include "cudaTools.h"
#include "Grid.h"


/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

class Histogramme
    {
	/*--------------------------------------*\
	|*		Constructor		*|
	 \*-------------------------------------*/

    public:

	Histogramme(const Grid& grid, int* ptrResult, int max);

	virtual ~Histogramme(void);

	/*--------------------------------------*\
	|*		Methodes		*|
	 \*-------------------------------------*/

    public:

	void run();

	/*--------------------------------------*\
	|*		Attributs		*|
	 \*-------------------------------------*/
    private:
   	void dataCreate();
   	void dataShuffle();
   	void swap(int i, int j);
    private:

	// Inputs
	dim3 dg;
	dim3 db;
	int max;

	// Inputs/Outputs
	int* ptrResult;
	int* datas;

	// Tools
	size_t sizeOctetData;
	size_t sizeOctetResult;
	int* data;
	int nbPixels;
	int n;
	int nbShuffles;

	int* ptrTabIn;
	int* ptrTabOut;

    };

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
