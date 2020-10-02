#include <GL/glut.h> 
#include <math.h>  

const  double pi2 = 6.28318530718;


void NonlinearMap(double *x, double *y){
 	static double K = 1.04295;         /* Stochastic parameter */

	/* Standard Map: 
	     x is the angle
	     y is the action 
	*/
	*y += K * sin(*x);
    *x += *y;

    *x = fmod(*x, pi2);
	if (*x < 0.0) *x += pi2;

};


void winInit(){
	gluOrtho2D(0.0, pi2, 0.0, pi2);
};


void display(void){
    const int    NumberSteps = 1000;
	const int    NumberOrbits = 100;
	const double Delta_x = pi2/(NumberOrbits-1);
    int step, orbit;

	glColor3f(0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(1.0, 1.0, 1.0);
		
	for (orbit = 0; orbit < NumberOrbits; orbit++){
		double x, y;
		y = 3.1415;
		x = Delta_x * orbit;

		glBegin(GL_POINTS);
		for (step = 0; step < NumberSteps; step++){
			NonlinearMap(&x, &y);
			glVertex2f(x, y);
		};
		glEnd();
	};

	for (orbit = 0; orbit < NumberOrbits; orbit++){
		double x, y;
		x = 3.1415;
		y = Delta_x * orbit;

		glBegin(GL_POINTS);
		for (step = 0; step < NumberSteps; step++){
			NonlinearMap(&x, &y);
			glVertex2f(x, y);
		};
		glEnd();
	};




};





int main(int argc, char **argv)  
{  
  glutInit(&argc, argv);  
  glutInitDisplayMode(GLUT_SINGLE | GLUT_RGBA);  
  glutInitWindowPosition(5,5);  
  glutInitWindowSize(300,300);  
  glutCreateWindow("Coordinate Box");  
  
  winInit();
  glutDisplayFunc(display);  
  glutMainLoop();  
  
  return 0;  
}  
  
  
  
  
