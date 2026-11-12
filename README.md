# nekozame os

<p align="center"><img src="docs/logo.gif" alt="nekozame os logo: a pixelated catshark swimming above the chrome letters nekozame os and 猫鮫 in a bubble, underwater" width="640"></p>

My opinionated immutable distro, built on [Bazzite](https://bazzite.gg).

## Install

On an existing Bazzite (DX, NVIDIA) or other Universal Blue system. Your files,
Flatpaks and settings stay as they are.

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

## FAQ

**What does nekozame mean?**
猫鮫 (*nekozame*) is Japanese for catshark. I'm a catgirl, I love cats, sharks
are my favourite animal, and I'm a Sonic fan: the Sonic hedgehog protein (yes,
named after Sonic) is studied a lot in catsharks, which I find funny.

**How do I go back to Bazzite?**

```sh
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/bazzite-dx-nvidia:stable
```

**How is it built?**
GitHub Actions builds the image every day from [`Containerfile`](Containerfile)
and [`build_files/build.sh`](build_files/build.sh) and signs it with cosign.
Check it with [`cosign.pub`](cosign.pub):

```sh
cosign verify --key cosign.pub ghcr.io/purplekairi1312/nekozame-os
```

## Credits

Built on [Bazzite](https://bazzite.gg) and the Universal Blue
[image template](https://github.com/ublue-os/image-template).

## License

The code is licensed under the [GNU General Public License v3.0 or later](LICENSE).
The parts that come from the Universal Blue image template were published under
the Apache License 2.0.

The artwork (the logo, the catshark, the boot animation and the wallpapers) is
by purplekairi1312 under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).
See [`LICENSE-ART`](LICENSE-ART).
