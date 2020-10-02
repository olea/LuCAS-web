INCLUDE = -I/usr/include/GL 
LIBDIR  = -L. -L/usr/X11R6/lib

COMPILERFLAGS = -Wall  
CC = gcc
CFLAGS = $(COMPILERFLAGS) $(INCLUDE)
LIBRARIES = -lglut -lMesaGL -lMesaGLU -lXmu -lXext -lXi -lX11 -lm


all:  example1 example2 example3

example1 : example1.o
	$(CC) $(CFLAGS) -o example1 $(LIBDIR) example1.o $(LIBRARIES)  

example2 : example2.o
	$(CC) $(CFLAGS) -o example2 $(LIBDIR) example2.o $(LIBRARIES)  

example3 : example3.o
	$(CC) $(CFLAGS) -o example3 $(LIBDIR) example3.o $(LIBRARIES)  
