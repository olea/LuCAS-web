#include <stdio.h>
#include <math.h>
#include <ri.h>
#include "filename.h"

float rebote (int i, int nframes, int max)
{
	float min;
	float z;

	while (i>nframes)
		i-=nframes;

	min=sqrt(max);

	z=i-((float)nframes/2.0);
	z=(z*min)/((float)nframes/2.0);
	z*=z;
	z-=max;
	z=-z;
	return(z);
}

void main(void)
{
	int i;
	int x,y,z;
	int nf;

	RtColor Rojo={1,0,0};
	RtColor Verde={0,1,0};
	RtColor Azul={0,0,1};
	RtColor Blanco={1,1,1};

	RtPoint p1={15,10,5}; 		/* Posicicion inicial de la pelota */
	
	RtPoint from={0,100,100};	/*      Direccion de la luz        */
	RtPoint to={0,0,0};

	char base[]="camara_";
	char ext[]="tif";
	char name[50];
	RtFloat fov=45;
	RtFloat intensity1=0.1;
	RtFloat intensity2=1.5;
	RtInt init=0,end=1;
	
	nf=1000;				/*        Numero de frames         */

	RiBegin(RI_NULL);
		RiFormat(320,240,1);
		RiPixelSamples(2,2);	
		RiShutter(0,1);
		for (i=0;i<nf;i++)
			{
			RiFrameBegin(i);
				filename(base,ext,sizeof(base)+4,i,name);
				RiDisplay(name,"file","rgb",RI_NULL);
				name[7]++;
				RiProjection("perspective","fov",&fov,RI_NULL);
				RiTranslate(0,-5,60);
				RiRotate(-110,1,0,0);
				RiRotate(25,0,0,1);
				RiWorldBegin();
					RiLightSource("ambientlight","intensity",&intensity1,RI_NULL);
					RiLightSource("distantlight","intensity",&intensity2,"from",from,"to",to,RI_NULL);
					RiColor(Azul);
					RiTransformBegin();
						RiCylinder(1,0,20,360,RI_NULL);
						RiTranslate(0,0,20);
						RiCone(2,2,360,RI_NULL);
					RiTransformEnd();
					RiColor(Verde);
					RiTransformBegin();
						RiRotate(-90,1,0,0);
						RiCylinder(1,0,20,360,RI_NULL);
						RiTranslate(0,0,20);
						RiCone(2,2,360,RI_NULL);
					RiTransformEnd();
					RiColor(Rojo);
					RiTransformBegin();
						RiRotate(90,0,1,0);
						RiCylinder(1,0,20,360,RI_NULL);
						RiTranslate(0,0,20);
						RiCone(2,2,360,RI_NULL);
					RiTransformEnd();
					RiColor(Blanco);
					RiTransformBegin();
						RiTranslate(p1[0],p1[1],p1[2]+rebote(i,nf/10,15));
						RiSphere(5,-5,5,360,RI_NULL);
					RiTransformEnd();
				RiWorldEnd();
			RiFrameEnd();
			}
	RiEnd();
};
