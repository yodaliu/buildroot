################################################################################
#
# rocksdb
#
################################################################################

ROCKSDB_VERSION = 6.6.4
ROCKSDB_SITE = $(call github,facebook,rocksdb,v$(ROCKSDB_VERSION))
ROCKSDB_LICENSE = GPL-2.0 or Apache-2.0
ROCKSDB_LICENSE_FILES = COPYING LICENSE.Apache LICENSE.leveldb README.md
ROCKSDB_INSTALL_STAGING = YES

ROCKSDB_MAKE_OPTS = PORTABLE=1

ifeq ($(BR2_PACKAGE_BZIP2),y)
ROCKSDB_DEPENDENCIES += bzip2
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_BZ2=0
else
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_BZ2=1
endif

ifeq ($(BR2_PACKAGE_GFLAGS),y)
ROCKSDB_DEPENDENCIES += gflags
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_GFLAGS=0
else
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_GFLAGS=1
endif

ifeq ($(BR2_PACKAGE_JEMALLOC),y)
ROCKSDB_DEPENDENCIES += jemalloc
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_JEMALLOC=0
else
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_JEMALLOC=1
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
ROCKSDB_DEPENDENCIES += lz4
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_LZ4=0
else
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_LZ4=1
endif

ifeq ($(BR2_PACKAGE_SNAPPY),y)
ROCKSDB_DEPENDENCIES += snappy
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_SNAPPY=0
else
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_SNAPPY=1
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ROCKSDB_DEPENDENCIES += zlib
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_ZLIB=0
else
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_ZLIB=1
endif

ifeq ($(BR2_PACKAGE_ZSTD),y)
ROCKSDB_DEPENDENCIES += zstd
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_ZSTD=0
else
ROCKSDB_MAKE_OPTS += ROCKSDB_DISABLE_ZSTD=1
endif

ifeq ($(BR2_STATIC_LIBS),y)
ROCKSDB_BUILD_TARGETS += static_lib
ROCKSDB_INSTALL_TARGETS += install-static
else ifeq ($(BR2_SHARED_LIBS),y)
ROCKSDB_BUILD_TARGETS += shared_lib
ROCKSDB_INSTALL_TARGETS += install-shared
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
ROCKSDB_BUILD_TARGETS += shared_lib static_lib
ROCKSDB_INSTALL_TARGETS += install-shared install-static
endif

define ROCKSDB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(ROCKSDB_MAKE_OPTS) -C $(@D) \
		$(ROCKSDB_BUILD_TARGETS)
endef

define ROCKSDB_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(ROCKSDB_MAKE_OPTS) -C $(@D) \
		INSTALL_PATH=$(STAGING_DIR) $(ROCKSDB_INSTALL_TARGETS)
endef

define ROCKSDB_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(ROCKSDB_MAKE_OPTS) -C $(@D) \
		INSTALL_PATH=$(TARGET_DIR) $(ROCKSDB_INSTALL_TARGETS)
endef

$(eval $(generic-package))
