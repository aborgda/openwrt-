#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WORK="$ROOT/.gn866-build"
SDK_TARBALL="$WORK/rtl819x-SDK-3.4.7.3-original.tar.gz"
SDK_URL="https://www.dropbox.com/scl/fi/ul5lp3t4rk9f8gwm7tabz/rtl819x-SDK-3.4.7.3-original.tar.gz?rlkey=nsx7nw5u4sqc4xu6rhb552v0f&st=4tfqssl9&raw=1"
JOBS="${JOBS:-1}"

rm -rf "$WORK"
mkdir -p "$WORK" "$ROOT/artifacts"

echo "GN866 AC / RTL8198C"
echo "SDK: RTL819X SDK 3.4.7.3"
echo "WLAN: RTL8192E/8192EE + RTL8812A"
echo "GN866 target: RTL8198C / Linux 3.10 / legacy Realtek image path"

wget --retry-connrefused --tries=5 --timeout=60 -O "$SDK_TARBALL" "$SDK_URL"
test "$(stat -c '%s' "$SDK_TARBALL")" -eq 500206571

tar -xzf "$SDK_TARBALL" -C "$WORK"
SDK="$WORK/rtl819x-SDK-3.4.7.3-original/rtl819x"
cd "$SDK"

BB="$SDK/users/busybox-1.13"
if [[ -f "$BB/Makefile" ]]; then
  sed -i 's/rm -rf include;/# preserve source include headers;/' "$BB/Makefile" || true
fi

# Use the vendor board configuration; no menuconfig is required.
cp boards/rtl8198C_8954E/config.linux-3.10.RTL8198C_8812_92E_GW linux-3.10/.config
cp boards/rtl8198C_8954E/config.users.RTL8198C_8812_92E_GW users/.config
cp boards/rtl8198C_8954E/config.busybox-1.13.RTL8198C_8812_92E_GW users/busybox-1.13/.config

cat > .config <<'EOF'
CONFIG_BOARD_rtl8198C_8954E=y
CONFIG_LINUX_3.10=y
CONFIG_BZBOX_busybox-1.13=y
CONFIG_RSDK_msdk-4.4.7-mips-EB-3.10-0.9.33-m32t-131227b=y
CONFIG_MODEL_RTL8198C_8812_92E_GW=y
CONFIG_ARCH_CPU_MIPS=y
EOF

# Keep both radio slots enabled as supplied by the vendor GN866-compatible board config.
grep -q '^CONFIG_SLOT_0_8192EE=y' linux-3.10/.config
grep -q '^CONFIG_SLOT_1_8812=y' linux-3.10/.config
grep -q '^CONFIG_RTL_8812_SUPPORT=y' linux-3.10/.config

# Legacy Kconfig/GCC compatibility.
for f in config/zconf.hash.c config/zconf.hash.c_shipped linux-3.10/scripts/kconfig/zconf.hash.c linux-3.10/scripts/kconfig/zconf.hash.c_shipped; do
  if [[ -f "$f" ]]; then
    sed -i -E 's/^[[:space:]]*const struct kconf_id \*/static const struct kconf_id */' "$f"
    sed -i 's/static static const/static const/g' "$f"
    sed -i '/__attribute__ ((__gnu_inline__))/d' "$f"
  fi
done

for f in users/squashfs4.0/squashfs-tools/mksquashfs.c users/squashfs4.0/squashfs-tools/unsquashfs.c; do
  if [[ -f "$f" ]]; then
    sed -i 's/^inline void inc_progress_bar(/static inline void inc_progress_bar(/' "$f"
    sed -i 's/^inline void update_progress_bar(/static inline void update_progress_bar(/' "$f"
    sed -i 's/^inline void waitforthread(/static inline void waitforthread(/' "$f"
    sed -i 's/^inline void add_dir_entry(/static inline void add_dir_entry(/' "$f"
    grep -q 'sys/sysmacros.h' "$f" || sed -i '1i#include <sys/sysmacros.h>' "$f"
  fi
done

TOOLBIN="$SDK/toolchain/msdk-4.4.7-mips-EB-3.10-0.9.33-m32t-131227b/bin"
for t in "$TOOLBIN"/msdk-linux-*; do
  [[ -e "$t" ]] || continue
  n="$TOOLBIN/rsdk-linux-${t##*/msdk-linux-}"
  [[ -e "$n" ]] || ln -s "${t##*/}" "$n"
done

export HOSTCFLAGS="${HOSTCFLAGS:-} -fgnu89-inline"
export CPPFLAGS="${CPPFLAGS:-} -Utrue -Ufalse"
export CFLAGS="${CFLAGS:-} -fno-pie"
export LDFLAGS="${LDFLAGS:-} -no-pie"
export FORCE_UNSAFE_CONFIGURE=1

# Vendor scripts use bashisms through /bin/sh.
sudo ln -sf /bin/bash /bin/sh

cp .config .oldconfig

make -j"$JOBS" V=1 HOSTCFLAGS="$HOSTCFLAGS" CPPFLAGS="$CPPFLAGS"

# Also validate the OpenWrt tree target definitions without invoking menuconfig.
cd "$ROOT"
make defconfig
make -s target/linux/realtek/prepare SUBTARGET=rtl8198c V=s

echo "== collecting GN866 images =="
find "$SDK" -type f \( -iname '*.bin' -o -iname '*.img' -o -iname '*.trx' -o -iname '*.web' \) -size +64k -print0 |
while IFS= read -r -d '' f; do
  cp -v "$f" "$ROOT/artifacts/"
done

cp -f linux-3.10/.config "$ROOT/artifacts/linux-3.10.config"
cp -f .config "$ROOT/artifacts/sdk.config"
find "$ROOT/artifacts" -maxdepth 1 -type f -printf '%f %s bytes\n' | sort
