include $(TOPDIR)/rules.mk

LZMA_TEXT_START:=0x80a00000
LOADER:=loader.bin
LOADER_NAME:=$(basename $(notdir $(LOADER)))
LOADER_DATA:=
TARGET_DIR:=
FLASH_OFFS:=
FLASH_MAX:=
BOARD:=
ifeq ($(TARGET_DIR),)
TARGET_DIR:=$(KDIR)
endif
LOADER_BIN:=$(TARGET_DIR)/$(LOADER_NAME).bin
LOADER_ELF:=$(TARGET_DIR)/$(LOADER_NAME).elf
PKG_NAME:=lzma-loader
PKG_BUILD_DIR:=$(KDIR)/$(PKG_NAME)
.PHONY: loader-compile loader.bin loader.elf
$(PKG_BUILD_DIR)/.prepared:
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
	touch $@
loader-compile: $(PKG_BUILD_DIR)/.prepared
	$(MAKE) -C $(PKG_BUILD_DIR) CROSS_COMPILE="$(TARGET_CROSS)" LZMA_TEXT_START=$(LZMA_TEXT_START) LOADER_DATA=$(LOADER_DATA) FLASH_OFFS=$(FLASH_OFFS) FLASH_MAX=$(FLASH_MAX) BOARD="$(BOARD)" clean all
loader.bin: $(PKG_BUILD_DIR)/loader.bin
	$(CP) $< $(LOADER_BIN)
loader.elf: $(PKG_BUILD_DIR)/loader.elf
	$(CP) $< $(LOADER_ELF)
compile: loader-compile
clean:
	rm -rf $(PKG_BUILD_DIR)
