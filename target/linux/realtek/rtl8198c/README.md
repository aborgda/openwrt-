# RTL8198C legacy target

Boards:
- GN866 AC: RTL8198C + RTL8192ER + RTL8812BRH, 16 MiB
- SK337: RTL8198C + RTL8192E + RTL8812AR, 32 MiB

The target uses the legacy Realtek image format, LZMA loader and cvimg/fix_chksum tools.
WLAN startup is enabled by target/linux/realtek/files-3.10/etc/init.d/rtl8198c-wlan.

GPIO values are not guessed. They must be populated from the supplied board dumps before
using GPIO-controlled radio reset/LED functions.
