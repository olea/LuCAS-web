LIBS = -lm -lribout
PROGNAME = primero
 
all: $(PROGNAME)

$(PROGNAME).o: $(PROGNAME).c
	gcc -c $(PROGNAME).c

$(PROGNAME): $(PROGNAME).o 
	gcc -o $(PROGNAME) $(PROGNAME).o $(LIBS)
