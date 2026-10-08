# SPDX-License-Identifier: GPL-2.0-only
include ./common.mk

define Device/gn866_ac
  SOC := rtl8198c
  DEVICE_VENDOR := Aborgda
  DEVICE_MODEL := GN866 AC
  DEVICE_PACKAGES += kmod-rtl8192er kmod-rtl8192enb kmod-rtl8822be
  KERNEL := kernel-bin | append-dtb | rt-compress
  KERNEL_INITRAMFS := kernel-bin | append-dtb | rt-compress
  IMAGE_SIZE := 16m
  IMAGES += factory.bin
  IMAGE/factory.bin := append-kernel | pad-to 64k | append-rootfs | pad-rootfs | check-size
endef
TARGET_DEVICES += gn866_ac
