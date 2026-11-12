#!/bin/bash
# greenboot: a boot only counts as good if the login screen comes up (greetd on
# the pc images, plasma's on the deck). three bad boots in a row and greenboot
# rolls back to the previous image by itself.
for _ in $(seq 120); do
    systemctl is-active --quiet display-manager.service && exit 0
    sleep 1
done
echo "the login screen didn't start" >&2
exit 1
