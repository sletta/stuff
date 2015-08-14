#pragma once

#if defined(__APPLE__)
#include <OpenCL/opencl.h>
#else
#include <CL/opencl.h>
#endif

#include <iostream>
#include <iomanip>

#define DUMP_CL_DEVICE_BOOL_OPTION(device, name)                             \
    cl_bool __##name;                                                        \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    std::cout << #name << ' ' << setfill('.') << setw(35 - (int) strlen(#name)) << ": " << __##name << std::endl;

#define DUMP_CL_DEVICE_INT_OPTION(device, name)                              \
    cl_int __##name;                                                         \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    std::cout << #name << ' ' << setfill('.') << setw(35 - (int) strlen(#name)) << ": " << __##name << std::endl;

#define DUMP_CL_DEVICE_ULONG_OPTION(device, name)                            \
    cl_ulong __##name;                                                       \
    clGetDeviceInfo(device, name, sizeof(__##name), &__##name, 0);           \
    std::cout << #name << ' ' << setfill('.') << setw(35 - strlen(#name)) << ": " << __##name << std::endl;

#define DUMP_CL_DEVICE_STRING_OPTION(device, name)                           \
    char __##name[1024];                                                     \
    clGetDeviceInfo(device, name, sizeof(__##name), __##name, 0);            \
    std::cout << #name << ' ' << setfill('.') << setw(35 - strlen(#name)) << ": " << __##name << std::endl;

// This will expand to a lot of code, so probably not a good idea to have inline,
// but for now it is convenient...
inline void CL_CHECK_ERROR(cl_int error)
{
    if (error == CL_SUCCESS)
        return;
    const char *errorString;
    switch (error) {
        case CL_SUCCESS: errorString = "CL_SUCCESS"; break;
        case CL_DEVICE_NOT_FOUND: errorString = "CL_DEVICE_NOT_FOUND"; break;
        case CL_DEVICE_NOT_AVAILABLE: errorString = "CL_DEVICE_NOT_AVAILABLE"; break;
        case CL_COMPILER_NOT_AVAILABLE: errorString = "CL_COMPILER_NOT_AVAILABLE"; break;
        case CL_MEM_OBJECT_ALLOCATION_FAILURE: errorString = "CL_MEM_OBJECT_ALLOCATION_FAILURE"; break;
        case CL_OUT_OF_RESOURCES: errorString = "CL_OUT_OF_RESOURCES"; break;
        case CL_OUT_OF_HOST_MEMORY: errorString = "CL_OUT_OF_HOST_MEMORY"; break;
        case CL_PROFILING_INFO_NOT_AVAILABLE: errorString = "CL_PROFILING_INFO_NOT_AVAILABLE"; break;
        case CL_MEM_COPY_OVERLAP: errorString = "CL_MEM_COPY_OVERLAP"; break;
        case CL_IMAGE_FORMAT_MISMATCH: errorString = "CL_IMAGE_FORMAT_MISMATCH"; break;
        case CL_IMAGE_FORMAT_NOT_SUPPORTED: errorString = "CL_IMAGE_FORMAT_NOT_SUPPORTED"; break;
        case CL_BUILD_PROGRAM_FAILURE: errorString = "CL_BUILD_PROGRAM_FAILURE"; break;
        case CL_MAP_FAILURE: errorString = "CL_MAP_FAILURE"; break;
        case CL_MISALIGNED_SUB_BUFFER_OFFSET: errorString = "CL_MISALIGNED_SUB_BUFFER_OFFSET"; break;
        case CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST: errorString = "CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST"; break;
        case CL_COMPILE_PROGRAM_FAILURE: errorString = "CL_COMPILE_PROGRAM_FAILURE"; break;
        case CL_LINKER_NOT_AVAILABLE: errorString = "CL_LINKER_NOT_AVAILABLE"; break;
        case CL_LINK_PROGRAM_FAILURE: errorString = "CL_LINK_PROGRAM_FAILURE"; break;
        case CL_DEVICE_PARTITION_FAILED: errorString = "CL_DEVICE_PARTITION_FAILED"; break;
        case CL_KERNEL_ARG_INFO_NOT_AVAILABLE: errorString = "CL_KERNEL_ARG_INFO_NOT_AVAILABLE"; break;
        case CL_INVALID_VALUE: errorString = "CL_INVALID_VALUE"; break;
        case CL_INVALID_DEVICE_TYPE: errorString = "CL_INVALID_DEVICE_TYPE"; break;
        case CL_INVALID_PLATFORM: errorString = "CL_INVALID_PLATFORM"; break;
        case CL_INVALID_DEVICE: errorString = "CL_INVALID_DEVICE"; break;
        case CL_INVALID_CONTEXT: errorString = "CL_INVALID_CONTEXT"; break;
        case CL_INVALID_QUEUE_PROPERTIES: errorString = "CL_INVALID_QUEUE_PROPERTIES"; break;
        case CL_INVALID_COMMAND_QUEUE: errorString = "CL_INVALID_COMMAND_QUEUE"; break;
        case CL_INVALID_HOST_PTR: errorString = "CL_INVALID_HOST_PTR"; break;
        case CL_INVALID_MEM_OBJECT: errorString = "CL_INVALID_MEM_OBJECT"; break;
        case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR: errorString = "CL_INVALID_IMAGE_FORMAT_DESCRIPTOR"; break;
        case CL_INVALID_IMAGE_SIZE: errorString = "CL_INVALID_IMAGE_SIZE"; break;
        case CL_INVALID_SAMPLER: errorString = "CL_INVALID_SAMPLER"; break;
        case CL_INVALID_BINARY: errorString = "CL_INVALID_BINARY"; break;
        case CL_INVALID_BUILD_OPTIONS: errorString = "CL_INVALID_BUILD_OPTIONS"; break;
        case CL_INVALID_PROGRAM: errorString = "CL_INVALID_PROGRAM"; break;
        case CL_INVALID_PROGRAM_EXECUTABLE: errorString = "CL_INVALID_PROGRAM_EXECUTABLE"; break;
        case CL_INVALID_KERNEL_NAME: errorString = "CL_INVALID_KERNEL_NAME"; break;
        case CL_INVALID_KERNEL_DEFINITION: errorString = "CL_INVALID_KERNEL_DEFINITION"; break;
        case CL_INVALID_KERNEL: errorString = "CL_INVALID_KERNEL"; break;
        case CL_INVALID_ARG_INDEX: errorString = "CL_INVALID_ARG_INDEX"; break;
        case CL_INVALID_ARG_VALUE: errorString = "CL_INVALID_ARG_VALUE"; break;
        case CL_INVALID_ARG_SIZE: errorString = "CL_INVALID_ARG_SIZE"; break;
        case CL_INVALID_KERNEL_ARGS: errorString = "CL_INVALID_KERNEL_ARGS"; break;
        case CL_INVALID_WORK_DIMENSION: errorString = "CL_INVALID_WORK_DIMENSION"; break;
        case CL_INVALID_WORK_GROUP_SIZE: errorString = "CL_INVALID_WORK_GROUP_SIZE"; break;
        case CL_INVALID_WORK_ITEM_SIZE: errorString = "CL_INVALID_WORK_ITEM_SIZE"; break;
        case CL_INVALID_GLOBAL_OFFSET: errorString = "CL_INVALID_GLOBAL_OFFSET"; break;
        case CL_INVALID_EVENT_WAIT_LIST: errorString = "CL_INVALID_EVENT_WAIT_LIST"; break;
        case CL_INVALID_EVENT: errorString = "CL_INVALID_EVENT"; break;
        case CL_INVALID_OPERATION: errorString = "CL_INVALID_OPERATION"; break;
        case CL_INVALID_GL_OBJECT: errorString = "CL_INVALID_GL_OBJECT"; break;
        case CL_INVALID_BUFFER_SIZE: errorString = "CL_INVALID_BUFFER_SIZE"; break;
        case CL_INVALID_MIP_LEVEL: errorString = "CL_INVALID_MIP_LEVEL"; break;
        case CL_INVALID_GLOBAL_WORK_SIZE: errorString = "CL_INVALID_GLOBAL_WORK_SIZE"; break;
        case CL_INVALID_PROPERTY: errorString = "CL_INVALID_PROPERTY"; break;
        case CL_INVALID_IMAGE_DESCRIPTOR: errorString = "CL_INVALID_IMAGE_DESCRIPTOR"; break;
        case CL_INVALID_COMPILER_OPTIONS: errorString = "CL_INVALID_COMPILER_OPTIONS"; break;
        case CL_INVALID_LINKER_OPTIONS: errorString = "CL_INVALID_LINKER_OPTIONS"; break;
        case CL_INVALID_DEVICE_PARTITION_COUNT: errorString = "CL_INVALID_DEVICE_PARTITION_COUNT"; break;
        default: errorString = "unknown error"; break;
    }
    std::cerr << "OpenCL Error: code=" << error << "; " << errorString << std::endl;
    exit(1);
}