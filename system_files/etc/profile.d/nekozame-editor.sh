# doom emacs is the editor: a client of the emacs daemon (always running, see
# emacs.service), so it opens instantly with your doom config and theme.
# a window on the desktop, inside the terminal otherwise; -a '' starts the
# daemon if it isn't up.
if [ -n "${WAYLAND_DISPLAY:-}${DISPLAY:-}" ]; then
    export EDITOR="emacsclient -c -a ''"
else
    export EDITOR="emacsclient -t -a ''"
fi
export VISUAL="$EDITOR"
