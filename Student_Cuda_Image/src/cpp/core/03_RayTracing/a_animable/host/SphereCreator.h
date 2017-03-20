#pragma once
#include "Sphere.h"

class SphereCreator
    {
	/*--------------------------------------*\
	|*		Constructor		 *|
	 \*-------------------------------------*/
    public:
	SphereCreator(int nbSpheres, int w, int h, int bord);
	virtual ~SphereCreator(void);
	/*--------------------------------------*\
	|*		 Methodes 		*|
	 \*-------------------------------------*/
    public:
	Sphere* getTabSphere();
    private:
	void createSphere(void);
	/*--------------------------------------*\
	|*		 Attributs		*|
	 \*-------------------------------------*/
    private:
	// Inputs
	int nbSpheres;
	int w;
	int h;
	int bord;

	// Tools
	Sphere* tabSphere;
    };
