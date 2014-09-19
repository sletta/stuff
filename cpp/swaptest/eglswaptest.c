/*
    Copyright (c) 2014, Gunnar Sletta
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/* Suggested compile command:
 *
 * > gcc eglswaptest.c -g -lEGL -lGLESv2 -o eglswaptest
 *
 */

#include <sys/time.h>
#include <stdlib.h>
#include <unistd.h>
#include <EGL/egl.h>
#include <GLES2/gl2.h>
#include <stdio.h>

static EGLint const MY_EGL_CONFIG_ATTRIBUTES[] = {
    EGL_RED_SIZE, 8,
    EGL_GREEN_SIZE, 8,
    EGL_BLUE_SIZE, 8,
    EGL_ALPHA_SIZE, 8,
    EGL_NONE, EGL_NONE
};

static EGLint const MY_GL_CONTEXT_ATTRIBUTES[] = {
    EGL_CONTEXT_CLIENT_VERSION, 2,
    EGL_NONE
};

int timeSince(struct timeval *t)
{
    struct timeval tt;
    gettimeofday(&tt, 0);
    return (tt.tv_sec - t->tv_sec) * 1000 + (tt.tv_usec - t->tv_usec) / 1000;
}

int main(int argc, char ** argv)
{
    EGLDisplay display;
    EGLConfig config;
    EGLContext context;
    EGLSurface surface;
    EGLint num_config;
    struct timeval startTime;
    int frameCount;
    int majorVersion, minorVersion;
    int runningTime;

    display = eglGetDisplay(EGL_DEFAULT_DISPLAY);

    eglInitialize(display, &majorVersion, &minorVersion);
    printf("EGL Initialized: v%d.%d\n", majorVersion, minorVersion);

    eglBindAPI(EGL_OPENGL_ES_API);

    eglChooseConfig(display, MY_EGL_CONFIG_ATTRIBUTES, &config, 1, &num_config);
    context = eglCreateContext(display, config, EGL_NO_CONTEXT, MY_GL_CONTEXT_ATTRIBUTES);
    printf("EGLContext: %p\n"
           "EGLConfig: %p\n"
           "EGLDisplay: %p\n",
           context, config, display);

    // Assumes that 0 is a valid native window handle. This will be the case on
    // many embedded systems, but not the case under X nor Android.
    surface = eglCreateWindowSurface(display, config, 0, NULL);
    printf("EGLSurface: %p\n", surface);
    eglMakeCurrent(display, surface, surface, context);
    eglSwapInterval(display, 1);

    printf("GL_RENDERER: %s\n", glGetString(GL_RENDERER));
    printf("GL_VERSION: %s\n", glGetString(GL_VERSION));
    printf("GL_VENDOR: %s\n", glGetString(GL_VENDOR));

   gettimeofday(&startTime, 0);
   frameCount = 0;
   while (timeSince(&startTime) < 10000) {
       int c = ++frameCount % 2;
       glClearColor(c, 0, 1 - c, 1.0);
       glClear(GL_COLOR_BUFFER_BIT);
       eglSwapBuffers(display, surface);
   }

   runningTime = timeSince(&startTime);
   printf("%d frames in %d ms; %f fps, %f ms/frame\n",
          frameCount,
          runningTime,
          frameCount * 1000 / (float) runningTime,
          runningTime / (float) frameCount);

    return 0;
}
