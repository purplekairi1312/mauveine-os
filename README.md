# nekozame os

<p align="center"><img src="system_files/usr/share/nekozame-os/logo.png" alt="purplekairi1312 logo" width="420"></p>

nekozame os is purplekairi1312's pastel, kawaii desktop OS: the
[niri](https://github.com/niri-wm/niri) scrolling window manager with
[DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell), KDE
Plasma alongside it, and the **nekozame** theme everywhere.

*nekozame* (猫鮫) is Japanese for catshark: a small, gentle shark with
cat-like eyes. Cat plus shark, so a catgirl shark.

## Features

| | |
|---|---|
| Desktop | niri with DankMaterialShell, or KDE Plasma. Choose either on the login screen. |
| Gaming | Steam, Proton, NVIDIA drivers and gaming tweaks |
| Development | Emacs, Ghostty, VS Code, containers (Podman, Docker, Distrobox) |
| Look | The nekozame name and logo in fastfetch, About this System and the boot menu |
| Theme | nekozame for KDE and Ghostty, a wallpaper, and a `.gpl` swatch palette for Krita, GIMP and Aseprite |
| Updates | Atomic and signed: built every day, installed in the background, and the previous version stays in the boot menu |

## nekozame theme

A soft lavender background with pastel pink, baby blue, mint, lemon and lilac.
Dark, but only a little.

| | | | |
|---|---|---|---|
| background `#5a4f6e` | panel `#4f4562` | text `#ffffff` | pink text `#ffd9ef` |
| orchid `#ffc0e5` | pink `#ffd4ee` | baby blue `#b8e4ff` | cyan `#b8f5f2` |
| mint `#c8f7dc` | lemon `#fff1b0` | lilac `#e3ccff` | peach `#ffd2b8` |

Where to find it:

- KDE: System Settings → Colors → **nekozame**
- Ghostty: `theme = nekozame`
- Wallpaper: System Settings → Wallpaper → **nekozame**
- Art palette: `/usr/share/nekozame-os/nekozame.gpl`

## Install

nekozame os installs on top of an existing Bazzite (DX, NVIDIA) or other
Universal Blue system. Your files, Flatpaks and settings stay as they are;
nothing is erased.

```sh
# 1. drop packages you layered yourself (skip if you never used rpm-ostree install)
sudo rpm-ostree reset

# 2. switch to nekozame os (first time only, unsigned), then reboot
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/purplekairi1312/nekozame-os:latest
systemctl reboot

# 3. switch to the signed image, so later updates are verified, then reboot
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/purplekairi1312/nekozame-os:latest
systemctl reboot
```

To update right away instead of waiting for the background update:
`ujust update`.

To leave nekozame os and go back to upstream Bazzite:

```sh
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/bazzite-dx-nvidia:stable
```

## Building

The image is built by GitHub Actions from [`Containerfile`](Containerfile) and
[`build_files/build.sh`](build_files/build.sh), and signed with cosign.
Verify it with [`cosign.pub`](cosign.pub):

```sh
cosign verify --key cosign.pub ghcr.io/purplekairi1312/nekozame-os
```

## Built on

nekozame os is a fork of [Bazzite](https://bazzite.gg) (`bazzite-dx-nvidia`),
made with the Universal Blue
[image template](https://github.com/ublue-os/image-template). Its gaming,
driver and update foundations come from their work.
