#

include $(TOPDIR)/rules.mk

PKG_NAME:=atlasprobe
PKG_VERSION:=5050
PKG_RELEASE:=1
PKG_FLAGS:=essential

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/RIPE-NCC/ripe-atlas-software-probe.git
PKG_SOURCE_VERSION:=3c30aa25aaa7ed55d8e398f2ccc2e8f4d93e3f4e
#PKG_MIRROR_HASH:=1afb1587fcc689e3e05dcf7151d29b2040a8dc0f88c3766e47a4dd4335867bed

# For V3 probes:
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

PKG_BUILD_DIR=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)
PKG_BUILD_PARALLEL:=1
PKG_CHECK_FORMAT_SECURITY:=0

include $(INCLUDE_DIR)/package.mk

define Package/atlasprobe
  SECTION:=net
  CATEGORY:=Network
  MAINTAINER:=Philip Homburg <phomburg@ripe.net>
  TITLE:=RIPE NCC Atlas Probe Scripts
  URL:=http://atlas.ripe.net
  MENU:=1
endef

define Package/atlassprobe/description
 Atlas Probe Scripts
endef

define Package/atlasprobe/config
endef

define Build/Compile
endef

define Package/atlasprobe/install
	$(INSTALL_DIR) $(1)/home/atlas/bin
	$(CP) $(PKG_BUILD_DIR)/bin/* $(1)/home/atlas/bin
	$(INSTALL_DIR) $(1)/home/atlas/state
	$(CP) $(PKG_BUILD_DIR)/atlas-config/state/* $(1)/home/atlas/state/
	$(LN) -s /tmp/status $(1)/home/atlas/status
	$(LN) -s /storage/crons $(1)/home/atlas/crons
	$(LN) -s /tmp/data $(1)/home/atlas/data
endef

$(eval $(call BuildPackage,atlasprobe))
