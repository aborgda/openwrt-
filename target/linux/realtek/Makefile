# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=realtek
BOARDNAME:=Realtek MIPS
DEVICE_TYPE:=basic
FEATURES:=ramdisk squashfs
SUBTARGETS:=rtl838x rtl839x rtl930x rtl930x_nand rtl931x rtl931x_nand rtl8198c

# GN866 uses the Linux 6.18 port in this tree.
KERNEL_PATCHVER:=6.18

define Target/Description
	Build firmware images for Realtek RTL83xx/RTL93xx and RTL8198C GN866 AC.
endef

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += \
	ethtool \
	firewall4 \
	kmod-gpio-button-hotplug \
	odhcp6c \
	uboot-envtools \
	linux-firmware

$(eval $(call BuildTarget))
