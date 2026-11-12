# nekozame os

<p align="center"><img src="https://git.sr.ht/~purplekairi1312/nekozame-os/blob/main/docs/logo.gif" alt="nekozame os logo: a pixelated catshark swimming above the chrome letters nekozame os and 猫鮫 in a bubble, underwater" width="640"></p>

Opinionated immutable distro, built on [Bazzite](https://bazzite.gg).

- [niri](https://github.com/niri-wm/niri) with [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) as the desktop (KDE Plasma is still there, for now)
- Gaming and emulation tools from Bazzite, with NVIDIA drivers
- Doom Emacs as `$EDITOR`, always running as a daemon (`nekozame-doom` installs it), Ghostty and fuzzel, plus Bazzite DX's dev tools
- Audio: low-latency PipeWire, realtime priority, Wine + yabridge for Windows plugins, qpwgraph and Carla. `nekozame-audio` sets up your pick of Bitwig, Reaper or Renoise (proprietary, paid), Ardour or LMMS (open source, free), plus open source plugins
- Windows VMs with quickemu (`quickget windows 11`) on top of libvirt and virt-manager
- An animated catshark boot screen and wallpaper, sharp on any screen shape

## Install

From Bazzite (DX, NVIDIA) or any Universal Blue image. Your files, Flatpaks and settings stay.

```sh
# Drop anything you layered yourself
sudo rpm-ostree reset

# First time: unsigned, then reboot
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/purplekairi1312/nekozame-os:latest
systemctl reboot

# Then the signed image, then reboot
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/purplekairi1312/nekozame-os:latest
systemctl reboot
```

## FAQ

**What does nekozame mean?**
猫鮫, catshark. I'm a catgirl, I love cats, sharks are my fav animal, and I'm a Sonic fan: the Sonic hedgehog protein (yes, named after Sonic) gets studied a lot in catsharks, which I find funny and that way im fusing 3 things i really like :D

**Going back to Bazzite?**

```sh
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/bazzite-dx-nvidia:stable
```

**How is it built?**
GitHub Actions builds it daily from the [`Containerfile`](Containerfile) and [`build_files/build.sh`](build_files/build.sh), signed with Cosign:

```sh
cosign verify --key cosign.pub ghcr.io/purplekairi1312/nekozame-os
```

## Credits

[Bazzite](https://bazzite.gg) and the Universal Blue [image template](https://github.com/ublue-os/image-template).

## License

Code: [GPL-3.0-or-later](LICENSE). Bits from the Universal Blue template were Apache 2.0.
Art (logo, catshark, boot animation, wallpapers): mine, [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). See [`LICENSE-ART`](LICENSE-ART).
