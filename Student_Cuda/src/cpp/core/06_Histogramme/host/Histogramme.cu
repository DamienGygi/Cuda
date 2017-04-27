#include "../../06_Histogramme/host/Histogramme.h"

#include <iostream>

#include "Device.h"
#include "AleaTools.h"

using std::cout;
using std::endl;


/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern __global__ void histogramme(int* ptrTabPixelsGM, uint nbPixels, int* ptrGM);

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Constructeur			*|
 \*-------------------------------------*/

Histogramme::Histogramme(const Grid& grid, int* ptrResult, int max)
    {

    this->max = max;
    this->n = max * (max + 1) / 2;
    this->nbShuffles = n * 10;
    this->datas = new int[n];

    dataCreate();
    dataShuffle();

    this->nbPixels= this->n;
    this->data = this->datas;

    this->ptrResult = ptrResult;

    this->sizeOctetResult = sizeof(int) * max;
    this->sizeOctetData = sizeof(int) * this->nbPixels;

    Device::malloc(&ptrTabIn, sizeOctetData);
    Device::memclear(ptrTabIn, sizeOctetData);
    Device::memcpyHToD(ptrTabIn, data, sizeOctetData);
    Device::malloc(&ptrTabOut, sizeOctetResult);
    Device::memclear(ptrTabOut, sizeOctetResult);

    this->dg = grid.dg;
    this->db = grid.db;

    }

Histogramme::~Histogramme(void)
    {
	Device::free(ptrTabOut);
	Device::free(ptrTabIn);
    }

/*--------------------------------------*\
 |*		Methode			*|
 \*-------------------------------------*/

void Histogramme::run()
    {

    histogramme<<<dg,db, sizeOctetResult>>>(ptrTabIn, nbPixels, ptrTabOut);
    Device::synchronize();
    Device::memcpyDToH(ptrResult, ptrTabOut, sizeOctetResult);

    }

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/
void Histogramme::dataCreate(void)
    {
    int s = 0;
    for (int i = 0; i < max; i++)
	{
	for (int j = 1; j <= i + 1; j++)
	    {
	    datas[s] = i;
	    //assert(i >= 0 && i <= max);
	    //assert(s < n);
	    s++;
	    }
	}
    //assert(s == n);
    }
void Histogramme::dataShuffle()
    {
    AleaTools aleaTools = AleaTools();
    for (int i = 1; i <= nbShuffles; i++)
	{
	int first = aleaTools.uniformeAB(0, n - 1);
	int second = aleaTools.uniformeAB(0, n - 1);
	swap(first, second);
	}
    }
void Histogramme::swap(int i, int j)
    {
    //assert(i >= 0 && i < n);
    //assert(j >= 0 && j < n);
    int temp = datas[i];
    datas[i] = datas[j];
    datas[j] = temp;
    }

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/
