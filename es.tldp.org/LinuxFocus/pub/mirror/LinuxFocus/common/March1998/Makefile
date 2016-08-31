INCLUDE = -I/usr/include/GL 
LIBDIR  = -L. -L/usr/X11R6/lib

COMPILERFLAGS = -Wall  
CC = gcc
CFLAGS = $(COMPILERFLAGS) $(INCLUDE)
LIBRARIES = -lglut -lMesaGL -lMesaGLU -lXmu -lXext -lXi -lX11 -lm


all:  
	@echo "This make file compiles all the demos in the LF issue"
	@echo "Usage:"
	@echo "make GLUTdemo         to make GLUT article demo"
	@echo "make OGLdemo          to make OpenGL demo"
	@echo "make 3DFXdemo         to make 3Dfxdemo"

clean:
	@rm -rf *.o *~ example1 example2 example3


GLUTdemo : example1.o
	$(CC) $(CFLAGS) -o example1 $(LIBDIR) example1.o $(LIBRARIES)  

OGLdemo : example2.o
	$(CC) $(CFLAGS) -o example2 $(LIBDIR) example2.o $(LIBRARIES)  

3DFXdemo : example3.o
	$(CC) $(CFLAGS) -o example3 $(LIBDIR) example3.o $(LIBRARIES)  
