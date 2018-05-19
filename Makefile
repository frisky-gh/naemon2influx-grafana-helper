NAME=		naemon2influx-grafana-helper
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

all:	deb

clean:
	@rm -rf ${SPEC} ${RPM} ${DEB} naemon2influx.1.gz naemon2influx.cfg.5.gz ${BUILD}

install:
	@pod2man naemon2influx | gzip > /usr/share/man/man1/naemon2influx.1.gz
	@pod2man --section 5 naemon2influx.cfg.pod | gzip > /usr/share/man/man5/naemon2influx.cfg.5.gz
	@install -m 0755 naemon-perf /usr/bin
	@install -m 0755 naemon2influx /usr/bin
	@install -m 0640 naemon2influx.cfg /etc/naemon

#rpm:	${RPM}

#${RPM}: ${SPEC}
#	@echo "Building ${NAME} rpm ..."
#	@rm -f ${RPM}
#	@rpmbuild -bb ${SPEC}

#${SPEC}:	${TMPL} ${MAKEFILE}
#	@sed -s 's/__NAME__/${NAME}/g;s/__RELEASE__/${RELEASE}/g;s/__VERSION__/${VERSION}/g;' ${TMPL} > ${SPEC}

deb:	${DEB}

${DEB}:	${DEBIAN} control naemon2influx-grafana-helper naemon2influx-grafana-helper.init naemon2influx-grafana-helper.conf naemon2influx-grafana-helper.rules ${TEMPLATES}
	@sed -s 's/__NAME__/${NAME}/g;s/__RELEASE__/${RELEASE}/g;s/__VERSION__/${VERSION}/g;' control > ${DEBIAN}/control
	@mkdir -p ${BUILD}/usr/bin ${BUILD}/usr/share/man/man1 ${BUILD}/usr/share/man/man5
	@install -m 0755 naemon2influx-grafana-helper ${BUILD}/usr/bin
	@mkdir -p ${BUILD}/etc/init.d
	@echo /etc/init.d/naemon2influx-grafana-helper > ${DEBIAN}/conffiles
	@install -m 0755 naemon2influx-grafana-helper.init ${BUILD}/etc/init.d/naemon2influx-grafana-helper
	@mkdir -p ${BUILD}/etc/naemon
	@echo /etc/naemon/naemon2influx-grafana-helper.conf >> ${DEBIAN}/conffiles
	@install -m 0644 naemon2influx-grafana-helper.conf ${BUILD}/etc/naemon
	@echo /etc/naemon/naemon2influx-grafana-helper.rules >> ${DEBIAN}/conffiles
	@install -m 0644 naemon2influx-grafana-helper.rules ${BUILD}/etc/naemon
	@mkdir -p ${BUILD}/etc/naemon/naemon2influx-grafana-helper.d
	@for i in ${TEMPLATES} ; do echo ${TEMPLATEDIR}/$$i ; install -m 0644 $$i ${BUILD}${TEMPLATEDIR}/$$i ; done >> ${DEBIAN}/conffiles
	@mkdir -p ${BUILD}/usr/share/grafana/public/dashboards ${BUILD}/var/cache/naemon
	@ln -s /var/cache/naemon/naemon2influx-grafana-helper.js ${BUILD}/usr/share/grafana/public/dashboards/naemon2influx-grafana-helper.js
#	@pod2man naemon2influx | gzip > ${BUILD}/usr/share/man/man1/naemon2influx.1.gz
#	@pod2man --section 5 naemon2influx.cfg.pod | gzip > ${BUILD}/usr/share/man/man5/naemon2influx.cfg.5.gz
	@dpkg-deb --build ${BUILD}
	@rm -rf ${BUILD}

${DEBIAN}: ${BUILD}
	@mkdir -p ${DEBIAN}

${BUILD}:
	@mkdir -p ${NAME}-${VERSION}-${RELEASE}

