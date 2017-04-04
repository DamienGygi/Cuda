#include "Device.h"
#include <iostream>
#include "MonteCarlo.h"

using std::cout;
using std::endl;

extern __global__ void monteCarlo(curandState* tabDevGenerator, int nbFleches, float m,int* ptrDevNx);

MonteCarlo::MonteCarlo(int nbFleches,int m,dim3 dg,dim3 db) :
	nbFleches(nbFleches)
    {
    this->db=db;
    this->dg=dg;
    Grid grid(dg,db);
    this->sizeOctetPi = sizeof(int);
    cudaMalloc(&ptrDevNx, sizeOctetPi);
    cudaMemset(ptrDevNx, 0, sizeOctetPi);
    this->sizeOctetSM = db.x * db.y * db.z * sizeof(int);

    int nbThread =grid.threadCounts();
    size_t sizeOctet= nbThread*sizeof(curandState) ;
    curandState* ptrDevGenerator=NULL;
    cudaMalloc(&ptrDevGenerator, sizeOctet);
    }

MonteCarlo::~MonteCarlo(void)
    {
    cudaFree (ptrDevNx);
    }

void MonteCarlo::process()
    {
    //Device::lastCudaError("Slice (before)"); // temp debug
    monteCarlo<<<dg,db, sizeOctetSM>>>(tabDevGenerator, nbFleches,m,ptrDevNx);// assynchrone
    //Device::lastCudaError("Slice (after)"); // temp debug
    cudaMemcpy(&pi, ptrDevNx, sizeOctetPi, cudaMemcpyDeviceToHost); // barriere synchronisation implicite
    //pi /= nbFleches;
    }

float MonteCarlo::getPi()
    {
    return this->pi;
    }
