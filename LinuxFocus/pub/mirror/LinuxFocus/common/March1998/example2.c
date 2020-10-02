/* 
   Copyright (C) 1998 Miguel Angel Sepulveda (angel@mercury.chem.pitt.edu)

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version, and provided that the above
   copyright and permission notice is included with all distributed
   copies of this or derived software.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA

 */


/*******************************************************************************\
 *
 *      D E F I N I T I O N S   &  I N C L U D E    F I L E S
 *
\*******************************************************************************/
/* Physical and Mathematical Constants */
#define  PI    3.14159265358979323846	/* Pi                               */
#define  PI2  -6.28318530717959  	      /* 2Pi                              */
#define  HBAR  1.0		            /* Planck's COnstant (Atomic units) */

/* Standard Libraries */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* GLUT & OpenGL libraries */
#include <GL/glut.h>
#include <GL/gl.h>

/* Windows parameters and variables */
#define WIDTH  500
#define HEIGHT 500
#define TITLE  "OpenGL Demo: Line Details"

/* Quantum Simulation Parameters */
#define TIME_STEP     0.20	/* Integration Time Step            */
#define NR_POINTS     512	/* Nr points defining wavefunction  */
#define XMIN         -15.0	/* Minimum X coordinate             */
#define XMAX          15.0	/* Maximum X coordinate             */
#define YMIN         -1.25	/* Minimum Y coordinate             */
#define YMAX          1.25	/* Maximum Y coordinate             */
#define VMIN          0.00	/* Minimum Potential                */
#define VMAX          25.0	/* Maximum Potential                */
#define MASS          1.0	/* Mass in atomic units             */
#define ALPHA         5.00	/* Psi(0) gaussian coefficient      */
#define X0            -8.3	/* Average initial position         */
#define P0            0.00	/* Average initial momentum         */


/* Quantum Simulation State Variables */
double v0 = 0.005;		/* Initial Barrier Height           */
double time = 0.0;		/* Current Time                     */
double psi[2 * NR_POINTS];	/* Wavefunction                     */
double potential[NR_POINTS];	/* Potential                        */
double x[NR_POINTS];		/* Coordinate Grid                  */
double p[NR_POINTS];		/* Momentum Grid                    */
double expV[2 * NR_POINTS];	/* Potential part of the propagator */
double expK[2 * NR_POINTS];	/* Kinetic part of the propagator   */


/* Definitions */
double V (double);
void V_setup (unsigned long, double, double, double *, double *);
void psiInit (unsigned long, double *, double *, double, double, double);
void propagator (unsigned long, double *, double *, double *);


/*******************************************************************************\
 *
 *      A U X I L I A R Y   F U N C T I O N S
 *
\*******************************************************************************/
/* This function renders a character string
   onto the current position */
void
drawString (char *s)
{
  unsigned int i;
  for (i = 0; i < strlen (s); i++)
    glutBitmapCharacter (GLUT_BITMAP_HELVETICA_10, s[i]);
};

/* This function renders a character string using bigger fonts
   onto the current position */
void
drawStringBig (char *s)
{
  unsigned int i;
  for (i = 0; i < strlen (s); i++)
    glutBitmapCharacter (GLUT_BITMAP_HELVETICA_18, s[i]);
};
/* This routine plots the quantum state Psi(x) on an already
 * openned window with double buffer. The system coordinates must be
 * mapped to window coordinates
 */
