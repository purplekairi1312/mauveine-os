# What's in nekozame os

## Desktop

- [niri](https://github.com/niri-wm/niri) (window manager)
- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) (shell: bar, launcher, notifications, settings, login screen)
- [cava](https://github.com/karlstav/cava) (audio visualizer on the bar)
- [Ghostty](https://ghostty.org) (terminal)
- [fuzzel](https://codeberg.org/dnkl/fuzzel) (launcher)
- [Thunar](https://docs.xfce.org/xfce/thunar/start) (file manager)
- [yazi](https://yazi-rs.github.io) (terminal file manager)
- [Doom Emacs](https://github.com/doomemacs/doomemacs) (editor, `$EDITOR`)
- [Zen](https://zen-browser.app) (browser)
- [Helium](https://helium.computer) (browser, optional)
- [gum](https://github.com/charmbracelet/gum) (the setup's menus)

On the Steam Deck image, Desktop Mode is [KDE Plasma](https://kde.org/plasma-desktop/) and niri is optional.

## Look

- [nekozame theme](https://git.sr.ht/~purplekairi1312/nekozame-theme)
- [animated catshark boot screen](system_files/usr/share/plymouth/themes/nekozame)
- [animated catshark wallpaper](system_files/usr/share/backgrounds/nekozame)

## Browser

- [Dark Reader](https://darkreader.org) (dark mode on every site)
- [uBlock Origin](https://github.com/gorhill/uBlock) (ad and tracker blocker)
- [Privacy Badger](https://privacybadger.org) (tracker blocker)
- [LibRedirect](https://github.com/libredirect/browser_extension) (privacy frontends for YouTube, Reddit and more)
- [ClearURLs](https://github.com/ClearURLs/Addon) (strips tracking from links)
- [Consent-O-Matic](https://consentomatic.au.dk) (rejects cookie banners)
- [DuckDuckGo](https://duckduckgo.com) (search)
- [HTTPS-only, strict tracking protection, no telemetry, no WebRTC leaks](system_files/usr/share/nekozame-os/zen/policies/policies.json)

## Audio

- [PipeWire](https://pipewire.org) (low latency, realtime priority)
- [qpwgraph](https://gitlab.freedesktop.org/rncbc/qpwgraph) (patchbay)

## Music production (optional)

- [Bitwig](https://www.bitwig.com), [Reaper](https://www.reaper.fm), [Renoise](https://www.renoise.com), [Ardour](https://ardour.org) or [LMMS](https://lmms.io) (DAWs)
- [Carla](https://kx.studio/Applications:Carla) (plugin host)
- [Calf](https://calf-studio-gear.org), [LSP](https://lsp-plug.in), [Surge XT](https://surge-synthesizer.github.io), [Dexed](https://asb2m10.github.io/dexed/), [Cardinal](https://cardinal.kx.studio), [Helm](https://tytel.org/helm/), [Geonkick](https://gitlab.com/Geonkick-Synthesizer/geonkick), [x42](https://x42-plugins.com), [Zam](https://github.com/zamaudio/zam-plugins), [Dragonfly Reverb](https://michaelwillis.github.io/dragonfly-reverb/) (plugins)
- [yabridge](https://github.com/robbert-vdh/yabridge) (Microsoft Windows plugins)

## Streaming

- [Tailscale](https://tailscale.com) (private network between your machines)
- [Sunshine](https://app.lizardbyte.dev/Sunshine/) (game streaming, always on over Tailscale)

## Microsoft Windows

- [Wine](https://www.winehq.org) (Microsoft Windows apps)
- [quickemu](https://github.com/quickemu-project/quickemu) (Microsoft Windows VMs)

## VMs

- [virt-manager](https://virt-manager.org) (any VM)

## System

- [greenboot](https://github.com/fedora-iot/greenboot) (rolls back an update that doesn't reach the login screen)
- [signed daily builds, `:stable` weekly](MAINTENANCE.md)
