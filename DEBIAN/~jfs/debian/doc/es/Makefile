
all: FAQ maint-guide

FAQ: .FAQ-stamp
.FAQ-stamp:
	cd FAQ/FAQ && make publish
	touch .FAQ-stamp


maint-guide: .maint-guide-stamp
.maint-guide-stamp:
	cd maint-guide && make
	touch .maint-guide-stamp

FTPDIR=ftp.rediris.es/pub/linux/distributions/debian/dists/frozen/main/disks-i386/current/doc

installation: .installation-stamp
.installation-stamp:
	wget -nd -P installation/ -q --proxy=off -l1 -m ftp://$(FTPDIR)/es
	touch .installation-stamp

clean:
	rm -f .maint-guide-stamp .FAQ-stamp .installation-stamp
	cd FAQ/FAQ/ && make clean
	cd maint-guide && make clean
	rm -rf installation/

update:
	cd packages && apt-get source doc-debian-es maint-guide-es

