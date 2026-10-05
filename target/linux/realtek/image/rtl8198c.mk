# SPDX-License-Identifier: GPL-2.0-only
# RTL8198C legacy image format: LZMA loader + kernel + squashfs + cvimg checksum.

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

BlockSize=4k

ifeq ($(CONFIG_TARGET_realtek_rtl8198c),y)

define mkcmdline
board=$(1) console=$(2),$(3) linuxpart=0x$(4) hwpart=0x$(5)
endef

SINGLE_PROFILES :=

define SingleProfile
  define Image/Build/Profile/$(1)/initramfs
	$(call Image/BuildLoader,loader-$(SUBTARGET)-$(1),bin,$(call mkcmdline,$(1),$(2),$(3)),$(5))
	cvimg-$(SUBTARGET) linux $(KDIR)/loader-$(SUBTARGET)-$(1).bin $(BIN_DIR)/$(IMG_PREFIX)-$(1)-ramfs.bin $(5) $(6)
  endef
  define Image/Build/Profile/$(1)/squashfs
	$(call Image/BuildLoader,loader-$(SUBTARGET)-$(1),bin,$(call mkcmdline,$(1),$(2),$(3),$(6),$(7)),$(5))
	cvimg-$(SUBTARGET) linux $(KDIR)/loader-$(SUBTARGET)-$(1).bin $(BIN_DIR)/$(IMG_PREFIX)-$(1)-linux.bin $(5) $(6)
	dd if=$(BIN_DIR)/$(IMG_PREFIX)-$(1)-linux.bin of=$(BIN_DIR)/$(IMG_PREFIX)-$(1)-linux_4k.bin bs=4k conv=sync
	cat $(BIN_DIR)/$(IMG_PREFIX)-$(1)-linux_4k.bin $(KDIR)/root.squashfs-4k > $(BIN_DIR)/$(IMG_PREFIX)-$(1)-fw_4k_cat.bin
	cvimg-$(SUBTARGET) fix_chksum $(BIN_DIR)/$(IMG_PREFIX)-$(1)-fw_4k_cat.bin $(BIN_DIR)/$(IMG_PREFIX)-$(1)-fw.bin
	rm -f $(BIN_DIR)/$(IMG_PREFIX)-$(1)-linux_4k.bin $(BIN_DIR)/$(IMG_PREFIX)-$(1)-fw_4k_cat.bin $(BIN_DIR)/$(IMG_PREFIX)-$(1)-linux.bin
  endef
  SINGLE_PROFILES += $(1)
endef

define Image/Prepare
	lzma e $(KDIR)/vmlinux -lc1 -lp2 -pb2 $(KDIR)/vmlinux.bin.lzma
endef

LOADER_MAKE := $(NO_TRACE_MAKE) -C lzma-loader KDIR=$(KDIR) LINUX_DIR=$(LINUX_DIR)

define Image/Build/Clean
	$(LOADER_MAKE) clean
endef

define Image/BuildLoader
	-rm -rf $(KDIR)/lzma-loader
	$(LOADER_MAKE) LOADER=$(1).$(2) KERNEL_CMDLINE="$(3)" LZMA_TEXT_START=$(4) LOADADDR=0x80000000 LOADER_DATA="$(KDIR)/vmlinux.bin.lzma" BOARD="$(1)" compile loader.$(2)
endef

$(eval $(call SingleProfile,GN866_AC,ttyS0,38400,root=/dev/mtdblock2,0x80500000,60000,20000))
$(eval $(call SingleProfile,SK337,ttyS0,38400,root=/dev/mtdblock2,0x80500000,60000,20000))

define Image/Build/Initramfs
	$(call Image/Build/Profile/$(PROFILE)/initramfs)
endef

define Image/Build
	dd if=$(KDIR)/root.squashfs of=$(KDIR)/root.squashfs-4k bs=4k conv=sync
	$(call add_jffs2_mark,$(KDIR)/root.squashfs-4k)
	$(call Image/Build/Profile/$(PROFILE)/squashfs)
endef

endif

$(eval $(call BuildImage))
