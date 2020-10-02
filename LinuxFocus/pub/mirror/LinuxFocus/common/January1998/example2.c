#include <GL/glut.h> 
#include <math.h>  

const  double  pi2 = 6.28318530718; 
const  double  K_max = 3.5;
const  double  K_min = 0.1;
static double  Delta_K = 0.005;
static double  K = 0.1;          


void NonlinearMap(double *x, double *y){
  /* Standard Map */
  *y += K * sin(*x);
  *x += *y;
  
  /* Angle x is modules 2Pi */
  *x = fmod(*x, pi2);
  if (*x < 0.0) *x += pi2;
};


/* Callback function: 
   What to do in absence of use input */
void idle(void){
  /* Increase the stochastic parameter */
  K += Delta_K;
  if(K > K_max) K = K_min;
  
  /* Redraw the display */
  glutPostRedisplay();
};


/* Initialization for the graphics window */
void winInit(void){
  gluOrtho2D(0.0, pi2, 0.0, pi2);
};

/* Callback function:
   What to do when the display needs redrawing */
void display(void){
  const int    NumberSteps = 1000;
  const int    NumberOrbits = 50;
  const double Delta_x = pi2/(NumberOrbits-1);
  int step, orbit;
  
  glColor3f(0.0, 0.0, 0.0);
  glClear(GL_COLOR_BUFFER_BIT);
  glColor3f(1.0, 1.0, 1.0);

  glBegin(GL_POINTS);
  
  for (orbit = 0; orbit < NumberOrbits; orbit++){
    double x, y;
    y = 3.1415;
    x = Delta_x * orbit;
    
    for (step = 0; step < NumberSteps; step++){
      NonlinearMap(&x, &y);
      glVertex2f(x, y);
    };
  };
  
  for (orbit = 0; orbit < NumberOrbits; orbit++){
    double x, y;
    x = 3.1415;
    y = Delta_x * orbit;
    
    for (step = 0; step < NumberSteps; step++){
      NonlinearMap(&x, &y);
      glVertex2f(x, y);
    };
  };

  glEnd();
  glutSwapBuffers();
};





int main(int argc, char **argv)  
{  
  /* GLUT Initializations */
  glutInit(&argc, argv);  
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);  
  glutInitWindowPosition(5,5);  
  glutInitWindowSize(300,300);
  
  /* Open Window */
  glutCreateWindow("Order to Chaos");  
  
  /* Window initializations */
  winInit();

  /* Register callback functions */
  glutDisplayFunc(display);  
  glutIdleFunc(idle);

  /* Launch event processing */
  glutMainLoop();  
  
  return 0;  
}  
  
  
  
  
