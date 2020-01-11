#!/bin/sh

set -xe

cat <<EOF >/etc/crontabs/pi
@reboot sleep 10 && docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --name portainer --restart always portainer/portainer
EOF
