#!/bin/sh

set -xe

cat <<EOF > /usr/bin/portainer
#!/bin/sh
docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
EOF

cat <<EOF > /etc/init.d/portainer
#!/sbin/openrc-run
command="/usr/bin/portainer"
command_background=false
depend() {
  after sshd
  need docker
}
EOF

chmod +x /etc/init.d/portainer /usr/bin/portainer
rc-update add portainer default