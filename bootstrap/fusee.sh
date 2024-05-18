#!/bin/bash -e

FUSEE_LAUNCHER_HASH=e4dee10256f1b84ac131899c10d5900a4c1821f63d19f0c4a0e5fd6f9022fb4c

# Setup fusee-launcher
apk add --no-cache python3 py3-usb libusb-dev wget

mkdir -p /etc/fusee-launcher
wget https://github.com/borntohonk/fusee-launcher/archive/refs/tags/1.0.zip -O /etc/fusee-launcher/1.0.zip

FUSEE_LAUNCHER_CALCULATED_HASH=$(sha256sum /etc/fusee-launcher/1.0.zip | awk '{print $1}')

if [ "$FUSEE_LAUNCHER_CALCULATED_HASH" == "$FUSEE_LAUNCHER_HASH" ]; then
    echo "Hashes match. File integrity verified."
    exit 0
else
    echo "Hashes do not match. File may be corrupted."
    exit 1
fi

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
