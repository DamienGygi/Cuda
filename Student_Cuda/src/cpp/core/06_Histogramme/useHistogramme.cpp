#include <iostream>
#include "Grid.h"
#include "Device.h"
#include "MathTools.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

#include "../06_Histogramme/host/Histogramme.h"

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool useHistogramme(void);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool useHistogramme()
    {
    int max = 256;
    int result[max];
    int mp = Device::getMPCount();
    dim3 dg = dim3(mp, 1, 1);
    dim3 db = dim3(64, 1, 1);
    Grid grid(dg, db);

    Histogramme histogramme(grid, result, max);
    histogramme.run();

    for (int i = 0; i < max; i++ ) {printf("Item[%d] => %d fois\n ", i, result[i] );}
    bool isOk = true;
    return isOk;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
