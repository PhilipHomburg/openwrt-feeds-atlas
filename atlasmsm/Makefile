#

include $(TOPDIR)/rules.mk

PKG_NAME:=atlasmsm
PKG_VERSION:=2.4.0
PKG_RELEASE:=1
PKG_FLAGS:=essential

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/RIPE-NCC/ripe-atlas-probe-busybox.git
PKG_SOURCE_VERSION:=cb459ead90652308c3d4892b54e66e8cb2c5b9aa
PKG_MIRROR_HASH:=07123540255bdb1efc25a59d2517d71c5ef189e69140d66e9f39a3cbbc6c7854

# For V3 probes:
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DEPENDS:=BUSYBOX_USE_LIBRPC:librpc
PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1
PKG_CHECK_FORMAT_SECURITY:=0

include $(INCLUDE_DIR)/package.mk

ifeq ($(DUMP),)
	STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell $(SH_FUNC) grep '^CONFIG_BUSYBOX_' $(TOPDIR)/.config | md5s)
endif


define Package/atlasmsm
  SECTION:=net
  CATEGORY:=Network
  MAINTAINER:=Philip Homburg <phomburg@ripe.net>
  TITLE:=RIPE NCC Atlas 
  URL:=http://atlas.ripe.net
  DEPENDS:=+BUSYBOX_USE_LIBRPC:librpc
  DEPENDS:=+libevent2 +libevent2-openssl
  MENU:=1
endef

define Package/atlassbb/description
 Atlas Measurements
endef

define Package/atlasmsm/config
	source "$(SOURCE)/Config.in"
endef

define Build/Configure
	rm -f $(PKG_BUILD_DIR)/.configured*
	yes '' | $(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KBUILD_HAVE_NLS=no \
		ARCH="$(ARCH)" \
		oldconfig
endef

ifdef CONFIG_GCC_VERSION_LLVM
  TARGET_CFLAGS += -fnested-functions
endif

LDLIBS:=m crypt event event_openssl ssl crypto
ifdef CONFIG_BUSYBOX_USE_LIBRPC
  TARGET_CFLAGS += -I$(STAGING_DIR)/usr/include
  export LDFLAGS=$(TARGET_LDFLAGS)
  LDLIBS += rpc
endif

define Build/Compile
	echo test
	set
	$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR)/../$(PKG_SOURCE_SUBDIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KBUILD_HAVE_NLS=no \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
		ARCH="$(ARCH)" \
		SKIP_STRIP=y \
		LDLIBS="$(LDLIBS)" \
		all
	rm -rf $(PKG_INSTALL_DIR)/home/atlas/bb-13.3
	$(FIND) $(PKG_BUILD_DIR) -lname "*busybox" -exec rm \{\} \;
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
		ARCH="$(ARCH)" \
		CONFIG_PREFIX="$(PKG_INSTALL_DIR)/home/atlas/bb-13.3" \
		LDLIBS="$(LDLIBS)" \
		install
endef

define Package/atlasmsm/install
	$(INSTALL_DIR) $(1)/
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
	-rm -rf $(1)/lib64
endef

$(eval $(call BuildPackage,atlasmsm))
