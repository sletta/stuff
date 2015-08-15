
#include "openglhelpers.h"
#include "openclhelpers.h"

#include <iostream>
#include <cmath>

using namespace std;

// Globals, put here for convenience...

// GLFW (windowing stuff)
static GLFWwindow *window;
static int windowWidth;
static int windowHeight;

// OpenGL
static GLuint framebuffer;
static GLuint framebufferTexture;
static GLuint resultTexture;
static GLuint fractalProgram;
static GLuint fractalUniformC;
static GLuint textureQuadBuffer;
static GLuint blitProgram;

// OpenCL
static struct {
    cl_device_id device;
    cl_context context;
    cl_command_queue commandQueue;
    cl_mem sourceImage;
    cl_mem targetImage;
} cl;

static void openclErrorCallback(const char *errinfo, const void *privateInfo, size_t cb, void *userData)
{
    cout << "CL ERROR: '" << errinfo << "'" << endl;
}

void glfwErrorCallback(int error, const char *description)
{
    cout << "GLFW ERROR (" << error << "): " << description << endl;
}

static void initialize_opencl() {

    // OpenCL setup
    cl_platform_id platforms[16];
    cl_uint platformCount;
    clGetPlatformIDs(sizeof(platforms) / sizeof(cl_platform_id), platforms, &platformCount);
    cout << "OpenCL Platforms found: " << platformCount << endl;
    assert(platformCount > 0);

    cl_uint deviceCount = 0;
    clGetDeviceIDs(platforms[0], CL_DEVICE_TYPE_GPU, sizeof(cl.device), &cl.device, &deviceCount);
    assert(deviceCount);
    cout << "OpenCL GPU devices found: " << deviceCount << endl;

    DUMP_CL_DEVICE_STRING_OPTION(cl.device, CL_DEVICE_NAME);
    DUMP_CL_DEVICE_STRING_OPTION(cl.device, CL_DEVICE_VENDOR);
    DUMP_CL_DEVICE_STRING_OPTION(cl.device, CL_DEVICE_VERSION);
    DUMP_CL_DEVICE_STRING_OPTION(cl.device, CL_DRIVER_VERSION);
    DUMP_CL_DEVICE_BOOL_OPTION(cl.device, CL_DEVICE_AVAILABLE);
    DUMP_CL_DEVICE_BOOL_OPTION(cl.device, CL_DEVICE_COMPILER_AVAILABLE);
    DUMP_CL_DEVICE_INT_OPTION(cl.device, CL_DEVICE_MAX_COMPUTE_UNITS);
    DUMP_CL_DEVICE_INT_OPTION(cl.device, CL_DEVICE_MAX_CLOCK_FREQUENCY);
    DUMP_CL_DEVICE_ULONG_OPTION(cl.device, CL_DEVICE_LOCAL_MEM_SIZE);
    DUMP_CL_DEVICE_ULONG_OPTION(cl.device, CL_DEVICE_GLOBAL_MEM_SIZE);
    DUMP_CL_DEVICE_STRING_OPTION(cl.device, CL_DEVICE_EXTENSIONS);

    cout << "OpenCL Objects:" << endl;

    // OpenCL context
    cl_int error;
#ifdef __APPLE__
    CGLContextObj kCGLContext = CGLGetCurrentContext();
    CGLShareGroupObj kCGLShareGroup = CGLGetShareGroup(kCGLContext);
    cl_context_properties clProperties[] =
    {
        CL_CONTEXT_PROPERTY_USE_CGL_SHAREGROUP_APPLE, (cl_context_properties)kCGLShareGroup,
        0
    };
#else
     cl_context_properties clProperties[] = {
        CL_GL_CONTEXT_KHR, (cl_context_properties) glXGetCurrentContext(),
        CL_GLX_DISPLAY_KHR, (cl_context_properties) glXGetCurrentDisplay(),
        0
    };
#endif
    cl.context = clCreateContext(clProperties, 1, &cl.device, openclErrorCallback, 0, &error);
    CL_CHECK_ERROR(error);
    cout << " - context ............: " << cl.context << endl;

    // OpenCL command queue...
    cl.commandQueue = clCreateCommandQueue(cl.context, cl.device, CL_QUEUE_PROFILING_ENABLE, &error);
    CL_CHECK_ERROR(error);
    cout << " - command queue ......: " << cl.commandQueue << endl;

    cl.sourceImage = clCreateFromGLTexture(cl.context, CL_MEM_READ_ONLY, GL_TEXTURE_2D, 0, framebufferTexture, &error);
    CL_CHECK_ERROR(error);
    cout << " - source image mem ...: " << cl.sourceImage << endl;
    cl.targetImage = clCreateFromGLTexture(cl.context, CL_MEM_WRITE_ONLY, GL_TEXTURE_2D, 0, resultTexture, &error);
    CL_CHECK_ERROR(error);
    cout << " - target image mem ...: " << cl.targetImage << endl;
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
    glfwGetFramebufferSize(window, &windowWidth, &windowHeight);

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

    resultTexture = gl_create_texture(windowWidth, windowHeight, 0);
    cout << " - result texture ....: " << resultTexture << endl;

    cout << endl;

    glFinish();
}

static void renderToFramebuffer()
{
    // Prepare to draw frame, initial setup..
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

    // Render the FBO to the screen..
    // attribute arrays and buffer can be reused, so leave them be
    glBindTexture(GL_TEXTURE_2D, framebufferTexture);
    glUseProgram(blitProgram);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    // Reset to default state
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
    initialize_opencl();

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

