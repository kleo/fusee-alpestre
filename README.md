# Alpine Raspberry PI

This is a system install of Alpine linux for Raspberry Pi 2B, 3B, 3B+ and 4 image ready to burn to an SD card via [balenaEtcher](https://www.balena.io/etcher/) (there's no need to gunzip image).

If you prefer the command line, you can use `dd` and `gzip`:

```shell
gzip -dc /path/to/your/image.gz | sudo dd bs=4M of=/dev/sdX
````

The image automatically setup and configures:

* root user [pwd: raspberry]
* pi user [pwd: raspberry]
* ethernet
* wifi (edit `wpa_supplicant.conf` in the boot partition, on first boot it will be copied)
* bluetooth
* avahi
* swap
* openssh server
* root partition auto-expand on first boot
* docker
* portainer

## Why this project?
I wanted a board where all the software on it is containerized and easy to restore.

Also, with [Portainer](https://www.portainer.io/), I can keep the entire system under control with a web GUI.