# SPDX-License-Identifier: GPL-2.0-only

ARCH:=mips
BOARDNAME:=Realtek RTL8198C legacy
FEATURES:=squashfs ramdisk
SUBTARGET:=rtl8198c
CPU_TYPE:=24kc
KERNEL_PATCHVER:=3.10

define Target/Description
  Legacy Realtek RTL8198C target for GN866 AC-class MIPS routers.
endef
