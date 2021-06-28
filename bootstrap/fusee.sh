#!/bin/sh 

set -xe

# Setup fusee-launcher
apk add --no-cache python3 py3-usb libusb-dev wget

mkdir -p /etc/fusee-launcher
wget https://github.com/Qyriad/fusee-launcher/archive/refs/tags/1.0.zip -O /etc/fusee-launcher/1.0.zip
unzip -j /etc/fusee-launcher/1.0.zip -d /etc/fusee-launcher/
rm -f /etc/fusee-launcher/1.0.zip

wget https://github.com/Atmosphere-NX/Atmosphere/releases/download/0.19.1/fusee-primary.bin -O /etc/fusee-launcher/fusee.bin

# Create fusee-launcher service
cat > /etc/init.d/fusee-launcher <<EOF
#!/sbin/openrc-run

name="fusee-launcher"
command=/etc/fusee-launcher/modchipd.sh
command_user="root"

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