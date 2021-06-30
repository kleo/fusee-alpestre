#!/bin/bash -e

# Setup fusee-launcher
apk add --no-cache python3 py3-usb libusb-dev wget

mkdir -p /etc/fusee-launcher
wget https://github.com/Qyriad/fusee-launcher/archive/refs/tags/1.0.zip -O /etc/fusee-launcher/1.0.zip
unzip -j /etc/fusee-launcher/1.0.zip -d /etc/fusee-launcher/
rm -f /etc/fusee-launcher/1.0.zip

wget -P /etc/fusee-launcher $PAYLOAD_LATEST_URL

if compgen -G "/etc/fusee-launcher/hekate*.zip" > /dev/null; then
    unzip /etc/fusee-launcher/hekate*.zip -d /etc/fusee-launcher \
    && find /etc/fusee-launcher -name "hekate*.bin" -exec mv '{}' /etc/fusee-launcher/fusee.bin \;
elif compgen -G "/etc/fusee-launcher/fusee-primary.bin" > /dev/null; then
    find /etc/fusee-launcher -name "fusee-primary.bin" -exec mv '{}' /etc/fusee-launcher/fusee.bin \;
fi

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