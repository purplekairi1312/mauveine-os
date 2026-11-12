# nekozame os

<p align="center"><img src="https://git.sr.ht/~purplekairi1312/nekozame-os/blob/main/docs/logo.gif" alt="nekozame os logo: a pixelated catshark swimming above the chrome letters nekozame os and 猫鮫 in a bubble, underwater" width="640"></p>

Opinionated immutable distro.

- [niri](https://github.com/niri-wm/niri) with [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell), login screen included
- Gaming and emulation tools (and NVIDIA drivers on the NVIDIA image)
- Doom Emacs as `$EDITOR`, always running as a daemon, emacs keys (evil mode or another editor if you want)
- Low-latency audio with realtime priority for everyone, and music production on request: Bitwig, Reaper or Renoise (proprietary, paid), Ardour or LMMS (free software), a checklist of about 700 plugins from Audinux that every DAW finds, and yabridge for Microsoft Windows plugins
- Sunshine always on, so you can stream it from anywhere over Tailscale with Moonlight
- Zen, ready for privacy: Dark Reader, uBlock Origin, Privacy Badger, LibRedirect, ClearURLs, Consent-O-Matic and nekojs (LibreJS made simple), DuckDuckGo, HTTPS-only, no telemetry, no WebRTC leaks (Helium optional, with the same)
- Microsoft Windows VMs with quickemu (`quickget windows 11`) on top of libvirt and virt-manager
- A little catshark swimming as your boot screen and wallpaper, sharp on any screen shape <3

On your first login, a short setup turns all of it on and asks about the optional bits. Run it again with `ujust nekozame-setup`; everything else is under `ujust`.

[All the software](PACKAGES.md)

## Install

From any Universal Blue image. Your files, Flatpaks and settings stay. Pick the image for your machine:

| Machine | Image |
|---|---|
| PC or laptop with AMD or Intel graphics | `nekozame-os` |
| PC with an NVIDIA GPU | `nekozame-os-nvidia` |
| Steam Deck | `nekozame-os-deck` (boots Game Mode; Desktop Mode is KDE with the nekozame look, `ujust nekozame-niri` adds niri; no DX dev tools) |

```sh
IMAGE=nekozame-os   # or nekozame-os-nvidia, nekozame-os-deck

# Drop anything you layered yourself
sudo rpm-ostree reset

# First time: unsigned, then reboot
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/purplekairi1312/$IMAGE:stable
systemctl reboot

# Then the signed image, then reboot
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/purplekairi1312/$IMAGE:stable
systemctl reboot
```

## FAQ

**What does nekozame mean?**
猫鮫, catshark. I'm a catgirl, I love cats, sharks are my fav animal, and I'm a Sonic fan: the Sonic hedgehog protein (yes, named after Sonic) gets studied a lot in catsharks, which I find funny and that way im fusing 3 things i really like :D

**Going back?**

```sh
# bazzite-dx, bazzite-dx-nvidia or bazzite-deck, matching your nekozame os image
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/bazzite-dx:stable
```

**How is it built and updated?**
GitHub Actions builds it daily from the [`Containerfile`](Containerfile) and [`build_files/build.sh`](build_files/build.sh), and every build runs smoke tests before it's published. `:stable` gets the latest good build once a week (`:latest` is daily, for testing). Images are signed with Cosign:

```sh
cosign verify --key cosign.pub ghcr.io/purplekairi1312/nekozame-os
```

See [`MAINTENANCE.md`](MAINTENANCE.md) for when something breaks.

## Credits

[Bazzite](https://bazzite.gg) and the Universal Blue [image template](https://github.com/ublue-os/image-template).

## License

Code: [GPL-3.0-or-later](LICENSE).
Art (logo, catshark, boot animation, wallpapers): [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). See [`LICENSE-ART`](LICENSE-ART).
