#!/usr/bin/env python3
"""hide bazzite's ujust recipes that don't fit nekozame os, or that nekozame os
wraps under its own names (60-custom.just). they stay runnable, just unlisted:
each gets a [private] attribute. a recipe that's gone only warns."""
import glob
import re
import sys

HIDE = """
add-updater-to-steam check-idle-power-draw configure-opengamepadui
disable-bios-updates disable-firmware-updates enable-deck-bios-firmware-updates
install-deckhd-bios disable-ryzenadj-max-performance enable-ryzenadj-max-performance
disable-sdgyrodsu get-decky-bazzite-buddy get-decky-lossless-scaling get-framegen
setup-decky restore-virtual-keyboard set-default-desktop set-default-game-mode
switch-to-ext4 toggle-gamemode restore-gamemode-shortcut steamos-automount
generate-inputplumber-ignorelist restore-input-remapper cec-mode cec-sleep
asus enable-framework-fan-control toggle-i915-sleep-fix configure-broadcom-wl
install-displaylink install-openrazer configure-amd-hdmi21
disable-framework-automount enable-framework-automount
restore-bazzite-breeze-gtk-theme bazzite-cli changelogs changelogs-testing
setup-sunshine
setup-virtualization tailscale ssh clean-system logs-this-boot logs-last-boot
distrobox-new setup-virtual-channels install-fonts bios
""".split()

root = sys.argv[1] if len(sys.argv) > 1 else "/usr/share/ublue-os/just"
found = set()
for path in sorted(glob.glob(f"{root}/*.just")):
    lines = open(path, encoding="utf-8").read().split("\n")
    out = []
    for line in lines:
        m = re.match(r"^@?([A-Za-z0-9_-]+)\b[^:]*:(?!=)", line)  # a recipe header, not :=
        if m and m.group(1) in HIDE and m.group(1) not in found:
            found.add(m.group(1))
            if not (out and out[-1].strip() == "[private]"):
                out.append("[private]")
        out.append(line)
    open(path, "w", encoding="utf-8").write("\n".join(out))
for name in sorted(set(HIDE) - found):
    print(f"warning: no ujust recipe named {name} to hide", file=sys.stderr)
print(f"hid {len(found)} ujust recipes")
