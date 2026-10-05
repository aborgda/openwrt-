# SPDX-License-Identifier: GPL-2.0-only
include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=realtek
BOARDNAME:=Realtek RTL8198C legacy MIPS
SUBTARGETS:=rtl8198c
FEATURES:=squashfs usb
LINUX_VERSION:=3.10.49

include $(INCLUDE_DIR)/target.mk

define Target/Description
	Legacy Realtek RTL8198C boards (GN866 AC / SK337).
endef

$(eval $(call BuildTarget))
