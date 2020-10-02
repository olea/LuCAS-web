# Ejecute primero "make screen" si quiere proteger las páginas de manual ya
# instaladas y más actualizadas que las incluidas en este paquete.
# Ejecute "make install" para copiar las páginas a su destino.
# Ejecute "make gz" o "make bz2" antes de "make install" si usa páginas fuente
# comprimidas
# Ejecute "make remove" antes de "make gz" si es posible que tenga páginas
# fuente sin comprimir por ahí.
# Utilice la macro "-DMANDIR=<directorio>" si sus páginas de manual se
# encuentran en un directorio distinto de "/usr/man/es".

# FHS requiere /usr/share/man
ifndef MANDIR
	MANDIR=/usr/man/es
endif

GZIP=gzip -9
BZIP2=bzip2 -9
 
all: screen remove install

allgz: gz all

allbz: bz2 all

# Desafortunadamente, debido al deterioro cerebral de BSD codificado por POSIX,
# código como "for i in dir/*;do STH; done" no itera sobre todos los ficheros
# de dir - de hecho, cuando dir está vacío ejecuta STH una vez en lugar de cero
# veces. David Balazic se encontró con que perdía sus ficheros y se dió cuenta
# de la causa.
# [Si supieramos con seguridad que esto fuera a usar bash, podríamos activar
#  allow_null_glob_expansion.]

screen:
	-mkdir no_instaladas
	files=man?/*; \
	if [ "$$files" != "man\?/\*" ]; then for i in $$files; do \
		if [ $(MANDIR)/$$i -nt $$i ]; then \
			diff -q $(MANDIR)/$$i $$i > /dev/null 2>&1; \
			if [ $$? != 0 ]; then mv $$i no_instaladas; fi; \
		fi; \
	done; fi

remove:
	files=man?/*; \
	if [ "$$files" != "man\?/\*" ]; then for i in $$files; do \
		rm -f $(MANDIR)/$$i $(MANDIR)/$$i.gz $(MANDIR)/$$i.bz2; \
	done; fi
	rm -f $(MANDIR)/LEEME $(MANDIR)/PROYECTO $(MANDIR)/EXTRA

gz:
	for i in man?; do $(GZIP) $$i/*; done

bz2:     
	for i in man?; do $(BZIP2) $$i/*; done

install:
	for i in man?; do \
		install -d -m 755 $(MANDIR)/$$i; \
		install -m 644 $$i/* $(MANDIR)/$$i; \
	done
	install -m 644 LEEME $(MANDIR)

# Tal vez alguien también querría mirar en el directorio /var/catman/cat2 o
# algo por el estilo. El problema es que la posición de las páginas cat
# varia bastante.
