include $(TOPDIR)/rules.mk

PKG_NAME:=rtl819x-vendor-wlan
PKG_RELEASE:=1

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/rtl8192er
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek RTL8192ER legacy WLAN driver
  FILES:=$(PKG_BUILD_DIR)/rtl8192er.ko
  AUTOLOAD:=$(call AutoProbe,rtl8192er)
endef
$(eval $(call KernelPackage,rtl8192er))

define KernelPackage/rtl8192enb
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek RTL8192ENB legacy WLAN driver
  FILES:=$(PKG_BUILD_DIR)/rtl8192enb.ko
  AUTOLOAD:=$(call AutoProbe,rtl8192enb)
endef
$(eval $(call KernelPackage,rtl8192enb))

define KernelPackage/rtl8822be
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek RTL8822BE legacy WLAN driver
  FILES:=$(PKG_BUILD_DIR)/rtl8822be.ko
  AUTOLOAD:=$(call AutoProbe,rtl8822be)
endef
$(eval $(call KernelPackage,rtl8822be))

define Build/Compile
	@mkdir -p $(PKG_BUILD_DIR)
	@echo "Legacy Realtek WLAN package skeleton; proprietary source must be supplied for actual module compilation."
endef

define Package/rtl819x-vendor-wlan/Default
endef
