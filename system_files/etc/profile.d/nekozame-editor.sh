# the editor: doom emacs by default, a client of the emacs daemon (always running,
# see emacs.service), so it opens instantly with your doom config and theme. a
# window on the desktop, inside the terminal otherwise; -a '' starts the daemon if
# it isn't up. ujust nekozame-editor picks another one (~/.config/nekozame/editor).
if [ -s "$HOME/.config/nekozame/editor" ]; then
    EDITOR="$(cat "$HOME/.config/nekozame/editor")"
    export EDITOR
elif [ -n "${WAYLAND_DISPLAY:-}${DISPLAY:-}" ]; then
    export EDITOR="emacsclient -c -a ''"
else
    export EDITOR="emacsclient -t -a ''"
fi
export VISUAL="$EDITOR"
