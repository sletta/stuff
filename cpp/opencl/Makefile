OSNAME := $(shell uname -s)
SHARED_HEADERS := openclhelpers.h openglhelpers.h ioutils.h
ifeq ($(OSNAME),Darwin)
	OS=osx
	CC=clang++
	# /usr/local/include and /usr/local/lib are needed because of where homebrew installs them
	CFLAGS := -g -I/usr/local/include
	LFLAGS=-L/usr/local/lib -lglfw3 -lGLEW -framework OpenCL -framework OpenGL
else
	OS=linux
	CC=g++
	CFLAGS=-g
	LFLAGS=-lglfw -lGLEW -lOpenCL -lGL
endif

all: mixed clinfo

mixed: mixed.cpp $(SHARED_HEADERS)
	$(CC) $(CFLAGS) mixed.cpp $(LFLAGS) -o mixed

clinfo: clinfo.cpp $(SHARED_HEADERS)
	$(CC) $(CFLAGS) clinfo.cpp $(LFLAGS) -o clinfo
