NAME=		naemon2influx-grafana-helper
VERSION=	$( dpkg-parsechangelog -S Version | sed -e 's/-.*//' )
UPSTREAM_PACKAGE=naemon2influx-grafana-helper_${VERSION}.orig.tar.gz
VERSION=	0.1
RELEASE=	01

RPM=		${HOME}/rpmbuild/RPMS/x86_64/${NAME}-${VERSION}-${RELEASE}.el7.x86_64.rpm
DEB=		${NAME}-${VERSION}-${RELEASE}.deb

BUILD=		${NAME}-${VERSION}-${RELEASE}
DEBIAN=		${BUILD}/DEBIAN
SPEC=		${NAME}.spec
TMPL=		${NAME}.tmpl
TEMPLATEDIR=	/etc/naemon/naemon2influx-grafana-helper.d
TEMPLATES=	generic.tmpl gpercent.tmpl gvolume.tmpl cpu.tmpl mem.tmpl disk.tmpl
DESTDIR=	

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
	mkdir -p ${DESTDIR}/usr/share/grafana/public/dashboards ${DESTDIR}/var/cache/naemon
	ln -s /var/cache/naemon/naemon2influx-grafana-helper.js ${DESTDIR}/usr/share/grafana/public/dashboards/naemon2influx-grafana-helper.js

#rpm:	${RPM}

#${RPM}: ${SPEC}
#	@echo "Building ${NAME} rpm ..."
#	@rm -f ${RPM}
#	@rpmbuild -bb ${SPEC}

#${SPEC}:	${TMPL} ${MAKEFILE}
#	@sed -s 's/__NAME__/${NAME}/g;s/__RELEASE__/${RELEASE}/g;s/__VERSION__/${VERSION}/g;' ${TMPL} > ${SPEC}

${DEB}:	${DEBIAN} control naemon2influx-grafana-helper naemon2influx-grafana-helper.conf naemon2influx-grafana-helper.rules ${TEMPLATES}
#	@sed -s 's/__NAME__/${NAME}/g;s/__RELEASE__/${RELEASE}/g;s/__VERSION__/${VERSION}/g;' control > ${DEBIAN}/control
#	@mkdir -p ${BUILD}/usr/share/doc/naemon2influx-grafana-helper
#	@install -m 0755 naemon2influx-grafana-helper ${BUILD}/usr/bin
#	@mkdir -p ${BUILD}/usr/bin ${BUILD}/usr/share/man/man1 ${BUILD}/usr/share/man/man5
#	@install -m 0755 naemon2influx-grafana-helper ${BUILD}/usr/bin
#	@mkdir -p ${BUILD}/etc/init.d
#	@echo /etc/init.d/naemon2influx-grafana-helper > ${DEBIAN}/conffiles
#	@install -m 0755 naemon2influx-grafana-helper.init ${BUILD}/etc/init.d/naemon2influx-grafana-helper
#	@mkdir -p ${BUILD}/etc/naemon
#	@echo /etc/naemon/naemon2influx-grafana-helper.conf >> ${DEBIAN}/conffiles
#	@install -m 0644 naemon2influx-grafana-helper.conf ${BUILD}/etc/naemon
#	@echo /etc/naemon/naemon2influx-grafana-helper.rules >> ${DEBIAN}/conffiles
#	@install -m 0644 naemon2influx-grafana-helper.rules ${BUILD}/etc/naemon
#	@mkdir -p ${BUILD}/etc/naemon/naemon2influx-grafana-helper.d
#	@for i in ${TEMPLATES} ; do echo ${TEMPLATEDIR}/$$i ; install -m 0644 $$i ${BUILD}${TEMPLATEDIR}/$$i ; done >> ${DEBIAN}/conffiles
#	@mkdir -p ${BUILD}/usr/share/grafana/public/dashboards ${BUILD}/var/cache/naemon
#	@ln -s /var/cache/naemon/naemon2influx-grafana-helper.js ${BUILD}/usr/share/grafana/public/dashboards/naemon2influx-grafana-helper.js
#	@dpkg-deb --build ${BUILD}
#	@rm -rf ${BUILD}


../${UPSTREAM_PACKAGE}:
	tar cvzf ../${UPSTREAM_PACKAGE} . --exclude .git

