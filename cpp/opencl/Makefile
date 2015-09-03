OSNAME := $(shell uname -s)
SHARED_HEADERS := openclhelpers.h openglhelpers.h ioutils.h
ifeq ($(OSNAME),Darwin)
	OS=osx
	CC=clang++
	# /usr/local/include and /usr/local/lib are needed because of where homebrew installs them
	CFLAGS := -g -I/usr/local/include
	LFLAGS=-L/usr/local/lib -lGLEW -framework OpenCL -framework OpenGL -lglfw3
else
	OS=linux
	CC=g++
	CFLAGS=-g
	LFLAGS=-lGLEW -lOpenCL -lGL -lglfw
endif

all: mixed clinfo hello

mixed: mixed.cpp $(SHARED_HEADERS)
	$(CC) $(CFLAGS) mixed.cpp $(LFLAGS) -o mixed

clinfo: clinfo.cpp $(SHARED_HEADERS)
	$(CC) $(CFLAGS) clinfo.cpp $(LFLAGS) -o clinfo

hello: hello.c
	$(CC) $(CFLAGS) hello.c $(LFLAGS) -o hello

clean:
	@rm mixed
	@rm hello
	@rm clinfo