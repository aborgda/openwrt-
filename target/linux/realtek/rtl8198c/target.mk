# SPDX-License-Identifier: GPL-2.0-only

ARCH:=mips
BOARDNAME:=Realtek RTL8198C
FEATURES:=squashfs ramdisk
SUBTARGET:=rtl8198c
CPU_TYPE:=24kc

define Target/Description
  RTL8198C MIPS boards, including GN866 AC legacy hardware.
endef
