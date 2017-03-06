#include <omp.h>
#include "MathTools.h"
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

bool isPiOMPforPromotionTab_Ok(int n);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static double piOMPforPromotionTab(int n);
static void syntaxeSimplifier(double* tabSumThread,int n);
static void syntaxeFull(double* tabSumThread,int n);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

bool isPiOMPforPromotionTab_Ok(int n)
    {
    return isAlgoPI_OK(piOMPforPromotionTab, n, "Pi OMP for promotion tab");
    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/**
 * De-synchronisation avec PromotionTab
 */
double piOMPforPromotionTab(int n)
    {
    const double DX =1/(double)n;
    const int NB_THREAD=OmpTools::setAndGetNaturalGranularity();
    double* tab = new double [NB_THREAD]; // tableau sur le tas

    #pragma omp parallel for // initialisation du tableau en parralele
    for(int i=0;i<NB_THREAD;i++)
	{
	    tab[i]=0;
	}

    #pragma omp parallel for // fait la boucle en parralele
    for(int i=0;i<=n;i++)
	{
	    const int TID = OmpTools::getTid();
	    double xi = i *DX;
	    tab[TID]+= fpi(xi);
	}

    //reduction additive sequentielle
    double sumGlobal=0;
    //Reduction sequentielle
    for(int i=0;i<=NB_THREAD;i++)
	{
	    sumGlobal+=tab[i];
	}
    delete[] tab;
    return sumGlobal*DX;
    }



/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

