#include "openclhelpers.h"

#include <iostream>

using namespace std;

#define DUMP_BOOL_OPTION(device, name)                                       \
    cl_bool __##name;                                                        \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    cout << " - " << #name << ": " << __##name << endl;

#define DUMP_INT_OPTION(device, name)                                        \
    cl_int __##name;                                                         \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    cout << " - " << #name << ": " << __##name << endl;

#define DUMP_ULONG_OPTION(device, name)                                        \
    cl_ulong __##name;                                                       \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    cout << " - " << #name << ": " << __##name << endl;

#define DUMP_STRING_OPTION(device, name)                                     \
    char __##name[1024];                                                     \
    clGetDeviceInfo(device, name, sizeof(__##name), __##name, 0);            \
    cout << " - " << #name << ": " << __##name << endl;

int main(int argc, char **argv)
{
    cout << "OpenCL Info: " << endl;
    cl_device_id devices[16];
    cl_uint deviceCount = 0;
    clGetDeviceIDs(0, CL_DEVICE_TYPE_ALL, sizeof(devices), devices, &deviceCount);

    cout << "Number of devices: " << deviceCount << endl;

    for (int i=0; i<deviceCount; ++i) {

        const cl_device_id &dev = devices[i];

        cout << "Device #" << i << ": " << endl;

        DUMP_STRING_OPTION(devices[i], CL_DEVICE_NAME);
        DUMP_STRING_OPTION(devices[i], CL_DEVICE_VENDOR);
        DUMP_STRING_OPTION(devices[i], CL_DEVICE_VERSION);
        DUMP_STRING_OPTION(devices[i], CL_DRIVER_VERSION);

        DUMP_BOOL_OPTION(devices[i], CL_DEVICE_AVAILABLE);
        DUMP_BOOL_OPTION(devices[i], CL_DEVICE_COMPILER_AVAILABLE);

        DUMP_INT_OPTION(devices[i], CL_DEVICE_MAX_COMPUTE_UNITS);
        DUMP_INT_OPTION(devices[i], CL_DEVICE_MAX_CLOCK_FREQUENCY);

        DUMP_ULONG_OPTION(devices[i], CL_DEVICE_LOCAL_MEM_SIZE);
        DUMP_ULONG_OPTION(devices[i], CL_DEVICE_GLOBAL_MEM_SIZE);

        DUMP_INT_OPTION(devices[i], CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR);
        DUMP_INT_OPTION(devices[i], CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT);
        DUMP_INT_OPTION(devices[i], CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT);
        DUMP_INT_OPTION(devices[i], CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG);
        DUMP_INT_OPTION(devices[i], CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT);
        DUMP_INT_OPTION(devices[i], CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE);

        DUMP_STRING_OPTION(devices[i], CL_DEVICE_EXTENSIONS);
    }

    return 0;
}