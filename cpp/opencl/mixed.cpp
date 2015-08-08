#include <OpenCL/opencl.h>
#include "openclhelpers.h"

#include <GLFW/glfw3.h>

#include <iostream>

using namespace std;

void openclErrorCallback(const char *errinfo, const void *privateInfo, size_t cb, void *userData)
{
    cout << "CL ERROR: '" << errinfo << "'" << endl;
}

void glfwErrorCallback(int error, const char *description)
{
    cout << "GLFW ERROR (" << error << "): " << description << endl;
}

int main(int argc, char *argv[])
{
     // OpenGL setup
    if (!glfwInit())
        exit(EXIT_FAILURE);
    glfwSetErrorCallback(glfwErrorCallback);
    cout << "GLFW initialized!" << endl;
    GLFWwindow *window = glfwCreateWindow(640, 480, "My Title", NULL, NULL);
    cout << "GLFWwindow: " << window << endl;
    glfwMakeContextCurrent(window);
    cout << "OpenGL Context is current!" << endl;
    cout << "GL_RENDERER ...: " << glGetString(GL_RENDERER) << endl;
    cout << "GL_VENDOR .....: " << glGetString(GL_VENDOR) << endl;
    cout << "GL_VERSION ....: " << glGetString(GL_VERSION) << endl;
    cout << "GL_EXTENSIONS .: " << glGetString(GL_EXTENSIONS) << endl;

    // OpenCL setup
    cl_device_id devices[4];
    cl_uint deviceCount = 0;
    clGetDeviceIDs(0, CL_DEVICE_TYPE_GPU, sizeof(devices), devices, &deviceCount);
    cout << "OpenCL GPU devices found: " << deviceCount << endl;

    const int deviceId = 0;
    DUMP_CL_DEVICE_STRING_OPTION(devices[deviceId], CL_DEVICE_NAME);
    DUMP_CL_DEVICE_STRING_OPTION(devices[deviceId], CL_DEVICE_VENDOR);
    DUMP_CL_DEVICE_STRING_OPTION(devices[deviceId], CL_DEVICE_VERSION);
    DUMP_CL_DEVICE_STRING_OPTION(devices[deviceId], CL_DRIVER_VERSION);
    DUMP_CL_DEVICE_BOOL_OPTION(devices[deviceId], CL_DEVICE_AVAILABLE);
    DUMP_CL_DEVICE_BOOL_OPTION(devices[deviceId], CL_DEVICE_COMPILER_AVAILABLE);
    DUMP_CL_DEVICE_INT_OPTION(devices[deviceId], CL_DEVICE_MAX_COMPUTE_UNITS);
    DUMP_CL_DEVICE_INT_OPTION(devices[deviceId], CL_DEVICE_MAX_CLOCK_FREQUENCY);
    DUMP_CL_DEVICE_ULONG_OPTION(devices[deviceId], CL_DEVICE_LOCAL_MEM_SIZE);
    DUMP_CL_DEVICE_ULONG_OPTION(devices[deviceId], CL_DEVICE_GLOBAL_MEM_SIZE);
    DUMP_CL_DEVICE_STRING_OPTION(devices[deviceId], CL_DEVICE_EXTENSIONS);

    cl_int error;
    cl_context_properties clProperties[] = {
        0
    };
    cl_context clContext = clCreateContext(0, 1, &devices[deviceId], 0, 0, &error);
    cout << "OpenCL Context: " << clContext << endl;
    if (error != CL_SUCCESS) {
        cout << "Epic failure when creating OpenCL Context....: " << error << " (0x" << hex << error << ")" << endl;
        return 0;
    }

    int frameCounter = 1000;
    while (!glfwWindowShouldClose(window) && --frameCounter > 0)
    {
        float color = frameCounter % 2;
        glClearColor(color, 0, 1.0 - color, 1);
        glClear(GL_COLOR_BUFFER_BIT);

        glfwSwapBuffers(window);
        glfwPollEvents();
    }
    glfwDestroyWindow(window);
    glfwTerminate();

    return 0;
}

// Building...
//
// OSX: clang++ -framework OpenCL -framework OpenGL -I/usr/local/include mixed.cpp -L/usr/local/lib -lglfw3  -o mixed && ./mixed
//
//

