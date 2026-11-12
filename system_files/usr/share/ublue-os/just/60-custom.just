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
