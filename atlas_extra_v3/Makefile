#

include $(TOPDIR)/rules.mk

PKG_NAME:=atlas_extra_v3
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_FLAGS:=essential

PKG_BUILD_PARALLEL:=1
PKG_CHECK_FORMAT_SECURITY:=0

include $(INCLUDE_DIR)/package.mk

define Package/atlas_extra_v3
  SECTION:=net
  CATEGORY:=Network
  MAINTAINER:=Philip Homburg <phomburg@ripe.net>
  TITLE:=Atlas V4 Probe Extra Config
  URL:=http://atlas.ripe.net
  MENU:=1
endef

define Package/atlas_extra_v3/description
  Atlas V4 Rpobe Extra Config
endef

define Package/atlas_extra_v3/config
endef

define Build/Compile
endef

define Package/atlas_extra_v3/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./files/etc/udhcpc.user $(1)/etc/udhcpc.user
	$(INSTALL_DATA) ./files/etc/passwd $(1)/etc/passwd
	$(INSTALL_DIR) $(1)/home/atlas/.ssh
	$(INSTALL_DIR) $(1)/home/atlas/bin
	$(CP) ./files/home/atlas/bin/* $(1)/home/atlas/bin/
	$(INSTALL_DIR) $(1)/home/atlas/etc 
	$(CP) ./files/home/atlas/etc/* $(1)/home/atlas/etc/
endef

$(eval $(call BuildPackage,atlas_extra_v3))
