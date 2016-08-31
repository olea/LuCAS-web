Author: Guido Socher <guido(at)linuxfocus(dot)org>
Copyright: GPL

Linux frequency counter command language
----------------------------------------

The file describes the command language that the Linux frequency counter
understands. Although this is human readable and ASCII based, the
software on the controller is not checking for all kind of
syntax errors. The is not enough ram on the AVR to implement a full
blown parser. The commands are primarily designed as a machine
to machine language where typing and syntax errors will not occur.

valid command are:
c=1
   clear the counter. This is useful for continuous count mode or
   needed if there is still a logical "1" on the or gate from
   the 1/100 divider as this clears also the divider.
m=0
m=1
m=2
m=?
   Set the mode:
   1= 1Hz gate
   2= 64Hz gate 
   0= continuous count up
   ?= show which mode is in use
h=0
h=1
h=?
  It is possible to multiply the result by 100 to compensate the
  counter result when the 1/100 divider is used. 
  
-----------------------------------------------------
The counter result is printed every second like this:
c:16917
c:16923
c:16921
....

