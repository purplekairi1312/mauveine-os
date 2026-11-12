# nekozame os

<p align="center"><img src="docs/logo.gif" alt="nekozame os logo: a pixelated catshark swimming above the chrome letters nekozame os and 猫鮫 in a bubble, underwater" width="640"></p>

opinionated immutable distro, built on [bazzite](https://bazzite.gg).

## install

from bazzite (dx, nvidia) or any universal blue image. your files, flatpaks and settings stay.

```sh
# drop anything you layered yourself
sudo rpm-ostree reset

# first time: unsigned, then reboot
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/purplekairi1312/nekozame-os:latest
systemctl reboot

# then the signed image, then reboot
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/purplekairi1312/nekozame-os:latest
systemctl reboot
```

## faq

**what does nekozame mean?**
猫鮫, catshark. i'm a catgirl, i love cats, sharks are my fav animal, and i'm a sonic fan: the sonic hedgehog protein (yes, named after sonic) gets studied a lot in catsharks, which i find funny.

**going back to bazzite?**

```sh
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/bazzite-dx-nvidia:stable
```

**how is it built?**
github actions builds it daily from the [`Containerfile`](Containerfile) and [`build_files/build.sh`](build_files/build.sh), signed with cosign:

```sh
cosign verify --key cosign.pub ghcr.io/purplekairi1312/nekozame-os
```

## credits

[bazzite](https://bazzite.gg) and the universal blue [image template](https://github.com/ublue-os/image-template).

## license

code: [gpl-3.0-or-later](LICENSE). bits from the universal blue template were apache 2.0.
art (logo, catshark, boot animation, wallpapers): mine, [cc by-nc-sa 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). see [`LICENSE-ART`](LICENSE-ART).