void 
psiDraw (unsigned long nx, double *psi, double *x)
{
  static double ratio1 = 2.0 / (XMAX - XMIN);
  static double ratio2 = 2.0 / (YMAX - YMIN);
  double xs, ys;
  unsigned long i;

  /* Draw Real Part of the Wavefunction */
  glColor3f (1.0, 1.0, 1.0);
  glLineWidth (1);
  glPushAttrib (GL_LINE_BIT);
  glLineStipple (3, 0xAAAA);
  glBegin (GL_LINE_STRIP);
  for (i = 0; i < nx; i++)
    {
      xs = ratio1 * (x[i] - XMIN) - 1.0;
      ys = ratio2 * (psi[2 * i] - YMIN) - 1.0;
      glVertex2d (xs, ys);
    };
  glEnd ();
  glPopAttrib ();

  /* Draw Quantum Probability */
  glColor3f (1.0, 0.0, 1.0);
  glLineWidth (1.0);
  glBegin (GL_LINE_STRIP);
  for (i = 0; i < nx; i++)
    {
      double tmp;
      tmp = sqrt (psi[2 * i] * psi[2 * i] + psi[2 * i + 1] * psi[2 * i + 1]);
      xs = ratio1 * (x[i] - XMIN) - 1.0;
      ys = ratio2 * (tmp - YMIN) - 1.0;
      glVertex2d (xs, ys);
    };
  glEnd ();
};


/* This routine plots the system's potential on an already
 * openned window with double buffer. The system coordinates must be
 * mapped to window coordinates
 */
void 
potentialDraw (unsigned long nx, double *v, double *x)
{
  static double ratio1 = 2.0 / (XMAX - XMIN);
  static double ratio2 = 2.0 / (VMAX - VMIN);
  double xs, ys;
  unsigned long i;

  /* Draw Potential */
  glColor3f (1.0, 0.5, 0.0);
  glLineWidth (2);
  glBegin (GL_LINE_STRIP);
  for (i = 0; i < nx; i++)
    {
      xs = ratio1 * (x[i] - XMIN) - 1.0;
      ys = ratio2 * (v[i] - VMIN) - 1.0;
      if (ys > -1.0 && ys < 1.0)
	glVertex2d (xs, ys);
    };
  glEnd ();

};


#define SWAP(a, b) tempr=(a); (a)=(b); (b)=tempr
/* Replaces data[0:2*nn-1] by its discrete Fourier 
 * transform,  if isign is input as -1; or replaces
 * data[0..2*nn-1] by nn times its inverse discrete
 * Fourier transform,  if isign is -1. data is a real
 * array of length 2*nn. nn must be an integer power
 * of 2. This FFT routine has been modified to Quantum Computations
 */
void
fft1 (double *data, unsigned long nn, int isign)
{
  unsigned long n, mmax, m, j, istep, i;
  double wtemp, wr, wpr, wpi, wi, theta;
  double tempr, tempi;


  /*  The algorithm assumes the index of the vector data
   * ranges from 1 to 2*nn. Next we shift the pointer.
   */

  /* Bit reversal section of the routine. */
  n = nn << 1;
  j = 1;
  for (i = 1; i < n; i += 2)
    {
      if (j > i)
	{
	  SWAP (*(data + j - 1), *(data + i - 1));
	  SWAP (*(data + j), *(data + i));
	}
      m = n >> 1;
      while (m >= 2 && j > m)
	{
	  j -= m;
	  m >>= 1;
	}
      j += m;
    }

  /* Beginning of the Danielson-Lanczos section */
  mmax = 2;
  while (n > mmax)
    {
      istep = mmax << 1;
      theta = isign * (PI2 / mmax);
      wtemp = sin (0.5 * theta);
      wpr = -2.0 * wtemp * wtemp;
      wpi = sin (theta);
      wr = 1.0;
      wi = 0.0;
      for (m = 1; m < mmax; m += 2)
	{
	  for (i = m; i <= n; i += istep)
	    {
	      j = i + mmax;
	      tempr = wr * *(data + j - 1) - wi * *(data + j);
	      tempi = wr * *(data + j) + wi * *(data + j - 1);
	      *(data + j - 1) = *(data + i - 1) - tempr;
	      *(data + j) = *(data + i) - tempi;
	      *(data + i - 1) += tempr;
	      *(data + i) += tempi;
	    }
	  wr = (wtemp = wr) * wpr - wi * wpi + wr;
	  wi = wi * wpr + wtemp * wpi + wi;
	}
      mmax = istep;
    }
};




