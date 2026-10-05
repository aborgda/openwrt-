# SPDX-License-Identifier: GPL-2.0-only

ARCH:=mips
SUBTARGET:=rtl8198c
CPU_TYPE:=24kec
BOARD:=realtek
BOARDNAME:=Realtek MIPS RTL8198C (legacy 3.10.49)
KERNEL_PATCHVER:=3.10
KERNEL_TESTING:=
FEATURES:=squashfs usb

# RTL8198C uses the vendor/OpenWrt 3.10.49 kernel and its legacy image tools.
LINUX_VERSION:=3.10.49

define Target/Description
	Legacy RTL8198C boards: GN866 AC and SK337.
endef
