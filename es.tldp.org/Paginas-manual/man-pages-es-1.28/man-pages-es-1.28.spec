Summary: System manual pages - Spanish versions
Name: man-pages-es
Version: 1.28
Release: 1
Copyright: Varios (distributable)
Group:  Documentation
Packager: Juan Piernas Cánovas <piernas@ditec.um.es>
Source: http://www.ditec.um.es/~piernas/manpages-es/man-pages-es-1.28.tar.gz
Source1: makewhatis.es
# Lo siguiente es un directorio temporal donde se construirán los ficheros
# que luego compondrán el paquete.
BuildRoot: /usr/tmp/man-pages-es-root
Icon: books-es.gif
URL: http://www.ditec.um.es/~piernas/manpages-es/
BuildArchitectures: noarch
Requires: mktemp, man >= 1.4
Obsoletes: manpages-es, man-pages-es
Summary(es_ES): Páginas de manual de Linux en castellano
Summary(es): Páginas de manual de Linux en castellano

%description
Linux man pages in spanish

%description -l es
Páginas de manual en español para Linux. Esta versión traduce la versión
1.28 de las páginas de manual en inglés. Como podrá comprobar, se trata de
una versión beta por lo que todavía puede encontrar bastantes errores.
Cualquier sugerencia, corrección o crítica constructiva será bien recibida.
Puede ponerse en contacto con el responsable del proyecto enviando un e-mail
a piernas@ditec.um.es. Para más información, lea el fichero LEEME que
encontrará en el directorio /usr/doc/man-pages-es-1.28.

%description -l es_ES
Páginas de manual en español para Linux. Esta versión traduce la versión
1.28 de las páginas de manual en inglés. Como podrá comprobar, se trata de
una versión beta por lo que todavía puede encontrar bastantes errores.
Cualquier sugerencia, corrección o crítica constructiva será bien recibida.
Puede ponerse en contacto con el responsable del proyecto enviando un e-mail
a piernas@ditec.um.es. Para más información, lea el fichero LEEME que
encontrará en el directorio /usr/doc/man-pages-es-1.28.

%prep

%setup -n man-pages-es-%{PACKAGE_VERSION}

# Lo que viene a continuación se utiliza a la hora de construir el paquete a
# partir de los fuentes.
%install
rm -fr $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/man/es/man{1,2,3,4,5,6,7,8}
mkdir -p $RPM_BUILD_ROOT/var/catman/es/cat{1,2,3,4,5,6,7,8}
make MANDIR=$RPM_BUILD_ROOT/usr/man/es

mkdir -p $RPM_BUILD_ROOT/usr/local/sbin
install -m 755 $RPM_SOURCE_DIR/makewhatis.es $RPM_BUILD_ROOT/usr/local/sbin/makewhatis.es

mkdir -p $RPM_BUILD_ROOT/etc/cron.weekly
cat > $RPM_BUILD_ROOT/etc/cron.weekly/makewhatis-es.cron << EOF
#!/bin/bash
/usr/local/sbin/makewhatis.es /usr/man/es
exit 0
EOF
chmod a+x $RPM_BUILD_ROOT/etc/cron.weekly/makewhatis-es.cron

%post
if grep makewhatis.es /etc/cron.weekly/makewhatis.cron >& /dev/null
then
	TMPFILE=`mktemp ${TMPDIR:-/tmp}/tmp$0$$.XXXXXX`
        cat /etc/cron.weekly/makewhatis.cron | grep -v '^/usr/local/sbin/makewhatis.es' > $TMPFILE
        cat $TMPFILE > /etc/cron.weekly/makewhatis.cron
        rm $TMPFILE
fi
/usr/local/sbin/makewhatis.es /usr/man/es

echo
echo "No olvide configurar el programa man y sus fuentes de pantalla"
echo "para poder ver correctamente las páginas de manual. El fichero"
echo "LEEME le dice como hacerlo."
echo

%clean
rm -r $RPM_BUILD_ROOT

%files
%doc LEEME
%dir /usr/man/es
/usr/man/es/man?
/var/catman/es
/usr/local/sbin/makewhatis.es
%config /etc/cron.weekly/makewhatis-es.cron

%preun

%postun
echo
echo "Para que la desinstalación esté completa, puede ser que tenga que"
echo "borrar manualmente los directorios /usr/doc/man-pages-es-1.28"
echo "y /usr/man/es."
echo
