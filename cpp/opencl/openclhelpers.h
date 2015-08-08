#pragma once

#define DUMP_CL_DEVICE_BOOL_OPTION(device, name)                             \
    cl_bool __##name;                                                        \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    cout << " - " << #name << ": " << __##name << endl;

#define DUMP_CL_DEVICE_INT_OPTION(device, name)                              \
    cl_int __##name;                                                         \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    cout << " - " << #name << ": " << __##name << endl;

#define DUMP_CL_DEVICE_ULONG_OPTION(device, name)                            \
    cl_ulong __##name;                                                       \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    cout << " - " << #name << ": " << __##name << endl;

#define DUMP_CL_DEVICE_STRING_OPTION(device, name)                           \
    char __##name[1024];                                                     \
    clGetDeviceInfo(device, name, sizeof(__##name), __##name, 0);            \
    cout << " - " << #name << ": " << __##name << endl;

