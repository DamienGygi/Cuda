#include "Device.h"
#include <iostream>
#include "MonteCarlo.h"

using std::cout;
using std::endl;

extern __global__ void monteCarlo(curandState* tabDevGenerator, int nbFleches, float m,int* ptrDevNx);
extern __global__ void setup_kernel_rand(curandState* tabDevGenerator, int deviceId);

MonteCarlo::MonteCarlo(int nbFleches,int m,const Grid& grid) :
	nbFleches(nbFleches)
    {
    this->db=grid.db;
    this->dg=grid.dg;
    this->m=m;

    this->sizeOctetPi = sizeof(int);

    Device::malloc(&ptrDevNx, sizeOctetPi);
    Device::memclear(ptrDevNx, sizeOctetPi);

    this->sizeOctetSM = db.x * db.y * db.z * sizeof(int);

    int nbThread =grid.threadCounts();
    size_t sizeOctet= nbThread*sizeof(curandState) ;
    Device::malloc(&ptrDevGenerator, sizeOctet);
    Device::memclear(ptrDevGenerator, sizeOctet);

    setup_kernel_rand<<<dg,db>>>(ptrDevGenerator, Device::getDeviceId());

    }

MonteCarlo::~MonteCarlo(void)
    {
    Device::free(ptrDevNx);
    Device::free(ptrDevGenerator);
    }

void MonteCarlo::process()
    {
    //Device::lastCudaError("Slice (before)"); // temp debug
    monteCarlo<<<dg,db, sizeOctetSM>>>(ptrDevGenerator, nbFleches,m,ptrDevNx);// assynchrone
    //Device::lastCudaError("Slice (after)"); // temp debug
    Device::memcpyDToH(&piTest, ptrDevNx, sizeOctetPi);
    pi=(float)piTest/nbFleches*m;
    //cudaMemcpy(&pi, ptrDevNx, sizeOctetPi, cudaMemcpyDeviceToHost); // barriere synchronisation implicite
    //pi /= nbFleches;
    }

float MonteCarlo::getPi()
    {
    return this->pi;
    }
