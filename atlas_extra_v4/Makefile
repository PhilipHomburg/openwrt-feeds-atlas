#

include $(TOPDIR)/rules.mk

PKG_NAME:=atlas_extra_v4
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_FLAGS:=essential

PKG_BUILD_PARALLEL:=1
PKG_CHECK_FORMAT_SECURITY:=0

include $(INCLUDE_DIR)/package.mk

define Package/atlas_extra_v4
  SECTION:=net
  CATEGORY:=Network
  MAINTAINER:=Philip Homburg <phomburg@ripe.net>
  TITLE:=Atlas V4 Probe Extra Config
  URL:=http://atlas.ripe.net
  MENU:=1
endef

define Package/atlas_extra_v4/description
  Atlas V4 Rpobe Extra Config
endef

define Package/atlas_extra_v4/config
endef

define Build/Compile
endef

define Package/atlas_extra_v4/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./files/etc/udhcpc.user $(1)/etc/udhcpc.user
	$(INSTALL_DIR) $(1)/etc/init.d
	$(CP) ./files/etc/init.d/* $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/home/atlas/.ssh
	$(INSTALL_DIR) $(1)/home/atlas/bin
	$(CP) ./files/home/atlas/bin/* $(1)/home/atlas/bin/
	$(INSTALL_DIR) $(1)/home/atlas/etc 
	$(CP) ./files/home/atlas/etc/* $(1)/home/atlas/etc/
	$(INSTALL_DIR) $(1)/home/atlas/state
	$(CP) ./files/home/atlas/state/mode $(1)/home/atlas/state/
endef

$(eval $(call BuildPackage,atlas_extra_v4))
