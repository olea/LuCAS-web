# $Id: LEEME.Makefile,v 1.1.1.1 2000/07/10 17:49:08 jjamor Exp $

         AUTOMATIZACION DE FICHEROS html
         ===============================

   El conjunto Makefile/haz_dep_wml/script.sh de este directorio permite
mantener autom�ticamente las p�ginas html del proyecto LuCAS a partir
de los ficheros fuente WML y los propios C�MOS.

   Utilizaci�n:

   Programar un cron al finalizar la revisi�n de la r�plica de INSFLUG
y la generaci�n de los COMOs navegables (ver ../auto-COMO). Este
cron deber� realizar en este directorio:

   1. make dep             <--- Regenera las dependencias a partir
                                de los ficheros WML y los COMOs
                                existentes.

   2. make                 <--- Regenera solo aquellos HTML que
                                deban reconstruirse. Hay una regla
                                por defecto, y sendas reglas espec�ficas,
                                para la p�gina de COMOs y la index.html


   Las dependencias se generan en un fichero llamado .dependencias, que
incluye una l�nea:

all: $(DIR_TARGET)/fichero1.html $(DIR_TARGET)/fichero2.html ...

   Y otra:

INCL_COMOS = ../../COMO-INSFLUG/es/como1-COMO ../../COMO-INSFLUG/es/como2-COMO ../../COMO-INSFLUG/es/como3-COMO  ... 

   El script.sh permite generar la lista HTML con los COMOs navegables
y en otros formatos disponibles. Por �ltimo se adjunta una utilidad para
convertir los textos WML con retorno de carro a texto Unix, para que
wml los procese sin problemas.

