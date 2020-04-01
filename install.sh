#!/bin/bash

# systemd
sudo timedatectl set-ntp true
sudo timedatectl set-timezone Asia/Shanghai

sudo systemctl enable sshd
sudo systemctl enable syslog-ng@default
sudo systemctl enable cronie
sudo systemctl enable postfix
sudo systemctl enable docker
sudo systemctl enable NetworkManager
sudo systemctl enable znc
sudo systemctl enable qbittorrent-nox@$USER
sudo systemctl enable rpcbind nfs-server
sudo systemctl enable nginx

# docker
docker run -p6801:80 -eARIA_SECRET=06ffa48448af4996b3da7c1df48f --name ariang -d --restart always remyj38/ariang:nginx16-alpine
docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /home/petrus/portainer_data:/data portainer/portainer
