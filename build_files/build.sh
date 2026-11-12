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
# niri's screen capture (screen sharing, sunshine) goes through the gnome portal
dnf5 -y install xdg-desktop-portal-gnome

# dms starts with every niri session, and a first niri login gets dms's config
systemctl --global add-wants niri.service dms.service
systemctl --global enable nekozame-niri-config.service

### Packages that used to be layered by hand on this machine
dnf5 -y copr enable scottames/ghostty
dnf5 -y install emacs fuzzel ghostty

### the nekozame theme, from its own repo (github.com/purplekairi1312/nekozame-theme)
curl -fsSL https://github.com/purplekairi1312/nekozame-theme/archive/refs/heads/main.tar.gz \
    | tar -xz -C /tmp
T=/tmp/nekozame-theme-main/themes
install -Dm0644 "$T/kde/nekozame.colors" /usr/share/color-schemes/nekozame.colors
install -Dm0644 "$T/konsole/nekozame.colorscheme" /usr/share/konsole/nekozame.colorscheme
install -Dm0644 "$T/ghostty/nekozame" /usr/share/ghostty/themes/nekozame
install -Dm0644 "$T/btop/nekozame.theme" /usr/share/btop/themes/nekozame.theme
install -Dm0644 "$T/palettes/nekozame.gpl" /usr/share/nekozame-os/nekozame.gpl
install -Dm0644 "$T/dms/nekozame.json" /usr/share/nekozame-os/dms/nekozame.json
rm -rf /tmp/nekozame-theme-main

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

### Animated wallpaper: mpvpaper, compiled in its own stage (see Containerfile);
### nekozame-wallpaper in system_files runs it. It only needs libmpv here.
dnf5 -y install mpv-libs
cp -avf /ctx/mpvpaper/. /
command -v mpvpaper

### music: low latency (pipewire config + threadirqs in system_files), realtime
### priority, a patchbay and plugin host, plugins, wine + yabridge for windows plugins
dnf5 -y install realtime-setup qpwgraph Carla calf lsp-plugins-lv2 wine
YABRIDGE=5.1.1
curl -fsSL "https://github.com/robbert-vdh/yabridge/releases/download/${YABRIDGE}/yabridge-${YABRIDGE}.tar.gz" \
    | tar -xz -C /tmp
mkdir -p /usr/lib/yabridge
cp -a /tmp/yabridge/. /usr/lib/yabridge/
ln -sf /usr/lib/yabridge/yabridgectl /usr/bin/yabridgectl
rm -rf /tmp/yabridge

### windows vms: quickemu on top of dx's libvirt/qemu/swtpm/ovmf
### ("quickget windows 11" downloads windows and sets up the vm). fedora's package
### wants mesa-demos, which bazzite's own mesa blocks; quickemu is just scripts,
### so take them from the release and install what they use
dnf5 -y install qemu edk2-tools genisoimage jq pciutils socat spice-gtk-tools swtpm \
    unzip usbutils xdg-user-dirs xrandr
QUICKEMU=4.9.9
curl -fsSL "https://github.com/quickemu-project/quickemu/archive/refs/tags/${QUICKEMU}.tar.gz" \
    | tar -xz -C /tmp
install -m 0755 "/tmp/quickemu-${QUICKEMU}"/{quickemu,quickget,quickreport,chunkcheck} /usr/bin/
rm -rf "/tmp/quickemu-${QUICKEMU}"

### doom emacs: its dependencies (nekozame-doom installs doom itself per user),
### and the emacs daemon always running for every user (EDITOR is its client)
dnf5 -y install ripgrep fd-find git
if [ -f /usr/lib/systemd/user/emacs.service ]; then
    systemctl --global enable emacs.service
else
    echo "warning: no emacs.service in this emacs build" >&2
fi

### sunshine, always on over tailscale: native, so kms capture works under niri (the
### flatpak can't get the capture right); ujust nekozame-sunshine turns it on
dnf5 -y copr enable lizardbyte/stable
dnf5 -y install Sunshine
dnf5 -y copr disable lizardbyte/stable
setcap cap_sys_admin+p "$(readlink -f /usr/bin/sunshine)"

### Boot screen: the nekozame underwater loop (Plymouth theme in system_files),
### baked into the initramfs so it shows from the very start of boot.
dnf5 -y install plymouth-plugin-script  # the theme is a plymouth script
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
