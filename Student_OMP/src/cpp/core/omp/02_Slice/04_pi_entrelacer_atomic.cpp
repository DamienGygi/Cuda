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

bool isPiOMPEntrelacerAtomic_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPEntrelacerAtomic(int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPEntrelacerAtomic_Ok(int n)
    {
    return isAlgoPI_OK(piOMPEntrelacerAtomic,  n, "Pi OMP Entrelacer atomic");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * Bonne performance, si!
 */
double piOMPEntrelacerAtomic(int n)
    {
	//TODO
	const double DX =1/(double)n;
	const int NB_THREAD=OmpTools::setAndGetNaturalGranularity();
	double sumGlobal=0;

	#pragma omp parallel shared(sumGlobal) //la variable sumGlobal est partagé par tout les threads, optionnels car comportement par défaut
	{
	    const int TID = OmpTools::getTid();
	    int s = TID;
	    double sumLocal=0;
	    while(s<n)
		{

		    double xs = s *DX;
		    sumLocal += fpi(xs);
		    s+=NB_THREAD;
		}
	    #pragma omp atomic // atomic protege uniquement le prochain opérateur mathématique
	    sumGlobal+=sumLocal;
	}

	return sumGlobal*DX;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

