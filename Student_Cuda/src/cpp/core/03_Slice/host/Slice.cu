#include "Slice.h"

#include "Device.h"
#include <iostream>

using std::cout;
using std::endl;

extern __global__ void slice(float* ptrDevPi, int nbSlice);

Slice::Slice(int nbSlice,dim3 dg,dim3 db) :
	nbSlice(nbSlice)
    {
    this->db=db;
    this->dg=dg;
    this->sizeOctetPi = sizeof(float);
    cudaMalloc(&ptrDevPi, sizeOctetPi);
    cudaMemset(ptrDevPi, 0, sizeOctetPi);
    Device::gridHeuristic(dg, db);
    this->sizeOctetSM = db.x * db.y * db.z * sizeof(float);
    }

Slice::~Slice(void)
    {
    cudaFree (ptrDevPi);
    }

void Slice::process()
    {
    //Device::lastCudaError("Slice (before)"); // temp debug
    slice<<<dg,db, sizeOctetSM>>>(ptrDevPi, nbSlice);// assynchrone
    //Device::lastCudaError("Slice (after)"); // temp debug
    cudaMemcpy(&pi, ptrDevPi, sizeOctetPi, cudaMemcpyDeviceToHost); // barriere synchronisation implicite
    pi /= nbSlice;
    }

float Slice::getPi()
    {
    return this->pi;
    }
