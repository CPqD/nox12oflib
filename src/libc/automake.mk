noinst_LIBRARIES += libc/libopenflow.a

lib_libopenflow_a_SOURCES = \
	libc/compiler.h \
	libc/dirs.c \
	libc/dirs.h \
	libc/dynamic-string.c \
	libc/dynamic-string.h \
	libc/fatal-signal.c \
	libc/fatal-signal.h \
	libc/fault.c \
	libc/fault.h \
	libc/hash.c \
	libc/hash.h \
	libc/hmap.c \
	libc/hmap.h \
	libc/ipv6_util.c \
	libc/ipv6_util.h \
	libc/list.c \
	libc/list.h \
	libc/oxm-match.c \
	libc/oxm-match.h \
	libc/ofpbuf.c \
	libc/ofpbuf.h \
	libc/packets.h \
	libc/sat-math.h \
	libc/signals.c \
	libc/signals.h \
	libc/tag.c \
	libc/tag.h \
	libc/timeval.c \
	libc/timeval.h \
	libc/type-props.h \
	libc/util.c \
	libc/util.h \
	libc/vlog-modules.def \
	libc/vlog.c \
	libc/vlog.h \

lib_libopenflow_a_LIBADD = oflib/ofl-actions.o \
                           oflib/ofl-actions-pack.o \
                           oflib/ofl-actions-print.o \
                           oflib/ofl-actions-unpack.o \
                           oflib/ofl-messages.o \
                           oflib/ofl-messages-pack.o \
                           oflib/ofl-messages-print.o \
                           oflib/ofl-messages-unpack.o \
                           oflib/ofl-structs.o \
			   oflib/ofl-structs-match.o \
                           oflib/ofl-structs-pack.o \
                           oflib/ofl-structs-print.o \
                           oflib/ofl-structs-unpack.o \
                           oflib/ofl-print.o \
                           oflib-exp/ofl-exp.o \
                           oflib-exp/ofl-exp-nicira.o \
                           oflib-exp/ofl-exp-openflow.o


if HAVE_NETLINK
lib_libopenflow_a_SOURCES += \
	libc/dpif.c \
	libc/dpif.h \
	libc/netlink-protocol.h \
	libc/netlink.c \
	libc/netlink.h \
	libc/vconn-netlink.c
endif

if HAVE_OPENSSL
lib_libopenflow_a_SOURCES += \
	libc/vconn-ssl.c 
nodist_lib_libopenflow_a_SOURCES = libc/dhparams.c
lib/dhparams.c: libc/dh1024.pem libc/dh2048.pem libc/dh4096.pem
	(echo '#include "libc/dhparams.h"' &&				\
	 openssl dhparam -C -in $(srcdir)/libc/dh1024.pem -noout &&	\
	 openssl dhparam -C -in $(srcdir)/libc/dh2048.pem -noout &&	\
	 openssl dhparam -C -in $(srcdir)/libc/dh4096.pem -noout)	\
	| sed 's/\(get_dh[0-9]*\)()/\1(void)/' > libc/dhparams.c.tmp
	mv libc/dhparams.c.tmp libc/dhparams.c
endif

EXTRA_DIST += \
	libc/dh1024.pem \
	libc/dh2048.pem \
	libc/dh4096.pem \
	libc/dhparams.h

CLEANFILES += lib/dirs.c
lib/dirs.c: Makefile
	($(ro_c) && \
	 echo 'const char ofp_pkgdatadir[] = "$(pkgdatadir)";' && \
	 echo 'const char ofp_rundir[] = "@RUNDIR@";' && \
	 echo 'const char ofp_logdir[] = "@LOGDIR@";') > libc/dirs.c.tmp
	 mv libc/dirs.c.tmp lib/dirs.c

install-data-local:
	$(MKDIR_P) $(DESTDIR)$(RUNDIR)
	$(MKDIR_P) $(DESTDIR)$(PKIDIR)
	$(MKDIR_P) $(DESTDIR)$(LOGDIR)
