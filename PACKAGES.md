# What's in nekozame os

Everything nekozame os changes on top of Bazzite. The full recipe is [`build_files/build.sh`](build_files/build.sh).

## Desktop

| | PC images | Steam Deck |
|---|---|---|
| Desktop | niri + DankMaterialShell (DMS COPR) | KDE Plasma (Desktop Mode), niri via `ujust nekozame-niri` |
| Login screen | dms-greeter on greetd | Bazzite's |
| KDE | removed entirely | kept |
| File managers | Thunar (+ archive, volumes, thumbnails), yazi | Dolphin, yazi |
| Portals | gnome (screen capture), gtk (file dialogs) | Bazzite's |
| Keyring, GPG prompt | gnome-keyring, pinentry-gnome3 | Bazzite's |

All images keep Bazaar for apps.

## Added

| Package | Where it comes from | Why |
|---|---|---|
| emacs, ghostty, fuzzel | Fedora, ghostty COPR | editor, terminal, launcher |
| ripgrep, fd-find, git | Fedora | Doom Emacs dependencies |
| Sunshine | LizardByte COPR | streaming, with the KMS capture right |
| mpvpaper | built from its release | animated wallpaper without DMS |
| yazi | its release | terminal file manager |
| quickemu, quickget | its release | Windows VMs |
| qemu, swtpm, edk2-tools, genisoimage, spice-gtk-tools | Fedora | what quickemu uses |
| wine, yabridge | Fedora, yabridge release | Windows audio plugins |
| realtime-setup, qpwgraph, Carla, calf, lsp-plugins-lv2 | Fedora | audio |
| plymouth-plugin-script | Fedora | the animated boot screen |

## Removed

| Package | Images | Why |
|---|---|---|
| KDE Plasma, KWin, KDE apps and frameworks, plasma-login-manager | PC | niri + DMS is the whole desktop |
| bazzite-updater | PC | KDE GUI; updates still run through uupd |

## Configured

- Boot screen: the nekozame Plymouth theme, baked into the initramfs
- DMS: the nekozame theme and the animated wallpaper on first login, sized for each screen
- KDE (Steam Deck): the nekozame colors and wallpaper on first login
- Audio: low-latency PipeWire defaults, `threadirqs` kernel option
- Emacs daemon on for every user, `emacsclient` as `$EDITOR`
- Zen: Dark Reader preinstalled
- greenboot: a boot only counts if the login screen comes up
- ujust: a `nekozame` group, and Bazzite's recipes that don't fit are hidden
- Theme files (KDE, Konsole, Ghostty, btop, DMS, Dark Reader, palette) from [nekozame-theme](https://github.com/purplekairi1312/nekozame-theme)
