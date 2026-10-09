include $(TOPDIR)/rules.mk

PKG_NAME:=rtl819x-gn866-wlan-compat
PKG_RELEASE:=5

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

# Compatibility names for GN866 images. Use the in-tree Linux drivers so
# modules are built against the exact OpenWrt kernel ABI.
define KernelPackage/rtl8192enb
  SUBMENU:=Wireless Drivers
  TITLE:=RTL8192ENB compatibility metapackage
  DEPENDS:=+kmod-rtl8192ee
  HIDDEN:=1
endef
$(eval $(call KernelPackage,rtl8192enb))

define KernelPackage/rtl8192er
  SUBMENU:=Wireless Drivers
  TITLE:=RTL8192ER compatibility metapackage
  DEPENDS:=+kmod-rtl8192ee
  HIDDEN:=1
endef
$(eval $(call KernelPackage,rtl8192er))

define KernelPackage/rtl8822be
  SUBMENU:=Wireless Drivers
  TITLE:=RTL8822BE compatibility metapackage
  DEPENDS:=+kmod-rtw88-8822be
  HIDDEN:=1
endef
$(eval $(call KernelPackage,rtl8822be))

define KernelPackage/rtl8822b
  SUBMENU:=Wireless Drivers
  TITLE:=RTL8822B compatibility metapackage
  DEPENDS:=+kmod-rtw88-8822b
  HIDDEN:=1
endef
$(eval $(call KernelPackage,rtl8822b))
