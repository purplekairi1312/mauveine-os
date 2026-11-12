# cava in the nekozame colours, unless you have your own ~/.config/cava/config
if [ ! -e "${XDG_CONFIG_HOME:-$HOME/.config}/cava/config" ]; then
    alias cava='cava -p /usr/share/nekozame-os/cava/config'
fi
