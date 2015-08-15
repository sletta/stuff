#pragma once

#include <GL/glew.h>
#include <GLFW/glfw3.h>

#ifdef __APPLE__
#include <OpenGL/OpenGL.h>
#else
#include <GL/glx.h>
#endif

#include <iostream>
#include <cassert>
#include <cstring>

inline GLuint gl_create_shader(const char *sh, GLenum type)
{
    GLuint id = glCreateShader(type);
    int len = std::strlen(sh);
    glShaderSource(id, 1, &sh, &len);
    glCompileShader(id);
    int param = 0;
    glGetShaderiv(id, GL_COMPILE_STATUS, &param);
    if (param == GL_FALSE) {
        glGetShaderiv(id, GL_INFO_LOG_LENGTH, &param);
        char *str = (char *) malloc(param + 1);
        int l = 0;
        glGetShaderInfoLog(id, param, &l, str);
        assert(l < param);
        str[l] = '\0';
        std::cout << "error: Failed to compile shader: " << (type == GL_VERTEX_SHADER ? "vertex" : "fragment") << std::endl
             << sh << std::endl
             << "error: " << str << std::endl;
        free(str);
        assert(false);
    }
    return id;
}

inline GLuint gl_create_program(const char *vsh, const char *fsh, const char *attr[])
{
    GLuint vid = gl_create_shader(vsh, GL_VERTEX_SHADER);
    assert(vid);

    GLuint fid = gl_create_shader(fsh, GL_FRAGMENT_SHADER);
    assert(fid);

    GLuint pid = glCreateProgram();
    assert(pid);

    glAttachShader(pid, vid);
    glAttachShader(pid, fid);
    for (unsigned i=0; attr[i]; ++i)
        glBindAttribLocation(pid, i, attr[i]);
    glLinkProgram(pid);

    int param = 0;
    glGetProgramiv(pid, GL_LINK_STATUS, &param);
    if (param == GL_FALSE) {
        glGetProgramiv(pid, GL_INFO_LOG_LENGTH, &param);
        char *str = (char *) malloc(param + 1);
        int l = 0;
        glGetProgramInfoLog(pid, param, &l, str);
        assert(l < param);
        str[l] = '\0';
        std::cerr << "error: Failed to link shader program:" << std::endl
                  << "Vertex Shader:" << std::endl << vsh << std::endl
                  << "FragmentShader:" << std::endl << fsh << std::endl
                  << "error: " << str << std::endl;
        free(str);
        assert(false);
    }

    assert(glGetError() == GL_NO_ERROR);
    return pid;
}


inline GLuint gl_create_texture(int w, int h, void *data = 0)
{
	GLuint tex;
	glGenTextures(1, &tex);
    glBindTexture(GL_TEXTURE_2D, tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    return tex;
}

inline GLuint gl_create_framebufferobject(int width, int height, GLuint *texture)
{
    assert(texture);
    *texture = gl_create_texture(width, height);
	GLuint fbo;
    glGenFramebuffers(1, &fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, *texture, 0);

#ifndef NDEBUG
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        std::cerr << "Failed! gl_create_framebufferobject(" << width << ", " << height
        		  << ") texture=" << texture << std::endl;
        assert(false);
    }
#endif

    return fbo;
}