/*******************************************************************************\
 *
 *      G L U T     C A L L B A C K    F U N C T I O N S 
 *
\*******************************************************************************/
/* Function for Reshaping the Main Window:
 *   The system of coordinated is 2D, ranging from XMIN to XMAX in x,
 *   and from -0.75 to 0.75 in y. The y coordinate will be associated with
 *   the real part of the wavefunction, and since |Psi(x)| <= 1.0  then
 *   assuming [-0.75 to 0.75] range is reasonable
 */
void
reshape (int w, int h)
{
  glMatrixMode (GL_MODELVIEW);
  glLoadIdentity ();
  glViewport (0, 0, w, h);
  glMatrixMode (GL_PROJECTION);
  glLoadIdentity ();
  gluOrtho2D (-1.2, 1.2, -1.2, 1.2);
  glEnable (GL_LINE_SMOOTH);
  glEnable (GL_LINE_STIPPLE);
};


/* Function for Displaying main window:
 *   It draws simulation box, coordinate axis, grid, wavefunction, physical potential,
 *   some labels,...
 */
void
display (void)
{
  static char label[100];
  float xtmp;

  /* Clean drawing board */
  glClear (GL_COLOR_BUFFER_BIT);


  /* Write Footnote */
  glColor3f (0.0F, 1.0F, 1.0F);
  sprintf (label, "(c)Miguel Angel Sepulveda 1998");
  glRasterPos2f (-1.1F, -1.1F);
  drawString (label);


  /* Draw fine grid */
  glLineWidth (0.5);
  glColor3f (0.5F, 0.5F, 0.5F);
  glBegin (GL_LINES);
  for (xtmp = -1.0F; xtmp < 1.0F; xtmp += 0.05F)
    {
      glVertex2f (xtmp, -1.0);
      glVertex2f (xtmp, 1.0);
      glVertex2f (-1.0, xtmp);
      glVertex2f (1.0, xtmp);
    };
  glEnd ();

  /* Draw Outsite box */
  glColor3f (0.1F, 0.80F, 0.1F);
  glLineWidth (3);
  glBegin (GL_LINE_LOOP);
  glVertex2f (-1.0F, -1.0F);
  glVertex2f (1.0F, -1.0F);
  glVertex2f (1.0F, 1.0F);
  glVertex2f (-1.0F, 1.0F);
  glEnd ();

  /* Draw Grid */
  glLineWidth (1);
  glColor3f (1.0F, 1.0F, 1.0F);
  glBegin (GL_LINES);
  for (xtmp = -0.5; xtmp < 1.0; xtmp += 0.50)
    {
      glVertex2f (xtmp, -1.0);
      glVertex2f (xtmp, 1.0);
      glVertex2f (-1.0, xtmp);
      glVertex2f (1.0, xtmp);
    };
  glEnd ();

  /* Draw Coordinate Axis */
  glLineWidth (2);
  glBegin (GL_LINES);
  glVertex2f (-1.0, 0.0);
  glVertex2f (1.0, 0.0);
  glVertex2f (0.0, -1.0);
  glVertex2f (0.0, 1.0);
  glEnd ();

  /* Axis Labels */
  glColor3f (1.0F, 1.0F, 1.0F);
  sprintf (label, "Position");
  glRasterPos2f (0.80F, 0.025F);
  drawString (label);
  glColor3f (1.0F, 0.0F, 1.0F);
  sprintf (label, " Quantum Probability ");
  glRasterPos2f (0.025F, 0.90F);
  drawString (label);
  glColor3f (1.0F, 1.0F, 1.0F);
  sprintf (label, " Real(Psi) ");
  glRasterPos2f (0.025F, 0.85F);
  drawString (label);

  /* Draw Wavefunction */
  psiDraw (NR_POINTS, psi, x);

  /* Draw potential Function */
  potentialDraw (NR_POINTS, potential, x);

  glutSwapBuffers ();
};


/* Function for Keyboard events handlying:
 *   Everytime key stroke generates an ASCII code that is captured 
 *   and handle by this callback function
 */
