# Realtek RTL8198C legacy SoC files
extra-y += vmlinux.lds
obj-y := imem-dmem.o prom.o setup.o irq.o timer.o serial.o gpio.o dev_leds_gpio.o dev-gpio-buttons.o
obj-y += mach_rtl8198c.o
obj-$(CONFIG_RTL89XXD_BOARD_V100) += mach_rtl8972d_v100_ata.o
obj-$(CONFIG_SOC_RTL819XD) += mach_rtl819xd.o
obj-$(CONFIG_PCI) += pci.o
obj-$(CONFIG_ARCH_BUS_USB) += dev_usb.o
CPPFLAGS_vmlinux.lds := $(KBUILD_CFLAGS)
