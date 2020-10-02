Summary: Extra manual pages - Spanish versions
Name: man-pages-es-extra
Version: 0.8a
Release: 1
Copyright: Varios (distributable)
Group:  Documentation
Packager: Juan Piernas C�novas <piernas@ditec.um.es>
Source: http://www.ditec.um.es/~piernas/manpages-es/man-pages-es-extra-0.8a.tar.gz
Source1: makewhatis.es
# Lo siguiente es un directorio temporal donde se construir�n los ficheros
# que luego compondr�n el paquete.
BuildRoot: /usr/tmp/man-pages-es-extra-root
Icon: books-es.gif
URL: http://www.ditec.um.es/~piernas/manpages-es/
BuildArchitectures: noarch
Requires: mktemp, man >= 1.4
Summary(es_ES): P�ginas de manual extras en castellano
Summary(es): P�ginas de manual extras en castellano

%description
Extra man pages in Spanish

%description -l es
P�ginas de manual extras en espa�ol para Linux. Consulte el fichero
/usr/doc/man-pages-es-extras-0.8a/PAQUETES para conocer los paquetes de los
que proceden las p�ginas traducidas. Como podr� comprobar, se trata de
una versi�n alfa por lo que todav�a puede encontrar bastantes errores.
Cualquier sugerencia, correcci�n o cr�tica constructiva ser� bien recibida.
Puede ponerse en contacto con el responsable del proyecto enviando un e-mail
a piernas@ditec.um.es. Para m�s informaci�n, lea el fichero LEEME.extra que
encontrar� en el directorio /usr/doc/man-pages-es-extra-0.8a.

%description -l es_ES
P�ginas de manual extras en espa�ol para Linux. Consulte el fichero
/usr/doc/man-pages-es-extras-0.8a/PAQUETES para conocer los paquetes de los
que proceden las p�ginas traducidas. Como podr� comprobar, se trata de
una versi�n alfa por lo que todav�a puede encontrar bastantes errores.
Cualquier sugerencia, correcci�n o cr�tica constructiva ser� bien recibida.
Puede ponerse en contacto con el responsable del proyecto enviando un e-mail
a piernas@ditec.um.es. Para m�s informaci�n, lea el fichero LEEME.extra que
encontrar� en el directorio /usr/doc/man-pages-es-extra-0.8a.

%prep

%setup -n man-pages-es-extra-%{PACKAGE_VERSION}

# Lo que viene a continuaci�n se utiliza a la hora de construir el paquete a
# partir de los fuentes.
%install
rm -fr $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/man/es/man{1,2,3,4,5,6,7,8}
mkdir -p $RPM_BUILD_ROOT/var/catman/es/cat{1,2,3,4,5,6,7,8}
make MANDIR=$RPM_BUILD_ROOT/usr/man/es

#mkdir -p $RPM_BUILD_ROOT/usr/local/sbin
#install -m 755 $RPM_SOURCE_DIR/makewhatis.es $RPM_BUILD_ROOT/usr/local/sbin/makewhatis.es
#
#mkdir -p $RPM_BUILD_ROOT/etc/cron.weekly
#cat > $RPM_BUILD_ROOT/etc/cron.weekly/makewhatis-es.cron << EOF
##!/bin/bash
#/usr/local/sbin/makewhatis.es /usr/man/es
#exit 0
#EOF
#chmod a+x $RPM_BUILD_ROOT/etc/cron.weekly/makewhatis-es.cron

%post
#if grep makewhatis.es /etc/cron.weekly/makewhatis.cron >& /dev/null
#then
#	TMPFILE=`mktemp ${TMPDIR:-/tmp}/tmp$0$$.XXXXXX`
#        cat /etc/cron.weekly/makewhatis.cron | grep -v '^/usr/local/sbin/makewhatis.es' > $TMPFILE
#        cat $TMPFILE > /etc/cron.weekly/makewhatis.cron
#        rm $TMPFILE
#fi

if [ -x /usr/local/sbin/makewhatis.es ]
then
	/usr/local/sbin/makewhatis.es /usr/man/es
fi

echo
echo "No olvide configurar el programa man y sus fuentes de pantalla"
echo "para poder ver correctamente las p�ginas de manual. El fichero"
echo "LEEME.extra le dice como hacerlo."
echo

%clean
rm -r $RPM_BUILD_ROOT

%files
%doc LEEME.extra PAQUETES PROYECTO
%dir /usr/man/es
/usr/man/es/man?
/var/catman/es
#/usr/local/sbin/makewhatis.es
#%config /etc/cron.weekly/makewhatis-es.cron

%preun

%postun
echo
echo "Para que la desinstalaci�n est� completa, puede ser que tenga que"
echo "borrar manualmente los directorios /usr/doc/man-pages-es-extra-0.8a"
echo "y /usr/man/es."
echo