void
keyboard (unsigned char key_code, int xpos, int ypos)
{
  int i;
  switch (key_code)
    {
      /* Quit Application */
    case 'q':
    case 'Q':
      glFinish ();
      exit (0);
      break;

      /* Increase Potential Barrier */
    case 'a':
    case 'A':
      if (v0 < 0.006)
	{
	  v0 += 0.0001;
	  /* Modify potential grid */
	  for (i = 0; i < NR_POINTS; i++)
	    potential[i] = V (x[i]);

	  /* Set up Kinetic part of the Propagator */
	  V_setup (NR_POINTS, HBAR, TIME_STEP, potential, expV);

	};
      break;

      /* Decrease Potential Barrier */
    case 'z':
    case 'Z':
      if (v0 > 0.004)
	{
	  v0 -= 0.0001;
	  /* Modify potential grid */
	  for (i = 0; i < NR_POINTS; i++)
	    potential[i] = V (x[i]);

	  /* Set up Kinetic part of the Propagator */
	  V_setup (NR_POINTS, HBAR, TIME_STEP, potential, expV);

	};
      break;


      /* Restart Wavefunction */
    case 'r':
    case 'R':
      psiInit (NR_POINTS, x, psi, ALPHA, P0, X0);
      break;

    };
};



/* Background idle function always running:
 *  There can be only one idle() callback function. In an
 *  animation, this idle() function must update all graphical
 *  and non-graphical elements
 */
void
idle (void)
{
  /* Update  state variables */
  time += TIME_STEP;
  propagator (NR_POINTS, expV, expK, psi);

  /* Update main and sub window */
  glutPostRedisplay ();
};



/*******************************************************************************\
 *
 *      Q U A N T U M   M E C H A N I C A L    S I M U L A T I O N
 *
\*******************************************************************************/
/* Potential function:
 *  It defines the system, a double well potential
 */
double
V (double x)
{
  double tmp = v0;
  tmp *= pow (x - 7.0, 2.0);
  tmp *= pow (x + 7.0, 2.0);
  return tmp;
};

/* Wavefunction Initialization:
 *   This routine sets up the initial state Psi(x;0) on 
 *   the grid psi[0..2*nx-1]
 */
void
psiInit (unsigned long nx, double *x, double *psi, double alpha,
	 double p0, double x0)
{
  unsigned long i, itmp;
  double c1, c2, c3;
  double cs, sn;
  double dx;
  double tmp;

  /* Normalization constant */
  c1 = alpha / PI;
  c1 = pow (c1, 0.250);

  /* Gaussian quadratic coeff. */
  c2 = -alpha / 2.0;

  /* Momentum component coeff. */
  c3 = p0 / HBAR;

  /* Loop over grid points */
  for (i = 0; i < nx; i++)
    {
      dx = *(x + i) - x0;

      tmp = c3 * dx;
      cs = cos (tmp);
      sn = sin (tmp);

      tmp = c1 * exp (c2 * dx * dx);

      itmp = 2 * i;
      *(psi + itmp) = tmp * cs;
      *(psi + itmp + 1) = tmp * sn;
    }

};


/* Setup Potential part of the propagator */
void
V_setup (unsigned long nx, double hbar, double tau, double *v, double *expV)
{
  unsigned long i;
  int itmp;
  double tmp;
  double cs, sn, theta;

  /* compute and store exp(-iV(x) tau/hbar) */
  tmp = tau / hbar;
  for (i = 0; i < nx; i++)
    {
      theta = tmp * v[i];
      cs = cos (theta);
      sn = sin (theta);
      itmp = 2 * i;
      expV[itmp] = cs;
      expV[itmp + 1] = -sn;
    };
};

/* Setup Kinetic part of the propagator */
void
K_setup (unsigned long nx, double hbar, double tau, double mass, double *p, double *expK)
{
  unsigned long i;
  int itmp;
  double tmp;
  double cs, sn, theta;

  tmp = tau / (4.0 * hbar * mass);
  for (i = 0; i < nx; i++)
    {
      theta = tmp * pow (*(p + i), 2);
      cs = cos (theta);
      sn = sin (theta);
      itmp = 2 * i;
      *(expK + itmp) = cs;
      *(expK + itmp + 1) = -sn;
    };

};



/* Quantum Simulation initializations:
 *  Set up x and p grids, initial wavefunction, 
 *  potential, propagator, ..
 */
