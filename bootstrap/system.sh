#!/bin/sh

set -xe

TARGET_HOSTNAME="raspberrypi"
TARGET_PASSWORD="raspberry"
TARGET_TIMEZONE="UTC"
TARGET_LOCALE="us-us"
LAYOUT=$(echo $LOCALE | cut -d'-' -f 1);
LAYOUT_SPEC=$(echo $LOCALE | cut -d'-' -f 2);

# base stuff
apk add --no-cache ca-certificates
update-ca-certificates

# password
echo "root:${TARGET_PASSWORD}" | chpasswd

# hostname
setup-hostname "${TARGET_HOSTNAME}"

# keymap
setup-keymap "${LAYOUT}" "${LAYOUT_SPEC}"

# time
apk add --no-cache chrony tzdata
setup-timezone -z "${TARGET_TIMEZONE}"
rc-update add swclock boot
rc-update add chronyd default

# message of the day
cat > /etc/motd <<EOF
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <http://wiki.alpinelinux.org>.

This is an unofficial image. Issues can be reported at 
https://github.com/dannybouwers/alpine-images/issues

You may change this message by editing /etc/motd.
EOF

# Setup fusee-launcher
apk add --no-cache axel python3 py3-usb libusb-dev

mkdir -p /etc/fusee-launcher
axel https://github.com/Qyriad/fusee-launcher/archive/refs/tags/1.0.zip --output=/etc/fusee-launcher/1.0.zip
unzip -j /etc/fusee-launcher/1.0.zip -d /etc/fusee-launcher/
rm -f /etc/fusee-launcher/1.0.zip

axel https://github.com/Atmosphere-NX/Atmosphere/releases/download/0.19.1/fusee-primary.bin --output=/etc/fusee-launcher/fusee.bin

# Create fusee-launcher service
cat > /etc/init.d/fusee-launcher <<EOF
#!/sbin/openrc-run

name="fusee-launcher"
command=/etc/fusee-launcher/modchipd.sh
command_user="root"

depend() {
        need net    
}

start_pre() {
        checkpath --directory --owner root:root --mode 0775 \
                /etc/fusee-launcher
}
EOF

chmod +x /etc/init.d/fusee-launcher

rm -f /etc/fusee-launcher/modchipd.sh

# Replace modchipd.sh
cat > /etc/fusee-launcher/modchipd.sh <<EOF
#!/usr/bin/env ash

while true; do
    /etc/fusee-launcher/fusee-launcher.py -w /etc/fusee-launcher/fusee.bin
done
EOF

chmod +x /etc/fusee-launcher/modchipd.sh