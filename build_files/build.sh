#!/bin/bash
# Mauveine OS: Bazzite DX (NVIDIA) plus niri, DankMaterialShell and a few
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

### Only accept updates signed with this repo's key (cosign.pub)
jq '.transports.docker["ghcr.io/purplekairi1312/mauveine-os"] = [{
      "type": "sigstoreSigned",
      "keyPath": "/etc/pki/containers/mauveine-os.pub",
      "signedIdentity": {"type": "matchRepository"}
    }]' /etc/containers/policy.json > /tmp/policy.json
mv /tmp/policy.json /etc/containers/policy.json

# Don't leave the COPRs enabled on the finished system.
dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable avengemedia/danklinux || true
dnf5 -y copr disable scottames/ghostty
