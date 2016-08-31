#include <stdio.h>
#include <stdlib.h>
#include <vga.h>
#include <vgagl.h>

GraphicsContext *physicalscreen;
GraphicsContext *virtualscreen;

int main(void)
{
   int i,
       j,
       b,
       y,
       c;

   vga_init();
   vga_setmode(5);
   gl_setcontextvga(5);
   physicalscreen = gl_allocatecontext();
   gl_getcontext(physicalscreen);
   gl_setcontextvgavirtual(5);
   virtualscreen = gl_allocatecontext();
   gl_getcontext(virtualscreen);

   gl_setcontext(virtualscreen);
   y = 0;
   c = 0;
   gl_setpalettecolor(c, 0, 0, 0);
   c++;
   for (i = 0; i < 64; i++)
   {
      b = 63 - i;
      gl_setpalettecolor(c, 0, 0, b);      
      for (j = 0; j < 3; j++)
      {
         gl_hline(0, y, 319, c);
         y++;
      }
      c++;
   }

   gl_copyscreen(physicalscreen);

   getchar();
   gl_clearscreen(0);
   vga_setmode(0);
   exit(0);
}
