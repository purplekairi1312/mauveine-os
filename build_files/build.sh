#!/bin/bash
# nekozame os: niri, DankMaterialShell, a few editors and tools, and the
# nekozame theme, on its Bazzite DX (NVIDIA) base.

set -ouex pipefail

# Theme files, wallpaper and configs from system_files/
cp -avf "/ctx/system_files"/. /

### niri + DankMaterialShell
# niri comes from Fedora. DMS comes from its developers' COPR, which pulls in
# its helper repo (avengemedia/danklinux) for dependencies such as quickshell.
dnf5 -y copr enable avengemedia/dms
dnf5 -y install niri dms

### Packages that used to be layered by hand on this machine
dnf5 -y copr enable scottames/ghostty
dnf5 -y install emacs fuzzel ghostty

### Branding: the name and logo people see. ID, VARIANT_ID and image-info.json
### stay Bazzite's, because ujust and the update tools read them.
sed -i -e 's/^PRETTY_NAME=.*/PRETTY_NAME="nekozame os"/' \
       -e 's/^LOGO=.*/LOGO=nekozame-os/' /usr/lib/os-release
# Bazzite's fastfetch: keep its layout, show the nekozame os logo instead.
perl -0pi -e 's/"logo":\s*\{.*?\n    \},/"logo": {\n        "type": "kitty-direct",\n        "source": "\/usr\/share\/nekozame-os\/logo.png",\n        "width": 38,\n        "padding": { "top": 1, "right": 2 }\n    },/s' \
    /usr/share/ublue-os/bazzite/fastfetch.jsonc
grep -q nekozame-os/logo.png /usr/share/ublue-os/bazzite/fastfetch.jsonc
# Terminal welcome: same layout and ujust table, nekozame os title.
sed -i '1s/.*/# Welcome to nekozame os 🦈/' /usr/share/ublue-os/motd/template.md

### Animated wallpaper: mpvpaper isn't in Fedora, so build the pinned release from
### source (nekozame-wallpaper in system_files runs it), then drop the build tools.
MPVPAPER=1.9
dnf5 -y install mpv-libs
# only remove afterwards what this step added (the DX base already ships some of these)
BUILD_DEPS=""
for p in gcc meson ninja-build pkgconf-pkg-config mpv-devel wayland-devel \
         wayland-protocols-devel mesa-libEGL-devel; do
    rpm -q "$p" >/dev/null 2>&1 || BUILD_DEPS="$BUILD_DEPS $p"
done
if [ -n "$BUILD_DEPS" ]; then
    # shellcheck disable=SC2086
    dnf5 -y install --setopt=install_weak_deps=False $BUILD_DEPS
fi
curl -fsSL "https://github.com/GhostNaN/mpvpaper/archive/refs/tags/${MPVPAPER}.tar.gz" \
    | tar -xz -C /tmp
meson setup /tmp/mpvpaper-build "/tmp/mpvpaper-${MPVPAPER}" --prefix=/usr --buildtype=release
ninja -C /tmp/mpvpaper-build install
rm -rf /tmp/mpvpaper-build "/tmp/mpvpaper-${MPVPAPER}"
if [ -n "$BUILD_DEPS" ]; then
    # shellcheck disable=SC2086
    dnf5 -y remove $BUILD_DEPS
fi
command -v mpvpaper

### Boot screen: the nekozame underwater loop (Plymouth theme in system_files),
### baked into the initramfs so it shows from the very start of boot.
plymouth-set-default-theme nekozame
KVER="$(ls /usr/lib/modules | head -n1)"
dracut --no-hostonly --kver "$KVER" --reproducible --zstd -v --add ostree \
    -f "/usr/lib/modules/$KVER/initramfs.img"
chmod 0600 "/usr/lib/modules/$KVER/initramfs.img"

### Only accept updates signed with this repo's key (cosign.pub)
jq '.transports.docker["ghcr.io/purplekairi1312/nekozame-os"] = [{
      "type": "sigstoreSigned",
      "keyPath": "/etc/pki/containers/nekozame-os.pub",
      "signedIdentity": {"type": "matchRepository"}
    }]' /etc/containers/policy.json > /tmp/policy.json
mv /tmp/policy.json /etc/containers/policy.json

# Don't leave the COPRs enabled on the finished system.
dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable avengemedia/danklinux || true
dnf5 -y copr disable scottames/ghostty
