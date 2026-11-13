# nekozame os recipes (bazzite imports this file)

# Set up nekozame os for your user (opens by itself on the first login)
[group('nekozame')]
nekozame-setup:
    /usr/bin/nekozame-setup

# Audio latency: low (default), normal (for crackles) or status
[group('nekozame')]
nekozame-audio LATENCY="status":
    /usr/bin/nekozame-audio {{ LATENCY }}

# Music production: DAWs (Bitwig, Reaper, Renoise, Ardour, LMMS) and a checklist of plugins
[group('nekozame')]
nekozame-music:
    /usr/bin/nekozame-music

# Your editor: doom (default), neovim, helix, micro, nano or any command
[group('nekozame')]
nekozame-editor EDITOR="":
    /usr/bin/nekozame-editor {{ EDITOR }}

# Install Doom Emacs or sync it; --evil or --no-evil switches evil mode
[group('nekozame')]
nekozame-doom FLAG="":
    /usr/bin/nekozame-doom {{ FLAG }}

# Log in automatically at boot: on, off or status
[group('nekozame')]
nekozame-autologin ACTION="status":
    /usr/bin/nekozame-autologin {{ ACTION }}

# The nekozame look in Zen, Discord (Vencord) and Bitwig; again after Discord or Bitwig update
[group('nekozame')]
nekozame-apps-theme APPS="":
    /usr/bin/nekozame-apps-theme {{ APPS }}

# Animated catshark wallpaper, with the nekozame logo small (default), big or none (just the catshark); stop turns it off
[group('nekozame')]
nekozame-wallpaper VARIANT="small":
    /usr/bin/nekozame-wallpaper {{ VARIANT }}

# Sunshine always on, over Tailscale: native, KMS capture, runs from boot
[group('nekozame')]
nekozame-sunshine:
    /usr/bin/nekozame-sunshine

# The nekozame shortcuts: Super like Cmd (copy, paste...), Ctrl+Alt for windows
[group('nekozame')]
nekozame-keys:
    /usr/bin/nekozame-keys

# Install the Helium browser (optional), or update it
[group('nekozame')]
nekozame-helium:
    /usr/bin/nekozame-helium

# Virtualization: libvirt, virt-manager and vfio
[group('nekozame')]
nekozame-vm ACTION="": (setup-virtualization ACTION)

# Tailscale: status | enable | disable
[group('nekozame')]
nekozame-tailscale ACTION="": (tailscale ACTION)

# SSH: status | enable | disable | start
[group('nekozame')]
nekozame-ssh ACTION="": (ssh ACTION)

# Clean up old podman images, flatpaks and rpm-ostree content
[group('nekozame')]
nekozame-clean: clean-system

# Logs from this boot, or the last one (nekozame-logs last)
[group('nekozame')]
nekozame-logs BOOT="this":
    /usr/bin/ujust logs-{{ BOOT }}-boot

# Make a new distrobox
[group('nekozame')]
nekozame-distrobox IMAGE="prompt" NAME="prompt": (distrobox-new IMAGE NAME)

# Virtual audio channels (game, voice, browser, music) to split audio with qpwgraph
[group('nekozame')]
nekozame-virtual-audio ACTION="": (setup-virtual-channels ACTION)

# Install fonts from brew
[group('nekozame')]
nekozame-fonts: install-fonts

# Boot into the BIOS/UEFI setup
[group('nekozame')]
nekozame-bios: bios
