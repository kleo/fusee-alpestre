#!/bin/sh

set -xe

TARGET_HOSTNAME="raspberrypi"

cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback
  
hostname ${TARGET_HOSTNAME}  
EOF
