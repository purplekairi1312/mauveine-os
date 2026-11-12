# nekozame os recipes (bazzite imports this file)

# Set up audio: realtime priority, DAWs (bitwig, reaper, renoise, ardour, lmms) and plugins
[group('nekozame')]
nekozame-audio *DAWS:
    /usr/bin/nekozame-audio {{ DAWS }}

# Install Doom Emacs, or sync it if it's already there
[group('nekozame')]
nekozame-doom:
    /usr/bin/nekozame-doom

# Animated catshark wallpaper: big, small (default), none or stop
[group('nekozame')]
nekozame-wallpaper VARIANT="small":
    /usr/bin/nekozame-wallpaper {{ VARIANT }}

# Sunshine always on, over Tailscale: native, KMS capture, runs from boot
[group('nekozame')]
nekozame-sunshine:
    /usr/bin/nekozame-sunshine

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
