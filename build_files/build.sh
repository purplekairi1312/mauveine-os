#!/bin/bash
# Nekozame OS: Bazzite DX (NVIDIA) plus niri, DankMaterialShell and a few
# editors and tools, with the Mauveine theme installed system-wide.

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
sed -i -e 's/^PRETTY_NAME=.*/PRETTY_NAME="Nekozame OS"/' \
       -e 's/^LOGO=.*/LOGO=nekozame-os/' /usr/lib/os-release
# Bazzite's fastfetch: keep its layout, show the Nekozame OS logo instead.
perl -0pi -e 's/"logo":\s*\{.*?\n    \},/"logo": {\n        "type": "kitty-direct",\n        "source": "\/usr\/share\/nekozame-os\/logo.png",\n        "width": 38,\n        "padding": { "top": 1, "right": 2 }\n    },/s' \
    /usr/share/ublue-os/bazzite/fastfetch.jsonc
grep -q nekozame-os/logo.png /usr/share/ublue-os/bazzite/fastfetch.jsonc

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
