#include <stdlib.h>
#include <assert.h>
#include <iostream>

#include "cudaTools.h"
#include "Device.h"

#include "Settings_GPU.h"
using namespace gpu;

/*----------------------------------------------------------------------*\
 |*			Declaration 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Imported	 	*|
 \*-------------------------------------*/

extern int mainImageDemo(Settings& settings);

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

int main(int argc, char** argv);

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

static int use(Settings& option);
static int start(Settings& option);
static void initCuda(Settings& option);

/*----------------------------------------------------------------------*\
 |*			Implementation 					*|
 \*---------------------------------------------------------------------*/

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

int main(int argc, char** argv)
{
	int DEVICE_ID = 1;

	LaunchMode launchMode = LaunchMode::IMAGE; // IMAGE  ANIMABLE  BARIVOX FORCEBRUT
	Settings settings(launchMode, DEVICE_ID, argc, argv);

	return use(settings);
}

/*--------------------------------------*\
 |*		Public			*|
 \*-------------------------------------*/

int use(Settings& settings)
{
	if (Device::isCuda())
	{
		initCuda(settings);
		int isOk = start(settings);

		HANDLE_ERROR(cudaDeviceReset()); //cudaDeviceReset causes the driver to clean up all state. While not mandatory in normal operation, it is good practice.

		return isOk;
	}
	else
	{
		return EXIT_FAILURE;
	}
}

/*--------------------------------------*\
 |*		Private			*|
 \*-------------------------------------*/

void initCuda(Settings& settings)
{
	int deviceId = settings.getDeviceId();

	// Check deviceId area
	int nbDevice = Device::getDeviceCount();
	assert(deviceId >= 0 && deviceId < nbDevice);

	// Choose current device  (state of host-thread)
	HANDLE_ERROR(cudaSetDevice(deviceId));

	// It can be usefull to preload driver, by example to practice benchmarking! (sometimes slow under linux)
	Device::loadCudaDriver(deviceId);
	// Device::loadCudaDriverAll();// Force driver to be load for all GPU
}

int start(Settings& settings)
{
	// print
	{
		// Device::printAll();
		Device::printAllSimple();
		Device::printCurrent();
		//Device::print(option.getDeviceId());
	}

	return mainImageDemo(settings);
}

/*----------------------------------------------------------------------*\
 |*			End	 					*|
 \*---------------------------------------------------------------------*/

