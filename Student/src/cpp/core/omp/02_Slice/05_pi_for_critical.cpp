#include <omp.h>
#include "OmpTools.h"
#include "../02_Slice/00_pi_tools.h"

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/



/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPforCritical_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPforCritique(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPforCritical_Ok(int n)
    {
    return isAlgoPI_OK(piOMPforCritique, n, "Pi OMP for critique");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * synchronisation couteuse!
 */
double piOMPforCritique(int n)
    {
    double sum=0;
    const double DX =1/(double)n;
    //double xi;
    //#pragma omp parallel for private(xi)
    #pragma omp parallel for // fait la boucle en parralele
    for(int i=0;i<=n;i++)
	{
	    double xi = i *DX;
	    // xi = i* DX;
	    #pragma omp critical (ab)
	    {
		sum+= fpi(xi);
	    }
	}
    return sum*DX;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

