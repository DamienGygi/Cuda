#include "MonteCarloMultiGPU.h"
#include "MonteCarlo.h"

#include "Device.h"
#include <iostream>

using std::cout;
using std::endl;

extern __global__ void monteCarlo(curandState* tabDevGenerator, int nbFleches, float m,int* ptrDevNx);
extern __global__ void setup_kernel_rand(curandState* tabDevGenerator, int deviceId);

MonteCarloMultiGPU::MonteCarloMultiGPU(int nbFleches,int m,const Grid& grid) :
	nbFleches(nbFleches)
    {
    this->db=grid.db;
    this->dg=grid.dg;
    this->m=m;
    this->grid=grid;

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

MonteCarloMultiGPU::~MonteCarloMultiGPU(void)
    {
    Device::free(ptrDevNx);
    Device::free(ptrDevGenerator);
    }

void MonteCarloMultiGPU::process()
    {
    int nbDevice=Device::getDeviceCount();
    int nbFlechesGPU=nbFleches/nbDevice;
    int totalResult;

    #pragma omp parallel for reduction(+:totalResult)
	for(int deviceId=0;deviceId<nbDevice;deviceId++)
	    {
		Device::setDevice(deviceId);
		MonteCarlo monteCarlo(nbFlechesGPU,m,grid);
		monteCarlo.process();
		totalResult+=monteCarlo.getPi();
	    }
    pi=totalResult;
    //pi /= nbFleches;
    }

float MonteCarloMultiGPU::getPi()
    {
    return this->pi;
    }
