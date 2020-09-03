################################################################################
#
# sofia-sip
#
################################################################################

SOFIA_SIP_VERSION = 1.13.1-d10a3d268c
SOFIA_SIP_SITE = https://files.freeswitch.org/downloads/libs
SOFIA_SIP_INSTALL_STAGING = YES
SOFIA_SIP_DEPENDENCIES = host-pkgconf
SOFIA_SIP_LICENSE = LGPL-2.1+
SOFIA_SIP_LICENSE_FILES = COPYING COPYRIGHTS
SOFIA_SIP_CONF_OPTS = --with-doxygen=no

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
SOFIA_SIP_CONF_OPTS += --with-glib
SOFIA_SIP_DEPENDENCIES += libglib2
else
SOFIA_SIP_CONF_OPTS += --without-glib
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SOFIA_SIP_CONF_OPTS += --with-openssl
SOFIA_SIP_DEPENDENCIES += openssl
else
SOFIA_SIP_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
SOFIA_SIP_CONF_OPTS += --enable-ndebug
endif

$(eval $(autotools-package))
