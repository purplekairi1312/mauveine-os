#!/bin/bash
# smoke tests, run at the end of every build: if the image is missing something,
# the build fails and nothing gets pushed to anyone.
set -uo pipefail
V="${VARIANT:-nvidia}"
fail=0
check() {  # check "what" 'command'
    if bash -c "$2" >/dev/null 2>&1; then echo "ok    $1"; else echo "FAIL  $1"; fail=1; fi
}

check "sunshine, with the screen capture right" 'getcap "$(readlink -f /usr/bin/sunshine)" | grep -q cap_sys_admin'
check "mpvpaper" 'command -v mpvpaper'
check "quickemu" 'command -v quickemu && command -v quickget'
check "qpwgraph" 'command -v qpwgraph'
check "wine" 'command -v wine'
check "realtime audio for everyone" 'test -f /etc/security/limits.d/95-nekozame-audio.conf'
check "first-login setup" 'test -x /usr/bin/nekozame-setup && test -f /etc/xdg/autostart/nekozame-setup.desktop && command -v gum'
check "emacs and cava themes" 'test -s /usr/share/nekozame-os/emacs/nekozame-theme.el && test -s /usr/share/nekozame-os/cava/config'
check "browser policies" 'jq -e ".policies.ExtensionSettings[\"uBlock0@raymondhill.net\"]" /usr/share/nekozame-os/zen/policies/policies.json && jq -e .WebRtcIPHandling /etc/chromium/policies/managed/nekozame.json'
check "emacs, ghostty, fuzzel, yazi" 'command -v emacs && command -v ghostty && command -v fuzzel && command -v yazi'
check "boot screen is the default" 'plymouth-set-default-theme | grep -qx nekozame'
check "boot screen is in the initramfs" 'lsinitrd /usr/lib/modules/*/initramfs.img | grep -q themes/nekozame/frames-16x9'
check "nekozame ujust recipes" 'just --justfile /usr/share/ublue-os/justfile --list | grep -q nekozame-sunshine'
check "theme files" 'test -s /usr/share/color-schemes/nekozame.colors && jq -e .primary /usr/share/nekozame-os/dms/nekozame.json'
check "wallpapers" 'test -s /usr/share/backgrounds/nekozame/small-16x9.mkv'
check "signed updates, every image" 'for i in nekozame-os nekozame-os-amd nekozame-os-deck; do jq -e ".transports.docker[\"ghcr.io/purplekairi1312/$i\"]" /etc/containers/policy.json || exit 1; done'
check "low latency audio" 'test -f /usr/share/pipewire/pipewire.conf.d/50-nekozame-lowlatency.conf'
check "greenboot login screen check" 'test -x /etc/greenboot/check/required.d/50-nekozame-login-screen.sh'
check "nekozame-fetch with its logos" 'test -x /usr/bin/nekozame-fetch && test -s /usr/share/nekozame-os/fastfetch/logo-tty.txt && test -s /usr/share/nekozame-os/fastfetch/logo.png'
check "nekozame terminal welcome" 'grep -q "nekozame" /usr/share/ublue-os/motd/template.md'
check "bazaar" 'rpm -q bazaar'
if [ "$V" = deck ]; then
    check "kde for desktop mode" 'rpm -q plasma-workspace'
    check "ujust nekozame-niri" 'grep -q "^nekozame-niri:" /usr/share/ublue-os/just/60-custom.just'
else
    check "niri, dms and its login screen" 'command -v niri && command -v dms && command -v dms-greeter'
    check "greetd is the login manager" 'systemctl is-enabled greetd.service'
    check "no kde" '! rpm -q plasma-workspace && ! rpm -q kwin && ! rpm -q plasma-login-manager'
    check "thunar" 'command -v thunar'
    check "virt-manager" 'command -v virt-manager'
    check "gnome portal for screen capture" 'rpm -q xdg-desktop-portal-gnome'
fi
[ "$fail" = 0 ] && echo "all good" || echo "some checks failed"
exit "$fail"
