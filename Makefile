NAME=		naemon2influx-grafana-helper
VERSION!=	dpkg-parsechangelog -S Version | sed -e 's/-.*//'
RELEASE!=	dpkg-parsechangelog -S Version | sed -e 's/.*-//'
UPSTREAM_PACKAGE=naemon2influx-grafana-helper_$(VERSION).orig.tar.gz
DESTDIR=	

TEMPLATEDIR=	/etc/naemon/naemon2influx-grafana-helper.d
TEMPLATES=	generic.tt gcounter.tt gpercent.tt gvolume.tt gpm.tt cpu.tt mem.tt disk.tt dev.tt port.tt link.tt naemon2influx-grafana-helper.tt

all:	build

clean: ../${UPSTREAM_PACKAGE}
	rm -rf ${SPEC} ${RPM} ${DEB} naemon2influx-grafana-helper.1.gz naemon2influx-grafana-helper.conf.5.gz naemon2influx-grafana-helper.rules.5.gz ${BUILD}

build:
	pod2man naemon2influx-grafana-helper | gzip > naemon2influx-grafana-helper.1.gz
	pod2man --section 5 naemon2influx-grafana-helper.conf.pod | gzip > naemon2influx-grafana-helper.conf.5.gz
	pod2man --section 5 naemon2influx-grafana-helper.rules.pod | gzip > naemon2influx-grafana-helper.rules.5.gz

install:
	install -m 0755 naemon2influx-grafana-helper ${DESTDIR}/usr/bin
	install -m 0644 naemon2influx-grafana-helper.conf ${DESTDIR}/etc/naemon
	install -m 0644 naemon2influx-grafana-helper.rules ${DESTDIR}/etc/naemon
	install -m 0644 ${TEMPLATES} ${DESTDIR}/etc/naemon/naemon2influx-grafana-helper.d
	mkdir -p ${DESTDIR}/etc/cron.hourly
	install -m 0644 -T cron.hourly ${DESTDIR}/etc/cron.hourly/naemon2influx-grafana-helper
	mkdir -p ${DESTDIR}/usr/share/grafana/public/dashboards ${DESTDIR}/var/cache/naemon
	ln -s /var/cache/naemon/naemon2influx-grafana-helper.js ${DESTDIR}/usr/share/grafana/public/dashboards/naemon2influx-grafana-helper.js

#RPM=		${HOME}/rpmbuild/RPMS/x86_64/${NAME}-${VERSION}-${RELEASE}.el7.x86_64.rpm
#SPEC=		${NAME}.spec
#SPECTMPL=	${NAME}.spectmpl

#rpm:	${RPM}

#${RPM}: ${SPEC}
#	@echo "Building ${NAME} rpm ..."
#	@rm -f ${RPM}
#	@rpmbuild -bb ${SPEC}

#${SPEC}:	${TMPL} ${MAKEFILE}
#	@sed -s 's/__NAME__/${NAME}/g;s/__RELEASE__/${RELEASE}/g;s/__VERSION__/${VERSION}/g;' ${SPECTMPL} > ${SPEC}

../${UPSTREAM_PACKAGE}:
	tar cvzf ../${UPSTREAM_PACKAGE} . --exclude .git

