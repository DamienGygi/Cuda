#include <iostream>
#include <stdlib.h>
#include <string.h>

#include "Device.h"
#include "cudaTools.h"

#include "RipplingProvider.h"
#include "MandelbrotProvider.h"
#include "RayTracingProvider.h"

#include "Settings_GPU.h"
#include "Viewer_GPU.h"
using namespace gpu;

using std::cout;
using std::endl;
using std::string;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

int mainImage(Settings& settings);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

int mainImage(Settings& settings)
    {
    cout << "\n[Image] mode" << endl;

    GLUTImageViewers::init(settings.getArgc(), settings.getArgv()); //only once

    // ImageOption : (boolean,boolean) : (isSelection,isAnimation)
    ImageOption zoomable(true);
    ImageOption nozoomable(false);

    //Viewer<MandelbrotProvider> mandelbrot(zoomable, 0, 0);
    //Viewer<RipplingProvider> rippling(nozoomable, 25, 25); // imageOption px py
    Viewer<RayTracingProvider> rayTracing(nozoomable, 25, 25); // imageOption px py

    // Common
    GLUTImageViewers::runALL(); // Bloquant, Tant qu'une fenetre est ouverte

    cout << "\n[Image] end" << endl;

    return EXIT_SUCCESS;
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

