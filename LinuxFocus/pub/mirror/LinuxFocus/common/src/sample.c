#include  <stdio.h>
#include  <vga.h>

int main(void) {
   vga_init();
   vga_setmode(5);
   vga_setcolor(4);
   vga_drawpixel(10,10);

   sleep(5);
   vga_setmode(0);
   exit(0);
}
