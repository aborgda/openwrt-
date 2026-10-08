# SPDX-License-Identifier: GPL-2.0-only

ARCH:=mips
BOARDNAME:=Realtek RTL8198C GN866 AC
FEATURES:=squashfs ramdisk
SUBTARGET:=rtl8198c
CPU_TYPE:=24kc

# Modern OpenWrt kernel target.
KERNEL_PATCHVER:=6.18

define Target/Description
  Modern OpenWrt 6.18 target for the Realtek RTL8198C GN866 AC.
  The separate legacy vendor workflow remains available for the original
  RTL819X SDK 3.4.7.3 / Linux 3.10 factory image.
endef
