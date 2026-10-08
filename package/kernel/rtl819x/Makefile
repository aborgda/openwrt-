include $(TOPDIR)/rules.mk

PKG_NAME:=rtl819x-gn866-wlan-compat
PKG_RELEASE:=2

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

# GN866 compatibility names. The actual 6.18 drivers come from OpenWrt's
# mac80211/rtw88 stack; these packages keep the legacy GN866 package names
# while selecting the correct in-kernel modules.

define KernelPackage/rtl8192enb
  SUBMENU:=Wireless Drivers
  TITLE:=RTL8192ENB compatibility package (RTL8192EE)
  DEPENDS:=+kmod-rtl8192ee
  HIDDEN:=1
endef
$(eval $(call KernelPackage,rtl8192enb))

define KernelPackage/rtl8822be
  SUBMENU:=Wireless Drivers
  TITLE:=RTL8822BE compatibility package (rtw88)
  DEPENDS:=+kmod-rtw88-8822be +rtw88-firmware
  HIDDEN:=1
endef
$(eval $(call KernelPackage,rtl8822be))

define KernelPackage/rtl8822b
  SUBMENU:=Wireless Drivers
  TITLE:=RTL8822B compatibility package (rtw88 core)
  DEPENDS:=+kmod-rtw88-8822b
  HIDDEN:=1
endef
$(eval $(call KernelPackage,rtl8822b))

define KernelPackage/rtl8192er
  SUBMENU:=Wireless Drivers
  TITLE:=RTL8192ER compatibility package
  DEPENDS:=+kmod-rtl8192ee
  HIDDEN:=1
endef
$(eval $(call KernelPackage,rtl8192er))
