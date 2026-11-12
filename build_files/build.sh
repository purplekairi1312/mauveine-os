#!/bin/bash
# nekozame os: niri, DankMaterialShell, a few editors and tools, and the
# nekozame theme, on its Bazzite DX (NVIDIA) base.

set -ouex pipefail

# Theme files, wallpaper and configs from system_files/
cp -avf "/ctx/system_files"/. /

### niri + DankMaterialShell (not on the steam deck image: kde there, and
### ujust nekozame-niri layers niri for whoever wants it).
# niri comes from Fedora. DMS comes from its developers' COPR, which pulls in
# its helper repo (avengemedia/danklinux) for dependencies such as quickshell.
if [ "${VARIANT:-nvidia}" != deck ]; then
    # the pc images have no kde at all: niri with dms is the whole desktop
    dnf5 -y remove "plasma-*" "kwin*" "kde-*" "kdeplasma-*" "kdeconnect*" "kf5-*" "kf6-*" \
        "kio-*" "kscreen*" "krunner*" "kwallet*" "kwrite*" "akonadi*" "baloo*" "dolphin*" \
        "konsole*" "kate*" ark gwenview okular spectacle filelight khelpcenter kinfocenter \
        kmenuedit kdebugsettings kdesu kdecoration "kdegraphics-*" powerdevil polkit-kde \
        xdg-desktop-portal-kde sddm-wayland-plasma plasma-login-manager "breeze-*" \
        kwalletmanager5 bazzite-updater
    # what kde happened to be carrying that stays, and the non-kde replacements
    dnf5 -y install virt-manager gnome-keyring pinentry-gnome3 \
        Thunar thunar-archive-plugin thunar-volman tumbler gvfs file-roller

    dnf5 -y copr enable avengemedia/dms
    dnf5 -y install niri dms dms-greeter greetd
    # niri's screen capture (screen sharing, sunshine) goes through the gnome portal
    dnf5 -y install xdg-desktop-portal-gnome
    dnf5 -y copr disable avengemedia/dms
    dnf5 -y copr disable avengemedia/danklinux || true

    # dms's login screen, on greetd
    mkdir -p /etc/greetd
    printf '[terminal]\nvt = 1\n\n[default_session]\nuser = "greeter"\ncommand = "dms-greeter --command niri"\n' \
        > /etc/greetd/config.toml
    systemctl enable greetd.service

    # thunar for folders; file dialogs from the gtk portal (gnome's needs nautilus)
    printf '[Default Applications]\ninode/directory=thunar.desktop\n' >> /usr/share/applications/mimeapps.list
    mkdir -p /etc/xdg-desktop-portal
    { cat /usr/share/xdg-desktop-portal/niri-portals.conf
      echo "org.freedesktop.impl.portal.FileChooser=gtk"; } > /etc/xdg-desktop-portal/niri-portals.conf

    # the kde look-setup only belongs on the deck
    rm -f /etc/xdg/autostart/nekozame-kde-defaults.desktop
else
    # the deck keeps kde; niri is one ujust away
    cat /usr/share/nekozame-os/just/deck.just >> /usr/share/ublue-os/just/60-custom.just
fi

# dms starts with every niri session, and a first niri login gets dms's config.
# plain links, so they're ready on the deck too once niri gets layered
mkdir -p /etc/systemd/user/niri.service.wants
ln -sf /usr/lib/systemd/user/dms.service /etc/systemd/user/niri.service.wants/dms.service
ln -sf /usr/lib/systemd/user/nekozame-niri-config.service \
    /etc/systemd/user/niri.service.wants/nekozame-niri-config.service

### yazi, the terminal file manager (not in fedora): the official release build
# renovate: datasource=github-releases depName=sxyazi/yazi
YAZI=v26.9.1
curl -fsSL -o /tmp/yazi.zip \
    "https://github.com/sxyazi/yazi/releases/download/${YAZI}/yazi-x86_64-unknown-linux-gnu.zip"
python3 -m zipfile -e /tmp/yazi.zip /tmp/yazi
install -m 0755 /tmp/yazi/yazi-x86_64-unknown-linux-gnu/{yazi,ya} /usr/bin/
rm -rf /tmp/yazi /tmp/yazi.zip

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
install -Dm0644 "$T/darkreader/nekozame.json" /usr/share/nekozame-os/darkreader/nekozame.json
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
# renovate: datasource=github-releases depName=robbert-vdh/yabridge
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
# renovate: datasource=github-releases depName=quickemu-project/quickemu
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

### ujust: hide bazzite's recipes that don't fit (deck, handhelds, other hardware,
### bazzite branding) and the ones nekozame os wraps under its own names
python3 /ctx/hide-recipes.py /usr/share/ublue-os/just "${VARIANT:-nvidia}"

### Boot screen: the nekozame underwater loop (Plymouth theme in system_files),
### baked into the initramfs so it shows from the very start of boot.
dnf5 -y install plymouth-plugin-script  # the theme is a plymouth script
plymouth-set-default-theme nekozame
KVER="$(ls /usr/lib/modules | head -n1)"
dracut --no-hostonly --kver "$KVER" --reproducible --zstd -v --add ostree \
    -f "/usr/lib/modules/$KVER/initramfs.img"
chmod 0600 "/usr/lib/modules/$KVER/initramfs.img"

### Only accept updates signed with this repo's key (cosign.pub)
jq '["nekozame-os", "nekozame-os-amd", "nekozame-os-deck"] as $images
    | reduce $images[] as $i (.; .transports.docker["ghcr.io/purplekairi1312/\($i)"] = [{
      "type": "sigstoreSigned",
      "keyPath": "/etc/pki/containers/nekozame-os.pub",
      "signedIdentity": {"type": "matchRepository"}
    }])' /etc/containers/policy.json > /tmp/policy.json
mv /tmp/policy.json /etc/containers/policy.json

# Don't leave the COPRs enabled on the finished system.
dnf5 -y copr disable scottames/ghostty
