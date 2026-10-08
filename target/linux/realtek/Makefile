# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=realtek
BOARDNAME:=Realtek MIPS
DEVICE_TYPE:=basic
FEATURES:=ramdisk squashfs
SUBTARGETS:=rtl838x rtl839x rtl930x rtl930x_nand rtl931x rtl931x_nand rtl8198c

KERNEL_PATCHVER:=6.18

ifeq ($(SUBTARGET),rtl8198c)
  KERNEL_PATCHVER:=3.10
endif

define Target/Description
	Build firmware images for Realtek RTL83xx/RTL93xx and legacy RTL8198C based boards.
endef

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += 	ethtool 	firewall4 	kmod-gpio-button-hotplug 	odhcp6c 	uboot-envtools 
$(eval $(call BuildTarget))
