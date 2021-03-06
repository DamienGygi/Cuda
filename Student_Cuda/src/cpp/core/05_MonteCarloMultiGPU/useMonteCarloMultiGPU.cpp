#include <iostream>
#include "MathTools.h"
#include "MonteCarloMultiGPU.h"
#include <limits.h>
#include "cudaTools.h"
#include "Grid.h"
#include "Chrono.h"

using std::cout;
using std::endl;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool useMonteCarloMultiGPU(void);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool useMonteCarloMultiGPU()
    {
    //int nbSlice = INT_MAX;
    int nbFleches = 40000000;
    int m = 30;

    dim3 dg = dim3(24, 1, 1);
    dim3 db = dim3(128, 1, 1);
    Grid grid(dg, db);

    float pi;
    // SearchPI
    Chrono c;
    MonteCarloMultiGPU montecarloMulti(nbFleches, m, grid);
    c.start();
    montecarloMulti.process();
    pi = montecarloMulti.getPi();
    c.stop();
    double ellapsedTime=c.getElapseTimeS();
    cout <<"Ellapsed time:" << ellapsedTime <<endl;
//	MonteCarlo slice(nbSlice, dg, db);
//	slice.process();
//	pi = slice.getPi();

    cout << "Pi value = " << pi << endl;
    return MathTools::isEquals(pi, PI_FLOAT, 0.01f);
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
