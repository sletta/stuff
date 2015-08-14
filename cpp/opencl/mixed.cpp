
#include "openclhelpers.h"
#include "openglhelpers.h"

#include <iostream>
#include <cmath>

using namespace std;

// Globals, put here for convenience...
static GLFWwindow *window;
static int windowWidth;
static int windowHeight;
static GLuint framebuffer;
static GLuint framebufferTexture;
static GLuint fractalProgram;
static GLuint fractalUniformC;
static GLuint textureQuadBuffer;
static GLuint blitProgram;

static void openclErrorCallback(const char *errinfo, const void *privateInfo, size_t cb, void *userData)
{
    cout << "CL ERROR: '" << errinfo << "'" << endl;
}

void glfwErrorCallback(int error, const char *description)
{
    cout << "GLFW ERROR (" << error << "): " << description << endl;
}

static void setup_cl() {
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
        return;
    }
}

static void initialize_opengl()
{
     // OpenGL setup
    if (!glfwInit()) {
        cerr << "glfwInit: failed!!" << endl;       
        exit(1);
    }
    glfwSetErrorCallback(glfwErrorCallback);
    cout << "GLFW initialized!" << endl;
    window = glfwCreateWindow(1280, 720, "Mixing OpenGL & OpenCL", NULL, NULL);
    glfwGetWindowSize(window, &windowWidth, &windowHeight);
    cout << "GLFWwindow ....: " << window << "; size=" << windowWidth << "," << windowHeight << endl;
    glfwMakeContextCurrent(window);
    cout << "OpenGL Context is current!" << endl;
    cout << "GL_RENDERER ...: " << glGetString(GL_RENDERER) << endl;
    cout << "GL_VENDOR .....: " << glGetString(GL_VENDOR) << endl;
    cout << "GL_VERSION ....: " << glGetString(GL_VERSION) << endl;
    cout << "GL_EXTENSIONS .: " << glGetString(GL_EXTENSIONS) << endl;
    cout << endl;

    glewExperimental=GL_TRUE;
    GLenum err = glewInit();
    if (err != GLEW_OK) {
        cerr << "glewInit: failed!" << glewGetErrorString(err) << endl;
        exit(1);       
    }
    cout << "GLEW initialized!" << endl << endl;

    cout << "OpenGL Objects:" << endl;
    framebuffer = gl_create_framebufferobject(windowWidth, windowHeight, &framebufferTexture);
    cout << " - framebuffer .......: " << framebuffer 
         << " (texture=" << framebufferTexture << ")" << endl;
    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    const char *fractalAttributes[] = { "aV", "aTC", 0 };
    fractalProgram = gl_create_program(// Vertex Shader
                                      "\n attribute vec4 aV;"
                                      "\n attribute vec2 aTC;"
                                      "\n varying vec2 vTC;"
                                      "\n void main() {"
                                      "\n     gl_Position = aV;"
                                      "\n     vTC = 3.0 * (aTC - 0.5);"
                                      "\n }",
                                      // Fragment Shader
                                      "\n uniform vec2 c;"
                                      "\n varying vec2 vTC;"
                                      "\n #define ITERATIONS 50"
                                      "\n void main() {"
                                      "\n      vec2 z = vTC;"
                                      "\n     int i;"
                                      "\n     for (i=0; i<ITERATIONS; ++i) {"
                                      "\n         float x = (z.x * z.x - z.y * z.y) + c.x;"
                                      "\n         float y = (z.y * z.x + z.x * z.y) + c.y;"
                                      "\n         if (x*x + y*y > 4.0) break;"
                                      "\n         z = vec2(x,y);"
                                      "\n     }"
                                      "\n     float v = i == ITERATIONS ? 0.0 : pow(float(i) / float(ITERATIONS), 0.5);"
                                      "\n     gl_FragColor = vec4(v * vec3(v, v*v, 1), 1);"
                                      "\n }", 
                                      fractalAttributes);
    cout << " - fractal shader ....: " << fractalProgram << endl;

    const char *blitAttributes[] = { "aV", "aTC", 0 };
    blitProgram = gl_create_program(// Vertex Shader
                                    "\n attribute vec2 aV;"
                                    "\n attribute vec2 aTC;"
                                    "\n varying vec2 vTC;"
                                    "\n void main() {"
                                    "\n     gl_Position = vec4(aV, 0, 1);"
                                    "\n     vTC = aTC;"
                                    "\n }",
                                    // Fragment Shader
                                    "\n uniform sampler2D T;"
                                    "\n varying vec2 vTC;"
                                    "\n void main() {"
                                    "\n     gl_FragColor = texture2D(T, vTC);"
                                    "\n }", 
                                    blitAttributes);
    cout << " - blit shader .......: " << blitProgram << endl;

    glGenBuffers(1, &textureQuadBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, textureQuadBuffer);
    float data[] = { -1, -1, 0, 0, 
                      1, -1, 1, 0,
                     -1,  1, 0, 1,
                      1,  1, 1, 1 };
    glBufferData(GL_ARRAY_BUFFER, sizeof(data), data, GL_STATIC_DRAW);
    cout << " - vertex buffer .....: " << textureQuadBuffer << endl;

}

static void renderToFramebuffer()
{
    glViewport(0, 0, windowWidth, windowHeight);
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);

    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);


    // Render the fractal to the FBO
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glUseProgram(fractalProgram);
    static double t = 0; 
    t += 0.01;
    float cx = sin(t) * 0.5;
    float cy = cos(t);
    glUniform2f(fractalUniformC, cx, cy);
    glBindBuffer(GL_ARRAY_BUFFER, textureQuadBuffer);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 4, 0);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 4, (void *) (sizeof(float) * 2));
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);

    // Optionally, render the FBO to the screen...
    glBindTexture(GL_TEXTURE_2D, framebufferTexture);
    glUseProgram(blitProgram);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glUseProgram(0);
}

int main(int argc, char *argv[])
{
    initialize_opengl();

    while (!glfwWindowShouldClose(window))
    {
        renderToFramebuffer();
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
// Linux: g++ mixed.cpp -lOpenCL -lglfw -lGL -o mixed
//

