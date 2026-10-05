# GN866 AC legacy build

Target:
- SoC: RTL8198C
- WLAN: RTL8192ER + RTL8812BRH
- Flash: 16 MiB
- Legacy SDK: Realtek RTL819x toolchain, Linux 2.6.30

This target deliberately uses the Realtek vendor image path rather than
the unrelated mainline RTL83xx image builder.

The build produces:
- sdk/boards/rtl8198/image/linux.bin
- sdk/boards/rtl8198/image/root.bin
- sdk/boards/rtl8198/image/fw.bin
- sdk/boards/rtl8198/image/GN866_factory.bin

GN866_factory.bin is built with the SDK's cvimg/mgbin tools. The factory
image is assembled with the kernel (cr6c) block first, followed by the
web/root blocks, and each block is checked for the Realtek 16-byte image
header and 16-bit checksum.

WLAN startup is added to the vendor rcS so wlan0/wlan1 are brought up
after the RTL8192E module is loaded.

The supplied GN866 dump-specific GPIO/calibration data is not fabricated
here. Those values remain separate from the generic SDK build.
