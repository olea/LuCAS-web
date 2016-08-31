#include <GL/glut.h> 
#include <math.h>  

const  double  pi2 = 6.28318530718; 

/* Pendulum constants */
const  double  omega = 1.0;
const  double  initial_angle = -1.0;
const  double  cord_length = 0.75;

/* Time variables */
const  double  tic  = 0.025;
static double  time = 0.0;


void idle(void){
  /* Increase time by 1 tic */  
  time += tic;
  
  /* Redraw the display */
  glutPostRedisplay();
};


void winInit(void){
  /* Set orthographic 2D coordinate system */
  gluOrtho2D(-1.0, 1.0, -1.5, 0.5);
};


void display(void){
  static double radius = 0.05;
  const double delta_theta = pi2/20;
  double xcenter , ycenter;  
  double x, y;
  double theta = 0.0;

  double current_angle = cos(omega * time);

  glColor3f(0.0, 0.0, 0.0);
  glClear(GL_COLOR_BUFFER_BIT);
  glColor3f(1.0, 1.0, 1.0);

  /* Draw pendulum cord */  
  glColor3f(1.0, 1.0, 1.0);
  glBegin(GL_LINES);
  glVertex2f(0.0, 0.0);
  xcenter = -cord_length * sin(current_angle);
  ycenter = -cord_length * cos(current_angle);
  glVertex2f(xcenter, ycenter);
  glEnd();

  /* Draw pendulum dish */
  glColor3f(1.0, 0.0, 0.0);
  glBegin(GL_POLYGON);
  while (theta <= pi2) {
    x = xcenter + radius * sin(theta);
    y = ycenter + radius * cos(theta);
    glVertex2f(x, y);
    theta += delta_theta;
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
  glutCreateWindow("Pendulum");  
  
  /* Window initializations */
  winInit();
  
  /* Register callback functions */
  glutDisplayFunc(display);  
  glutIdleFunc(idle);
  
  /* Launch event processing */
  glutMainLoop();  
  
  return 0;  
}  
  
  
  
  
