# Legacy RTL8198C image format.
# This follows the original Realtek cvimg/fix_chksum layout:
# loader + kernel, 4 KiB alignment, squashfs, then firmware checksum.
BLOCKSIZE_RTL8198C:=4k

define Build/rtl8198c-lzma-loader
 rm -rf $(KDIR)/rtl8198c-lzma-loader
 $(MAKE) -C lzma-loader KDIR=$(KDIR) LINUX_DIR=$(LINUX_DIR)    LOADER=loader-$(DEVICE_NAME).bin    KERNEL_CMDLINE="$(KERNEL_CMDLINE)"    LZMA_TEXT_START=0x80500000 LOADADDR=0x80000000    LOADER_DATA="$(KDIR)/vmlinux.bin.lzma" BOARD="$(DEVICE_NAME)" compile loader.bin
endef

define Build/rtl8198c-cvimg
 cvimg-rtl8198c linux "$@" "$@.linux" 0x60000 0x20000
 mv "$@.linux" "$@"
endef

define Build/rtl8198c-fix-checksum
 cvimg-rtl8198c fix_chksum "$@" "$@.new"
 mv "$@.new" "$@"
endef

define Device/rtl8198c
 DEVICE_VENDOR := Realtek
 DEVICE_DTS_DIR := ../dts
 KERNEL_LOADADDR := 0x80500000
 KERNEL := kernel-bin | lzma | rtl8198c-lzma-loader
 IMAGES := factory.bin
endef

define Device/gn866_ac
 $(Device/rtl8198c)
 DEVICE_MODEL := GN866 AC
 DEVICE_NAME := gn866_ac
 FLASH_SIZE := 16M
 KERNEL_CMDLINE := board=gn866_ac console=ttyS0,38400 root=/dev/mtdblock2 linuxpart=0x60000 hwpart=0x20000
 IMAGE/factory.bin := append-kernel | append-rootfs | pad-rootfs | rtl8198c-fix-checksum
endef

define Device/sk337
 $(Device/rtl8198c)
 DEVICE_MODEL := SK337
 DEVICE_NAME := sk337
 FLASH_SIZE := 32M
 KERNEL_CMDLINE := board=sk337 console=ttyS0,38400 root=/dev/mtdblock2 linuxpart=0x60000 hwpart=0x20000
 IMAGE/factory.bin := append-kernel | append-rootfs | pad-rootfs | rtl8198c-fix-checksum
endef

TARGET_DEVICES += gn866_ac sk337