void
QMinit ()
{
  int i;
  double tmp;
  double xinc;
  double pinc;

  /* Coordinate grid */
  xinc = (XMAX - XMIN) / (double) (NR_POINTS - 1);
  tmp = XMIN;
  for (i = 0; i < NR_POINTS; i++)
    {
      x[i] = tmp;
      tmp += xinc;
    };

  /* Momentum grid */
  pinc = 2.0 * PI * HBAR / xinc / NR_POINTS;
  tmp = 0.0;
  for (i = 0; i < NR_POINTS / 2; i++)
    {
      p[i] = tmp;
      tmp += pinc;
      p[NR_POINTS - i - 1] = -tmp;
    };

  /* Initialize Wavefunction */
  psiInit (NR_POINTS, x, psi, ALPHA, P0, X0);

  /* Set up potential grid */
  for (i = 0; i < NR_POINTS; i++)
    potential[i] = V (x[i]);

  /* Set up Kinetic part of the Propagator */
  V_setup (NR_POINTS, HBAR, TIME_STEP, potential, expV);

  /* Set up Potential part of the Propagator */
  K_setup (NR_POINTS, HBAR, TIME_STEP, MASS, p, expK);

};

/* One step propagator Quantum Propagator:
 *   Solves the Time-Dependent Schrodinger Equation using the Split-Operator
 *   technique
 */
void
propagator (unsigned long nx, double *expV, double *expK, double *psi)
{
  unsigned long i;
  int isign;
  int itmp;
  double tmp1, tmp2;


  /* transform psi(x) into momentum representation */
  isign = 1;
  fft1 (psi, nx, isign);


  /* free propagation */
  for (i = 0; i < nx; i++)
    {
      itmp = 2 * i;
      tmp1 = expK[itmp] * psi[itmp] - expK[itmp + 1] * psi[itmp + 1];
      tmp2 = expK[itmp] * psi[itmp + 1] + expK[itmp + 1] * psi[itmp];
      psi[itmp] = tmp1 / (double) nx;
      psi[itmp + 1] = tmp2 / (double) nx;
    }


  /* transform psi(p) into coordinate representation */
  isign = -1;
  fft1 (psi, nx, isign);


  /* Potential kick */
  for (i = 0; i < nx; i++)
    {
      itmp = 2 * i;
      tmp1 = expV[itmp] * psi[itmp] - expV[itmp + 1] * psi[itmp + 1];
      tmp2 = expV[itmp] * psi[itmp + 1] + expV[itmp + 1] * psi[itmp];
      psi[itmp] = tmp1;
      psi[itmp + 1] = tmp2;
    }


  /* transform psi(x) into momentum representation */
  isign = 1;
  fft1 (psi, nx, isign);


  /* free propagation */
  for (i = 0; i < nx; i++)
    {
      itmp = 2 * i;
      tmp1 = expK[itmp] * psi[itmp] - expK[itmp + 1] * psi[itmp + 1];
      tmp2 = expK[itmp] * psi[itmp + 1] + expK[itmp + 1] * psi[itmp];
      psi[itmp] = tmp1 / (double) nx;
      psi[itmp + 1] = tmp2 / (double) nx;
    }

  /* transform psi(p) into coordinate representation */
  isign = -1;
  fft1 (psi, nx, isign);

}


/*******************************************************************************\
 *
 *      M A I N     F U N C T I O N 
 *
\*******************************************************************************/
int
main (int argc, char **argv)
{
  /* Quantum System Initializations */
  QMinit ();

  /* Glut initializations */
  glutInit (&argc, argv);
  glutInitDisplayMode (GLUT_DOUBLE | GLUT_RGBA);
  glutInitWindowPosition (5, 5);
  glutInitWindowSize (WIDTH, HEIGHT);

  /* Main window creation and setup */
  glutCreateWindow (TITLE);
  glutDisplayFunc (display);
  glutReshapeFunc (reshape);
  glutKeyboardFunc (keyboard);
  glutIdleFunc (idle);

  glutMainLoop ();

  return 0;
};
