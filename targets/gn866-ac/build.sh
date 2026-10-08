#!/bin/sh
set -eu

SDK_REPO="https://github.com/frederic/rtl819x-toolchain.git"
SDK_REF="5c9be5d943318fdb4d048ae22078129594eb5a10"
RSDK="rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714"

echo "GN866 AC legacy build"
echo "SoC: RTL8198C"
echo "WLAN: RTL8192ER + RTL8812AR"
echo "Flash: 16 MiB"

if [ ! -d sdk ]; then
    git clone --depth 1 "$SDK_REPO" sdk
fi

cd sdk
git fetch --depth 1 origin "$SDK_REF"
git checkout "$SDK_REF"

test -d "toolchain/$RSDK"
test -f "boards/rtl8198/Makefile"
test -f "boards/rtl8198/config.linux-2.6.30.RTL8198_SPI_SQUASHFS"
test -f "users/boa/tools/cvimg"
test -f "users/boa/tools/mgbin"

cp .config .config.gn866.base
python3 - <<'PY'
from pathlib import Path
import re

p = Path(".config.gn866.base")
s = p.read_text()

repl = {
    "# CONFIG_BOARD_rtl8196e is not set": "CONFIG_BOARD_rtl8198=y",
    "CONFIG_BOARD_rtl8196e=y": "# CONFIG_BOARD_rtl8196e is not set\nCONFIG_BOARD_rtl8198=y",
    "# CONFIG_BOARD_rtl8198 is not set": "CONFIG_BOARD_rtl8198=y",
    "CONFIG_RSDK_rsdk-1.3.6-4181-EB-2.6.30-0.9.30=y": "# CONFIG_RSDK_rsdk-1.3.6-4181-EB-2.6.30-0.9.30 is not set",
    "# CONFIG_RSDK_rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714 is not set": "CONFIG_RSDK_rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714=y",
    "CONFIG_BOARDDIR=boards/rtl8196e": "CONFIG_BOARDDIR=boards/rtl8198",
    "CONFIG_RSDKDIR=toolchain/rsdk-1.3.6-4181-EB-2.6.30-0.9.30": "CONFIG_RSDKDIR=toolchain/rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714",
    "CONFIG_MODEL=RTL8196E_88E_GW": "CONFIG_MODEL=RTL8198_SPI_SQUASHFS",
}
for a, b in repl.items():
    s = s.replace(a, b)

if "CONFIG_BOARD_rtl8198=y" not in s:
    s += "\nCONFIG_BOARD_rtl8198=y\n"
if "CONFIG_MODEL=RTL8198_SPI_SQUASHFS" not in s:
    s += "\nCONFIG_MODEL=RTL8198_SPI_SQUASHFS\n"
if "CONFIG_BOARDDIR=boards/rtl8198" not in s:
    s += "\nCONFIG_BOARDDIR=boards/rtl8198\n"
if "CONFIG_RSDKDIR=toolchain/rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714" not in s:
    s += "\nCONFIG_RSDKDIR=toolchain/rsdk-1.5.5-5281-EB-2.6.30-0.9.30.3-110714\n"

p.write_text(s)
PY
cp .config.gn866.base .config

cp boards/rtl8198/config.linux-2.6.30.RTL8198_SPI_SQUASHFS linux-2.6.30/.config

python3 - <<'PY'
from pathlib import Path
import re

p = Path("linux-2.6.30/.config")
s = p.read_text()

def setopt(name, value):
    global s
    s = re.sub(r"^# CONFIG_" + re.escape(name) + r" is not set\n", "", s, flags=re.M)
    s = re.sub(r"^CONFIG_" + re.escape(name) + r"=.*\n", "", s, flags=re.M)
    s += f"CONFIG_{name}={value}\n"

setopt("RTL8192E", "m")
setopt("WLAN_HAL_8192EE", "y")
if "CONFIG_RTL8192CD=" not in s:
    s += "CONFIG_RTL8192CD=m\n"

p.write_text(s)
PY

python3 - <<'PY'
from pathlib import Path
p = Path("boards/rtl8198/Makefile")
s = p.read_text()
needle = 'ifeq ($(CONFIG_RTL8192CD),m)\n\tsed -i "14i insmod /lib/modules/2.6.30.9/kernel/drivers/net/wireless/rtl8192cd/rtl8192cd.ko" $(DIR_ROMFS)/etc/init.d/rcS\nendif\n'
if needle in s and "GN866 WLAN auto-start" not in s:
    block = needle + '''
# GN866 WLAN auto-start
ifeq ($(CONFIG_RTL8192E),m)
\tsed -i '15i insmod /lib/modules/2.6.30.9/kernel/drivers/net/wireless/rtl8192e/rtl8192e.ko 2>/dev/null || true' $(DIR_ROMFS)/etc/init.d/rcS
endif
\tcat >> $(DIR_ROMFS)/etc/init.d/rcS <<'EOF_GN866_WLAN'
# GN866 WLAN auto-start
for _if in wlan0 wlan1; do
\tif [ -d /sys/class/net/$_if ]; then
\t\tifconfig "$_if" up 2>/dev/null || true
\tfi
done
EOF_GN866_WLAN
'''
    s = s.replace(needle, block)

p.write_text(s)
PY

export FORCE_UNSAFE_CONFIGURE=1
make -j2 V=1

test -f boards/rtl8198/image/linux.bin
test -f boards/rtl8198/image/root.bin

mkdir -p boards/rtl8198/image
rm -f boards/rtl8198/image/GN866_factory.bin
./users/boa/tools/mgbin -c   -o boards/rtl8198/image/GN866_factory.bin   boards/rtl8198/image/linux.bin   boards/rtl8198/image/webpages.bin   boards/rtl8198/image/root.bin

test -s boards/rtl8198/image/GN866_factory.bin
echo "GN866_factory.bin created"
