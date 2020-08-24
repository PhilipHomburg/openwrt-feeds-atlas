#

include $(TOPDIR)/rules.mk

PKG_NAME:=atlasprobe
PKG_VERSION:=5021
PKG_RELEASE:=6
PKG_FLAGS:=essential

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=ssh://git@gitlab7999/phomburg/ripe-atlas-software-probe.git
PKG_SOURCE_VERSION:=252b715a02487a62a2c54f36963bf8ba063bd549
#PKG_MIRROR_HASH:=a830a8ab056671603ffb3db738ea28c5258f48a9b7a539fa21fb8fd9a5eba90a

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
